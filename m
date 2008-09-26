Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:49530 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbYIZQvH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 12:51:07 -0400
Date: Fri, 26 Sep 2008 19:50:07 +0300
From: Jouni Malinen <j@w1.fi>
To: Iwo Mergler <iwo@call-direct.com.au>
Cc: rt2400-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
	hostap@lists.shmoo.com, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: hostapd - mac80211 - rt2x00 - rt73usb  AP mode bug
Message-ID: <20080926165007.GP4791@jm.kir.nu> (sfid-20080926_185113_941662_B54B793E)
References: <48C9CD51.1060107@call-direct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48C9CD51.1060107@call-direct.com.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(fixed linux-wireless address to get this to more appropriate people)

On Fri, Sep 12, 2008 at 12:00:49PM +1000, Iwo Mergler wrote:

> I'm trying to get to the bottom of a bug that stops me from using
> hostapd - mac80211 - rt2x00 - rt73usb as an access point.
> 
> Initially, I assumed a bug within the rt2x00 driver and added some
> tracing code to that. However, it now looks like the error is more
> likely within mac80211 or hostapd.

> I'm testing this on two systems, vmware-based x86 and ARM. The bug
> exists on both, but on the x86 the AP actually emits beacons, while
> on the ARM the system crashes on a bad spinlock.
> 
> The reason for the problem is the driver private data (vif), which
> doesn't get initialised, due to a missing call from mac80211.

This works with other drivers.. Not that that would automatically mean
that something wouldn't be wrong in mac80211 ;-). As far as I can tell,
hostapd does things the way it is supposed to and the main question
would be in the area of what mac80211 does with frames injected through
a monitor event.

I believe the current version is not calling driver add_interface for
monitor events by design. Whether this leaves some confusing information
for tx() handler is an open question, though, or well, at least I did
not go through the current code now to verify what exactly is happening
there.

There has been some discussion on the use of monitor interfaces for
injecting frames in the context of how management frame protection (IEEE
802.11w) should work with hostapd. The current design is not ideal and
mac80211 should really be converting the netdev from mon.wlan# to wlan#;
it just does not have enough information to do this if there may be more
than one virtual netdev for the radio.. One option that has been
discussed is to add a radiotap parameter to indicate the interface for
the injected frame. This way mac80211 should be able to map it to the
correct interface and the driver would not get into this sort of
situation where it gets a frame from an unexpected interface.

As far as the crash itself is concerned, this may be an issue in the
driver. Please note that net/mac80211.h explicitly notes that vif can be
NULL for injected frames (i.e., frame from monitor interface). rt2x00
seems to be doing some kind of mapping from vif to rt2x00_intf with
vif_to_intf() in rt2x00queue_create_tx_descriptor(). That function
handles the NULL case by not allocating a sequence number which itself
seems incorrect; all the virtual interfaces sharing the same STA/AP
interface should share the same sequence number space.

I don't have the debug code that produced the BUG shown in the output
below, so I'm not sure what exactly it was trying to do. However, it if
expect the vif to be always set, it will fail. The odd part here is that
the vif reported in the driver is not NULL; I would have expected that
to be the case.. Again, not having the debug code makes it difficult to
figure out what happened. If mac80211 is indeed setting struct
ieee80211_tx_info.control.vif to point to the monitor interface and not
NULL, that would likely be an issue in mac80211; otherwise, the driver
(and/or debug code) is likely to do something wrong with the vif
pointer.


I'll leave the following details in for whoever is reading
linux-wireless and may have missed the original message..

> The trace below was captured during hostapd startup. Sometimes there
> is a discrepancy of 4 bytes between the printed pointer values of a
> particular vif - it's still the same vif.
> 
> Here goes:
> 
> [T87]ieee80211_open:194: dev->name=mon.wlan0
> [T87]ieee80211_open:309: sdata->dev->name=mon.wlan0
> [T87]ieee80211_open:310: sdata->vif.type=5, &sdata->vif=c3b957b4
> [T87]ieee80211_open:316: IEEE80211_IF_TYPE_MNTR
> 
> Hostapd has opened the monitor interface. Because the type is
> IEEE80211_IF_TYPE_MNTR, the driver's add_interface method is
> not called. This leaves vif=c3b957b4 uninitialised.
> 
> 
> [T87]ieee80211_open:194: dev->name=wlan0
> [T87]ieee80211_open:309: sdata->dev->name=wlan0
> [T87]ieee80211_open:310: sdata->vif.type=1, &sdata->vif=c3a197b4
> [T87]ieee80211_open:345: Calling local->ops->add_interface()
> [T87]rt2x00mac_add_interface:211: vif=c3a197b4
> [T87]rt2x00mac_add_interface:307: Canary Check c3a197b8
> 
> Here, hostapd has opened wlan0 in AP mode (sdata->vif.type=1).
> This code path in ieee80211_open calls the add_interface method
> which ends up to be rt2x00mac_add_interface in our case. This
> initialises vif=c3a197b4. The 'canary' is a couple of known
> magic values I use to detect uninitialised vif data.
> 
> Next, hostapd attempts to send a packet to the monitor interface:
> 
> [T87]ieee80211_monitor_start_xmit:1397: skb=c2c0e710, vif=00000004
> [T87]ieee80211_master_start_xmit:1332: odev=c3b95000 (.name=mon.wlan0)
> [T87]ieee80211_master_start_xmit:1339: osdata=c3b95460, &osdata->vif=c3b957b4
> [T87]ieee80211_master_start_xmit:1378: skb=c2c0e710, vif=c3b957b8
> 
> ieee80211_master_start_xmit finds the correct vif=c3b957b8
> (which is not initialised) and calls the driver.
> 
> [T87]__ieee80211_tx:1063: skb=c2c0e710, vif=c3b957b8
> [T87]rt2x00mac_tx:117: skb=c2c0e710, vif=c3b957b8
> [T87]rt2x00queue_write_tx_frame:405: skb=c2c0e710, vif=c3b957b8
> [T87]rt2x00queue_create_tx_descriptor:171: enter (1)
> [T87]rt2x00queue_create_tx_descriptor:175: skb=c2c0e710, vif=c3b957b8
> [T87]rt2x00queue_create_tx_descriptor:178: Canary Check c3b957b8
> [T87]rt2x00queue_create_tx_descriptor:178: The canary died. canary1=00000000, canary2=00000000, lock=1
> kernel BUG at drivers/net/wireless/rt2x00/rt2x00queue.c:178!
> ...
> 
> The debugging code detected the uninitialised vif and called BUG().
> 
> ====
> 
> As far as I can see, there are two possible reasons for this.
> 
> 1) Hostapd shouldn't have sent packets out of the monitor interface.
> In that case, mac80211 should have thrown an error at hostapd.
> 
> 2) ieee80211_open should have called the add_interface method, even
> for monitor mode.
> 
> I asked Ivo van Doorn (the author of the rt2x00 drivers) about this,
> here is the reply:
> 
> Ivo van Doorn wrote:
> > 
> > Well sending through the monitor interface is fine, as long as the userspace agent
> > that does this sets the sequence number. There is no way rt2x00 can create correct
> > sequence numbers for multiple interfaces when it has to keep monitor interfaces into account.
> > 


-- 
Jouni Malinen                                            PGP id EFC895FA

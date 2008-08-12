Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:36680 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbYHLIXe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 04:23:34 -0400
Date: Tue, 12 Aug 2008 11:22:46 +0300
From: Jouni Malinen <j@w1.fi>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Pondering: how to improve mac80211 roaming ...
Message-ID: <20080812082246.GD4981@jm.kir.nu> (sfid-20080812_102338_764293_241BA402)
References: <200808120838.52888.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200808120838.52888.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 12, 2008 at 08:38:52AM +0200, Holger Schurig wrote:

> The last days I looked a bit at mac80211 and how it works. While
> doing this, I detected that mac80211 does virtually no roaming.

> It looks like that somebody (Jiri?) also detected this, because
> I found he following TODO in mlme.c:
> 
>     /* TODO: start monitoring current AP signal quality and number of
>      * missed beacons. Scan other channels every now and then and search
>      * for better APs. */

I think I actually wrote that long time ago.. The original design for
the client MLME code in kernel was to be minimal and just support fixed
location (i.e., just minimal roaming if the AP goes away for any
reason).

> How to detect missed beacons?
> -----------------------------
> When I know the beacon period, I could setup a timer
> with "beacon_period + beacon_period*0.5". In the timer function I
> could then increase a missed beacon counter and act accordingly,
> e.g. search for APs, roam etc.

Some (most?) wlan hardware designs allow this to be done in
firmware/hardware and that would likely be more efficient way of
determining missed beacons. In other words, the design here should take
into account the possibility of moving this functionality into the
driver and only optionally (if no hw support) set up this to be done
with host CPU and timers.

> But how would I determine the beacon period?

struct ieee80211_sta_bss::beacon_int

(in TUs, i.e., 1.024 ms)

> Is detection of missed beacons good enought?
> --------------------------------------------
> Certainly it's better to act before the accident happens, so I'd
> rather do it differently. With a fullmac driver I looked at the
> RSSI and, when it fell below a certain threshhold, started the
> roaming.

That is another feature that is available in many hw/firmware designs
even for softmac drivers (i.e., interrupt if current BSS signal strength
drops below a threshold value). This could tricker a background scan to
figure out whether there are better APs available at the moment.
Similarly, it would be useful to be able to trigger such background
scans periodically even without a specific signal strength trigger.

> In-kernel or in-userspace?   --- or hybrid?
> -------------------------------------------

> So I think I'd opt to a hybrid approach. Userspace uses cfg80211
> to configure some roaming threshold to mac80211. mac80211 would
> gain AP-is-about-to-fail detection and, if it detects this, it
> would signal via cfg80211 (is this possible?) to user-space that
> it should now roam.

I would also think that this is the most useful design. You could
already do background scanning in the kernel (triggered by whatever) and
just sen SIOCSIWSCAN WE event to notify user space (e.g.,
wpa_supplicant) of availability of new scan results. This is something
that madwifi for example is already doing.

As far as notification for current-signal-below-threshold event is
concerned, that would be a new notification and it would need to be
added somewhere. At this point, cfg80211/nl80211 does not provide new
event mechanism, i.e., the WE netlink messages are still used.

cfg80211 lacks a command for request new scans, so that could also be an
area that would benefit of improvements if the current SIOCSIWSCAN WE
ioctl does not provide all the functionality needed for this (though, it
may be more because of SIOCSIWSCAN handler in mac80211 lacking support
for many of the options).

> For a WEP or non-encrypted environment a in-kernel-roaming would
> be possible, this would bring a similar behavior to mac80211 that
> common fullmac drivers exhibit. But my first goal would not be in
> this area.

That should not be limited to just WEP or plaintext. If mac80211 reports
association even to a new BSS, wpa_supplicant should be able to complete
WPA/IEEE 802.1X handshake with the new AP after that.
 
-- 
Jouni Malinen                                            PGP id EFC895FA

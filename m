Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33646 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaESO35 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 10:29:57 -0400
Message-ID: <1400509775.4273.8.camel@jlt4.sipsolutions.net> (sfid-20140519_163001_496941_4CFA01FA)
Subject: Re: [RFC] mac80211: at76x50x_usb driver broken by commit 3afc216..
 and RX path involved in scan
From: Johannes Berg <johannes@sipsolutions.net>
To: andrea.merello@gmail.com
Cc: emmanuel.grumbach@intel.com,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	oku@masqmail.cx, joerg.albert@gmx.de, alex@foogod.com,
	n0_5p4m_p13453@hotmail.com, proski@gnu.org, agx@sigxcpu.org,
	kalle.valo@iki.fi, sesmo@gmx.net,
	John Linville <linville@tuxdriver.com>
Date: Mon, 19 May 2014 16:29:35 +0200
In-Reply-To: <CAN8YU5Nh-FwrBWuCz-YArmHg9NSLqsS2aan_6edaVDg+i6018g@mail.gmail.com> (sfid-20140517_174307_788362_95E52488)
References: <CAN8YU5Nh-FwrBWuCz-YArmHg9NSLqsS2aan_6edaVDg+i6018g@mail.gmail.com>
	 (sfid-20140517_174307_788362_95E52488)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all (big cc list...),

> It happened that since Emmanuel's commit
> 3afc2167f60a327a2c1e1e2600ef209a3c2b75b7 (cfg80211/mac80211: ignore
> signal if the frame was heard on wrong channel) my atmel-based wifi
> device couldn't scan anymore.

That driver is a pain! :-)

> The problem is triggered because the at76x50x-usb driver does not
> provide frequency information in rx_status (and AFAIK it difficultly
> could do that during scan right now).

Why is that difficult? Ok actually, looking at the driver, I see. It has
HW scan but nothing indicating the channel.

> So my first question is:
> Are mac80211 drivers obligated to report this information?
> Does this commit just rely on something that should be already in that
> way (and the at7950x-usb driver is simply buggy not doing this)?
> Reading Emmanuel's commit message it seems he didn't have any
> intention to introduce this constraint now.

Yeah, every other driver is always unconditionally setting the channel,
so this is very surprising.

> Said that, I dig in mac80211 code, and I saw Emmanuel commit does
> affect frames processed in sta (and ibss, but i didn't look at this)
> rx path.
> 
> Summarizing it a bit, the call path should be:
>  __ieee80211_rx_handle_packet()
> ieee80211_invoke_rx_handlers()
> ieee80211_rx_h_mgmt()
> -- work queue --
> ieee80211_iface_work()
> ieee80211_sta_rx_queued_mgmt()
> ieee80211_rx_bss_info() - patched to get channel from driver's rx_status.
> And finally
> ieee80211_bss_info_update()
> 
> is this right?
> 
> What is surprising for me is that
>  __ieee80211_rx_handle_packet()
> contains a shorter path for updating BSS information by
> ieee80211_scan_rx() that directly calls
> ieee80211_bss_info_update()
> 
> The interesting thing is that ieee80211_scan_rx was already written in
> the way Emmanuel's patched ieee80211_rx_bss_info(): It get channel
> info from rx_status.

Right - this is the real scan path. The other one is a bit of a
confusing path, I've kinda wanted to get rid of the former one but there
are some corner cases with that as far as I remember. Maybe with careful
analysis we can get rid of it.

> This suggests that the at79c50x-usb driver, prior to Emmanuel's
> commit, was able to scan by getting mgmt frames processed by the
> former, longer, RX path, and that the ieee80211_scan_rx() path was
> never really used.

And had I removed the former path that would have broken the driver :)

> If this is correct, my question is:
> Isn't this a redundant path duplication (provided that drivers
> supplies channel information)?

Yes.

> Finally my latest question is:
> Emmanuel's patch makes cfg80211_inform_bss_width_frame() compare the
> RX channel and the actual BSS channel (known from beacon/probe
> response), and it does this by comparing the two pointers.
> 
> Are we guaranteed that only one instance of every channel object does
> exists ? isn't it safer to compare the frequency field value?

This is perfectly fine (though Emmanuel's response that we do it
elsewhere is kinda useless - that might still be a bug :) ) since
there's only one set of channel pointers for each hardware. Those point
to the array entries in (for this driver) at76_channels[].


Since there's no "rx channel" information in this driver, but there does
seem to be a (currently unused) channel field in the scan request, maybe
we can make the driver request up to 14 single-channel scans (rather
than a single full scan), and then it can keep track of the current
channel in software and assign the pointer properly.

This would also allow implementing regulatory for scan properly, which
seems like a good idea as well.

johannes


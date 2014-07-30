Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:54909 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbaG3LIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2014 07:08:38 -0400
Date: Wed, 30 Jul 2014 13:08:30 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Nate Carlson <linux-wireless@natecarlson.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Borislav Boev <borislavboev@hotmail.com>, ilw@linux.intel.com
Subject: Re: Poor wifi performance on Intel 7260 Dual-Band AC Wifi card
Message-ID: <20140730110829.GA3563@sig21.net> (sfid-20140730_130842_610738_548062D5)
References: <BAY178-W38CA42DFDD4031D453FB48CFF80@phx.gbl>
 <53D7AEF5.5040907@lwfinger.net>
 <alpine.DEB.2.02.1407290946100.1431@admin.chi.technicality.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.02.1407290946100.1431@admin.chi.technicality.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2014 at 09:56:46AM -0500, Nate Carlson wrote:
> On Tue, 29 Jul 2014, Larry Finger wrote:
> >You should try the experimental firmware file from
> >https://git.kernel.org/cgit/linux/kernel/git/egrumbach/linux-firmware.git/plain/iwlwifi-7260-9.ucode?h=Core6.
> >
> >I am currently testing it and getting throughput of 60 Mbps on the 2.4 GHz band,
> >and 90 Mbps at 5 GHz.

I'm getting 1...5 Mbs with 7260 AC (Thinkpad Yoga) in 2.4 GHz band
in the office (11n AP), more decent speed at home.
I'm about 5m away from the AP.  A tiny Ralink rt2800usb dongle in the
same machine gives solid performance (40...60 Mbs).

The experimental firmware didn't make a difference for me, except
it seems to fix /sys/kernel/debug/ieee80211/phy0/iwlwifi/iwlmvm/fw_rx_stats
(previously all values were 0, but I don't know how to interpret them).


> For what it's worth - on both this experimental firmware and previous
> revisions, I can do > 200Mbps to the public internet (on my office internet
> connection), with 13 other users currently on the same AP as me (the APs are
> Cisco 3702i's managed by a Cisco 2504.) This is (obviously) on the 5ghz
> band, with VHT enabled. I've had issues with occasional 'dropouts' with this
> card, where traffic will randomly stop passing and/or ping times will jump
> to > 10s; sometimes it clears up on its own, somethings I have to
> re-associate to the AP to get it to stop. I'm hoping the new firmware and/or
> the newest Cisco WLC build fixes it; testing now.
> 
> Borislav - you didn't mention what firmware revision you are running; if you
> aren't on one of the -9 builds, I'd highly recommend moving to it.
> 
> I do have the following set in
> /etc/modprobe.d/iwlwifi-disable-powersave.conf:
> "options iwlwifi power_save=0 bt_coex_active=0"

I also tried iwlmvm option power_scheme=1 (Continuously Active Mode),
11n_disable=1, and "iw dev wlan0 set power_save off".  It stays slow,
and typing in ssh is still somewhat laggy.

> Once I move to 3.16, I'll probably try turning both of those features back
> on, and see what happens.
> 
> Here's a speedtest result; I've gotten better, but this is representative of
> my average speeds:
> http://www.speedtest.net/my-result/3655207245
> 
> In any case - this card _is_ capable of decent speeds for sure!

The question is how to go about testing.  ISTR the Windows 8 driver
didn't have any issue and gave decent speed, but I don't have the
time to restore the Windows image for testing now.  If Windows
and Linux use the same firmware I guess a comparison would
reveal if it's a driver of firmware issue.

Otherwise I'm hoping Intel guys could provide some guidance for
testing so we could find the root cause.


Johannes

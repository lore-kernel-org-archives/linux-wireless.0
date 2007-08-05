Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:34267
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbXHEOng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2007 10:43:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH V2] bcm43xx-mac80211: Rescale link quality output
Date: Sun, 5 Aug 2007 16:43:30 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46b57c5f.7s2ojiPQUXY5R3Qv%Larry.Finger@lwfinger.net> <200708051457.11970.mb@bu3sch.de> <46B5DFAC.9090600@lwfinger.net>
In-Reply-To: <46B5DFAC.9090600@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708051643.30569.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 05 August 2007, Larry Finger wrote:
> Michael Buesch wrote:
> > On Sunday 05 August 2007, Larry Finger wrote:
> >> The link quality output from wireless extensions is too small by the ratio
> >> of 100/BCM43xx_RX_MAX_SSI (60) for bcm43xx-mac80211. This patch puts the
> >> quantity on the proper scale.
> >>
> >> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> >> ---
> >>
> >> Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_xmit.c
> >> ===================================================================
> >> --- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_xmit.c
> >> +++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_xmit.c
> >> @@ -537,7 +537,8 @@ void bcm43xx_rx(struct bcm43xx_wldev *de
> >>  					      (phystat0 & BCM43xx_RX_PHYST0_GAINCTL),
> >>  					      (phystat3 & BCM43xx_RX_PHYST3_TRSTATE));
> >>  	status.noise = dev->stats.link_noise;
> >> -	status.signal = jssi; /* this looks wrong, but is what mac80211 wants */
> >> +	/* the next line looks wrong, but is what mac80211 wants */
> >> +	status.signal = (jssi * 100) / BCM43xx_RX_MAX_SSI;
> > 
> > So signal is in percent?
> > Where is this actually documented. I cannot find a hint on what
> > the values of all these things are supposed to be.
> 
> Yes, it is clear as mud, with the additional complications of mac80211 mixing the definitions of 
> signal and rssi (as far as I'm concerned). The scale is set by the following code snippet in 
> bcm43xx_wireless_init.
> 
>          hw->max_signal = 100;
>          hw->max_rssi = -110;
>          hw->max_noise = -110;
> 
> In this code, "signal" is put on a scale of 0 to 100, and rssi and noise on a scale of -110 to 0 and 
> are assumed to be dBm. Of course, rssi should be a positive number and signal should be in dBm, but 
> my renaming of signal => quality and rssi => signal was shot down, so we are stuck.
> 
> An alternative to the patch above would be to set hw->max_signal = BCM43xx_RX_MAX_SSI. In that case, 
> the line of iwconfig output that reads "Link Quality=83/100  Signal level=-34 dBm  Noise level=-71 
> dBm" would have a "Link Quality" of 50/60 instead of 83/100.
> 
> The bottom line is that it is an arbitrary quantity on an arbitrary scale. Is it better for it to be 
>   XX/100 than YY/60? I think so, but YMMV.

Ah, I see. Kind of confusing. :)

Well, I would like to do
hw->max_signal = MAX_RSSI
but it seems to be an unwritten rule that signal scales to 100.
At least I never saw a different scale in a driver, yet.
So I think I will apply your patch.
Thanks!


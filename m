Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42061 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055Ab2EYUpF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 16:45:05 -0400
Date: Fri, 25 May 2012 15:44:59 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: BCM4331 tx failures after S3
Message-ID: <20120525204459.GE2895@thinkpad-t410> (sfid-20120525_224510_809432_F4D657DA)
References: <20120522165251.GA31347@thinkpad-t410>
 <4FBCAE3E.6050206@broadcom.com>
 <20120523135506.GB30165@thinkpad-t410>
 <4FBE0110.5020209@broadcom.com>
 <20120524212115.GD26760@thinkpad-t410>
 <4FBEA96D.8030207@hauke-m.de>
 <20120525141339.GB2895@thinkpad-t410>
 <4FBFB79F.4060609@broadcom.com>
 <20120525183451.GD2895@thinkpad-t410>
 <4FBFE95F.2080306@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FBFE95F.2080306@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 25, 2012 at 10:19:43PM +0200, Arend van Spriel wrote:
> >> Well let me explain some behaviour. Upon suspend mac80211 takes down the
> >> driver with the last callback being .stop(). Upon resume mac80211 calls
> >> the driver with .start() callback.
> >>
> >> The brcmsmac driver has two bool states that are in play here: driver_up
> >> and hw_up. Upon .stop() callback the driver_up is set to false, but
> >> hw_up remains true. A subsequent .start() will perform some
> >> reconfiguration and driver_up will be made true.
> >>
> >> The suspend/resume scenario is different for brcmsmac. bcma will call
> >> brcmsmac .suspend() callback in which we set hw_up to false. This
> >> changes the behaviour of the .start() callback after resume. Basically,
> >> it reinitializes the hardware.
> > 
> > I'm having a bit of a hard time understanding the relevance of your
> > description, since we're talking about b43. Are you suggesting that b43
> > should do something similar? But even then I don't see any of the
> > reinitialization done by brcmsmac setting BCMA_CC_CHIPCTL with the
> > needed value. Am I missing something?
> > 
> > Seth
> > 
> 
> Yes, that is my suggestion. I dived into the b43 driver, but I do not
> see a .resume callback for bcma:
> 
> static struct bcma_driver b43_bcma_driver = {
> 	.name		= KBUILD_MODNAME,
> 	.id_table	= b43_bcma_tbl,
> 	.probe		= b43_bcma_probe,
> 	.remove		= b43_bcma_remove,
> };
> 
> So upon suspend/resume b43 seems to take no extra steps, but I may be
> missing it as I am not a b43 specialist (let me CC the b43 developer
> list :-) ).

I don't think your missing it. There doesn't seem to be a resume handler
in b43.

> In brcmsmac the brcms_b_hw_up() is called in brcms_c_up() when the flag
> hw_up is false:
> 
> int brcms_c_up(struct brcms_c_info *wlc)
> {
> 	if (!wlc->pub->hw_up) {
> 		brcms_b_hw_up(wlc->hw);
> 		wlc->pub->hw_up = true;
> 	}
> 
> /* Initialize just the hardware when coming out of POR or S3/S5 system
> states */
> static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
> 
> You are right that this particular code does not fiddle with
> BCMA_CC_CHIPCTL. Where in the code did you print the value of this
> register? Before or after the mac80211 .start() callback has been called?

Before. I printed the value from bcma_host_pci_resume().

I can easily make a patch that fixes the chipctl register up as needed
during resume to fix my problem. But based on the fact that other fields
in the register are also changing value, I'm wondering if more thorough
handling is needed for the register. And I'm also a little fuzzy on
exactly who should be responsible for what in the relationship between
b43 and the wireless drivers.

Thanks,
Seth


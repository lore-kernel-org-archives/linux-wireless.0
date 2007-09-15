Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:53733
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbXIOWGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Sep 2007 18:06:46 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH V2] b43legacy: Fix machine check errors for PPC architecture with BCM4306/2
Date: Sun, 16 Sep 2007 00:04:27 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <46ec4d0c.PU+VRueOH3Peh6s5%Larry.Finger@lwfinger.net>
In-Reply-To: <46ec4d0c.PU+VRueOH3Peh6s5%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709160004.28018.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 15 September 2007 23:22:20 Larry Finger wrote:
> In b43legacy, the variable gmode is always set. With a BCM4306/2,
> and likely a BCM4301, a variable is needed to control the execution
> path through the PHY and radio initialization, otherwise there are
> attempts to read from invalid registers. On x86 platforms, these
> read failures cause no problems; however they lead to machine check
> errors for the ppc architecture. This patch reverts to the variable
> and semantics used in the V3 specifications. It has been tested on
> an i386 platform using special code to detect these invalid reads,
> and on at least one Powerbook.
>  
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

> Index: wireless-dev/drivers/net/wireless/b43legacy/b43legacy.h
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/b43legacy/b43legacy.h
> +++ wireless-dev/drivers/net/wireless/b43legacy/b43legacy.h
> @@ -389,10 +389,10 @@ struct b43legacy_lopair {
>  struct b43legacy_phy {
>  	/* Possible PHYMODEs on this PHY */
>  	u8 possible_phymodes;
> -	/* GMODE bit enabled? */
> -	bool gmode;
> +	/* true if PHY registers can be accessed */
> +	bool connected;

I am completely against re-adding the old broken "connected" semantics.
IMO, this is a step backwards. I was happy to finally get rid of
this, as it caused me a lot of headaches.

>  	/* Possible ieee80211 subsystem hwmodes for this PHY.
> -	 * Which mode is selected, depends on thr GMODE enabled bit */
> +	 * This will be either G or B mode */
>  #define B43legacy_MAX_PHYHWMODES	2
>  	struct ieee80211_hw_mode hwmodes[B43legacy_MAX_PHYHWMODES];

Not sure why you change the comment here this way.
If you remove the "gmode" capability, you also limit
the number of hwmodes to one. So no array is needed here anymore.

But in the end, you are the maintainer, so you decide.
I personally would not re-add proven wrong stuff back to my driver.

-- 
Greetings Michael.

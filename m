Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47117
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbXIPJDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 05:03:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH V3] b43legacy: Fix machine check errors for PPC architecture with BCM4306/2
Date: Sun, 16 Sep 2007 11:00:51 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <46ec7e3b.fvdyZ6cbJm24I7PA%Larry.Finger@lwfinger.net>
In-Reply-To: <46ec7e3b.fvdyZ6cbJm24I7PA%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709161100.51955.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 16 September 2007 02:52:11 Larry Finger wrote:
> In b43legacy, the variable gmode is always set. With a BCM4306/2,
> a variable is needed to control the execution path through the PHY
> and radio initialization, otherwise there are attempts to read from
> invalid registers. On x86 platforms, these read failures cause no
> problems; however they lead to machine check errors for the ppc
> architecture. This problem is fixed by making the variable gmode mimic
> the state of the GMODE bit of MACCTL. This patch has been tested on an
> i386 platform using special code to detect these invalid reads, and on
> at least one Powerbook.
>  
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This patch fixes a problem with the Fedora Rawhide kernel reported by David
> Woodhouse on the bcm43xx mailing list and by Will Woods at 
> https://bugzilla.redhat.com/show_bug.cgi?id=233011. 
> 
> Larry
> 
>  drivers/net/wireless/b43legacy/b43legacy.h |    2 +-
>  drivers/net/wireless/b43legacy/main.c      |    5 ++++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> Index: wireless-dev/drivers/net/wireless/b43legacy/main.c
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/b43legacy/main.c
> +++ wireless-dev/drivers/net/wireless/b43legacy/main.c
> @@ -738,8 +738,11 @@ void b43legacy_wireless_core_reset(struc
>  
>  	macctl = b43legacy_read32(dev, B43legacy_MMIO_MACCTL);
>  	macctl &= ~B43legacy_MACCTL_GMODE;
> -	if (flags & B43legacy_TMSLOW_GMODE)
> +	if (flags & B43legacy_TMSLOW_GMODE) {
>  		macctl |= B43legacy_MACCTL_GMODE;
> +		dev->phy.gmode = 1;
> +	} else
> +		dev->phy.gmode = 0;
>  	macctl |= B43legacy_MACCTL_IHR_ENABLED;
>  	b43legacy_write32(dev, B43legacy_MMIO_MACCTL, macctl);
>  }
> Index: wireless-dev/drivers/net/wireless/b43legacy/b43legacy.h
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/b43legacy/b43legacy.h
> +++ wireless-dev/drivers/net/wireless/b43legacy/b43legacy.h
> @@ -389,7 +389,7 @@ struct b43legacy_lopair {
>  struct b43legacy_phy {
>  	/* Possible PHYMODEs on this PHY */
>  	u8 possible_phymodes;
> -	/* GMODE bit enabled? */
> +	/* GMODE bit enabled in MACCTL? */
>  	bool gmode;
>  	/* Possible ieee80211 subsystem hwmodes for this PHY.
>  	 * Which mode is selected, depends on thr GMODE enabled bit */

ACK

-- 
Greetings Michael.

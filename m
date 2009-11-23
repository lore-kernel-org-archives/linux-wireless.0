Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47972 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573AbZKWUBe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 15:01:34 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC] b43: Fix regression from Bug #14538
Date: Mon, 23 Nov 2009 21:01:34 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, casteyde.christian@free.fr
References: <4b0ae89a.w9I5fcNpeuH/GfsI%Larry.Finger@lwfinger.net>
In-Reply-To: <4b0ae89a.w9I5fcNpeuH/GfsI%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911232101.35933.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 November 2009 20:55:06 Larry Finger wrote:
> The routine b43_is_hw_radio_enabled() has long been a problem.
> For PPC architecture with PHY Revision < 3, a read of the register
> B43_MMIO_HWENABLED_LO will cause a CPU fault unless b43_status()
> returns a value of 2 (B43_STAT_STARTED) (BUG 14181). Fixing that
> results in Bug 14538 in which the driver is unable to reassociate
> after resuming from hibernation because b43_status() returns 0.
> 
> The correct fix would be to determine why the status is 0; however,
> I have not yet found why that happens. The correct value is found for
> my device, which has PHY revision >= 3.
> 
> Returning TRUE when the PHY revision < 3 and b43_status() returns 0 fixes
> the regression for 2.6.32.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Tested-by: Christian Casteyde <casteyde.christian@free.fr>
> ---
> 
> Index: wireless-testing/drivers/net/wireless/b43/rfkill.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/rfkill.c
> +++ wireless-testing/drivers/net/wireless/b43/rfkill.c
> @@ -33,9 +33,16 @@ bool b43_is_hw_radio_enabled(struct b43_
>  		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
>  			return 1;
>  	} else {
> -		if (b43_status(dev) >= B43_STAT_STARTED &&
> -		    b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
> -		    & B43_MMIO_RADIO_HWENABLED_LO_MASK)
> +		/* To prevent CPU fault on PPC, do not read a register
> +		 * unless the interface is started; however, on resume
> +		 * for hibernation, this routine is entered early. When
> +		 * that happens, unconditionally return TRUE.
> +		 */
> +		if (b43_status(dev) >= B43_STAT_STARTED) {
> +			if (b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
> +			    & B43_MMIO_RADIO_HWENABLED_LO_MASK)
> +				return 1;
> +		} else
>  			return 1;
>  	}
>  	return 0;

looks OK as quick workaround.

-- 
Greetings, Michael.

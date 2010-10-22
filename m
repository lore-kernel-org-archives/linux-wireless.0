Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63883 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab0JVVh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 17:37:57 -0400
Received: by ywk9 with SMTP id 9so1096885ywk.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 14:37:56 -0700 (PDT)
Message-ID: <4CC2043D.2040909@lwfinger.net>
Date: Fri, 22 Oct 2010 16:38:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: rfkill: use status register based on core revision
 not (PHY's)
References: <1287779045-20257-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1287779045-20257-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/22/2010 03:24 PM, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This makes my N-PHY radio at least running (no scanning results so far). The
> same register is used by wl on this device.
> ---
>  drivers/net/wireless/b43/rfkill.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
> index 78016ae..d2734c9 100644
> --- a/drivers/net/wireless/b43/rfkill.c
> +++ b/drivers/net/wireless/b43/rfkill.c
> @@ -28,7 +28,7 @@
>  /* Returns TRUE, if the radio is enabled in hardware. */
>  bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
>  {
> -	if (dev->phy.rev >= 3 || dev->phy.type == B43_PHYTYPE_LP) {
> +	if (dev->dev->id.revision >= 3) {
>  		if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
>  		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
>  			return 

As that register is present only when the core revision >= 3, this change should
not cause a regression. Perhaps this was an error in the RE from the start and
testing the phy.rev has always been wrong.

John: Just in case my analysis is wrong, keep this change out of 2.6.37. I'll
give it some testing with G PHYs before 2.6.38 merge time.

Larry

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38566 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab1JMO2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 10:28:11 -0400
Subject: Re: [PATCH] brcm80211: rename CONFIG_BRCMUMAC to CONFIG_BRCMUTIL
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: arend@broadcom.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1318515949-9558-1-git-send-email-hauke@hauke-m.de> (sfid-20111013_162620_528734_10EF53D2)
References: <1318515949-9558-1-git-send-email-hauke@hauke-m.de>
	 (sfid-20111013_162620_528734_10EF53D2)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 16:28:04 +0200
Message-ID: <1318516084.5612.18.camel@jlt3.sipsolutions.net> (sfid-20111013_162814_475635_4D78407F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-13 at 16:25 +0200, Hauke Mehrtens wrote:
> There is no config option named CONFIG_BRCMUMAC this should be
> CONFIG_BRCMUTIL as this is missing here.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
> index 0a304b0..812a050 100644
> --- a/drivers/net/wireless/Makefile
> +++ b/drivers/net/wireless/Makefile
> @@ -59,5 +59,5 @@ obj-$(CONFIG_IWM)	+= iwmc3200wifi/
>  
>  obj-$(CONFIG_MWIFIEX)	+= mwifiex/
>  obj-$(CONFIG_BRCMFMAC) += brcm80211/
> -obj-$(CONFIG_BRCMUMAC) += brcm80211/
> +obj-$(CONFIG_BRCMUTIL) += brcm80211/
>  obj-$(CONFIG_BRCMSMAC) += brcm80211/

Shouldn't it just go away since BRCMUTIL depends on SMAC||FMAC and is
otherwise unreachable?

johannes


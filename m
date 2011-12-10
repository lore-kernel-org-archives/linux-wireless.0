Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46311 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1LJVEy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 16:04:54 -0500
Message-ID: <4EE3C96B.4070102@hauke-m.de> (sfid-20111210_220457_302739_04D6D07D)
Date: Sat, 10 Dec 2011 22:04:43 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Franky Lin <frankyl@broadcom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 18/23] brcm80211: smac: use bcma functions for register
 access in phy code
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com> <1323385619-7454-19-git-send-email-frankyl@broadcom.com>
In-Reply-To: <1323385619-7454-19-git-send-email-frankyl@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2011 12:06 AM, Franky Lin wrote:
> From: Arend van Spriel <arend@broadcom.com>
> 
> This adds the use of bcma functions to access the registers within
> the phy source code.
> 
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Alwin Beukers <alwin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Franky Lin <frankyl@broadcom.com>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/main.c     |    2 +-
>  .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |  183 +++++++++-----------
>  .../net/wireless/brcm80211/brcmsmac/phy/phy_hal.h  |    2 +-
>  .../net/wireless/brcm80211/brcmsmac/phy/phy_int.h  |    4 +-
>  .../net/wireless/brcm80211/brcmsmac/phy/phy_lcn.c  |   69 ++++----
>  .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |   75 ++++----
>  drivers/net/wireless/brcm80211/brcmsmac/types.h    |    3 +
>  7 files changed, 162 insertions(+), 176 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index 43172b3..5db2bdc 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
....
>  
>  void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
>  {
> -	struct d11regs __iomem *regs;
> -
> -	regs = pi->regs;
> -
>  #ifdef CONFIG_BCM47XX
> -	W_REG_FLUSH(&regs->phyregaddr, addr);
> -	W_REG(&regs->phyregdata, val);
> +	bcma_wflush16(pi->d11core, D11REGOFFS(phyregaddr), addr);
> +	bcma_write16(pi->d11core, D11REGOFFS(phyregdata), val);
>  	if (addr == 0x72)
> -		(void)R_REG(&regs->phyregdata);
> +		(void)bcma_read16(pi->d11core, D11REGOFFS(phyregdata), val);
                                                                     ^^^
This does not compile with CONFIG_BCM47XX set.
>  #else
> -	W_REG((u32 __iomem *)(&regs->phyregaddr), addr | (val << 16));
> +	bcma_write32(pi->d11core, D11REGOFFS(phyregaddr), addr | (val << 16));
>  	if (++pi->phy_wreg >= pi->phy_wreg_limit) {
>  		pi->phy_wreg = 0;
> -		(void)R_REG(&regs->phyversion);
> +		(void)bcma_read16(pi->d11core, D11REGOFFS(phyversion));
>  	}
>  #endif
>  }
>  
...

Hauke

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42162 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab1LMUAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 15:00:24 -0500
Date: Tue, 13 Dec 2011 14:59:39 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Franky Lin <frankyl@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 15/15] brcm80211: smac: fix compilation issue with
 CONFIG_BCM47XX set
Message-ID: <20111213195939.GA2613@tuxdriver.com> (sfid-20111213_210027_843949_643A6E8C)
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
 <1323731713-14942-16-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1323731713-14942-16-git-send-email-frankyl@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To preserve bisectability (just in case!), I'm folding this into the
original patch.

John

On Mon, Dec 12, 2011 at 03:15:13PM -0800, Franky Lin wrote:
> From: Arend van Spriel <arend@broadcom.com>
> 
> With the BCMA support patches a compilation issue was introduced
> with CONFIG_BCM47XX set. This patch fixes that issue.
> 
> Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Alwin Beukers <alwin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Franky Lin <frankyl@broadcom.com>
> ---
>  .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
> index 687aafa..d2c7fb1 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
> @@ -292,7 +292,7 @@ void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
>  	bcma_wflush16(pi->d11core, D11REGOFFS(phyregaddr), addr);
>  	bcma_write16(pi->d11core, D11REGOFFS(phyregdata), val);
>  	if (addr == 0x72)
> -		(void)bcma_read16(pi->d11core, D11REGOFFS(phyregdata), val);
> +		(void)bcma_read16(pi->d11core, D11REGOFFS(phyregdata));
>  #else
>  	bcma_write32(pi->d11core, D11REGOFFS(phyregaddr), addr | (val << 16));
>  	if (++pi->phy_wreg >= pi->phy_wreg_limit) {
> -- 
> 1.7.5.4
> 
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4943 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab2FFLn2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 07:43:28 -0400
Message-ID: <4FCF4250.7080904@broadcom.com> (sfid-20120606_134331_472182_6ECC41F7)
Date: Wed, 6 Jun 2012 13:43:12 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 18/18] brcmsmac: handle non PCI devices in the phy
 code
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
 <1338937641-8519-19-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1338937641-8519-19-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
> --- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
> @@ -209,9 +211,11 @@ void write_radio_reg(struct brcms_phy *pi, u16 addr, u16 val)
>  		bcma_write16(pi->d11core, D11REGOFFS(phy4wdatalo), val);
>  	}
>  
> -	if (++pi->phy_wreg >= pi->phy_wreg_limit) {
> -		(void)bcma_read32(pi->d11core, D11REGOFFS(maccontrol));
> -		pi->phy_wreg = 0;
> +	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI) {
> +		if (++pi->phy_wreg >= pi->phy_wreg_limit) {
> +			(void)bcma_read32(pi->d11core, D11REGOFFS(maccontrol));
> +			pi->phy_wreg = 0;
> +		}
>  	}

You can loose the outer curly braces or combine into one if statement.
Same for the other code fragment in this patch.

Gr. AvS


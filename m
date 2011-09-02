Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:40977 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752945Ab1IBPtZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 11:49:25 -0400
Subject: Re: [PATCH 12/12] staging: brcm80211: cleaned up softmac srom macro
From: Joe Perches <joe@perches.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1314972039-27098-13-git-send-email-rvossen@broadcom.com>
References: <1314972039-27098-1-git-send-email-rvossen@broadcom.com>
	 <1314972039-27098-13-git-send-email-rvossen@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Sep 2011 08:49:23 -0700
Message-ID: <1314978563.1773.13.camel@Joe-Laptop> (sfid-20110902_174928_488715_1A7F1E06)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-02 at 16:00 +0200, Roland Vossen wrote:
> Substituted macro.
[]
> diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
[]
> @@ -792,6 +780,14 @@ static const struct brcms_sromvar perpath_pci_sromvars[] = {
>  
>  static u8 srom_crc8_table[CRC8_TABLE_SIZE];
>  
> +static u8 *srom_window_address(struct si_pub *sih, void *curmap)
> +{
> +	return sih->ccrev > 31 ?
> +	       (((sih->cccaps & CC_CAP_SROM) == 0) ? NULL :
> +	       ((u8 *)curmap + PCI_16KB0_CCREGS_OFFSET + CC_SROM_OTP)) :
> +	       ((u8 *)curmap + PCI_BAR0_SPROM_OFFSET);
> +}

Please try to make code more readable when
converting to functions too.

Maybe:

static u16 *srom_window_address(struct si_pub *sih, u8 *curmap)
{
	if (sih->ccrev < 32)
		return (u16 *)(curmap + PCI_BAR0_SPROM_OFFSET);
	if (sih->cccaps & CC_CAP_SROM)
		return (u16 *)(curmap + PCI_16KB0_CCREGS_OFFSET + CC_SROM_OTP);

	return NULL;
}
> @@ -1147,7 +1143,7 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
>  	if (!srom)
>  		return -ENOMEM;
>  
> -	sromwindow = (u16 *) SROM_OFFSET(sih);
> +	sromwindow = (u16 *) srom_window_address(sih, curmap);

	sromwindow = srom_window_address(sih, curmap)



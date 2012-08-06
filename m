Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41160 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab2HFTPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:15:12 -0400
Date: Mon, 6 Aug 2012 15:01:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jeff Mahoney <jeffm@suse.de>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>
Subject: Re: [PATCH] brcmsmac: document firmware dependencies
Message-ID: <20120806190135.GA26210@tuxdriver.com> (sfid-20120806_211518_058517_4A31ECE2)
References: <501079BC.6050607@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <501079BC.6050607@suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Could you repost this in a fashion that is consumable by 'git am'?

On Wed, Jul 25, 2012 at 06:57:00PM -0400, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> The brcmsmac driver requests firmware but doesn't document the
> dependency. This means that software that analyzes the modules to
> determine if firmware is needed won't detect it.
> 
> Specifically, (at least) openSUSE won't install the kernel-firmware
> package if no hardware requires it.
> 
> This patch adds the MODULE_FIRMWARE directives.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> - ---
>  drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> - --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> @@ -86,7 +86,9 @@ MODULE_AUTHOR("Broadcom Corporation");
>  MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver.");
>  MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN cards");
>  MODULE_LICENSE("Dual BSD/GPL");
> - -
> +/* This needs to be adjusted when brcms_firmwares changes */
> +MODULE_FIRMWARE("brcm/bcm43xx-0.fw");
> +MODULE_FIRMWARE("brcm/bcm43xx_hdr-0.fw");
>  
>  /* recognized BCMA Core IDs */
>  static struct bcma_device_id brcms_coreid_table[] = {
> 
> - -- 
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
> Comment: GPGTools - http://gpgtools.org
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQIcBAEBAgAGBQJQEHm8AAoJEB57S2MheeWySqEQALkb2wGqTYsbjeKSz4gbXshf
> aUohL3UWrE81FH/2QzcXzLlLYPWmRdzsdMve6uafNfWWVHEXJDW5PzNbegCOwaPt
> 8CdDFCUztKElfOzuqs6gUA3RgKdCl0ORSEFvFg6qg77jpw348e749dHUalmrsxga
> eR1R7NbFb7i2dcl0cK8d6SefdWtzcPonYYtb/pjSbJXlGMPxPpjFpXA2e/eGx+sf
> X5RP2AVGXDPQ7KgtVcZMMbOfmWRYLNmLfFZjXkpZGGPPiGgIc523HP3+PAAEi054
> LG3YcRIURAmqklrrHs2QQh9kQB3IxwXonkOiPsUuj9kJzv1mgMyxvXSOwywgI2O3
> AWRxCeQMsujrSLXUJJVHKjOk7sOmYHy/y7KytA1gvxQ18XnEHs0BrnOEUtgdbNdO
> rsc9gtZwtc1OOSmuH1kX12IyLe8YFatQ/d3nrFjWlMYeY0eqP349/vhgMdzQyTN5
> yz8wrbANBxDMiqsh+wUCtMEU5YPAailNcYPl2mUT2ptGmup6LGZSS0lpk1/GfPkr
> qpHW+4coFeJyIGT4IEnux3+32KaIrU/m93Vd7H7D0Lv4AsDV3Dn6YTD6EbdUgWmW
> bwvuAUWhVhgRoeVB6nO+fkHRrQyWUDRqknGXL+qtPn/TKDyJw7x3md1yR+/WbIeX
> jFFv5i1+CDoR+JlMmkOK
> =7FV2
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

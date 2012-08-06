Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754506Ab2HFTSB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 15:18:01 -0400
Message-ID: <50201862.3050909@suse.de> (sfid-20120806_211804_617222_96990787)
Date: Mon, 06 Aug 2012 15:17:54 -0400
From: Jeff Mahoney <jeffm@suse.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>
Subject: Re: [PATCH] brcmsmac: document firmware dependencies
References: <501079BC.6050607@suse.de> <20120806190135.GA26210@tuxdriver.com>
In-Reply-To: <20120806190135.GA26210@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 8/6/12 3:01 PM, John W. Linville wrote:
> Could you repost this in a fashion that is consumable by 'git am'?

Apologies. I forgot to turn off signing. I've resent.

- -Jeff

> On Wed, Jul 25, 2012 at 06:57:00PM -0400, Jeff Mahoney wrote: The
> brcmsmac driver requests firmware but doesn't document the 
> dependency. This means that software that analyzes the modules to 
> determine if firmware is needed won't detect it.
> 
> Specifically, (at least) openSUSE won't install the
> kernel-firmware package if no hardware requires it.
> 
> This patch adds the MODULE_FIRMWARE directives.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com> --- 
> drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    4 +++- 1
> file changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c +++
> b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c @@ -86,7
> +86,9 @@ MODULE_AUTHOR("Broadcom Corporation"); 
> MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver."); 
> MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN cards"); 
> MODULE_LICENSE("Dual BSD/GPL"); - +/* This needs to be adjusted
> when brcms_firmwares changes */ 
> +MODULE_FIRMWARE("brcm/bcm43xx-0.fw"); 
> +MODULE_FIRMWARE("brcm/bcm43xx_hdr-0.fw");
> 
> /* recognized BCMA Core IDs */ static struct bcma_device_id
> brcms_coreid_table[] = {
> 
>> -- To unsubscribe from this list: send the line "unsubscribe
>> linux-wireless" in the body of a message to
>> majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>> 
> 

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQIBhiAAoJEB57S2MheeWy8GQP/RS/v1buCVfYTkkzp5DGb6Fe
w4gtRvGmSbPj8iOIbCqC1VhzoGXntJbL9KVlE0RDqc9A3nriEC+DPx11t4VFx8KP
8JI9ai25tIy40FOMb3HlaZ4AeVCu3eooEU7lxIfdy+hognXj9LIw2GohDVwmlTG3
0XLsOJoYax0RRQe7lhRIPASDjbl5lne+djrCJODZN1kSNJguKKyo7p5+1VqfVszi
pEcs6NZWw7YbyoJ9g+px4turX4A9dEqWqw1qCL48gWL/iCLPETN72xj6O+oumZ5G
NJeuLn0Mz+uNOd7wh8gAAJVrAAcnIPVVWrWbJtcAJKaPW5lQnf8sSB1XDvVZAmlM
syNfJm9c0JSVquD/SS73awCOMQwMP5Zx7jK09pmgAQwrPATpoMwbUDlGG97UI24O
36PqA1u5iNaPfK1EJ9Q0e/12hD+OyLgo9gC6zSVKz0soxfuQIONou1Ju/6yyjX/3
SqTckKELkM1TY9HDqLIvYrCNPbWI73QVEKdKcdBojBbrtCBGV6PvS+6ZnPBJNbPg
4V1VjHO/gG8o99kYM0mCtBNq8fiL1UNmmBZFPM/uAEumZA9z4+EzFA1bUJg3YYzD
TO2Q9FL7hYTp2BUrJJBk5V7tzG8EMah6M+oWpam+5zNtQbq3QopNZAlvJlCvg9sv
XDGL9pMHB+2qbZTYvVmq
=wqxy
-----END PGP SIGNATURE-----

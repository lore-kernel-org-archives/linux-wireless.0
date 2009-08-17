Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:56576 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbZHQUqb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 16:46:31 -0400
Message-ID: <4A89C19E.6080906@free.fr>
Date: Mon, 17 Aug 2009 22:46:22 +0200
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: rt2x00 Users List <users@rt2x00.serialmonkey.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] [PATCH 4/7] rt2x00: Set SKBDESC_L2_PADDED in RX
 path
References: <200908171853.24256.IvDoorn@gmail.com>	<200908171853.57397.IvDoorn@gmail.com>	<200908171854.19205.IvDoorn@gmail.com> <200908171854.50790.IvDoorn@gmail.com>
In-Reply-To: <200908171854.50790.IvDoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Ivo van Doorn a écrit :
> When the RX descriptor indicates the frame was L2 padded,
> the SKBDESC_L2_PADDED flag should be set to make sure the
> L2 padding is removed before it is send to mac80211.
>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800usb.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c
b/drivers/net/wireless/rt2x00/rt2800usb.c
> index c82474e..6de2eda 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -2163,8 +2163,10 @@ static void rt2800usb_fill_rxdone(struct
queue_entry *entry,
>      if (rt2x00_get_field32(rxd0, RXD_W0_MY_BSS))
>          rxdesc->dev_flags |= RXDONE_MY_BSS;
> 
> -    if (rt2x00_get_field32(rxd0, RXD_W0_L2PAD))
> +    if (rt2x00_get_field32(rxd0, RXD_W0_L2PAD)) {
>          rxdesc->dev_flags |= RXDONE_L2PAD;
> +        skbdesc->flags |= SKBDESC_L2_PADDED;
> +    }
> 
>      if (rt2x00_get_field32(rxwi1, RXWI_W1_SHORT_GI))
>          rxdesc->flags |= RX_FLAG_SHORT_GI;
I have tested this patch as well and it looks correct. However, during
my test, the hardware does not set L2PAD flag, even if padding is
present (for some frames). I did the same test with the rt2870sta
driver from Ralink and the L2PAD was indeed set.

Ivo : what happens during your tests?

Regards,
Benoit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkqJwZkACgkQOR6EySwP7oLcEACcDDUaE5oeOhF8CsC1hdg6cKQ6
7K4An2DKy76bVP2CpfhOJePGNrSWDI2v
=3ymH
-----END PGP SIGNATURE-----


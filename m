Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:53679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbYGWR37 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 13:29:59 -0400
From: Andreas Schwab <schwab@suse.de>
To: Christoph Hellwig <hch@lst.de>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: use correct type for test_bit/set_bit
References: <20080723165314.GA30144@lst.de>
Date: Wed, 23 Jul 2008 19:29:57 +0200
In-Reply-To: <20080723165314.GA30144@lst.de> (Christoph Hellwig's message of
	"Wed, 23 Jul 2008 18:53:14 +0200")
Message-ID: <jeod4oecfe.fsf@sykes.suse.de> (sfid-20080723_193004_371296_9E4651ED)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christoph Hellwig <hch@lst.de> writes:

> The test_bit/set_bit/etc family of routines operates on arrays of
> unsigned long, so declare sc_keymap as such using the DECLARE_BITMAP
> helper.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: linux-2.6/drivers/net/wireless/ath9k/core.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/net/wireless/ath9k/core.h	2008-07-23 18:36=
:39.000000000 +0200
> +++ linux-2.6/drivers/net/wireless/ath9k/core.h	2008-07-23 18:37:28.0=
00000000 +0200
> @@ -1042,7 +1042,7 @@ struct ath_softc {
> =20
>  	/* Crypto */
>  	u_int                   sc_keymax;      /* size of key cache */
> -	u_int8_t                sc_keymap[ATH_KEYBYTES];/* key use bit map =
*/
> +	DECLARE_BITMAP		(sc_keymap, ATH_KEYBYTES);/* key use bit map */

DECLARE_BITMAP expects the number of bits, not bytes.

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

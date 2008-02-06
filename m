Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:39293 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800AbYBFKsJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 05:48:09 -0500
From: Andreas Schwab <schwab@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Tino Keitel <tino.keitel@gmx.de>, <linux-kernel@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT 1/1] single_chip test
References: <20080206014131.9d489a34.akpm@linux-foundation.org>
	<1202294560-7313-1-git-send-email-jirislaby@gmail.com>
Date: Wed, 06 Feb 2008 11:48:06 +0100
In-Reply-To: <1202294560-7313-1-git-send-email-jirislaby@gmail.com> (Jiri
	Slaby's message of "Wed\, 6 Feb 2008 11\:42\:40 +0100")
Message-ID: <jezluetl7d.fsf@sykes.suse.de> (sfid-20080206_104812_669786_38897964)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Slaby <jirislaby@gmail.com> writes:

> @@ -210,12 +205,16 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_s=
oftc *sc, u8 mac_version)
>  	}
> =20
>  	/* Identify single chip solutions */
> -	if((srev <=3D AR5K_SREV_VER_AR5414) &&
> -	(srev >=3D AR5K_SREV_VER_AR2424)) {
> -		ah->ah_single_chip =3D true;
> -	} else {
> -		ah->ah_single_chip =3D false;
> -	}
> +	ah->ah_single_chip =3D !!(srev >=3D AR5K_SREV_VER_AR2424 &&
                             ^^

This is useless.

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

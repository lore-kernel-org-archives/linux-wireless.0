Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:56491 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbYEWLUR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 07:20:17 -0400
From: Andreas Schwab <schwab@suse.de>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATH] libertas: speeds up downloading of CF firmware
References: <200805231018.26751.hs4233@mail.mn-solutions.de>
Date: Fri, 23 May 2008 13:20:15 +0200
In-Reply-To: <200805231018.26751.hs4233@mail.mn-solutions.de> (Holger
	Schurig's message of "Fri, 23 May 2008 10:18:26 +0200")
Message-ID: <jeve15b72o.fsf@sykes.suse.de> (sfid-20080523_132024_759701_65A36CB5)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig <hs4233@mail.mn-solutions.de> writes:

> Keep the timeout the same (1000*500 =3D=3D 100000 * 5), but take shor=
ter
> naps. Makes downloading the firmware slightly faster.
>
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
>
> --- linux.orig/drivers/net/wireless/libertas/if_cs.c
> +++ linux/drivers/net/wireless/libertas/if_cs.c
> @@ -148,11 +148,11 @@
>  {
>  	int i;
> =20
> -	for (i =3D 0; i < 1000; i++) {
> +	for (i =3D 0; i < 100000; i++) {
>  		u8 val =3D if_cs_read8(card, addr);
>  		if (val =3D=3D reg)
>  			return i;

That changes the return value.  Although it doesn't matter since all
callers only check for < 0, it should perhaps be changed to return 0
here to avoid confusion.

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

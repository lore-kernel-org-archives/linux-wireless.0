Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:42948 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756727AbXEMBaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 May 2007 21:30:24 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] Add 93cx6 eeprom library
Date: Sat, 12 May 2007 21:29:24 -0400
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
References: <200705111559.41153.flamingice@sourmilk.net> <20070512191749.GA6018@tuxdriver.com>
In-Reply-To: <20070512191749.GA6018@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9994858.PreklQ3glZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705122129.28655.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart9994858.PreklQ3glZ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 12 May 2007 15:17, John W. Linville wrote:
> On Fri, May 11, 2007 at 03:59:40PM -0400, Michael Wu wrote:
> > +static inline void eeprom_93cx6_pulse_high(struct eeprom_93cx6 *eeprom)
> > +{
> > +	eeprom->reg_data_clock = 1;
> > +	eeprom->register_write(eeprom);
> > +	udelay(1);
> > +}
> > +
> > +static inline void eeprom_93cx6_pulse_low(struct eeprom_93cx6 *eeprom)
> > +{
> > +	eeprom->reg_data_clock = 0;
> > +	eeprom->register_write(eeprom);
> > +	udelay(1);
> > +}
>
> I'm with Jeff, these udelay's should go.  If they belong anywhere, it
> would be in the write routines provided by the caller.  For example, the
> routines provided by rtl8187 already have a delay in them.  Other
> hardware might actually have a hardware timer to implement delays (hey,
> it's possible).  Either way, this delay is superfluous.
>
Will remove.

> > +}
> > +EXPORT_SYMBOL_GPL(eeprom_93cx6_multiread);
> > +
>
> It's pedantic, but I hate empty lines at the end of files...
>
OK.

Thanks,
-Michael Wu

--nextPart9994858.PreklQ3glZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGRmn4T3Oqt9AH4aERAo4YAKCACXWIQaaosMfHPuDBxymDHpKNGwCfRl/C
hMuEJ1YAZxTP15JRwx9jJpE=
=9uU5
-----END PGP SIGNATURE-----

--nextPart9994858.PreklQ3glZ--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

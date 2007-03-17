Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from betty.cbit.net.au ([202.55.154.10]:53946 "EHLO mail.cbit.net.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752649AbXCQHfK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 03:35:10 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.cbit.net.au (Postfix) with ESMTP id E42261081AC
	for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2007 18:35:07 +1100 (EST)
Received: from mail.cbit.net.au ([127.0.0.1])
	by localhost (betty [127.0.0.1]) (amavisd-new, port 10024) with LMTP
	id 27417-02-59 for <linux-wireless@vger.kernel.org>;
	Sat, 17 Mar 2007 18:35:05 +1100 (EST)
Received: from keitarou.bubblesworth.net (unknown [202.55.155.91])
	by mail.cbit.net.au (Postfix) with ESMTP id 651A11081B6
	for <linux-wireless@vger.kernel.org>; Sat, 17 Mar 2007 18:34:58 +1100 (EST)
Date: Sat, 17 Mar 2007 18:34:53 +1100
From: Paul TBBle Hampson <Paul.Hampson@Pobox.com>
To: linux-wireless@vger.kernel.org
Subject: Re: prism54pci fails to read eeprom on PowerPC, then bugs in pci code
Message-ID: <20070317073453.GD5954@keitarou>
References: <20070317034607.GA1522@keitarou> <200703170037.14875.flamingice@sourmilk.net> <20070317061502.GA5954@keitarou> <200703170244.54114.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JwB53PgKC5A7+0Ej"
In-Reply-To: <200703170244.54114.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--JwB53PgKC5A7+0Ej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 17, 2007 at 02:44:49AM -0400, Michael Wu wrote:
> On Saturday 17 March 2007 02:15, Paul TBBle Hampson wrote:
>> Is it worth dumping the purported eeprom to see if it's actually a valid
>> eeprom in a format unexpected by the code? (The card is very old now...)

> Actually, the code doesn't check (but it does report) if parsing fails so=
 a=20
> corrupted eeprom can't be the reason for probe failure. I'll get that fix=
ed=20
> next week..

> So anyway, your card isn't even returning the eeprom data. Only thing I c=
an=20
> think of is fiddling with the mdelay in that (p54p_read_eeprom) function=
=20
> (there's only one). Try making it bigger. That mdelay solved problems wit=
h=20
> eeprom reading on module reload but it's very close to the minimum delay=
=20
> needed there.

mdelay of 500 and 5000 didn't seem to help.

Would the result of any of the P54P_READs help? Or do they not produce
anything useful at this stage?

--=20
-----------------------------------------------------------
Paul "TBBle" Hampson, B.Sc, LPI, MCSE
On-hiatus Asian Studies student, ANU
The Boss, Bubblesworth Pty Ltd (ABN: 51 095 284 361)
Paul.Hampson@Pobox.Com

Of course Pacman didn't influence us as kids. If it did,
we'd be running around in darkened rooms, popping pills and
listening to repetitive music.
 -- Kristian Wilson, Nintendo, Inc, 1989

License: http://creativecommons.org/licenses/by/2.1/au/
-----------------------------------------------------------

--JwB53PgKC5A7+0Ej
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF+5odexDuohKLFuARAobiAJ0YzBmBpASppHCVmqWCisjaTJ2FLwCfa5EK
QMQBd+D7eGU6nnuOXF+Hk1Q=
=2joK
-----END PGP SIGNATURE-----

--JwB53PgKC5A7+0Ej--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

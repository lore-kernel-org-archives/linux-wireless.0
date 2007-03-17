Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:43568 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752149AbXCQGpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 02:45:39 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Paul TBBle Hampson <Paul.Hampson@pobox.com>
Subject: Re: prism54pci fails to read eeprom on PowerPC, then bugs in pci code
Date: Sat, 17 Mar 2007 02:44:49 -0400
Cc: linux-wireless@vger.kernel.org
References: <20070317034607.GA1522@keitarou> <200703170037.14875.flamingice@sourmilk.net> <20070317061502.GA5954@keitarou>
In-Reply-To: <20070317061502.GA5954@keitarou>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2842515.S2j9ovjxeo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703170244.54114.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2842515.S2j9ovjxeo
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 17 March 2007 02:15, Paul TBBle Hampson wrote:
>  ] rmmod prism54
> Mar 17 16:43:26 su kernel: prism54-0: removing device
> Mar 17 16:43:26 su kernel: Unloaded prism54 driver
>
> Then, with the p54 code, patched with the patch you attached.
>
>  ] modprobe prism54pci
> Mar 17 16:48:56 su kernel: p54: LM86 firmware
> Mar 17 16:48:58 su kernel: 0001:11:00.0 (prism54pci): Cannot read eeprom!
> Mar 17 16:48:58 su kernel: prism54pci: probe of 0001:11:00.0 failed with
> error -22
>
> Hmm, I guess the patch fixed the BUG_ON. ^_^
>
Ok good, thanks for testing!

> Still fails to read an eeprom from my card though. I'm wondering if the
> crapspew from the prism54 driver implies card or socket badness?
>
These devices do go bad, so a broken card isn't out of the question. Howeve=
r..

> However, the hardmac driver is able to get a MAC address (with an OID
> query, according to the code) and the MAC address is correct:
> 00:60:64:03:41:81
>
My broken card never got that far.=20

> Is it worth dumping the purported eeprom to see if it's actually a valid
> eeprom in a format unexpected by the code? (The card is very old now...)
>
Actually, the code doesn't check (but it does report) if parsing fails so a=
=20
corrupted eeprom can't be the reason for probe failure. I'll get that fixed=
=20
next week..

So anyway, your card isn't even returning the eeprom data. Only thing I can=
=20
think of is fiddling with the mdelay in that (p54p_read_eeprom) function=20
(there's only one). Try making it bigger. That mdelay solved problems with=
=20
eeprom reading on module reload but it's very close to the minimum delay=20
needed there.

=2DMichael Wu

--nextPart2842515.S2j9ovjxeo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF+45mT3Oqt9AH4aERAmasAKDQeDbnUTrKYPrPSDWgX55eIKtX/gCePX0N
cFVzhbduZ7L1tYKP1fMmS+Q=
=SFIp
-----END PGP SIGNATURE-----

--nextPart2842515.S2j9ovjxeo--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

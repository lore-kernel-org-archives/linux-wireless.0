Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:37227 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbdHXHNw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Aug 2017 03:13:52 -0400
Received: by mail-wr0-f174.google.com with SMTP id z91so7021586wrc.4
        for <linux-wireless@vger.kernel.org>; Thu, 24 Aug 2017 00:13:52 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
        simon.wunderlich@openmesh.com
Subject: Re: [PATCH] wireless-regdb: Update regulatory rules for Singapore (SG)
Date: Thu, 24 Aug 2017 09:13:42 +0200
Message-ID: <1684208.h1AJVyQWH7@bentobox> (sfid-20170824_091357_033317_C4FF96C8)
In-Reply-To: <20170823205240.ycyrszsvjugtosdi@ubuntu-xps13>
References: <20170807081950.13327-1-sven.eckelmann@openmesh.com> <20170823205240.ycyrszsvjugtosdi@ubuntu-xps13>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3285254.gLubm19p8a"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3285254.gLubm19p8a
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

On Mittwoch, 23. August 2017 15:52:40 CEST Seth Forshee wrote:
[...]
> > +# Source
> > +# https://www.imda.gov.sg/~/media/imda/files/regulation%20licensing%20=
and%20consultations/ict%20standards/telecommunication%20standards/radio-com=
ms/imdatssrd.pdf?la=3Den
> > +# page 12-14
> > +# The EIRP for 5250 =E2=80=93 5350 can be increased by 3dB if TPC is i=
mplemented.
[...]
> > +	# 5470 - 5725 is only allowed when TPC is implemented
> > +	# (5470 - 5725 @ 160), (30), DFS
>=20
> I'm not sure that the lack of a specific provision for operating without
> TPC in this range means that it cannot be used. As I understand it, TPC
> would only result in a reduction in EIRP of 3 dB, so as long as we use
> a power limit of half of the maximum allowed we will be safe.
>=20
> If this is incorrect I'd appreciate it if someone more knowledgable on
> the topic could chime in.

I would also be happy about feedback regarding this part. But my current=20
settings are based on the document [1] mentioned in this change.

Let us look at the range 5250 =E2=80=93 5350 on page 13. There are two entr=
ies for the=20
same frequency range.

 * 28:
   - up to 200 mW
   - requires TPC for 5250 =E2=80=93 5350 Mhz
 * 29:
   - up to 100 mW
   - requires *no* TPC for 5250 =E2=80=93 5350 Mhz

This is exactly the 3(.01029995...) dB difference which you've talked about=
=2E=20
Now to the frequency range 5470 - 5725 MHz on page 14.=20

 * 30:
   - up to 1000 mW
   - requires TPC for 5470 - 5725 MHz

There is no extra exception rule for non-TPC mode.

Now let us check what IEEE 802.11h-2003 [2] says about TPC.

* 5.4.4.1 TPC:
  - doesn't say anything about 3dB but mentions adaption based on different=
=20
    criteria
* 7.3.2.16 Power Capability element
  - nothing regarding 3 dB here (just allows 5 dB tolerance)
* 7.3.2.17 TPC Request element
  - only describes the element
  - nothing relevant regarding the usage
* 7.3.2.18 TPC Report element
  - only describes the element
  - nothing relevant regarding the usage
* 7.4.1.3 TPC Request frame format
  - only describes the element
  - nothing relevant regarding the usage
* 7.4.1.4 TPC Report frame format
  - only describes the element
  - nothing relevant regarding the usage
* 10.3.16 TPC request
  - nothing relevant regarding the limits
* 11.5 TPC procedures
  - refers to 11.5.4 for the power adaption
* 11.5.4 Adaptation of the transmit power
  - has some suggestions to the power reduction methods
  - doesn't go into details
  - nothing about a 3dB only reduction

Ok, where is the 3 dB then coming from? My guess is the mitigation=20
requirement. This should be 3 dB as *default* value (page 59). "11.5 TPC=20
procedures" says following:

"Potential methods to ensure regulations are met even if TPC is not employed
include using a transmit power that is below the legal maximum (including a=
ny=20
mitigation factor).".

It informs us also in "11.5.2 Specification of regulatory and local maximum=
=20
transmit power levels" that the mitigation factors are defined in each=20
regulatory domain:

"Any calculation of the local maximum transmit power for the channel shall=
=20
ensure the mitigation requirements for the channel in the current regulator=
y=20
domain can be satisfied. The conservative approach is to set the local maxi=
mum=20
transmit power level equal to the regulatory maximum transmit power level=20
minus the mitigation requirement. However, it may be possible to satisfy th=
e=20
mitigation requirement using a higher local maximum transmit power level. A=
=20
lower local maximum transmit power level may be used for other purposes (e.=
g.,=20
range control, reduction of interference)."

It is therefore now relevant to know how these these statements from 802.11=
h=20
and the statements from the the Singapore document have to be combined=20
correctly. My current change now assumes following strict interpretation:

 * Singapore provides a mitigation factor of 3 dB for 5250 =E2=80=93 5350 M=
hz (see=20
   table entry 28 + 29)
 * Singapore provides now mitigation factor for 5470 - 5725 MHz and require=
s=20
   TPC

I am currently unsure whether it is now valid to say that the default=20
mitigation factor would be 3 dB and thus there is an implicit table entry (=
let=20
us call it 30b) which would be:

 * 30b:
   - up to 500 mW
   - requires *no* TPC for 5470 - 5725 MHz

Countries like AU or regions like ETSI (ETSI EN 301 893) seem to have this=
=20
mitigation factor always specified in their rules. But Singapore is missing=
 it=20
for this specific frequency range.

Kind regards,
	Sven

[1] https://www.imda.gov.sg/~/media/imda/files/regulation%20licensing%20and=
%20consultations/ict%20standards/telecommunication%20standards/radio-comms/=
imdatssrd.pdf?la=3Den
[2] http://standards.ieee.org/getieee802/download/802.11h-2003.pdf
--nextPart3285254.gLubm19p8a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlmefKYACgkQXYcKB8Em
e0aBrxAAsu1qFWeIDEjJY2CO3FVk6pqrWhDiggstYp2CinTk853THSwqCbBHrsG7
fBoGnt9gKKuVWtYWZ/ymbecZ0n8UufOe064XVUzJOxbDKl7ywsyqK71PPB2hspnH
GiWQvPn0kim82Hg0VTYL3L5dfgvfirspp56ibEQnbmihuvhp8BX82QgZNe/NG8J0
0i30FDLSAyDDC2hRk7XB/z7ibn+sBe6Mls6OfxRMCWVCHCSPIGkRNfUNic98RKKt
R9tleDdXGkjRZ6juZ3u0AoRyOpqEr9xaoTBz7/TZrbgCTLL+/PdIUooEMlaL6ZJz
NLcorovcZZ1G9x5Y/6dUJAbTk3JPlLSqvHFGdBDbyHP/ndzUjK1GnfbTvcnkjWbM
p9W6CsbJwliT2etcycAY/bIicL/4Nn2sQkxoYq12pl1Yjptogo6MaErAZ+kcyNz+
yyPy1IBCbbLRFPdYBa3a7WdcXF5H7cdB1xx5XKC26BnzCmZtVVcq2zGbD3hVDnlt
CWcLVK30dHI411QiCFzK5s7vQdXwL9mJhOUN5Eqnyv7WcLlUJWcJNCdKbIo+miGI
OWMwr/jLgjGbgukrgM6exBERFD0e9HPBf8xAOpXs4PCEeoBSovt9fT7zSTrBSKs1
h66jcaWiXUy62MITi+UPK8gm1x6xrIuqG6K11Lo/3DXl7NQjDQk=
=iahn
-----END PGP SIGNATURE-----

--nextPart3285254.gLubm19p8a--

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50739 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZHKUx1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 16:53:27 -0400
Message-ID: <4A81DA33.1050405@hauke-m.de>
Date: Tue, 11 Aug 2009 22:53:07 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/7] [compat-2.6] pcmcia_parse_tuple was redefined in
 	pcmcia/cistpl.h
References: <1249735096-27071-1-git-send-email-hauke@hauke-m.de> 	<1249735096-27071-3-git-send-email-hauke@hauke-m.de> <43e72e890908101520x19fddcddx72215fb0851baf2f@mail.gmail.com>
In-Reply-To: <43e72e890908101520x19fddcddx72215fb0851baf2f@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5C2F661DAADA94C6B47F988B"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5C2F661DAADA94C6B47F988B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Luis,

Thank you for applying the rest of the patches. Next time I will use
--cover-letter when generating the patches.

Luis R. Rodriguez wrote:
> On Sat, Aug 8, 2009 at 5:38 AM, Hauke Mehrtens<hauke@hauke-m.de> wrote:=

>> fix build:
>> undef pcmcia_parse_tuple before redefine it again.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  compat/compat-2.6.28.h |    8 +++++++-
>>  1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/compat/compat-2.6.28.h b/compat/compat-2.6.28.h
>> index fdc021a..e25259f 100644
>> --- a/compat/compat-2.6.28.h
>> +++ b/compat/compat-2.6.28.h
>> @@ -29,7 +29,13 @@
>>  })
>>  #endif /* From include/asm-generic/bug.h */
>>
>> -#define pcmcia_parse_tuple(tuple, parse) pcmcia_parse_tuple(NULL, tup=
le, parse)
>> +#include <pcmcia/cs_types.h>
>> +#include <pcmcia/cs.h>
>> +#include <pcmcia/cistpl.h>
>> +#ifdef pcmcia_parse_tuple
>> +#undef pcmcia_parse_tuple
>> +#define pcmcia_parse_tuple(tuple, parse) pccard_parse_tuple(tuple, pa=
rse)
>> +#endif
>=20
> Where did pccard_parse_tuple() come from?
In include/pcmcia/cistpl.h pcmcia_parse_tuple(p_dev, tuple, parse) is
defined as pccard_parse_tuple(tuple, parse)

> Did you see the commit 0df8084caf53774113c8f118e9dd43e660cf9e15 by any
> chance? That fixed compilation for me against older kernels.
I still get a compile error with recent compat-wireless including commit
0df8084caf53774113c8f118e9dd43e660cf9e15 with kernel <=3D 2.6.27 in Ubunt=
u:

In file included from
/compat-wireless-git/drivers/net/wireless/b43/pcmcia.c:30:
include/pcmcia/cistpl.h:610:1: warning: "pcmcia_parse_tuple" redefined
In file included from /compat-wireless-git/include/net/compat.h:19,
                 from <command-line>:0:
/compat-wireless-git/include/net/compat-2.6.28.h:32:1: warning: this is
the location of the previous definition

The above patch fixes it for me. The patch does not look relay nice, do
you have a better idea how to solve this problem?

Hauke


--------------enig5C2F661DAADA94C6B47F988B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJKgdo4AAoJEIZ0px9YPRMyz14P/A+dC989vcul2n/W+CtA3SJS
qjp3Ww/Yqpyf8O1SOjn8lNr5VYn762fpYuVjHj+hSFeGS62PoWajpd5uj/faYT3U
ox5s29eBTHyuLZVrhg++JPE9IQ6WPr/nRkIqRRT+NqAbIfd2z8hHRTrAfnWbaqI6
MHAb/YLO44vTfpNcJOIrKf6xFPwIfasUEvxLEsi6s7kGWJ3TigLDsVAjMtqDk2dy
rGEq81y3SeMTzl/wV7YFhU5jMspSuAdhBrwaDPiDD+gG9sN5x0N3SlvHJSIwf3nW
Go5CN/EwqcBjwQM0SdD2jqVwzbO3xv3wPefvYUTXR6nFjOWdVsD1Jyt6X9nO12d5
gKLmU1qH4f7Ay5VBBeUmOdNrEyEGS0F7X6kQRmvsQhVFIe4MxTTnwbmI8eqPBpTg
b8/Z/NCdX5FtaZIdWmdbdpQndC1T05oprJ6f2lOWyoXxQ45R2mergYk13yXr2mOv
r1Tz2OwRyq/PCL0evAthC8rJmZDz8O6sLdIQbFj9F29z/Ar/xxFOH5ygxKI71U4z
a9JDiq1i/cbGSjCNLuEA0DGOSjmJefz83IrZXR5T0flJ/dvb408ziDy77MlOSMFO
T4qoW+ydW8cSb4lYoRKCi2EVhQXpKpLq9PU3VD0MHNuSBeSa9FpF0LHv+bw5mdJI
DO4NbRAVTLFzbwbonYyY
=IVsc
-----END PGP SIGNATURE-----

--------------enig5C2F661DAADA94C6B47F988B--

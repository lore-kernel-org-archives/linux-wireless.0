Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3735 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab1JIKdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Oct 2011 06:33:24 -0400
Message-ID: <4E91785F.6030008@broadcom.com> (sfid-20111009_123328_143848_26CE8DA0)
Date: Sun, 9 Oct 2011 12:33:03 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"John W Linville" <linville@tuxdriver.com>,
	"Michael Buesch" <mb@bu3sch.de>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net>
 <20111009005107.43a49372@milhouse>
 <CACna6rz-0TZrwctTZR-YLDHG=xdt4Oc5ShbjCZiad7Cvmh0+hQ@mail.gmail.com>
In-Reply-To: <CACna6rz-0TZrwctTZR-YLDHG=xdt4Oc5ShbjCZiad7Cvmh0+hQ@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 10/09/2011 10:48 AM, Rafał Miłecki wrote:

> Agree. I already tried converting bcma to use crc8:
> [RFC][WORTH IT?][PATCH] bcma: make use of crc8 lib
> http://lists.infradead.org/pipermail/b43-dev/2011-June/001466.html
> 
> But resigned, it was introducing some hacks or not optimal ops, I
> decided it's not worth it.
> 
> Even Arend said their brcm80211 is hacky about crc8 usage:
> 
> W dniu 15 czerwca 2011 21:26 użytkownik Arend van Spriel
> <arend@broadcom.com> napisał:
>> Agree. In brcm80211 we convert the entire sprom, calculate, and convert it
>> back. Also not perfect I think as it loops over de sprom data twice.
> 

Hi Rafał,

"not perfect" == "hacky" ;-)

I also just replied with a less hacky approach. Reading the sprom as
bytes will read the sprom content as is (little-endian) and you can do
the crc8 check without any conversions. After the check there is only
one conversion needed to move to a word array.

Gr. AvS
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOkXheAAoJELcEx/G14aEWnHwP+wZRWLladazO/zZnuMrnEuRk
xhMzbZcIy8gJwkGs/GwuWqnHBZu+Qx/k/BC3S1CNNmLPOf7qLNbS4hgKRZn+2Tze
FHYzXb6IPXkCE6MS5BFRi2qxnzrxam7gL00SB5NuGceS4b3LQL+wNHzPx5yPlPEW
KsJnecyFTabclun2zxucZPB19w2xrS84Xcl2Db+2nV3wSn700REr5mr3+pmVXmvd
ptLuWsc5ZoAnvuTQq/PUjKvQb/tA7CpDFs9+uvCeKa93Rb3JIRwTk5tAVadLEWn7
6IWyN0VMK+pdL2LT14qc1LWJa192tn8qbmOg21lKsQFepP4egJyRGWaU7aKo9bdG
PVSXfqme0azRl6vd+G28Q/SVdt//w5HBoPgdWlORhNdo/sov07QVl8gf80QkTn/A
Ij3M1+LMlUFu7weuIwgKBIA+Bi6CxTR/3ozK+S3ItpVqt6gCnMlDYtEUM6pk2vVj
8ppl0LtGHyrogFgwOrcYbxMKJGbk8Po82T+Um7wchcHuRxGLD3NuErndMiRwemMk
zALNLYNCLLftCSypCgkM5kyfDkDf7uZMxJZbPXyIIFCP4BXm5xrgx39sYQAVx4if
bIjW0W3OmIbBcQScZ4+KRZ5YN1g45VFRQ3+4BPyusApYqzwSmjxUj8aomfD2QhEJ
Fh/5uq3JIrpQazyEsILz
=JjZ0
-----END PGP SIGNATURE-----


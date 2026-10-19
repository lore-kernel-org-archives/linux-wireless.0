Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=34.202.193.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792451622;
	b=GL098aZuYM756KYma9MNR2uX9lE0SdX0SiRaE9JyeTTNXJsVVMtKn0cpnM+ghPnQERzY
	 OO8ft8XIRVrBiJyuj9E/VuDR0MJTQkbmL++vlJAzJt/M3ZcB+2ppvkSGcStSgHk799mtD
	 KPzM1UA1LPkRTLq/R93Cw/6vB/SYVbRKhvpv4SEKTsyR0JKJk7U78PT52AVPny4Jbak8b
	 P7nCVcZm7OB9cS2BMm15+tMHQYIxkCEOZV4nLe78VtduLuGxtcrns6UWstH04CfWJGo/Y
	 l0ngYjQl20PGacNt3yaSEMAAYRawk8yH6WzRx3NDfJejSXdlh/HxlAimDYxyxDbQ5XQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792451622;
	h=DMARC-Filter:DKIM-Signature:DKIM-Signature:Feedback-ID:
	 X-Pm-Original-To:Received:MIME-Version:Date:From:To:Cc:Subject:
	 User-Agent:Message-ID:X-Sender:Content-Type:Content-Transfer-Encoding:
	 X-MIME-Autoconverted;
	bh=Tl6e+2ir7opmhBXwat8ozz+DyoXD0/01QeXHvVUGORM=;
	b=LvIUfhOGWoq5XXPSQwZM+/M2P9MkLyWdHzyg3LXvXL2Kc1kAtjEZFiYmF+WBa3z250tL
	 Ow3Bu2I/0GLctAH3bQzktwD2APVZDw3spNWZg7cjIhpcpy5N3AzIXrViP0EVBpWHvjFrQ
	 nQMeKXQe1XW8+tdauCsup8bGLf6bobEbGtoaHKlj489ihiRJ5MYK4GxKEvFdRGev44Pvf
	 rhrh5j3ahSmSs4UE0x1SJUDWc3/dPEfoxUobKJHD9wCQJKdrA6322JcgmuzxY43CuIYMn
	 QuvZLcUBHiM809f324m4KReGhL6EKwPodjvg4Kxsm0QnvR7V+ReDX9lH4KSaAXbmBJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=plabin.cl;
	spf=pass smtp.mailfrom=plabin.cl;
	dkim=pass header.d=plabin.cl header.i=@plabin.cl header.a=rsa-sha256 header.s=purelymail3 header.b=Xz+ug86X;
	dkim=pass header.d=purelymail.com header.i=@purelymail.com header.a=rsa-sha256 header.s=purelymail3 header.b=PJ0ugKYG;
	arc=none smtp.remote-ip=34.202.193.197
Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13709606A319
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 23:13:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13709606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=plabin.cl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plabin.cl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=plabin.cl header.i=@plabin.cl header.a=rsa-sha256 header.s=purelymail3 header.b=Xz+ug86X;
	dkim=pass (2048-bit key, unprotected) header.d=purelymail.com header.i=@purelymail.com header.a=rsa-sha256 header.s=purelymail3 header.b=PJ0ugKYG
DKIM-Signature: a=rsa-sha256; b=Xz+ug86X4/zOimelx0eFWBhwEvlTRY08JOZxJuzPvUME281ma6+m+LDOB5uFcwuh1FV0IuSYKrAKSKKEQMjsKa6vhMJhO8j0mAARh1CTGTJQpJOx2xxHVsfFRszXnb7eUX4BFo+efCpt61q5dyfZBXwJwmL9Rq37CJU0Wv7KZmOaqL7WzBr02FqP5HbyzSCR7H5HaDsku8bQxoWcUSnswOFTByIZpa4jaleyGQCsLE5RdBqHtHqE2nZAKxBXQgwbIOdzh1jbRKhJyr+1tJw101/Eo+xamlqlQozdEnNGS0b5sQgf7hehw2/YfE2A0P70NmCHxnmFwv4Nsey/5hWcvA==; s=purelymail3; d=plabin.cl; v=1; bh=c285t87veb6yMEukUvT9Fm6cDC9S0jefouQ9OKsgCrE=; h=Received:Date:From:To:Subject;
DKIM-Signature: a=rsa-sha256; b=PJ0ugKYGSSkM8c/syvrzCXvEDEPcafK/x9xKwX0tD2GPqqSgN9epijuZ0fwHkeXyS+Oy9iB4jTZj1y99BKVAMdYr2aTBCroeXug0SJxeinSUBTXBMhePNtcb3ZAVLDxjDdTQaJ+aMsqt+zgCpPFeflXXEeZgnZETBOpj8oTBcr2TO5RGmp/qwpEkbZz/6YxWw9Pa0HqoEECfjh8mt9QGDl5i0QkdzyjzsEPEwh4o+6/AVNJ7UOPbne1Mh321aPQBI3FG3oy0ca8Rj6QzsB2Y4NleIbA8MMKZNj2dFi8gjQzzsuMYpqjpnE6VphmpdJ9NQyzGUaEgJwiDCPTwFZDU3Q==; s=purelymail3; d=purelymail.com; v=1; bh=c285t87veb6yMEukUvT9Fm6cDC9S0jefouQ9OKsgCrE=; h=Feedback-ID:Received:Date:From:To:Subject;
Feedback-ID: 839499:40515:null:purelymail
X-Pm-Original-To: linux-wireless@vger.kernel.org
Authentication-Results: purelymail.com; auth=pass
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPA id 2082373624;
          Mon, 19 Oct 2026 23:13:39 +0000 (UTC)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 19 Oct 2026 20:13:39 -0300
From: plabin@plabin.cl
To: linux-wireless@vger.kernel.org
Cc: wens@kernel.org, pkshih@realtek.com
Subject: [PATCH] wireless-regdb: Update regulatory rules for Chile (CL)
User-Agent: Purely Mail via Roundcube/1.6.19
Message-ID: <c73bf6f8881844c599cb294398639730@purelymail.com>
X-Sender: plabin@plabin.cl
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by Purelymail

Update the regulatory rules for Chile (CL) based on SUBTEL=20
(Undersecretary
of Telecommunications) Resoluci=C3=B3n Exenta N=C2=B0 1.985 (Fija Norma T=
=C3=A9cnica de
Equipos de Alcance Reducido) and its consolidated amendments.

Source:
https://www.bcn.cl/leychile/navegar?idNorma=3D1109333

Key changes:
- Change DFS region from DFS-JP to DFS-FCC: SUBTEL regulations align
   with ITU Region 2 / FCC standards rather than Japanese MIC rules.
- 2.4 GHz band: Align boundaries to 2400-2483.5 MHz (Article 1, j.1)
   and update EIRP power limit from 20 dBm to 30 dBm (1 W).
- 5150-5250 MHz: Align lower boundary to 5150 MHz, update EIRP power
   limit to 30 dBm (1 W), and add NO-OUTDOOR as Article 1, literal j
   strictly restricts operation in this band to indoor enclosures.
- 5250-5350 MHz: Align upper boundary from 5330 to 5350 MHz and update
   EIRP power limit to 30 dBm (1 W) with DFS (Article 1, j.1).
- 5470-5725 MHz: Add missing band authorized by Article 1, j.1 with
   DFS up to 1 W EIRP. Extend upper boundary to 5730 MHz to cover
   Channel 144, similar to US, TW, and CA entries.
- 5725-5850 MHz: Align boundaries from 5735-5835 to 5725-5850 MHz and
   update EIRP limit to 30 dBm (1 W) (Article 1, j.1).
- 57-66 GHz band: Add 60 GHz WiGig band at 40 dBm EIRP as authorized
   for short-range devices.

Signed-off-by: Patricio Labin Correa <plabin@plabin.cl>
---
Hi Chen-Yu, Ping-Ke, and linux-wireless reviewers,

This is my first time submitting a patch. I prepared this RFC to=20
modernize
the regulatory rules for Chile (CL), which have remained largely=20
untouched
since 2008.

In Chile, major ISPs (such as Movistar) deploy Wi-Fi routers=20
broadcasting on
Channel 100 (5500 MHz) by default. Because the 5.470-5.725 GHz band was=20
missing
from country CL, Linux machines cannot detect or connect to these 5 GHz=20
networks.

Before finalizing, I would appreciate your guidance on:
1. DFS region: I changed DFS-JP to DFS-FCC since Chile follows ITU=20
Region 2
    and aligns with FCC standards. Does DFS-FCC look right here?
2. Power limits: SUBTEL Article 1, j.1 authorizes up to 1 W EIRP. I used=20
(30) dBm;
    would you prefer explicit mW units (e.g. 1000 mW)?
3. Channel 144: I used (5470 - 5730 @ 160) to accommodate Channel 144,=20
matching
    conventions in US, TW, and CA rules. Does this look good?

Thank you for your review and sorry if I'm doing something wrong.

  db.txt | 15 +++++++++------
  1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/db.txt b/db.txt
index 7aff3fb..1240270 100644
--- a/db.txt
+++ b/db.txt
@@ -455,13 +455,16 @@ country CI: DFS-FCC
  =09(5735 - 5835 @ 80), (30)

  # Source:
-#=20
https://www.bcn.cl/leychile/navegar?idNorma=3D1109333&idParte=3D9841504&idV=
ersion=3D&r_c=3D6
-country CL: DFS-JP
-=09(2402 - 2482 @ 40), (20)
-=09(5170 - 5250 @ 80), (20), AUTO-BW
-=09(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-=09(5735 - 5835 @ 80), (20)
+# https://www.bcn.cl/leychile/navegar?idNorma=3D1109333
+# SUBTEL Resoluci=C3=B3n Exenta N=C2=B0 1.985 (Norma T=C3=A9cnica de Equip=
os de=20
Alcance Reducido)
+country CL: DFS-FCC
+=09(2400 - 2483.5 @ 40), (30)
+=09(5150 - 5250 @ 80), (30), NO-OUTDOOR, AUTO-BW
+=09(5250 - 5350 @ 80), (30), DFS, AUTO-BW
+=09(5470 - 5730 @ 160), (30), DFS
+=09(5725 - 5850 @ 80), (30)
  =09(5925 - 6425 @ 320), (12), NO-OUTDOOR
+=09(57000 - 66000 @ 2160), (40)

  # Source:
  #=20
https://wap.miit.gov.cn/zwgk/zcwj/wjfb/tz/art/2021/art_e4ae71252eab42928daf=
0ea620976e4e.html

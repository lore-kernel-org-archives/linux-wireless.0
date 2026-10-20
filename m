Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=34.202.193.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792467881;
	b=oqMH5HC9V7E8txGqFmxa9scE0X6LS20WUXDb36VDgRldAoSQHbkHtFC5qYgQMGQTBzRT
	 dLDf5g37GP/gcRoXtKkl3pQ80DIiF48dYeDNamuJCa/4GsoaF/+wGO9XUYltJBSqc+v0g
	 tOOwdnWPGggrlQIaDqvLj2JaA76w8bolehSpdUBIUwdM3AeilPXxJ9TbHaC5EYPvY06sQ
	 PMw7zSM0P5/VsheTS5mCOqm3eLLkypsaZaTdMNfa9gRKqYGL8adGbUsYV6+Um0nFytBND
	 8Ou7rD67i5/mjMeDf7eBIT4NmbAgQ57djatYArwjaFTbawxG7xTGkVkqsYphRRkxhUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792467881;
	h=DMARC-Filter:DKIM-Signature:DKIM-Signature:Feedback-ID:
	 X-Pm-Original-To:Received:MIME-Version:Date:From:To:Cc:Subject:
	 User-Agent:Message-ID:X-Sender:Content-Type:Content-Transfer-Encoding:
	 X-MIME-Autoconverted;
	bh=+y7LEmOmear+ZPxvlfTnbQqqfi6Pb9DSFzXx55parUk=;
	b=u8pgoqAiZOsg1qmNzdeUyXUnbMoy8/FkuRC6SV81+FraQmmXJhcJFVYMR5PdwTgrjOvP
	 lIH17WYP/GfP/mmxnCjUUSnBartQEstyu42y+lMDR2aZM2gW7kBxtBy6KSS8FMxsVv7xO
	 Y77iyL6v4Fbx9c8ZTrZntk0vTJHvYx0nm4pIV2FDRKxWM9fwCiPCkZP4HFY+MVaZsqMy+
	 ch25c0ghl4WIQ4E4/Si1zKuLflyJZHbqjCQj9EEe/uo1zfphIX+Wz5IVvXOweLOkCCI9+
	 ObNWRo+QIC0dSPuLCfQIs/oPu5hYJRR/vvFs97xbtMWQlSL3Imm2aUxz8Tujr7bG42Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=plabin.cl;
	spf=pass smtp.mailfrom=plabin.cl;
	dkim=pass header.d=plabin.cl header.i=@plabin.cl header.a=rsa-sha256 header.s=purelymail3 header.b=SuuRcHra;
	dkim=pass header.d=purelymail.com header.i=@purelymail.com header.a=rsa-sha256 header.s=purelymail3 header.b=SgkGywE8;
	arc=none smtp.remote-ip=34.202.193.197
Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44CC606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 03:44:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C44CC606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=plabin.cl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plabin.cl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=plabin.cl header.i=@plabin.cl header.a=rsa-sha256 header.s=purelymail3 header.b=SuuRcHra;
	dkim=pass (2048-bit key, unprotected) header.d=purelymail.com header.i=@purelymail.com header.a=rsa-sha256 header.s=purelymail3 header.b=SgkGywE8
DKIM-Signature: a=rsa-sha256; b=SuuRcHraUbatQFk5JoT3WJI4gxmSWD76UCdf11qFp1Jwg6lqeIrBNNmX/OQv+Tt4V2DRv061kQ2NAL6QpmliIocLHOPqqgndRgz1r9eTR6h5rSinpwQSt1B9Jz7Aa0+2JDE2cd/HZGAkY5U6AmmxBORmDxFMzzp0JTpZMVVYucf6RReBvKkuPIMArwN7zmuO0QWEJPQijnUKuRmdq1zjXWcAAst+Jf541No52xUjWZndugcdMmge2pQJAoOvqyV4XdaTfZhuw/cDs3gJfA3KAFUhciaPTwNYKqhOyuiZaPuqj//V5c8gecL4IR5n1DEcFkDIHhHCj7FAackurIAh6w==; s=purelymail3; d=plabin.cl; v=1; bh=Y9rZceB9BJl+t6rlhBmYn8x3dNY36JLYQAXCR9k8Gnc=; h=Received:Date:From:To:Subject;
DKIM-Signature: a=rsa-sha256; b=SgkGywE8A6fNZwQ/5sHcDJHrFJ6Tv2qIHvDZ2VHvxujhz5uKq7lVxte7pEy1dqnvCM3GaiGGEtmwZ/BeZ7VjpCdGQxzJF0PDptxdecalCO8EgWIOVMLKmKL8RecfETZamkKVWjg/Kca295bHzuSBZ7b8utlCc+B4X8JVNnFp352Uo3KdhLRRFXdPgPtaCOfPHRFpO1d5iT70ebj3rHMxyT7PXAyEG+hAMa2qTtNzubQxoqQK+Xh5YMMd5Ff3TZY9KRYhqgdGENzUaWt1MYDlNnh1FYJSpfIgmt+TXTRvHcbJnRdjsMra9ASc+nJ7mx9wYs6zXs1MO2L+Yv7B8udY8w==; s=purelymail3; d=purelymail.com; v=1; bh=Y9rZceB9BJl+t6rlhBmYn8x3dNY36JLYQAXCR9k8Gnc=; h=Feedback-ID:Received:Date:From:To:Subject;
Feedback-ID: 839499:40515:null:purelymail
X-Pm-Original-To: linux-wireless@vger.kernel.org
Authentication-Results: purelymail.com; auth=pass
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPA id -240673090;
          Tue, 20 Oct 2026 03:44:30 +0000 (UTC)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Tue, 20 Oct 2026 00:44:29 -0300
From: plabin@plabin.cl
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com, wens@kernel.org
Subject: [RFC PATCH v2] wireless-regdb: Update regulatory rules for Chile (CL)
User-Agent: Purely Mail via Roundcube/1.6.19
Message-ID: <d390d8a7db9bf2ec0a920dc8e95aa551@purelymail.com>
X-Sender: plabin@plabin.cl
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by Purelymail

Update the regulatory rules for Chile (CL) based on SUBTEL=20
(Undersecretary
of Telecommunications) Resoluci=C3=B3n Exenta N=C2=B0 1.247 published on Ju=
ly 10,
2026, which establishes the consolidated and refundido text of=20
Resoluci=C3=B3n
Exenta N=C2=B0 1.985 (Norma T=C3=A9cnica de Equipos de Alcance Reducido).

Source:
https://www.bcn.cl/leychile/navegar?idNorma=3D1225920

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
v1 -> v2:
- Update source reference to direct link for Resoluci=C3=B3n Exenta N=C2=B0=
 1.247
   (idNorma=3D1225920) which contains the refundido/consolidated text.

Hi Chen-Yu, Ping-Ke, and linux-wireless reviewers,

This is my first time submitting a patch, and I apologize for the wrong=20
sources on v1.

I prepared this RFC to modernize the regulatory rules for
Chile (CL), which have remained largely untouched since the initial=20
import in
2008.

In Chile, major ISPs (such as Movistar) deploy Wi-Fi routers=20
broadcasting on
Channel 100 (5500 MHz) by default. Because the 5.470-5.725 GHz band was=20
missing
from country CL, Linux machines cannot detect or connect to these 5 GHz=20
networks.

This update aligns Chile's entry with SUBTEL Resoluci=C3=B3n Exenta N=C2=B0=
 1.247=20
of
July 10, 2026 (the official refundido and consolidated text of the=20
standard).

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

Thank you for your review and guidance!

  db.txt | 15 +++++++++------
  1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/db.txt b/db.txt
index 7aff3fb..90a78bb 100644
--- a/db.txt
+++ b/db.txt
@@ -455,13 +455,16 @@ country CI: DFS-FCC
      (5735 - 5835 @ 80), (30)

  # Source:
-#=20
https://www.bcn.cl/leychile/navegar?idNorma=3D1109333&idParte=3D9841504&idV=
ersion=3D&r_c=3D6
-country CL: DFS-JP
-    (2402 - 2482 @ 40), (20)
-    (5170 - 5250 @ 80), (20), AUTO-BW
-    (5250 - 5330 @ 80), (20), DFS, AUTO-BW
-    (5735 - 5835 @ 80), (20)
+# https://www.bcn.cl/leychile/navegar?idNorma=3D1225920
+# SUBTEL Resoluci=C3=B3n Exenta N=C2=B0 1.247 (10-JUL-2026, texto refundid=
o de=20
Res. 1.985)
+# Norma T=C3=A9cnica de Equipos de Alcance Reducido
+country CL: DFS-FCC
+    (2400 - 2483.5 @ 40), (30)
+    (5150 - 5250 @ 80), (30), NO-OUTDOOR, AUTO-BW
+    (5250 - 5350 @ 80), (30), DFS, AUTO-BW
+    (5470 - 5730 @ 160), (30), DFS
+    (5725 - 5850 @ 80), (30)
      (5925 - 6425 @ 320), (12), NO-OUTDOOR
+    (57000 - 66000 @ 2160), (40)

  # Source:
  #=20
https://wap.miit.gov.cn/zwgk/zcwj/wjfb/tz/art/2021/art_e4ae71252eab42928daf=
0ea620976e4e.html

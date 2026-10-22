Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.186.4.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792687166;
	b=rSBiggAOyruMFcu/lQeN63QDuT3gFwPv05phTOZIt13O+5rWN+/PDBV4XewoYrXScQlR
	 EXIKHETviEzGetsiQBjG36npFh/3giNHgXOEBf0XxNmnTzIBx4t/N6E7/yhKmrTfYe5Kq
	 eOg25UDfjwQ27VhvX6FoN/AypHNLpEemj0cY3vuKcC6kUIAqddo0106Ab0FkqUEnsfPA3
	 80oPvtjBJp2Sgk/YX3RqnRDAumGUdrGHPskm2QsJjBStkj/hsMYKVx2bIAVNLsjt2QFFM
	 EUBjdiSFU0dW85kSUZ/jFh2QSUSmJDWG2WZyaMwbGxYNz1W8Y1DXLOUalMEsf/xJk/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792687166;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=Xa0r/DQ/s0JYCk88RUqPkqF/7q6ZRxVmUPUbBNZ5zmc=;
	b=SbICaAmHmiEE9/bVVfUmB8Tz+1PoXqljW1xv/MzFt/5ArSYxXkK2rurZh9BSRxAWNoJC
	 kcH5Xr+qYUPfYBo5009vINzFF4OlHygiPgJ45Xq161oi2jBWfplX7PUw1gFhZjbqM+Nrn
	 jAcLVxxb0fFqf64C0yAK55HO/+yKTWb8Q4NnPcmR64TMWp8yYNJ+2QyZ0xmjK3ZwW49K8
	 GtZj7CWtW/AXs99md3C9m/5C46oMS1m8lBmbvN8PRTZSHrRqfelJH2ZKyy0b5Twq9RGpp
	 istzIUjr6NNK7J6L2OsYiubM4xxMMeDmvOLYBa+te2j9SB9Y0jy5zPLzTn8ErNwlZBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lizardsystems.com;
	spf=pass smtp.mailfrom=lizardsystems.com;
	dkim=pass header.d=lizardsystems.com header.i=@lizardsystems.com header.a=rsa-sha256 header.s=dkim2 header.b="m3YJH8/V";
	arc=none smtp.remote-ip=54.186.4.18
Received: from mail.lizardsystems.com (mail.lizardsystems.com [54.186.4.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D316606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 16:39:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D316606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lizardsystems.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lizardsystems.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=lizardsystems.com header.i=@lizardsystems.com header.a=rsa-sha256 header.s=dkim2 header.b=m3YJH8/V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lizardsystems.com;
	s=dkim2; t=1792687160;
	bh=Xa0r/DQ/s0JYCk88RUqPkqF/7q6ZRxVmUPUbBNZ5zmc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:From;
	b=m3YJH8/V0KUhOkaIUnA8twSbUKXpiqiej4tHlRWdfm7Z9tc4N96q2dh1sHh4cfG18
	 8+X4jWTxFIkhp4Z1ZB1lRJJwEUmOXx+hERyqqZXtsKbxgX5WqE+aDrAgshzAdsx+oL
	 Bb8O6oCoabslPsOoVp4z2SY52FccGyLY5/BkKa0vVhkzob7DaMWpLfdCuEs7MJGmDq
	 SZvPsKvwvK1FUe0KliDX9mQI53pe+0bUWz9iI4hBChjOhAdUET8SFrm+Ad0/T6uyqB
	 83H2FKHTwDm8P1/V0MMMTkuxIU1KxdzYPWJAz70C3Gt0BaqQRUXFLKN9X2VYah3VO5
	 nchXmhPTqGDDQ==
Received: from viza (unknown [109.248.199.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.lizardsystems.com (Postfix) with ESMTPSA id BFFBE427CC;
	Thu, 22 Oct 2026 16:39:18 +0000 (UTC)
From: Vitalii Zagorovskii <support@lizardsystems.com>
To: wens@kernel.org
Cc: wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	Vitalii Zagorovskii <support@lizardsystems.com>
Subject: [RFC PATCH] wireless-regdb: Apply the FR rules to French Polynesia (PF) and Wallis and Futuna (WF)
Date: Thu, 22 Oct 2026 21:39:10 +0500
Message-ID: <20261022163910.1292-1-support@lizardsystems.com>
X-Mailer: git-send-email 2.56.0.windows.1
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

PF and WF carry the same block, which matches neither FR nor TNRBF
Annex 7: 2402-2482, 5170-5250, 5250-5330 and 5490-5710 MHz, with no
5725-5875 MHz, 6 GHz or 60 GHz rule. I could not trace those values to
the TNRBF or to a local decision.

Annex 7 of the TNRBF (consolidated edition of 26 May 2026) says that the
use of its bands by short-range devices is subject, in Region 3, to
decisions of the TTOM assignee, and that in the absence of such
decisions the conditions in its tables apply:

  en Region 3, a des decisions de l'affectataire TTOM; en l'absence de
  telles decisions, les conditions d'utilisation de ces bandes de
  frequences par les AFP sont celles mentionnees dans les tableaux
  ci-dessous.

PF and WF are in Region 3. The TTOM assignee is the government of
French Polynesia (DGEN) for PF and the Service des postes et
telecommunications (SPT) for WF. I found no Wi-Fi decision from either,
so the Annex 7 tables apply.

FR is the closest block db.txt has to those tables, so use it for both
countries. The FR block cites the 2021-12-14 edition of the TNRBF and may
not equal the current Annex 7 rows in every detail; if FR is brought up
to date, PF and WF should follow it.

Source:
https://www.anfr.fr/fileadmin/mediatheque/documents/tnrbf/TNRBF_2026-05-26c.pdf
(Annexe 7, A7-1, and the WAS/RLAN tables 3.a to 3.c)

Signed-off-by: Vitalii Zagorovskii <support@lizardsystems.com>
---
 db.txt | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/db.txt b/db.txt
index 7aff3fb..6a83fff 100644
--- a/db.txt
+++ b/db.txt
@@ -1617,10 +1617,16 @@ country PE: DFS-FCC
 	(5925 - 7125 @ 320), (12), NO-OUTDOOR
 
 country PF: DFS-ETSI
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
-	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
+	(2400 - 2483.5 @ 40), (100 mW)
+	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
+	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
+	(5470 - 5725 @ 160), (500 mW), DFS, wmmrule=ETSI
+	# short range devices (ETSI EN 300 440-1)
+	(5725 - 5875 @ 80), (25 mW)
+	# WiFi 6E low power indoor
+	(5945 - 6425 @ 320), (23), NO-OUTDOOR, wmmrule=ETSI
+	# 60 GHz band channels 1-6 (ETSI EN 302 567 v2.2.1)
+	(57000 - 71000 @ 2160), (40)
 
 country PG: DFS-FCC
 	(2402 - 2482 @ 40), (20)
@@ -2167,10 +2173,16 @@ country VU: DFS-FCC
 	(5735 - 5835 @ 80), (30)
 
 country WF: DFS-ETSI
-	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
-	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
+	(2400 - 2483.5 @ 40), (100 mW)
+	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
+	(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
+	(5470 - 5725 @ 160), (500 mW), DFS, wmmrule=ETSI
+	# short range devices (ETSI EN 300 440-1)
+	(5725 - 5875 @ 80), (25 mW)
+	# WiFi 6E low power indoor
+	(5945 - 6425 @ 320), (23), NO-OUTDOOR, wmmrule=ETSI
+	# 60 GHz band channels 1-6 (ETSI EN 302 567 v2.2.1)
+	(57000 - 71000 @ 2160), (40)
 
 country WS: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-- 
2.56.0.windows.1


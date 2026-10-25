Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=98.137.65.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792932854;
	b=0NTwO52YR+lSsavhi02Qkm8J8b/PJW/0iSX7R7EuajV2jBZXSXIYe8WyZ4q+Veke0Tfk
	 9kUyApOiuRKRj4jCJzPSLnMQc+pOGInD6+MeU5Fy7qGn9v50WSms8agsQYsqiSM2a+kwM
	 ZYc3BbX8u5cBIb+mFXgInkyfUTZ5T3HVAk4flrKDKgXaA6JoizOxHBs8LDB5V/YYLReFl
	 VT5iDc/PoN23NgDADctnKXfasjyd/UGgQhAPXaE8UnglVw3lDc9yFET3Vp8vCCl3Ok0Zn
	 yrvvJn83G+t8OiZt/ORCNWWuFlOBCl6mtpTTqoLJbZysLXjE/GdJ7Jz0NO7JwOqNIOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792932854;
	h=DMARC-Filter:DKIM-Signature:X-SONIC-DKIM-SIGN:X-YMail-OSG:X-Sonic-MF:
	 X-Sonic-ID:Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:References;
	bh=fqJOBjI4OghyEpJhwDiKxCiOs7plrMf3wWuuAAC7ZBY=;
	b=BSO6dWudd6IJbBXMOhvZkE2mYplYkggKV78Bgq1IoCB4Z5+IYpmnLKX79wTw4HDpESyg
	 QKcHB+O2q4rp0GvXrnyXZMIJHWhNQptgydArVWM7/fU9JFRVcmkI5fB9yCLNIkGiP5Cs1
	 vsgxh3s9qDjRb1P6BzRCtd0OCYDp6G2dPcVmxLZoNCYlQN+v2wwReuiEA6O0A2QZh9Z5D
	 juQXb/wHEhRDfHCxuTK/Qd0WRWinGE6WEs1u1WcuqVZ3AfyL05Mw7bfGJ1fAeKeWGWbvC
	 oPf1NQ5pqnXGxv+bPGTnjqShkiVa5/1Bzt7NKTFMEntvR8PKdKXglU1giqKSh+t19sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yahoo.com;
	spf=pass smtp.mailfrom=yahoo.com;
	dkim=pass header.d=yahoo.com header.i=@yahoo.com header.a=rsa-sha256 header.s=s2048 header.b=kwdnPPHo;
	arc=none smtp.remote-ip=98.137.65.30
Received: from sonic315-54.consmr.mail.gq1.yahoo.com (sonic315-54.consmr.mail.gq1.yahoo.com [98.137.65.30])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A673606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 12:54:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A673606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=yahoo.com header.i=@yahoo.com header.a=rsa-sha256 header.s=s2048 header.b=kwdnPPHo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1792932852; bh=fqJOBjI4OghyEpJhwDiKxCiOs7plrMf3wWuuAAC7ZBY=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=kwdnPPHoGkn3KuVzjhf89hdYpgKKSOedtGrl7KnTiKvc6K8z8Z1FYI2PSB+TPENRQb5+i6LTlZCQhMgxCOZzGGiEkkQhoIlJWw7XYI6KAeQVMnaZxWaV/w/CD/6Bs2Fjn1GYmYQk0ooIjTc/g1jvF8Dem7mioINljITTwvt6XdnDstPzKXZMfSLddgJ7YZTljru56Tatvn8CaeSDCW6/8WsLyLmZNcDi+nEf3E16AFGIndJw/jFIJUEcFSWEUJNZAFgczquYovchjWLjvo7vQVKQy+7kWT+lMhf9W7pzTYWPBTXnqyY05CiQOnXBLCK2UK7C3bbkekhqrTNAN0Zmtw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1792932852; bh=ETi+SfshEdOjd7wM7MYBYl6d4O7JzfDEd1tWxOHDHJ3=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=fg4RmY0xpi+lkRIeOrz3X9TFA5NitOki21c07+w4I1PiBI41Hdal9wx+kIS01ofxu670xyxKF0oi9+te4hrdWAjzBxyL1LG1MDlNo67mBCqpAtUWcevNg767DHILmhcqvF58l/cRTqRiG8g1gNS8d0Y8B0dQ6uvOOyzDO60HrLRI90q9mHl4dgXoh9ICLzpCygUOq/v+U4usF313gbGl1LL4fP7S19RD14Ktz+TkHfmYsQjePWhYWsBNZ7qyKzpkUY0k0paQEFBYU82aflkiXmf7vZMrhZk0LXny+H7dyw2uz6hYnUWF79vBhyB8u0SlAvmzUr9nY62J8+/OaNXduQ==
X-YMail-OSG: AmVbkkkVM1mRe7MGPoQ7Avo8ijeZL4JeVeRgox91tM07P0WrMnj1EY3dQzS8PyO
 LDmangeN2ZPJa6zuj30fVQqoONsGhbQxq6bFaNNgVWMndrev1l45g9Nd1hwJCaK0ofJiMEUB_BYH
 YfWXG7nHCli79IIg__aNHGoAozyUfmyrv69ybzGoaf7CGOFPJIrZmZSWGseCj4vl9E4cV5p63jeB
 WZIsNrdNlkKQLEmzYgxOe16phGCfVITPx_YThd_FDvo7WQ290OZfteDsh0lPwqbSgvMr4fZVVgX_
 xFaQasOk0zpk5rOvTvVAdX6jscJwq4mbvlKGURlcvZK66HmlTRoU.3ydUpkSmvTf9gcUrKO6u1hF
 aaYarjO31d_ITGqZWFnK8wqhAEqYF6EtLZgRGP0f1PxApnQPKNmyBuTIXQmnI1goIZOtxma48ZQO
 VAnjJTgiFoOHpc5ITaY0TTiklBhvWY59hqoPhCr63wx8SIFc8MzmUQXIJHWWr4y0nkhvHwABXMj9
 Ks3OHSzqKwkNfkyHsIDcfhb2Qh287Wqqox2gZEJRN6BnRAKJ9te1KR0MuFh_ChQ0yy1fODkmUvIt
 wNdNAZMBLNEpRozsOZ7BonLK5o9f1Klt0YaAYSKPMAb82q6LrAuY7u7SnvjdeAKriesezrg4CppR
 eF2xHGeuI9LB3k3Nb9k7SUDYQVQ50YIYZChaT_KpEvdUYNrM24_4aJptQEQbiVoJYs8rLf8_k24S
 v9Bbjt8PcV1fRPZE0HpWb4bJiIP.iWc55tbcFwACiV6jb57y7XOKLvj6CDGllskay.bCY3KYZRdQ
 SpwRDdeNOChCbUrXEh8E7oPz8VgozhgDay5ViwRJ9nuWBooKEcY35c8wcy83D2VOVv2Pp12FF3I_
 fcekMcBhr8DR_i1IC.Ur9s04tb9cMBohu_ZszWik30C_Xm6nbMgG3hZ.OpR2OuOkDyz665vg_4Sr
 L5utzpSPl9lvDFgvkglgverYX98818xmh.op4CWUtO_AnpmBQn89CnTo3QSUrpggOl9TjaqOwKzC
 c4lXXGD1UzHIB8hTkYu0PhX0ftQCM.Xowg8GOw2M38HBk.20xzDuh.XIxOgNj5b5BgeQdTuU_0dz
 hW04gQWmWNPpp_xox8Iv6_6atPW16JcHNzJiAxLMgK7bJazT_4psYXtPOd6ZBXck6PttY2F2G7CW
 Yo.dgkCI_uraoSRRApKEyo_XsE6NAI7__lU0R2Hja87Qx16FzPbdyy7HAEHOkxtnfx.ObTKFXkEA
 EL2_BBZSPk51uece_oka7VJCLW2Q9YFqTXjsxI5ybomAIZN5gBG2iwPs02EXQprj9NQKO6FvI1xp
 u8EyI7qHLQqMKZWe11DmUOL54kY0bjYX_DziInVNWtiE9PmfIKWlz_oYulCFPQ7JyNKG84ac8o3h
 g5z8aJMD42e8.UkT.5Y96Gy_2MQsN_FAgHo_DniaF2ZUUeuEwPjryI5Bc.j8JXw_2hdyncIeKgn0
 lru6Wpcu9v_fIgEsQUcKfh.wbrKNcrdOR2u9Kj4bUgePeQshbidGxfSu4MmtpdeEuoNuqosaJjOv
 Xw_1UPMU_WBe7k30yqoW2w2cp6LMN.XZ6RkpN4SKFbKFCi_fai_cVVI3bKSkvqQ0UPDJvXSywtwX
 QueqMOQelGncqjnWlo_px.ivjSjqO_wQjp2nPHLTmizNIS2Ljv4Cu9wUSL9hphyFPN9mEmBS1ZUQ
 pawqjjGUhyVvbDFGK9PFWUZ9nTPxN9OqCjVEaYQiM3KnSmSGl6_gKeM4iZ605DbsaJjLZNeGJG96
 5DujL65Dw2q7zBU6wUVqzWHYmPtxrIrpno1iR2bERQnxEIlaC4XUZM8qRlch5wm1iZASGlarnGNZ
 Vo5vSXd8khctE5ST4xQsWtP4HMVtxRxD4zHJ3vUpeox5GKeMADNWwAQnC3qSt.sHxV0_EYp8.VUA
 7H.gOraxw0opL6hOtX9WfkxwhwNXZP.zQCnKQIo9M4EvuAm6r7UYRkesVhIQTzauqwzVmDpXiyYy
 f_0WfHJp9wqJJblRsTz6iVfIXvpLMZDmdwBCRbx2iePphiUcEFtI0dSve7oU1qgZF10rw5gr9LS4
 Ox9uSRjHUG1Ej8OgsvSVnwLnKarUnR6pqUXRVMKK1GsxC2onJQxtTfybBJ9jo7TVGVigYrYXre.B
 ebJq7CcuigmElbq0Z0k4gMpyEn055rDarYAQPe23rETsEKk0er0jFLXCv663Q8K3vXxYS88GXMVh
 qiYI3mRH3V863hropYejI4jNYOInwHg01l9cLY0Yd0IBNaBNwxiIj4u1uYCil2.b_QvwMmvsD3C4
 SgfUfhgx_NbgQqcLIANMRL6L5S1BZ9uswOl795I2AXSmWRXM-
X-Sonic-MF: <mnew_iraq@yahoo.com>
X-Sonic-ID: 96a82424-8a56-4c30-81f7-d7d3ea4badc4
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.gq1.yahoo.com with HTTP; Sun, 25 Oct 2026 12:54:12 +0000
Received: by hermes--production-ir2-5dd9bf4598-b6ftf (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 2416c4191a8d653539d2fb9f60260ade;
          Sun, 25 Oct 2026 12:54:06 +0000 (UTC)
From: Mohammed Abdullah Ali Al-Obaidi <mnew_iraq@yahoo.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v3] wireless-regdb: add regulatory rules for Iraq (IQ)
Date: Sun, 25 Oct 2026 15:54:00 +0300
Message-ID: <20261025125400.799-1-mnew_iraq@yahoo.com>
X-Mailer: git-send-email 2.54.0.windows.1
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
References: <20261025125400.799-1-mnew_iraq.ref@yahoo.com>

Add a regulatory entry for Iraq (ISO 3166-1 alpha-2: IQ).

Iraq is currently absent from the database, so devices set to
country=IQ fall back to the world domain (00). The Iraqi
Communications and Media Commission (CMC) has published a numerical
national regulation covering Wi-Fi.

Source: Regulation on short-range radio communication devices (SRD)
and devices using ultra-broadband (UWB) technology, CMC Council of
Commissioners decision No. 122/q-2025, in force from 2025-09-22,
Article 4-1-13 (Wireless Access Systems):
https://cmc.iq/wp-content/uploads/2025/09/Regulation-on-short-range-radio-communication-devices-SRD-and-devices-using-ultra-broadband-UWB-technology.pdf

Limits as stated in the regulation:
  2400-2483.5 MHz: 100 mW, indoor/outdoor
  5150-5250 MHz:   200 mW, indoor
  5250-5350 MHz:   200 mW, indoor, DFS
  5470-5725 MHz:   1000 mW, indoor, DFS + TPC
  5725-5875 MHz:   2000 mW (10 MHz ch) / 4000 mW (20 MHz ch)
  5945-6425 MHz:   200 mW, indoor
  57-66 GHz:       10000 mW, indoor

Encoding notes:
 * 5470-5725 MHz: the regulation requires TPC, which Linux does not
   implement. Following EN 301 893, the limit is reduced from 30 dBm
   to 27 dBm. The upper edge is extended to 5730 MHz so that channel
   144 is usable, as the 5725-5875 MHz band is less restrictive.
 * 5725-5875 MHz: the 2000 mW limit for 10 MHz channels is used to be
   conservative, since the database holds one ceiling per band.
 * 5945-6425 MHz: encoded at 80 MHz pending clarification from the
   CMC regarding AFC requirements.

Signed-off-by: Mohammed Abdullah Ali Al-Obaidi <mnew_iraq@yahoo.com>
---

Notes:
    Changes since v2 (https://lore.kernel.org/wireless-regdb/20260521101501.1841-1-mnew_iraq@yahoo.com/):
    - Reduce 5470 MHz rule to 27 dBm (EN 301 893, no TPC); mention in commit message.
    - Extend 5470 MHz rule upper edge to 5730 MHz for channel 144, with comment.
    - Add comment for the conservative 2000 mW (10 MHz) limit at 5.8 GHz.
    - Use 10000 mW for 57-66 GHz, as in the regulation.

 db.txt | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/db.txt b/db.txt
index 7aff3fb..43dc0b3 100644
--- a/db.txt
+++ b/db.txt
@@ -1017,6 +1017,30 @@ country IN:
 	(5725 - 5875 @ 80), (30)
 	(5925 - 6425 @ 320), (24), NO-OUTDOOR
 
+# Iraq
+# Source: Regulation on short-range radio communication devices (SRD)
+# and devices using ultra-broadband (UWB) technology, First Edition
+# 2025, issued by the Iraqi Communications and Media Commission (CMC)
+# under Council of Commissioners decision No. 122/q-2025, in force
+# from 2025-09-22. Limits below are taken from Article 4-1-13
+# (Wireless Access Systems) of that regulation.
+# https://cmc.iq/wp-content/uploads/2025/09/Regulation-on-short-range-radio-communication-devices-SRD-and-devices-using-ultra-broadband-UWB-technology.pdf
+country IQ: DFS-ETSI
+	(2400 - 2483.5 @ 40), (100 mW), wmmrule=ETSI
+	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
+	(5250 - 5350 @ 80), (200 mW), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
+	# Regulation allows 1000 mW (30 dBm) with DFS + TPC. Linux lacks TPC,
+	# so the limit is reduced to 27 dBm following EN 301 893.
+	# Upper edge is 5730 MHz so that channel 144 is usable; the 5725-5730
+	# MHz overlap is covered here, as the next band is less restrictive.
+	(5470 - 5730 @ 160), (27), NO-OUTDOOR, DFS, wmmrule=ETSI
+	# Regulation allows 2000 mW (10 MHz channels) / 4000 mW (20 MHz
+	# channels). Adopting the limit for 10 MHz channel width to be
+	# conservative.
+	(5730 - 5875 @ 80), (2000 mW)
+	(5945 - 6425 @ 80), (200 mW), NO-OUTDOOR, wmmrule=ETSI
+	(57000 - 66000 @ 2160), (10000 mW), NO-OUTDOOR
+
 # Source:
 # https://asnad.cra.ir/fa/Public/Documents/Details/73af8590-f065-eb11-968f-0050569b0899
 country IR: DFS-ETSI
-- 
2.54.0.windows.1


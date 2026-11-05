Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793855847;
	b=2xPHBfVQ8OjI1luUUHHGvl4U6Kb9wKatBoNh21xLvwLqMNFlkK5G8qdE8yX2ymvzIUqn
	 NVSRbvs1dOGB6dYRLiZajLhKcSUO/qIGRlCBq9ffiuv6p/1ldYKyYcLJn/0GFZKe3tsZp
	 JAN/8dBODSe2vuCeFbNWdB286V0D0Oiqg9Bd6Xdro3HtQ8ZA68HnqqMGIZlGNqE04XPmE
	 kSHzZ1D6fmSiwSxMbCo+1i0hkZ+OeYf0873XuhmNL/GBO4kI2kYmOdU2kZDu/3lboM/GW
	 4/PI12eEqFOgfJe9C9cONKw2LjP5xuvIIGfBmVorRe5uP90IenWE+G2PpTvxVGhF5KA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793855847;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=X+VBJPN19Rxr4jI2MqKS4zWSqq8lpduuJ6vi/q3CP0o=;
	b=DL7FYiAms5YlSFdciruaSu2olZWvegiaITkXYwhzgZsuIFTjWBG38/vLjGVwWOx6RlWs
	 N9h1ebeTV/VumRa1GsCkyRpua5E1MVnKIZkiH+5ji+SyE0N3BcgyTEhuOGXp00CxdRQW/
	 8lFnzCS444Ie1GDGyUVb1rrNUy58PYQxztaMpV/ofxa1EybWpiA309eaefbB46AbWUVvf
	 z85Ouyq8/QCJShhl4aBYmg0do0KgK23RLfB4JzydoUH6j8nOuKaLbCR9rqp6e5YEmSTI9
	 uHIkceNPIwL9M1NGIj5Y91/vjeJas1bdFrOACv6QeeUS8pKRHfrbaOjaArZFBjD9tNg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UonDI737;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B76F606A326;
	Thu,  5 Nov 2026 05:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UonDI737
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793855847;
	b=FPfWgE74SBn4hGxWGUJDwbzPd6W4SZ/FHEiJqUKTldKmjH5G+j4CsDi3L1BTF3V2Ba4a
	 TZMb+uJPUmQG1GHzlK5mQ4m2tz9snWxF6VbV8hgN6FrccXFjq2Eyy2Z6xdA63lAaMSe1n
	 AKrjx4ZuXvEfAVt6JG/ZKhgnaCbwiaze0goDJOhwq/Ja5uji1gxaLLZJ+7lervhqEIkrc
	 CXRWg6dO1MIeLYyBCghY5d3Ph2g6HWa9kCKQbkWGl1GExyG5a8OcIneGPeTlDQI0eAcWx
	 FFAgsGYBhjBXfHhKwy3ixwUbslDOEQOG3hDEtkYpU9KW7V3oJA2obizuKGz//+k941Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793855847;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=X+VBJPN19Rxr4jI2MqKS4zWSqq8lpduuJ6vi/q3CP0o=;
	b=U6Hw+mdb5lRB3ca9TGlLY5brXo/5QM788nAmNckaUowt9RkhXgrJwsa2ij/c4smmHTMW
	 tJRBGIHyoA4xBQes7XI09fBPtqbPYyboG58x6m4hHaRMNQYsTSyDKjuROQctJA2b0dFMI
	 L4oUhf7ByQmgg1NJ3/Isf06Tv/2n44E2B/wffZcNyjM/izpOvtDg5pKulCUCpjaDOGYnn
	 Y6g64ZRvPNRVpIim54+pFaTHUBbjL1MjE7SrSypl0x9vGFyhQqajCuyUN/nctBKaC/4+t
	 p56mIEot44Uc6Va+V+BTBetRvMNtqn5IGV1FDJ7AFH120cDNvVA30Mvudu5x0BiqIBg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8E4811F00919;
	Thu,  5 Nov 2026 05:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793855847;
	bh=X+VBJPN19Rxr4jI2MqKS4zWSqq8lpduuJ6vi/q3CP0o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=UonDI737eeMBhgQ6//FM0zpif7+yl0uVzCWO+F8H7xw4umnSO+B9Phd1SOutdhrI0
	 bz7kmwyYG1MWt9T/hHbCpZzm9I/LxGEkWMQEvh2B/9FaVdvR+8+tJT/ZrSkY+DrCGO
	 bXhUniBv6CMKXaGAQl6fmT9CzgQlboyLVcDSc77i55dfAiPCe9LJcqfRKddIu0pp2Y
	 iTwQRzYDULZke2LFDqZFJHitPVcTWrJLJDw4987uYExKZQvoXvDtnKuY5aIErApKkM
	 6qTVIqWDWpiWuoebgaV9udC1gtW/I73hWQI4LiPWT1sbsA7cUW2A2K82M9omsjYvaX
	 KshgYck+hf4cQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 167B5470CA;
	Thu,  5 Nov 2026 05:17:26 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Wed, 04 Nov 2026 23:17:26 -0600
Subject: [PATCH ath-next 1/2] wifi: ath11k: don't bit-reverse the
 firmware's PPE thresholds
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261104-ath-ppe-thresholds-bit-order-v1-1-0f569106cbc4@gmail.com>
References: <20261104-ath-ppe-thresholds-bit-order-v1-0-0f569106cbc4@gmail.com>
In-Reply-To: <20261104-ath-ppe-thresholds-bit-order-v1-0-0f569106cbc4@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>, John Crispin <john@phrozen.org>, 
 Kalle Valo <kvalo@kernel.org>, 
 Shashidhar Lakkavalli <slakkavalli@datto.com>, 
 P Praneesh <quic_ppranees@quicinc.com>, 
 Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>, 
 Karthikeyan Periyasamy <quic_periyasa@quicinc.com>, 
 Wen Gong <quic_wgong@quicinc.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Baochen Qiang <baochen.qiang@oss.qualcomm.com>, 
 Carl Huang <quic_cjhuang@quicinc.com>, 
 Ramya Gnanasekar <quic_rgnanase@quicinc.com>, 
 Balamurugan Selvarajan <quic_bselvara@quicinc.com>, 
 ath12k@lists.infradead.org, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793855845; l=2073;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=lRDCXb5fGqCIVT7aLQMio7qzrVZEvLsJS6K3rr1zoFA=;
 b=HxsVhn7nW+oc2hCfogzfaE60v4s1cr3V3MsFVFNOGWXSrL6D7cjsfiMXTfQfbLM2387B36S2x
 98q7iBMhVbmBAJduHvsDlnW68pPkmk8FYDaDNmqyW4hpCJ+k0v43rV5
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

The firmware reports its PPE thresholds as WMI defines them: in
ppet16_ppet8_ru3_ru0[nss], each RU has six bits, PPET16 in bits 2:0 and
PPET8 in bits 5:3, each a 3-bit constellation index. The PPE Thresholds
field of the HE Capabilities element carries the same two subfields in
the same order, bit 0 first, and ath11k_peer_assoc_h_he() already
converts a peer's field to the WMI layout that way.

ath11k_gen_ppe_thresh(), which builds our own field from the firmware's,
swaps the two halves and then writes the six bits from the top down.
That puts PPET16 first again, but with its three bits reversed, and the
same for PPET8: a threshold of 1 (QPSK) is advertised as 4 (256-QAM),
4 as 1, 3 (64-QAM) as 6 (reserved) and 6 as 3. Only 0, 2, 5 and 7 (none)
come out right, so the bug does not show with firmware that asks for
16 us padding at every constellation (PPET16 0, PPET8 7).

Copy the six bits in order.

IPQ8074 (WLAN.HK.2.9.0.1-02146) and QCN9074 (WLAN.HK.2.5.r4-00683)
firmware report PPET16 0 and PPET8 7 everywhere (iw phy: PPE Threshold
0x7b 0x1c 0xc7 0x71 ...), which reads the same either way, so their HE
capabilities do not change. Compile-tested.

Fixes: 9f056ed8ee01 ("ath11k: add HE support")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1a237adaa37d1..8b4e992b609a6 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5825,8 +5825,7 @@ static void ath11k_gen_ppe_thresh(struct ath11k_ppe_threshold *fw_ppet,
 				continue;
 			val = (fw_ppet->ppet16_ppet8_ru3_ru0[nss] >> (ru * 6)) &
 			       0x3f;
-			val = ((val >> 3) & 0x7) | ((val & 0x7) << 3);
-			for (i = 5; i >= 0; i--) {
+			for (i = 0; i < 6; i++) {
 				he_ppet[bit / 8] |=
 					((val >> i) & 0x1) << ((bit % 8));
 				bit++;

-- 
2.43.0



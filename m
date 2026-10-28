Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793216261;
	b=zQU9E6OMbYYqOgHywCtnjFjcrgPdhFo8zmfKmtQqGQnYAPU1svxqX+Xu7XpJo2WU70ML
	 dw03PaTUIZ1TOqKCPbbsgaZT4Xmolh+UiwC7UrAgTQ4y6Wlp2pCHmZGZSt5vE6Rd0kYqV
	 aaaA4Fp0UCwHyB+2rBu7z55GhAgzgWpfzjDqQ45l7tC0e6buAwn9NL+1V/sz7iXGxscjf
	 n3YzT44oK0RD879aCGhc9YF1XcyWz4JEYOByv+PNhoFGHOyORkpHonC3dw9A3VciTv8La
	 Z3nmNOBhZSZZLC0RBptxeN23IncMtpMP7v2aN7WDZD5EfVAkA1TMSjkWumyBKYWvMmA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216261;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=CEXAY6FI854zgRGoF4r4PjZbyhjQOwJWATqvlH3EHFI=;
	b=NheG3oU9ioAW99nXpJQZ5w+1ZeBLBW8TGFiQNioUojlwsOu71mYWvv2oi7jiSZ3FT/h/
	 goZo1AF93WJUrykwzWuOCgD0OT31CRHHiXJCWb5j2oBlp6kncTLMb8jcc45fhKrIenwog
	 e7+SGTCJ7wwd+HRZWE00ZKGc/2yneuAsDTMfA7V/ouN3TfPiHgzK7kwo2Q9wEsn6Tj8uj
	 dSVsps0rzWjee/0r75Z+YTlt0j2LiRAjhMcXLpbYVtayYIUBEcB9KDVE9OJP38AqnO1h9
	 aDUiqStHkRcJfoLAolDkDTIoh3BEP2QmPld49lIRdXpYGJWFXgBcRz8OhViJ/tq3qfQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pu+9aDKu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA48B606A31A;
	Wed, 28 Oct 2026 19:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pu+9aDKu
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793216260;
	b=Xhn6akBEiNMAHh4Yq6UkWqc5ejCCWHZaK+2G4w6M5Dr3TDIaazMKubJozbGIDOaVhg3y
	 gDwYtVFsSdMVn/W+JU7Hgsso9PuTQRw76x3ZbawV0KUvtgFbvLjs8UckU/2mY4NwThEx8
	 +u88uNc+kBdBFAjqnW+vvQTDKcfVg2BFj/VvOFP59LF41dUv6i+oqy/2Oi73ySH7rsGUo
	 PukeniKmYWmOvtbML6QJ+F9kupbQUC0kU+8O3xeecR25B8RqbFONVc7w5fh0FRM9bfzpp
	 zuwFHxiVmcxheK4si01VQu0+FiiPIncpscSDesakguRKnqK9yiAbJOuEWatBRgrJnwA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793216260;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=CEXAY6FI854zgRGoF4r4PjZbyhjQOwJWATqvlH3EHFI=;
	b=IYlVxOhNMdGn5eK9TeoSJV0KfrO0KLLBokWCuDFVM3Rr+q99gqzpKbzylGGtF1nrvsQl
	 xhnNPlXlesgo6ahpK1FXQftBE0VXTAvjsRNh7mtflU2iUCcy1M8TwuQv/UY9ejfqQagwB
	 CnbANp66NHvRndxvs6Lzzd31N1apDIFfbjjv3/E/OdRC9kJyeO99g2ULoYkxkBEODPJOF
	 c6rfcwoXJ1G14bF1iyuZMky+sykMdLkSrQnHpVND/3b2YiSkyzyQ99VaHZ9UvFjD4VdJ6
	 xl6UmZHhppO1uyD+5DM/XNX/Xy2/eNiX8n+QN4TBtAOfCKE2PruJekxTcJYZUdtumvQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 685491F031E0;
	Wed, 28 Oct 2026 19:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793216260;
	bh=CEXAY6FI854zgRGoF4r4PjZbyhjQOwJWATqvlH3EHFI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Pu+9aDKuz4XXOghLkOmuqDfiPa380a+YRg5JgbbjKWbLtly/sWI49ei7MEVhv4diT
	 iwQUnCaI8/IWnR0S/CCsxy99IQ1fyku4tpiL6QYG7j8QfAFMJno7MgXcRb8hpaDKOB
	 gn6SIaqM2YupjVKNR5yWeyeDGuwMMF7/tKZ8/LqaVeazg7yquqCLuVf8OkvhResXuT
	 CSp4r+qLgWZRyiiErslsyMummKX/76vMkazXMuC1f49weDF4GzXB+DRXJ3GE2Hv2Ys
	 stU4wexex9UP7zoutS2M/Y4TVDH0UHf0W+nRsmXIcrfGzdF+OnAPq/UY7XzpgoKWrf
	 N4TJonVKSLMQw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D72C64557F;
	Wed, 28 Oct 2026 19:37:38 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Wed, 28 Oct 2026 14:37:39 -0500
Subject: [PATCH ath-next 2/2] wifi: ath11k: advertise a spatial stream for
 every chain
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
Message-Id: <20261028-b4-ath11k-qcn907x-caps-v1-2-c7daa6f1c02c@gmail.com>
References: <20261028-b4-ath11k-qcn907x-caps-v1-0-c7daa6f1c02c@gmail.com>
In-Reply-To: <20261028-b4-ath11k-qcn907x-caps-v1-0-c7daa6f1c02c@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793216257; l=6123;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=8Uwxeg8UHngxATx0eZ4/cEVXGxe0+dvdWqlppGkOKfE=;
 b=ZpPF/FYUsE/MwMmiwn21IqxNMU7TLlxzf60JrTgfkhg3KzaxYjeAko1eP8rwUFmfscY2HG2LA
 K+MZiwC6CuqCnjVGY6jAs5SbSp7SkkO2Al2v0MgLbV/u8y2ybDyDW1H
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

ath11k counts stream i as supported only when bit i of the radio's
chainmask is set: in the HT RX MCS mask (ath11k_create_ht_cap()), the
VHT MCS maps (ath11k_create_vht_cap()) and the HE MCS maps
(ath11k_mac_set_hemcsmap()). A chainmask need not be contiguous. The
QCN9072 in an Arista C-360 reports 0x5, chains 0 and 2: it has two
chains, and ar->num_tx_chains and ar->num_rx_chains say so, but bit 1
is clear, so its HT, VHT and HE capabilities offer one stream ("2
streams: not supported" in iw phy, on 2.4, 5 and 6 GHz) and it
associates as a 1x1 client.

A radio can use as many streams as it has chains, whichever chains
they are. Count the streams up to ar->num_tx_chains and
ar->num_rx_chains, the chainmasks' weights, and take TX STBC away when
there is one TX chain rather than when the shifted TX chainmask is at
most 1. The rate-cap chainmasks that only fed these tests go. This also
ends the HE RX map's use of tx_chain_mask_shift for the RX chainmask.

With this the QCN9072 shows HT MCS 0-15 and two VHT and HE streams on
every band, and as a client on 5 GHz at 40 MHz it associated at
HE-MCS 10, 2 streams, and ran 310 Mbit/s down and 438 up to a local
server. Contiguous chainmasks get the same capabilities as before: the
IPQ8074's radios (0xf, and 0xf0 shifted by 4) are unchanged.

Tested-on: QCN9074 hw1.0 PCI fw_version 0x250affff (vendor build)
Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Fixes: ebf82988f844 ("wifi: ath11k: generate rx and tx mcs maps for supported HE mcs")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 38 ++++++++++++-----------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index af01ef1cf4c9..62c3a6a7cd20 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5556,7 +5556,7 @@ static int ath11k_mac_op_conf_tx(struct ieee80211_hw *hw,
 }
 
 static struct ieee80211_sta_ht_cap
-ath11k_create_ht_cap(struct ath11k *ar, u32 ar_ht_cap, u32 rate_cap_rx_chainmask)
+ath11k_create_ht_cap(struct ath11k *ar, u32 ar_ht_cap)
 {
 	int i;
 	struct ieee80211_sta_ht_cap ht_cap = {};
@@ -5611,10 +5611,9 @@ ath11k_create_ht_cap(struct ath11k *ar, u32 ar_ht_cap, u32 rate_cap_rx_chainmask
 	if (ar_vht_cap & WMI_VHT_CAP_MAX_MPDU_LEN_MASK)
 		ht_cap.cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
-	for (i = 0; i < ar->num_rx_chains; i++) {
-		if (rate_cap_rx_chainmask & BIT(i))
-			ht_cap.mcs.rx_mask[i] = 0xFF;
-	}
+	/* a stream for every chain, whichever chains the chainmask names */
+	for (i = 0; i < ar->num_rx_chains; i++)
+		ht_cap.mcs.rx_mask[i] = 0xFF;
 
 	ht_cap.mcs.tx_params |= IEEE80211_HT_MCS_TX_DEFINED;
 
@@ -5723,8 +5722,7 @@ static void ath11k_set_vht_txbf_cap(struct ath11k *ar, u32 *vht_cap)
 }
 
 static struct ieee80211_sta_vht_cap
-ath11k_create_vht_cap(struct ath11k *ar, u32 rate_cap_tx_chainmask,
-		      u32 rate_cap_rx_chainmask)
+ath11k_create_vht_cap(struct ath11k *ar)
 {
 	struct ieee80211_sta_vht_cap vht_cap = {};
 	u16 txmcs_map, rxmcs_map;
@@ -5742,18 +5740,18 @@ ath11k_create_vht_cap(struct ath11k *ar, u32 rate_cap_tx_chainmask,
 	rxmcs_map = 0;
 	txmcs_map = 0;
 	for (i = 0; i < 8; i++) {
-		if (i < ar->num_tx_chains && rate_cap_tx_chainmask & BIT(i))
+		if (i < ar->num_tx_chains)
 			txmcs_map |= IEEE80211_VHT_MCS_SUPPORT_0_9 << (i * 2);
 		else
 			txmcs_map |= IEEE80211_VHT_MCS_NOT_SUPPORTED << (i * 2);
 
-		if (i < ar->num_rx_chains && rate_cap_rx_chainmask & BIT(i))
+		if (i < ar->num_rx_chains)
 			rxmcs_map |= IEEE80211_VHT_MCS_SUPPORT_0_9 << (i * 2);
 		else
 			rxmcs_map |= IEEE80211_VHT_MCS_NOT_SUPPORTED << (i * 2);
 	}
 
-	if (rate_cap_tx_chainmask <= 1)
+	if (ar->num_tx_chains <= 1)
 		vht_cap.cap &= ~IEEE80211_VHT_CAP_TXSTBC;
 
 	vht_cap.vht_mcs.rx_mcs_map = cpu_to_le16(rxmcs_map);
@@ -5767,20 +5765,14 @@ static void ath11k_mac_setup_ht_vht_cap(struct ath11k *ar,
 					u32 *ht_cap_info)
 {
 	struct ieee80211_supported_band *band;
-	u32 rate_cap_tx_chainmask;
-	u32 rate_cap_rx_chainmask;
 	u32 ht_cap;
 
-	rate_cap_tx_chainmask = ar->cfg_tx_chainmask >> cap->tx_chain_mask_shift;
-	rate_cap_rx_chainmask = ar->cfg_rx_chainmask >> cap->rx_chain_mask_shift;
-
 	if (cap->supported_bands & WMI_HOST_WLAN_2G_CAP) {
 		band = &ar->mac.sbands[NL80211_BAND_2GHZ];
 		ht_cap = cap->band[NL80211_BAND_2GHZ].ht_cap_info;
 		if (ht_cap_info)
 			*ht_cap_info = ht_cap;
-		band->ht_cap = ath11k_create_ht_cap(ar, ht_cap,
-						    rate_cap_rx_chainmask);
+		band->ht_cap = ath11k_create_ht_cap(ar, ht_cap);
 	}
 
 	/* A 6 GHz capable radio may cover 5 GHz as well, as a QCN9074 does:
@@ -5793,10 +5785,8 @@ static void ath11k_mac_setup_ht_vht_cap(struct ath11k *ar,
 		ht_cap = cap->band[NL80211_BAND_5GHZ].ht_cap_info;
 		if (ht_cap_info)
 			*ht_cap_info = ht_cap;
-		band->ht_cap = ath11k_create_ht_cap(ar, ht_cap,
-						    rate_cap_rx_chainmask);
-		band->vht_cap = ath11k_create_vht_cap(ar, rate_cap_tx_chainmask,
-						      rate_cap_rx_chainmask);
+		band->ht_cap = ath11k_create_ht_cap(ar, ht_cap);
+		band->vht_cap = ath11k_create_vht_cap(ar);
 	}
 }
 
@@ -5949,14 +5939,12 @@ static void ath11k_mac_set_hemcsmap(struct ath11k *ar,
 	rxmcs_map = 0;
 	txmcs_map = 0;
 	for (i = 0; i < 8; i++) {
-		if (i < ar->num_tx_chains &&
-		    (ar->cfg_tx_chainmask >> cap->tx_chain_mask_shift) & BIT(i))
+		if (i < ar->num_tx_chains)
 			txmcs_map |= IEEE80211_HE_MCS_SUPPORT_0_11 << (i * 2);
 		else
 			txmcs_map |= IEEE80211_HE_MCS_NOT_SUPPORTED << (i * 2);
 
-		if (i < ar->num_rx_chains &&
-		    (ar->cfg_rx_chainmask >> cap->tx_chain_mask_shift) & BIT(i))
+		if (i < ar->num_rx_chains)
 			rxmcs_map |= IEEE80211_HE_MCS_SUPPORT_0_11 << (i * 2);
 		else
 			rxmcs_map |= IEEE80211_HE_MCS_NOT_SUPPORTED << (i * 2);

-- 
2.43.0



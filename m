Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793216260;
	b=q51xHZXgWYKua/eGlXutLbdRU1zbFQR+63eF51I4DbWUqLafuyy7eAXqa79KGUXBss2/
	 gzi5319qs6SVvFdTl8a2C+fyaxaQFAuRfme6oB8ctnj7wsw5MxY5g58sxo6k6xBlKgaKd
	 BEgdp+ueZqyRl7y++vkM9EOhhIYPeSmskzO6NIra0alM2+peUrGBBdzhxA5IuHE9MB9KD
	 bcXIAzKv7ND4V+vuvJXeeB9AaFH6XVYKiQotqLTG/a/EwKNiqdN+13cTY0LJx9T19vasf
	 CE3eXSaMNc8dGuMNmAlNI/fScC5wkUw0X9bcuty42vhnaXrNL+vxCfdizKDu2E/znLQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216260;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=eLlDCLSsDUwwUAgVwUhz6k7lTVTDa3zrZ/c4TXej6+A=;
	b=zor2YsI3LBw68NjTMtvm2JVF3qVSb+YF4KIvlmH8UyYx/C4rckaxtZdOwvIs5jn/AbSL
	 b+GgBn9uCaxtgXAHr7tn20GHn4O4/VYs2PICorUpjR+U9RMFmd2wDPyRMlpzcN9cPCUux
	 SIO5gAhS/v0qitmMFXk9Oi7zIXGEfx/aJJnKMz2/Yeri2IcJNeyUoTHm0zZQh1UZorx65
	 OBtqFlJXaOGBtpbPhrmQrnZQSNmqzTGBRhiRgxufP6a6+3udrfZ+3ygrtOA/65PH0e+m0
	 5rdpIZ0uhjHeY/M/ylp5siFWFCYLQ4rSA60K9kdwamNrwhtSg28CmOClrfSMvokv2Aw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ls8yLWrm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F12606A323;
	Wed, 28 Oct 2026 19:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ls8yLWrm
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793216260;
	b=A8weRGLzwnBTKdzCfOEykTLqmSRiC/fZBd/j1fpVn/Lt1L4lGton0rVHnngPR8PIXH+d
	 7Wq8pcZkvFXrubia6JsHX+py4+/yfau+OacXpU0cnoaFRyiAmaCbcWv30ldTgkOIyICKC
	 kpZIDR8kEVzarTk1gOILmk/PF0u3lBhH2x6OBdgv0lQlqYueeIxwm/lODABWXY8qr672x
	 KefenecEoOe3gu/67uCxRiChB1joHBBns4IuDc3yB1wFpSqA3heLgKefTQySZINRiP+el
	 1JI/l1Ddw8HB8mbCICJInYMtXB6+QG3z1HUqi3dZX73hotXWiVCiXsceSKmfxnCAsFg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793216260;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=eLlDCLSsDUwwUAgVwUhz6k7lTVTDa3zrZ/c4TXej6+A=;
	b=1ioApWTHYsTH/m4eEtCCZLYBpYjzkG/rAbOaOGrpdFClV2O4MRowlMXqloDtiArTURpp
	 u5COOd4d3B50I+1guX7piBskwJCItgIIYe68aW2BQuznqc3QX6isotvBtRo8Ew8Qdu88j
	 Qbwe9pko7F3FnNiPhkIeKVGN587FYOL1ZekuzBJlp6bT96AilnGX0WWS98Tx7eTypsNCN
	 l9XuIrlUDLbPA4BB0A2+jWXc0EglmJwdRXE0s/2LpVjwbdT1sFF62aYDS0Qsc80E4lsCV
	 nDbrf2YeVoj7x3J4ZsVWNGATDSTa40McOnwTB/qY3cdygaWby0d9k5VtB1ZENGr8hNQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 67F0C1F01828;
	Wed, 28 Oct 2026 19:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793216260;
	bh=eLlDCLSsDUwwUAgVwUhz6k7lTVTDa3zrZ/c4TXej6+A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Ls8yLWrm/d3LkJL41zaATBG6u5sMTgkL1IA5S1wQWJ+3qysum7WQ3jIlwgBYoxOpQ
	 h0t9Y7LAcYgoQ7KMYuV5JTd1tSTzrMLCIV44Pxpt3Wc6SfVT2crKgXhu566Ii8U1My
	 2x6ERUCZOFmt42U1iMp1RUJURZUcAdt+cYtNOiiyKpkIzwVEDi+Zah4Rnc51TBCl8N
	 2n+COppWWQRKGCUzQp52D2hHbyobPqVrrs3j4oc9RQwZg708bkUzSt04vpsgI9TAVE
	 5HnCnk35kq5PbT5/agQUfkWeBAC7AqQxAfmPWS00T45HdG5T+XZjdV9+nD7nfo9wcj
	 ngPIakN8W8PEw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CC1714554D;
	Wed, 28 Oct 2026 19:37:38 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Wed, 28 Oct 2026 14:37:38 -0500
Subject: [PATCH ath-next 1/2] wifi: ath11k: give a 6 GHz capable radio's 5
 GHz band HT and VHT
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
Message-Id: <20261028-b4-ath11k-qcn907x-caps-v1-1-c7daa6f1c02c@gmail.com>
References: <20261028-b4-ath11k-qcn907x-caps-v1-0-c7daa6f1c02c@gmail.com>
In-Reply-To: <20261028-b4-ath11k-qcn907x-caps-v1-0-c7daa6f1c02c@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793216257; l=2244;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=LoAHMWFP0FpoZiJJt9l8o390qNJjKYVd9pyVzPAa5+I=;
 b=LaMXa7wTct2ML3K347ffAKeqcWaIx8xIkvSSAAFcymjA4tghkB2xpTuw0BXQTYP4mnlg4dP5s
 cVJmPgCg+uuCOnny7j6z8FNw70jcdC/4ULuECpWYhb/nXflKovoOn27
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

ath11k_mac_setup_ht_vht_cap() sets the 5 GHz band's HT and VHT
capabilities only for a single_pdev_only device or a radio that does
not support 6 GHz, on the understanding that a QCN9074 covers 6 GHz
only. A QCN9074 can cover 5 GHz as well: ath11k_mac_setup_channels_rates()
then registers its 5 GHz band too, with HE capabilities
(ath11k_mac_setup_he_cap() sets HE for any 5 GHz capable radio), but
without HT and VHT. mac80211 can't use HE on 5 GHz without them, so on
that band the radio uses legacy rates only. On an Arista C-360, its
QCN9072 (which takes the QCN9074's hw_params) associated to an 802.11ax
AP on 5 GHz at 24-54 Mbit/s with no MCS, and `iw phy` showed its 5 GHz
band with HE capabilities and no HT or VHT ones.

Give the 5 GHz band HT and VHT whenever it was registered with channels,
which ath11k_mac_setup_channels_rates() does before this runs. With
this, the QCN9072's 5 GHz band shows HT (HT20/HT40) and VHT in `iw phy`.

Tested-on: QCN9074 hw1.0 PCI fw_version 0x250affff (vendor build)
Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: 22eeadcdeab6 ("ath11k: add support for 6GHz radio in driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1a237adaa37d..af01ef1cf4c9 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5783,9 +5783,12 @@ static void ath11k_mac_setup_ht_vht_cap(struct ath11k *ar,
 						    rate_cap_rx_chainmask);
 	}
 
+	/* A 6 GHz capable radio may cover 5 GHz as well, as a QCN9074 does:
+	 * its 5 GHz band, where one was registered, needs HT and VHT as much
+	 * as any other radio's.
+	 */
 	if (cap->supported_bands & WMI_HOST_WLAN_5G_CAP &&
-	    (ar->ab->hw_params.single_pdev_only ||
-	     !ar->supports_6ghz)) {
+	    ar->mac.sbands[NL80211_BAND_5GHZ].n_channels) {
 		band = &ar->mac.sbands[NL80211_BAND_5GHZ];
 		ht_cap = cap->band[NL80211_BAND_5GHZ].ht_cap_info;
 		if (ht_cap_info)

-- 
2.43.0



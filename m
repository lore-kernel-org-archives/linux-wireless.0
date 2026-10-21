Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792601501;
	b=fBhcN7B1B1ftPSIBAXtYfNs/E4+9bFUWevLn00TQmAShynKFc1tgfFFJnSE+eItajLIA
	 8gOr4xOLFnR+UXopAECv2WU2SvCsBjCleP2ok0xxV64OBwaNB0OpVeIsJmN96S4LXl5E3
	 xrzQ+CRSPoQVH6fQlE4FMYaI9Y0Y3vuITzByVJT+lFH3irX/LBO3eAlGneqEucNWAT/Rk
	 SqOZQMddWPF705/OVBe+3pWaHCxZR2e3BEtNA2ZPZvxliO0bWADn2LrCuh0b9StMnOO9E
	 1DcJae9HEhM9ahS3xQv98BUrBh7x1PtMJIbk+s/m0C0iGsNgAs1qWH+vzY8oHq3NVOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792601501;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JXmyT257j9HWX6yMLjeKjbshvliT1svS1XMIFan8Qm4=;
	b=ZLm3E1Q+Ov9yK7OSPiEBXDYr5ZZ745ipaWRI471M7TBy1KimenI3wcrcz38uJ2ZBbIom
	 nujqKouO1o/Y2bG2+ExHJGn+zgp/H5KRYPUKZ9yjCQ4INpCuxafJKtr59QGvAleYpOkgI
	 HeS/RHfMvfmVQOLK2DjGnJiADIbl3LtPnFJKY3Was3wgmdkKBY4FU1Z7dW1e8yhZV8lnB
	 5TOENcHTjou9gV3a9UCCvE9fUTumEAbD5GWLDo61VAOdDRftOXRegDY9/ThW55RSnG4hR
	 x+EHTX6x2t2makKJR92mf0fp7HTSDI244FZ7rtn4TJi9oPlFeGJbT9sRzFvKCCxpHJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=Fcqs1HXQ;
	arc=none smtp.remote-ip=209.85.218.42
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3969C606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 16:51:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3969C606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=Fcqs1HXQ
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4086e892a4so123253666b.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792601499; x=1793206299; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JXmyT257j9HWX6yMLjeKjbshvliT1svS1XMIFan8Qm4=;
        b=Fcqs1HXQv/0AOgsatOoGMIw6g+PWVptDcac7+4vPArKNLCTWsraViSb4DtdH1our1r
         ombs/gBCSOiOzumu3qigHVtwMMSKucB2iNT6ih7DjHRwCnAWAQnKovYziRp+1XA3LFzw
         L8Dj3O6LXk66X78aggc2Q9KQR7vN4Cgi8irULe7XY38oIFsxHYphNuy0FQqjpA7GZQPA
         KInCx4+95tO6NLUAapSTlDQbzdGXwpKRcy4GcTrH8aBtlFktOcfB6/SjAZxQ96P1C+Zb
         T1xx/zlDEh8w/A6MnkhKNspV4KuChAn9lf7iV2jWaCfyHFtvOIpszOvWhuAIQHXAAVYu
         RKkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792601499; x=1793206299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JXmyT257j9HWX6yMLjeKjbshvliT1svS1XMIFan8Qm4=;
        b=lZmNTT+Q3t8g8BTKA3BTMTQ0zAFvIquF+LkSWmtR2JUgOguFk+JyujNBifBVa/nGP5
         q1Jz7UGP0goYOgT5rXmHi8RWuwiuh3miOHy44La5xkyKxtS0QcJHKe6BwQNPGTuDRIOH
         HS2ZJAEBZ0iLVbqH2lNpvVm1olau5NpjUkYNDWgm0TliEA/Gb7AjBDHbxZuQfNSLdIMy
         WFeLW0e1rj8bRlFXHtALAth5t1k1uSNghYLMpoOBUwc4GmDdNyhh7QEuuwTt/UKiVOFV
         +28uBp4YdL9+7L/miNbeql1MR/RZvEyosIQVeewqTSojeM1T9JkihRL0SPII5/noCZpN
         Efjw==
X-Forwarded-Encrypted: i=1; AKwUvByuap+vx7uK2jbdO5tiZJD9BO/f+gnNHIPon/DZkvMTUognFgUqOAjHF1+IY2r4xhFKr55Lg0WXQQUl88/syw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKBtOryei0LNp/Mm0h2U2uVqrM9i5nrgVpuOZcX+xffeTalCtcI
	jkkMas17woJdL0fs4pm/UFO2vZJfDPYTEMAlUp9h56RD4nHjozY2dYgqBxi90pZa5A==
X-Gm-Gg: AYBFou0nEQcZmdSSAVpAf8WurmznzD37xFHWfYYd4gZKTZRMcx3C1jGptPnu/Bk6eD2
	n2vORMDkjA288IS4NjGESRw4DQnH76Gkrvm3tHFH5Kgk8QvGue2Kd6pU0ffkqyeSUSjewtqWpXH
	8/OPa99nQ84lIpQryHL7GdZ5H/h72KQgAmdp4Ui14YN5dApx9ZznNOnpiagIHWYn/9zamUh3tUl
	MZyZh/hKjPk6/u0ak7CtyyOsEii6jkC35PysWKewaBfLsy2UEvIROm15kihKvWSQIqiTuQXiX7Z
	VwXc1vJnMl4uxcXUYsllXuZ6oX0bZohcRuR3wSd1wU6WSJDjmEDkhW5BE2PbiEXetORLLHzUqNz
	LYhbWLcnYWyxRsTmGnkrbunKigl1s3CFvBMKK/8MeYtAL11VUjUeGXYxPvgvUggW5IMCK6OQ3oR
	APFvUeM3oQOux3fDV2PoW2gA26mYM8ZcZJp6X/kY9e4AH793Qe7VCxL3WmGjJaI8ieedAiHSjsU
	WLmSmQk1n0nibmZPtmMf/VfK4hNX7ylDSlQH10cFJmsVDFw2xqu7HzDZOabwOPQKZJCTPOU4Zu7
	mL6FwQo3gNnJ3GsiJYInuEqZhyyzJWkFHpPHuj27rqWRpFXUk0nyKxiroKFZE9FxKSIq9fehxHc
	xUQBVGyhR1tqOvzFqRJmJARaR9o/tURMJFPHrZ4XJiJlTh/EQKnjV/ACv4t64+NfusJdITNMNix
	D3JGGqhYGMS305ez/JYjjY+HxtQ3RDR9dLosGePWBjWZl26mW5qlH+l0huULSKetms
X-Received: by 2002:a17:907:9604:b0:c29:555e:bf2 with SMTP id a640c23a62f3a-c46799c8dc9mr242364766b.41.1792601499598;
        Wed, 21 Oct 2026 09:51:39 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.223.169])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c468a5de48esm20782466b.66.2026.10.21.09.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:51:39 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: rameshkumar.sundaram@oss.qualcomm.com,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/2] wifi: ath11k: apply the 160 MHz NSS ratio to the radio
Date: Wed, 21 Oct 2026 18:51:37 +0200
Message-ID: <20261021165138.388593-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021165138.388593-1-julius@bairaktaris.de>
References: <20261021165138.388593-1-julius@bairaktaris.de>
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

The firmware reports the NSS a radio supports at 160 MHz as a ratio of
its 80 MHz NSS. Peer assoc applies that ratio to the peer's NSS instead,
so on a radio with a 1:2 ratio a two-stream peer is sent one stream at
160 MHz. The HE 160 and 80+80 MCS maps copy the 80 MHz map, so a
4-chain radio with that ratio offers 4 streams at 160 MHz where it
supports 2.

Take the 160 MHz NSS from the radio's TX chains, as ath12k does since
commit a82ce08775bc ("wifi: ath12k: add extended NSS bandwidth support
for 160 MHz"), and limit the 160 and 80+80 MCS maps to the ratio when
the firmware reports one.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: f552d6fd2f27 ("ath11k: add support for 80P80 and 160 MHz bandwidth")
Assisted-by: LLM
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/mac.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1a237adaa37d1..a842306d65d9c 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2278,7 +2278,7 @@ static void ath11k_peer_assoc_h_vht(struct ath11k *ar,
 
 	if (arg->peer_phymode == MODE_11AC_VHT160 ||
 	    arg->peer_phymode == MODE_11AC_VHT80_80) {
-		tx_nss = ath11k_get_nss_160mhz(ar, max_nss);
+		tx_nss = ath11k_get_nss_160mhz(ar, ar->num_tx_chains);
 		rx_nss = min(arg->peer_nss, tx_nss);
 		arg->peer_bw_rxnss_override = ATH11K_BW_NSS_MAP_ENABLE;
 
@@ -2588,7 +2588,7 @@ static void ath11k_peer_assoc_h_he(struct ath11k *ar,
 
 	if (arg->peer_phymode == MODE_11AX_HE160 ||
 	    arg->peer_phymode == MODE_11AX_HE80_80) {
-		tx_nss = ath11k_get_nss_160mhz(ar, max_nss);
+		tx_nss = ath11k_get_nss_160mhz(ar, ar->num_tx_chains);
 		rx_nss = min(arg->peer_nss, tx_nss);
 		arg->peer_bw_rxnss_override = ATH11K_BW_NSS_MAP_ENABLE;
 
@@ -5940,7 +5940,7 @@ static void ath11k_mac_set_hemcsmap(struct ath11k *ar,
 				    struct ieee80211_sta_he_cap *he_cap,
 				    int band)
 {
-	u16 txmcs_map, rxmcs_map;
+	u16 txmcs_map, rxmcs_map, txmcs_map_160, rxmcs_map_160;
 	u32 i;
 
 	rxmcs_map = 0;
@@ -5958,18 +5958,28 @@ static void ath11k_mac_set_hemcsmap(struct ath11k *ar,
 		else
 			rxmcs_map |= IEEE80211_HE_MCS_NOT_SUPPORTED << (i * 2);
 	}
+
+	txmcs_map_160 = txmcs_map;
+	rxmcs_map_160 = rxmcs_map;
+	if (cap->nss_ratio_enabled) {
+		for (i = ath11k_get_nss_160mhz(ar, ar->num_tx_chains); i < 8; i++)
+			txmcs_map_160 |= IEEE80211_HE_MCS_NOT_SUPPORTED << (i * 2);
+		for (i = ath11k_get_nss_160mhz(ar, ar->num_rx_chains); i < 8; i++)
+			rxmcs_map_160 |= IEEE80211_HE_MCS_NOT_SUPPORTED << (i * 2);
+	}
+
 	he_cap->he_mcs_nss_supp.rx_mcs_80 =
 		cpu_to_le16(rxmcs_map & 0xffff);
 	he_cap->he_mcs_nss_supp.tx_mcs_80 =
 		cpu_to_le16(txmcs_map & 0xffff);
 	he_cap->he_mcs_nss_supp.rx_mcs_160 =
-		cpu_to_le16(rxmcs_map & 0xffff);
+		cpu_to_le16(rxmcs_map_160);
 	he_cap->he_mcs_nss_supp.tx_mcs_160 =
-		cpu_to_le16(txmcs_map & 0xffff);
+		cpu_to_le16(txmcs_map_160);
 	he_cap->he_mcs_nss_supp.rx_mcs_80p80 =
-		cpu_to_le16(rxmcs_map & 0xffff);
+		cpu_to_le16(rxmcs_map_160);
 	he_cap->he_mcs_nss_supp.tx_mcs_80p80 =
-		cpu_to_le16(txmcs_map & 0xffff);
+		cpu_to_le16(txmcs_map_160);
 }
 
 static int ath11k_mac_copy_he_cap(struct ath11k *ar,
-- 
2.53.0


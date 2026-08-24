Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218F33876C5
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601184; cv=none; b=jolMee9WXhpo73zTOjw+FawBTbnjZSdhH6ttoNUKIfWsI1+qix87Iks8hk6zUAYMQJdygLOhpv3Zb9DaTEBcVBvSBs3009zkrzObiE/F2UGTwN/S5hiABLMlE4lj0hWo+lkwMyo9rQynQyEqmTo4JYJ18fEaW+lkdInY4VWZ21Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601184; c=relaxed/simple;
	bh=pSAuMaUkasmSFVSiJnweP1Om/vjA3nJ4XxgzUekp+kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mS9tHBIAXMUfYw17i6EhxP04UTrTjzYHZpmM3CTNpts/bYAD9Rpnoy+jIR2f69zVvvoFi1G49q0bq7/8KR2PyKC7v2SCGNFY+WGcEKryeYm0CyhjzIiCCv+UxihhEkAsQrKEA049WmNHWmlNCibYX4eQAU8xMh45hxWEqOkxokI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-45eddb6fdccso2167944fac.2
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:53:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601182; x=1788205982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TeonRlP0AmNpIWgR3zOOTFzTXc3/eUo2hUs/hJhA6L8=;
        b=dLlfQGJ7MXyV4oUyZ4OumQGyjUROew6hTmDWryBEKQWj1TSvOcTFG0u78ZryaFdMoR
         bRxBqnXAkej5w8LcRqK6oE/L+Gyi6dmkApBdF/rgR3Gb2DtiymSZ7VpYAQQdEXzJ+WN5
         SsmOBBKxYFx1Z3UqqIcl7ljbXoXE3czKE+Vafob/hQ14IsJ9K8HcTslPupyPO79PUs2S
         02D5YGlCq63oF6rCmI2f6yb2Rf5AYLoN7qAWbdsRY1MU8h3/QAVII45Ybtp5rNf4Qe5P
         IPMV5Q9IE4L/xvORB7k23vlMGf3WoWeGcI9Hbamouzd8JzmYyXT0j1UB6KtGGkF92fYH
         6SNA==
X-Gm-Message-State: AFuF++lxIxP8WWh/NFM8KrDGW1+3IgaOozwsit7pq9IiqS5APNMaeAzK
	dgyG1NTn9h5Vbk83ujudY+JkMRS5/u5EOBWrODZQBgb3mJB7KSbBS4A7
X-Gm-Gg: AR+sD13602+EnzwuFVlOtO08alz5q4D4Dlg2lxM2DQHzbDPae2kctSEanPL3hCvCYf3
	usuoqVAx+UT8ayzGU9lATNcQoyAEikkfFLvl9S2LZ/tRq3+PDPCfrvwIRYJENcKJcKjdJ9EqmiL
	qpd0NmQnqMs+UAieYjodo+KB8dwZynebaFIZqEO+zQ6hHmGDj6PIW+8qzFMj7X7mBo8y+o1OWHf
	ON4Z9e0LK28Ac8jSvb8FqciFobQQ01qX95lDa/fVMAnbtRIbGQ81oc/khHI6s9i034AG4IR/tuM
	tSVLFZuHRb7uPslXA1o/N2BdyVB/xi1dc2gI/6fFhkq1JbnK2FEIVnPQYU7CDagEd5T8t1ed1u7
	QR1KdmrgVDCgnOom8NcA2o/UiyOctE/nL8ZpwxTHQ+qy2COJQ4YhuiVOHPYeShh0fcVvYwhH1h0
	FQnrQctYy6DVnQSS26OfYj8RWjzTk7HSxtd+Vg9QTNAe1FNxJvdWMwVrZUjEL6O9LLy728BUnIu
	kdXo8m3EKlCQH1QSedVSlF9+cLyZZW9Bn5fnYq4KyDpswNibz2zrDT7Axz3
X-Received: by 2002:a05:6870:ab8b:b0:435:16e9:f288 with SMTP id 586e51a60fabf-4644b59067cmr1615297fac.20.1787601181803;
        Mon, 24 Aug 2026 12:53:01 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:53:01 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 03/15] wifi: mt76: mt7925: fix NAN committed CRB timeline layout
Date: Mon, 24 Aug 2026 14:52:15 -0500
Message-ID: <20260824195227.12589-4-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260824195227.12589-1-sean.wang@kernel.org>
References: <20260824195227.12589-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stella Liu <yu-ching.liu@mediatek.com>

The committed CRB timeline carried a local_map_id byte that does not
exist in the firmware NAN_SCHEDULE_TIMELINE_T layout (map id plus 3
reserved bytes), shifting the availability bitmap. Drop it and match
the firmware structure.

The common-slot check is also dropped as redundant: mac80211 already
tracks common slots, so avail_map is built directly from the peer
schedule.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 37 ++++++-------------
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |  3 +-
 2 files changed, 12 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index ba7374fb7c03..e51e91f08b49 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -753,52 +753,38 @@ static int mt7925_nan_peer_cap_tlv(struct sk_buff *skb,
 
 static void
 mt7925_nan_fill_crb_committed(struct mt7925_nan_sched_update_crb_tlv *crb_tlv,
-			      struct ieee80211_vif *vif,
 			      struct ieee80211_nan_peer_sched *sched)
 {
-	struct ieee80211_nan_sched_cfg *local_sched;
-	u8 local_map_id;
 	u32 m, slot;
 
-	if (!vif || !sched)
+	if (!sched)
 		return;
 
-	local_sched = &vif->cfg.nan_sched;
-	local_map_id = mt7925_nan_avail_attr_ctrl(local_sched) &
-		       NAN_AVAIL_CTRL_MAPID;
-
 	for (m = 0; m < CFG80211_NAN_MAX_PEER_MAPS &&
 	     m < NAN_TIMELINE_MGMT_SIZE; m++) {
+		struct ieee80211_nan_peer_map *map = &sched->maps[m];
 		struct mt7925_nan_sched_timeline *tl =
 			&crb_tlv->comm_faw_timeline[m];
-		struct ieee80211_nan_peer_map *map = &sched->maps[m];
-		u32 avail_map = 0;
 
 		if (map->map_id == CFG80211_NAN_INVALID_MAP_ID)
 			continue;
 
 		tl->map_id = map->map_id;
-		tl->local_map_id = local_map_id;
 
+		/*
+		 * Convert peer schedule slots to FW avail_map bitmap.
+		 * Each bit in avail_map[0] represents one time slot where
+		 * the peer has committed availability.
+		 */
 		for (slot = 0; slot < CFG80211_NAN_SCHED_NUM_TIME_SLOTS;
 		     slot++) {
-			struct ieee80211_nan_channel *local_ch;
-			struct ieee80211_nan_channel *peer_ch;
+			struct ieee80211_nan_channel *ch = map->slots[slot];
 
-			local_ch = local_sched->schedule[slot];
-			peer_ch = map->slots[slot];
-
-			if (!local_ch || !local_ch->chanctx_conf ||
-			    !peer_ch || !peer_ch->chanctx_conf)
-				continue;
-
-			if (local_ch->chanctx_conf != peer_ch->chanctx_conf)
+			if (!ch || !ch->chanctx_conf)
 				continue;
 
-			avail_map |= BIT(slot);
+			tl->avail_map[0] |= cpu_to_le32(BIT(slot));
 		}
-
-		tl->avail_map[0] = cpu_to_le32(avail_map);
 	}
 }
 
@@ -824,8 +810,7 @@ static int mt7925_nan_update_crb_tlv(struct sk_buff *skb,
 	crb_tlv->is_use_ranging = false;
 	crb_tlv->comm_ndc_ctrl.is_valid = false;
 
-	mt7925_nan_fill_crb_committed(crb_tlv, msta->vif->phy->dev->nan_vif,
-				      sta->nan_sched);
+	mt7925_nan_fill_crb_committed(crb_tlv, sta->nan_sched);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index 91f4e999711e..fab10b829eaa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -348,8 +348,7 @@ struct mt7925_nan_sched_update_peer_cap_tlv {
 
 struct mt7925_nan_sched_timeline {
 	u8 map_id;
-	u8 local_map_id;
-	u8 reserved[2];
+	u8 reserved[3];
 	union {
 		__le32 avail_map[NAN_TOTAL_DW];
 		u8 avail_block[NAN_TOTAL_DW * 4];
-- 
2.43.0


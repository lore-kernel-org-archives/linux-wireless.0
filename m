Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5102BD022
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601209; cv=none; b=kcvXO5BEpmt+ozB48hpWuP6X+NKGbqOiaSanD3+pMuVQff1L5jh2/RmcESH8DT/scWjOATEfnYzauY6wkKKsPpQr+UCsLskotC3zytJ0FSCMHdVBWvT6YD/5+VyYDbyT3+Khi4iNDj4aw56pVwjr7Ry6SMm/TjiBOJTBxSzvXos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601209; c=relaxed/simple;
	bh=G/2y59g8/itHAj02PUDDEXsK8NWa6tMl+IuE4WDTAGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPWT9jEAuZ3Bg0SQxBFwE3RwK0ycrqvO1XKqz5kTvbdb6nAJIfr4GOco6b1Q/ZB0iAWAeiN8iZlnbARprRGHzZhspmB12RtwnVxIAgFKNajhlwaFScJJ915zRg6y76Lt6kV5vhhgla2oV8nqKsu3Nha653cLdCaE1z71PqwMj0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-4472500e25fso2853658fac.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:53:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601207; x=1788206007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JJzjnsYLL4UwomFHEFbRiMkzuuEN73DtDLFwq3zURGc=;
        b=aLJluOhlZLC7iM1blpQrkqfKLInGHgvLLUw5p/G5tFL0t3LymlN54MvyfrMbdsP0xI
         ecEm5XhWQ3Oa6bfDX0naQDhT7LQ+1Rx4a1XF+cV4f3R4ltt/uZoZ5uYVvDfVDzZjbmY9
         Wj1Cc/22NEC8fHkTLRaA1eGvKo+SfIAsoN3QUOR2p8sxBKEbB9Id0j40SYyqAoGcI5v4
         q4Rd/qcSQS/06OacFAtidBuW3QrkCWhVU1BglLnOHqjKWv7m9KMXaewVBjdq6l1xmKz5
         yWTxYL5ecKagZn7SlWcgUYeYys74zntjJSc4NFJTZaijRRqZcKnv8v7YJxNhJJ9kJItt
         zPqA==
X-Gm-Message-State: AFuF++n5pXfogSnVAkOGj5oOM/MpSaratJpI5Gb9kx7zVcUbGONiKBMm
	qrbLFDrcYriIFUMc6xUH3o6+0pu97po/44Ow5If0V7MHNGjyKWulyRcg
X-Gm-Gg: AR+sD12DQz1JXLLI8W5ciQYJuyotY9saC8IGgC/juvhnhIQQgQ/Nc5R+mBfjTcs0iNw
	y0FKUv7u9Ez56Jk8Wwo2m/mkZQve1/i9qh/ALqJrJu1sqpyVQ+IaGG/SymM8BEitjA9aEWhH0WZ
	EAkR1J2CY8DELt9nFWat0eyIxpDCi3oHg2D3LiHZk5GJN6S9JtjFfIT5JMIXHHGXtcnRkEPJS+p
	rNzhsfSeKmRp64zfNGmzuakhoFB8Ws/t7867twP2ObQMNwNnpW1MJ1FceB+WlFkfpZKz3RPFsID
	dwYKt+yciKC21XwdZWIFmHrWSmE6oc3zW5VUrvTdGL4UIM/BpTNxZ4SSXLbEVUGWvo+65ZDsZBn
	zs1kj6ohqeOXYDCRsYAd3hDUkyAdf0sTIMxPmI380lr9J2nfoqy95lwLHX4YYFcoMW0IVkRttnT
	TajMUditb1MCGI/PiGP1XCs9HHLLwSRkZIXjmD4VWEHPj0bAjkw6d4oI1LNaPONlFCwORLgNgBr
	nlaomjw1g6iqUF0+lk1ubxCv8eT+x99eNlPJRQPUItR
X-Received: by 2002:a05:6870:469f:b0:457:4470:96e2 with SMTP id 586e51a60fabf-4637fd74442mr20423477fac.12.1787601207417;
        Mon, 24 Aug 2026 12:53:27 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:53:26 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 10/15] wifi: mt76: mt7925: fill all DW intervals in NAN avail_map
Date: Mon, 24 Aug 2026 14:52:22 -0500
Message-ID: <20260824195227.12589-11-sean.wang@kernel.org>
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

Fill avail_map for all DW intervals instead of only DW index 0.
FW requires the bitmap to be set across all 16 DW intervals for
correct NAN scheduling. Without this, NDP ping latency is extremely
high (~200ms) because FW only schedules data in the first DW interval.

Also set ch_type = 1 for new channel entries to indicate
channel-based (non-band) availability.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 27 ++++++++++++++-----
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |  3 +++
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index fc105e48eaca..4a1f80fac1b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -491,9 +491,14 @@ static u32 mt7925_nan_slot_to_bitmap(struct ieee80211_vif *vif,
 
 			if (FIELD_GET(NAN_CH_CTRL_PRIMARY_CH, raw) ==
 			    slot_chan->chan->hw_value) {
-				u32 map = le32_to_cpu(ch_list[j].avail_map[0]);
+				u32 dw;
 
-				ch_list[j].avail_map[0] = cpu_to_le32(map | BIT(i));
+				for (dw = 0; dw < NAN_TOTAL_DW; dw++) {
+					u32 map = le32_to_cpu(ch_list[j].avail_map[dw]);
+
+					ch_list[j].avail_map[dw] =
+						cpu_to_le32(map | BIT(i));
+				}
 				le32_add_cpu(&ch_list[j].num, 1);
 				is_found = true;
 				break;
@@ -501,12 +506,18 @@ static u32 mt7925_nan_slot_to_bitmap(struct ieee80211_vif *vif,
 		}
 
 		if (!is_found && num_channels < NAN_TIMELINE_MGMT_CHNL_LIST_NUM) {
+			u32 dw;
+
 			ch_list[num_channels].ch_info =
-				cpu_to_le32(FIELD_PREP(NAN_CH_CTRL_OP_CLASS,
+				cpu_to_le32(FIELD_PREP(NAN_CH_CTRL_CH_TYPE,
+						       NAN_BAND_CHANNEL_ENTRY_LIST_TYPE_CHANNEL) |
+					    FIELD_PREP(NAN_CH_CTRL_OP_CLASS,
 						       slot->channel_entry[0]) |
 					    FIELD_PREP(NAN_CH_CTRL_PRIMARY_CH,
 						       slot_chan->chan->hw_value));
-			ch_list[num_channels].avail_map[0] = cpu_to_le32(BIT(i));
+			for (dw = 0; dw < NAN_TOTAL_DW; dw++)
+				ch_list[num_channels].avail_map[dw] =
+					cpu_to_le32(BIT(i));
 			le32_add_cpu(&ch_list[num_channels].num, 1);
 			ch_list[num_channels].is_valid++;
 			num_channels++;
@@ -681,17 +692,19 @@ mt7925_nan_fill_crb_committed(struct mt7925_nan_sched_update_crb_tlv *crb_tlv,
 
 		/*
 		 * Convert peer schedule slots to FW avail_map bitmap.
-		 * Each bit in avail_map[0] represents one time slot where
-		 * the peer has committed availability.
+		 * Each bit represents one time slot where the peer has
+		 * committed availability. Fill all DW intervals the same.
 		 */
 		for (slot = 0; slot < CFG80211_NAN_SCHED_NUM_TIME_SLOTS;
 		     slot++) {
 			struct ieee80211_nan_channel *ch = map->slots[slot];
+			u32 dw;
 
 			if (!ch || !ch->chanctx_conf)
 				continue;
 
-			tl->avail_map[0] |= cpu_to_le32(BIT(slot));
+			for (dw = 0; dw < NAN_TOTAL_DW; dw++)
+				tl->avail_map[dw] |= cpu_to_le32(BIT(slot));
 		}
 	}
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index b03b909a98d2..32e2e9cfffc7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -117,12 +117,15 @@ enum nan_peer_supported_bands {
 	NAN_SUPPORTED_BN_NUM
 };
 
+#define NAN_CH_CTRL_CH_TYPE		BIT(0)
 #define NAN_CH_CTRL_OP_CLASS		GENMASK(15, 8)
 #define NAN_CH_CTRL_PRIMARY_CH		GENMASK(23, 16)
 
 #define NAN_CRB_USE_DATA_PATH		BIT(0)
 #define NAN_CRB_AVAIL_6G_FORMAT		GENMASK(2, 1)
 
+#define NAN_BAND_CHANNEL_ENTRY_LIST_TYPE_CHANNEL	1
+
 struct mt7925_nan_social_ch_scan_params {
 	u8 dwell_time[NAN_MAX_SOCIAL_CHANNELS];
 	__le16 scan_period[NAN_MAX_SOCIAL_CHANNELS];
-- 
2.43.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793953816;
	b=RJXEpK+Sb4pd1OCovbQoGvgSFUP62FEYnNiAOysDL4Xyat/nTgm6q/it/UkFB49uzgzJ
	 nZeJwJiefCaPxXNk7lnTEpzI3oK/+sfrMrYJ/E8i8bv8ywNtSyDAlKDArsnVZl/Q6GYQO
	 JuS3ntGJiJMlRzy0AblnjRHQ+tiJGaRlY5YlqZAEo/ouEWDU7rBSDtnBljG0x61yFfh2v
	 n/DI0HSRjuh24dDHKICo6uZ9sSIeRyfjBImd80PRdxftNw3BrAfuC0oiYJLX6blvQ5uYl
	 eS1qworPiNhTKznw0fPVMHMkbKTdS0h1+EO8787vJbRlzWuWRMm5LY+r/3KDo4i7B1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793953816;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-MTK;
	bh=JS8yH/i3xsdkIIV8v8lsztk3i1DNBKfNBzKmg56OxCQ=;
	b=LT/d1THbfHPPhbBoYqpgbzcI7turoZkw0YjJuaYttMZwe0yei+lSsdCEjZAo6Cy7uSyH
	 2Ffx5biT4zuMud8lvR3TI9jY958c0/DMOebGJhlpRzktE3sJiCV9wmWEL+uC7GOAHWknG
	 +1HaXFVqFDILQ4YOWT3f6/b57rX8DlZruAsFn67KqAgsUDJBn7cZXISzNoOk6B/Qn2YLD
	 /mnz6tVldtukRXq4yoqWOR8uhppbrzrFIUomQb+arprR94yeOe94amQcRA4rOF1cNOMR3
	 1qw5OJf07RKmBqKAzwPTw+sg4HeNoIVgkR04c5mFF6fsTCGZFdi3Rar/66OPlr8smnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=LMgMR4d4;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E113F606A334
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:30:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E113F606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=LMgMR4d4
X-UUID: 4746a7a0d9bc11f18dc8c9802ae25ab1-20261106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=JS8yH/i3xsdkIIV8v8lsztk3i1DNBKfNBzKmg56OxCQ=;
	b=LMgMR4d43PtH2P8ZUEDiJlzyR34Wulx5VGt7mNmwWPmybY+Ppt8oR8aV/jVKGJE5NQ34k7r7m4HEaesa8jUL11T66Ltr8UMLE7H30v3Wuf600v+UTDdWOxAem4XA4ewaVgFE7FxdTbHjSltP4feRhuYYbkcLvjr5FXOxycYWl5E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:c8030951-cd03-4a74-a9b8-1c2f3efb4d2a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:4ce574bb-4006-44bb-949c-6e25a7b8dad4,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4746a7a0d9bc11f18dc8c9802ae25ab1-20261106
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <james-ly.huang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1492019320; Fri, 06 Nov 2026 16:30:09 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 6 Nov 2026 16:30:09 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 6 Nov 2026 16:30:09 +0800
From: James-LY Huang <james-ly.huang@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<sean.wang@mediatek.com>, <jb.tsai@mediatek.com>, <kun.wu@mediatek.com>,
	<James-LY.Huang@mediatek.com>, james-ly huang <james-ly.huang@mediatek.com>
Subject: [PATCH v2 2/9] wifi: mt76: mt7925: bound P2P off-channel mgmt TX lifetime
Date: Fri, 6 Nov 2026 16:29:57 +0800
Message-ID: <20261106083004.3156085-3-james-ly.huang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20261106083004.3156085-1-james-ly.huang@mediatek.com>
References: <20261106083004.3156085-1-james-ly.huang@mediatek.com>
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
Content-Type: text/plain
X-MTK: N

From: james-ly huang <james-ly.huang@mediatek.com>

A P2P GO's Probe Response is only useful while the requester is
still on the listen channel: give it a short TX lifetime and a
small retry limit, and arm the TXD timestamp, so a response that
cannot get on air in time is aged out by the HW instead of going
out long after the requester has left.

Bound an off-channel P2P mgmt frame to the dwell window it was
queued for: program the lifetime from whatever is left of the
granted ROC interval, and aim the expiry MT7925_P2P_OFFCHAN_TXS_MARGIN_MS
short of its end so the TX status still reaches cfg80211 while it
waits on the cookie. Both live in p2p.c behind
mt7925_p2p_txwi_override(), which mt7925_mac_write_txwi() calls
last so the more specific lifetime wins.

Signed-off-by: james-ly huang <james-ly.huang@mediatek.com>
---
v2: no change
---
 .../net/wireless/mediatek/mt76/mt7925/mac.c   |   2 +
 .../net/wireless/mediatek/mt76/mt7925/p2p.c   | 197 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/p2p.h   |  31 +++
 3 files changed, 230 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 6e67ef3c52fa..577463af74b3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -865,6 +865,8 @@ mt7925_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 
 		txwi[3] |= cpu_to_le32(MT_TXD3_BA_DISABLE);
 	}
+
+	mt7925_p2p_txwi_override(dev, txwi, skb);
 }
 EXPORT_SYMBOL_GPL(mt7925_mac_write_txwi);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
index 12d6eee8ce10..5dad902a0446 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
@@ -21,6 +21,203 @@
 #include "mcu.h"
 #include "p2p.h"
 
+/* ------------------------------------------------------------------ */
+/* TX: TXD overrides                                                    */
+/* ------------------------------------------------------------------ */
+
+/* DW2 MAX_TX_TIME is a remaining-lifetime counter in units of 64 TU
+ * (64 * 1024 us). Only bits [6:0] of the field may be programmed by the host -
+ * the MSB is reserved for HW, which replaces the field with its own "max TX
+ * time" once the packet is queued - so clamp there. A non-zero request must
+ * never round down to 0 either, because 0 means "no lifetime" to the HW.
+ */
+#define MT7925_TXD_MAX_TX_TIME_LIMIT	0x7f
+
+static u32 mt7925_mac_txd_life_time(u32 ms)
+{
+	u32 unit;
+
+	if (!ms)
+		return 0;
+
+	/* ms -> TU (1024 us) -> 64 TU */
+	unit = (ms * USEC_PER_MSEC / 1024) >> 6;
+
+	if (unit > MT7925_TXD_MAX_TX_TIME_LIMIT)
+		return MT7925_TXD_MAX_TX_TIME_LIMIT;
+
+	return unit ? unit : 1;
+}
+
+/* Bound an off-channel P2P mgmt frame to the dwell window it was queued for.
+ *
+ * mt76 leaves DW2 MAX_TX_TIME at 0 (= no limit) for everything except a P2P
+ * GO Probe Response, so an off-channel frame that cannot win the medium
+ * inside its dwell stays in the PLE ALTX queue and keeps contending after
+ * the window is gone: UNI_ROC_ABORT only pauses and resumes the STA, so
+ * nothing drops the frame. If it does reach the air then, cfg80211 has
+ * already emitted NL80211_CMD_FRAME_WAIT_CANCEL and wpa_supplicant has
+ * dropped the cookie, so the TX status lands on an unknown cookie,
+ * 'p2p-send-action' radio work is never freed and wpa_supplicant's
+ * serialized radio-work queue stalls - p2p_find dies.
+ *
+ * Program the lifetime from the ROC instead: whatever is left of the
+ * granted interval that mt7925_mcu_roc_handle_grant() armed phy->roc_timer
+ * with, so the HW ages the frame out rather than transmitting it long
+ * after the window is gone.
+ *
+ * Granularity: DW2 MAX_TX_TIME counts 64 TU (~65.5 ms) units and
+ * mt7925_mac_txd_life_time() floors, with a floor of one unit, so it never
+ * writes 0 (= no lifetime) for a non-zero input.
+ */
+static void
+mt7925_mac_txwi_p2p_offchan_life_time(struct mt76_dev *mdev, __le32 *txwi,
+				      struct sk_buff *skb)
+{
+	struct mt792x_dev *dev = container_of(mdev, struct mt792x_dev, mt76);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_vif *vif = info->control.vif;
+	struct mt792x_phy *phy = &dev->phy;
+	struct ieee80211_hdr *hdr;
+	unsigned long expires;
+	u32 life_time, dwell_ms;
+
+	if (!(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN))
+		return;
+
+	if (!vif)
+		return;
+
+	switch (ieee80211_vif_type_p2p(vif)) {
+	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		break;
+	default:
+		return;
+	}
+
+	/* skb->data is an 802.3 header in the HW-encap path, not a frame ctl */
+	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
+		return;
+
+	if (skb->len < sizeof(hdr->frame_control))
+		return;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	if (!ieee80211_is_mgmt(hdr->frame_control))
+		return;
+
+	/* Only meaningful while a dwell window actually exists. roc_timer is
+	 * armed from the grant event only, so timer_pending() also means the
+	 * FW has confirmed the channel.
+	 */
+	if (!test_bit(MT76_STATE_ROC, &phy->mt76->state) ||
+	    !timer_pending(&phy->roc_timer))
+		return;
+
+	expires = phy->roc_timer.expires;
+	if (time_after_eq(jiffies, expires))
+		return;
+
+	dwell_ms = jiffies_to_msecs(expires - jiffies);
+
+	/* Aim the expiry short of the end of the dwell, not at it. Two things
+	 * have to fit in front of cfg80211's deadline:
+	 *
+	 *   - the TXS round trip, ~4..12 ms observed on healthy frames;
+	 *   - the head start cfg80211's wait has over phy->roc_timer. The
+	 *     wait starts when ieee80211_mgmt_tx() queues the frame, while
+	 *     the timer is only armed when the FW grants the channel, and
+	 *     the grant costs ~8..20 ms. So the ROC deadline this function
+	 *     reads is ~17..20 ms later than the deadline that actually
+	 *     matters: the frame wait expires just ahead of roc_work.
+	 *
+	 * 40 ms covers both with slack. Because mt7925_mac_txd_life_time()
+	 * floors, subtracting first guarantees life_time <= dwell - margin.
+	 * Without it the margin would swing between ~0 and ~65 ms depending
+	 * on where the remaining dwell lands inside a unit.
+	 */
+	if (dwell_ms > MT7925_P2P_OFFCHAN_TXS_MARGIN_MS)
+		dwell_ms -= MT7925_P2P_OFFCHAN_TXS_MARGIN_MS;
+
+	/* mt7925_mac_txd_life_time() only returns 0 for a 0 ms input, which
+	 * time_after_eq() above already excluded, and otherwise floors to a
+	 * minimum of one 64 TU unit (~65.5 ms) - it never writes 0, because
+	 * 0 means "no lifetime" to the HW.
+	 *
+	 * The flip side is that a dwell shorter than ~65 ms cannot be
+	 * expressed: it is rounded *up* to ~65.5 ms, so for e.g. a 50 ms
+	 * off-channel wait the frame is bounded but not necessarily reported
+	 * inside the wait. That is still strictly better than the unlimited
+	 * lifetime it has today; capping the damage is the goal, and the
+	 * short-dwell case would need a finer-grained field than DW2
+	 * MAX_TX_TIME to do better.
+	 */
+	life_time = mt7925_mac_txd_life_time(dwell_ms);
+	if (!life_time)
+		return;
+
+	txwi[2] &= ~cpu_to_le32(MT_TXD2_MAX_TX_TIME);
+	txwi[2] |= cpu_to_le32(FIELD_PREP(MT_TXD2_MAX_TX_TIME, life_time));
+}
+
+/* A P2P GO's Probe Response is only useful while the requester is still
+ * on the listen channel, so give it a short TX lifetime and a small retry
+ * limit: a response that cannot get on air in time is aged out by the HW
+ * instead of being transmitted long after the requester has left the
+ * channel.
+ *
+ * Bound the lifetime, keep the small retry limit, and otherwise align the
+ * TXD with a regular management frame.
+ */
+#define MT7925_TXD_PROBERESP_TIMESTAMP_IDX	0	/* WH_TXD_PROBERSP_TIMESTAMP_IDX */
+
+static void
+mt7925_mac_txwi_p2p_go_probe_resp(struct mt76_dev *dev, __le32 *txwi,
+				  struct sk_buff *skb)
+{
+	u32 life_time, val;
+
+	if (!mt7925_is_p2p_go_probe_resp(skb))
+		return;
+
+	life_time = mt7925_mac_txd_life_time(MT7925_P2P_PROBERESP_LIFE_TIME_MS);
+
+	txwi[2] &= ~cpu_to_le32(MT_TXD2_MAX_TX_TIME);
+	txwi[2] |= cpu_to_le32(FIELD_PREP(MT_TXD2_MAX_TX_TIME, life_time));
+
+	txwi[3] &= ~cpu_to_le32(MT_TXD3_REM_TX_COUNT);
+	txwi[3] |= cpu_to_le32(FIELD_PREP(MT_TXD3_REM_TX_COUNT,
+					  MT7925_P2P_PROBERESP_RETRY_LIMIT));
+
+	if (is_mt7928(dev)) {
+		txwi[6] &= ~cpu_to_le32(MT_TXD6_MSDU_CNT_V2 |
+					MT_TXD6_TIMESTAMP_OFS_EN_V2 |
+					MT_TXD6_TIMESTAMP_OFS_IDX_V2);
+		val = FIELD_PREP(MT_TXD6_TIMESTAMP_OFS_EN_V2, 1) |
+		      FIELD_PREP(MT_TXD6_TIMESTAMP_OFS_IDX_V2,
+				 MT7925_TXD_PROBERESP_TIMESTAMP_IDX);
+	} else {
+		txwi[6] &= ~cpu_to_le32(MT_TXD6_TIMESTAMP_OFS_EN |
+					MT_TXD6_TIMESTAMP_OFS_IDX);
+		val = MT_TXD6_TIMESTAMP_OFS_EN |
+		      FIELD_PREP(MT_TXD6_TIMESTAMP_OFS_IDX,
+				 MT7925_TXD_PROBERESP_TIMESTAMP_IDX);
+	}
+	txwi[6] |= cpu_to_le32(val | MT_TXD6_VTA);
+}
+
+void mt7925_p2p_txwi_override(struct mt76_dev *dev, __le32 *txwi,
+			      struct sk_buff *skb)
+{
+	/* Ordered so that the more specific lifetime wins if a frame ever
+	 * matches both composers.
+	 */
+	mt7925_mac_txwi_p2p_offchan_life_time(dev, txwi, skb);
+	mt7925_mac_txwi_p2p_go_probe_resp(dev, txwi, skb);
+}
+
 /* ------------------------------------------------------------------ */
 /* RX: foreign-channel discovery frames                                 */
 /* ------------------------------------------------------------------ */
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h
index ed51670d9633..b005eebbfdca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/p2p.h
@@ -9,10 +9,41 @@
 #include "../mt76.h"
 #include "../mt792x.h"
 
+/* P2P TX timing knobs (values align gen4m FW defaults). */
+#define MT7925_P2P_PROBERESP_LIFE_TIME_MS	100
+#define MT7925_P2P_PROBERESP_RETRY_LIMIT	2	/* DEFAULT_P2P_PROBERESP_RETRY_LIMIT */
+
+/* How far short of the end of an off-channel dwell an off-channel P2P mgmt
+ * frame's TX lifetime is aimed, so that the resulting TX status still reaches
+ * cfg80211 while it is waiting for it. Covers the TXS round trip (~4..12 ms
+ * observed) plus the head start cfg80211's wait has over phy->roc_timer,
+ * which is only armed once the FW grants the channel (~8..20 ms later).
+ */
+#define MT7925_P2P_OFFCHAN_TXS_MARGIN_MS	40
+
+static inline bool mt7925_is_p2p_go_probe_resp(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_vif *vif = info->control.vif;
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
+
+	if (!vif || ieee80211_vif_type_p2p(vif) != NL80211_IFTYPE_P2P_GO)
+		return false;
+
+	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
+		return false;
+
+	if (skb->len < sizeof(mgmt->frame_control))
+		return false;
+
+	return ieee80211_is_probe_resp(mgmt->frame_control);
+}
 /* TX/RX path overrides, BMC wcid bookkeeping and the P2P-only MCU event
  * handlers.
  */
 bool mt7925_p2p_rx_drop_chan_mismatch(struct mt792x_dev *dev,
 				      struct sk_buff *skb);
+void mt7925_p2p_txwi_override(struct mt76_dev *dev, __le32 *txwi,
+			      struct sk_buff *skb);
 
 #endif /* __MT7925_P2P_H */
-- 
2.45.2


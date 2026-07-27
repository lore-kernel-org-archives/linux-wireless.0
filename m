Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356FC41E6C4
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164695; cv=none; b=TG4IPnxxFH2O077crr4ld0EE0i2Kl2E7mShWYMXLX1PqDk5g670czvWTtOfaKloaV8hRKO4k6ohdUCJx+p3XNXggd/k0xPPoCjxCz+BqKyI92063ZBnMQxCjc6odBzLe4M1SBpPHP6OMK6eAIT0FmwUibDFeVWLepd0hhV+rijo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164695; c=relaxed/simple;
	bh=c6XsO0UnfVnkQDq8LaS0gkkryaCp2s78rcsluR2p/38=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7sD0DIY3L4g85gxCe5zrtXuVY7EhdIrvMiVyV6vHXAHEjCxmb6abN99+lhy2msAtQRA9OZV7L7RysYCVu4rxE5gVP0QtT/bx78Ltc/OtslMkwBqDQmhg1tQdoh4yEqoVwRsSBkAj2+fqnNEGFveY8OiNWvFKQEfdzf5GlGkOcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=D7SkfZZ+; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="D7SkfZZ+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SCfXFC29VJFHIBodfpwu53CvTH2mLhW7GrcyTq1rJk4=; b=D7SkfZZ+X84iUvSQnVwdOMUfxQ
	b7HXsbzx1ohs3mkxQsvH3VKM8YHZY8hkcqDsa54IhDYTx+Fl+/kkCAFKTahxKIlOF57TTd7CXdA+b
	PXvJZhzEfrdLO0wqJw7dfzwkL+i4014BDaFLtwHKotlG+ipxjyF2irtJLvOkpn6isuWY=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1woMsl-008KN0-2o
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2026 17:04:43 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 15/15] wifi: mt76: mt7925: fix infinite loop in UNI event TLV parsing
Date: Mon, 27 Jul 2026 15:04:34 +0000
Message-ID: <20260727150434.1778520-15-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260727150434.1778520-1-nbd@nbd.name>
References: <20260727150434.1778520-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The event TLV loops accept a zero-length TLV, which advances neither the
cursor nor the remaining length, so a malformed event hangs the caller.
mt7925_mcu_uni_roc_event() additionally walked past the end of the skb,
since it never checked the declared length against the remainder.

Replace the five open-coded loops with a shared iterator that rejects
lengths below the TLV header and beyond the remaining buffer, and check
the per-tag payload sizes before dereferencing them.

While here, make the RSSI monitor event read from the current TLV rather
than from the start of the list.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 10 ++---
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 38 +++++++++++--------
 .../net/wireless/mediatek/mt76/mt7925/mcu.h   | 19 ++++++++++
 3 files changed, 46 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 8586e18c2fa3..825cdced9f40 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -1562,7 +1562,7 @@ void mt7925_scan_work(struct work_struct *work)
 	while (true) {
 		struct sk_buff *skb;
 		struct tlv *tlv;
-		int tlv_len;
+		u32 tlv_len;
 
 		spin_lock_bh(&phy->dev->mt76.lock);
 		skb = __skb_dequeue(&phy->scan_event_list);
@@ -1575,7 +1575,7 @@ void mt7925_scan_work(struct work_struct *work)
 		tlv = (struct tlv *)skb->data;
 		tlv_len = skb->len;
 
-		while (tlv_len > 0 && le16_to_cpu(tlv->len) <= tlv_len) {
+		mt7925_for_each_tlv(tlv, tlv_len) {
 			struct mt7925_mcu_scan_chinfo_event *evt;
 
 			switch (le16_to_cpu(tlv->tag)) {
@@ -1588,6 +1588,9 @@ void mt7925_scan_work(struct work_struct *work)
 				}
 				break;
 			case UNI_EVENT_SCAN_DONE_CHNLINFO:
+				if (le16_to_cpu(tlv->len) < sizeof(*tlv) + sizeof(*evt))
+					break;
+
 				evt = (struct mt7925_mcu_scan_chinfo_event *)tlv->data;
 
 				mt7925_regd_change(phy, evt->alpha2);
@@ -1599,9 +1602,6 @@ void mt7925_scan_work(struct work_struct *work)
 			default:
 				break;
 			}
-
-			tlv_len -= le16_to_cpu(tlv->len);
-			tlv = (struct tlv *)((char *)(tlv) + le16_to_cpu(tlv->len));
 		}
 
 		dev_kfree_skb(skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 8ca4c952d399..1219a370300a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -409,16 +409,18 @@ mt7925_mcu_uni_hif_ctrl_event(struct mt792x_dev *dev, struct sk_buff *skb)
 	tlv = (struct tlv *)skb->data;
 	tlv_len = skb->len;
 
-	while (tlv_len > 0 && le16_to_cpu(tlv->len) <= tlv_len) {
+	mt7925_for_each_tlv(tlv, tlv_len) {
 		switch (le16_to_cpu(tlv->tag)) {
 		case UNI_EVENT_HIF_CTRL_BASIC:
+			if (le16_to_cpu(tlv->len) <
+			    sizeof(struct mt7925_mcu_hif_ctrl_basic_tlv))
+				break;
+
 			mt7925_mcu_handle_hif_ctrl_basic(dev, tlv);
 			break;
 		default:
 			break;
 		}
-		tlv_len -= le16_to_cpu(tlv->len);
-		tlv = (struct tlv *)((char *)(tlv) + le16_to_cpu(tlv->len));
 	}
 }
 
@@ -426,22 +428,24 @@ static void
 mt7925_mcu_uni_roc_event(struct mt792x_dev *dev, struct sk_buff *skb)
 {
 	struct tlv *tlv;
-	int i = 0;
+	u32 tlv_len;
 
 	skb_pull(skb, sizeof(struct mt7925_mcu_rxd) + 4);
+	tlv = (struct tlv *)skb->data;
+	tlv_len = skb->len;
 
-	while (i < skb->len) {
-		tlv = (struct tlv *)(skb->data + i);
-
+	mt7925_for_each_tlv(tlv, tlv_len) {
 		switch (le16_to_cpu(tlv->tag)) {
 		case UNI_EVENT_ROC_GRANT:
+			if (le16_to_cpu(tlv->len) <
+			    sizeof(struct mt7925_roc_grant_tlv))
+				break;
+
 			mt7925_mcu_roc_handle_grant(dev, tlv);
 			break;
 		case UNI_EVENT_ROC_GRANT_SUB_LINK:
 			break;
 		}
-
-		i += le16_to_cpu(tlv->len);
 	}
 }
 
@@ -476,7 +480,7 @@ mt7925_mcu_tx_done_event(struct mt792x_dev *dev, struct sk_buff *skb)
 	tlv = (struct tlv *)skb->data;
 	tlv_len = skb->len;
 
-	while (tlv_len > 0 && le16_to_cpu(tlv->len) <= tlv_len) {
+	mt7925_for_each_tlv(tlv, tlv_len) {
 		switch (le16_to_cpu(tlv->tag)) {
 		case UNI_EVENT_TX_DONE_MSG:
 			struct mt7928_uni_txdone_event *evt;
@@ -484,6 +488,9 @@ mt7925_mcu_tx_done_event(struct mt792x_dev *dev, struct sk_buff *skb)
 			if (!is_mt7928(&dev->mt76))
 				break;
 
+			if (le16_to_cpu(tlv->len) < sizeof(*evt))
+				break;
+
 			evt = (struct mt7928_uni_txdone_event *)tlv;
 			if (evt->status) {
 				dev_info(dev->mt76.dev,
@@ -510,8 +517,6 @@ mt7925_mcu_tx_done_event(struct mt792x_dev *dev, struct sk_buff *skb)
 		default:
 			break;
 		}
-		tlv_len -= le16_to_cpu(tlv->len);
-		tlv = (struct tlv *)((char *)(tlv) + le16_to_cpu(tlv->len));
 	}
 }
 
@@ -548,10 +553,13 @@ mt7925_mcu_rssi_monitor_event(struct mt792x_dev *dev, struct sk_buff *skb)
 	tlv = (struct tlv *)skb->data;
 	tlv_len = skb->len;
 
-	while (tlv_len > 0 && le16_to_cpu(tlv->len) <= tlv_len) {
+	mt7925_for_each_tlv(tlv, tlv_len) {
 		switch (le16_to_cpu(tlv->tag)) {
 		case UNI_EVENT_RSSI_MONITOR_INFO:
-			event = (struct mt7925_uni_rssi_monitor_event *)skb->data;
+			if (le16_to_cpu(tlv->len) < sizeof(*event))
+				break;
+
+			event = (struct mt7925_uni_rssi_monitor_event *)tlv;
 			ieee80211_iterate_active_interfaces_atomic(dev->mt76.hw,
 								   IEEE80211_IFACE_ITER_RESUME_ALL,
 								   mt7925_mcu_rssi_monitor_iter,
@@ -560,8 +568,6 @@ mt7925_mcu_rssi_monitor_event(struct mt792x_dev *dev, struct sk_buff *skb)
 		default:
 			break;
 		}
-		tlv_len -= le16_to_cpu(tlv->len);
-		tlv = (struct tlv *)((char *)(tlv) + le16_to_cpu(tlv->len));
 	}
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
index 154f792a56bc..11f9eac13ffc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.h
@@ -699,6 +699,25 @@ mt7925_mcu_get_cipher(int cipher)
 	}
 }
 
+static inline bool
+mt7925_mcu_tlv_valid(struct tlv *tlv, u32 rem)
+{
+	u16 len;
+
+	if (rem < sizeof(*tlv))
+		return false;
+
+	len = le16_to_cpu(tlv->len);
+
+	/* a length below the header size would not advance the cursor */
+	return len >= sizeof(*tlv) && len <= rem;
+}
+
+#define mt7925_for_each_tlv(tlv, rem)					\
+	for (; mt7925_mcu_tlv_valid(tlv, rem);				\
+	     (rem) -= le16_to_cpu((tlv)->len),				\
+	     (tlv) = (struct tlv *)((u8 *)(tlv) + le16_to_cpu((tlv)->len)))
+
 int mt7925_mcu_set_dbdc(struct mt76_phy *phy, bool enable);
 int mt7925_mcu_hw_scan(struct mt76_phy *phy, struct ieee80211_vif *vif,
 		       struct ieee80211_scan_request *scan_req);
-- 
2.53.0


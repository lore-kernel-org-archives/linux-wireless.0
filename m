Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564712BD022
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601216; cv=none; b=S5b8/r165ZT8amPbIeAQGJpfsI6DkdGX6UoQ4bdjnZHWJ34UQ0ZLgIHAZC+Gi49xWWcRP/Blx0gvIbEMig7Lku7iwnNZ8/MKQfl9os1WCIIL/+905lWvnUwzFAcVe5p4krl6LAYnzg0z5H574MyjKF6//gaEekO5eL7CW24m4KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601216; c=relaxed/simple;
	bh=rGPjK5udxh/yntiTQzk4btFfJjzHmaERcfdu0ueOQ4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAUGOXsg/she1TJdoB8UepyZyxCS1y6eWQwPZXD6x9opKO+LyDXGZAXfCXJZGRl9MygPNCVrui/TC+H7LcKo12FE0ZzkjJayd12fGOSve0FD4mbyRNecux4CuoD3uH20HPApDayC3Pu5ZGxwU4ySbw8sabyKhss461Dp8uYOvzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7f48c750afcso1673763a34.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:53:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601214; x=1788206014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5FLXoQ3eZi+0ZhLhJQdslPk4Jatagvv9bTwe/bZk+2E=;
        b=a0eOuPnZkJHMStm41E7usQjEv1MC8lMFE05za0m6P4fxLwAyyIk2gR+86STbmSOkmP
         8janQpJSQpyAPjS6BceVlw5qETJlFUfMy90G5SbQrqe9ER4klXzryIkQrFJB9rH1GA3L
         GiyKdBVv1rP09EACoz5WOIHoK3lNGps/0XqwDUZ0CQarZ4uzDPsh9Durd/nqYG5+zRLZ
         WqpOSYam3HeVz/1T52ecX8tmo9RtBCfvTodhAqPrfrSmOqDrGPwGzFFhKboGRbd/n5nz
         mUtjjIZPgUJKQ18ohuKRmFwDd8s6nqk12cyKl3W0yyHgSPcj6KCr4/ICsxaZrF0h6mco
         Uqyg==
X-Gm-Message-State: AFuF++ks2iy2Tru1hi6SZ9qEwwqjmw//3YPrp8Fmq1UzWAvZ6JW8G3We
	RgVrz/BQDT271NGRTnSJHmWC2BU8fVrJirFCtB4XrjTdEOqRX15TbOaM
X-Gm-Gg: AR+sD12NFdYXZlrCZIrpUDyh+hTatysH081sqbcPrH6nD2hDmb3RIg1DIeCIMNmuarh
	NgSzC1SKWfxDtx8ETsAZuxrFbtwzmVs4kqMFGOjm0VHB9SuUsd2WY39MUiEeZh1PGWudN0TBBfb
	qRnYsJe6TwV6cU6rAGvJ455OJkNjllVJrSmIUe5C8ZcS/kKMeSCBVQxMhM5xuXr1vhnuPmFMGvR
	6nUrGRo+KpOJISuhQJmRsLpAzbTWMTK6hiuLXX0+wT7gtoxq3VJ/91M/jNn4+BBvAKkO4pOIJuc
	1F8XwRXy7artL/AHYrTlUYKKD4SP06QdGqMl3FkYBecSAFCcSCnQsiRNNw22QCvtNyrUJo+np3A
	POdn+8a+7aYe3k1z9hN+r5REPRRrwqArGRkIm4PXN13FJVC8Kx2LOSmqVnwLg7qK2Uq4Xd+b1lF
	pAv7/lGHKo7WSt8YkRm+RTi+SKoz3e9N1URiF+7YEXAMeVgqm8QTRyjVXkqxDJDCWRLe/6TqqCK
	2dgodji54+a3mhRc2nwDuSy02xRRKcr+auvLiIKFD64
X-Received: by 2002:a05:6820:208c:b0:6ae:33fb:4546 with SMTP id 006d021491bc7-6b190411b18mr1066445eaf.9.1787601214175;
        Mon, 24 Aug 2026 12:53:34 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:53:33 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 12/15] wifi: mt76: mt7925: add ULW event handling and peer ULW update
Date: Mon, 24 Aug 2026 14:52:24 -0500
Message-ID: <20260824195227.12589-13-sean.wang@kernel.org>
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

Forward NAN Unaligned Window attributes between FW and mac80211:
report ULW updates from FW via cfg80211_nan_ulw_update() and push
peer ULW attributes to FW with NAN_UNI_CMD_UPDATE_ULW.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 84 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/nan.h   | 40 ++++++++-
 2 files changed, 123 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 16fb196e1bf5..53736b156f69 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -397,6 +397,52 @@ mt7925_nan_mcu_handle_de_event(struct mt792x_dev *dev, struct tlv *tlv)
 	ieee80211_nan_cluster_joined(dev->nan_vif, cluster_id, true, GFP_KERNEL);
 }
 
+static void
+mt7925_nan_handle_ulw_update(struct mt792x_dev *dev, struct tlv *tlv)
+{
+	struct mt7925_nan_ulw_event *evt;
+	struct mt7925_nan_ulw_attr attr;
+	struct wireless_dev *wdev;
+	u16 len;
+
+	if (!dev || !tlv)
+		return;
+
+	if (!dev->nan_vif || !ieee80211_vif_nan_started(dev->nan_vif))
+		return;
+
+	len = le16_to_cpu(tlv->len);
+	if (len < sizeof(*tlv) + sizeof(*evt)) {
+		dev_warn(dev->mt76.dev,
+			 "nan: short ulw event tlv len=%u\n", len);
+		return;
+	}
+
+	evt = (struct mt7925_nan_ulw_event *)tlv->data;
+	wdev = ieee80211_vif_to_wdev(dev->nan_vif);
+	if (!wdev)
+		return;
+
+	dev_dbg(dev->mt76.dev,
+		"nan: ulw_update wdev=%p owner_nlportid=%u sched_id=%u seq=%u dur=%u\n",
+		wdev, wdev->owner_nlportid,
+		evt->sched_id, evt->seq_id, le32_to_cpu(evt->duration));
+
+	/* Reorder the FW fields into NAN spec Table 109 attribute layout */
+	attr.attr_id = NAN_ULW_ATTR_ID;
+	attr.length = cpu_to_le16(NAN_ULW_FIXED_PAYLOAD);
+	attr.sched_id = evt->sched_id;
+	attr.seq_id = evt->seq_id;
+	attr.start_time = evt->start_time;
+	attr.duration = evt->duration;
+	attr.period = evt->period;
+	attr.count_down = evt->count_down;
+	attr.ulw_overwrite = evt->ulw_overwrite;
+
+	cfg80211_nan_ulw_update(wdev, (const u8 *)&attr, sizeof(attr),
+				GFP_KERNEL);
+}
+
 void mt7925_nan_mcu_event(struct mt792x_dev *dev, struct sk_buff *skb)
 {
 	struct tlv *tlv;
@@ -425,6 +471,9 @@ void mt7925_nan_mcu_event(struct mt792x_dev *dev, struct sk_buff *skb)
 		case NAN_UNI_EVENT_REPORT_DW_START:
 			mt7925_nan_handle_dw_ind(dev, tlv);
 			break;
+		case NAN_UNI_EVENT_ID_ULW_UPDATE:
+			mt7925_nan_handle_ulw_update(dev, tlv);
+			break;
 		default:
 			break;
 		}
@@ -736,6 +785,37 @@ static int mt7925_nan_update_crb_tlv(struct sk_buff *skb,
 	return 0;
 }
 
+static int
+mt7925_nan_peer_ulw_tlv(struct sk_buff *skb,
+			struct ieee80211_sta *sta,
+			struct mt792x_sta *msta)
+{
+	struct mt7925_nan_update_ulw_tlv *ulw_tlv = NULL;
+	struct ieee80211_nan_peer_sched *sched = NULL;
+	struct tlv *tlv = NULL;
+
+	if (!skb || !sta || !msta)
+		return -EINVAL;
+
+	sched = sta->nan_sched;
+	if (!sched || !sched->init_ulw || !sched->ulw_size)
+		return 0; /* No ULW to send, not an error */
+
+	if (sched->ulw_size > NAN_ULW_MAX_SIZE)
+		return -EINVAL;
+
+	tlv = mt76_connac_mcu_add_tlv(skb, NAN_UNI_CMD_UPDATE_ULW,
+				      sizeof(struct mt7925_nan_update_ulw_tlv));
+	if (!tlv)
+		return -ENOMEM;
+
+	ulw_tlv = (struct mt7925_nan_update_ulw_tlv *)tlv;
+	ether_addr_copy(ulw_tlv->nmi_addr, sta->addr);
+	memcpy(ulw_tlv->ulw_attr, sched->init_ulw, sched->ulw_size);
+
+	return 0;
+}
+
 int mt792x_nan_set_peer_schedule(struct mt792x_dev *dev,
 				 struct ieee80211_sta *sta)
 {
@@ -788,6 +868,10 @@ int mt792x_nan_set_peer_schedule(struct mt792x_dev *dev,
 		goto free_skb;
 	}
 
+	ret = mt7925_nan_peer_ulw_tlv(skb, sta, msta);
+	if (ret)
+		goto free_skb;
+
 	ret = mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(NAN), true);
 	if (ret && idx_allocated)
 		goto clear_idx;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index 32e2e9cfffc7..c9207b5c899e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -50,7 +50,8 @@
 	(sizeof(struct mt7925_nan_common_hdr) +				\
 	 sizeof(struct mt7925_nan_sched_manage_peer_rec_tlv) +		\
 	 sizeof(struct mt7925_nan_sched_update_peer_cap_tlv) +		\
-	 sizeof(struct mt7925_nan_sched_update_crb_tlv))
+	 sizeof(struct mt7925_nan_sched_update_crb_tlv) +		\
+	 sizeof(struct mt7925_nan_update_ulw_tlv))
 
 /* NAN Availability Attribute */
 #define NAN_AVAIL_ATTR_ID_OFFSET	0
@@ -81,6 +82,7 @@ enum nan_uni_cmd_tag {
 	NAN_UNI_CMD_UPDATE_CRB			= 10,
 	NAN_UNI_CMD_MANAGE_PEER_SCH_RECORD	= 12,
 	NAN_UNI_CMD_MAP_STA_RECORD		= 13,
+	NAN_UNI_CMD_UPDATE_ULW			= 16,
 	NAN_UNI_CMD_UPDATE_AVAILABILITY_CTRL	= 20,
 	NAN_UNI_CMD_UPDATE_PEER_CAPABILITY	= 21,
 	NAN_UNI_CMD_CHANGE_NMI_ADDRESS		= 24,
@@ -92,6 +94,7 @@ enum nan_uni_cmd_tag {
 
 enum nan_uni_event_tag {
 	NAN_UNI_EVENT_ID_DE_EVENT_IND		= 19,
+	NAN_UNI_EVENT_ID_ULW_UPDATE		= 39,
 	NAN_UNI_EVENT_REPORT_DW_START		= 59,
 	NAN_UNI_EVENT_REPORT_DW_END		= 60,
 };
@@ -165,6 +168,32 @@ struct nan_rpt_dw_evt {
 	__le16 dw_num;
 };
 
+#define NAN_ULW_ATTR_ID		0x17
+#define NAN_ULW_FIXED_PAYLOAD	16	/* Table 109 fixed fields */
+
+struct mt7925_nan_ulw_event {
+	u8 sched_id;
+	u8 seq_id;
+	u8 count_down;
+	u8 ulw_overwrite;
+	__le32 start_time;
+	__le32 duration;
+	__le32 period;
+} __packed;
+
+/* ULW attribute laid out in NAN spec Table 109 field order */
+struct mt7925_nan_ulw_attr {
+	u8 attr_id;
+	__le16 length;
+	u8 sched_id;
+	u8 seq_id;
+	__le32 start_time;
+	__le32 duration;
+	__le32 period;
+	u8 count_down;
+	u8 ulw_overwrite;
+} __packed;
+
 struct mt7925_nan_conf_dw {
 	u8 config_2dot4g_dw_band;
 	__le32 dw_2dot4g_interval_val;
@@ -389,6 +418,15 @@ struct mt7925_nan_sched_update_crb_tlv {
 	struct mt7925_nan_sched_faw_ndc_timeline faw_ndc_timeline[NAN_TIMELINE_MGMT_SIZE];
 } __packed __aligned(4);
 
+#define NAN_ULW_MAX_SIZE	256
+
+struct mt7925_nan_update_ulw_tlv {
+	__le16 tag;
+	__le16 len;
+	u8 nmi_addr[ETH_ALEN];
+	u8 ulw_attr[NAN_ULW_MAX_SIZE];
+} __packed __aligned(4);
+
 struct mt7925_nan_sched_map_sta_rec_tlv {
 	__le16 tag;
 	__le16 len;
-- 
2.43.0


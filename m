Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5504231A3B
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543016; cv=none; b=gerXcoWEi+AdZ5nBgo5jzVVLrFpAto9rEEdUVyorz2+RJn+Fdl2CvmICPxLbGXq0PTAJFm1+jds5AulrwUwF8jLA6fhiOCIxkjh4fuIZXiPyawdZzeK32Lna8RHCSB7RxEXzmLAZc72JJHoC16/FDzFf6OyQPY0rX4AFw70z5fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543016; c=relaxed/simple;
	bh=kZljhIoNC4CVp9tVljujFDywRu6tAw38J1X+cuttf6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMILb0wzaJa/9l4OCNV+Ep0UJA8x1VmMMNec7hpjfAOViSY4ig1X4BUnOEtJNdbqu2jJK8Edd8X6k6xp15Zeq/XyCYSb/oQ7KDokwkA2bWkyEQu34hSrRKC6UTxsN56mcWaGhbOHZUl4Dl8Bol9OlZlJZQwaYI2nAdwCPjEFAzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx2-f43.google.com with SMTP id 956f58d0204a3-67109935888so2100869d50.3
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:03:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543014; x=1791147814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dOW97T1gtPr4a3glS4lYt5Ynt0bJTscU/piIiSCSjUI=;
        b=UgTqkt4vjJH8KrKCIgZ9vg9auvXZ3lgkkI6+ocrRkMHIX96Qhiom3KegC45VFVnJdD
         BuQ9JzGdGf0PGeKL2QW9T/JL0mvHgQ8PdCk+2cGPrc7h/Q6U2CMelfFWTTyQygS9RN0l
         bpxLbL5eZEkyohr1CZNRz8lGFNmM9XU+X8vYAa4ml5+/RHN/TbqOddR7qfj+dlgOaklL
         vjLjYJ3VcKf05TyiW7canoKgd04q05fseAY4wYI/qPqHuZkFv5Ij7D72BMS84jBMjZNH
         GP/cU0cdDbkejdPgSGv0wQgPf1TfXNy2Ac8AdvZlH9QZ1SmlMnG/XzMoy+Qm/G7XPqMZ
         /ImA==
X-Gm-Message-State: AFq9FYJtExn1Fo12EECPNzSeP6RXjQTgnNr2N4e13scIa3eEt/tJfuBC
	WpWqopm6dsmaF9T4LHu3labLN5iVEECpeDM8RNxR06f7Q7DDz7UAJWL/
X-Gm-Gg: AYBFou1V7p4mssVLydrNt7ps5RhjI+gF1+ZPLVOgWwRVnnSwNy3LSBUMgE5dvyIG2Gk
	qVqzrXonYOdj3JabDQ9NECPRS3kFYbFVFx0GtveXmoWowi++/Quk2I0rTX8lipcLZajf5o9TeIR
	IrqFQe6LUfQXfQPF7jDYk7V/OqJqFl2G5u8nAzzfczUtb1HpYUMJ7wyMUqddTgyxR+wHoWFlv5r
	uUTzQSCvqxwyRPk9kg1lQVYZVGGNPzgaDciFdjzvuQp8NYsmLNL1v7rhEV5LFeyKInC841Sdssj
	Cfvpn2AU7j50eGSjY5GigLCBJ4CtEHC/lvy3uv23v3gxRwgyhdmFQM5D9stC4nqb0Ezu/g1mQ7Z
	MHYwBkcYC8oejVYAQOcCGzkpVzw4EvpoubXT0ZU345tzNVeBurqTc8TLPpa28SKSooBqFakP7Zh
	dnnUXqEXzyc+2gMvxjv48U7mvENMmlKfzXiiQP3yYPJPZnnamqqih2PKxZJn2aAiwJ0Pg8WzKYg
	drA7bhQUKqHWJvdGT26maVrVMMQnza0y8sPVdNZ74lH0JWJgDFicfyb7fLXc5jXG1Go7Q==
X-Received: by 2002:a05:690e:124e:b0:674:e0d2:7e12 with SMTP id 956f58d0204a3-674e0d286c3mr1607558d50.109.1790543013745;
        Sun, 27 Sep 2026 14:03:33 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:03:33 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Chengwei Yu <chengwei.yu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 05/23] wifi: mt76: mt7925: add NAN low power event control on suspend/resume
Date: Sun, 27 Sep 2026 16:02:47 -0500
Message-ID: <20260927210306.737669-6-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260927210306.737669-1-sean.wang@kernel.org>
References: <20260927210306.737669-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chengwei Yu <chengwei.yu@mediatek.com>

Disable NAN low power event reporting when the interface suspends so
the firmware stops firing peer-schedule notifications into a quiesced
system, and re-enable it on resume.

Re-enabling is conditional: it only fires if firmware has previously
reported an active peer schedule (non-zero peer_sch_record_tx_map in
the LOWPOWER_CTRL event). This avoids sending the command on every
resume when no peer connection is in progress.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Chengwei Yu <chengwei.yu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   |  9 ++
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 93 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/nan.h   | 18 ++++
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  7 ++
 4 files changed, 127 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 2afd3f5e3266..76dcbbffabfc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -296,6 +296,7 @@ void mt7925_mcu_set_suspend_iter(void *priv, u8 *mac,
 	bool suspend = !test_bit(MT76_STATE_RUNNING, &phy->state);
 	struct ieee80211_hw *hw = phy->hw;
 	struct cfg80211_wowlan *wowlan = hw->wiphy->wowlan_config;
+	struct mt792x_dev *dev = mt792x_hw_dev(hw);
 	int i;
 
 	mt76_connac_mcu_set_gtk_rekey(phy->dev, vif, suspend);
@@ -306,6 +307,14 @@ void mt7925_mcu_set_suspend_iter(void *priv, u8 *mac,
 		mt7925_mcu_set_wow_pattern(phy->dev, vif, i, suspend,
 					   &wowlan->patterns[i]);
 	mt7925_connac_mcu_set_wow_ctrl(phy, vif, suspend, wowlan);
+
+	/*
+	 * Disable NAN low power event reporting while suspended, and
+	 * re-enable it on resume so firmware resumes reporting peer
+	 * schedule activity.
+	 */
+	if (vif->type == NL80211_IFTYPE_NAN)
+		mt7925_nan_send_lowpower_ctrl_cmd(dev, !suspend);
 }
 
 #endif /* CONFIG_PM */
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 0b94bd4005d4..73e45be8b40e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -654,6 +654,44 @@ mt7925_nan_handle_sched_update_done(struct mt792x_dev *dev, struct tlv *tlv)
 	ieee80211_queue_work(dev->mt76.hw, &dev->nan_deferred_work);
 }
 
+static void
+mt7925_nan_handle_lowpower_ctrl(struct mt792x_dev *dev, struct tlv *tlv)
+{
+	struct mt7925_nan_lowpower_ctrl_evt *evt;
+	struct mt792x_vif *mvif;
+	u16 len;
+
+	if (!dev || !tlv)
+		return;
+
+	len = le16_to_cpu(tlv->len);
+	if (len < sizeof(*tlv) + sizeof(*evt)) {
+		dev_warn(dev->mt76.dev,
+			 "nan: short lowpower_ctrl event tlv len=%u\n", len);
+		return;
+	}
+
+	if (!dev->nan_vif || !ieee80211_vif_nan_started(dev->nan_vif))
+		return;
+
+	evt = (struct mt7925_nan_lowpower_ctrl_evt *)tlv->data;
+
+	dev_dbg(dev->mt76.dev,
+		"nan: lowpower_ctrl event - peer_sch_record_tx_map=0x%x\n",
+		evt->peer_sch_record_tx_map);
+
+	if (!evt->peer_sch_record_tx_map)
+		return;
+
+	/*
+	 * Firmware reports an active peer schedule; remember it so the
+	 * next resume re-enables low power event reporting instead of
+	 * sending the command unconditionally every suspend/resume cycle.
+	 */
+	mvif = (struct mt792x_vif *)dev->nan_vif->drv_priv;
+	mvif->nan.lowpower_mode = true;
+}
+
 void mt7925_nan_mcu_event(struct mt792x_dev *dev, struct sk_buff *skb)
 {
 	struct tlv *tlv;
@@ -688,6 +726,9 @@ void mt7925_nan_mcu_event(struct mt792x_dev *dev, struct sk_buff *skb)
 		case NAN_UNI_EVENT_ID_SCHED_UPDATE_DONE:
 			mt7925_nan_handle_sched_update_done(dev, tlv);
 			break;
+		case NAN_UNI_EVENT_LOWPOWER_CTRL:
+			mt7925_nan_handle_lowpower_ctrl(dev, tlv);
+			break;
 		default:
 			break;
 		}
@@ -745,6 +786,58 @@ int mt7925_nan_set_ndi_address(struct ieee80211_vif *vif,
 	return 0;
 }
 
+int mt7925_nan_send_lowpower_ctrl_cmd(struct mt792x_dev *dev, bool enable)
+{
+	struct mt7925_nan_lowpower_ctrl_tlv *lp_tlv;
+	struct mt7925_nan_common_hdr *hdr;
+	struct mt792x_vif *mvif;
+	struct mt76_dev *mdev;
+	struct sk_buff *skb;
+	struct tlv *tlv;
+
+	if (!dev)
+		return -EINVAL;
+
+	/*
+	 * Only re-enabling (on resume) is gated on firmware having reported
+	 * an active peer schedule while suspended; disabling (on suspend)
+	 * always goes through so firmware stops reporting immediately.
+	 */
+	if (enable) {
+		if (!dev->nan_vif)
+			return 0;
+
+		mvif = (struct mt792x_vif *)dev->nan_vif->drv_priv;
+		if (!mvif->nan.lowpower_mode)
+			return 0;
+
+		mvif->nan.lowpower_mode = false;
+	}
+
+	mdev = &dev->mt76;
+
+	skb = mt76_mcu_msg_alloc(mdev, NULL,
+				 sizeof(struct mt7925_nan_common_hdr) +
+				 sizeof(struct mt7925_nan_lowpower_ctrl_tlv));
+	if (!skb)
+		return -ENOMEM;
+
+	hdr = (struct mt7925_nan_common_hdr *)skb_put(skb, sizeof(*hdr));
+	memset(hdr, 0, sizeof(*hdr));
+
+	tlv = mt76_connac_mcu_add_tlv(skb, NAN_UNI_CMD_LOWPOWER_CTRL,
+				      sizeof(struct mt7925_nan_lowpower_ctrl_tlv));
+	if (!tlv) {
+		dev_kfree_skb(skb);
+		return -ENOMEM;
+	}
+
+	lp_tlv = (struct mt7925_nan_lowpower_ctrl_tlv *)tlv;
+	lp_tlv->enabled = enable ? 1 : 0;
+
+	return mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(NAN), true);
+}
+
 void mt7925_nan_mac_rand_work(struct work_struct *work)
 {
 	struct mt792x_vif *mvif = container_of(work, struct mt792x_vif,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index 191134825c3b..3a14ec384e4f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -88,6 +88,7 @@ enum nan_uni_cmd_tag {
 	NAN_UNI_CMD_UPDATE_PEER_CAPABILITY	= 21,
 	NAN_UNI_CMD_CHANGE_NMI_ADDRESS		= 24,
 	NAN_UNI_CMD_SET_DW_INTERVAL		= 26,
+	NAN_UNI_CMD_LOWPOWER_CTRL		= 37,
 	NAN_UNI_CMD_SET_SYNC_RSSI		= 39,
 	NAN_UNI_CMD_SET_CLUSTER_ID		= 40,
 	NAN_UNI_CMD_KEY_MANAGEMENT		= 53,
@@ -95,6 +96,7 @@ enum nan_uni_cmd_tag {
 
 enum nan_uni_event_tag {
 	NAN_UNI_EVENT_ID_DE_EVENT_IND		= 19,
+	NAN_UNI_EVENT_LOWPOWER_CTRL		= 37,
 	NAN_UNI_EVENT_ID_ULW_UPDATE		= 39,
 	NAN_UNI_EVENT_ID_SCHED_UPDATE_DONE	= 43,
 	NAN_UNI_EVENT_REPORT_DW_START		= 59,
@@ -476,6 +478,20 @@ struct mt7925_nan_update_phy_setting_tlv {
 	struct mt7925_nan_phy_setting phy_5g;
 } __packed __aligned(4);
 
+/* NAN Low Power Control Command */
+struct mt7925_nan_lowpower_ctrl_tlv {
+	__le16 tag;
+	__le16 len;
+	u8 enabled;
+	u8 reserved[3];
+} __packed __aligned(4);
+
+/* NAN Low Power Control Event */
+struct mt7925_nan_lowpower_ctrl_evt {
+	u8 peer_sch_record_tx_map;
+	u8 reserved[7];
+} __packed __aligned(4);
+
 int mt7925_nan_update_phy_setting(struct mt792x_dev *dev);
 
 struct ieee80211_chanctx_conf *
@@ -510,6 +526,8 @@ void mt7925_nan_start_mac_randomization(struct ieee80211_vif *vif,
 
 void mt7925_nan_stop_mac_randomization(struct ieee80211_vif *vif);
 
+int mt7925_nan_send_lowpower_ctrl_cmd(struct mt792x_dev *dev, bool enable);
+
 void mt7925_nan_local_sched_changed(struct mt792x_dev *dev,
 				    struct ieee80211_vif *vif);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 64cca8852359..fa28a77d12bb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -182,6 +182,13 @@ struct mt792x_nan {
 	/* Connection index bitmap, up to NAN_MAX_CONN_CFG peers */
 	unsigned long conn_bitmap;
 
+	/*
+	 * Set when firmware reports an active peer schedule via
+	 * NAN_UNI_EVENT_LOWPOWER_CTRL; cleared once the re-enable command
+	 * has been sent on resume.
+	 */
+	bool lowpower_mode;
+
 	/*
 	 * NMI/NDI MAC address randomization. Kept per-vif (rather than a
 	 * single pointer on mt792x_dev) because up to two NAN_DATA vifs can
-- 
2.43.0


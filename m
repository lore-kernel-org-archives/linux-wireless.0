Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7F92BD022
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 19:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787601222; cv=none; b=rrpzP31hPoJt2uZ11VCxhZoJao0iqr4m5jlQcf4em1vXVCdWHiRL8gntgH4WxN8VXlvxJW5snzCE1nLPmH6DYMa6W6YsyH1xv+YYxtkiVnO7T70yi4z/7YOOJIAuaBtlNbbSzh6Flj51XqePZ0Sf1MlnOmpr3q8BOkhLWviyHAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787601222; c=relaxed/simple;
	bh=jqlfzl5ckJLceMQsrWE0A3TfEfaLH2DIlJuHTXaR/XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3jTEuy7JH2c7NO8zwZqEzFLeE5H4/a77IthpQa5iqyTaiwbSfFGL6YIjoQwimJQODxlpQmJoMq3OUGEihmQ4uHq/Z4YU1yT/7pq8pWpDbSMLlKFZsx41u9r5VOw1NCkT92CUM+gtDxQzMO9eNOPqhiGMBqhI2tthQvPmp8DRjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-44cb057311bso3637246fac.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 12:53:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601220; x=1788206020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tYh2eyx3MQIXpn7Ochh86kWh474/apID4gTsqhPwG0Y=;
        b=DK4MmdjKX+75Qbmkv+ztS4D+MRxTwnvV+P/87B8xU2N0kkZlg4jJCiY3jea6Qt2Acw
         9gbsntHF1QngwKfZEY/TSlWDg9zRV+Y8jduROLcwzPbQHuEC4TGrFKA5ngvbVfMbCbmk
         ImsoJO9GfX3U+a3D00xt99GLTFTeBF90OuVODp9uxHHr8tZ35g+F4TOFsFIOIPuJ+1ZW
         yOVMypHuo+oal9KYQ0M8TYkN0BHZ5adJP4gUJRk0ki44N/1KAPcIEb2vA2NFKgtK1LeB
         XEVvUkxXVWHPfKQFEZOSBQVJNShQQjO2XpoUGJTz6NSI0ZFSd86smx4N9F35tv2XBdJv
         DXbw==
X-Gm-Message-State: AFuF++lXfk6/KIzpNIgXviJt++YuHxrqr2+OE1x7DxfW9tgUMuCQqUdw
	naiIF1qGQr9k6KBL4B+AireqlNDzIiqAR3FL2EHguwACZpxr8ZW0gkfM
X-Gm-Gg: AR+sD10qPSUo6elSot3/B02TQxxAwVOyXr9hRq795tUXM0gt6KQa4Gl+NIKNW5Xjr51
	vM668VWO2FE9El6NiXTPMgInWzHObiUj6lSc/BAclRN8UzUKq9NVSc1sAmyJX+IJMmZr8K33frE
	032Qz54qzdsY0xz2Ox3ZC1A3X0Q1Sa8NESTV2tiD9FCB8AANSGD4iZUSaFgWpZXpAzXHHwiGh3v
	DditJinZSpHbuM0NhPeOLEUWj7E6j22O+xzemLD8Ibk3ci26uJIOjJYvvy/0igP+4eSO4QGH/Vj
	NkgO29w9C7Hoc4Mdn4hES+kDHpnubE3XZYVxmjZD4wTYoI+TXbRSSHCB4sy0ns0wgP1PLm/k2aN
	jpmN0nj5VcZnGhsWlsTtrjjfX+EONdqvDRy8MtL1Oj9VNNzM1i0fmhpIzaxaCUkOAPrAs1fPAYa
	MkqEhRd1J3dGmZdWN521kHxdCRioCW8ooKnXIR/uvTeF+ThyVZiXmtqVemoub0w51zzMFXu9sYd
	d24E36tc6Otr8mVUHf/mK8ztNO5LnSv1RjTJU1q8J7Vs0nwfdi53bU=
X-Received: by 2002:a05:6870:e189:b0:440:e191:b095 with SMTP id 586e51a60fabf-46350f399a8mr29117789fac.3.1787601219876;
        Mon, 24 Aug 2026 12:53:39 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.lan ([207.191.35.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463835bcdcbsm5805896fac.18.2026.08.24.12.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 12:53:39 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name,
	lorenzo.bianconi@redhat.com
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Jacobs Wu <jacobs.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 14/15] wifi: mt76: mt7925: support deferred NAN schedule update and cluster events
Date: Mon, 24 Aug 2026 14:52:26 -0500
Message-ID: <20260824195227.12589-15-sean.wang@kernel.org>
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

From: Jacobs Wu <jacobs.wu@mediatek.com>

Send the is_deferred flag in the availability control TLV so FW
applies a deferred schedule change at the next DW boundary, and report
the NAN_UNI_EVENT_ID_SCHED_UPDATE_DONE and STARTED_CLUSTER events to
mac80211 via ieee80211_nan_sched_update_done() and
ieee80211_nan_cluster_joined().

Both events arrive on the BH-disabled MCU RX path, where notifying
mac80211 inline is wrong: ieee80211_nan_sched_update_done() needs the
wiphy mutex and may sleep, and ieee80211_nan_cluster_joined() would
fire during NAN_START before mac80211 sets sdata->u.nan.started and
before the supplicant subscribes to NL80211_MCGRP_NAN, so the
self-anchor cluster-join is lost and a solo anchor master can never
publish a service.

Deliver both events from a shared nan_deferred_work selected by a
pending bitmap instead. The bitmap spinlock is taken with
spin_lock_bh() on the RX side, the work re-checks nan_vif under the
wiphy mutex, and the stop path clears the bitmap. STARTED_CLUSTER
signals new_cluster=true, and JOINED_CLUSTER is corrected to
new_cluster=false.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Co-developed-by: Stella Liu <yu-ching.liu@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Signed-off-by: Jacobs Wu <jacobs.wu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/init.c  |  2 +
 .../net/wireless/mediatek/mt76/mt7925/main.c  |  7 ++
 .../wireless/mediatek/mt76/mt7925/mt7925.h    |  1 +
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 85 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7925/nan.h   | 11 ++-
 .../net/wireless/mediatek/mt76/mt7925/pci.c   |  1 +
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  8 ++
 7 files changed, 111 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/init.c b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
index cd22fcc021b1..8c3049b66a85 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/init.c
@@ -270,6 +270,8 @@ int mt7925_register_device(struct mt792x_dev *dev)
 
 	INIT_WORK(&dev->reset_work, mt7925_mac_reset_work);
 	INIT_WORK(&dev->init_work, mt7925_init_work);
+	INIT_WORK(&dev->nan_deferred_work, mt7925_nan_deferred_work);
+	spin_lock_init(&dev->nan_deferred_lock);
 
 	INIT_WORK(&dev->phy.roc_work, mt7925_roc_work);
 	timer_setup(&dev->phy.roc_timer, mt792x_roc_timer, 0);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 93de42c2bfd9..e1c688af7c59 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -2613,6 +2613,13 @@ static int mt7925_stop_nan(struct ieee80211_hw *hw,
 	struct mt792x_dev *dev = mt792x_hw_dev(hw);
 	int err, ret;
 
+	/* Drop a deferred event queued just before stop so a stale cluster_id
+	 * cannot leak into a restart; the work re-checks liveness anyway.
+	 */
+	spin_lock_bh(&dev->nan_deferred_lock);
+	dev->nan_deferred_pending = 0;
+	spin_unlock_bh(&dev->nan_deferred_lock);
+
 	mt792x_mutex_acquire(dev);
 
 	err = mt7925_nan_disable(vif, dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
index 321e732347f2..33782d9ba9ed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h
@@ -361,6 +361,7 @@ void mt7925_mcu_set_suspend_iter(void *priv, u8 *mac,
 void mt7925_connac_mcu_set_suspend_iter(void *priv, u8 *mac,
 					struct ieee80211_vif *vif);
 void mt7925_set_ipv6_ns_work(struct work_struct *work);
+void mt7925_nan_deferred_work(struct work_struct *work);
 
 int mt7925_mcu_set_sniffer(struct mt792x_dev *dev, struct ieee80211_vif *vif,
 			   bool enable);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 1f695f0c4473..4b479edab018 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -454,9 +454,27 @@ mt7925_nan_mcu_handle_de_event(struct mt792x_dev *dev, struct tlv *tlv)
 	dev_dbg(dev->mt76.dev, "nan: evt=%u cluster=%pM\n",
 		de_evt->event_type, de_evt->cluster_id);
 
-	if (de_evt->event_type != NAN_EVENT_ID_JOINED_CLUSTER)
+	if (de_evt->event_type != NAN_EVENT_ID_JOINED_CLUSTER &&
+	    de_evt->event_type != NAN_EVENT_ID_STARTED_CLUSTER)
 		return;
 
+	/* STARTED_CLUSTER fires during NAN_START, before nan.started is set and
+	 * before the supplicant subscribes - defer past NAN_START via the work
+	 * so ieee80211_nan_cluster_joined() actually reaches userspace.
+	 */
+	if (de_evt->event_type == NAN_EVENT_ID_STARTED_CLUSTER) {
+		dev_dbg(dev->mt76.dev,
+			"nan: deferring STARTED_CLUSTER cluster=%pM\n",
+			cluster_id);
+		spin_lock_bh(&dev->nan_deferred_lock);
+		memcpy(dev->nan_started_cluster_id, cluster_id, ETH_ALEN);
+		set_bit(MT7925_NAN_DEFERRED_STARTED_CLUSTER,
+			&dev->nan_deferred_pending);
+		spin_unlock_bh(&dev->nan_deferred_lock);
+		ieee80211_queue_work(dev->mt76.hw, &dev->nan_deferred_work);
+		return;
+	}
+
 	if (!dev->nan_vif || !ieee80211_vif_nan_started(dev->nan_vif)) {
 		dev_warn(dev->mt76.dev, "nan: joined-cluster event but NAN not started\n");
 		return;
@@ -468,7 +486,43 @@ mt7925_nan_mcu_handle_de_event(struct mt792x_dev *dev, struct tlv *tlv)
 	dev_dbg(dev->mt76.dev, "nan: own_nmi=%pM master_nmi=%pM\n",
 		de_evt->own_nmi, de_evt->master_nmi);
 
-	ieee80211_nan_cluster_joined(dev->nan_vif, cluster_id, true, GFP_KERNEL);
+	/* joined an existing cluster, not a self-anchored new one */
+	ieee80211_nan_cluster_joined(dev->nan_vif, cluster_id, false, GFP_KERNEL);
+}
+
+/* Runs the deferred NAN MCU events in process context; takes wiphy_lock
+ * before nan_vif, which the NAN stop path frees under that mutex.
+ */
+void
+mt7925_nan_deferred_work(struct work_struct *work)
+{
+	struct mt792x_dev *dev = container_of(work, struct mt792x_dev,
+					      nan_deferred_work);
+	struct ieee80211_vif *vif;
+	unsigned long pending;
+	u8 cluster_id[ETH_ALEN];
+
+	spin_lock_bh(&dev->nan_deferred_lock);
+	pending = dev->nan_deferred_pending;
+	dev->nan_deferred_pending = 0;
+	memcpy(cluster_id, dev->nan_started_cluster_id, ETH_ALEN);
+	spin_unlock_bh(&dev->nan_deferred_lock);
+
+	if (!pending)
+		return;
+
+	wiphy_lock(dev->mt76.hw->wiphy);
+	vif = dev->nan_vif;
+	if (!vif || !ieee80211_vif_nan_started(vif))
+		goto out;
+
+	if (test_bit(MT7925_NAN_DEFERRED_STARTED_CLUSTER, &pending))
+		ieee80211_nan_cluster_joined(vif, cluster_id, true, GFP_KERNEL);
+
+	if (test_bit(MT7925_NAN_DEFERRED_SCHED_UPDATE_DONE, &pending))
+		ieee80211_nan_sched_update_done(vif);
+out:
+	wiphy_unlock(dev->mt76.hw->wiphy);
 }
 
 static void
@@ -517,6 +571,27 @@ mt7925_nan_handle_ulw_update(struct mt792x_dev *dev, struct tlv *tlv)
 				GFP_KERNEL);
 }
 
+static void
+mt7925_nan_handle_sched_update_done(struct mt792x_dev *dev, struct tlv *tlv)
+{
+	struct ieee80211_vif *vif;
+
+	if (!dev || !tlv)
+		return;
+
+	vif = dev->nan_vif;
+	if (!vif || !ieee80211_vif_nan_started(vif))
+		return;
+
+	/* Runs in the BH-disabled MCU-event RX path; the mac80211 helper needs
+	 * the wiphy mutex and may sleep, so hand it to the work instead.
+	 */
+	spin_lock_bh(&dev->nan_deferred_lock);
+	set_bit(MT7925_NAN_DEFERRED_SCHED_UPDATE_DONE, &dev->nan_deferred_pending);
+	spin_unlock_bh(&dev->nan_deferred_lock);
+	ieee80211_queue_work(dev->mt76.hw, &dev->nan_deferred_work);
+}
+
 void mt7925_nan_mcu_event(struct mt792x_dev *dev, struct sk_buff *skb)
 {
 	struct tlv *tlv;
@@ -548,6 +623,9 @@ void mt7925_nan_mcu_event(struct mt792x_dev *dev, struct sk_buff *skb)
 		case NAN_UNI_EVENT_ID_ULW_UPDATE:
 			mt7925_nan_handle_ulw_update(dev, tlv);
 			break;
+		case NAN_UNI_EVENT_ID_SCHED_UPDATE_DONE:
+			mt7925_nan_handle_sched_update_done(dev, tlv);
+			break;
 		default:
 			break;
 		}
@@ -585,6 +663,7 @@ static int mt7925_nan_avail_ctrl_tlv(struct sk_buff *skb,
 	avail_ctrl_tlv->avail_ctrl =
 		cpu_to_le16(ctrl & NAN_AVAIL_CTRL_CHECK_FOR_CHANGED);
 	avail_ctrl_tlv->seq_id = seq_id;
+	avail_ctrl_tlv->is_deferred = sched->deferred ? 1 : 0;
 
 	return 0;
 }
@@ -710,7 +789,7 @@ void mt7925_nan_local_sched_changed(struct mt792x_dev *dev,
 		goto out;
 	}
 
-	mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(NAN), true);
+	mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(NAN), false);
 out:
 	mt792x_mutex_release(dev);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index 1e8f5b76fc3d..c78a1350c456 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -96,15 +96,24 @@ enum nan_uni_cmd_tag {
 enum nan_uni_event_tag {
 	NAN_UNI_EVENT_ID_DE_EVENT_IND		= 19,
 	NAN_UNI_EVENT_ID_ULW_UPDATE		= 39,
+	NAN_UNI_EVENT_ID_SCHED_UPDATE_DONE	= 43,
 	NAN_UNI_EVENT_REPORT_DW_START		= 59,
 	NAN_UNI_EVENT_REPORT_DW_END		= 60,
 };
 
 enum nan_disc_event_type {
 	NAN_EVENT_ID_DISC_MAC_ADDR		= 0,
+	NAN_EVENT_ID_STARTED_CLUSTER		= 1,
 	NAN_EVENT_ID_JOINED_CLUSTER		= 2,
 };
 
+/* bit indices into mt792x_dev->nan_deferred_pending, set from the atomic
+ * MCU-event RX path and consumed by mt7925_nan_deferred_work()
+ */
+enum mt7925_nan_deferred_event {
+	MT7925_NAN_DEFERRED_STARTED_CLUSTER,
+	MT7925_NAN_DEFERRED_SCHED_UPDATE_DONE,
+};
 /* NAN 4.0 Table 79. Device Capability attribute format, Supported Bands */
 enum nan_supported_bands {
 	NAN_SUPPORTED_BAND_ID_2P4G = 2,
@@ -344,7 +353,7 @@ struct mt7925_nan_avail_ctrl_tlv {
 	__le16 len;
 	__le16 avail_ctrl;
 	u8 seq_id;
-	u8 reserved[1];
+	u8 is_deferred;
 } __packed __aligned(4);
 
 struct mt7925_nan_ch_timeline {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 02ef09dd797d..24585c992ff5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -55,6 +55,7 @@ static void mt7925e_unregister_device(struct mt792x_dev *dev)
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_delayed_work_sync(&dev->mlo_pm_work);
 	cancel_work_sync(&pm->wake_work);
+	cancel_work_sync(&dev->nan_deferred_work);
 
 	mt7925_tx_token_put(dev);
 	__mt792x_mcu_drv_pmctrl(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 9efc251cb745..9722d840c1af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -342,6 +342,14 @@ struct mt792x_dev {
 	struct ieee80211_vif *nan_vif;
 	const struct ieee80211_iface_combination *iface_combinations;
 	int n_iface_combinations;
+	/* deferred NAN MCU events run out of the atomic RX path on one shared
+	 * work; see mt7925_nan_deferred_work() and enum mt7925_nan_deferred_event
+	 */
+	struct work_struct nan_deferred_work;
+	/* protects @nan_deferred_pending */
+	spinlock_t nan_deferred_lock;
+	unsigned long nan_deferred_pending;
+	u8 nan_started_cluster_id[ETH_ALEN];
 };
 
 static inline struct mt792x_bss_conf *
-- 
2.43.0


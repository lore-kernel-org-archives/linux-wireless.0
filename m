Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB2CC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:25:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CBC420857
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 13:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552310712;
	bh=7kw3EmSURCfeUEniczpPjTpIoFX8HLv8ZzNeCnfD0PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ghxHOOJRvNox3mrzTnaC5uN0im8G1IaC3pVMMvPHZsavynBrive2+O94ejfnJbOtm
	 Nznl+zFbbG4k5xIusMDViBLnYgMTtzkm6l6UCqLxD23Hz2OiKFgi5sFb0G1P1ypP8f
	 xt70h6XPoBba11eo7alDTxeLys3E4G67zkYG+YFc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfCKNZL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727899AbfCKNY5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 09:24:57 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E812820857;
        Mon, 11 Mar 2019 13:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552310696;
        bh=7kw3EmSURCfeUEniczpPjTpIoFX8HLv8ZzNeCnfD0PM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Prs3GzH5iynYXzaxYH/8ztP8mv03BdMroJ9Dbpcwcj6RpfI8TR4hFJ13PZjfmowFk
         TADwxXvgvH3sGAWX9Mi9rCVXumjaokXHA+R9oU5BC3L//FvIiqJV9s4Y3XvzReBGhZ
         RqM8AkEo+XnDFjmgw9kAv3wChkMHFdMaF6hh+1Dk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH v2] mt76: fix schedule while atomic in mt76x02_reset_state
Date:   Mon, 11 Mar 2019 14:24:35 +0100
Message-Id: <f5d501960f82e62806e4a4566e0b50795b2103db.1552309862.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552309862.git.lorenzo@kernel.org>
References: <cover.1552309862.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix following schedule while atomic in mt76x02_reset_state
since synchronize_rcu is run inside a RCU section

[44036.944222] mt76x2e 0000:06:00.0: MCU message 31 (seq 3) timed out
[44036.944281] BUG: sleeping function called from invalid context at kernel/rcu/tree_exp.h:818
[44036.944284] in_atomic(): 1, irqs_disabled(): 0, pid: 28066, name: kworker/u4:1
[44036.944287] INFO: lockdep is turned off.
[44036.944292] CPU: 1 PID: 28066 Comm: kworker/u4:1 Tainted: G        W         5.0.0-rc7-wdn-t1+ #7
[44036.944294] Hardware name: Dell Inc. Studio XPS 1340/0K183D, BIOS A11 09/08/2009
[44036.944305] Workqueue: phy1 mt76x02_wdt_work [mt76x02_lib]
[44036.944308] Call Trace:
[44036.944317]  dump_stack+0x67/0x90
[44036.944322]  ___might_sleep.cold.88+0x9f/0xaf
[44036.944327]  rcu_blocking_is_gp+0x13/0x50
[44036.944330]  synchronize_rcu+0x17/0x80
[44036.944337]  mt76_sta_state+0x138/0x1d0 [mt76]
[44036.944349]  mt76x02_wdt_work+0x1c9/0x610 [mt76x02_lib]
[44036.944355]  process_one_work+0x2a5/0x620
[44036.944361]  worker_thread+0x35/0x3e0
[44036.944368]  kthread+0x11c/0x140
[44036.944376]  ret_from_fork+0x3a/0x50
[44036.944384] BUG: scheduling while atomic: kworker/u4:1/28066/0x00000002
[44036.944387] INFO: lockdep is turned off.
[44036.944389] Modules linked in: cmac ctr ccm af_packet snd_hda_codec_hdmi

Introduce __mt76_sta_remove in order to run sta_remove without holding dev->mutex.
Move __mt76_sta_remove outside of RCU section in mt76x02_reset_state

Fixes: e4ebb8b403d1 ("mt76: mt76x2: implement full device restart on watchdog reset")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- fix checkpatch warnings
- add lockdep_assert_held in mt76x02_reset_state
- access wcid pointer through rcu_dereference_protected()
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 18 +++++++++++-------
 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 ++
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 19 ++++++++++---------
 3 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index a033745adb2f..316167404729 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -679,19 +679,15 @@ mt76_sta_add(struct mt76_dev *dev, struct ieee80211_vif *vif,
 	return ret;
 }
 
-static void
-mt76_sta_remove(struct mt76_dev *dev, struct ieee80211_vif *vif,
-	        struct ieee80211_sta *sta)
+void __mt76_sta_remove(struct mt76_dev *dev, struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta)
 {
 	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
-	int idx = wcid->idx;
-	int i;
+	int i, idx = wcid->idx;
 
 	rcu_assign_pointer(dev->wcid[idx], NULL);
 	synchronize_rcu();
 
-	mutex_lock(&dev->mutex);
-
 	if (dev->drv->sta_remove)
 		dev->drv->sta_remove(dev, vif, sta);
 
@@ -699,7 +695,15 @@ mt76_sta_remove(struct mt76_dev *dev, struct ieee80211_vif *vif,
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		mt76_txq_remove(dev, sta->txq[i]);
 	mt76_wcid_free(dev->wcid_mask, idx);
+}
+EXPORT_SYMBOL_GPL(__mt76_sta_remove);
 
+static void
+mt76_sta_remove(struct mt76_dev *dev, struct ieee80211_vif *vif,
+		struct ieee80211_sta *sta)
+{
+	mutex_lock(&dev->mutex);
+	__mt76_sta_remove(dev, vif, sta);
 	mutex_unlock(&dev->mutex);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 477027bb9aaf..eb72e4bf3db6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -697,6 +697,8 @@ int mt76_sta_state(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta,
 		   enum ieee80211_sta_state old_state,
 		   enum ieee80211_sta_state new_state);
+void __mt76_sta_remove(struct mt76_dev *dev, struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta);
 
 struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 6a34a6afcfe4..531779d8856e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -423,19 +423,23 @@ static void mt76x02_reset_state(struct mt76x02_dev *dev)
 {
 	int i;
 
+	lockdep_assert_held(&dev->mt76.mutex);
+
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 
 	rcu_read_lock();
-
 	ieee80211_iter_keys_rcu(dev->mt76.hw, NULL, mt76x02_key_sync, NULL);
+	rcu_read_unlock();
 
 	for (i = 0; i < ARRAY_SIZE(dev->mt76.wcid); i++) {
-		struct mt76_wcid *wcid = rcu_dereference(dev->mt76.wcid[i]);
-		struct mt76x02_sta *msta;
 		struct ieee80211_sta *sta;
 		struct ieee80211_vif *vif;
+		struct mt76x02_sta *msta;
+		struct mt76_wcid *wcid;
 		void *priv;
 
+		wcid = rcu_dereference_protected(dev->mt76.wcid[i],
+					lockdep_is_held(&dev->mt76.mutex));
 		if (!wcid)
 			continue;
 
@@ -445,13 +449,10 @@ static void mt76x02_reset_state(struct mt76x02_dev *dev)
 		priv = msta->vif;
 		vif = container_of(priv, struct ieee80211_vif, drv_priv);
 
-		mt76_sta_state(dev->mt76.hw, vif, sta,
-			       IEEE80211_STA_NONE, IEEE80211_STA_NOTEXIST);
+		__mt76_sta_remove(&dev->mt76, vif, sta);
 		memset(msta, 0, sizeof(*msta));
 	}
 
-	rcu_read_unlock();
-
 	dev->vif_mask = 0;
 	dev->beacon_mask = 0;
 }
@@ -471,11 +472,11 @@ static void mt76x02_watchdog_reset(struct mt76x02_dev *dev)
 	for (i = 0; i < ARRAY_SIZE(dev->mt76.napi); i++)
 		napi_disable(&dev->mt76.napi[i]);
 
+	mutex_lock(&dev->mt76.mutex);
+
 	if (restart)
 		mt76x02_reset_state(dev);
 
-	mutex_lock(&dev->mt76.mutex);
-
 	if (dev->beacon_mask)
 		mt76_clear(dev, MT_BEACON_TIME_CFG,
 			   MT_BEACON_TIME_CFG_BEACON_TX |
-- 
2.20.1


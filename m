Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DBF3955C7
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785596028; cv=none; b=VGjV6TZ8qxZnDRkwExx1xyCPTiY+0J+hJR+djJ/ykCBLhcodM02aEQn0JIeWsdMzFyRA83huGMFIS+lyAUeKvBOix6SutpAJjW/g46krgxMFsjGCRaN7poN+a/ZrIieR/mUGEE3HWcUw3k4Z1ETMf01oALRV7kJZ5rRIvw65Ta0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785596028; c=relaxed/simple;
	bh=PPBrHmtkYshieAYuxhfi7zNTZuM5y5XLBX7D6agx+hQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8WS4ZdzbOG7WoZe+wpIrISlaU1wfvldPrbsfGT1adQxKzhEQ90obLAJaP9k2QMsRIHLHguaJMMPYSONS2oSIR2z5sv7mG95V4TLJVgeQOSpaVxCp09v3tvjgaCve19QdQGTGNooP4gZljJqd5F2mzl/lZx7h37gAGpyhG4bEc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=TncbU+bF; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="TncbU+bF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XaEQDH03KyvF/8fvNl3uP1yz6CTALy7wx3+GvJtmJPU=; b=TncbU+bF8I2D/3L/3x7BRE/9C+
	7BLE3VJPuttCYmh1MV+B3BuMBsgcrTidyFjMB4DfwILQlAwHMTBQf1QozQCCdIa13tAyIOzqmNlG3
	w7jEfE+v4aSwRpjQcTLBafUfE8YFgeLdFV+CsWTJUezIMRS4ntwFUsKOSt2BcibSb1xM=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wqB5m-009znC-1I
	for linux-wireless@vger.kernel.org;
	Sat, 01 Aug 2026 16:53:38 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 07/10] wifi: mt76: mt7603: restore hardware PS buffering after a service period
Date: Sat,  1 Aug 2026 14:53:31 +0000
Message-ID: <20260801145334.1166751-7-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260801145334.1166751-1-nbd@nbd.name>
References: <20260801145334.1166751-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Releasing buffered frames has to turn off the PSE redirect for the
station, otherwise the released frames are looped straight back into the
driver PS queue. Nothing ever turns it back on: mt7603_sta_ps() only runs
on an observed PM bit transition, and MT_WCID_FLAG_PS keeps mt76 from
reporting the same state twice. After the first service period the
hardware therefore treats a dozing station as awake and transmits at it
directly, which is where the retry storms and the packet loss reported
against U-APSD clients come from.

Re-arm hardware buffering from mt7603_mac_work() for every station that
is still known to be asleep, once the PSD queue has drained and the
released frames have passed the redirect stage. Frames that are still
queued belong to the service period that was just served, so unlike on a
sleep transition they must not be pulled back with mt7603_filter_tx().

Track the sleep state separately from the WTBL state, so a station that
wakes up while the re-arm is pending is not put back to sleep.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7603/mac.c   | 73 +++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt7603/main.c  |  2 +-
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  4 +
 3 files changed, 72 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index d3110eeb45d7..fa0bf9a201ce 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -235,16 +235,17 @@ void mt7603_wtbl_set_smps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 	sta->smps = enabled;
 }
 
-void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
-			bool enabled)
+static void
+__mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
+		     bool enabled, bool filter)
 {
 	int idx = sta->wcid.idx;
 	u32 addr;
 
-	spin_lock_bh(&dev->ps_lock);
+	lockdep_assert_held(&dev->ps_lock);
 
 	if (sta->ps == enabled)
-		goto out;
+		return;
 
 	mt76_wr(dev, MT_PSE_RTA,
 		FIELD_PREP(MT_PSE_RTA_TAG_ID, idx) |
@@ -255,7 +256,7 @@ void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 
 	mt76_poll(dev, MT_PSE_RTA, MT_PSE_RTA_BUSY, 0, 5000);
 
-	if (enabled)
+	if (enabled && filter)
 		mt7603_filter_tx(dev, sta->vif->idx, idx, false);
 
 	addr = mt7603_wtbl1_addr(idx);
@@ -264,8 +265,34 @@ void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 		 enabled * MT_WTBL1_W3_POWER_SAVE);
 	mt76_clear(dev, MT_WTBL1_OR, MT_WTBL1_OR_PSM_WRITE);
 	sta->ps = enabled;
+}
 
-out:
+void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
+			bool enabled)
+{
+	spin_lock_bh(&dev->ps_lock);
+	__mt7603_wtbl_set_ps(dev, sta, enabled, enabled);
+	spin_unlock_bh(&dev->ps_lock);
+}
+
+void mt7603_wtbl_sta_ps(struct mt7603_dev *dev, struct mt7603_sta *sta, bool ps)
+{
+	spin_lock_bh(&dev->ps_lock);
+	sta->ps_sleeping = ps;
+	__mt7603_wtbl_set_ps(dev, sta, ps, ps);
+	spin_unlock_bh(&dev->ps_lock);
+}
+
+void mt7603_wtbl_restore_ps(struct mt7603_dev *dev, struct mt7603_sta *sta)
+{
+	spin_lock_bh(&dev->ps_lock);
+	/*
+	 * Frames that are already queued for the station belong to the service
+	 * period that has just been served, so unlike on a sleep transition
+	 * they must not be pulled back into the PS queue.
+	 */
+	if (sta->ps_sleeping)
+		__mt7603_wtbl_set_ps(dev, sta, true, false);
 	spin_unlock_bh(&dev->ps_lock);
 }
 
@@ -1816,6 +1843,39 @@ mt7603_false_cca_check(struct mt7603_dev *dev)
 	mt7603_adjust_sensitivity(dev);
 }
 
+/*
+ * Releasing buffered frames turns off the PSE redirect for a station, since
+ * the released frames would otherwise be looped back into the driver PS queue
+ * again. mac80211 never tells us when the service period is over, so hardware
+ * buffering has to be re-armed here for every station that is still known to
+ * be asleep. Waiting for the PSD queue to drain makes sure that the released
+ * frames have already passed the redirect stage.
+ */
+static void
+mt7603_mac_ps_check(struct mt7603_dev *dev)
+{
+	int i;
+
+	if (dev->mphy.q_tx[MT_TXQ_PSD]->queued)
+		return;
+
+	rcu_read_lock();
+	for (i = 0; i < MT7603_WTBL_STA; i++) {
+		struct mt76_wcid *wcid = mt76_wcid_ptr(dev, i);
+		struct mt7603_sta *msta;
+
+		if (!wcid || !wcid->sta)
+			continue;
+
+		msta = container_of(wcid, struct mt7603_sta, wcid);
+		if (msta->ps || !msta->ps_sleeping)
+			continue;
+
+		mt7603_wtbl_restore_ps(dev, msta);
+	}
+	rcu_read_unlock();
+}
+
 void mt7603_mac_work(struct work_struct *work)
 {
 	struct mt7603_dev *dev = container_of(work, struct mt7603_dev,
@@ -1830,6 +1890,7 @@ void mt7603_mac_work(struct work_struct *work)
 	dev->mphy.mac_work_count++;
 	mt76_update_survey(&dev->mphy);
 	mt7603_edcca_check(dev);
+	mt7603_mac_ps_check(dev);
 
 	for (i = 0, idx = 0; i < 2; i++) {
 		u32 val = mt76_rr(dev, MT_TX_AGG_CNT(i));
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index c968ee3d591a..757664e9e1f2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -410,7 +410,7 @@ mt7603_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 	struct sk_buff_head list;
 
 	mt76_stop_tx_queues(&dev->mphy, sta, true);
-	mt7603_wtbl_set_ps(dev, msta, ps);
+	mt7603_wtbl_sta_ps(dev, msta, ps);
 	if (ps)
 		return;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 071bfab3af7c..5b0ecd01aad9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -80,6 +80,7 @@ struct mt7603_sta {
 	u8 smps;
 
 	u8 ps;
+	u8 ps_sleeping;
 };
 
 struct mt7603_vif {
@@ -229,6 +230,9 @@ int mt7603_wtbl_set_key(struct mt7603_dev *dev, int wcid,
 			struct ieee80211_key_conf *key);
 void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 			bool enabled);
+void mt7603_wtbl_sta_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
+			bool ps);
+void mt7603_wtbl_restore_ps(struct mt7603_dev *dev, struct mt7603_sta *sta);
 void mt7603_wtbl_set_smps(struct mt7603_dev *dev, struct mt7603_sta *sta,
 			  bool enabled);
 void mt7603_filter_tx(struct mt7603_dev *dev, int mac_idx, int idx, bool abort);
-- 
2.53.0


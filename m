Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F37F4FECC0
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896774; cv=none; b=qlRmsANoRC2XXAtItMhvEcr4kIvwRjjf3q/BqP19CpzCicbUhVJZcQ8SJQra6cbgtt2ONYRNT3pDV2d4dKGvYssifaNU5XvpygUGfDyldhZRaKCVTJJY18T3/Lu1z+768/I1XTahFuO5xf82DgA4Jjf6p8bw/nNNQ48OL/ymbmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896774; c=relaxed/simple;
	bh=iwZ/tVUvyRQKEE6YhXksTN2qdXRhifkmNRvVF5FrdR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlqKl/7oNvKVh5XzkT3iSvDwCD79ujlGFRAMT6AupOB1G73mN2DACH7atvSLPesUlitCowhW7og0r8cDKqf9vrzaBqPH+RKR3SY8c+7xaSFzLhXglXVNCE0ULs1OIU9JOMxawnPMqVfZiQWu52m8Qo8EyTt9e4tTizUgh/RBvBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=LN78gVAE; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="LN78gVAE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=X8AqUL7RYU3uO7JT3ufiqIOdouPtI2iBW7R/sy6NhhM=;
	t=1791896772; x=1793106372; b=LN78gVAEu3ph8J1rRS871vlHdNo0V/oV0y21GgyGlPhG58s
	7Is3DdoRgZpCpsPr2n/9xGi0lsWq/ZMmtXEle8mNNndutx1Lt9+Fre8hR2nIBhCh7rvuFWTEI4pUK
	YoiTDttaJmgjck9urciFliSN1NiZQMymOX6qXfYZFv1ANdufIqS0i0w0/jYZiRveOwse8cHYRIczC
	1kUMf0XJGqDAPISxrHnvWVTQ/WC9VV4CKPQU4MsTyifWirRTmByiMQZ2hjzSMmqQYduupVuI3U91c
	Sm/bmyK+wIDZ2dd6U8BTQkcTMD5nN8XpX+//ynMikRfMdt0QMrkSs0+BrlvtjPfw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcCo-0000000HPRi-0QCe;
	Tue, 13 Oct 2026 15:06:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 02/11] wifi: mac80211: replace ieee80211_iter_keys_rcu()
Date: Tue, 13 Oct 2026 14:59:04 +0200
Message-ID: <20261013150604.e2fda97f779c.Ic15199f800d8a2bbcf4164ccc0e6f4d5aa0eac06@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013130604.254393-13-johannes@sipsolutions.net>
References: <20261013130604.254393-13-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

This function is unsafe since we reuse the key->list for
deletions after RCU removal. Use a spinlock instead to
protect that, since otherwise we'd have to add a new list
head for a very uncommon case.

Fixes: ef044763a3ca ("mac80211: add atomic uploaded keys iterator")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/d3.c   |  6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c  |  4 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |  4 +-
 drivers/net/wireless/realtek/rtw88/main.c     |  4 +-
 drivers/net/wireless/realtek/rtw88/util.h     |  4 +-
 include/net/mac80211.h                        | 22 +++----
 net/mac80211/ieee80211_i.h                    |  3 +
 net/mac80211/key.c                            | 62 +++++++++++--------
 net/mac80211/key.h                            |  2 +-
 net/mac80211/main.c                           |  1 +
 10 files changed, 60 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index 6d8ede336d59..74165bf5c42a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -1120,9 +1120,9 @@ iwl_mld_process_rsc_notification(struct iwl_mld *mld,
 	};
 
 	/* Iterate through all active keys and update RSC */
-	ieee80211_iter_keys_rcu(mld->hw, vif,
-				iwl_mld_rsc_update_key_iter,
-				&iter_data);
+	ieee80211_iter_keys_atomic(mld->hw, vif,
+				   iwl_mld_rsc_update_key_iter,
+				   &iter_data);
 }
 
 static void
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 1dd27292af9b..fb64b95a632e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -987,9 +987,7 @@ static void iwl_mvm_frob_txf(void *ctx, void *buf, size_t buflen)
 	if (iwl_mvm_has_new_tx_api(mvm))
 		return;
 
-	rcu_read_lock();
-	ieee80211_iter_keys_rcu(mvm->hw, NULL, iwl_mvm_frob_txf_key_iter, &txf);
-	rcu_read_unlock();
+	ieee80211_iter_keys_atomic(mvm->hw, NULL, iwl_mvm_frob_txf_key_iter, &txf);
 }
 
 static void iwl_mvm_frob_hcmd(void *ctx, void *hcmd, size_t len)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index dc7c03d23123..2caba7f5f97f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -398,9 +398,7 @@ static void mt76x02_reset_state(struct mt76x02_dev *dev)
 
 	clear_bit(MT76_STATE_RUNNING, &dev->mphy.state);
 
-	rcu_read_lock();
-	ieee80211_iter_keys_rcu(dev->mt76.hw, NULL, mt76x02_key_sync, NULL);
-	rcu_read_unlock();
+	ieee80211_iter_keys_atomic(dev->mt76.hw, NULL, mt76x02_key_sync, NULL);
 
 	for (i = 0; i < MT76x02_N_WCIDS; i++) {
 		struct ieee80211_sta *sta;
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 0f23498b5c96..f7708ad17b6f 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -662,9 +662,7 @@ static void __fw_recovery_work(struct rtw_dev *rtwdev)
 
 	WARN(1, "firmware crash, start reset and recover\n");
 
-	rcu_read_lock();
-	rtw_iterate_keys_rcu(rtwdev, NULL, rtw_reset_key_iter, rtwdev);
-	rcu_read_unlock();
+	rtw_iterate_keys_atomic(rtwdev, NULL, rtw_reset_key_iter, rtwdev);
 	rtw_iterate_stas_atomic(rtwdev, rtw_reset_sta_iter, rtwdev);
 	rtw_iterate_vifs_atomic(rtwdev, rtw_reset_vif_iter, rtwdev);
 	bitmap_zero(rtwdev->hw_port, RTW_PORT_NUM);
diff --git a/drivers/net/wireless/realtek/rtw88/util.h b/drivers/net/wireless/realtek/rtw88/util.h
index f8399128a9a3..dff02057bd34 100644
--- a/drivers/net/wireless/realtek/rtw88/util.h
+++ b/drivers/net/wireless/realtek/rtw88/util.h
@@ -14,8 +14,8 @@ struct rtw_dev;
 	ieee80211_iterate_stations_atomic(rtwdev->hw, iterator, data)
 #define rtw_iterate_keys(rtwdev, vif, iterator, data)			       \
 	ieee80211_iter_keys(rtwdev->hw, vif, iterator, data)
-#define rtw_iterate_keys_rcu(rtwdev, vif, iterator, data)		       \
-	ieee80211_iter_keys_rcu((rtwdev)->hw, vif, iterator, data)
+#define rtw_iterate_keys_atomic(rtwdev, vif, iterator, data)		       \
+	ieee80211_iter_keys_atomic((rtwdev)->hw, vif, iterator, data)
 
 void rtw_iterate_vifs(struct rtw_dev *rtwdev,
 		      void (*iterator)(void *data, struct ieee80211_vif *vif),
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a1a6409b44c1..2272d7c85dd4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6962,7 +6962,7 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
 			 void *iter_data);
 
 /**
- * ieee80211_iter_keys_rcu - iterate keys programmed into the device
+ * ieee80211_iter_keys_atomic - iterate keys programmed into the device
  * @hw: pointer obtained from ieee80211_alloc_hw()
  * @vif: virtual interface to iterate, may be %NULL for all
  * @iter: iterator function that will be called for each key
@@ -6973,17 +6973,17 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
  * the device. Note that due to locking reasons, keys of station
  * in removal process will be skipped.
  *
- * This function requires being called in an RCU critical section,
- * and thus iter must be atomic.
+ * This function is atomic, so the iter must be as well. Cannot
+ * be used from hardirq context.
  */
-void ieee80211_iter_keys_rcu(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif,
-			     void (*iter)(struct ieee80211_hw *hw,
-					  struct ieee80211_vif *vif,
-					  struct ieee80211_sta *sta,
-					  struct ieee80211_key_conf *key,
-					  void *data),
-			     void *iter_data);
+void ieee80211_iter_keys_atomic(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				void (*iter)(struct ieee80211_hw *hw,
+					     struct ieee80211_vif *vif,
+					     struct ieee80211_sta *sta,
+					     struct ieee80211_key_conf *key,
+					     void *data),
+				void *iter_data);
 
 /**
  * ieee80211_iter_chan_contexts_atomic - iterate channel contexts
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1a6cbbb5a17d..52e413a20f71 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1533,6 +1533,9 @@ struct ieee80211_local {
 	/* protects the aggregated multicast list and filter calls */
 	spinlock_t filter_lock;
 
+	/* protects atomic iteration of each sdata key_list */
+	spinlock_t key_lock;
+
 	/* used for uploading changed mc list */
 	struct wiphy_work reconfig_filter;
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 4c9788ec0b74..b55de973a929 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -532,8 +532,11 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	if (ret)
 		return ret;
 
-	if (new)
-		list_add_tail_rcu(&new->list, &sdata->key_list);
+	if (new) {
+		spin_lock_bh(&sdata->local->key_lock);
+		list_add_tail(&new->list, &sdata->key_list);
+		spin_unlock_bh(&sdata->local->key_lock);
+	}
 
 	if (sta) {
 		if (pairwise) {
@@ -596,8 +599,11 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 							   new->conf.keyidx);
 	}
 
-	if (old)
-		list_del_rcu(&old->list);
+	if (old) {
+		spin_lock_bh(&sdata->local->key_lock);
+		list_del(&old->list);
+		spin_unlock_bh(&sdata->local->key_lock);
+	}
 
 	return 0;
 }
@@ -803,8 +809,8 @@ static void ieee80211_key_destroy(struct ieee80211_key *key,
 		return;
 
 	/*
-	 * Synchronize so the TX path and rcu key iterators
-	 * can no longer be using this key before we free/remove it.
+	 * Synchronize so the TX path can no longer be using this
+	 * key before we free/remove it.
 	 */
 	synchronize_net();
 
@@ -1078,42 +1084,46 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
 EXPORT_SYMBOL(ieee80211_iter_keys);
 
 static void
-_ieee80211_iter_keys_rcu(struct ieee80211_hw *hw,
-			 struct ieee80211_sub_if_data *sdata,
-			 void (*iter)(struct ieee80211_hw *hw,
-				      struct ieee80211_vif *vif,
-				      struct ieee80211_sta *sta,
-				      struct ieee80211_key_conf *key,
-				      void *data),
-			 void *iter_data)
+_ieee80211_iter_keys_atomic(struct ieee80211_hw *hw,
+			    struct ieee80211_sub_if_data *sdata,
+			    void (*iter)(struct ieee80211_hw *hw,
+					 struct ieee80211_vif *vif,
+					 struct ieee80211_sta *sta,
+					 struct ieee80211_key_conf *key,
+					 void *data),
+			    void *iter_data)
 {
 	struct ieee80211_key *key;
 
-	list_for_each_entry_rcu(key, &sdata->key_list, list)
+	list_for_each_entry(key, &sdata->key_list, list)
 		ieee80211_key_iter(hw, &sdata->vif, key, iter, iter_data);
 }
 
-void ieee80211_iter_keys_rcu(struct ieee80211_hw *hw,
-			     struct ieee80211_vif *vif,
-			     void (*iter)(struct ieee80211_hw *hw,
-					  struct ieee80211_vif *vif,
-					  struct ieee80211_sta *sta,
-					  struct ieee80211_key_conf *key,
-					  void *data),
-			     void *iter_data)
+void ieee80211_iter_keys_atomic(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				void (*iter)(struct ieee80211_hw *hw,
+					     struct ieee80211_vif *vif,
+					     struct ieee80211_sta *sta,
+					     struct ieee80211_key_conf *key,
+					     void *data),
+				void *iter_data)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 
+	spin_lock_bh(&local->key_lock);
 	if (vif) {
 		sdata = vif_to_sdata(vif);
-		_ieee80211_iter_keys_rcu(hw, sdata, iter, iter_data);
+		_ieee80211_iter_keys_atomic(hw, sdata, iter, iter_data);
 	} else {
+		rcu_read_lock();
 		list_for_each_entry_rcu(sdata, &local->interfaces, list)
-			_ieee80211_iter_keys_rcu(hw, sdata, iter, iter_data);
+			_ieee80211_iter_keys_atomic(hw, sdata, iter, iter_data);
+		rcu_read_unlock();
 	}
+	spin_unlock_bh(&local->key_lock);
 }
-EXPORT_SYMBOL(ieee80211_iter_keys_rcu);
+EXPORT_SYMBOL(ieee80211_iter_keys_atomic);
 
 static void ieee80211_free_keys_iface(struct ieee80211_sub_if_data *sdata,
 				      struct list_head *keys)
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index c85992493afd..c8531b516c1c 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -62,7 +62,7 @@ struct ieee80211_key {
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
-	/* for sdata list */
+	/* for sdata list - note reuse and local->key_lock locking */
 	struct list_head list;
 
 	/* protected by key mutex */
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 76e85754deff..2d60fe5b3f91 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -990,6 +990,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->rx_path_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
+	spin_lock_init(&local->key_lock);
 
 	local->aql_txq_limit_mc = IEEE80211_DEFAULT_AQL_TXQ_LIMIT_MC;
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-- 
2.56.0


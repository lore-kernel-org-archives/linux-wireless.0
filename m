Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s2.neomailbox.net ([5.148.176.60]:41310 "EHLO s2.neomailbox.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752339AbcJRIzx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 04:55:53 -0400
From: Antonio Quartulli <a@unstable.cc>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
        Antonio Quartulli <antonio@open-mesh.com>
Subject: [NOT FOR MERGE] ath9k: work around key cache corruption
Date: Tue, 18 Oct 2016 16:35:52 +0800
Message-Id: <20161018083552.28592-1-a@unstable.cc> (sfid-20161018_105600_452438_5BAA42B2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

This patch was crafted long time ago to work around a key cache
corruption problem on ath9k chipsets.

The workaround consists in periodically triggering a worker that
uploads all the keys to the HW cache. The worker is triggered also
when the vif detects 21 undecryptable packets.


This patch is based on top compat-wireless-2015-10-26.


I was asked to release this code to the public and, since it is
GPL, I am now doing it.


Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>

---
 drivers/net/wireless/ath/ath.h         |  11 +++
 drivers/net/wireless/ath/ath9k/ath9k.h |   7 ++
 drivers/net/wireless/ath/ath9k/init.c  |   1 +
 drivers/net/wireless/ath/ath9k/main.c  |  21 +++++
 drivers/net/wireless/ath/ath9k/recv.c  |  25 ++++++
 drivers/net/wireless/ath/key.c         | 149 +++++++++++++++++++++++++++++++++
 include/net/mac80211.h                 |   4 +
 net/mac80211/key.c                     |  22 ++---
 net/mac80211/key.h                     |   1 +
 net/mac80211/sta_info.c                |  13 +++
 10 files changed, 243 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 91eeca5..85377bc 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -187,6 +187,13 @@ struct ath_common {
 
 	int last_rssi;
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
+
+	struct {
+		struct mutex mtx;
+		atomic_t running;
+		void (*refresh_cb)(struct ieee80211_sta *sta);
+		struct work_struct refresh_work;
+	} key_cache;
 };
 
 static inline const struct ath_ps_ops *ath_ps_ops(struct ath_common *common)
@@ -201,10 +208,14 @@ bool ath_is_mybeacon(struct ath_common *common, struct ieee80211_hdr *hdr);
 
 void ath_hw_setbssidmask(struct ath_common *common);
 void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key);
+void ath_keys_config(struct ath_common *common);
 int ath_key_config(struct ath_common *common,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_sta *sta,
 			  struct ieee80211_key_conf *key);
+void ath_key_refresher_init(struct ath_common *common,
+			    void (*cb)(struct ieee80211_sta *sta));
+void ath_key_refresher_start(struct ath_common *common);
 bool ath_hw_keyreset(struct ath_common *common, u16 entry);
 void ath_hw_cycle_counters_update(struct ath_common *common);
 int32_t ath_hw_get_listen_time(struct ath_common *common);
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0aab323..3930962 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -23,6 +23,8 @@
 #include <linux/leds.h>
 #include <linux/completion.h>
 #include <linux/time.h>
+#include <linux/hw_random.h>
+#include <net/mac80211.h>
 
 #include "common.h"
 #include "debug.h"
@@ -38,6 +40,8 @@ extern int ath9k_led_blink;
 extern bool is_ath9k_unloaded;
 extern int ath9k_use_chanctx;
 
+#define ATH_RX_DEC_MAX_ERR	20
+
 /*************************/
 /* Descriptor Management */
 /*************************/
@@ -266,6 +270,8 @@ struct ath_node {
 #endif
 	u8 key_idx[4];
 
+	atomic_t decrypt_errors;
+
 	u32 ackto;
 	struct list_head list;
 };
@@ -584,6 +590,7 @@ void ath9k_release_buffered_frames(struct ieee80211_hw *hw,
 				   u16 tids, int nframes,
 				   enum ieee80211_frame_release_type reason,
 				   bool more_data);
+void ath9k_refresh_iter(struct ieee80211_sta *sta);
 
 /********/
 /* VIFs */
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 1b57d12..adec135 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -612,6 +612,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 		common->bt_ant_diversity = 1;
 
 	spin_lock_init(&common->cc_lock);
+	ath_key_refresher_init(common, ath9k_refresh_iter);
 	spin_lock_init(&sc->sc_serial_rw);
 	spin_lock_init(&sc->sc_pm_lock);
 	spin_lock_init(&sc->chan_lock);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 56520ac..8ddb0e0 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -16,6 +16,7 @@
 
 #include <linux/nl80211.h>
 #include <linux/delay.h>
+#include <net/mac80211.h>
 #include "ath9k.h"
 #include "btcoex.h"
 
@@ -1690,6 +1691,9 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	if (sta)
 		an = (struct ath_node *)sta->drv_priv;
 
+	if (sta)
+		an = (struct ath_node *)sta->drv_priv;
+
 	switch (cmd) {
 	case SET_KEY:
 		if (sta)
@@ -1717,6 +1721,14 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 			}
 			WARN_ON(i == ARRAY_SIZE(an->key_idx));
 		}
+		/* QCA chips seems to have a known (and old) bug which corrupts
+		 * the key cache 'every now and then'. We observed that the
+		 * corruption happens after having uploaded a new (GTK) key. For
+		 * this reason we try to refresh the cache each time a key is
+		 * uploaded (we could do this after uploading the GTK only, but
+		 * in this way we try to catch more corruptions at a low cost).
+		 */
+		ath_key_refresher_start(common);
 		break;
 	case DISABLE_KEY:
 		ath_key_delete(common, key);
@@ -1740,6 +1752,15 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 	return ret;
 }
 
+void ath9k_refresh_iter(struct ieee80211_sta *sta)
+{
+	struct ath_node *an;
+
+	an = (struct ath_node *)sta->drv_priv;
+
+	atomic_set(&an->decrypt_errors, 0);
+}
+
 static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_bss_conf *bss_conf,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c9f5baf..e28185e 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -995,12 +995,16 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	struct ieee80211_rx_status *rxs;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_node *an;
 	struct ieee80211_hw *hw = sc->hw;
+	/* TODO remove */
+	struct ieee80211_sta *sta;
 	int retval;
 	struct ath_rx_status rs;
 	enum ath9k_rx_qtype qtype;
 	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
 	int dma_type;
+	u8 rx_status_len = ah->caps.rx_status_len;
 	u64 tsf = 0;
 	unsigned long flags;
 	dma_addr_t new_buf_addr;
@@ -1041,6 +1045,7 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		else
 			hdr_skb = skb;
 
+		hdr = (struct ieee80211_hdr *) (hdr_skb->data + rx_status_len);
 		rxs = IEEE80211_SKB_RXCB(hdr_skb);
 		memset(rxs, 0, sizeof(struct ieee80211_rx_status));
 
@@ -1049,6 +1054,26 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		if (retval)
 			goto requeue_drop_frag;
 
+		/* check if it is the case to refresh the entire key cache.. */
+		if (decrypt_error) {
+			int errors;
+
+			rcu_read_lock();
+			sta = ieee80211_find_sta_by_ifaddr(hw, hdr->addr2, NULL);
+			if (sta) {
+				an = (struct ath_node *)sta->drv_priv;
+				errors = atomic_inc_return(&an->decrypt_errors);
+				/* refresh the cache after some errors */
+				if (errors > ATH_RX_DEC_MAX_ERR) {
+					if (net_ratelimit())
+						printk("ath: %d decryption error for %pM - refreshing cache\n", errors, hdr->addr2);
+					atomic_set(&an->decrypt_errors, 0);
+					ath_key_refresher_start(common);
+				}
+			}
+			rcu_read_unlock();
+		}
+
 		/* Ensure we always have an skb to requeue once we are done
 		 * processing the current buffer's skb */
 		requeue_skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_ATOMIC);
diff --git a/drivers/net/wireless/ath/key.c b/drivers/net/wireless/ath/key.c
index 1816b4e..7896ea6 100644
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -18,6 +18,7 @@
 #include <linux/export.h>
 #include <asm/unaligned.h>
 #include <net/mac80211.h>
+#include "../../../../net/mac80211/key.h"
 
 #include "ath.h"
 #include "reg.h"
@@ -607,3 +608,151 @@ void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf *key)
 	}
 }
 EXPORT_SYMBOL(ath_key_delete);
+
+static int ath_key_refresh(struct ath_common *common, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   struct ieee80211_key_conf *key)
+{
+	struct ath_keyval hk;
+	const u8 *mac = NULL;
+	u8 gmac[ETH_ALEN];
+	int ret = 0;
+	int idx;
+
+	memset(&hk, 0, sizeof(hk));
+
+	switch (key->cipher) {
+	case 0:
+		hk.kv_type = ATH_CIPHER_CLR;
+		break;
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		hk.kv_type = ATH_CIPHER_WEP;
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		hk.kv_type = ATH_CIPHER_TKIP;
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		hk.kv_type = ATH_CIPHER_AES_CCM;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	hk.kv_len = key->keylen;
+	if (key->keylen)
+		memcpy(hk.kv_val, key->key, key->keylen);
+
+	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
+		switch (vif->type) {
+		case NL80211_IFTYPE_AP:
+			memcpy(gmac, vif->addr, ETH_ALEN);
+			gmac[0] |= 0x01;
+			mac = gmac;
+			break;
+		case NL80211_IFTYPE_ADHOC:
+			memcpy(gmac, sta->addr, ETH_ALEN);
+			gmac[0] |= 0x01;
+			mac = gmac;
+			break;
+		default:
+			break;
+		}
+	} else if (key->keyidx) {
+		if (WARN_ON(!sta))
+			return -EOPNOTSUPP;
+		mac = sta->addr;
+
+		if (vif->type == NL80211_IFTYPE_AP)
+			return -EIO;
+	} else {
+		if (WARN_ON(!sta))
+			return -EOPNOTSUPP;
+		mac = sta->addr;
+	}
+
+	/* get the index that is already used by this key */
+	idx = key->hw_key_idx;
+
+	if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
+		ret = ath_setkey_tkip(common, idx, key->key, &hk, mac,
+				      vif->type == NL80211_IFTYPE_AP);
+	else
+		ret = ath_hw_set_keycache_entry(common, idx, &hk, mac);
+
+	if (!ret)
+		return -EIO;
+
+	return 0;
+}
+
+/**
+ * ath_key_config_iter - refresh one key in the cache
+ */
+static void ath_key_config_iter(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta,
+				struct ieee80211_key_conf *keyconf, void *data)
+{
+	struct ath_common *common = data;
+	struct ieee80211_key *key;
+
+	key = container_of(keyconf, struct ieee80211_key, conf);
+
+	/* skip keys which were not programmed into the hardware */
+	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+		return;
+
+	/* delete and re-install the key */
+	ath_key_refresh(common, vif, sta, keyconf);
+}
+
+/**
+ * ath_key_refresher - refresh the entire key cache until it becomes sane
+ */
+static void ath_key_refresher(struct work_struct *work)
+{
+	struct ath_common *common;
+
+	common = container_of(work, struct ath_common, key_cache.refresh_work);
+
+	mutex_lock(&common->key_cache.mtx);
+	ieee80211_iter_keys(common->hw, NULL, ath_key_config_iter, common);
+	mutex_unlock(&common->key_cache.mtx);
+
+	/* invoke the driver callback to reset the private sta state */
+	ieee80211_for_each_sta(common->hw, common->key_cache.refresh_cb);
+
+	atomic_dec(&common->key_cache.running);
+}
+
+void ath_key_refresher_init(struct ath_common *common,
+			    void (*cb)(struct ieee80211_sta *sta))
+{
+	INIT_WORK(&common->key_cache.refresh_work, ath_key_refresher);
+	common->key_cache.refresh_cb = cb;
+	mutex_init(&common->key_cache.mtx);
+	atomic_set(&common->key_cache.running, 0);
+}
+EXPORT_SYMBOL(ath_key_refresher_init);
+
+/**
+ * starts a refresher worker for asynchronous cache refresh
+ */
+void ath_key_refresher_start(struct ath_common *common)
+{
+	if (!atomic_add_unless(&common->key_cache.running, 1, 1))
+		return;
+
+	ieee80211_queue_work(common->hw, &common->key_cache.refresh_work);
+}
+EXPORT_SYMBOL(ath_key_refresher_start);
+
+/**
+ * decrease the refcounter and possibly stop the key refresh worker
+ */
+/*void ath_key_refresher_stop(struct ath_common *common)
+{
+	cancel_work_sync(&common->key_cache.refresh_work);
+}
+EXPORT_SYMBOL(ath_key_refresher_stop);*/
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 19cde95..22d7164 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4775,6 +4775,10 @@ void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif, const u8 *ra,
 struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
 					 const u8 *addr);
 
+/* iterate over stations */
+void ieee80211_for_each_sta(struct ieee80211_hw *hw,
+			    void (*iter)(struct ieee80211_sta *sta));
+
 /**
  * ieee80211_find_sta_by_ifaddr - find a station on hardware
  *
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 44388d6..6373c48 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -320,7 +320,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 		return;
 
 	if (new)
-		list_add_tail(&new->list, &sdata->key_list);
+		list_add_tail_rcu(&new->list, &sdata->key_list);
 
 	WARN_ON(new && old && new->conf.keyidx != old->conf.keyidx);
 
@@ -368,7 +368,7 @@ static void ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (old)
-		list_del(&old->list);
+		list_del_rcu(&old->list);
 }
 
 struct ieee80211_key *
@@ -720,27 +720,27 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
 			 void *iter_data)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_key *key, *tmp;
+	struct ieee80211_key *key;
 	struct ieee80211_sub_if_data *sdata;
 
-	ASSERT_RTNL();
-
-	mutex_lock(&local->key_mtx);
+	/* WARNING removed proper locking + _safe because only intel driver
+	 * depends on it and we need to avoid locking problems
+	 */
+	rcu_read_lock();
 	if (vif) {
 		sdata = vif_to_sdata(vif);
-		list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
+		list_for_each_entry_rcu(key, &sdata->key_list, list)
 			iter(hw, &sdata->vif,
 			     key->sta ? &key->sta->sta : NULL,
 			     &key->conf, iter_data);
 	} else {
-		list_for_each_entry(sdata, &local->interfaces, list)
-			list_for_each_entry_safe(key, tmp,
-						 &sdata->key_list, list)
+		list_for_each_entry_rcu(sdata, &local->interfaces, list)
+			list_for_each_entry_rcu(key, &sdata->key_list, list)
 				iter(hw, &sdata->vif,
 				     key->sta ? &key->sta->sta : NULL,
 				     &key->conf, iter_data);
 	}
-	mutex_unlock(&local->key_mtx);
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(ieee80211_iter_keys);
 
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 5d9e028..d18b132 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -55,6 +55,7 @@ struct ieee80211_key {
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
+	struct work_struct work;
 
 	/* for sdata list */
 	struct list_head list;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6eed9db..ccf0634 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1109,6 +1109,19 @@ struct ieee80211_sta *ieee80211_find_sta_by_ifaddr(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(ieee80211_find_sta_by_ifaddr);
 
+void ieee80211_for_each_sta(struct ieee80211_hw *hw,
+			    void (*iter)(struct ieee80211_sta *sta))
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct sta_info *sta;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &local->sta_list, list)
+		iter(&sta->sta);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(ieee80211_for_each_sta);
+
 struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
 					 const u8 *addr)
 {

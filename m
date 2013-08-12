Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50901 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3HLMHZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 08:07:25 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add APIs to allow keeping connections after WoWLAN
Date: Mon, 12 Aug 2013 14:07:20 +0200
Message-Id: <1376309240-2485-1-git-send-email-johannes@sipsolutions.net> (sfid-20130812_140728_802101_934A3D7D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to be able to (securely) keep connections alive after
the system was suspended for WoWLAN, we need some additional
APIs. We already have API (ieee80211_gtk_rekey_notify) to tell
wpa_supplicant about the new replay counter if GTK rekeying
was done by the device while the host was asleep, but that's
not sufficient.

If GTK rekeying wasn't done, we need to tell the host about
sequence counters for the GTK (and PTK regardless of rekeying)
that was used while asleep, add ieee80211_set_key_rx_seq() for
that.

If GTK rekeying was done, then we need to be able to disable
the old keys (with ieee80211_remove_key()) and allocate the
new GTK key(s) in mac80211 (with ieee80211_gtk_rekey_add()).

If protocol offload (e.g. ARP) is implemented, then also the
TX sequence counter for the PTK must be updated, using the new
ieee80211_set_key_tx_seq() function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |  83 ++++++++++++++++++++++++++
 net/mac80211/key.c     | 154 ++++++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/util.c    |   2 +-
 3 files changed, 231 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index df93c77..e3e3037 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3688,6 +3688,89 @@ void ieee80211_get_key_rx_seq(struct ieee80211_key_conf *keyconf,
 			      int tid, struct ieee80211_key_seq *seq);
 
 /**
+ * ieee80211_set_key_tx_seq - set key TX sequence counter
+ *
+ * @keyconf: the parameter passed with the set key
+ * @seq: new sequence data
+ *
+ * This function allows a driver to set the current TX IV/PNs for the
+ * given key. This is useful when resuming from WoWLAN sleep and the
+ * device may have transmitted frames using the PTK, e.g. replies to
+ * ARP requests.
+ *
+ * Note that this function may only be called when no TX processing
+ * can be done concurrently.
+ */
+void ieee80211_set_key_tx_seq(struct ieee80211_key_conf *keyconf,
+			      struct ieee80211_key_seq *seq);
+
+/**
+ * ieee80211_set_key_rx_seq - set key RX sequence counter
+ *
+ * @keyconf: the parameter passed with the set key
+ * @tid: The TID, or -1 for the management frame value (CCMP only);
+ *	the value on TID 0 is also used for non-QoS frames. For
+ *	CMAC, only TID 0 is valid.
+ * @seq: new sequence data
+ *
+ * This function allows a driver to set the current RX IV/PNs for the
+ * given key. This is useful when resuming from WoWLAN sleep and GTK
+ * rekey may have been done while suspended. It should not be called
+ * if IV checking is done by the device and not by mac80211.
+ *
+ * Note that this function may only be called when no RX processing
+ * can be done concurrently.
+ */
+void ieee80211_set_key_rx_seq(struct ieee80211_key_conf *keyconf,
+			      int tid, struct ieee80211_key_seq *seq);
+
+/**
+ * ieee80211_remove_key - remove the given key
+ * @keyconf: the parameter passed with the set key
+ *
+ * Remove the given key. If the key was uploaded to the hardware at the
+ * time this function is called, it is not deleted in the hardware but
+ * instead assumed to have been removed already.
+ *
+ * Note that due to locking considerations this function can (currently)
+ * only be called during key iteration (ieee80211_iter_keys().)
+ */
+void ieee80211_remove_key(struct ieee80211_key_conf *keyconf);
+
+/**
+ * ieee80211_gtk_rekey_add - add a GTK key from rekeying during WoWLAN
+ * @vif: the virtual interface to add the key on
+ * @keyconf: new key data
+ *
+ * When GTK rekeying was done while the system was suspended, (a) new
+ * key(s) will be available. These will be needed by mac80211 for proper
+ * RX processing, so this function allows setting them.
+ *
+ * The function returns the newly allocated key structure, which will
+ * have similar contents to the passed key configuration but point to
+ * mac80211-owned memory. In case of errors, the function returns an
+ * ERR_PTR(), use IS_ERR() etc.
+ *
+ * Note that this function assumes the key isn't added to hardware
+ * acceleration, so no TX will be done with the key. Since it's a GTK
+ * on managed (station) networks, this is true anyway. If the driver
+ * calls this function from the resume callback and subsequently uses
+ * the return code 1 to reconfigure the device, this key will be part
+ * of the reconfiguration.
+ *
+ * Note that the driver should also call ieee80211_set_key_rx_seq()
+ * for the new key for each TID to set up sequence counters properly.
+ *
+ * IMPORTANT: If this replaces a key that is present in the hardware,
+ * then it will attempt to remove it during this call. In many cases
+ * this isn't what you want, so call ieee80211_remove_key() first for
+ * the key that's being replaced.
+ */
+struct ieee80211_key_conf *
+ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
+			struct ieee80211_key_conf *keyconf);
+
+/**
  * ieee80211_gtk_rekey_notify - notify userspace supplicant of rekeying
  * @vif: virtual interface the rekeying was done on
  * @bssid: The BSSID of the AP, for checking association
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index e39cc91..620677e 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -93,6 +93,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 
 	might_sleep();
 
+	if (key->flags & KEY_FLAG_TAINTED)
+		return -EINVAL;
+
 	if (!key->local->ops->set_key)
 		goto out_unsupported;
 
@@ -455,6 +458,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct sta_info *sta)
 {
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_key *old_key;
 	int idx, ret;
 	bool pairwise;
@@ -484,10 +488,13 @@ int ieee80211_key_link(struct ieee80211_key *key,
 
 	ieee80211_debugfs_key_add(key);
 
-	ret = ieee80211_key_enable_hw_accel(key);
-
-	if (ret)
-		ieee80211_key_free(key, true);
+	if (!local->wowlan) {
+		ret = ieee80211_key_enable_hw_accel(key);
+		if (ret)
+			ieee80211_key_free(key, true);
+	} else {
+		ret = 0;
+	}
 
 	mutex_unlock(&sdata->local->key_mtx);
 
@@ -540,7 +547,7 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
 			 void *iter_data)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_key *key;
+	struct ieee80211_key *key, *tmp;
 	struct ieee80211_sub_if_data *sdata;
 
 	ASSERT_RTNL();
@@ -548,13 +555,14 @@ void ieee80211_iter_keys(struct ieee80211_hw *hw,
 	mutex_lock(&local->key_mtx);
 	if (vif) {
 		sdata = vif_to_sdata(vif);
-		list_for_each_entry(key, &sdata->key_list, list)
+		list_for_each_entry_safe(key, tmp, &sdata->key_list, list)
 			iter(hw, &sdata->vif,
 			     key->sta ? &key->sta->sta : NULL,
 			     &key->conf, iter_data);
 	} else {
 		list_for_each_entry(sdata, &local->interfaces, list)
-			list_for_each_entry(key, &sdata->key_list, list)
+			list_for_each_entry_safe(key, tmp,
+						 &sdata->key_list, list)
 				iter(hw, &sdata->vif,
 				     key->sta ? &key->sta->sta : NULL,
 				     &key->conf, iter_data);
@@ -751,3 +759,135 @@ void ieee80211_get_key_rx_seq(struct ieee80211_key_conf *keyconf,
 	}
 }
 EXPORT_SYMBOL(ieee80211_get_key_rx_seq);
+
+void ieee80211_set_key_tx_seq(struct ieee80211_key_conf *keyconf,
+			      struct ieee80211_key_seq *seq)
+{
+	struct ieee80211_key *key;
+	u64 pn64;
+
+	key = container_of(keyconf, struct ieee80211_key, conf);
+
+	switch (key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_TKIP:
+		key->u.tkip.tx.iv32 = seq->tkip.iv32;
+		key->u.tkip.tx.iv16 = seq->tkip.iv16;
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		pn64 = (u64)seq->ccmp.pn[5] |
+		       ((u64)seq->ccmp.pn[4] << 8) |
+		       ((u64)seq->ccmp.pn[3] << 16) |
+		       ((u64)seq->ccmp.pn[2] << 24) |
+		       ((u64)seq->ccmp.pn[1] << 32) |
+		       ((u64)seq->ccmp.pn[0] << 40);
+		atomic64_set(&key->u.ccmp.tx_pn, pn64);
+		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+		pn64 = (u64)seq->aes_cmac.pn[5] |
+		       ((u64)seq->aes_cmac.pn[4] << 8) |
+		       ((u64)seq->aes_cmac.pn[3] << 16) |
+		       ((u64)seq->aes_cmac.pn[2] << 24) |
+		       ((u64)seq->aes_cmac.pn[1] << 32) |
+		       ((u64)seq->aes_cmac.pn[0] << 40);
+		atomic64_set(&key->u.aes_cmac.tx_pn, pn64);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(ieee80211_set_key_tx_seq);
+
+void ieee80211_set_key_rx_seq(struct ieee80211_key_conf *keyconf,
+			      int tid, struct ieee80211_key_seq *seq)
+{
+	struct ieee80211_key *key;
+	u8 *pn;
+
+	key = container_of(keyconf, struct ieee80211_key, conf);
+
+	switch (key->conf.cipher) {
+	case WLAN_CIPHER_SUITE_TKIP:
+		if (WARN_ON(tid < 0 || tid >= IEEE80211_NUM_TIDS))
+			return;
+		key->u.tkip.rx[tid].iv32 = seq->tkip.iv32;
+		key->u.tkip.rx[tid].iv16 = seq->tkip.iv16;
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		if (WARN_ON(tid < -1 || tid >= IEEE80211_NUM_TIDS))
+			return;
+		if (tid < 0)
+			pn = key->u.ccmp.rx_pn[IEEE80211_NUM_TIDS];
+		else
+			pn = key->u.ccmp.rx_pn[tid];
+		memcpy(pn, seq->ccmp.pn, IEEE80211_CCMP_PN_LEN);
+		break;
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+		if (WARN_ON(tid != 0))
+			return;
+		pn = key->u.aes_cmac.rx_pn;
+		memcpy(pn, seq->aes_cmac.pn, IEEE80211_CMAC_PN_LEN);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+}
+EXPORT_SYMBOL_GPL(ieee80211_set_key_rx_seq);
+
+void ieee80211_remove_key(struct ieee80211_key_conf *keyconf)
+{
+	struct ieee80211_key *key;
+
+	key = container_of(keyconf, struct ieee80211_key, conf);
+
+	assert_key_lock(key->local);
+
+	/*
+	 * if key was uploaded, we assume the driver will/has remove(d)
+	 * it, so adjust bookkeeping accordingly
+	 */
+	if (key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
+		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
+
+		if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
+		      (key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) ||
+		      (key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)))
+			increment_tailroom_need_count(key->sdata);
+	}
+
+	ieee80211_key_free(key, false);
+}
+EXPORT_SYMBOL_GPL(ieee80211_remove_key);
+
+struct ieee80211_key_conf *
+ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
+			struct ieee80211_key_conf *keyconf)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_key *key;
+	int err;
+
+	if (WARN_ON(!local->wowlan))
+		return ERR_PTR(-EINVAL);
+
+	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION))
+		return ERR_PTR(-EINVAL);
+
+	key = ieee80211_key_alloc(keyconf->cipher, keyconf->keyidx,
+				  keyconf->keylen, keyconf->key,
+				  0, NULL);
+	if (IS_ERR(key))
+		return ERR_PTR(PTR_ERR(key));
+
+	if (sdata->u.mgd.mfp != IEEE80211_MFP_DISABLED)
+		key->conf.flags |= IEEE80211_KEY_FLAG_RX_MGMT;
+
+	err = ieee80211_key_link(key, sdata, NULL);
+	if (err)
+		return ERR_PTR(err);
+
+	return &key->conf;
+}
+EXPORT_SYMBOL_GPL(ieee80211_gtk_rekey_add);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d23c5a7..e1b34a1 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1453,8 +1453,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		local->resuming = true;
 
 	if (local->wowlan) {
-		local->wowlan = false;
 		res = drv_resume(local);
+		local->wowlan = false;
 		if (res < 0) {
 			local->resuming = false;
 			return res;
-- 
1.8.0


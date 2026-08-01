Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BDA3E2AA1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 07:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785571121; cv=none; b=ZWYO0glKyqmPvI0XO9j/hmB1aLq7QF1hoFh9L9ixmaBAkSG/q/kjry2ZL5MmIo+bNw3R9Ix+ZFT8AzYTERkJtyNEnBdsZiw6F235PCVoEHfaLVQ7tWNTq4CJskhyb7sM56sADSaNlVTM4RtS7kOKIDqztFCrhiGs09UKxRdV6LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785571121; c=relaxed/simple;
	bh=ZsWhKFgWwQLqumVvnCl5aaIu8AHDrL+UCQ19j7AxXNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cV/X6+TOWh6CovONVjsMkoEw8rBz2hxvLu/3pdHd3py+DH7SuhWi1SulOsFusUv/nhB52gJVOOJPG0kMeMWbGD710cfA0BbWUBnNjP0SL2T9aZvPVd+vT/djJ56VMCYOZuVQsW1YEF4EkAuSgOt5uO7xufj9i891c/cmZQdFsCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=IHFMc8Im; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="IHFMc8Im"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=9oEoVt3+iPQNkCh+a2hXKfPMvSrSciYHSw9Y/+eBhwA=;
	t=1785571118; x=1786780718; b=IHFMc8ImQs0m22Yzee97NLO1KMxYibmLfcW+dRdpEom5AXi
	0EczYpdflVjli+Ws9yihtSvOi9ruSqmVwD0OkDMDl+KSyBDG2glkV4s9TugJRfO11whUR5Z3tA0sM
	v04KFdSg5G+tU/xeLHOqn1QdkHcCJpS5ClWpTUkuJMLfcnnkjYggdknTy+eHahHkHypV4fGrXtjer
	Pxhi008BQwYr0zjxM5E0hFrD/2Jh1QBTs0AAyQKeAcxrZ542IblCUBhVw6/HsspRrvjRcQQYTPUiE
	KejviiMPUy2C1cGnxqvmPQfu9qZIBMCd0iDRALVeWxPcEUEeeYNhZHW56RlPrfMA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wq4c7-0000000ErOv-3cMr;
	Sat, 01 Aug 2026 09:58:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 12/12] wifi: mac80211: optimize RCU on group key rekeying
Date: Sat,  1 Aug 2026 09:58:28 +0200
Message-ID: <20260801095822.143cf4c56562.I8e30528b787541241c5709178d7de643d70e7dc7@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260801075822.645974-14-johannes@sipsolutions.net>
References: <20260801075822.645974-14-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

After the previous change, RCU synchronization is avoided
on the first key install if possible (if it goes to HW).
On the client side, group keys are used only for RX and
therefore don't affect tailroom requirements at all, but
accounting is currently still done for them.

With the previous cleanups and the slot mechanism, it's
now relatively simple to differentiate RX-only keys. Add
a flag to the slot and key (where it tracks for later HW
enablement/disablement etc.) and skip the whole tailroom
accounting for RX-only keys.

This way, no RCU synchronisation is needed on group key
rekeying on the client side.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/key.c | 47 +++++++++++++++++++++++++++++++++-------------
 net/mac80211/key.h |  6 ++++++
 2 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ab92014f67ef..61bebc02c811 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -118,6 +118,13 @@ static void decrease_tailroom_need_count(struct ieee80211_sub_if_data *sdata,
 	sdata->crypto_tx_tailroom_needed_cnt -= delta;
 }
 
+/* RX-only keys don't need tailroom since that's for TX only */
+static bool ieee80211_key_relevant_for_tailroom(struct ieee80211_key *key)
+{
+	return !(key->flags & KEY_FLAG_RX_ONLY);
+}
+
+/* check if this individual key needs tailroom right now */
 static bool ieee80211_key_needs_tailroom(struct ieee80211_key *key)
 {
 	if (key->conf.flags & (IEEE80211_KEY_FLAG_GENERATE_MMIC |
@@ -146,7 +153,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key,
 		 * so clear that flag now to avoid trying to remove
 		 * it again later.
 		 */
-		if (update_tailroom && !ieee80211_key_needs_tailroom(key))
+		if (update_tailroom &&
+		    ieee80211_key_relevant_for_tailroom(key) &&
+		    !ieee80211_key_needs_tailroom(key))
 			increment_tailroom_need_count(sdata);
 
 		key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;
@@ -212,7 +221,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key,
 	if (!ret) {
 		key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
 
-		if (update_tailroom && !ieee80211_key_needs_tailroom(key))
+		if (update_tailroom &&
+		    ieee80211_key_relevant_for_tailroom(key) &&
+		    !ieee80211_key_needs_tailroom(key))
 			decrease_tailroom_need_count(sdata, 1);
 
 		WARN_ON((key->conf.flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE) &&
@@ -282,7 +293,8 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 	    !(sdata->vif.active_links & BIT(key->conf.link_id)))
 		return;
 
-	if (!ieee80211_key_needs_tailroom(key))
+	if (ieee80211_key_relevant_for_tailroom(key) &&
+	    !ieee80211_key_needs_tailroom(key))
 		increment_tailroom_need_count(sdata);
 
 	pubsta = sta ? &sta->sta : NULL;
@@ -515,6 +527,7 @@ int ieee80211_key_slot_lookup(struct ieee80211_sub_if_data *sdata,
 
 		if (cigtk && key_idx < NUM_CTRL_KEYS) {
 			slot->key = &slot->link_sta->rx_cigtk[key_idx];
+			slot->rx_only = true;
 			return 0;
 		}
 
@@ -523,6 +536,7 @@ int ieee80211_key_slot_lookup(struct ieee80211_sub_if_data *sdata,
 			      NUM_DEFAULT_MGMT_KEYS +
 			      NUM_DEFAULT_BEACON_KEYS) {
 			slot->key = &slot->link_sta->rx_gtk[key_idx];
+			slot->rx_only = true;
 			return 0;
 		}
 
@@ -637,7 +651,8 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	 *
 	 * This avoids the RCU synchronize on first key installation.
 	 */
-	if (new && ieee80211_key_needs_tailroom(new))
+	if (new && ieee80211_key_relevant_for_tailroom(new) &&
+	    ieee80211_key_needs_tailroom(new))
 		increment_tailroom_need_count(sdata);
 
 	if (new)
@@ -884,14 +899,16 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key,
 
 		ieee80211_debugfs_key_remove(key);
 
-		if (delay_tailroom) {
-			/* see ieee80211_delayed_tailroom_dec */
-			sdata->crypto_tx_tailroom_pending_dec++;
-			wiphy_delayed_work_queue(sdata->local->hw.wiphy,
-						 &sdata->dec_tailroom_needed_wk,
-						 HZ / 2);
-		} else {
-			decrease_tailroom_need_count(sdata, 1);
+		if (ieee80211_key_relevant_for_tailroom(key)) {
+			if (delay_tailroom) {
+				/* see ieee80211_delayed_tailroom_dec */
+				sdata->crypto_tx_tailroom_pending_dec++;
+				wiphy_delayed_work_queue(sdata->local->hw.wiphy,
+							 &sdata->dec_tailroom_needed_wk,
+							 HZ / 2);
+			} else {
+				decrease_tailroom_need_count(sdata, 1);
+			}
 		}
 	}
 
@@ -1018,6 +1035,8 @@ int ieee80211_key_link(struct ieee80211_sub_if_data *sdata,
 	key->local = sdata->local;
 	key->sdata = sdata;
 	key->sta = slot->sta;
+	if (slot->rx_only)
+		key->flags |= KEY_FLAG_RX_ONLY;
 
 	/*
 	 * Assign a unique ID to every key so we can easily prevent mixed
@@ -1087,7 +1106,8 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
 
 	if (ieee80211_sdata_running(sdata)) {
 		list_for_each_entry(key, &sdata->key_list, list) {
-			if (!(key->flags & KEY_FLAG_TAINTED))
+			if (ieee80211_key_relevant_for_tailroom(key) &&
+			    !(key->flags & KEY_FLAG_TAINTED))
 				increment_tailroom_need_count(sdata);
 			ieee80211_key_enable_hw_accel(key, true);
 		}
@@ -1576,6 +1596,7 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 
 	slot.sta = sta;
 	slot.link_sta = link_sta;
+	slot.rx_only = true;
 
 	if (cigtk)
 		slot.key = &link_sta->rx_cigtk[idx];
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 9604000866a3..38b96d916b38 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -33,10 +33,14 @@ struct sta_info;
  * @KEY_FLAG_UPLOADED_TO_HARDWARE: Indicates that this key is present
  *	in the hardware for TX crypto hardware acceleration.
  * @KEY_FLAG_TAINTED: Key is tainted and packets should be dropped.
+ * @KEY_FLAG_RX_ONLY: Key is installed into an RX-only key slot, so it's
+ *	never used by the TX path and therefore never affects tailroom
+ *	allocation requirements.
  */
 enum ieee80211_internal_key_flags {
 	KEY_FLAG_UPLOADED_TO_HARDWARE	= BIT(0),
 	KEY_FLAG_TAINTED		= BIT(1),
+	KEY_FLAG_RX_ONLY		= BIT(2),
 };
 
 enum ieee80211_internal_tkip_state {
@@ -148,6 +152,8 @@ struct ieee80211_key_slot {
 	struct link_sta_info *link_sta;
 
 	struct ieee80211_link_data *link;
+
+	bool rx_only;
 };
 
 /**
-- 
2.55.0


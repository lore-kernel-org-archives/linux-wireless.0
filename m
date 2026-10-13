Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5856502578
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896780; cv=none; b=aydy1Rd3uhubarVTZvrygC4yMmYWxEcKQOM/6powAg/bhURagbwaQz61QSftPZK91XzygaDRzkXt+rQQM24tFV5hTfui/s+bKcoZMv/+IoT4OPyExs1VkmlAWNEoC/Gyn7aKtR7QV/8dL86dI08eLxVP3XBMwlAGhDfNsHiO2vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896780; c=relaxed/simple;
	bh=iv9ale4RU6C+rRKd0B8LuIwTGcjThMAEsgvBTa+sccE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aiit78MI1PS3hqEdee7EZYwKIOt4OdA5pgVG8D03Bsu5XqSB3mex1N5ndxEKbpTtFFDc51NaObjd2Nd+dXrqMuOqaViSBPfL/OZocsFp1WIwnCYdBMXnbaAUL1TWgRSBYgvKaFjQUg6P4A56Zy3DGbwgpI+ZdOc0n38hArpm4FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=u+9KdbpS; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="u+9KdbpS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=DNSc1KZEkF56CZI0c7f1R2tGuMntkFCUs2r0jAyITpw=;
	t=1791896778; x=1793106378; b=u+9KdbpSZrwBvWl/1jgtFyaTU4LoDKDYqH8/64osBc5G2uq
	CLufJYL4yavja7+Kv0jn6SYcXZVyhsC+Z9KOR9y2AiGy3Sn7Cj7FyKAU9KjIpRIFRt9jLj9Oium47
	/Qd8BL4OiV6NLv3IZDkiRctaeOTGhGvJWtxnVGISxWHKLqEa+ZdsW0HanjIGgAQtOxSkZeqmxVov3
	QhWcZZ2m8SL828qV2+EdQBVDL7kDPwAYJYqe5RJWfPUjRBZrwOHDJab9qF0RAB6xhPL46cKNgTupU
	3JzdpFLmU6Hd/nPv1UmUfhI7yMfaweM3YR9gMD0uV0WmzmPIJJSYXuaTgEUdlnUQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcCu-0000000HPRi-1SIt;
	Tue, 13 Oct 2026 15:06:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 11/11] wifi: mac80211: optimize RCU on group key rekeying
Date: Tue, 13 Oct 2026 14:59:13 +0200
Message-ID: <20261013150605.02513cd5b9cf.I8e30528b787541241c5709178d7de643d70e7dc8@changeid>
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
index caaea117d4e0..a18760cd8209 100644
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
 
 		if (cigtk) {
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
 
 	if (new) {
@@ -890,14 +905,16 @@ static void __ieee80211_key_cleanup(struct ieee80211_key *key,
 
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
 }
@@ -1030,6 +1047,8 @@ int ieee80211_key_link(struct ieee80211_sub_if_data *sdata,
 	key->local = sdata->local;
 	key->sdata = sdata;
 	key->sta = slot->sta;
+	if (slot->rx_only)
+		key->flags |= KEY_FLAG_RX_ONLY;
 
 	/*
 	 * Assign a unique ID to every key so we can easily prevent mixed
@@ -1099,7 +1118,8 @@ void ieee80211_reenable_keys(struct ieee80211_sub_if_data *sdata)
 
 	if (ieee80211_sdata_running(sdata)) {
 		list_for_each_entry(key, &sdata->key_list, list) {
-			if (!(key->flags & KEY_FLAG_TAINTED))
+			if (ieee80211_key_relevant_for_tailroom(key) &&
+			    !(key->flags & KEY_FLAG_TAINTED))
 				increment_tailroom_need_count(sdata);
 			ieee80211_key_enable_hw_accel(key, true);
 		}
@@ -1606,6 +1626,7 @@ ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 
 	slot.sta = sta;
 	slot.link_sta = link_sta;
+	slot.rx_only = true;
 
 	if (cigtk)
 		slot.key = &link_sta->rx_cigtk[idx];
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 2fc985d41e8f..89afe23276c7 100644
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
2.56.0


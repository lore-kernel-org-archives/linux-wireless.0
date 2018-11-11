Return-Path: <SRS0=Soq1=NW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8563BC43441
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 11:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3386320871
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Nov 2018 11:21:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="HPmirl9P"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3386320871
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbeKKVKF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Nov 2018 16:10:05 -0500
Received: from 8.mo177.mail-out.ovh.net ([46.105.61.98]:50452 "EHLO
        8.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbeKKVKE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Nov 2018 16:10:04 -0500
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Nov 2018 16:10:02 EST
Received: from player714.ha.ovh.net (unknown [10.109.146.173])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id 76ECDD164C
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2018 12:03:58 +0100 (CET)
Received: from awhome.eu (p4FF91EF0.dip0.t-ipconnect.de [79.249.30.240])
        (Authenticated sender: postmaster@awhome.eu)
        by player714.ha.ovh.net (Postfix) with ESMTPSA id 31E6D3C00A0;
        Sun, 11 Nov 2018 12:03:57 +0100 (CET)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1541934236;
        bh=lQgDckOzIOiB7G/RXkc7E+BhZ6qgRHhnDxYjhJy3nys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=HPmirl9PP+WYfSfMkKDoJXIgxlI2FD1VgxeU78Xg2NnYf1zbq0v2QAsz2ewoiaW1z
         I3odyIj9miew0jatzlYksYOE3eBtVYX/nWF8WAVe4B07mxi88gn6DjFjad1QOdXw7E
         7BoF84jTSAM8/JKD2faXopvynVjPqU+q2jS4vbRk=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH v2 2/2] mac80211: Add support for Extended Key ID
Date:   Sun, 11 Nov 2018 12:02:35 +0100
Message-Id: <20181111110235.14213-3-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181111110235.14213-1-alexander@wetzel-home.de>
References: <20181111110235.14213-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 909164176186678471
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrkeejgddvvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Allow drivers using mac80211 to support Extended Key IDs.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---
 include/net/mac80211.h     |  6 +++++
 net/mac80211/cfg.c         | 30 ++++++++++++++++++++++++-
 net/mac80211/debugfs_sta.c |  1 +
 net/mac80211/key.c         | 46 ++++++++++++++++++++++++++++++--------
 net/mac80211/key.h         |  1 +
 net/mac80211/main.c        |  2 ++
 net/mac80211/sta_info.c    |  1 +
 net/mac80211/sta_info.h    |  1 +
 8 files changed, 78 insertions(+), 10 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 71985e95d2d9..fb53e7c84c01 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1643,6 +1643,10 @@ struct wireless_dev *ieee80211_vif_to_wdev(struct ieee80211_vif *vif);
  * @IEEE80211_KEY_FLAG_PUT_MIC_SPACE: This flag should be set by the driver for
  *	a TKIP key if it only requires MIC space. Do not set together with
  *	@IEEE80211_KEY_FLAG_GENERATE_MMIC on the same key.
+ * @IEEE80211_KEY_FLAG_RX_ONLY: Set by mac80211 to indicate that the key
+ *      must not be used for TX (yet).
+ * @IEEE80211_KEY_FLAG_SET_TX: Set by mac80211 to indicate that a previously
+ *      installed key with IEEE80211_KEY_FLAG_RX_ONLY should take over TX also.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_GENERATE_IV_MGMT	= BIT(0),
@@ -1654,6 +1658,8 @@ enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_RX_MGMT		= BIT(6),
 	IEEE80211_KEY_FLAG_RESERVE_TAILROOM	= BIT(7),
 	IEEE80211_KEY_FLAG_PUT_MIC_SPACE	= BIT(8),
+	IEEE80211_KEY_FLAG_RX_ONLY		= BIT(9),
+	IEEE80211_KEY_FLAG_SET_TX		= BIT(10),
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 51622333d460..c0af820bc557 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -365,6 +365,25 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	if (!ieee80211_sdata_running(sdata))
 		return -ENETDOWN;
 
+	if (pairwise && params->flag == NL80211_KEY_SET_TX) {
+		mutex_lock(&local->sta_mtx);
+		sta = sta_info_get_bss(sdata, mac_addr);
+
+		if (!sta ||
+		   !(key = rcu_dereference(sta->ptk[key_idx])) ||
+		   !(key->conf.flags | IEEE80211_KEY_FLAG_RX_ONLY)) {
+			err = -ENOENT;
+		} else {
+			key->conf.flags &= ~IEEE80211_KEY_FLAG_RX_ONLY;
+			key->conf.flags |= IEEE80211_KEY_FLAG_SET_TX;
+			err = ieee80211_key_hw_activate_tx(key);
+			if (!err)
+				sta->ptk_idx = key_idx;
+		}
+		mutex_unlock(&local->sta_mtx);
+		return err;
+	}
+
 	/* reject WEP and TKIP keys if WEP failed to initialize */
 	switch (params->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
@@ -451,9 +470,18 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 		break;
 	}
 
-	if (sta)
+	if (sta) {
 		sta->cipher_scheme = cs;
 
+		/* Flag STA correctly when using Extended Key ID */
+		if (pairwise && params->flag == NL80211_KEY_RX_ONLY &&
+		    !test_sta_flag(sta, WLAN_STA_EXT_KEY_ID))
+			set_sta_flag(sta, WLAN_STA_EXT_KEY_ID);
+	}
+
+	if (params->flag == NL80211_KEY_RX_ONLY)
+		key->conf.flags |= IEEE80211_KEY_FLAG_RX_ONLY;
+
 	err = ieee80211_key_link(key, sdata, sta);
 
  out_unlock:
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index af5185a836e5..d63dca26d504 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -81,6 +81,7 @@ static const char * const sta_flag_names[] = {
 	FLAG(MPSP_OWNER),
 	FLAG(MPSP_RECIPIENT),
 	FLAG(PS_DELIVER),
+	FLAG(EXT_KEY_ID),
 #undef FLAG
 };
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 4700718e010f..007f90a1f948 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -124,6 +124,36 @@ static void decrease_tailroom_need_count(struct ieee80211_sub_if_data *sdata,
 	sdata->crypto_tx_tailroom_needed_cnt -= delta;
 }
 
+int ieee80211_key_hw_activate_tx(struct ieee80211_key *key)
+{
+	struct ieee80211_sub_if_data *sdata = key->sdata;
+	struct sta_info *sta = key->sta;
+	int ret;
+
+	assert_key_lock(key->local);
+
+	if (!sta)
+		return -EOPNOTSUPP;
+
+	if (!(key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE))
+		/* No need to inform driver, report success */
+		return 0;
+
+	/* Inform driver that key is no longer RX only */
+	ret = drv_set_key(key->local, SET_KEY, sdata,
+			  &sta->sta, &key->conf);
+	if (ret) {
+		if (ret == 1)
+			/* Software crypto, report success */
+			return 0;
+		sdata_err(sdata,
+			  "failed to activate key for TX (%d, %pM) in hardware (%d)\n",
+			  key->conf.keyidx,
+			  sta->sta.addr, ret);
+	}
+	return ret;
+}
+
 static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 {
 	struct ieee80211_sub_if_data *sdata = key->sdata;
@@ -261,7 +291,7 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 
 static int ieee80211_hw_key_replace(struct ieee80211_key *old_key,
 				    struct ieee80211_key *new_key,
-				    bool ptk0rekey)
+				    bool pairwise)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_local *local;
@@ -278,8 +308,9 @@ static int ieee80211_hw_key_replace(struct ieee80211_key *old_key,
 	assert_key_lock(old_key->local);
 	sta = old_key->sta;
 
-	/* PTK only using key ID 0 needs special handling on rekey */
-	if (new_key && sta && ptk0rekey) {
+	/* PTK rekey without Extended Key ID needs special handling */
+	if (new_key && pairwise && sta &&
+	    !test_sta_flag(sta, WLAN_STA_EXT_KEY_ID)) {
 		local = old_key->local;
 		sdata = old_key->sdata;
 
@@ -395,10 +426,6 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 
 	if (old) {
 		idx = old->conf.keyidx;
-		/* TODO: proper implement and test "Extended Key ID for
-		 * Individually Addressed Frames" from IEEE 802.11-2016.
-		 * Till then always assume only key ID 0 is used for
-		 * pairwise keys.*/
 		ret = ieee80211_hw_key_replace(old, new, pairwise);
 	} else {
 		/* new must be provided in case old is not */
@@ -415,8 +442,9 @@ static int ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
 	if (sta) {
 		if (pairwise) {
 			rcu_assign_pointer(sta->ptk[idx], new);
-			sta->ptk_idx = idx;
-			if (new) {
+			if (new &&
+			    !(new->conf.flags & IEEE80211_KEY_FLAG_RX_ONLY)) {
+				sta->ptk_idx = idx;
 				clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
 				ieee80211_check_fast_xmit(sta);
 			}
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index ebdb80b85dc3..e0612a0b3adc 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -146,6 +146,7 @@ ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
 int ieee80211_key_link(struct ieee80211_key *key,
 		       struct ieee80211_sub_if_data *sdata,
 		       struct sta_info *sta);
+int ieee80211_key_hw_activate_tx(struct ieee80211_key *key);
 void ieee80211_key_free(struct ieee80211_key *key, bool delay_tailroom);
 void ieee80211_key_free_unused(struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 83e71e6b2ebe..8a8ca813494a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -574,6 +574,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_FILS_STA);
 	wiphy_ext_feature_set(wiphy,
 			      NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211);
+	/* !! DEVELOPMENT ONLY, must normally be set by driver !! */
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_EXT_KEY_ID);
 
 	if (!ops->hw_scan) {
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index fb8c2252ac0e..2d83d8e13769 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -350,6 +350,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 	sta->sta.max_rx_aggregation_subframes =
 		local->hw.max_rx_aggregation_subframes;
 
+	sta->ptk_idx = NUM_DEFAULT_KEYS - 1;
 	sta->local = local;
 	sta->sdata = sdata;
 	sta->rx_stats.last_rx = jiffies;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 9a04327d71d1..7787e773a350 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -101,6 +101,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_MPSP_OWNER,
 	WLAN_STA_MPSP_RECIPIENT,
 	WLAN_STA_PS_DELIVER,
+	WLAN_STA_EXT_KEY_ID,
 
 	NUM_WLAN_STA_FLAGS,
 };
-- 
2.19.1


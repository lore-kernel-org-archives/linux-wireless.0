Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793655840;
	b=RDryt/5MDlzDuBDbtSpj2pxU+tcvuFMzpkU2LXcH2hIBBHCo/SUw9CyDbrsZ4nOl/8Rl
	 VaGyoqYcwJ5/Tsb84TmauhUnv5v55c7SK2f/hufZIQMeHfvQ0Tp3aSunD0EUGgDYnqnFk
	 B167x5h1dTT4X7UazC4dROhzarKaKv718wi0BIJ3puHsyHq5g414O5BntlDkhioGPYmoA
	 VnXYmG5ElelibZcor0Wrqpc3bSWMm6lWAjm3sjZl8to20iIq/uqcy4fPbZYw16fm/4oJB
	 ID3kKGImHqImxAYUWJUTK+pP4atxCIWUiZyexmdDbXpsQubkQqzSggbt+mCZ7I6vQFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793655840;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=MeOuUjaJIb4i7cQnLvy5Mkaw6e43VtuFgfFL4lxzquY=;
	b=ccRP07Yq6tbDYdd77YwSJMgbp2uKqV/70WqDjDbis+vt1zpqJahrIHea/Ekyh85cyoBm
	 zIwTgP4r6UXzV46XTVCoY17EkgUffNaL/xbNIQwUNT2BVkur+FtLGwH/xGRMqGuSR7XcA
	 e7B7MTuixZEBNnGcD2Pb9P/TJGm5urShgOh50XJq6Qx2tY1xmf7FT/SeXaAlGoCFtdUJ6
	 YrNZ2EayH/5dNfOES6jhDl3/0JRV5j5GzltPbJAhLqJcvmn7wANIeIkbTtrmzZS3fknSX
	 +MQ74MXZGz0QSlPfz3vOhJrXcgb1asApkYMjpTt7D4qWQbAOb+PIV52quQTvVMUbJuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b="yEBIv1/O";
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145ED606A32C
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 21:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=yEBIv1/O
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=MeOuUjaJIb4i7cQnLvy5Mkaw6e43VtuFgfFL4lxzquY=;
	t=1793655839; x=1794865439; b=yEBIv1/OKmk8+4JKAx/6nIUSLCM+D18V7hY6RzhjiiLSOuQ
	ujxD9b3syj1/tJ96X1WKcVV7wAvoMYnsnU7DbLDB0Qn/S0WU4486wM+3ZYJ3nmSPY6NdJ40PrZpXw
	odTegUZPYEqWbfGbK21R+xG98eVU+q7hu7d6B9+uyL6CzSlePE1GJJnQ7yh8OEuKmWs7+xkSbyKT1
	YvbxoUOJbUpkkCrzhWiDNp4MJK5FEPTWOx5c8Qo7qUmUomXBZTENtu1KnyWZl2VcSx/+1q3VAr/Ar
	GdS0McXb+mpEeqwyz+Nkpp3xc3RpOR2YKii3yFDUT5vW6zU++4gFTeXwFqxGzxbw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNzor-000000020tw-2o7k;
	Mon, 02 Nov 2026 22:43:57 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Subject: [PATCH wireless-next 7/7] wifi: mac80211: use sta->active_links in for_each_sta_active_link()
Date: Mon,  2 Nov 2026 22:42:43 +0100
Message-ID: <20261102224349.e1d1ed2eef37.I0f5c26e0f6a05feaf5c578fa048ca5586530f0ba@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102214348.1104849-9-johannes@sipsolutions.net>
References: <20261102214348.1104849-9-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

With the new sta->active_links we can simplify the API
for for_each_sta_active_link() and no longer require
the vif to be passed in. This leads to bigger changes
in drivers, including removal of now unused variables.

It's mostly a cleanup, but will also allow drivers to
change code better in SMD Transition.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/iface.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mld/sta.c      | 15 +++++----------
 drivers/net/wireless/intel/iwlwifi/mld/tx.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 12 ++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c  | 14 +++++++-------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c      |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c   |  4 ++--
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c   |  5 +----
 drivers/net/wireless/mediatek/mt76/mt7996/main.c  |  6 +++---
 include/net/mac80211.h                            |  6 +++---
 11 files changed, 31 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/iface.c b/drivers/net/wireless/intel/iwlwifi/mld/iface.c
index 0307abff5644..1d66f106e7bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/iface.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/iface.c
@@ -155,7 +155,7 @@ static void iwl_mld_mac_wifi_gen_sta_iter(void *_data,
 	if (mld_sta->vif != data->vif)
 		return;
 
-	for_each_sta_active_link(data->vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		if (link_sta->he_cap.has_he)
 			data->support->he_support = 1;
 		if (link_sta->eht_cap.has_eht)
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 99cbd279ce48..898e376e2979 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -1745,7 +1745,7 @@ static void iwl_mld_link_set_2mhz_block(struct iwl_mld *mld,
 	struct ieee80211_link_sta *link_sta;
 	unsigned int link_id;
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		struct ieee80211_bss_conf *link_conf =
 			link_conf_dereference_protected(vif, link_id);
 		struct iwl_mld_link *mld_link =
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/sta.c b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
index 97f013330f06..cf86f1da959b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/sta.c
@@ -720,7 +720,7 @@ int iwl_mld_update_all_link_stations(struct iwl_mld *mld,
 	struct ieee80211_link_sta *link_sta;
 	int link_id;
 
-	for_each_sta_active_link(mld_sta->vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		int ret = iwl_mld_add_modify_sta_cmd(mld, link_sta);
 
 		if (ret)
@@ -815,7 +815,6 @@ iwl_mld_init_sta(struct iwl_mld *mld, struct ieee80211_sta *sta,
 int iwl_mld_add_sta(struct iwl_mld *mld, struct ieee80211_sta *sta,
 		    struct ieee80211_vif *vif)
 {
-	struct iwl_mld_sta *mld_sta = iwl_mld_sta_from_mac80211(sta);
 	struct ieee80211_link_sta *link_sta;
 	enum iwl_fw_sta_type type;
 	int link_id;
@@ -841,7 +840,7 @@ int iwl_mld_add_sta(struct iwl_mld *mld, struct ieee80211_sta *sta,
 	 * in the restart case if the single link that is active during
 	 * reconfig is not the deflink one.
 	 */
-	for_each_sta_active_link(mld_sta->vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		ret = iwl_mld_add_link_sta(mld, link_sta);
 		if (ret)
 			goto destroy_sta;
@@ -857,11 +856,10 @@ int iwl_mld_add_sta(struct iwl_mld *mld, struct ieee80211_sta *sta,
 
 void iwl_mld_flush_sta_txqs(struct iwl_mld *mld, struct ieee80211_sta *sta)
 {
-	struct iwl_mld_sta *mld_sta = iwl_mld_sta_from_mac80211(sta);
 	struct ieee80211_link_sta *link_sta;
 	int link_id;
 
-	for_each_sta_active_link(mld_sta->vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		int fw_sta_id = iwl_mld_fw_sta_id_from_link_sta(mld, link_sta);
 
 		if (fw_sta_id < 0)
@@ -892,8 +890,6 @@ void iwl_mld_wait_sta_txqs_empty(struct iwl_mld *mld, struct ieee80211_sta *sta)
 
 void iwl_mld_remove_sta(struct iwl_mld *mld, struct ieee80211_sta *sta)
 {
-	struct iwl_mld_sta *mld_sta = iwl_mld_sta_from_mac80211(sta);
-	struct ieee80211_vif *vif = mld_sta->vif;
 	struct ieee80211_link_sta *link_sta;
 	u8 link_id;
 
@@ -909,7 +905,7 @@ void iwl_mld_remove_sta(struct iwl_mld *mld, struct ieee80211_sta *sta)
 	for (int i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		iwl_mld_remove_txq(mld, sta->txq[i]);
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		/* Mac8011 will remove the groupwise keys after the sta is
 		 * removed, but FW expects all the keys to be removed before
 		 * the STA is, so remove them all here.
@@ -926,7 +922,6 @@ void iwl_mld_remove_sta(struct iwl_mld *mld, struct ieee80211_sta *sta)
 
 u32 iwl_mld_fw_sta_id_mask(struct iwl_mld *mld, struct ieee80211_sta *sta)
 {
-	struct ieee80211_vif *vif = iwl_mld_sta_from_mac80211(sta)->vif;
 	struct ieee80211_link_sta *link_sta;
 	unsigned int link_id;
 	u32 result = 0;
@@ -940,7 +935,7 @@ u32 iwl_mld_fw_sta_id_mask(struct iwl_mld *mld, struct ieee80211_sta *sta)
 	 */
 	lockdep_assert_wiphy(mld->wiphy);
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		int fw_id = iwl_mld_fw_sta_id_from_link_sta(mld, link_sta);
 
 		if (!(fw_id < 0))
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.c b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
index 44aa317b8e7d..882e36aa1ec6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -182,7 +182,7 @@ iwl_mld_get_queue_size(struct iwl_mld *mld, struct ieee80211_txq *txq)
 
 	lockdep_assert_wiphy(mld->wiphy);
 
-	for_each_sta_active_link(txq->vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		if (link_sta->eht_cap.has_eht) {
 			max_size = IWL_DEFAULT_QUEUE_SIZE_EHT;
 			break;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 937232882ea2..0f7f03b03037 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3692,7 +3692,7 @@ static bool iwl_mvm_vif_conf_from_sta(struct iwl_mvm *mvm,
 	 * wpa_s will blocklist the AP...
 	 */
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		struct ieee80211_bss_conf *link_conf =
 			link_conf_dereference_protected(vif, link_id);
 
@@ -3721,7 +3721,7 @@ static void iwl_mvm_vif_set_he_support(struct ieee80211_hw *hw,
 	struct ieee80211_link_sta *link_sta;
 	unsigned int link_id;
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		struct ieee80211_bss_conf *link_conf =
 			link_conf_dereference_protected(vif, link_id);
 
@@ -3775,7 +3775,7 @@ iwl_mvm_sta_state_notexist_to_none(struct iwl_mvm *mvm,
 	if (ret)
 		return ret;
 
-	for_each_sta_active_link(vif, sta, link_sta, i)
+	for_each_sta_active_link(sta, link_sta, i)
 		link_sta->agg.max_rc_amsdu_len = 1;
 
 	ieee80211_sta_recalc_aggregates(sta);
@@ -3833,7 +3833,7 @@ iwl_mvm_sta_state_auth_to_assoc(struct ieee80211_hw *hw,
 		if (!mvm->mld_api_is_used)
 			goto out;
 
-		for_each_sta_active_link(vif, sta, link_sta, link_id) {
+		for_each_sta_active_link(sta, link_sta, link_id) {
 			struct ieee80211_bss_conf *link_conf =
 				link_conf_dereference_protected(vif, link_id);
 
@@ -4004,7 +4004,7 @@ int iwl_mvm_mac_sta_state_common(struct ieee80211_hw *hw,
 	 * legit to have phy_ctxt = NULL. Don't bother not to WARN if we are in
 	 * recovery flow since we spit tons of error messages anyway.
 	 */
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		if (WARN_ON_ONCE(!mvmvif->link[link_id] ||
 				 !mvmvif->link[link_id]->phy_ctxt)) {
 			mutex_unlock(&mvm->mutex);
@@ -5752,7 +5752,7 @@ void iwl_mvm_mac_flush_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	int link_id;
 
 	guard(mvm)(mvm);
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		mvm_link_sta = rcu_dereference_protected(mvmsta->link[link_id],
 							 lockdep_is_held(&mvm->mutex));
 		if (!mvm_link_sta)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
index da7ed4639a93..483656d39bcc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2022-2025 Intel Corporation
+ * Copyright (C) 2022-2026 Intel Corporation
  */
 #include "mvm.h"
 #include "time-sync.h"
@@ -573,7 +573,7 @@ static int iwl_mvm_mld_alloc_sta_links(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		if (WARN_ON(mvm_sta->link[link_id]))
 			continue;
 
@@ -620,7 +620,7 @@ static int iwl_mvm_alloc_sta_after_restart(struct iwl_mvm *mvm,
 	 * a valid station. Since we need a link_id to allocate a station,
 	 * pick up the first valid one.
 	 */
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		struct iwl_mvm_vif_link_info *mvm_link;
 		struct ieee80211_bss_conf *link_conf =
 			link_conf_dereference_protected(vif, link_id);
@@ -685,7 +685,7 @@ int iwl_mvm_mld_add_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (ret)
 		goto err;
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		struct ieee80211_bss_conf *link_conf =
 			link_conf_dereference_protected(vif, link_id);
 		struct iwl_mvm_link_sta *mvm_link_sta =
@@ -736,7 +736,7 @@ int iwl_mvm_mld_update_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		struct ieee80211_bss_conf *link_conf =
 			link_conf_dereference_protected(vif, link_id);
 		struct iwl_mvm_link_sta *mvm_link_sta =
@@ -796,7 +796,7 @@ int iwl_mvm_mld_rm_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	lockdep_assert_held(&mvm->mutex);
 
 	/* flush its queues here since we are freeing mvm_sta */
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		struct iwl_mvm_link_sta *mvm_link_sta =
 			rcu_dereference_protected(mvm_sta->link[link_id],
 						  lockdep_is_held(&mvm->mutex));
@@ -816,7 +816,7 @@ int iwl_mvm_mld_rm_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	iwl_mvm_mld_disable_sta_queues(mvm, vif, sta);
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		struct iwl_mvm_link_sta *mvm_link_sta =
 			rcu_dereference_protected(mvm_sta->link[link_id],
 						  lockdep_is_held(&mvm->mutex));
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index a66128a62546..45f5816abcb7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -863,7 +863,7 @@ int iwl_mvm_tvqm_enable_txq(struct iwl_mvm *mvm,
 		unsigned int link_id;
 
 		rcu_read_lock();
-		for_each_sta_active_link(mvmsta->vif, sta, link_sta, link_id) {
+		for_each_sta_active_link(sta, link_sta, link_id) {
 			struct iwl_mvm_link_sta *link =
 				rcu_dereference_protected(mvmsta->link[link_id],
 							  lockdep_is_held(&mvm->mutex));
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 26cdb3f0a98a..5c227e853d04 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -767,7 +767,7 @@ int mt7925_mcu_uni_tx_ba(struct mt792x_dev *dev,
 	struct ieee80211_link_sta *link_sta;
 	unsigned int link_id;
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		struct mt792x_link_sta *mlink;
 		struct mt792x_bss_conf *mconf;
 		int ret;
@@ -801,7 +801,7 @@ int mt7925_mcu_uni_rx_ba(struct mt792x_dev *dev,
 	struct ieee80211_link_sta *link_sta;
 	unsigned int link_id;
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		struct mt792x_link_sta *mlink;
 		struct mt792x_bss_conf *mconf;
 		int ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
index 644abd0a0216..44a653deedc0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
@@ -776,14 +776,11 @@ mt7996_sta_hw_queue_read(void *data, struct ieee80211_sta *sta)
 	struct mt7996_vif *mvif = msta->vif;
 	struct ieee80211_link_sta *link_sta;
 	struct seq_file *s = data;
-	struct ieee80211_vif *vif;
 	unsigned int link_id;
 
-	vif = container_of((void *)mvif, struct ieee80211_vif, drv_priv);
-
 	rcu_read_lock();
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		struct mt7996_sta_link *msta_link;
 		struct mt76_vif_link *mlink;
 		struct mt7996_phy *phy;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index 873c5aef4935..6ec862c01446 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1338,7 +1338,7 @@ u16 mt7996_mac_sta_links(struct mt7996_dev *dev, struct ieee80211_vif *vif,
 	unsigned int link_id;
 	u16 links = 0;
 
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		struct mt7996_sta_link *msta_link;
 
 		msta_link = mt7996_sta_link_protected(dev, msta, link_id);
@@ -2522,7 +2522,7 @@ static void mt7996_sta_set_4addr(struct ieee80211_hw *hw,
 	mutex_lock(&dev->mt76.mutex);
 
 	assign_bit(MT_WCID_FLAG_4ADDR, &msta->wcid_flags, enabled);
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
 
@@ -2558,7 +2558,7 @@ static void mt7996_sta_set_decap_offload(struct ieee80211_hw *hw,
 	mutex_lock(&dev->mt76.mutex);
 
 	assign_bit(MT_WCID_FLAG_HDR_TRANS, &msta->wcid_flags, enabled);
-	for_each_sta_active_link(vif, sta, link_sta, link_id) {
+	for_each_sta_active_link(sta, link_sta, link_id) {
 		struct mt7996_sta_link *msta_link;
 		struct mt7996_vif_link *link;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 335eee075952..f156af2210f3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2796,10 +2796,10 @@ static inline bool lockdep_sta_mutex_held(struct ieee80211_sta *pubsta)
 	rcu_dereference_check((sta)->link[link_id],		\
 			      lockdep_sta_mutex_held(sta))
 
-#define for_each_sta_active_link(vif, sta, link_sta, link_id)			\
+#define for_each_sta_active_link(sta, link_sta, link_id)			\
 	for (link_id = 0; link_id < ARRAY_SIZE((sta)->link); link_id++)		\
-		if ((!(vif)->active_links ||					\
-		     (vif)->active_links & BIT(link_id)) &&			\
+		if ((!(sta)->active_links ||					\
+		     (sta)->active_links & BIT(link_id)) &&			\
 		    ((link_sta) = link_sta_dereference_check(sta, link_id)))
 
 /**
-- 
2.56.0


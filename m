Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D827240099A
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 11:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785757457; cv=none; b=ujHIK6z0QYSic7Oxh4UUhEA/7OAFac2TRXwL/+109wa2jI/5dRJcvOFr6tm7+1IQQXKJWbhxlWYPpEOs3fhsb0u+3tuz0wglfEj4opbqOoIh2BZucxWaRqUYTQJN1RgzUMFsiz+v8/dYcpJtjIo+hMfB+ocw2apy8lER7dPDlDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785757457; c=relaxed/simple;
	bh=0Dt2jGURnJ/uvbrOiLCoukRDlHgG8nwCksDmb6EF6dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAsnAB6cot2xVkmdYZfrlKVu07YOvG+HxGDYaTeJDaSuH9QicEtLC6pwrjuTiYUIDAr3oHKMAzNc8hWU5fELmlF3h4fcmtM8ffKscoN2kGc6MTsMUcTLbrqhbXMJeoCc8KaRgsxaU7cEPFjqqH6QcS1yurZ21kSMX2qvsk/zEs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=UOf3g/YH; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="UOf3g/YH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=i8R06z+2hFP9aLzmMnZKoQgOHDyWVvnLHW+bIcaXbS0=;
	t=1785757454; x=1786967054; b=UOf3g/YHybB6eCBO1neQBQmwF5IXGmwLykMshRMe6Ake+vx
	IX34LuWsgw9ItWzSomXkg5q8iZO/FqBwvxkDObuX7noro9KJ5jILuQwATWa/9PGSPDBQVr3VLKA1V
	taGvYFS5SJmdXTrUA82rN8HCPJoP8rPmleOCZ/ULYnFsEYM250sfUWC1SSY6cB4s0TpLhvNSQg74r
	+k/C2qkdS4pXj0gp4AwAj5lx1UmUDyjb5sECghEpBFEUWE2UxhPX5WTNJUtOqaFbu4Z+mBoH6z9RL
	pp8UrCpBtZNLgX20f0uTTYprjaWQei3sggU2nssOql5uDKgiZf+f63+dPXUZuXcA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wqr5X-0000000B74U-14T4;
	Mon, 03 Aug 2026 13:44:11 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v2 2/5] wifi: mac80211: add cigtk parameter to ieee80211_gtk_rekey_add
Date: Mon,  3 Aug 2026 13:44:03 +0200
Message-ID: <20260803134401.cb8f7f912efc.I3d046fbe7dfb3883471773f84e7a791b5b97000e@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803134401.e4851391bdda.I49c0be0a1b05d625cc307e9bdd13c32a6c18667f@changeid>
References: <20260803134401.e4851391bdda.I49c0be0a1b05d625cc307e9bdd13c32a6c18667f@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

The CIGTK keys use a key index of 0 or 1, which is not unique. As such,
a new parameter is needed to differentiate the key type. Add the
parameter to prepare for handling the CIGTK in the future.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/d3.c | 6 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 6 ++++--
 drivers/net/wireless/realtek/rtw89/wow.c    | 6 ++++--
 include/net/mac80211.h                      | 3 ++-
 net/mac80211/key.c                          | 2 +-
 5 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/d3.c b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
index 55f9b809e764..6d8ede336d59 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/d3.c
@@ -1138,7 +1138,8 @@ iwl_mld_add_mcast_rekey(struct ieee80211_vif *vif,
 		return;
 
 	key_config = ieee80211_gtk_rekey_add(vif, key_data->id, key_data->key,
-					     sizeof(key_data->key), link_id);
+					     sizeof(key_data->key), link_id,
+					     false);
 	if (IS_ERR(key_config))
 		return;
 
@@ -1220,7 +1221,8 @@ static void iwl_mld_mlo_rekey(struct iwl_mld *mld,
 				 mlo_key->idx, link_id);
 
 		key = ieee80211_gtk_rekey_add(vif, mlo_key->idx, mlo_key->key,
-					      sizeof(mlo_key->key), link_id);
+					      sizeof(mlo_key->key), link_id,
+					      false);
 
 		if (IS_ERR(key))
 			continue;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 6b11fa32ea5c..bd52f2ebd3ba 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1887,7 +1887,8 @@ static bool iwl_mvm_gtk_rekey(struct iwl_wowlan_status_data *status,
 
 		key = ieee80211_gtk_rekey_add(vif, status->gtk[i].id,
 					      status->gtk[i].key,
-					      sizeof(status->gtk[i].key), -1);
+					      sizeof(status->gtk[i].key), -1,
+					      false);
 		if (IS_ERR(key)) {
 			/* FW may send also the old keys */
 			if (PTR_ERR(key) == -EALREADY)
@@ -1922,7 +1923,8 @@ iwl_mvm_d3_igtk_bigtk_rekey_add(struct iwl_wowlan_status_data *status,
 		return true;
 
 	key_config = ieee80211_gtk_rekey_add(vif, keyidx, key_data->key,
-					     sizeof(key_data->key), -1);
+					     sizeof(key_data->key), -1,
+					     false);
 	if (IS_ERR(key_config)) {
 		/* FW may send also the old keys */
 		return PTR_ERR(key_config) == -EALREADY;
diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index 2dfa24c54e7d..2e37e1fafbef 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -669,10 +669,12 @@ static struct ieee80211_key_conf *rtw89_wow_gtk_rekey(struct rtw89_dev *rtwdev,
 	if (ieee80211_vif_is_mld(wow_vif))
 		key = ieee80211_gtk_rekey_add(wow_vif, keyidx, gtk,
 					      cipher_info->len,
-					      rtwvif_link->link_id);
+					      rtwvif_link->link_id,
+					      false);
 	else
 		key = ieee80211_gtk_rekey_add(wow_vif, keyidx, gtk,
-					      cipher_info->len, -1);
+					      cipher_info->len, -1,
+					      false);
 
 	kfree(rekey_conf);
 	if (IS_ERR(key)) {
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9d1fac6e8082..77ebf9a9ca87 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6279,6 +6279,7 @@ void ieee80211_set_key_rx_seq(struct ieee80211_key_conf *keyconf,
  * @key_len: the key data. Might be bigger than the actual key length,
  *	but not smaller (for the driver convinence)
  * @link_id: the link id of the key or -1 for non-MLO
+ * @cigtk: whether this is a CIGTK
  *
  * When GTK rekeying was done while the system was suspended, (a) new
  * key(s) will be available. These will be needed by mac80211 for proper
@@ -6305,7 +6306,7 @@ void ieee80211_set_key_rx_seq(struct ieee80211_key_conf *keyconf,
 struct ieee80211_key_conf *
 ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 			u8 idx, u8 *key_data, u8 key_len,
-			int link_id);
+			int link_id, bool cigtk);
 
 /**
  * ieee80211_gtk_rekey_notify - notify userspace supplicant of rekeying
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index f45e792abede..9ac7a5c4b861 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -1366,7 +1366,7 @@ EXPORT_SYMBOL_GPL(ieee80211_set_key_rx_seq);
 struct ieee80211_key_conf *
 ieee80211_gtk_rekey_add(struct ieee80211_vif *vif,
 			u8 idx, u8 *key_data, u8 key_len,
-			int link_id)
+			int link_id, bool cigtk)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
-- 
2.55.0


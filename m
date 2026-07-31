Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19433C1F36
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 13:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785505378; cv=none; b=FN087R2owuY1dJPt399sUzRu+FwY3E7Cf1VCvxdnx4uPs21XD+X2P5rfxCP+tyj8pJUg1m8dCDWOphA9k/Rbs9w9WkGJDr1kzq0SiKAXIlhayOiEfL/GlAO8Pg8PNM64WuYSO9Meosef6+ObpsqPOZBu1LslYtFoKXkD+r1ZQCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785505378; c=relaxed/simple;
	bh=tqO2TfrRv9qQGsravDmZw52YX2CL4POKp2z84mpWjGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heK1WG6IVaIzowY0rLZGJYofb9KctKg3vuT4sZ3/ESx38HQ6AN5WuhKu7qxvTpV7bPSksZt4MxYXeDRwQoRGOG2QXRsqKB0gst1mHsZxexkJjt5aDXCH8sf58sEnlfdyaQbObuU6mt9NayCqjBHkrf58tXSiz1Zdn5/nAxSMreY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=HKn5MExF; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="HKn5MExF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=zb5VEgjNOuIN+SASRqdFlJ+ZkwhAgJ8Qgzfm3kz1j88=;
	t=1785505377; x=1786714977; b=HKn5MExFlhvzQs6RihSfIilXumg8p3DlBSRSYZDagWhl8MB
	PfcUKq96vMEbTI88hucTP/5an97MY75swkplefCf8vq3uwYO6vQWLBSXqZFfIoEdWEM0NNIcx7j+q
	E/T6u56+4KXuKOf21wz9U426FafMNsmyk6/qFrOT9PW3wB47B8FhBmNIGejetjBaRVI84P6Rr0z94
	0ohHCl2+t8g5iVIV8zbl76R7g6YeUgAH931kUf+oc3kmZ+M5VYmcP5PBQDLn/b2xggdsWSigJHTPz
	OX0Y2w9d4wV917N8V3h5vzsfASix6+WbKOiuZYQhN8U2bsKTRW2oMH4wU7Y8FpsA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wpnVl-000000048ua-2B6Y;
	Fri, 31 Jul 2026 15:42:53 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next 2/5] wifi: mac80211: add cigtk parameter to ieee80211_gtk_rekey_add
Date: Fri, 31 Jul 2026 15:40:08 +0200
Message-ID: <20260731154006.4535cd6322f9.I3d046fbe7dfb3883471773f84e7a791b5b97000e@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731154006.7bddd2d85ff1.I49c0be0a1b05d625cc307e9bdd13c32a6c18667f@changeid>
References: <20260731154006.7bddd2d85ff1.I49c0be0a1b05d625cc307e9bdd13c32a6c18667f@changeid>
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
index 8dadd8df4fc6..c8e002238ecb 100644
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


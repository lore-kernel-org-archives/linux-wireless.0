Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1684963CC;
	Mon, 21 Sep 2026 12:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789994480; cv=none; b=PMOHV13PjTI+Y3HZEW9UikAjmkjqSqdETqG/ZT3wJom7ijzFVVP8/F60ianjA/r73v9CqD3Gh2bmmjzLmVv01tNVOoo61ydoDCwluvWIk6GmJUBGn1jt+s4mY3xwY1H+ZBbAzY5Mcc0HkfYrHBgKJ9r52gaWe1pH65n9vY7agFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789994480; c=relaxed/simple;
	bh=72/Uu3tMfSBBuhg13tWWteeLCIGzdDGciW0T+PCWABc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeRjYEqJ35TDp3dnWa7lZ+wbJuMTBAofTuajstN1TmcDgJtHNBfO0iIWUfCD0/z5NZJIYwd/VI8iDFByC4jm8PMRkQD36voimdS8LTzbUf0SjHBszDRJfZh1F/3NKB+k1JEeayykGewDI5/CtP9mH/G1ax/Sfk9sFIQQmBFtqO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=pabfP0tm; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="pabfP0tm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=MgohUdtvFW8z4OXGZX5AeefWIXNtWcDjh2SigxUey8g=;
	t=1789994478; x=1791204078; b=pabfP0tmMVIAwayY3FAK/0NZYUsByAxmc2bi6g/a47RPAOt
	No2rYfRM6QhD1N7EsbOo3dxKwN5o7EM1WrfMLM9rm6uayv2o2xgQ0TFgqLLQYWkXGK6YqGeQ+6bKG
	SU1DYfyRHRz2fc0THCImv20tB4zLxbv9VWFBlhOAQsoBvD8ZQsh/VsxBO9gyfX+p1k2hSX7tDuQZL
	dDvuGtcBia1qFJ9h/UR6/jGN1dsvp8c6aytgAJPzuNVQXpuTI3A+mg5l++V4r8qhUPopKaH0ZJG9p
	MWThrrY+1fNTC3g8+HdAkKyc2ZGOsEfolP7cs33tuJtzfxIy9Zl1XQSacjf4P51A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1x8dKc-00000005oVO-3P28;
	Mon, 21 Sep 2026 14:41:15 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Ajay Singh <ajay.kathat@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Igor Mitsyanko <imitsyanko@quantenna.com>,
	Sergey Matyukevich <geomatsi@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	brcm80211@lists.linux.dev,
	libertas-dev@lists.infradead.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v3 4/7] wifi: mac80211: add cigtk parameter to ieee80211_gtk_rekey_add
Date: Mon, 21 Sep 2026 14:40:53 +0200
Message-ID: <20260921144048.8bfea7df6b06.I3d046fbe7dfb3883471773f84e7a791b5b97000e@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921124048.4146576-9-benjamin@sipsolutions.net>
References: <20260921124048.4146576-9-benjamin@sipsolutions.net>
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
index 1172d7b83ed1..c9d0e1203d1b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6278,6 +6278,7 @@ void ieee80211_set_key_rx_seq(struct ieee80211_key_conf *keyconf,
  * @key_len: the key data. Might be bigger than the actual key length,
  *	but not smaller (for the driver convinence)
  * @link_id: the link id of the key or -1 for non-MLO
+ * @cigtk: whether this is a CIGTK
  *
  * When GTK rekeying was done while the system was suspended, (a) new
  * key(s) will be available. These will be needed by mac80211 for proper
@@ -6304,7 +6305,7 @@ void ieee80211_set_key_rx_seq(struct ieee80211_key_conf *keyconf,
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


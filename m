Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873D038239F
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 11:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785757460; cv=none; b=KLYymhphCqJr/rWGOVAszM8ItNSxC5ty3yFDKCfNzFqz22sUY6FwMACWZwnIxaEWKZib5VEUcUyxtwxF29q7yhotLsYTMNHUkDfeeAgPrwbyle/Qk3HYoaXUCN5nwpjeXZw95EoBHvP3WH27e2GVSVsWJ2r8rwStPwtOxaCHYBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785757460; c=relaxed/simple;
	bh=BS5z8mhW1d9To57WrKMZQhneIiTf7ZnMEUFyYmufzaA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c04eDSiN0BBLG14eQFAolTMOOZo3RgY2MbH3zbmz/04qk4CVxT10C0G7SkBj0OMIJ85ARkKVncnbUUG27/oDt8ns5sVJnLtZjorkUoxi97XRaCv2bMuB6392JNHe9ZFv3cP9nWXg5VodSpMtz/aXP/JJWInnY5MaKiDHznFeE2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=J59fwEVn; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="J59fwEVn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=Gz5Z7cugNc5KFhxzGPB/LMxomGTsaWKfRjnLDwgSids=; t=1785757454; x=1786967054; 
	b=J59fwEVnt9k9zQsFxIJHKKrEZVjqS/Xa0qjEIlMkb5kalTnQAqunEA/dNez7oZ7XvFTUauM9Fd4
	iGCWXbvl/OYt9k8n5rEeqEI8AFOPzrG3h+HHnY84DnC1jWj0kQY/Q4WdSlq+SYr0dWLVjE8PqBsz3
	hWls45jBG8tpSvqRUZbQ/XNZjwYk0YWExQa8RmduHjN3LY7VjnYw1cxn9vbEFnaA+EaRpoaHPT0gZ
	768yjJzR8CRnQajJK4MhE/VABA5/t2EBbK957G35wThc3akH1SY4Qb3zmr9+l9d9RBQdB0GpgDQKm
	weVcs3UyYNiGmKQkFt3DrR7qUOqiSzaeae4Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wqr5V-0000000B74U-435W;
	Mon, 03 Aug 2026 13:44:10 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v2 1/5] wifi: cfg80211: add Control Integrity Protocol (CIP) APIs
Date: Mon,  3 Aug 2026 13:44:02 +0200
Message-ID: <20260803134401.e4851391bdda.I49c0be0a1b05d625cc307e9bdd13c32a6c18667f@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

The Control Integrity Protocol consists of a set of capabilities for the
MIC padding as well as a new CIGTK that can be installed. The CIGTK uses
a fixed GMAC-256 cipher for which no RSN extension is defined as it is
bound to the pairwise cipher being GCMP-256. The CIGTK uses the key
index 0 and 1, making it necessary to add a new key type for it.

Add a new CIP feature flag and attributes for CIP Capabilities and
enabling the feature for stations and the association.

Also extend the cfg80211 API to pass the key type rather than a single
pairwise boolean.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>

---

v2:
- Also adjust rtl8723bs staging driver
- Fix incorrect position of new nl80211 attributes
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c    |  10 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c   |  13 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    |  11 +-
 drivers/net/wireless/marvell/libertas/cfg.c   |   6 +-
 .../net/wireless/marvell/mwifiex/cfg80211.c   |  12 +-
 .../wireless/microchip/wilc1000/cfg80211.c    |  13 +-
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c   |  11 +-
 .../net/wireless/quantenna/qtnfmac/cfg80211.c |   8 +-
 .../staging/rtl8723bs/os_dep/ioctl_cfg80211.c |   9 +-
 include/net/cfg80211.h                        |  19 ++-
 include/uapi/linux/nl80211.h                  |  14 ++
 net/mac80211/cfg.c                            |  19 ++-
 net/wireless/core.h                           |   7 +-
 net/wireless/ibss.c                           |   3 +-
 net/wireless/nl80211.c                        | 124 ++++++++++++++----
 net/wireless/rdev-ops.h                       |  23 ++--
 net/wireless/sme.c                            |  10 +-
 net/wireless/trace.h                          |  37 +++---
 net/wireless/util.c                           |  40 +++++-
 net/wireless/wext-compat.c                    |   8 +-
 20 files changed, 295 insertions(+), 102 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 34025d64d615..533787017ae0 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1125,13 +1125,15 @@ void ath6kl_cfg80211_ch_switch_notify(struct ath6kl_vif *vif, int freq,
 }
 
 static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-				   int link_id, u8 key_index, bool pairwise,
+				   int link_id, u8 key_index,
+				   enum nl80211_key_type type,
 				   const u8 *mac_addr,
 				   struct key_params *params)
 {
 	struct ath6kl *ar = ath6kl_priv(wdev->netdev);
 	struct ath6kl_vif *vif = netdev_priv(wdev->netdev);
 	struct ath6kl_key *key = NULL;
+	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
 	int seq_len;
 	u8 key_usage;
 	u8 key_type;
@@ -1250,7 +1252,8 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct wireless_dev *wde
 }
 
 static int ath6kl_cfg80211_del_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-				   int link_id, u8 key_index, bool pairwise,
+				   int link_id, u8 key_index,
+				   enum nl80211_key_type type,
 				   const u8 *mac_addr)
 {
 	struct ath6kl *ar = ath6kl_priv(wdev->netdev);
@@ -1280,7 +1283,8 @@ static int ath6kl_cfg80211_del_key(struct wiphy *wiphy, struct wireless_dev *wde
 }
 
 static int ath6kl_cfg80211_get_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-				   int link_id, u8 key_index, bool pairwise,
+				   int link_id, u8 key_index,
+				   enum nl80211_key_type type,
 				   const u8 *mac_addr, void *cookie,
 				   void (*callback) (void *cookie,
 						     struct key_params *))
diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 9ac33d827f80..bf060281c9a2 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1620,11 +1620,13 @@ static void wil_del_rx_key(u8 key_index, enum wmi_key_usage key_usage,
 
 static int wil_cfg80211_add_key(struct wiphy *wiphy,
 				struct wireless_dev *wdev, int link_id,
-				u8 key_index, bool pairwise,
+				u8 key_index,
+				enum nl80211_key_type type,
 				const u8 *mac_addr,
 				struct key_params *params)
 {
 	int rc;
+	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	struct wil6210_vif *vif = wdev_to_vif(wil, wdev);
 	enum wmi_key_usage key_usage = wil_detect_key_usage(wdev, pairwise);
@@ -1695,12 +1697,14 @@ static int wil_cfg80211_add_key(struct wiphy *wiphy,
 
 static int wil_cfg80211_del_key(struct wiphy *wiphy,
 				struct wireless_dev *wdev, int link_id,
-				u8 key_index, bool pairwise,
+				u8 key_index,
+				enum nl80211_key_type type,
 				const u8 *mac_addr)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
 	struct wil6210_vif *vif = wdev_to_vif(wil, wdev);
-	enum wmi_key_usage key_usage = wil_detect_key_usage(wdev, pairwise);
+	enum wmi_key_usage key_usage =
+		wil_detect_key_usage(wdev, type == NL80211_KEYTYPE_PAIRWISE);
 	struct wil_sta_info *cs = wil_find_sta_by_key_usage(wil, vif->mid,
 							    key_usage,
 							    mac_addr);
@@ -2071,7 +2075,8 @@ void wil_cfg80211_ap_recovery(struct wil6210_priv *wil)
 		key_params.seq_len = IEEE80211_GCMP_PN_LEN;
 		rc = wil_cfg80211_add_key(wiphy, vif_to_wdev(vif), -1,
 					  vif->gtk_index,
-					  false, NULL, &key_params);
+					  NL80211_KEYTYPE_PAIRWISE,
+					  NULL, &key_params);
 		if (rc)
 			wil_err(wil, "vif %d recovery add key failed (%d)\n",
 				i, rc);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 872c48806d09..b154420720fa 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2770,7 +2770,8 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 
 static s32
 brcmf_cfg80211_del_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-		       int link_id, u8 key_idx, bool pairwise,
+		       int link_id, u8 key_idx,
+		       enum nl80211_key_type type,
 		       const u8 *mac_addr)
 {
 	struct brcmf_if *ifp = netdev_priv(wdev->netdev);
@@ -2808,7 +2809,8 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 static s32
 brcmf_cfg80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-		       int link_id, u8 key_idx, bool pairwise,
+		       int link_id, u8 key_idx,
+		       enum nl80211_key_type type,
 		       const u8 *mac_addr, struct key_params *params)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
@@ -2834,7 +2836,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	if (params->key_len == 0)
 		return brcmf_cfg80211_del_key(wiphy, wdev, -1, key_idx,
-					      pairwise, mac_addr);
+					      type, mac_addr);
 
 	if (params->key_len > sizeof(key->data)) {
 		bphy_err(drvr, "Too long key length (%u)\n", params->key_len);
@@ -2930,7 +2932,8 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 static s32
 brcmf_cfg80211_get_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-		       int link_id, u8 key_idx, bool pairwise,
+		       int link_id, u8 key_idx,
+		       enum nl80211_key_type type,
 		       const u8 *mac_addr, void *cookie,
 		       void (*callback)(void *cookie,
 					struct key_params *params))
diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 72c92f72469d..e015cfa1950c 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1508,7 +1508,8 @@ static int lbs_cfg_set_default_key(struct wiphy *wiphy,
 
 
 static int lbs_cfg_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-			   int link_id, u8 idx, bool pairwise,
+			   int link_id, u8 idx,
+			   enum nl80211_key_type type,
 			   const u8 *mac_addr, struct key_params *params)
 {
 	struct lbs_private *priv = wiphy_priv(wiphy);
@@ -1569,7 +1570,8 @@ static int lbs_cfg_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 
 static int lbs_cfg_del_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-			   int link_id, u8 key_index, bool pairwise,
+			   int link_id, u8 key_index,
+			   enum nl80211_key_type type,
 			   const u8 *mac_addr)
 {
 
diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 7a1ba32f1fb3..94f47c4f7144 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -142,12 +142,14 @@ static void *mwifiex_cfg80211_get_adapter(struct wiphy *wiphy)
  */
 static int
 mwifiex_cfg80211_del_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-			 int link_id, u8 key_index, bool pairwise,
+			 int link_id, u8 key_index,
+			enum nl80211_key_type type,
 			 const u8 *mac_addr)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
 	static const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-	const u8 *peer_mac = pairwise ? mac_addr : bc_mac;
+	const u8 *peer_mac =
+		(type == NL80211_KEYTYPE_PAIRWISE) ? mac_addr : bc_mac;
 
 	if (mwifiex_set_encode(priv, NULL, NULL, 0, key_index, peer_mac, 1)) {
 		mwifiex_dbg(priv->adapter, ERROR, "deleting the crypto keys\n");
@@ -480,13 +482,15 @@ mwifiex_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
  */
 static int
 mwifiex_cfg80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-			 int link_id, u8 key_index, bool pairwise,
+			 int link_id, u8 key_index,
+			 enum nl80211_key_type type,
 			 const u8 *mac_addr, struct key_params *params)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
 	struct mwifiex_wep_key *wep_key;
 	static const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-	const u8 *peer_mac = pairwise ? mac_addr : bc_mac;
+	const u8 *peer_mac =
+		(type == NL80211_KEYTYPE_PAIRWISE) ? mac_addr : bc_mac;
 
 	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP &&
 	    (params->cipher == WLAN_CIPHER_SUITE_WEP40 ||
diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index bb2748a19329..651a527f6881 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -535,10 +535,13 @@ static int wilc_wfi_cfg_copy_wpa_info(struct wilc_wfi_key *key_info,
 }
 
 static int add_key(struct wiphy *wiphy, struct wireless_dev *wdev, int link_id,
-		   u8 key_index, bool pairwise, const u8 *mac_addr,
+		   u8 key_index,
+		   enum nl80211_key_type type,
+		   const u8 *mac_addr,
 		   struct key_params *params)
 
 {
+	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
 	int ret = 0, keylen = params->key_len;
 	const u8 *rx_mic = NULL;
 	const u8 *tx_mic = NULL;
@@ -641,9 +644,10 @@ static int add_key(struct wiphy *wiphy, struct wireless_dev *wdev, int link_id,
 
 static int del_key(struct wiphy *wiphy, struct wireless_dev *wdev, int link_id,
 		   u8 key_index,
-		   bool pairwise,
+		   enum nl80211_key_type type,
 		   const u8 *mac_addr)
 {
+	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
 	struct wilc_vif *vif = netdev_priv(wdev->netdev);
 	struct wilc_priv *priv = &vif->priv;
 
@@ -681,10 +685,11 @@ static int del_key(struct wiphy *wiphy, struct wireless_dev *wdev, int link_id,
 }
 
 static int get_key(struct wiphy *wiphy, struct wireless_dev *wdev, int link_id,
-		   u8 key_index, bool pairwise, const u8 *mac_addr,
-		   void *cookie,
+		   u8 key_index, enum nl80211_key_type type,
+		   const u8 *mac_addr, void *cookie,
 		   void (*callback)(void *cookie, struct key_params *))
 {
+	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
 	struct wilc_vif *vif = netdev_priv(wdev->netdev);
 	struct wilc_priv *priv = &vif->priv;
 	struct  key_params key_params;
diff --git a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
index c820f08d2835..f2a3e0a7586a 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cfg80211.c
@@ -99,12 +99,14 @@ static void *nxpwifi_cfg80211_get_adapter(struct wiphy *wiphy)
 /* cfg80211 operation handler to delete a network key. */
 static int
 nxpwifi_cfg80211_del_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-			 int link_id, u8 key_index, bool pairwise,
+			 int link_id, u8 key_index,
+			 enum nl80211_key_type type,
 			 const u8 *mac_addr)
 {
 	struct nxpwifi_private *priv = nxpwifi_netdev_get_priv(wdev->netdev);
 	static const u8 bc_mac[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-	const u8 *peer_mac = pairwise ? mac_addr : bc_mac;
+	const u8 *peer_mac =
+		(type == NL80211_KEYTYPE_PAIRWISE) ? mac_addr : bc_mac;
 	int ret;
 
 	ret = nxpwifi_set_encode(priv, NULL, NULL, 0, key_index, peer_mac, 1);
@@ -426,7 +428,8 @@ nxpwifi_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
 /* cfg80211 handler for adding an 802.11 encryption key. */
 static int
 nxpwifi_cfg80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-			 int link_id, u8 key_index, bool pairwise,
+			 int link_id, u8 key_index,
+			 enum nl80211_key_type type,
 			 const u8 *mac_addr, struct key_params *params)
 {
 	struct nxpwifi_private *priv = nxpwifi_netdev_get_priv(wdev->netdev);
@@ -436,7 +439,7 @@ nxpwifi_cfg80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 	int ret;
 
 	eth_broadcast_addr(bc_mac);
-	peer_mac = pairwise ? mac_addr : bc_mac;
+	peer_mac = (type == NL80211_KEYTYPE_PAIRWISE) ? mac_addr : bc_mac;
 
 	if (GET_BSS_ROLE(priv) == NXPWIFI_BSS_ROLE_UAP &&
 	    (params->cipher == WLAN_CIPHER_SUITE_WEP40 ||
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 45e2b7ae9633..d9c84d5ce254 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -531,10 +531,12 @@ qtnf_dump_station(struct wiphy *wiphy, struct wireless_dev *wdev,
 }
 
 static int qtnf_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-			int link_id, u8 key_index, bool pairwise,
+			int link_id, u8 key_index,
+			enum nl80211_key_type type,
 			const u8 *mac_addr, struct key_params *params)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(wdev->netdev);
+	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
 	int ret;
 
 	ret = qtnf_cmd_send_add_key(vif, key_index, pairwise, mac_addr, params);
@@ -547,10 +549,12 @@ static int qtnf_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 }
 
 static int qtnf_del_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-			int link_id, u8 key_index, bool pairwise,
+			int link_id, u8 key_index,
+			enum nl80211_key_type type,
 			const u8 *mac_addr)
 {
 	struct qtnf_vif *vif = qtnf_netdev_get_priv(wdev->netdev);
+	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
 	int ret;
 
 	ret = qtnf_cmd_send_del_key(vif, key_index, pairwise, mac_addr);
diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index b58dda129ff6..4a42a31146ba 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -832,7 +832,8 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 }
 
 static int cfg80211_rtw_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-				int link_id, u8 key_index, bool pairwise,
+				int link_id, u8 key_index,
+				enum nl80211_key_type type,
 				const u8 *mac_addr, struct key_params *params)
 {
 	char *alg_name;
@@ -911,7 +912,8 @@ static int cfg80211_rtw_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 }
 
 static int cfg80211_rtw_get_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-				int link_id, u8 key_index, bool pairwise,
+				int link_id, u8 key_index,
+				enum nl80211_key_type type,
 				const u8 *mac_addr, void *cookie,
 				void (*callback)(void *cookie,
 						 struct key_params*))
@@ -920,7 +922,8 @@ static int cfg80211_rtw_get_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 }
 
 static int cfg80211_rtw_del_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-				int link_id, u8 key_index, bool pairwise,
+				int link_id, u8 key_index,
+				enum nl80211_key_type type,
 				const u8 *mac_addr)
 {
 	struct adapter *padapter = rtw_netdev_priv(wdev->netdev);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 97c16d4ff127..8a441d30d07b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1821,6 +1821,8 @@ struct sta_txpwr {
  * @s1g_capa: S1G capabilities of station
  * @uhr_capa: UHR capabilities of the station
  * @uhr_capa_len: the length of the UHR capabilities
+ * @cip_cap_set: If CIP capabilities are present, required for CIP stations
+ * @cip_cap: CIP capabilities of station
  */
 struct link_station_parameters {
 	const u8 *mld_mac;
@@ -1842,6 +1844,8 @@ struct link_station_parameters {
 	const struct ieee80211_s1g_cap *s1g_capa;
 	const struct ieee80211_uhr_cap *uhr_capa;
 	u8 uhr_capa_len;
+	bool cip_cap_set;
+	u8 cip_cap;
 };
 
 /**
@@ -3402,6 +3406,7 @@ struct cfg80211_ml_reconf_req {
  *	flag is not set.
  * @ASSOC_REQ_SPP_AMSDU: SPP A-MSDUs will be used on this connection (if any)
  * @ASSOC_REQ_DISABLE_UHR: Disable UHR
+ * @ASSOC_REQ_CIP: Enable Control Integrity Protocol
  */
 enum cfg80211_assoc_req_flags {
 	ASSOC_REQ_DISABLE_HT			= BIT(0),
@@ -3413,6 +3418,7 @@ enum cfg80211_assoc_req_flags {
 	CONNECT_REQ_MLO_SUPPORT			= BIT(6),
 	ASSOC_REQ_SPP_AMSDU			= BIT(7),
 	ASSOC_REQ_DISABLE_UHR			= BIT(8),
+	ASSOC_REQ_CIP				= BIT(9),
 };
 
 /**
@@ -5302,14 +5308,17 @@ struct cfg80211_ops {
 				 unsigned int link_id);
 
 	int	(*add_key)(struct wiphy *wiphy, struct wireless_dev *wdev,
-			   int link_id, u8 key_index, bool pairwise,
+			   int link_id, u8 key_index,
+			   enum nl80211_key_type type,
 			   const u8 *mac_addr, struct key_params *params);
 	int	(*get_key)(struct wiphy *wiphy, struct wireless_dev *wdev,
-			   int link_id, u8 key_index, bool pairwise,
+			   int link_id, u8 key_index,
+			   enum nl80211_key_type type,
 			   const u8 *mac_addr, void *cookie,
 			   void (*callback)(void *cookie, struct key_params*));
 	int	(*del_key)(struct wiphy *wiphy, struct wireless_dev *wdev,
-			   int link_id, u8 key_index, bool pairwise,
+			   int link_id, u8 key_index,
+			   enum nl80211_key_type type,
 			   const u8 *mac_addr);
 	int	(*set_default_key)(struct wiphy *wiphy,
 				   struct net_device *netdev, int link_id,
@@ -6043,6 +6052,8 @@ struct wiphy_vendor_command {
  * @eml_capabilities: EML capabilities (for MLO)
  * @mld_capa_and_ops: MLD capabilities and operations (for MLO)
  * @ext_mld_capa_and_ops: Extended MLD capabilities and operations (for MLO)
+ * @cip_supported: CIP is supported and the capabilities are valid
+ * @cip_capabilities: CIP Capabilities element containing the MIC padding delay
  */
 struct wiphy_iftype_ext_capab {
 	enum nl80211_iftype iftype;
@@ -6052,6 +6063,8 @@ struct wiphy_iftype_ext_capab {
 	u16 eml_capabilities;
 	u16 mld_capa_and_ops;
 	u16 ext_mld_capa_and_ops;
+	bool cip_supported;
+	u8 cip_capabilities;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 020387d76412..de0e4eabb9e2 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3185,6 +3185,11 @@ enum nl80211_commands {
  *	The aggregated message always precedes the per-link messages for the
  *	same station within a dump sequence.
  *
+ * @NL80211_ATTR_ASSOC_CIP: Enable Control Integrity Protocol for the
+ *	association
+ * @NL80211_ATTR_CIP_CAPABILITIES: The Control Integrity Protocol for the
+ *	station.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3785,6 +3790,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_STA_DUMP_LINK_STATS,
 
+	NL80211_ATTR_ASSOC_CIP,
+	NL80211_ATTR_CIP_CAPABILITIES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3934,6 +3942,7 @@ enum nl80211_iftype {
  *	that support %NL80211_FEATURE_FULL_AP_CLIENT_STATE to transition a
  *	previously added station into associated state
  * @NL80211_STA_FLAG_SPP_AMSDU: station supports SPP A-MSDUs
+ * @NL80211_STA_FLAG_CIP: station has Control Integrity Protocol (CIP) enabled
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -3947,6 +3956,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_TDLS_PEER,
 	NL80211_STA_FLAG_ASSOCIATED,
 	NL80211_STA_FLAG_SPP_AMSDU,
+	NL80211_STA_FLAG_CIP,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
@@ -5778,12 +5788,16 @@ enum nl80211_auth_type {
  * @NL80211_KEYTYPE_GROUP: Group (broadcast/multicast) key
  * @NL80211_KEYTYPE_PAIRWISE: Pairwise (unicast/individual) key
  * @NL80211_KEYTYPE_PEERKEY: PeerKey (DLS)
+ * @NL80211_KEYTYPE_CIGTK: Control Integrity Group Temporal Key
+ *	The cipher is GMAC-256 but passed as GCMP-256,
+ *	same as the pairwise key when used for CIP.
  * @NUM_NL80211_KEYTYPES: number of defined key types
  */
 enum nl80211_key_type {
 	NL80211_KEYTYPE_GROUP,
 	NL80211_KEYTYPE_PAIRWISE,
 	NL80211_KEYTYPE_PEERKEY,
+	NL80211_KEYTYPE_CIGTK,
 
 	NUM_NL80211_KEYTYPES
 };
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 23f4f9ec86d0..eaafb45ff11f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -611,12 +611,14 @@ static int ieee80211_set_tx(struct ieee80211_sub_if_data *sdata,
 }
 
 static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-			     int link_id, u8 key_idx, bool pairwise,
+			     int link_id, u8 key_idx,
+			     enum nl80211_key_type type,
 			     const u8 *mac_addr, struct key_params *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 	struct ieee80211_link_data *link =
 		ieee80211_link_or_deflink(sdata, link_id, false);
+	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta = NULL;
 	struct ieee80211_key *key;
@@ -737,10 +739,12 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 static struct ieee80211_key *
 ieee80211_lookup_key(struct ieee80211_sub_if_data *sdata, int link_id,
-		     u8 key_idx, bool pairwise, const u8 *mac_addr)
+		     u8 key_idx, enum nl80211_key_type type,
+		     const u8 *mac_addr)
 {
 	struct ieee80211_local *local __maybe_unused = sdata->local;
 	struct ieee80211_link_data *link = &sdata->deflink;
+	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
 	struct ieee80211_key *key;
 
 	if (link_id >= 0) {
@@ -795,8 +799,8 @@ ieee80211_lookup_key(struct ieee80211_sub_if_data *sdata, int link_id,
 }
 
 static int ieee80211_del_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-			     int link_id, u8 key_idx, bool pairwise,
-			     const u8 *mac_addr)
+			     int link_id, u8 key_idx,
+			     enum nl80211_key_type type, const u8 *mac_addr)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 	struct ieee80211_local *local = sdata->local;
@@ -804,7 +808,7 @@ static int ieee80211_del_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
-	key = ieee80211_lookup_key(sdata, link_id, key_idx, pairwise, mac_addr);
+	key = ieee80211_lookup_key(sdata, link_id, key_idx, type, mac_addr);
 	if (!key)
 		return -ENOENT;
 
@@ -814,7 +818,8 @@ static int ieee80211_del_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 }
 
 static int ieee80211_get_key(struct wiphy *wiphy, struct wireless_dev *wdev,
-			     int link_id, u8 key_idx, bool pairwise,
+			     int link_id, u8 key_idx,
+			     enum nl80211_key_type type,
 			     const u8 *mac_addr, void *cookie,
 			     void (*callback)(void *cookie,
 					      struct key_params *params))
@@ -833,7 +838,7 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	rcu_read_lock();
 
-	key = ieee80211_lookup_key(sdata, link_id, key_idx, pairwise, mac_addr);
+	key = ieee80211_lookup_key(sdata, link_id, key_idx, type, mac_addr);
 	if (!key)
 		goto out;
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b4610f6685dc..508d731fbf33 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -443,13 +443,16 @@ void cfg80211_sme_abandon_assoc(struct wireless_dev *wdev);
 
 /* internal helpers */
 bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher);
+bool cfg80211_cigtk_supported(struct wireless_dev *wdev,
+			      struct genl_info *info);
 bool cfg80211_valid_key_idx(struct wireless_dev *wdev,
-			    int key_idx, bool pairwise,
+			    int key_idx, enum nl80211_key_type type,
 			    const u8 *mac_addr);
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct wireless_dev *wdev,
 				   struct key_params *params, int key_idx,
-				   bool pairwise, const u8 *mac_addr);
+				   enum nl80211_key_type type,
+				   const u8 *mac_addr);
 void __cfg80211_scan_done(struct wiphy *wiphy, struct wiphy_work *wk);
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 			   bool send_message);
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index b1d748bdb504..6ae561ed7f37 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -172,7 +172,8 @@ void cfg80211_clear_ibss(struct net_device *dev, bool nowext)
 	 */
 	if (rdev->ops->del_key)
 		for (i = 0; i < 6; i++)
-			rdev_del_key(rdev, wdev, -1, i, false, NULL);
+			rdev_del_key(rdev, wdev, -1, i, NL80211_KEYTYPE_GROUP,
+				     NULL);
 
 	if (wdev->u.ibss.current_bss) {
 		cfg80211_unhold_bss(wdev->u.ibss.current_bss);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 44f2bad08670..9f82d3bd248a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1096,6 +1096,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_NPCA_PUNCT_BITMAP] =
 		NLA_POLICY_FULL_RANGE(NLA_U32, &nl80211_punct_bitmap_range),
 	[NL80211_ATTR_STA_DUMP_LINK_STATS] = { .type = NLA_FLAG },
+	[NL80211_ATTR_ASSOC_CIP] = { .type = NLA_FLAG },
+	[NL80211_ATTR_CIP_CAPABILITIES] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -1761,6 +1763,11 @@ static int nl80211_parse_key(struct genl_info *info, struct key_parse *k)
 				GENL_SET_ERR_MSG(info, "def key idx not 0-3");
 				return -EINVAL;
 			}
+		} else if (k->type == NL80211_KEYTYPE_CIGTK) {
+			if (k->idx < 0 || k->idx > 1) {
+				GENL_SET_ERR_MSG(info, "CIGTK idx not 0-1");
+				return -EINVAL;
+			}
 		} else {
 			if (k->idx < 0 || k->idx > 7) {
 				GENL_SET_ERR_MSG(info, "key idx not 0-7");
@@ -1825,7 +1832,9 @@ nl80211_parse_connkeys(struct cfg80211_registered_device *rdev,
 		} else if (parse.defmgmt)
 			goto error;
 		err = cfg80211_validate_key_settings(rdev, wdev, &parse.p,
-						     parse.idx, false, NULL);
+						     parse.idx,
+						     NL80211_KEYTYPE_GROUP,
+						     NULL);
 		if (err)
 			goto error;
 		if (parse.p.cipher != WLAN_CIPHER_SUITE_WEP40 &&
@@ -3615,6 +3624,11 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 						NL80211_ATTR_EXT_MLD_CAPA_AND_OPS,
 						capab->ext_mld_capa_and_ops))
 					goto nla_put_failure;
+				if (capab->cip_supported &&
+				    nla_put_u8(msg,
+					       NL80211_ATTR_CIP_CAPABILITIES,
+					       capab->cip_capabilities))
+					goto nla_put_failure;
 
 				nla_nest_end(msg, nested_ext_capab);
 				if (state->split)
@@ -5371,6 +5385,7 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 	struct wireless_dev *wdev = info->user_ptr[1];
 	u8 key_idx = 0;
 	const u8 *mac_addr = NULL;
+	enum nl80211_key_type type;
 	bool pairwise;
 	struct get_key_cookie cookie = {
 		.error = 0,
@@ -5403,19 +5418,24 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
 	pairwise = !!mac_addr;
+	type = pairwise ? NL80211_KEYTYPE_PAIRWISE : NL80211_KEYTYPE_GROUP;
 	if (info->attrs[NL80211_ATTR_KEY_TYPE]) {
-		u32 kt = nla_get_u32(info->attrs[NL80211_ATTR_KEY_TYPE]);
+		type = nla_get_u32(info->attrs[NL80211_ATTR_KEY_TYPE]);
 
-		if (kt != NL80211_KEYTYPE_GROUP &&
-		    kt != NL80211_KEYTYPE_PAIRWISE)
+		if (type != NL80211_KEYTYPE_GROUP &&
+		    type != NL80211_KEYTYPE_PAIRWISE &&
+		    type != NL80211_KEYTYPE_CIGTK) {
+			GENL_SET_ERR_MSG(info, "key type not pairwise, group or CIGTK");
 			return -EINVAL;
-		pairwise = kt == NL80211_KEYTYPE_PAIRWISE;
+		}
+
+		pairwise = type == NL80211_KEYTYPE_PAIRWISE;
 	}
 
 	if (!rdev->ops->get_key)
 		return -EOPNOTSUPP;
 
-	if (!cfg80211_valid_key_idx(wdev, key_idx, pairwise, mac_addr))
+	if (!cfg80211_valid_key_idx(wdev, key_idx, type, mac_addr))
 		return -ENOENT;
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
@@ -5444,7 +5464,7 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		goto free_msg;
 
-	err = rdev_get_key(rdev, wdev, link_id, key_idx, pairwise, mac_addr,
+	err = rdev_get_key(rdev, wdev, link_id, key_idx, type, mac_addr,
 			   &cookie, get_key_callback);
 
 	if (err)
@@ -5603,8 +5623,9 @@ static int nl80211_new_key(struct sk_buff *skb, struct genl_info *info)
 
 	/* for now */
 	if (key.type != NL80211_KEYTYPE_PAIRWISE &&
-	    key.type != NL80211_KEYTYPE_GROUP) {
-		GENL_SET_ERR_MSG(info, "key type not pairwise or group");
+	    key.type != NL80211_KEYTYPE_GROUP &&
+	    key.type != NL80211_KEYTYPE_CIGTK) {
+		GENL_SET_ERR_MSG(info, "key type not pairwise, group or CIGTK");
 		return -EINVAL;
 	}
 
@@ -5616,8 +5637,7 @@ static int nl80211_new_key(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 
 	if (cfg80211_validate_key_settings(rdev, wdev, &key.p, key.idx,
-					   key.type == NL80211_KEYTYPE_PAIRWISE,
-					   mac_addr)) {
+					   key.type, mac_addr)) {
 		GENL_SET_ERR_MSG(info, "key setting validation failed");
 		return -EINVAL;
 	}
@@ -5631,8 +5651,7 @@ static int nl80211_new_key(struct sk_buff *skb, struct genl_info *info)
 				key.type == NL80211_KEYTYPE_PAIRWISE);
 
 	if (!err) {
-		err = rdev_add_key(rdev, wdev, link_id, key.idx,
-				   key.type == NL80211_KEYTYPE_PAIRWISE,
+		err = rdev_add_key(rdev, wdev, link_id, key.idx, key.type,
 				    mac_addr, &key.p);
 		if (err)
 			GENL_SET_ERR_MSG(info, "key addition failed");
@@ -5666,12 +5685,13 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 
 	/* for now */
 	if (key.type != NL80211_KEYTYPE_PAIRWISE &&
-	    key.type != NL80211_KEYTYPE_GROUP)
+	    key.type != NL80211_KEYTYPE_GROUP &&
+	    key.type != NL80211_KEYTYPE_CIGTK) {
+		GENL_SET_ERR_MSG(info, "key type not pairwise, group or CIGTK");
 		return -EINVAL;
+	}
 
-	if (!cfg80211_valid_key_idx(wdev, key.idx,
-				    key.type == NL80211_KEYTYPE_PAIRWISE,
-				    mac_addr))
+	if (!cfg80211_valid_key_idx(wdev, key.idx, key.type, mac_addr))
 		return -EINVAL;
 
 	if (!rdev->ops->del_key)
@@ -5685,8 +5705,7 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 
 	if (!err)
 		err = rdev_del_key(rdev, wdev, link_id, key.idx,
-				   key.type == NL80211_KEYTYPE_PAIRWISE,
-				   mac_addr);
+				   key.type, mac_addr);
 
 #ifdef CONFIG_CFG80211_WEXT
 	if (!err) {
@@ -8805,7 +8824,7 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 8);
+	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 9);
 
 	switch (statype) {
 	case CFG80211_STA_MESH_PEER_KERNEL:
@@ -8899,7 +8918,8 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
 				  BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
 				  BIT(NL80211_STA_FLAG_WME) |
 				  BIT(NL80211_STA_FLAG_MFP) |
-				  BIT(NL80211_STA_FLAG_SPP_AMSDU)))
+				  BIT(NL80211_STA_FLAG_SPP_AMSDU) |
+				  BIT(NL80211_STA_FLAG_CIP)))
 			return -EINVAL;
 
 		/* but authenticated/associated only if driver handles it */
@@ -9276,6 +9296,22 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			nla_get_u16(info->attrs[NL80211_ATTR_EML_CAPABILITY]);
 	}
 
+	if (params.sta_flags_mask & BIT(NL80211_STA_FLAG_CIP) &&
+	    params.sta_flags_set & BIT(NL80211_STA_FLAG_CIP)) {
+		if (!cfg80211_cigtk_supported(wdev, info))
+			return -EINVAL;
+
+		/* CIP capabilities are required if CIP is being enabled */
+		if (info->attrs[NL80211_ATTR_CIP_CAPABILITIES]) {
+			params.link_sta_params.cip_cap_set = true;
+			params.link_sta_params.cip_cap =
+				nla_get_u8(info->attrs[NL80211_ATTR_CIP_CAPABILITIES]);
+		} else {
+			GENL_SET_ERR_MSG(info, "No CIP capabilities provided");
+			return -EINVAL;
+		}
+	}
+
 	if (info->attrs[NL80211_ATTR_AIRTIME_WEIGHT])
 		params.airtime_weight =
 			nla_get_u16(info->attrs[NL80211_ATTR_AIRTIME_WEIGHT]);
@@ -9475,6 +9511,22 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 			nla_get_u16(info->attrs[NL80211_ATTR_EML_CAPABILITY]);
 	}
 
+	if (params.sta_flags_mask & BIT(NL80211_STA_FLAG_CIP) &&
+	    params.sta_flags_set & BIT(NL80211_STA_FLAG_CIP)) {
+		if (!cfg80211_cigtk_supported(wdev, info))
+			return -EINVAL;
+
+		/* CIP capabilities are required if CIP is enabled */
+		if (info->attrs[NL80211_ATTR_CIP_CAPABILITIES]) {
+			params.link_sta_params.cip_cap_set = true;
+			params.link_sta_params.cip_cap =
+				nla_get_u8(info->attrs[NL80211_ATTR_CIP_CAPABILITIES]);
+		} else {
+			GENL_SET_ERR_MSG(info, "No CIP capabilities provided");
+			return -EINVAL;
+		}
+	}
+
 	if (info->attrs[NL80211_ATTR_HE_6GHZ_CAPABILITY])
 		params.link_sta_params.he_6ghz_capa =
 			nla_data(info->attrs[NL80211_ATTR_HE_6GHZ_CAPABILITY]);
@@ -9552,7 +9604,7 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 
 	/* When you run into this, adjust the code below for the new flag */
-	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 8);
+	BUILD_BUG_ON(NL80211_STA_FLAG_MAX != 9);
 
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_AP:
@@ -9581,6 +9633,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		    params.sta_flags_mask & BIT(NL80211_STA_FLAG_SPP_AMSDU))
 			return -EINVAL;
 
+		if (params.sta_flags_mask & BIT(NL80211_STA_FLAG_CIP) &&
+		    !cfg80211_cigtk_supported(wdev, info))
+			return -EINVAL;
+
 		/* Older userspace, or userspace wanting to be compatible with
 		 * !NL80211_FEATURE_FULL_AP_CLIENT_STATE, will not set the auth
 		 * and assoc flags in the mask, but assumes the station will be
@@ -13307,6 +13363,13 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 		req.flags |= ASSOC_REQ_SPP_AMSDU;
 	}
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_ASSOC_CIP])) {
+		if (!cfg80211_cigtk_supported(dev->ieee80211_ptr, info))
+			return -EINVAL;
+
+		req.flags |= ASSOC_REQ_CIP;
+	}
+
 	req.link_id = nl80211_link_id_or_invalid(info->attrs);
 
 	if (info->attrs[NL80211_ATTR_MLO_LINKS]) {
@@ -19178,6 +19241,23 @@ nl80211_add_mod_link_station(struct sk_buff *skb, struct genl_info *info,
 		params.he_6ghz_capa =
 			nla_data(info->attrs[NL80211_ATTR_HE_6GHZ_CAPABILITY]);
 
+	if (info->attrs[NL80211_ATTR_CIP_CAPABILITIES]) {
+		struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+		if (!cfg80211_cigtk_supported(wdev, info))
+			return -EINVAL;
+
+		params.cip_cap_set = true;
+		params.cip_cap =
+			nla_get_u8(info->attrs[NL80211_ATTR_CIP_CAPABILITIES]);
+
+		/* Only permit CIP capabilities when adding link stations */
+		if (!add) {
+			GENL_SET_ERR_MSG(info, "Cannot modify CIP capabilities");
+			return -EINVAL;
+		}
+	}
+
 	if (info->attrs[NL80211_ATTR_OPMODE_NOTIF]) {
 		params.opmode_notif_used = true;
 		params.opmode_notif =
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 46849fe8d0b3..7653cd0da9b9 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -78,42 +78,43 @@ rdev_change_virtual_intf(struct cfg80211_registered_device *rdev,
 
 static inline int rdev_add_key(struct cfg80211_registered_device *rdev,
 			       struct wireless_dev *wdev, int link_id,
-			       u8 key_index, bool pairwise, const u8 *mac_addr,
-			       struct key_params *params)
+			       u8 key_index, enum nl80211_key_type type,
+			       const u8 *mac_addr, struct key_params *params)
 {
 	int ret;
-	trace_rdev_add_key(&rdev->wiphy, wdev, link_id, key_index, pairwise,
+	trace_rdev_add_key(&rdev->wiphy, wdev, link_id, key_index, type,
 			   mac_addr, params->mode);
 	ret = rdev->ops->add_key(&rdev->wiphy, wdev, link_id, key_index,
-				  pairwise, mac_addr, params);
+				  type, mac_addr, params);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
 
 static inline int
 rdev_get_key(struct cfg80211_registered_device *rdev, struct wireless_dev *wdev,
-	     int link_id, u8 key_index, bool pairwise, const u8 *mac_addr,
-	     void *cookie,
+	     int link_id, u8 key_index, enum nl80211_key_type type,
+	     const u8 *mac_addr, void *cookie,
 	     void (*callback)(void *cookie, struct key_params*))
 {
 	int ret;
-	trace_rdev_get_key(&rdev->wiphy, wdev, link_id, key_index, pairwise,
+	trace_rdev_get_key(&rdev->wiphy, wdev, link_id, key_index, type,
 			   mac_addr);
 	ret = rdev->ops->get_key(&rdev->wiphy, wdev, link_id, key_index,
-				  pairwise, mac_addr, cookie, callback);
+				 type, mac_addr, cookie, callback);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
 
 static inline int rdev_del_key(struct cfg80211_registered_device *rdev,
 			       struct wireless_dev *wdev, int link_id,
-			       u8 key_index, bool pairwise, const u8 *mac_addr)
+			       u8 key_index, enum nl80211_key_type type,
+			       const u8 *mac_addr)
 {
 	int ret;
-	trace_rdev_del_key(&rdev->wiphy, wdev, link_id, key_index, pairwise,
+	trace_rdev_del_key(&rdev->wiphy, wdev, link_id, key_index, type,
 			   mac_addr);
 	ret = rdev->ops->del_key(&rdev->wiphy, wdev, link_id, key_index,
-				  pairwise, mac_addr);
+				  type, mac_addr);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 2a719b5c487e..458f72d8351a 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1387,7 +1387,15 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 			    NL80211_EXT_FEATURE_BEACON_PROTECTION_CLIENT))
 			max_key_idx = 7;
 		for (i = 0; i <= max_key_idx; i++)
-			rdev_del_key(rdev, wdev, -1, i, false, NULL);
+			rdev_del_key(rdev, wdev, -1, i, NL80211_KEYTYPE_GROUP,
+				     NULL);
+
+		if (cfg80211_cigtk_supported(wdev, NULL)) {
+			rdev_del_key(rdev, wdev, -1, 0, NL80211_KEYTYPE_CIGTK,
+				     NULL);
+			rdev_del_key(rdev, wdev, -1, 1, NL80211_KEYTYPE_CIGTK,
+				     NULL);
+		}
 	}
 
 	rdev_set_qos_map(rdev, dev, NULL);
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 8c2a91b85c39..c210ca1e44e2 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -557,15 +557,15 @@ TRACE_EVENT(rdev_change_virtual_intf,
 
 DECLARE_EVENT_CLASS(key_handle,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, int link_id,
-		 u8 key_index, bool pairwise, const u8 *mac_addr),
-	TP_ARGS(wiphy, wdev, link_id, key_index, pairwise, mac_addr),
+		 u8 key_index, enum nl80211_key_type type, const u8 *mac_addr),
+	TP_ARGS(wiphy, wdev, link_id, key_index, type, mac_addr),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		WDEV_ENTRY
 		MAC_ENTRY(mac_addr)
 		__field(int, link_id)
 		__field(u8, key_index)
-		__field(bool, pairwise)
+		__field(u8, type)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
@@ -573,38 +573,40 @@ DECLARE_EVENT_CLASS(key_handle,
 		MAC_ASSIGN(mac_addr, mac_addr);
 		__entry->link_id = link_id;
 		__entry->key_index = key_index;
-		__entry->pairwise = pairwise;
+		__entry->type = type;
 	),
 	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", link_id: %d, "
-		  "key_index: %u, pairwise: %s, mac addr: %pM",
+		  "key_index: %u, pairwise: %s, type: %d, mac addr: %pM",
 		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->link_id,
-		  __entry->key_index, BOOL_TO_STR(__entry->pairwise),
-		  __entry->mac_addr)
+		  __entry->key_index,
+		  BOOL_TO_STR(__entry->type == NL80211_KEYTYPE_PAIRWISE),
+		  __entry->type, __entry->mac_addr)
 );
 
 DEFINE_EVENT(key_handle, rdev_get_key,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, int link_id,
-		 u8 key_index, bool pairwise, const u8 *mac_addr),
-	TP_ARGS(wiphy, wdev, link_id, key_index, pairwise, mac_addr)
+		 u8 key_index, enum nl80211_key_type type, const u8 *mac_addr),
+	TP_ARGS(wiphy, wdev, link_id, key_index, type, mac_addr)
 );
 
 DEFINE_EVENT(key_handle, rdev_del_key,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, int link_id,
-		 u8 key_index, bool pairwise, const u8 *mac_addr),
-	TP_ARGS(wiphy, wdev, link_id, key_index, pairwise, mac_addr)
+		 u8 key_index, enum nl80211_key_type type, const u8 *mac_addr),
+	TP_ARGS(wiphy, wdev, link_id, key_index, type, mac_addr)
 );
 
 TRACE_EVENT(rdev_add_key,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev, int link_id,
-		 u8 key_index, bool pairwise, const u8 *mac_addr, u8 mode),
-	TP_ARGS(wiphy, wdev, link_id, key_index, pairwise, mac_addr, mode),
+		 u8 key_index, enum nl80211_key_type type, const u8 *mac_addr,
+		 u8 mode),
+	TP_ARGS(wiphy, wdev, link_id, key_index, type, mac_addr, mode),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		WDEV_ENTRY
 		MAC_ENTRY(mac_addr)
 		__field(int, link_id)
 		__field(u8, key_index)
-		__field(bool, pairwise)
+		__field(u8, type)
 		__field(u8, mode)
 	),
 	TP_fast_assign(
@@ -613,15 +615,16 @@ TRACE_EVENT(rdev_add_key,
 		MAC_ASSIGN(mac_addr, mac_addr);
 		__entry->link_id = link_id;
 		__entry->key_index = key_index;
-		__entry->pairwise = pairwise;
+		__entry->type = type;
 		__entry->mode = mode;
 	),
 	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", link_id: %d, "
-		  "key_index: %u, mode: %u, pairwise: %s, "
+		  "key_index: %u, mode: %u, pairwise: %s, type: %d, "
 		  "mac addr: %pM",
 		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->link_id,
 		  __entry->key_index, __entry->mode,
-		  BOOL_TO_STR(__entry->pairwise), __entry->mac_addr)
+		  BOOL_TO_STR(__entry->type == NL80211_KEYTYPE_PAIRWISE),
+		  __entry->type, __entry->mac_addr)
 );
 
 TRACE_EVENT(rdev_set_default_key,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 3e584d0ca3e2..dd166c352910 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -258,8 +258,24 @@ static bool cfg80211_igtk_cipher_supported(struct wiphy *wiphy)
 	return false;
 }
 
+bool cfg80211_cigtk_supported(struct wireless_dev *wdev,
+			      struct genl_info *info)
+{
+	const struct wiphy_iftype_ext_capab *ext_capab =
+		cfg80211_get_iftype_ext_capa(wdev->wiphy, wdev->iftype);
+
+	if (ext_capab && ext_capab->cip_supported)
+		return true;
+
+	if (info)
+		GENL_SET_ERR_MSG(info,
+				 "Control Integrity Protocol not supported");
+
+	return false;
+}
+
 bool cfg80211_valid_key_idx(struct wireless_dev *wdev,
-			    int key_idx, bool pairwise,
+			    int key_idx, enum nl80211_key_type type,
 			    const u8 *mac_addr)
 {
 	if (WARN_ON(!wdev))
@@ -272,13 +288,24 @@ bool cfg80211_valid_key_idx(struct wireless_dev *wdev,
 	 * Can't differentiate ciphers here so allow 0..3.
 	 * Pairwise keys must be for a station (MAC address given).
 	 */
-	if (pairwise) {
+	if (type == NL80211_KEYTYPE_PAIRWISE) {
 		if (!mac_addr)
 			return false;
 
 		return key_idx < 4;
 	}
 
+	/* Check the wdev/iftype supports CIGTK */
+	if (type == NL80211_KEYTYPE_CIGTK) {
+		if (!cfg80211_cigtk_supported(wdev, NULL))
+			return false;
+
+		if (key_idx >= 2)
+			return false;
+
+		/* fallthrough for mac_addr checks */
+	}
+
 	/*
 	 * For group keys, mac_addr==NULL means setting a group key
 	 * for TX, which is only supported on some interface types,
@@ -343,9 +370,12 @@ bool cfg80211_valid_key_idx(struct wireless_dev *wdev,
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct wireless_dev *wdev,
 				   struct key_params *params, int key_idx,
-				   bool pairwise, const u8 *mac_addr)
+				   enum nl80211_key_type type,
+				   const u8 *mac_addr)
 {
-	if (!cfg80211_valid_key_idx(wdev, key_idx, pairwise, mac_addr))
+	bool pairwise = type == NL80211_KEYTYPE_PAIRWISE;
+
+	if (!cfg80211_valid_key_idx(wdev, key_idx, type, mac_addr))
 		return -EINVAL;
 
 	switch (params->cipher) {
@@ -1172,7 +1202,7 @@ void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
 	for (i = 0; i < 4; i++) {
 		if (!wdev->connect_keys->params[i].cipher)
 			continue;
-		if (rdev_add_key(rdev, wdev, -1, i, false, NULL,
+		if (rdev_add_key(rdev, wdev, -1, i, NL80211_KEYTYPE_GROUP, NULL,
 				 &wdev->connect_keys->params[i])) {
 			netdev_err(dev, "failed to set key %d\n", i);
 			continue;
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index d45bc08c0de4..ec2389f6b8b1 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -401,6 +401,8 @@ static int cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 				   int idx, struct key_params *params)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	enum nl80211_key_type key_type =
+		pairwise ? NL80211_KEYTYPE_PAIRWISE : NL80211_KEYTYPE_GROUP;
 	int err, i;
 	bool rejoin = false;
 
@@ -454,11 +456,11 @@ static int cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 				rejoin = true;
 			}
 
-			if (!cfg80211_valid_key_idx(wdev, idx, pairwise, addr))
+			if (!cfg80211_valid_key_idx(wdev, idx, key_type, addr))
 				err = -ENOENT;
 			else
-				err = rdev_del_key(rdev, wdev, -1, idx, pairwise,
-						   addr);
+				err = rdev_del_key(rdev, wdev, -1, idx,
+						   key_type, addr);
 		}
 		wdev->wext.connect.privacy = false;
 		/*
-- 
2.55.0


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49866 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbZGBPUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 11:20:47 -0400
Subject: [PATCH] cfg80211: keep track of BSSes
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 17:20:43 +0200
Message-Id: <1246548043.16770.42.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to avoid problems with BSS structs going away
while they're in use, I've long wanted to make cfg80211
keep track of them. Without the SME, that wasn't doable
but now that we have the SME we can do this too. It can
keep track of up to four separate authentications and
one association, regardless of whether it's controlled
by the cfg80211 SME or the userspace SME.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h  |   86 ++---------
 net/mac80211/cfg.c      |   22 +-
 net/mac80211/mlme.c     |    6 
 net/wireless/core.c     |    5 
 net/wireless/core.h     |   41 +++++
 net/wireless/ibss.c     |   12 -
 net/wireless/mlme.c     |  361 +++++++++++++++++++++++++++++++++++++++++++++---
 net/wireless/nl80211.c  |  144 +++++++++----------
 net/wireless/scan.c     |   31 ----
 net/wireless/sme.c      |  156 ++++++++++++--------
 net/wireless/wext-sme.c |    4 
 11 files changed, 591 insertions(+), 277 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-07-02 17:13:49.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-02 17:17:11.000000000 +0200
@@ -584,7 +584,6 @@ enum cfg80211_signal_type {
  *	is no guarantee that these are well-formed!)
  * @len_information_elements: total length of the information elements
  * @signal: signal strength value (type depends on the wiphy's signal_type)
- * @hold: BSS should not expire
  * @free_priv: function pointer to free private data
  * @priv: private area for driver use, has at least wiphy->bss_priv_size bytes
  */
@@ -642,33 +641,17 @@ struct cfg80211_crypto_settings {
  *
  * This structure provides information needed to complete IEEE 802.11
  * authentication.
- * NOTE: This structure will likely change when more code from mac80211 is
- * moved into cfg80211 so that non-mac80211 drivers can benefit from it, too.
- * Before using this in a driver that does not use mac80211, it would be better
- * to check the status of that work and better yet, volunteer to work on it.
- *
- * @chan: The channel to use or %NULL if not specified (auto-select based on
- *	scan results)
- * @peer_addr: The address of the peer STA (AP BSSID in infrastructure case);
- *	this field is required to be present; if the driver wants to help with
- *	BSS selection, it should use (yet to be added) MLME event to allow user
- *	space SME to be notified of roaming candidate, so that the SME can then
- *	use the authentication request with the recommended BSSID and whatever
- *	other data may be needed for authentication/association
- * @ssid: SSID or %NULL if not yet available
- * @ssid_len: Length of ssid in octets
+ *
+ * @bss: The BSS to authenticate with.
  * @auth_type: Authentication type (algorithm)
  * @ie: Extra IEs to add to Authentication frame or %NULL
  * @ie_len: Length of ie buffer in octets
  */
 struct cfg80211_auth_request {
-	struct ieee80211_channel *chan;
-	u8 *peer_addr;
-	const u8 *ssid;
-	size_t ssid_len;
-	enum nl80211_auth_type auth_type;
+	struct cfg80211_bss *bss;
 	const u8 *ie;
 	size_t ie_len;
+	enum nl80211_auth_type auth_type;
 };
 
 /**
@@ -676,32 +659,18 @@ struct cfg80211_auth_request {
  *
  * This structure provides information needed to complete IEEE 802.11
  * (re)association.
- * NOTE: This structure will likely change when more code from mac80211 is
- * moved into cfg80211 so that non-mac80211 drivers can benefit from it, too.
- * Before using this in a driver that does not use mac80211, it would be better
- * to check the status of that work and better yet, volunteer to work on it.
- *
- * @chan: The channel to use or %NULL if not specified (auto-select based on
- *	scan results)
- * @peer_addr: The address of the peer STA (AP BSSID); this field is required
- *	to be present and the STA must be in State 2 (authenticated) with the
- *	peer STA
- * @ssid: SSID
- * @ssid_len: Length of ssid in octets
+ * @bss: The BSS to associate with.
  * @ie: Extra IEs to add to (Re)Association Request frame or %NULL
  * @ie_len: Length of ie buffer in octets
  * @use_mfp: Use management frame protection (IEEE 802.11w) in this association
  * @crypto: crypto settings
  */
 struct cfg80211_assoc_request {
-	struct ieee80211_channel *chan;
-	u8 *peer_addr;
-	const u8 *ssid;
-	size_t ssid_len;
+	struct cfg80211_bss *bss;
 	const u8 *ie;
 	size_t ie_len;
-	bool use_mfp;
 	struct cfg80211_crypto_settings crypto;
+	bool use_mfp;
 };
 
 /**
@@ -710,16 +679,16 @@ struct cfg80211_assoc_request {
  * This structure provides information needed to complete IEEE 802.11
  * deauthentication.
  *
- * @peer_addr: The address of the peer STA (AP BSSID); this field is required
- *	to be present and the STA must be authenticated with the peer STA
+ * @bss: the BSS to deauthenticate from
  * @ie: Extra IEs to add to Deauthentication frame or %NULL
  * @ie_len: Length of ie buffer in octets
+ * @reason_code: The reason code for the deauthentication
  */
 struct cfg80211_deauth_request {
-	u8 *peer_addr;
-	u16 reason_code;
+	struct cfg80211_bss *bss;
 	const u8 *ie;
 	size_t ie_len;
+	u16 reason_code;
 };
 
 /**
@@ -728,16 +697,16 @@ struct cfg80211_deauth_request {
  * This structure provides information needed to complete IEEE 802.11
  * disassocation.
  *
- * @peer_addr: The address of the peer STA (AP BSSID); this field is required
- *	to be present and the STA must be associated with the peer STA
+ * @bss: the BSS to disassociate from
  * @ie: Extra IEs to add to Disassociation frame or %NULL
  * @ie_len: Length of ie buffer in octets
+ * @reason_code: The reason code for the disassociation
  */
 struct cfg80211_disassoc_request {
-	u8 *peer_addr;
-	u16 reason_code;
+	struct cfg80211_bss *bss;
 	const u8 *ie;
 	size_t ie_len;
+	u16 reason_code;
 };
 
 /**
@@ -1252,6 +1221,9 @@ extern void wiphy_free(struct wiphy *wip
 
 /* internal struct */
 struct cfg80211_conn;
+struct cfg80211_internal_bss;
+
+#define MAX_AUTH_BSSES		4
 
 /**
  * struct wireless_dev - wireless per-netdev state
@@ -1281,7 +1253,6 @@ struct wireless_dev {
 	struct net_device *netdev;
 
 	/* currently used for IBSS and SME - might be rearranged later */
-	struct cfg80211_bss *current_bss;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ssid_len;
 	enum {
@@ -1291,6 +1262,10 @@ struct wireless_dev {
 	} sme_state;
 	struct cfg80211_conn *conn;
 
+	struct cfg80211_internal_bss *authtry_bsses[MAX_AUTH_BSSES];
+	struct cfg80211_internal_bss *auth_bsses[MAX_AUTH_BSSES];
+	struct cfg80211_internal_bss *current_bss; /* associated / joined */
+
 #ifdef CONFIG_WIRELESS_EXT
 	/* wext data */
 	struct {
@@ -1813,23 +1788,6 @@ void cfg80211_send_deauth(struct net_dev
 void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp);
 
 /**
- * cfg80211_hold_bss - exclude bss from expiration
- * @bss: bss which should not expire
- *
- * In a case when the BSS is not updated but it shouldn't expire this
- * function can be used to mark the BSS to be excluded from expiration.
- */
-void cfg80211_hold_bss(struct cfg80211_bss *bss);
-
-/**
- * cfg80211_unhold_bss - remove expiration exception from the BSS
- * @bss: bss which can expire again
- *
- * This function marks the BSS to be expirable again.
- */
-void cfg80211_unhold_bss(struct cfg80211_bss *bss);
-
-/**
  * cfg80211_michael_mic_failure - notification of Michael MIC failure (TKIP)
  * @dev: network device
  * @addr: The source MAC address of the frame
--- wireless-testing.orig/net/wireless/core.h	2009-07-02 17:13:46.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-07-02 17:17:11.000000000 +0200
@@ -110,12 +110,30 @@ struct cfg80211_internal_bss {
 	struct rb_node rbn;
 	unsigned long ts;
 	struct kref ref;
-	bool hold, ies_allocated;
+	atomic_t hold;
+	bool ies_allocated;
 
 	/* must be last because of priv member */
 	struct cfg80211_bss pub;
 };
 
+static inline struct cfg80211_internal_bss *bss_from_pub(struct cfg80211_bss *pub)
+{
+	return container_of(pub, struct cfg80211_internal_bss, pub);
+}
+
+static inline void cfg80211_hold_bss(struct cfg80211_internal_bss *bss)
+{
+	atomic_inc(&bss->hold);
+}
+
+static inline void cfg80211_unhold_bss(struct cfg80211_internal_bss *bss)
+{
+	int r = atomic_dec_return(&bss->hold);
+	WARN_ON(r < 0);
+}
+
+
 struct cfg80211_registered_device *cfg80211_drv_by_wiphy_idx(int wiphy_idx);
 int get_wiphy_idx(struct wiphy *wiphy);
 
@@ -176,6 +194,26 @@ void cfg80211_clear_ibss(struct net_devi
 int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, bool nowext);
 
+/* MLME */
+int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev, struct ieee80211_channel *chan,
+		       enum nl80211_auth_type auth_type, const u8 *bssid,
+		       const u8 *ssid, int ssid_len,
+		       const u8 *ie, int ie_len);
+int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
+			struct net_device *dev, struct ieee80211_channel *chan,
+			const u8 *bssid, const u8 *ssid, int ssid_len,
+			const u8 *ie, int ie_len, bool use_mfp,
+			struct cfg80211_crypto_settings *crypt);
+int cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev, const u8 *bssid,
+			 const u8 *ie, int ie_len, u16 reason);
+int cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
+			   struct net_device *dev, const u8 *bssid,
+			   const u8 *ie, int ie_len, u16 reason);
+void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
+			struct net_device *dev);
+
 /* SME */
 int cfg80211_connect(struct cfg80211_registered_device *rdev,
 		     struct net_device *dev,
@@ -193,5 +231,6 @@ void __cfg80211_disconnected(struct net_
 			     size_t ie_len, u16 reason, bool from_ap);
 void cfg80211_sme_scan_done(struct net_device *dev);
 void cfg80211_sme_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
+void cfg80211_sme_disassoc(struct net_device *dev, int idx);
 
 #endif /* __NET_WIRELESS_CORE_H */
--- wireless-testing.orig/net/wireless/mlme.c	2009-07-02 17:13:46.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-07-02 17:17:11.000000000 +0200
@@ -14,8 +14,32 @@
 
 void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp)
 {
-	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
+	u8 *bssid = mgmt->bssid;
+	int i;
+	u16 status = le16_to_cpu(mgmt->u.auth.status_code);
+	bool done = false;
+
+	for (i = 0; i < MAX_AUTH_BSSES; i++) {
+		if (wdev->authtry_bsses[i] &&
+		    memcmp(wdev->authtry_bsses[i]->pub.bssid, bssid,
+							ETH_ALEN) == 0) {
+			if (status == WLAN_STATUS_SUCCESS) {
+				wdev->auth_bsses[i] = wdev->authtry_bsses[i];
+			} else {
+				cfg80211_unhold_bss(wdev->authtry_bsses[i]);
+				cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
+			}
+			wdev->authtry_bsses[i] = NULL;
+			done = true;
+			break;
+		}
+	}
+
+	WARN_ON(!done);
 
 	nl80211_send_rx_auth(rdev, dev, buf, len, gfp);
 	cfg80211_sme_rx_auth(dev, buf, len);
@@ -30,7 +54,8 @@ void cfg80211_send_rx_assoc(struct net_d
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
 	u8 *ie = mgmt->u.assoc_resp.variable;
-	int ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
+	int i, ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
+	bool done;
 
 	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
 
@@ -38,6 +63,20 @@ void cfg80211_send_rx_assoc(struct net_d
 
 	cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, ie, len - ieoffs,
 				status_code, gfp);
+
+	if (status_code == WLAN_STATUS_SUCCESS) {
+		for (i = 0; wdev->current_bss && i < MAX_AUTH_BSSES; i++) {
+			if (wdev->auth_bsses[i] == wdev->current_bss) {
+				cfg80211_unhold_bss(wdev->auth_bsses[i]);
+				cfg80211_put_bss(&wdev->auth_bsses[i]->pub);
+				wdev->auth_bsses[i] = NULL;
+				done = true;
+				break;
+			}
+		}
+
+		WARN_ON(!done);
+	}
 }
 EXPORT_SYMBOL(cfg80211_send_rx_assoc);
 
@@ -47,9 +86,45 @@ void cfg80211_send_deauth(struct net_dev
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
+	const u8 *bssid = mgmt->bssid;
+	int i;
+	bool done = false;
 
 	nl80211_send_deauth(rdev, dev, buf, len, gfp);
 
+	if (wdev->current_bss &&
+	    memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) == 0) {
+		done = true;
+		cfg80211_unhold_bss(wdev->current_bss);
+		cfg80211_put_bss(&wdev->current_bss->pub);
+		wdev->current_bss = NULL;
+	} else for (i = 0; i < MAX_AUTH_BSSES; i++) {
+		if (wdev->auth_bsses[i] &&
+		    memcmp(wdev->auth_bsses[i]->pub.bssid, bssid, ETH_ALEN) == 0) {
+			cfg80211_unhold_bss(wdev->auth_bsses[i]);
+			cfg80211_put_bss(&wdev->auth_bsses[i]->pub);
+			wdev->auth_bsses[i] = NULL;
+			done = true;
+			break;
+		}
+		if (wdev->authtry_bsses[i] &&
+		    memcmp(wdev->authtry_bsses[i]->pub.bssid, bssid, ETH_ALEN) == 0) {
+			cfg80211_unhold_bss(wdev->authtry_bsses[i]);
+			cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
+			wdev->authtry_bsses[i] = NULL;
+			done = true;
+			break;
+		}
+	}
+/*
+ * mac80211 currently triggers this warning,
+ * so disable for now (it's harmless, just
+ * means that we got a spurious event)
+
+	WARN_ON(!done);
+
+ */
+
 	if (wdev->sme_state == CFG80211_SME_CONNECTED) {
 		u16 reason_code;
 		bool from_ap;
@@ -59,8 +134,6 @@ void cfg80211_send_deauth(struct net_dev
 		from_ap = memcmp(mgmt->da, dev->dev_addr, ETH_ALEN) == 0;
 		__cfg80211_disconnected(dev, gfp, NULL, 0,
 					reason_code, from_ap);
-
-		wdev->sme_state = CFG80211_SME_IDLE;
 	} else if (wdev->sme_state == CFG80211_SME_CONNECTING) {
 		cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, NULL, 0,
 					WLAN_STATUS_UNSPECIFIED_FAILURE, gfp);
@@ -74,21 +147,38 @@ void cfg80211_send_disassoc(struct net_d
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
+	const u8 *bssid = mgmt->bssid;
+	int i;
+	u16 reason_code;
+	bool from_ap;
+	bool done = false;
 
 	nl80211_send_disassoc(rdev, dev, buf, len, gfp);
 
-	if (wdev->sme_state == CFG80211_SME_CONNECTED) {
-		u16 reason_code;
-		bool from_ap;
-
-		reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
-
-		from_ap = memcmp(mgmt->da, dev->dev_addr, ETH_ALEN) == 0;
-		__cfg80211_disconnected(dev, gfp, NULL, 0,
-					reason_code, from_ap);
+	if (!wdev->sme_state == CFG80211_SME_CONNECTED)
+		return;
 
-		wdev->sme_state = CFG80211_SME_IDLE;
-	}
+	if (wdev->current_bss &&
+	    memcmp(wdev->current_bss, bssid, ETH_ALEN) == 0) {
+		for (i = 0; i < MAX_AUTH_BSSES; i++) {
+			if (wdev->authtry_bsses[i] || wdev->auth_bsses[i])
+				continue;
+			wdev->auth_bsses[i] = wdev->current_bss;
+			wdev->current_bss = NULL;
+			done = true;
+			cfg80211_sme_disassoc(dev, i);
+			break;
+		}
+		WARN_ON(!done);
+	} else
+		WARN_ON(1);
+
+
+	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
+
+	from_ap = memcmp(mgmt->da, dev->dev_addr, ETH_ALEN) == 0;
+	__cfg80211_disconnected(dev, gfp, NULL, 0,
+				reason_code, from_ap);
 }
 EXPORT_SYMBOL(cfg80211_send_disassoc);
 
@@ -97,11 +187,27 @@ void cfg80211_send_auth_timeout(struct n
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	int i;
+	bool done = false;
+
 	nl80211_send_auth_timeout(rdev, dev, addr, gfp);
 	if (wdev->sme_state == CFG80211_SME_CONNECTING)
 		cfg80211_connect_result(dev, addr, NULL, 0, NULL, 0,
 					WLAN_STATUS_UNSPECIFIED_FAILURE, gfp);
-	wdev->sme_state = CFG80211_SME_IDLE;
+
+	for (i = 0; addr && i < MAX_AUTH_BSSES; i++) {
+		if (wdev->authtry_bsses[i] &&
+		    memcmp(wdev->authtry_bsses[i]->pub.bssid,
+			   addr, ETH_ALEN) == 0) {
+			cfg80211_unhold_bss(wdev->authtry_bsses[i]);
+			cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
+			wdev->authtry_bsses[i] = NULL;
+			done = true;
+			break;
+		}
+	}
+
+	WARN_ON(!done);
 }
 EXPORT_SYMBOL(cfg80211_send_auth_timeout);
 
@@ -110,11 +216,27 @@ void cfg80211_send_assoc_timeout(struct 
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	int i;
+	bool done = false;
+
 	nl80211_send_assoc_timeout(rdev, dev, addr, gfp);
 	if (wdev->sme_state == CFG80211_SME_CONNECTING)
 		cfg80211_connect_result(dev, addr, NULL, 0, NULL, 0,
 					WLAN_STATUS_UNSPECIFIED_FAILURE, gfp);
-	wdev->sme_state = CFG80211_SME_IDLE;
+
+	for (i = 0; addr && i < MAX_AUTH_BSSES; i++) {
+		if (wdev->auth_bsses[i] &&
+		    memcmp(wdev->auth_bsses[i]->pub.bssid,
+			   addr, ETH_ALEN) == 0) {
+			cfg80211_unhold_bss(wdev->auth_bsses[i]);
+			cfg80211_put_bss(&wdev->auth_bsses[i]->pub);
+			wdev->auth_bsses[i] = NULL;
+			done = true;
+			break;
+		}
+	}
+
+	WARN_ON(!done);
 }
 EXPORT_SYMBOL(cfg80211_send_assoc_timeout);
 
@@ -143,3 +265,208 @@ void cfg80211_michael_mic_failure(struct
 	nl80211_michael_mic_failure(rdev, dev, addr, key_type, key_id, tsc, gfp);
 }
 EXPORT_SYMBOL(cfg80211_michael_mic_failure);
+
+/* some MLME handling for userspace SME */
+int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev, struct ieee80211_channel *chan,
+		       enum nl80211_auth_type auth_type, const u8 *bssid,
+		       const u8 *ssid, int ssid_len,
+		       const u8 *ie, int ie_len)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_auth_request req;
+	struct cfg80211_internal_bss *bss;
+	int i, err, slot = -1, nfree = 0;
+
+	memset(&req, 0, sizeof(req));
+
+	req.ie = ie;
+	req.ie_len = ie_len;
+	req.auth_type = auth_type;
+	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
+				   WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+	if (!req.bss)
+		return -ENOENT;
+
+	bss = bss_from_pub(req.bss);
+
+	for (i = 0; i < MAX_AUTH_BSSES; i++) {
+		if (bss == wdev->auth_bsses[i]) {
+			err = -EALREADY;
+			goto out;
+		}
+	}
+
+	for (i = 0; i < MAX_AUTH_BSSES; i++) {
+		if (!wdev->auth_bsses[i] && !wdev->authtry_bsses[i]) {
+			slot = i;
+			nfree++;
+		}
+	}
+
+	/* we need one free slot for disassoc and one for this auth */
+	if (nfree < 2) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	wdev->authtry_bsses[slot] = bss;
+	cfg80211_hold_bss(bss);
+
+	err = rdev->ops->auth(&rdev->wiphy, dev, &req);
+	if (err) {
+		wdev->authtry_bsses[slot] = NULL;
+		cfg80211_unhold_bss(bss);
+	}
+
+ out:
+	if (err)
+		cfg80211_put_bss(req.bss);
+	return err;
+}
+
+int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
+			struct net_device *dev, struct ieee80211_channel *chan,
+			const u8 *bssid, const u8 *ssid, int ssid_len,
+			const u8 *ie, int ie_len, bool use_mfp,
+			struct cfg80211_crypto_settings *crypt)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_assoc_request req;
+	struct cfg80211_internal_bss *bss;
+	int i, err, slot = -1;
+
+	memset(&req, 0, sizeof(req));
+
+	if (wdev->current_bss)
+		return -EALREADY;
+
+	req.ie = ie;
+	req.ie_len = ie_len;
+	memcpy(&req.crypto, crypt, sizeof(req.crypto));
+	req.use_mfp = use_mfp;
+	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
+				   WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+	if (!req.bss)
+		return -ENOENT;
+
+	bss = bss_from_pub(req.bss);
+
+	for (i = 0; i < MAX_AUTH_BSSES; i++) {
+		if (bss == wdev->auth_bsses[i]) {
+			slot = i;
+			break;
+		}
+	}
+
+	if (slot < 0) {
+		err = -ENOTCONN;
+		goto out;
+	}
+
+	err = rdev->ops->assoc(&rdev->wiphy, dev, &req);
+ out:
+	/* still a reference in wdev->auth_bsses[slot] */
+	cfg80211_put_bss(req.bss);
+	return err;
+}
+
+int cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev, const u8 *bssid,
+			 const u8 *ie, int ie_len, u16 reason)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_deauth_request req;
+	int i;
+
+	memset(&req, 0, sizeof(req));
+	req.reason_code = reason;
+	req.ie = ie;
+	req.ie_len = ie_len;
+	if (wdev->current_bss &&
+	    memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) == 0) {
+		req.bss = &wdev->current_bss->pub;
+	} else for (i = 0; i < MAX_AUTH_BSSES; i++) {
+		if (wdev->auth_bsses[i] &&
+		    memcmp(bssid, wdev->auth_bsses[i]->pub.bssid, ETH_ALEN) == 0) {
+			req.bss = &wdev->auth_bsses[i]->pub;
+			break;
+		}
+		if (wdev->authtry_bsses[i] &&
+		    memcmp(bssid, wdev->authtry_bsses[i]->pub.bssid, ETH_ALEN) == 0) {
+			req.bss = &wdev->authtry_bsses[i]->pub;
+			break;
+		}
+	}
+
+	if (!req.bss)
+		return -ENOTCONN;
+
+	return rdev->ops->deauth(&rdev->wiphy, dev, &req);
+}
+
+int cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
+			   struct net_device *dev, const u8 *bssid,
+			   const u8 *ie, int ie_len, u16 reason)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_disassoc_request req;
+
+	memset(&req, 0, sizeof(req));
+	req.reason_code = reason;
+	req.ie = ie;
+	req.ie_len = ie_len;
+	if (memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) == 0)
+		req.bss = &wdev->current_bss->pub;
+	else
+		return -ENOTCONN;
+
+	return rdev->ops->disassoc(&rdev->wiphy, dev, &req);
+}
+
+void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
+			struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_deauth_request req;
+	int i;
+
+	if (!rdev->ops->deauth)
+		return;
+
+	memset(&req, 0, sizeof(req));
+	req.reason_code = WLAN_REASON_DEAUTH_LEAVING;
+	req.ie = NULL;
+	req.ie_len = 0;
+
+	if (wdev->current_bss) {
+		req.bss = &wdev->current_bss->pub;
+		rdev->ops->deauth(&rdev->wiphy, dev, &req);
+		if (wdev->current_bss) {
+			cfg80211_unhold_bss(wdev->current_bss);
+			cfg80211_put_bss(&wdev->current_bss->pub);
+			wdev->current_bss = NULL;
+		}
+	}
+
+	for (i = 0; i < MAX_AUTH_BSSES; i++) {
+		if (wdev->auth_bsses[i]) {
+			req.bss = &wdev->auth_bsses[i]->pub;
+			rdev->ops->deauth(&rdev->wiphy, dev, &req);
+			if (wdev->auth_bsses[i]) {
+				cfg80211_unhold_bss(wdev->auth_bsses[i]);
+				cfg80211_put_bss(&wdev->auth_bsses[i]->pub);
+				wdev->auth_bsses[i] = NULL;
+			}
+		}
+		if (wdev->authtry_bsses[i]) {
+			req.bss = &wdev->authtry_bsses[i]->pub;
+			rdev->ops->deauth(&rdev->wiphy, dev, &req);
+			if (wdev->authtry_bsses[i]) {
+				cfg80211_unhold_bss(wdev->authtry_bsses[i]);
+				cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
+				wdev->authtry_bsses[i] = NULL;
+			}
+		}
+	}
+}
--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-02 17:13:46.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-02 17:17:11.000000000 +0200
@@ -3043,9 +3043,10 @@ static int nl80211_authenticate(struct s
 {
 	struct cfg80211_registered_device *drv;
 	struct net_device *dev;
-	struct cfg80211_auth_request req;
-	struct wiphy *wiphy;
-	int err;
+	struct ieee80211_channel *chan;
+	const u8 *bssid, *ssid, *ie = NULL;
+	int err, ssid_len, ie_len = 0;
+	enum nl80211_auth_type auth_type;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
@@ -3056,6 +3057,12 @@ static int nl80211_authenticate(struct s
 	if (!info->attrs[NL80211_ATTR_AUTH_TYPE])
 		return -EINVAL;
 
+	if (!info->attrs[NL80211_ATTR_SSID])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
+		return -EINVAL;
+
 	rtnl_lock();
 
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
@@ -3077,38 +3084,30 @@ static int nl80211_authenticate(struct s
 		goto out;
 	}
 
-	wiphy = &drv->wiphy;
-	memset(&req, 0, sizeof(req));
-
-	req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
-
-	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		req.chan = ieee80211_get_channel(
-			wiphy,
-			nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
-		if (!req.chan) {
-			err = -EINVAL;
-			goto out;
-		}
+	bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	chan = ieee80211_get_channel(&drv->wiphy,
+		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+	if (!chan || (chan->flags & IEEE80211_CHAN_DISABLED)) {
+		err = -EINVAL;
+		goto out;
 	}
 
-	if (info->attrs[NL80211_ATTR_SSID]) {
-		req.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
-		req.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
-	}
+	ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
+	ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
 
 	if (info->attrs[NL80211_ATTR_IE]) {
-		req.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
-		req.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+		ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	req.auth_type = nla_get_u32(info->attrs[NL80211_ATTR_AUTH_TYPE]);
-	if (!nl80211_valid_auth_type(req.auth_type)) {
+	auth_type = nla_get_u32(info->attrs[NL80211_ATTR_AUTH_TYPE]);
+	if (!nl80211_valid_auth_type(auth_type)) {
 		err = -EINVAL;
 		goto out;
 	}
 
-	err = drv->ops->auth(&drv->wiphy, dev, &req);
+	err = cfg80211_mlme_auth(drv, dev, chan, auth_type, bssid,
+				 ssid, ssid_len, ie, ie_len);
 
 out:
 	cfg80211_put_dev(drv);
@@ -3182,26 +3181,29 @@ static int nl80211_crypto_settings(struc
 
 static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 {
-	struct cfg80211_registered_device *drv;
+	struct cfg80211_registered_device *rdev;
 	struct net_device *dev;
-	struct cfg80211_assoc_request req;
-	struct wiphy *wiphy;
-	int err;
+	struct cfg80211_crypto_settings crypto;
+	struct ieee80211_channel *chan;
+	const u8 *bssid, *ssid, *ie = NULL;
+	int err, ssid_len, ie_len = 0;
+	bool use_mfp = false;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
 
 	if (!info->attrs[NL80211_ATTR_MAC] ||
-	    !info->attrs[NL80211_ATTR_SSID])
+	    !info->attrs[NL80211_ATTR_SSID] ||
+	    !info->attrs[NL80211_ATTR_WIPHY_FREQ])
 		return -EINVAL;
 
 	rtnl_lock();
 
-	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	err = get_drv_dev_by_info_ifindex(info->attrs, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
-	if (!drv->ops->assoc) {
+	if (!rdev->ops->assoc) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -3216,46 +3218,42 @@ static int nl80211_associate(struct sk_b
 		goto out;
 	}
 
-	wiphy = &drv->wiphy;
-	memset(&req, 0, sizeof(req));
-
-	req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		req.chan = ieee80211_get_channel(
-			wiphy,
-			nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
-		if (!req.chan) {
-			err = -EINVAL;
-			goto out;
-		}
+	chan = ieee80211_get_channel(&rdev->wiphy,
+		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+	if (!chan || (chan->flags & IEEE80211_CHAN_DISABLED)) {
+		err = -EINVAL;
+		goto out;
 	}
 
-	req.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
-	req.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
+	ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
+	ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
 
 	if (info->attrs[NL80211_ATTR_IE]) {
-		req.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
-		req.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+		ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
 	if (info->attrs[NL80211_ATTR_USE_MFP]) {
 		enum nl80211_mfp use_mfp =
 			nla_get_u32(info->attrs[NL80211_ATTR_USE_MFP]);
 		if (use_mfp == NL80211_MFP_REQUIRED)
-			req.use_mfp = true;
+			use_mfp = true;
 		else if (use_mfp != NL80211_MFP_NO) {
 			err = -EINVAL;
 			goto out;
 		}
 	}
 
-	err = nl80211_crypto_settings(info, &req.crypto);
+	err = nl80211_crypto_settings(info, &crypto);
 	if (!err)
-		err = drv->ops->assoc(&drv->wiphy, dev, &req);
+		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid, ssid,
+					  ssid_len, ie, ie_len, use_mfp,
+					  &crypto);
 
 out:
-	cfg80211_put_dev(drv);
+	cfg80211_put_dev(rdev);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
@@ -3266,9 +3264,9 @@ static int nl80211_deauthenticate(struct
 {
 	struct cfg80211_registered_device *drv;
 	struct net_device *dev;
-	struct cfg80211_deauth_request req;
-	struct wiphy *wiphy;
-	int err;
+	const u8 *ie = NULL, *bssid;
+	int err, ie_len = 0;
+	u16 reason_code;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
@@ -3300,24 +3298,21 @@ static int nl80211_deauthenticate(struct
 		goto out;
 	}
 
-	wiphy = &drv->wiphy;
-	memset(&req, 0, sizeof(req));
-
-	req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-	req.reason_code = nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
-	if (req.reason_code == 0) {
+	reason_code = nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
+	if (reason_code == 0) {
 		/* Reason Code 0 is reserved */
 		err = -EINVAL;
 		goto out;
 	}
 
 	if (info->attrs[NL80211_ATTR_IE]) {
-		req.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
-		req.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+		ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	err = drv->ops->deauth(&drv->wiphy, dev, &req);
+	err = cfg80211_mlme_deauth(drv, dev, bssid, ie, ie_len, reason_code);
 
 out:
 	cfg80211_put_dev(drv);
@@ -3331,9 +3326,9 @@ static int nl80211_disassociate(struct s
 {
 	struct cfg80211_registered_device *drv;
 	struct net_device *dev;
-	struct cfg80211_disassoc_request req;
-	struct wiphy *wiphy;
-	int err;
+	const u8 *ie = NULL, *bssid;
+	int err, ie_len = 0;
+	u16 reason_code;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
@@ -3365,24 +3360,21 @@ static int nl80211_disassociate(struct s
 		goto out;
 	}
 
-	wiphy = &drv->wiphy;
-	memset(&req, 0, sizeof(req));
-
-	req.peer_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-	req.reason_code = nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
-	if (req.reason_code == 0) {
+	reason_code = nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
+	if (reason_code == 0) {
 		/* Reason Code 0 is reserved */
 		err = -EINVAL;
 		goto out;
 	}
 
 	if (info->attrs[NL80211_ATTR_IE]) {
-		req.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
-		req.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+		ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	err = drv->ops->disassoc(&drv->wiphy, dev, &req);
+	err = cfg80211_mlme_disassoc(drv, dev, bssid, ie, ie_len, reason_code);
 
 out:
 	cfg80211_put_dev(drv);
--- wireless-testing.orig/net/wireless/scan.c	2009-07-02 17:13:46.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-07-02 17:17:11.000000000 +0200
@@ -70,6 +70,8 @@ static void bss_release(struct kref *ref
 	if (bss->ies_allocated)
 		kfree(bss->pub.information_elements);
 
+	BUG_ON(atomic_read(&bss->hold));
+
 	kfree(bss);
 }
 
@@ -92,8 +94,9 @@ void cfg80211_bss_expire(struct cfg80211
 	bool expired = false;
 
 	list_for_each_entry_safe(bss, tmp, &dev->bss_list, list) {
-		if (bss->hold ||
-		    !time_after(jiffies, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE))
+		if (atomic_read(&bss->hold))
+			continue;
+		if (!time_after(jiffies, bss->ts + IEEE80211_SCAN_RESULT_EXPIRE))
 			continue;
 		list_del(&bss->list);
 		rb_erase(&bss->rbn, &dev->bss_tree);
@@ -553,30 +556,6 @@ void cfg80211_unlink_bss(struct wiphy *w
 }
 EXPORT_SYMBOL(cfg80211_unlink_bss);
 
-void cfg80211_hold_bss(struct cfg80211_bss *pub)
-{
-	struct cfg80211_internal_bss *bss;
-
-	if (!pub)
-		return;
-
-	bss = container_of(pub, struct cfg80211_internal_bss, pub);
-	bss->hold = true;
-}
-EXPORT_SYMBOL(cfg80211_hold_bss);
-
-void cfg80211_unhold_bss(struct cfg80211_bss *pub)
-{
-	struct cfg80211_internal_bss *bss;
-
-	if (!pub)
-		return;
-
-	bss = container_of(pub, struct cfg80211_internal_bss, pub);
-	bss->hold = false;
-}
-EXPORT_SYMBOL(cfg80211_unhold_bss);
-
 #ifdef CONFIG_WIRELESS_EXT
 int cfg80211_wext_siwscan(struct net_device *dev,
 			  struct iw_request_info *info,
--- wireless-testing.orig/net/wireless/ibss.c	2009-07-02 17:13:46.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-07-02 17:17:11.000000000 +0200
@@ -33,11 +33,11 @@ void cfg80211_ibss_joined(struct net_dev
 
 	if (wdev->current_bss) {
 		cfg80211_unhold_bss(wdev->current_bss);
-		cfg80211_put_bss(wdev->current_bss);
+		cfg80211_put_bss(&wdev->current_bss->pub);
 	}
 
-	cfg80211_hold_bss(bss);
-	wdev->current_bss = bss;
+	cfg80211_hold_bss(bss_from_pub(bss));
+	wdev->current_bss = bss_from_pub(bss);
 
 	nl80211_send_ibss_bssid(wiphy_to_dev(wdev->wiphy), dev, bssid, gfp);
 #ifdef CONFIG_WIRELESS_EXT
@@ -78,7 +78,7 @@ void cfg80211_clear_ibss(struct net_devi
 
 	if (wdev->current_bss) {
 		cfg80211_unhold_bss(wdev->current_bss);
-		cfg80211_put_bss(wdev->current_bss);
+		cfg80211_put_bss(&wdev->current_bss->pub);
 	}
 
 	wdev->current_bss = NULL;
@@ -212,7 +212,7 @@ int cfg80211_ibss_wext_giwfreq(struct ne
 		return -EINVAL;
 
 	if (wdev->current_bss)
-		chan = wdev->current_bss->channel;
+		chan = wdev->current_bss->pub.channel;
 	else if (wdev->wext.ibss.channel)
 		chan = wdev->wext.ibss.channel;
 
@@ -352,7 +352,7 @@ int cfg80211_ibss_wext_giwap(struct net_
 	ap_addr->sa_family = ARPHRD_ETHER;
 
 	if (wdev->current_bss)
-		memcpy(ap_addr->sa_data, wdev->current_bss->bssid, ETH_ALEN);
+		memcpy(ap_addr->sa_data, wdev->current_bss->pub.bssid, ETH_ALEN);
 	else
 		memcpy(ap_addr->sa_data, wdev->wext.ibss.bssid, ETH_ALEN);
 	return 0;
--- wireless-testing.orig/net/wireless/sme.c	2009-07-02 17:13:46.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-07-02 17:17:11.000000000 +0200
@@ -103,44 +103,37 @@ static int cfg80211_conn_scan(struct wir
 static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 {
 	struct cfg80211_registered_device *drv = wiphy_to_dev(wdev->wiphy);
-	union {
-		struct cfg80211_auth_request auth_req;
-		struct cfg80211_assoc_request assoc_req;
-	} u;
-
-	memset(&u, 0, sizeof(u));
+	struct cfg80211_connect_params *params;
+	int err;
 
 	if (!wdev->conn)
 		return 0;
 
+	params = &wdev->conn->params;
+
 	switch (wdev->conn->state) {
 	case CFG80211_CONN_SCAN_AGAIN:
 		return cfg80211_conn_scan(wdev);
 	case CFG80211_CONN_AUTHENTICATE_NEXT:
-		u.auth_req.chan = wdev->conn->params.channel;
-		u.auth_req.peer_addr = wdev->conn->params.bssid;
-		u.auth_req.ssid = wdev->conn->params.ssid;
-		u.auth_req.ssid_len = wdev->conn->params.ssid_len;
-		u.auth_req.auth_type = wdev->conn->params.auth_type;
-		u.auth_req.ie = NULL;
-		u.auth_req.ie_len = 0;
-		wdev->conn->state = CFG80211_CONN_AUTHENTICATING;
 		BUG_ON(!drv->ops->auth);
-		return drv->ops->auth(wdev->wiphy, wdev->netdev, &u.auth_req);
+		wdev->conn->state = CFG80211_CONN_AUTHENTICATING;
+		return cfg80211_mlme_auth(drv, wdev->netdev,
+					  params->channel, params->auth_type,
+					  params->bssid,
+					  params->ssid, params->ssid_len,
+					  NULL, 0);
 	case CFG80211_CONN_ASSOCIATE_NEXT:
-		u.assoc_req.chan = wdev->conn->params.channel;
-		u.assoc_req.peer_addr = wdev->conn->params.bssid;
-		u.assoc_req.ssid = wdev->conn->params.ssid;
-		u.assoc_req.ssid_len = wdev->conn->params.ssid_len;
-		u.assoc_req.ie = wdev->conn->params.ie;
-		u.assoc_req.ie_len = wdev->conn->params.ie_len;
-		u.assoc_req.use_mfp = false;
-		memcpy(&u.assoc_req.crypto, &wdev->conn->params.crypto,
-			sizeof(u.assoc_req.crypto));
-		wdev->conn->state = CFG80211_CONN_ASSOCIATING;
 		BUG_ON(!drv->ops->assoc);
-		return drv->ops->assoc(wdev->wiphy, wdev->netdev,
-					&u.assoc_req);
+		wdev->conn->state = CFG80211_CONN_ASSOCIATING;
+		err = cfg80211_mlme_assoc(drv, wdev->netdev,
+					  params->channel, params->bssid,
+					  params->ssid, params->ssid_len,
+					  params->ie, params->ie_len,
+					  false, &params->crypto);
+		if (err)
+			cfg80211_mlme_deauth(drv, wdev->netdev, params->bssid,
+					     NULL, 0, WLAN_REASON_DEAUTH_LEAVING);
+		return err;
 	default:
 		return 0;
 	}
@@ -186,7 +179,6 @@ static bool cfg80211_get_conn_bss(struct
 			       wdev->conn->params.ssid_len,
 			       WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_PRIVACY,
 			       capa);
-
 	if (!bss)
 		return false;
 
@@ -264,9 +256,11 @@ void cfg80211_sme_rx_auth(struct net_dev
 		}
 		wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
 		schedule_work(&rdev->conn_work);
-	} else if (status_code != WLAN_STATUS_SUCCESS)
+	} else if (status_code != WLAN_STATUS_SUCCESS) {
 		wdev->sme_state = CFG80211_SME_IDLE;
-	else if (wdev->sme_state == CFG80211_SME_CONNECTING &&
+		kfree(wdev->conn);
+		wdev->conn = NULL;
+	} else if (wdev->sme_state == CFG80211_SME_CONNECTING &&
 		 wdev->conn->state == CFG80211_CONN_AUTHENTICATING) {
 		wdev->conn->state = CFG80211_CONN_ASSOCIATE_NEXT;
 		schedule_work(&rdev->conn_work);
@@ -330,10 +324,13 @@ static void __cfg80211_connect_result(st
 
 	if (wdev->current_bss) {
 		cfg80211_unhold_bss(wdev->current_bss);
-		cfg80211_put_bss(wdev->current_bss);
+		cfg80211_put_bss(&wdev->current_bss->pub);
 		wdev->current_bss = NULL;
 	}
 
+	if (wdev->conn)
+		wdev->conn->state = CFG80211_CONN_IDLE;
+
 	if (status == WLAN_STATUS_SUCCESS) {
 		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
 				       wdev->ssid, wdev->ssid_len,
@@ -343,16 +340,15 @@ static void __cfg80211_connect_result(st
 		if (WARN_ON(!bss))
 			return;
 
-		cfg80211_hold_bss(bss);
-		wdev->current_bss = bss;
+		cfg80211_hold_bss(bss_from_pub(bss));
+		wdev->current_bss = bss_from_pub(bss);
 
 		wdev->sme_state = CFG80211_SME_CONNECTED;
 	} else {
 		wdev->sme_state = CFG80211_SME_IDLE;
+		kfree(wdev->conn);
+		wdev->conn = NULL;
 	}
-
-	if (wdev->conn)
-		wdev->conn->state = CFG80211_CONN_IDLE;
 }
 
 void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
@@ -387,7 +383,7 @@ void cfg80211_roamed(struct net_device *
 	}
 
 	cfg80211_unhold_bss(wdev->current_bss);
-	cfg80211_put_bss(wdev->current_bss);
+	cfg80211_put_bss(&wdev->current_bss->pub);
 	wdev->current_bss = NULL;
 
 	bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
@@ -397,8 +393,8 @@ void cfg80211_roamed(struct net_device *
 	if (WARN_ON(!bss))
 		return;
 
-	cfg80211_hold_bss(bss);
-	wdev->current_bss = bss;
+	cfg80211_hold_bss(bss_from_pub(bss));
+	wdev->current_bss = bss_from_pub(bss);
 
 	nl80211_send_roamed(wiphy_to_dev(wdev->wiphy), dev, bssid,
 			    req_ie, req_ie_len, resp_ie, resp_ie_len, gfp);
@@ -440,7 +436,7 @@ void __cfg80211_disconnected(struct net_
 
 	if (wdev->current_bss) {
 		cfg80211_unhold_bss(wdev->current_bss);
-		cfg80211_put_bss(wdev->current_bss);
+		cfg80211_put_bss(&wdev->current_bss->pub);
 	}
 
 	wdev->current_bss = NULL;
@@ -449,6 +445,8 @@ void __cfg80211_disconnected(struct net_
 	if (wdev->conn) {
 		kfree(wdev->conn->ie);
 		wdev->conn->ie = NULL;
+		kfree(wdev->conn);
+		wdev->conn = NULL;
 	}
 
 	nl80211_send_disconnected(wiphy_to_dev(wdev->wiphy), dev,
@@ -482,12 +480,12 @@ int cfg80211_connect(struct cfg80211_reg
 		if (!rdev->ops->auth || !rdev->ops->assoc)
 			return -EOPNOTSUPP;
 
-		if (!wdev->conn) {
-			wdev->conn = kzalloc(sizeof(*wdev->conn), GFP_KERNEL);
-			if (!wdev->conn)
-				return -ENOMEM;
-		} else
-			memset(wdev->conn, 0, sizeof(*wdev->conn));
+		if (WARN_ON(wdev->conn))
+			return -EINPROGRESS;
+
+		wdev->conn = kzalloc(sizeof(*wdev->conn), GFP_KERNEL);
+		if (!wdev->conn)
+			return -ENOMEM;
 
 		/*
 		 * Copy all parameters, and treat explicitly IEs, BSSID, SSID.
@@ -502,8 +500,11 @@ int cfg80211_connect(struct cfg80211_reg
 			wdev->conn->ie = kmemdup(connect->ie, connect->ie_len,
 						GFP_KERNEL);
 			wdev->conn->params.ie = wdev->conn->ie;
-			if (!wdev->conn->ie)
+			if (!wdev->conn->ie) {
+				kfree(wdev->conn);
+				wdev->conn = NULL;
 				return -ENOMEM;
+			}
 		}
 
 		if (connect->auth_type == NL80211_AUTHTYPE_AUTOMATIC) {
@@ -543,8 +544,11 @@ int cfg80211_connect(struct cfg80211_reg
 				wdev->conn->state = CFG80211_CONN_SCAN_AGAIN;
 			}
 		}
-		if (err)
+		if (err) {
+			kfree(wdev->conn);
+			wdev->conn = NULL;
 			wdev->sme_state = CFG80211_SME_IDLE;
+		}
 
 		return err;
 	} else {
@@ -572,31 +576,27 @@ int cfg80211_disconnect(struct cfg80211_
 		return -EINVAL;
 
 	if (!rdev->ops->disconnect) {
-		struct cfg80211_deauth_request deauth;
-		u8 bssid[ETH_ALEN];
+		if (!rdev->ops->deauth)
+			return -EOPNOTSUPP;
 
-		/* internal bug. */
-		if (WARN_ON(!wdev->conn))
-			return -EINVAL;
+		/* was it connected by userspace SME? */
+		if (!wdev->conn) {
+			cfg80211_mlme_down(rdev, dev);
+			return 0;
+		}
 
 		if (wdev->sme_state == CFG80211_SME_CONNECTING &&
 		    (wdev->conn->state == CFG80211_CONN_SCANNING ||
 		     wdev->conn->state == CFG80211_CONN_SCAN_AGAIN)) {
 			wdev->sme_state = CFG80211_SME_IDLE;
+			kfree(wdev->conn);
+			wdev->conn = NULL;
 			return 0;
 		}
 
-		if (!rdev->ops->deauth)
-			return -EOPNOTSUPP;
-
-		memset(&deauth, 0, sizeof(deauth));
-
 		/* wdev->conn->params.bssid must be set if > SCANNING */
-		memcpy(bssid, wdev->conn->params.bssid, ETH_ALEN);
-		deauth.peer_addr = bssid;
-		deauth.reason_code = reason;
-
-		err = rdev->ops->deauth(&rdev->wiphy, dev, &deauth);
+		err = cfg80211_mlme_deauth(rdev, dev, wdev->conn->params.bssid,
+					   NULL, 0, reason);
 		if (err)
 			return err;
 	} else {
@@ -614,3 +614,33 @@ int cfg80211_disconnect(struct cfg80211_
 
 	return 0;
 }
+
+void cfg80211_sme_disassoc(struct net_device *dev, int idx)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	u8 bssid[ETH_ALEN];
+
+	if (!wdev->conn)
+		return;
+
+	if (wdev->conn->state == CFG80211_CONN_IDLE)
+		return;
+
+	/*
+	 * Ok, so the association was made by this SME -- we don't
+	 * want it any more so deauthenticate too.
+	 */
+
+	if (!wdev->auth_bsses[idx])
+		return;
+
+	memcpy(bssid, wdev->auth_bsses[idx]->pub.bssid, ETH_ALEN);
+	if (cfg80211_mlme_deauth(rdev, dev, bssid,
+				 NULL, 0, WLAN_REASON_DEAUTH_LEAVING)) {
+		/* whatever -- assume gone anyway */
+		cfg80211_unhold_bss(wdev->auth_bsses[idx]);
+		cfg80211_put_bss(&wdev->auth_bsses[idx]->pub);
+		wdev->auth_bsses[idx] = NULL;
+	}
+}
--- wireless-testing.orig/net/wireless/wext-sme.c	2009-07-02 17:13:46.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-07-02 17:17:11.000000000 +0200
@@ -93,7 +93,7 @@ int cfg80211_mgd_wext_giwfreq(struct net
 		return -EINVAL;
 
 	if (wdev->current_bss)
-		chan = wdev->current_bss->channel;
+		chan = wdev->current_bss->pub.channel;
 	else if (wdev->wext.connect.channel)
 		chan = wdev->wext.connect.channel;
 
@@ -244,7 +244,7 @@ int cfg80211_mgd_wext_giwap(struct net_d
 	ap_addr->sa_family = ARPHRD_ETHER;
 
 	if (wdev->current_bss)
-		memcpy(ap_addr->sa_data, wdev->current_bss->bssid, ETH_ALEN);
+		memcpy(ap_addr->sa_data, wdev->current_bss->pub.bssid, ETH_ALEN);
 	else if (wdev->wext.connect.bssid)
 		memcpy(ap_addr->sa_data, wdev->wext.connect.bssid, ETH_ALEN);
 	else
--- wireless-testing.orig/net/mac80211/cfg.c	2009-07-02 17:13:46.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-07-02 17:17:11.000000000 +0200
@@ -1173,6 +1173,7 @@ static int ieee80211_auth(struct wiphy *
 			  struct cfg80211_auth_request *req)
 {
 	struct ieee80211_sub_if_data *sdata;
+	const u8 *ssid;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -1193,15 +1194,16 @@ static int ieee80211_auth(struct wiphy *
 		return -EOPNOTSUPP;
 	}
 
-	memcpy(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN);
+	memcpy(sdata->u.mgd.bssid, req->bss->bssid, ETH_ALEN);
 
-	sdata->local->oper_channel = req->chan;
+	sdata->local->oper_channel = req->bss->channel;
 	ieee80211_hw_config(sdata->local, 0);
 
-	if (!req->ssid)
+	ssid = ieee80211_bss_get_ie(req->bss, WLAN_EID_SSID);
+	if (!ssid)
 		return -EINVAL;
-	memcpy(sdata->u.mgd.ssid, req->ssid, req->ssid_len);
-	sdata->u.mgd.ssid_len = req->ssid_len;
+	sdata->u.mgd.ssid_len = *(ssid + 1);
+	memcpy(sdata->u.mgd.ssid, ssid + 2, sdata->u.mgd.ssid_len);
 
 	kfree(sdata->u.mgd.sme_auth_ie);
 	sdata->u.mgd.sme_auth_ie = NULL;
@@ -1227,7 +1229,7 @@ static int ieee80211_assoc(struct wiphy 
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (memcmp(sdata->u.mgd.bssid, req->peer_addr, ETH_ALEN) != 0 ||
+	if (memcmp(sdata->u.mgd.bssid, req->bss->bssid, ETH_ALEN) != 0 ||
 	    !(sdata->u.mgd.flags & IEEE80211_STA_AUTHENTICATED))
 		return -ENOLINK; /* not authenticated */
 
@@ -1239,15 +1241,9 @@ static int ieee80211_assoc(struct wiphy 
 		    req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP104)
 			sdata->u.mgd.flags |= IEEE80211_STA_DISABLE_11N;
 
-	sdata->local->oper_channel = req->chan;
+	sdata->local->oper_channel = req->bss->channel;
 	ieee80211_hw_config(sdata->local, 0);
 
-	if (!req->ssid)
-		return -EINVAL;
-
-	memcpy(sdata->u.mgd.ssid, req->ssid, req->ssid_len);
-	sdata->u.mgd.ssid_len = req->ssid_len;
-
 	ret = ieee80211_sta_set_extra_ie(sdata, req->ie, req->ie_len);
 	if (ret && ret != -EALREADY)
 		return ret;
--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-02 17:16:57.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-02 17:17:11.000000000 +0200
@@ -876,8 +876,6 @@ static void ieee80211_set_associated(str
 		bss_info_changed |= ieee80211_handle_bss_capability(sdata,
 			bss->cbss.capability, bss->has_erp_value, bss->erp_value);
 
-		cfg80211_hold_bss(&bss->cbss);
-
 		ieee80211_rx_bss_put(local, bss);
 	}
 
@@ -1031,10 +1029,8 @@ static void ieee80211_set_disassoc(struc
 				   conf->channel->center_freq,
 				   ifmgd->ssid, ifmgd->ssid_len);
 
-	if (bss) {
-		cfg80211_unhold_bss(&bss->cbss);
+	if (bss)
 		ieee80211_rx_bss_put(local, bss);
-	}
 
 	if (self_disconnected) {
 		if (deauth)
--- wireless-testing.orig/net/wireless/core.c	2009-07-02 17:13:46.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-02 17:17:11.000000000 +0200
@@ -583,15 +583,12 @@ static int cfg80211_netdev_notifier_call
 #endif
 			cfg80211_disconnect(rdev, dev,
 					    WLAN_REASON_DEAUTH_LEAVING, true);
+			cfg80211_mlme_down(rdev, dev);
 			break;
 		default:
 			break;
 		}
 		break;
-	case NETDEV_DOWN:
-		kfree(wdev->conn);
-		wdev->conn = NULL;
-		break;
 	case NETDEV_UP:
 #ifdef CONFIG_WIRELESS_EXT
 		switch (wdev->iftype) {



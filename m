Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2ATM64 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 07:58:56 -0500
Message-Id: <20120120125741.388356397@sipsolutions.net> (sfid-20120120_135901_420707_8EAD52E0)
Date: Fri, 20 Jan 2012 13:55:25 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/11] cfg80211: stop tracking authenticated state
References: <20120120125516.000124996@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To track authenticated state seems to have been
a design mistake in cfg80211. It is possible to
have out of band authentication (FT), tracking
multiple authentications caused more problems
than it ever helped, and the implementation in
mac80211 is too complex.

Remove all this complexity, and let userspace
do whatever it wants to, mac80211 can deal with
that just fine. Association is still tracked of
course, but authentication no longer is. Local
auth state changes are thus no longer of value,
so ignore them completely.

This will also help implement SAE -- asking the
driver to do an authentication is now almost
equivalent to sending an authentication frame,
with the exception of shared key authentication
which is still handled completely.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 Documentation/DocBook/80211.tmpl |    1 
 include/net/cfg80211.h           |   39 +---
 net/mac80211/mlme.c              |   23 --
 net/wireless/core.h              |    9 -
 net/wireless/mlme.c              |  322 ++++++---------------------------------
 net/wireless/nl80211.c           |   18 --
 net/wireless/sme.c               |   41 ----
 7 files changed, 91 insertions(+), 362 deletions(-)

--- a/include/net/cfg80211.h	2012-01-20 13:54:09.000000000 +0100
+++ b/include/net/cfg80211.h	2012-01-20 13:54:20.000000000 +0100
@@ -1036,10 +1036,6 @@ const u8 *ieee80211_bss_get_ie(struct cf
  * @key_len: length of WEP key for shared key authentication
  * @key_idx: index of WEP key for shared key authentication
  * @key: WEP key for shared key authentication
- * @local_state_change: This is a request for a local state only, i.e., no
- *	Authentication frame is to be transmitted and authentication state is
- *	to be changed without having to wait for a response from the peer STA
- *	(AP).
  */
 struct cfg80211_auth_request {
 	struct cfg80211_bss *bss;
@@ -1048,7 +1044,6 @@ struct cfg80211_auth_request {
 	enum nl80211_auth_type auth_type;
 	const u8 *key;
 	u8 key_len, key_idx;
-	bool local_state_change;
 };
 
 /**
@@ -1065,7 +1060,11 @@ enum cfg80211_assoc_req_flags {
  *
  * This structure provides information needed to complete IEEE 802.11
  * (re)association.
- * @bss: The BSS to associate with.
+ * @bss: The BSS to associate with. If the call is successful the driver
+ *	is given a reference that it must release, normally via a call to
+ *	cfg80211_send_rx_assoc(), or, if association timed out, with a
+ *	call to cfg80211_put_bss() (in addition to calling
+ *	cfg80211_send_assoc_timeout())
  * @ie: Extra IEs to add to (Re)Association Request frame or %NULL
  * @ie_len: Length of ie buffer in octets
  * @use_mfp: Use management frame protection (IEEE 802.11w) in this association
@@ -1093,19 +1092,16 @@ struct cfg80211_assoc_request {
  * This structure provides information needed to complete IEEE 802.11
  * deauthentication.
  *
- * @bss: the BSS to deauthenticate from
+ * @bssid: the BSSID of the BSS to deauthenticate from
  * @ie: Extra IEs to add to Deauthentication frame or %NULL
  * @ie_len: Length of ie buffer in octets
  * @reason_code: The reason code for the deauthentication
- * @local_state_change: This is a request for a local state only, i.e., no
- *	Deauthentication frame is to be transmitted.
  */
 struct cfg80211_deauth_request {
-	struct cfg80211_bss *bss;
+	const u8 *bssid;
 	const u8 *ie;
 	size_t ie_len;
 	u16 reason_code;
-	bool local_state_change;
 };
 
 /**
@@ -2198,8 +2194,6 @@ struct cfg80211_conn;
 struct cfg80211_internal_bss;
 struct cfg80211_cached_keys;
 
-#define MAX_AUTH_BSSES		4
-
 /**
  * struct wireless_dev - wireless per-netdev state
  *
@@ -2263,8 +2257,6 @@ struct wireless_dev {
 	struct list_head event_list;
 	spinlock_t event_lock;
 
-	struct cfg80211_internal_bss *authtry_bsses[MAX_AUTH_BSSES];
-	struct cfg80211_internal_bss *auth_bsses[MAX_AUTH_BSSES];
 	struct cfg80211_internal_bss *current_bss; /* associated / joined */
 	struct ieee80211_channel *channel;
 
@@ -2756,20 +2748,10 @@ void cfg80211_send_rx_auth(struct net_de
 void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr);
 
 /**
- * __cfg80211_auth_canceled - notify cfg80211 that authentication was canceled
- * @dev: network device
- * @addr: The MAC address of the device with which the authentication timed out
- *
- * When a pending authentication had no action yet, the driver may decide
- * to not send a deauth frame, but in that case must calls this function
- * to tell cfg80211 about this decision. It is only valid to call this
- * function within the deauth() callback.
- */
-void __cfg80211_auth_canceled(struct net_device *dev, const u8 *addr);
-
-/**
  * cfg80211_send_rx_assoc - notification of processed association
  * @dev: network device
+ * @bss: the BSS struct association was requested for, the struct reference
+ *	is owned by cfg80211 after this call
  * @buf: (re)association response frame (header + body)
  * @len: length of the frame data
  *
@@ -2778,7 +2760,8 @@ void __cfg80211_auth_canceled(struct net
  * function or cfg80211_send_assoc_timeout() to indicate the result of
  * cfg80211_ops::assoc() call. This function may sleep.
  */
-void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len);
+void cfg80211_send_rx_assoc(struct net_device *dev, struct cfg80211_bss *bss,
+			    const u8 *buf, size_t len);
 
 /**
  * cfg80211_send_assoc_timeout - notification of timed out association
--- a/Documentation/DocBook/80211.tmpl	2012-01-20 13:54:15.000000000 +0100
+++ b/Documentation/DocBook/80211.tmpl	2012-01-20 13:54:20.000000000 +0100
@@ -144,7 +144,6 @@ MISSING
 !Finclude/net/cfg80211.h cfg80211_pmksa
 !Finclude/net/cfg80211.h cfg80211_send_rx_auth
 !Finclude/net/cfg80211.h cfg80211_send_auth_timeout
-!Finclude/net/cfg80211.h __cfg80211_auth_canceled
 !Finclude/net/cfg80211.h cfg80211_send_rx_assoc
 !Finclude/net/cfg80211.h cfg80211_send_assoc_timeout
 !Finclude/net/cfg80211.h cfg80211_send_deauth
--- a/net/mac80211/mlme.c	2012-01-20 13:54:20.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-01-20 13:54:20.000000000 +0100
@@ -2459,9 +2459,6 @@ int ieee80211_mgd_auth(struct ieee80211_
 	struct ieee80211_work *wk;
 	u16 auth_alg;
 
-	if (req->local_state_change)
-		return 0; /* no need to update mac80211 state */
-
 	switch (req->auth_type) {
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
 		auth_alg = WLAN_AUTH_OPEN;
@@ -2593,7 +2590,7 @@ static enum work_done_result ieee80211_a
 		sta_info_destroy_addr(wk->sdata, cbss->bssid);
 	}
 
-	cfg80211_send_rx_assoc(wk->sdata->dev, skb->data, skb->len);
+	cfg80211_send_rx_assoc(wk->sdata->dev, cbss, skb->data, skb->len);
  destroy:
 	if (wk->assoc.synced)
 		drv_finish_tx_sync(local, wk->sdata, wk->filter_ta,
@@ -2750,13 +2747,12 @@ int ieee80211_mgd_deauth(struct ieee8021
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	u8 bssid[ETH_ALEN];
 	bool assoc_bss = false;
 
 	mutex_lock(&ifmgd->mtx);
 
-	memcpy(bssid, req->bss->bssid, ETH_ALEN);
-	if (ifmgd->associated == req->bss) {
+	if (ifmgd->associated &&
+	    memcmp(ifmgd->associated->bssid, req->bssid, ETH_ALEN) == 0) {
 		ieee80211_set_disassoc(sdata, false, true);
 		mutex_unlock(&ifmgd->mtx);
 		assoc_bss = true;
@@ -2777,7 +2773,7 @@ int ieee80211_mgd_deauth(struct ieee8021
 			    tmp->type != IEEE80211_WORK_ASSOC_BEACON_WAIT)
 				continue;
 
-			if (memcmp(req->bss->bssid, tmp->filter_ta, ETH_ALEN))
+			if (memcmp(req->bssid, tmp->filter_ta, ETH_ALEN))
 				continue;
 
 			not_auth_yet = tmp->type == IEEE80211_WORK_DIRECT_PROBE;
@@ -2811,18 +2807,15 @@ int ieee80211_mgd_deauth(struct ieee8021
 		 * frame, and if it's IDLE we have completed the auth
 		 * process already.
 		 */
-		if (not_auth_yet) {
-			__cfg80211_auth_canceled(sdata->dev, bssid);
+		if (not_auth_yet)
 			return 0;
-		}
 	}
 
 	printk(KERN_DEBUG "%s: deauthenticating from %pM by local choice (reason=%d)\n",
-	       sdata->name, bssid, req->reason_code);
+	       sdata->name, req->bssid, req->reason_code);
 
-	ieee80211_send_deauth_disassoc(sdata, bssid, IEEE80211_STYPE_DEAUTH,
-				       req->reason_code, cookie,
-				       !req->local_state_change);
+	ieee80211_send_deauth_disassoc(sdata, req->bssid, IEEE80211_STYPE_DEAUTH,
+				       req->reason_code, cookie, true);
 	if (assoc_bss)
 		sta_info_flush(sdata->local, sdata);
 
--- a/net/wireless/core.h	2012-01-20 13:54:09.000000000 +0100
+++ b/net/wireless/core.h	2012-01-20 13:54:20.000000000 +0100
@@ -325,15 +325,13 @@ int __cfg80211_mlme_auth(struct cfg80211
 			 const u8 *bssid,
 			 const u8 *ssid, int ssid_len,
 			 const u8 *ie, int ie_len,
-			 const u8 *key, int key_len, int key_idx,
-			 bool local_state_change);
+			 const u8 *key, int key_len, int key_idx);
 int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev, struct ieee80211_channel *chan,
 		       enum nl80211_auth_type auth_type, const u8 *bssid,
 		       const u8 *ssid, int ssid_len,
 		       const u8 *ie, int ie_len,
-		       const u8 *key, int key_len, int key_idx,
-		       bool local_state_change);
+		       const u8 *key, int key_len, int key_idx);
 int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev,
 			  struct ieee80211_channel *chan,
@@ -421,7 +419,8 @@ void __cfg80211_disconnected(struct net_
 			     size_t ie_len, u16 reason, bool from_ap);
 void cfg80211_sme_scan_done(struct net_device *dev);
 void cfg80211_sme_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
-void cfg80211_sme_disassoc(struct net_device *dev, int idx);
+void cfg80211_sme_disassoc(struct net_device *dev,
+			   struct cfg80211_internal_bss *bss);
 void __cfg80211_scan_done(struct work_struct *wk);
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak);
 void __cfg80211_sched_scan_results(struct work_struct *wk);
--- a/net/wireless/mlme.c	2012-01-20 13:54:09.000000000 +0100
+++ b/net/wireless/mlme.c	2012-01-20 13:54:20.000000000 +0100
@@ -20,40 +20,18 @@ void cfg80211_send_rx_auth(struct net_de
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
-	u8 *bssid = mgmt->bssid;
-	int i;
-	u16 status = le16_to_cpu(mgmt->u.auth.status_code);
-	bool done = false;
 
 	wdev_lock(wdev);
 
-	for (i = 0; i < MAX_AUTH_BSSES; i++) {
-		if (wdev->authtry_bsses[i] &&
-		    memcmp(wdev->authtry_bsses[i]->pub.bssid, bssid,
-							ETH_ALEN) == 0) {
-			if (status == WLAN_STATUS_SUCCESS) {
-				wdev->auth_bsses[i] = wdev->authtry_bsses[i];
-			} else {
-				cfg80211_unhold_bss(wdev->authtry_bsses[i]);
-				cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
-			}
-			wdev->authtry_bsses[i] = NULL;
-			done = true;
-			break;
-		}
-	}
-
-	if (done) {
-		nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
-		cfg80211_sme_rx_auth(dev, buf, len);
-	}
+	nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
+	cfg80211_sme_rx_auth(dev, buf, len);
 
 	wdev_unlock(wdev);
 }
 EXPORT_SYMBOL(cfg80211_send_rx_auth);
 
-void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len)
+void cfg80211_send_rx_assoc(struct net_device *dev, struct cfg80211_bss *bss,
+			    const u8 *buf, size_t len)
 {
 	u16 status_code;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
@@ -61,8 +39,7 @@ void cfg80211_send_rx_assoc(struct net_d
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
 	u8 *ie = mgmt->u.assoc_resp.variable;
-	int i, ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
-	struct cfg80211_internal_bss *bss = NULL;
+	int ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
 
 	wdev_lock(wdev);
 
@@ -75,43 +52,20 @@ void cfg80211_send_rx_assoc(struct net_d
 	 * frame instead of reassoc.
 	 */
 	if (status_code != WLAN_STATUS_SUCCESS && wdev->conn &&
-	    cfg80211_sme_failed_reassoc(wdev))
+	    cfg80211_sme_failed_reassoc(wdev)) {
+		cfg80211_put_bss(bss);
 		goto out;
+	}
 
 	nl80211_send_rx_assoc(rdev, dev, buf, len, GFP_KERNEL);
 
-	if (status_code == WLAN_STATUS_SUCCESS) {
-		for (i = 0; i < MAX_AUTH_BSSES; i++) {
-			if (!wdev->auth_bsses[i])
-				continue;
-			if (memcmp(wdev->auth_bsses[i]->pub.bssid, mgmt->bssid,
-				   ETH_ALEN) == 0) {
-				bss = wdev->auth_bsses[i];
-				wdev->auth_bsses[i] = NULL;
-				/* additional reference to drop hold */
-				cfg80211_ref_bss(bss);
-				break;
-			}
-		}
-
-		/*
-		 * We might be coming here because the driver reported
-		 * a successful association at the same time as the
-		 * user requested a deauth. In that case, we will have
-		 * removed the BSS from the auth_bsses list due to the
-		 * deauth request when the assoc response makes it. If
-		 * the two code paths acquire the lock the other way
-		 * around, that's just the standard situation of a
-		 * deauth being requested while connected.
-		 */
-		if (!bss)
-			goto out;
-	} else if (wdev->conn) {
+	if (status_code != WLAN_STATUS_SUCCESS && wdev->conn) {
 		cfg80211_sme_failed_assoc(wdev);
 		/*
 		 * do not call connect_result() now because the
 		 * sme will schedule work that does it later.
 		 */
+		cfg80211_put_bss(bss);
 		goto out;
 	}
 
@@ -124,17 +78,10 @@ void cfg80211_send_rx_assoc(struct net_d
 		wdev->sme_state = CFG80211_SME_CONNECTING;
 	}
 
-	/* this consumes one bss reference (unless bss is NULL) */
+	/* this consumes the bss reference */
 	__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, ie, len - ieoffs,
 				  status_code,
-				  status_code == WLAN_STATUS_SUCCESS,
-				  bss ? &bss->pub : NULL);
-	/* drop hold now, and also reference acquired above */
-	if (bss) {
-		cfg80211_unhold_bss(bss);
-		cfg80211_put_bss(&bss->pub);
-	}
-
+				  status_code == WLAN_STATUS_SUCCESS, bss);
  out:
 	wdev_unlock(wdev);
 }
@@ -148,8 +95,7 @@ void __cfg80211_send_deauth(struct net_d
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
 	const u8 *bssid = mgmt->bssid;
-	int i;
-	bool found = false, was_current = false;
+	bool was_current = false;
 
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -158,32 +104,9 @@ void __cfg80211_send_deauth(struct net_d
 		cfg80211_unhold_bss(wdev->current_bss);
 		cfg80211_put_bss(&wdev->current_bss->pub);
 		wdev->current_bss = NULL;
-		found = true;
 		was_current = true;
-	} else for (i = 0; i < MAX_AUTH_BSSES; i++) {
-		if (wdev->auth_bsses[i] &&
-		    memcmp(wdev->auth_bsses[i]->pub.bssid, bssid, ETH_ALEN) == 0) {
-			cfg80211_unhold_bss(wdev->auth_bsses[i]);
-			cfg80211_put_bss(&wdev->auth_bsses[i]->pub);
-			wdev->auth_bsses[i] = NULL;
-			found = true;
-			break;
-		}
-		if (wdev->authtry_bsses[i] &&
-		    memcmp(wdev->authtry_bsses[i]->pub.bssid, bssid,
-			   ETH_ALEN) == 0 &&
-		    memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) == 0) {
-			cfg80211_unhold_bss(wdev->authtry_bsses[i]);
-			cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
-			wdev->authtry_bsses[i] = NULL;
-			found = true;
-			break;
-		}
 	}
 
-	if (!found)
-		return;
-
 	nl80211_send_deauth(rdev, dev, buf, len, GFP_KERNEL);
 
 	if (wdev->sme_state == CFG80211_SME_CONNECTED && was_current) {
@@ -220,10 +143,8 @@ void __cfg80211_send_disassoc(struct net
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
 	const u8 *bssid = mgmt->bssid;
-	int i;
 	u16 reason_code;
 	bool from_ap;
-	bool done = false;
 
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -234,16 +155,10 @@ void __cfg80211_send_disassoc(struct net
 
 	if (wdev->current_bss &&
 	    memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) == 0) {
-		for (i = 0; i < MAX_AUTH_BSSES; i++) {
-			if (wdev->authtry_bsses[i] || wdev->auth_bsses[i])
-				continue;
-			wdev->auth_bsses[i] = wdev->current_bss;
-			wdev->current_bss = NULL;
-			done = true;
-			cfg80211_sme_disassoc(dev, i);
-			break;
-		}
-		WARN_ON(!done);
+		cfg80211_sme_disassoc(dev, wdev->current_bss);
+		cfg80211_unhold_bss(wdev->current_bss);
+		cfg80211_put_bss(&wdev->current_bss->pub);
+		wdev->current_bss = NULL;
 	} else
 		WARN_ON(1);
 
@@ -287,34 +202,6 @@ void cfg80211_send_unprot_disassoc(struc
 }
 EXPORT_SYMBOL(cfg80211_send_unprot_disassoc);
 
-static void __cfg80211_auth_remove(struct wireless_dev *wdev, const u8 *addr)
-{
-	int i;
-	bool done = false;
-
-	ASSERT_WDEV_LOCK(wdev);
-
-	for (i = 0; addr && i < MAX_AUTH_BSSES; i++) {
-		if (wdev->authtry_bsses[i] &&
-		    memcmp(wdev->authtry_bsses[i]->pub.bssid,
-			   addr, ETH_ALEN) == 0) {
-			cfg80211_unhold_bss(wdev->authtry_bsses[i]);
-			cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
-			wdev->authtry_bsses[i] = NULL;
-			done = true;
-			break;
-		}
-	}
-
-	WARN_ON(!done);
-}
-
-void __cfg80211_auth_canceled(struct net_device *dev, const u8 *addr)
-{
-	__cfg80211_auth_remove(dev->ieee80211_ptr, addr);
-}
-EXPORT_SYMBOL(__cfg80211_auth_canceled);
-
 void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
@@ -329,8 +216,6 @@ void cfg80211_send_auth_timeout(struct n
 					  WLAN_STATUS_UNSPECIFIED_FAILURE,
 					  false, NULL);
 
-	__cfg80211_auth_remove(wdev, addr);
-
 	wdev_unlock(wdev);
 }
 EXPORT_SYMBOL(cfg80211_send_auth_timeout);
@@ -340,8 +225,6 @@ void cfg80211_send_assoc_timeout(struct
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-	int i;
-	bool done = false;
 
 	wdev_lock(wdev);
 
@@ -351,20 +234,6 @@ void cfg80211_send_assoc_timeout(struct
 					  WLAN_STATUS_UNSPECIFIED_FAILURE,
 					  false, NULL);
 
-	for (i = 0; addr && i < MAX_AUTH_BSSES; i++) {
-		if (wdev->auth_bsses[i] &&
-		    memcmp(wdev->auth_bsses[i]->pub.bssid,
-			   addr, ETH_ALEN) == 0) {
-			cfg80211_unhold_bss(wdev->auth_bsses[i]);
-			cfg80211_put_bss(&wdev->auth_bsses[i]->pub);
-			wdev->auth_bsses[i] = NULL;
-			done = true;
-			break;
-		}
-	}
-
-	WARN_ON(!done);
-
 	wdev_unlock(wdev);
 }
 EXPORT_SYMBOL(cfg80211_send_assoc_timeout);
@@ -403,13 +272,11 @@ int __cfg80211_mlme_auth(struct cfg80211
 			 const u8 *bssid,
 			 const u8 *ssid, int ssid_len,
 			 const u8 *ie, int ie_len,
-			 const u8 *key, int key_len, int key_idx,
-			 bool local_state_change)
+			 const u8 *key, int key_len, int key_idx)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_auth_request req;
-	struct cfg80211_internal_bss *bss;
-	int i, err, slot = -1, nfree = 0;
+	int err;
 
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -421,20 +288,8 @@ int __cfg80211_mlme_auth(struct cfg80211
 	    memcmp(bssid, wdev->current_bss->pub.bssid, ETH_ALEN) == 0)
 		return -EALREADY;
 
-	for (i = 0; i < MAX_AUTH_BSSES; i++) {
-		if (wdev->authtry_bsses[i] &&
-		    memcmp(bssid, wdev->authtry_bsses[i]->pub.bssid,
-						ETH_ALEN) == 0)
-			return -EALREADY;
-		if (wdev->auth_bsses[i] &&
-		    memcmp(bssid, wdev->auth_bsses[i]->pub.bssid,
-						ETH_ALEN) == 0)
-			return -EALREADY;
-	}
-
 	memset(&req, 0, sizeof(req));
 
-	req.local_state_change = local_state_change;
 	req.ie = ie;
 	req.ie_len = ie_len;
 	req.auth_type = auth_type;
@@ -446,39 +301,9 @@ int __cfg80211_mlme_auth(struct cfg80211
 	if (!req.bss)
 		return -ENOENT;
 
-	bss = bss_from_pub(req.bss);
-
-	for (i = 0; i < MAX_AUTH_BSSES; i++) {
-		if (!wdev->auth_bsses[i] && !wdev->authtry_bsses[i]) {
-			slot = i;
-			nfree++;
-		}
-	}
-
-	/* we need one free slot for disassoc and one for this auth */
-	if (nfree < 2) {
-		err = -ENOSPC;
-		goto out;
-	}
-
-	if (local_state_change)
-		wdev->auth_bsses[slot] = bss;
-	else
-		wdev->authtry_bsses[slot] = bss;
-	cfg80211_hold_bss(bss);
-
 	err = rdev->ops->auth(&rdev->wiphy, dev, &req);
-	if (err) {
-		if (local_state_change)
-			wdev->auth_bsses[slot] = NULL;
-		else
-			wdev->authtry_bsses[slot] = NULL;
-		cfg80211_unhold_bss(bss);
-	}
 
- out:
-	if (err)
-		cfg80211_put_bss(req.bss);
+	cfg80211_put_bss(req.bss);
 	return err;
 }
 
@@ -487,15 +312,14 @@ int cfg80211_mlme_auth(struct cfg80211_r
 		       enum nl80211_auth_type auth_type, const u8 *bssid,
 		       const u8 *ssid, int ssid_len,
 		       const u8 *ie, int ie_len,
-		       const u8 *key, int key_len, int key_idx,
-		       bool local_state_change)
+		       const u8 *key, int key_len, int key_idx)
 {
 	int err;
 
 	wdev_lock(dev->ieee80211_ptr);
 	err = __cfg80211_mlme_auth(rdev, dev, chan, auth_type, bssid,
 				   ssid, ssid_len, ie, ie_len,
-				   key, key_len, key_idx, local_state_change);
+				   key, key_len, key_idx);
 	wdev_unlock(dev->ieee80211_ptr);
 
 	return err;
@@ -530,8 +354,7 @@ int __cfg80211_mlme_assoc(struct cfg8021
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_assoc_request req;
-	struct cfg80211_internal_bss *bss;
-	int i, err, slot = -1;
+	int err;
 	bool was_connected = false;
 
 	ASSERT_WDEV_LOCK(wdev);
@@ -573,26 +396,14 @@ int __cfg80211_mlme_assoc(struct cfg8021
 		return -ENOENT;
 	}
 
-	bss = bss_from_pub(req.bss);
-
-	for (i = 0; i < MAX_AUTH_BSSES; i++) {
-		if (bss == wdev->auth_bsses[i]) {
-			slot = i;
-			break;
-		}
-	}
+	err = rdev->ops->assoc(&rdev->wiphy, dev, &req);
 
-	if (slot < 0) {
-		err = -ENOTCONN;
-		goto out;
+	if (err) {
+		if (was_connected)
+			wdev->sme_state = CFG80211_SME_CONNECTED;
+		cfg80211_put_bss(req.bss);
 	}
 
-	err = rdev->ops->assoc(&rdev->wiphy, dev, &req);
- out:
-	if (err && was_connected)
-		wdev->sme_state = CFG80211_SME_CONNECTED;
-	/* still a reference in wdev->auth_bsses[slot] */
-	cfg80211_put_bss(req.bss);
 	return err;
 }
 
@@ -624,34 +435,25 @@ int __cfg80211_mlme_deauth(struct cfg802
 			   bool local_state_change)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_deauth_request req;
-	int i;
+	struct cfg80211_deauth_request req = {
+		.bssid = bssid,
+		.reason_code = reason,
+		.ie = ie,
+		.ie_len = ie_len,
+	};
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	memset(&req, 0, sizeof(req));
-	req.reason_code = reason;
-	req.local_state_change = local_state_change;
-	req.ie = ie;
-	req.ie_len = ie_len;
-	if (wdev->current_bss &&
-	    memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) == 0) {
-		req.bss = &wdev->current_bss->pub;
-	} else for (i = 0; i < MAX_AUTH_BSSES; i++) {
-		if (wdev->auth_bsses[i] &&
-		    memcmp(bssid, wdev->auth_bsses[i]->pub.bssid, ETH_ALEN) == 0) {
-			req.bss = &wdev->auth_bsses[i]->pub;
-			break;
-		}
-		if (wdev->authtry_bsses[i] &&
-		    memcmp(bssid, wdev->authtry_bsses[i]->pub.bssid, ETH_ALEN) == 0) {
-			req.bss = &wdev->authtry_bsses[i]->pub;
-			break;
+	if (local_state_change) {
+		if (wdev->current_bss &&
+		    memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) == 0) {
+			cfg80211_unhold_bss(wdev->current_bss);
+			cfg80211_put_bss(&wdev->current_bss->pub);
+			wdev->current_bss = NULL;
 		}
-	}
 
-	if (!req.bss)
-		return -ENOTCONN;
+		return 0;
+	}
 
 	return rdev->ops->deauth(&rdev->wiphy, dev, &req, wdev);
 }
@@ -722,7 +524,7 @@ void cfg80211_mlme_down(struct cfg80211_
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_deauth_request req;
-	int i;
+	u8 bssid[ETH_ALEN];
 
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -734,35 +536,17 @@ void cfg80211_mlme_down(struct cfg80211_
 	req.ie = NULL;
 	req.ie_len = 0;
 
-	if (wdev->current_bss) {
-		req.bss = &wdev->current_bss->pub;
-		rdev->ops->deauth(&rdev->wiphy, dev, &req, wdev);
-		if (wdev->current_bss) {
-			cfg80211_unhold_bss(wdev->current_bss);
-			cfg80211_put_bss(&wdev->current_bss->pub);
-			wdev->current_bss = NULL;
-		}
-	}
+	if (!wdev->current_bss)
+		return;
 
-	for (i = 0; i < MAX_AUTH_BSSES; i++) {
-		if (wdev->auth_bsses[i]) {
-			req.bss = &wdev->auth_bsses[i]->pub;
-			rdev->ops->deauth(&rdev->wiphy, dev, &req, wdev);
-			if (wdev->auth_bsses[i]) {
-				cfg80211_unhold_bss(wdev->auth_bsses[i]);
-				cfg80211_put_bss(&wdev->auth_bsses[i]->pub);
-				wdev->auth_bsses[i] = NULL;
-			}
-		}
-		if (wdev->authtry_bsses[i]) {
-			req.bss = &wdev->authtry_bsses[i]->pub;
-			rdev->ops->deauth(&rdev->wiphy, dev, &req, wdev);
-			if (wdev->authtry_bsses[i]) {
-				cfg80211_unhold_bss(wdev->authtry_bsses[i]);
-				cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
-				wdev->authtry_bsses[i] = NULL;
-			}
-		}
+	memcpy(bssid, wdev->current_bss->pub.bssid, ETH_ALEN);
+	req.bssid = bssid;
+	rdev->ops->deauth(&rdev->wiphy, dev, &req, wdev);
+
+	if (wdev->current_bss) {
+		cfg80211_unhold_bss(wdev->current_bss);
+		cfg80211_put_bss(&wdev->current_bss->pub);
+		wdev->current_bss = NULL;
 	}
 }
 
--- a/net/wireless/nl80211.c	2012-01-20 13:54:18.000000000 +0100
+++ b/net/wireless/nl80211.c	2012-01-20 13:54:20.000000000 +0100
@@ -4078,7 +4078,6 @@ static int nl80211_send_bss(struct sk_bu
 	struct cfg80211_bss *res = &intbss->pub;
 	void *hdr;
 	struct nlattr *bss;
-	int i;
 
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -4131,13 +4130,6 @@ static int nl80211_send_bss(struct sk_bu
 		if (intbss == wdev->current_bss)
 			NLA_PUT_U32(msg, NL80211_BSS_STATUS,
 				    NL80211_BSS_STATUS_ASSOCIATED);
-		else for (i = 0; i < MAX_AUTH_BSSES; i++) {
-			if (intbss != wdev->auth_bsses[i])
-				continue;
-			NLA_PUT_U32(msg, NL80211_BSS_STATUS,
-				    NL80211_BSS_STATUS_AUTHENTICATED);
-			break;
-		}
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		if (intbss == wdev->current_bss)
@@ -4405,10 +4397,16 @@ static int nl80211_authenticate(struct s
 
 	local_state_change = !!info->attrs[NL80211_ATTR_LOCAL_STATE_CHANGE];
 
+	/*
+	 * Since we no longer track auth state, ignore
+	 * requests to only change local state.
+	 */
+	if (local_state_change)
+		return 0;
+
 	return cfg80211_mlme_auth(rdev, dev, chan, auth_type, bssid,
 				  ssid, ssid_len, ie, ie_len,
-				  key.p.key, key.p.key_len, key.idx,
-				  local_state_change);
+				  key.p.key, key.p.key_len, key.idx);
 }
 
 static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
--- a/net/wireless/sme.c	2012-01-20 13:54:09.000000000 +0100
+++ b/net/wireless/sme.c	2012-01-20 13:54:20.000000000 +0100
@@ -179,7 +179,7 @@ static int cfg80211_conn_do_work(struct
 					    params->ssid, params->ssid_len,
 					    NULL, 0,
 					    params->key, params->key_len,
-					    params->key_idx, false);
+					    params->key_idx);
 	case CFG80211_CONN_ASSOCIATE_NEXT:
 		BUG_ON(!rdev->ops->assoc);
 		wdev->conn->state = CFG80211_CONN_ASSOCIATING;
@@ -477,6 +477,7 @@ void __cfg80211_connect_result(struct ne
 		kfree(wdev->connect_keys);
 		wdev->connect_keys = NULL;
 		wdev->ssid_len = 0;
+		cfg80211_put_bss(bss);
 		return;
 	}
 
@@ -701,31 +702,10 @@ void __cfg80211_disconnected(struct net_
 	wdev->ssid_len = 0;
 
 	if (wdev->conn) {
-		const u8 *bssid;
-		int ret;
-
 		kfree(wdev->conn->ie);
 		wdev->conn->ie = NULL;
 		kfree(wdev->conn);
 		wdev->conn = NULL;
-
-		/*
-		 * If this disconnect was due to a disassoc, we
-		 * we might still have an auth BSS around. For
-		 * the userspace SME that's currently expected,
-		 * but for the kernel SME (nl80211 CONNECT or
-		 * wireless extensions) we want to clear up all
-		 * state.
-		 */
-		for (i = 0; i < MAX_AUTH_BSSES; i++) {
-			if (!wdev->auth_bsses[i])
-				continue;
-			bssid = wdev->auth_bsses[i]->pub.bssid;
-			ret = __cfg80211_mlme_deauth(rdev, dev, bssid, NULL, 0,
-						WLAN_REASON_DEAUTH_LEAVING,
-						false);
-			WARN(ret, "deauth failed: %d\n", ret);
-		}
 	}
 
 	nl80211_send_disconnected(rdev, dev, reason, ie, ie_len, from_ap);
@@ -1012,7 +992,8 @@ int cfg80211_disconnect(struct cfg80211_
 	return err;
 }
 
-void cfg80211_sme_disassoc(struct net_device *dev, int idx)
+void cfg80211_sme_disassoc(struct net_device *dev,
+			   struct cfg80211_internal_bss *bss)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -1031,16 +1012,8 @@ void cfg80211_sme_disassoc(struct net_de
 	 * want it any more so deauthenticate too.
 	 */
 
-	if (!wdev->auth_bsses[idx])
-		return;
+	memcpy(bssid, bss->pub.bssid, ETH_ALEN);
 
-	memcpy(bssid, wdev->auth_bsses[idx]->pub.bssid, ETH_ALEN);
-	if (__cfg80211_mlme_deauth(rdev, dev, bssid,
-				   NULL, 0, WLAN_REASON_DEAUTH_LEAVING,
-				   false)) {
-		/* whatever -- assume gone anyway */
-		cfg80211_unhold_bss(wdev->auth_bsses[idx]);
-		cfg80211_put_bss(&wdev->auth_bsses[idx]->pub);
-		wdev->auth_bsses[idx] = NULL;
-	}
+	__cfg80211_mlme_deauth(rdev, dev, bssid, NULL, 0,
+			       WLAN_REASON_DEAUTH_LEAVING, false);
 }



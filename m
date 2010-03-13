Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54714 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218Ab0CMTxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 14:53:43 -0500
Date: Sat, 13 Mar 2010 21:53:35 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] cfg80211: Add local-state-change-only auth/deauth/disassoc
Message-ID: <20100313195335.GA2420@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 is quite strict on allowing authentication and association
commands only in certain states. In order to meet these requirements,
user space applications may need to clear authentication or
association state in some cases. Currently, this can be done with
deauth/disassoc command, but that ends up sending out Deauthentication
or Disassociation frame unnecessarily. Add a new nl80211 attribute to
allow this sending of the frame be skipped, but with all other
deauth/disassoc operations being completed.

Similar state change is also needed for IEEE 802.11r FT protocol in
the FT-over-DS case which does not use Authentication frame exchange
in a transition to another BSS. For this to work with cfg80211, an
authentication entry needs to be created for the target BSS without
sending out an Authentication frame. The nl80211 authentication
command can be used for this purpose, too, with the new attribute to
indicate that the command is only for changing local state. This
enables wpa_supplicant to complete FT-over-DS transition successfully.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 include/linux/nl80211.h |    8 ++++++++
 include/net/cfg80211.h  |   11 +++++++++++
 net/mac80211/mlme.c     |   21 ++++++++++++++-------
 net/wireless/core.h     |   15 ++++++++++-----
 net/wireless/nl80211.c  |   19 ++++++++++++++++---
 net/wireless/sme.c      |   15 +++++++++------
 6 files changed, 68 insertions(+), 21 deletions(-)

--- uml.orig/include/linux/nl80211.h	2010-03-13 17:17:56.000000000 +0200
+++ uml/include/linux/nl80211.h	2010-03-13 17:20:37.000000000 +0200
@@ -691,6 +691,12 @@ enum nl80211_commands {
  * @NL80211_ATTR_ACK: Flag attribute indicating that the frame was
  *	acknowledged by the recipient.
  *
+ * @NL80211_ATTR_LOCAL_STATE_CHANGE: Flag attribute to indicate that a command
+ *	is requesting a local authentication/association state change without
+ *	invoking actual management frame exchange. This can be used with
+ *	NL80211_CMD_AUTHENTICATE, NL80211_CMD_DEAUTHENTICATE,
+ *	NL80211_CMD_DISASSOCIATE.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -842,6 +848,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PS_STATE,
 
+	NL80211_ATTR_LOCAL_STATE_CHANGE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- uml.orig/include/net/cfg80211.h	2010-03-13 17:29:50.000000000 +0200
+++ uml/include/net/cfg80211.h	2010-03-13 17:32:40.000000000 +0200
@@ -704,6 +704,10 @@ struct cfg80211_crypto_settings {
  * @key_len: length of WEP key for shared key authentication
  * @key_idx: index of WEP key for shared key authentication
  * @key: WEP key for shared key authentication
+ * @local_state_change: This is a request for a local state only, i.e., no
+ *	Authentication frame is to be transmitted and authentication state is
+ *	to be changed without having to wait for a response from the peer STA
+ *	(AP).
  */
 struct cfg80211_auth_request {
 	struct cfg80211_bss *bss;
@@ -712,6 +716,7 @@ struct cfg80211_auth_request {
 	enum nl80211_auth_type auth_type;
 	const u8 *key;
 	u8 key_len, key_idx;
+	bool local_state_change;
 };
 
 /**
@@ -744,12 +749,15 @@ struct cfg80211_assoc_request {
  * @ie: Extra IEs to add to Deauthentication frame or %NULL
  * @ie_len: Length of ie buffer in octets
  * @reason_code: The reason code for the deauthentication
+ * @local_state_change: This is a request for a local state only, i.e., no
+ *	Deauthentication frame is to be transmitted.
  */
 struct cfg80211_deauth_request {
 	struct cfg80211_bss *bss;
 	const u8 *ie;
 	size_t ie_len;
 	u16 reason_code;
+	bool local_state_change;
 };
 
 /**
@@ -762,12 +770,15 @@ struct cfg80211_deauth_request {
  * @ie: Extra IEs to add to Disassociation frame or %NULL
  * @ie_len: Length of ie buffer in octets
  * @reason_code: The reason code for the disassociation
+ * @local_state_change: This is a request for a local state only, i.e., no
+ *	Disassociation frame is to be transmitted.
  */
 struct cfg80211_disassoc_request {
 	struct cfg80211_bss *bss;
 	const u8 *ie;
 	size_t ie_len;
 	u16 reason_code;
+	bool local_state_change;
 };
 
 /**
--- uml.orig/net/mac80211/mlme.c	2010-03-13 17:35:10.000000000 +0200
+++ uml/net/mac80211/mlme.c	2010-03-13 17:56:00.000000000 +0200
@@ -203,7 +203,7 @@ static u32 ieee80211_enable_ht(struct ie
 
 static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 					   const u8 *bssid, u16 stype, u16 reason,
-					   void *cookie)
+					   void *cookie, bool send_frame)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -240,7 +240,11 @@ static void ieee80211_send_deauth_disass
 			cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
 	if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-	ieee80211_tx_skb(sdata, skb);
+
+	if (send_frame)
+		ieee80211_tx_skb(sdata, skb);
+	else
+		kfree_skb(skb);
 }
 
 void ieee80211_send_pspoll(struct ieee80211_local *local,
@@ -1620,7 +1624,7 @@ static void ieee80211_sta_work(struct wo
 			ieee80211_send_deauth_disassoc(sdata, bssid,
 					IEEE80211_STYPE_DEAUTH,
 					WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
-					NULL);
+					NULL, true);
 			mutex_lock(&ifmgd->mtx);
 		}
 	}
@@ -1802,6 +1806,9 @@ int ieee80211_mgd_auth(struct ieee80211_
 	struct ieee80211_work *wk;
 	u16 auth_alg;
 
+	if (req->local_state_change)
+		return 0; /* no need to update mac80211 state */
+
 	switch (req->auth_type) {
 	case NL80211_AUTHTYPE_OPEN_SYSTEM:
 		auth_alg = WLAN_AUTH_OPEN;
@@ -2057,9 +2064,9 @@ int ieee80211_mgd_deauth(struct ieee8021
 	printk(KERN_DEBUG "%s: deauthenticating from %pM by local choice (reason=%d)\n",
 	       sdata->name, bssid, req->reason_code);
 
-	ieee80211_send_deauth_disassoc(sdata, bssid,
-			IEEE80211_STYPE_DEAUTH, req->reason_code,
-			cookie);
+	ieee80211_send_deauth_disassoc(sdata, bssid, IEEE80211_STYPE_DEAUTH,
+				       req->reason_code, cookie,
+				       !req->local_state_change);
 
 	ieee80211_recalc_idle(sdata->local);
 
@@ -2094,7 +2101,7 @@ int ieee80211_mgd_disassoc(struct ieee80
 
 	ieee80211_send_deauth_disassoc(sdata, req->bss->bssid,
 			IEEE80211_STYPE_DISASSOC, req->reason_code,
-			cookie);
+			cookie, !req->local_state_change);
 
 	ieee80211_recalc_idle(sdata->local);
 
--- uml.orig/net/wireless/core.h	2010-03-13 17:24:52.000000000 +0200
+++ uml/net/wireless/core.h	2010-03-13 17:27:49.000000000 +0200
@@ -293,13 +293,15 @@ int __cfg80211_mlme_auth(struct cfg80211
 			 const u8 *bssid,
 			 const u8 *ssid, int ssid_len,
 			 const u8 *ie, int ie_len,
-			 const u8 *key, int key_len, int key_idx);
+			 const u8 *key, int key_len, int key_idx,
+			 bool local_state_change);
 int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev, struct ieee80211_channel *chan,
 		       enum nl80211_auth_type auth_type, const u8 *bssid,
 		       const u8 *ssid, int ssid_len,
 		       const u8 *ie, int ie_len,
-		       const u8 *key, int key_len, int key_idx);
+		       const u8 *key, int key_len, int key_idx,
+		       bool local_state_change);
 int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev,
 			  struct ieee80211_channel *chan,
@@ -315,13 +317,16 @@ int cfg80211_mlme_assoc(struct cfg80211_
 			struct cfg80211_crypto_settings *crypt);
 int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 			   struct net_device *dev, const u8 *bssid,
-			   const u8 *ie, int ie_len, u16 reason);
+			   const u8 *ie, int ie_len, u16 reason,
+			   bool local_state_change);
 int cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 			 struct net_device *dev, const u8 *bssid,
-			 const u8 *ie, int ie_len, u16 reason);
+			 const u8 *ie, int ie_len, u16 reason,
+			 bool local_state_change);
 int cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
 			   struct net_device *dev, const u8 *bssid,
-			   const u8 *ie, int ie_len, u16 reason);
+			   const u8 *ie, int ie_len, u16 reason,
+			   bool local_state_change);
 void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
 			struct net_device *dev);
 void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
--- uml.orig/net/wireless/nl80211.c	2010-03-13 17:21:03.000000000 +0200
+++ uml/net/wireless/nl80211.c	2010-03-13 17:27:16.000000000 +0200
@@ -149,6 +149,7 @@ static const struct nla_policy nl80211_p
 				 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_FRAME_MATCH] = { .type = NLA_BINARY, },
 	[NL80211_ATTR_PS_STATE] = { .type = NLA_U32 },
+	[NL80211_ATTR_LOCAL_STATE_CHANGE] = { .type = NLA_FLAG },
 };
 
 /* policy for the attributes */
@@ -3391,6 +3392,7 @@ static int nl80211_authenticate(struct s
 	int err, ssid_len, ie_len = 0;
 	enum nl80211_auth_type auth_type;
 	struct key_parse key;
+	bool local_state_change;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
@@ -3469,9 +3471,12 @@ static int nl80211_authenticate(struct s
 		goto out;
 	}
 
+	local_state_change = !!info->attrs[NL80211_ATTR_LOCAL_STATE_CHANGE];
+
 	err = cfg80211_mlme_auth(rdev, dev, chan, auth_type, bssid,
 				 ssid, ssid_len, ie, ie_len,
-				 key.p.key, key.p.key_len, key.idx);
+				 key.p.key, key.p.key_len, key.idx,
+				 local_state_change);
 
 out:
 	cfg80211_unlock_rdev(rdev);
@@ -3648,6 +3653,7 @@ static int nl80211_deauthenticate(struct
 	const u8 *ie = NULL, *bssid;
 	int err, ie_len = 0;
 	u16 reason_code;
+	bool local_state_change;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
@@ -3693,7 +3699,10 @@ static int nl80211_deauthenticate(struct
 		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	err = cfg80211_mlme_deauth(rdev, dev, bssid, ie, ie_len, reason_code);
+	local_state_change = !!info->attrs[NL80211_ATTR_LOCAL_STATE_CHANGE];
+
+	err = cfg80211_mlme_deauth(rdev, dev, bssid, ie, ie_len, reason_code,
+				   local_state_change);
 
 out:
 	cfg80211_unlock_rdev(rdev);
@@ -3710,6 +3719,7 @@ static int nl80211_disassociate(struct s
 	const u8 *ie = NULL, *bssid;
 	int err, ie_len = 0;
 	u16 reason_code;
+	bool local_state_change;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
@@ -3755,7 +3765,10 @@ static int nl80211_disassociate(struct s
 		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
-	err = cfg80211_mlme_disassoc(rdev, dev, bssid, ie, ie_len, reason_code);
+	local_state_change = !!info->attrs[NL80211_ATTR_LOCAL_STATE_CHANGE];
+
+	err = cfg80211_mlme_disassoc(rdev, dev, bssid, ie, ie_len, reason_code,
+				     local_state_change);
 
 out:
 	cfg80211_unlock_rdev(rdev);
--- uml.orig/net/wireless/sme.c	2010-03-13 17:25:52.000000000 +0200
+++ uml/net/wireless/sme.c	2010-03-13 17:44:00.000000000 +0200
@@ -170,7 +170,7 @@ static int cfg80211_conn_do_work(struct 
 					    params->ssid, params->ssid_len,
 					    NULL, 0,
 					    params->key, params->key_len,
-					    params->key_idx);
+					    params->key_idx, false);
 	case CFG80211_CONN_ASSOCIATE_NEXT:
 		BUG_ON(!rdev->ops->assoc);
 		wdev->conn->state = CFG80211_CONN_ASSOCIATING;
@@ -185,12 +185,13 @@ static int cfg80211_conn_do_work(struct 
 		if (err)
 			__cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
 					       NULL, 0,
-					       WLAN_REASON_DEAUTH_LEAVING);
+					       WLAN_REASON_DEAUTH_LEAVING,
+					       false);
 		return err;
 	case CFG80211_CONN_DEAUTH_ASSOC_FAIL:
 		__cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
 				       NULL, 0,
-				       WLAN_REASON_DEAUTH_LEAVING);
+				       WLAN_REASON_DEAUTH_LEAVING, false);
 		/* return an error so that we call __cfg80211_connect_result() */
 		return -EINVAL;
 	default:
@@ -675,7 +676,8 @@ void __cfg80211_disconnected(struct net_
 				continue;
 			bssid = wdev->auth_bsses[i]->pub.bssid;
 			ret = __cfg80211_mlme_deauth(rdev, dev, bssid, NULL, 0,
-						WLAN_REASON_DEAUTH_LEAVING);
+						WLAN_REASON_DEAUTH_LEAVING,
+						false);
 			WARN(ret, "deauth failed: %d\n", ret);
 		}
 	}
@@ -934,7 +936,7 @@ int __cfg80211_disconnect(struct cfg8021
 		/* wdev->conn->params.bssid must be set if > SCANNING */
 		err = __cfg80211_mlme_deauth(rdev, dev,
 					     wdev->conn->params.bssid,
-					     NULL, 0, reason);
+					     NULL, 0, reason, false);
 		if (err)
 			return err;
 	} else {
@@ -990,7 +992,8 @@ void cfg80211_sme_disassoc(struct net_de
 
 	memcpy(bssid, wdev->auth_bsses[idx]->pub.bssid, ETH_ALEN);
 	if (__cfg80211_mlme_deauth(rdev, dev, bssid,
-				   NULL, 0, WLAN_REASON_DEAUTH_LEAVING)) {
+				   NULL, 0, WLAN_REASON_DEAUTH_LEAVING,
+				   false)) {
 		/* whatever -- assume gone anyway */
 		cfg80211_unhold_bss(wdev->auth_bsses[idx]);
 		cfg80211_put_bss(&wdev->auth_bsses[idx]->pub);

-- 
Jouni Malinen                                            PGP id EFC895FA

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46594 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1KCFz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 01:55:29 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3 1/3] mac80211: Support forcing station to disable HT (802.11n).
Date: Wed,  2 Nov 2011 22:55:20 -0700
Message-Id: <1320299722-30113-1-git-send-email-greearb@candelatech.com> (sfid-20111103_065534_192366_EF6ABFB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This allows a user to configure a wifi station interface
to disable the HT features, even if the AP and NIC supports it.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 8049bf7... 499a5a4... M	include/linux/nl80211.h
:100644 100644 92cf1c2... d2168c0... M	include/net/cfg80211.h
:100644 100644 57fb58f... d4092e8... M	net/mac80211/mlme.c
:100644 100644 b9ec306... 72e19e4... M	net/wireless/core.h
:100644 100644 21fc970... 5c41411... M	net/wireless/mlme.c
:100644 100644 48260c2... 3c4dab1... M	net/wireless/nl80211.c
:100644 100644 6e86d5a... 449a19f... M	net/wireless/sme.c
 include/linux/nl80211.h |    4 ++++
 include/net/cfg80211.h  |    6 ++++++
 net/mac80211/mlme.c     |    3 +++
 net/wireless/core.h     |    6 ++++--
 net/wireless/mlme.c     |   10 +++++++---
 net/wireless/nl80211.c  |   10 +++++++++-
 net/wireless/sme.c      |    3 ++-
 7 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 8049bf7..499a5a4 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1109,6 +1109,9 @@ enum nl80211_commands {
  *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
  *	used for asking the driver to perform a TDLS operation.
  *
+ * @NL80211_ATTR_DISABLE_HT:  Force HT capable interfaces to disable
+ *      this feature.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1337,6 +1340,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_TDLS_SUPPORT,
 	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
 
+	NL80211_ATTR_DISABLE_HT,
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 92cf1c2..d2168c0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1035,6 +1035,8 @@ struct cfg80211_auth_request {
 	bool local_state_change;
 };
 
+#define ASSOC_REQ_DISABLE_HT	(1<<0) /* Disable HT (802.11n) */
+
 /**
  * struct cfg80211_assoc_request - (Re)Association request data
  *
@@ -1046,6 +1048,7 @@ struct cfg80211_auth_request {
  * @use_mfp: Use management frame protection (IEEE 802.11w) in this association
  * @crypto: crypto settings
  * @prev_bssid: previous BSSID, if not %NULL use reassociate frame
+ * @flags:  See ASSOC_REQ_* flags above.
  */
 struct cfg80211_assoc_request {
 	struct cfg80211_bss *bss;
@@ -1053,6 +1056,7 @@ struct cfg80211_assoc_request {
 	size_t ie_len;
 	struct cfg80211_crypto_settings crypto;
 	bool use_mfp;
+	u32 flags;
 };
 
 /**
@@ -1147,6 +1151,7 @@ struct cfg80211_ibss_params {
  * @ie: IEs for association request
  * @ie_len: Length of assoc_ie in octets
  * @privacy: indicates whether privacy-enabled APs should be used
+ * @flags:  See ASSOC_REQ_* #defines above.
  * @crypto: crypto settings
  * @key_len: length of WEP key for shared key authentication
  * @key_idx: index of WEP key for shared key authentication
@@ -1164,6 +1169,7 @@ struct cfg80211_connect_params {
 	struct cfg80211_crypto_settings crypto;
 	const u8 *key;
 	u8 key_len, key_idx;
+	u32 flags;
 };
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 57fb58f..d4092e8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2611,6 +2611,9 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 
 
+	if (req->flags & ASSOC_REQ_DISABLE_HT)
+		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+
 	if (req->ie && req->ie_len) {
 		memcpy(wk->ie, req->ie, req->ie_len);
 		wk->ie_len = req->ie_len;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b9ec306..72e19e4 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -339,13 +339,15 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			  const u8 *bssid, const u8 *prev_bssid,
 			  const u8 *ssid, int ssid_len,
 			  const u8 *ie, int ie_len, bool use_mfp,
-			  struct cfg80211_crypto_settings *crypt);
+			  struct cfg80211_crypto_settings *crypt,
+			  u32 assoc_flags);
 int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, struct ieee80211_channel *chan,
 			const u8 *bssid, const u8 *prev_bssid,
 			const u8 *ssid, int ssid_len,
 			const u8 *ie, int ie_len, bool use_mfp,
-			struct cfg80211_crypto_settings *crypt);
+			struct cfg80211_crypto_settings *crypt,
+			u32 assoc_flags);
 int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 			   struct net_device *dev, const u8 *bssid,
 			   const u8 *ie, int ie_len, u16 reason,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 21fc970..5c41411 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -507,7 +507,8 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			  const u8 *bssid, const u8 *prev_bssid,
 			  const u8 *ssid, int ssid_len,
 			  const u8 *ie, int ie_len, bool use_mfp,
-			  struct cfg80211_crypto_settings *crypt)
+			  struct cfg80211_crypto_settings *crypt,
+			  u32 assoc_flags)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_assoc_request req;
@@ -537,6 +538,7 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 	memcpy(&req.crypto, crypt, sizeof(req.crypto));
 	req.use_mfp = use_mfp;
 	req.prev_bssid = prev_bssid;
+	req.flags = assoc_flags;
 	req.bss = cfg80211_get_bss(&rdev->wiphy, chan, bssid, ssid, ssid_len,
 				   WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
 	if (!req.bss) {
@@ -574,14 +576,16 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			const u8 *bssid, const u8 *prev_bssid,
 			const u8 *ssid, int ssid_len,
 			const u8 *ie, int ie_len, bool use_mfp,
-			struct cfg80211_crypto_settings *crypt)
+			struct cfg80211_crypto_settings *crypt,
+			u32 assoc_flags)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
 	wdev_lock(wdev);
 	err = __cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
-				    ssid, ssid_len, ie, ie_len, use_mfp, crypt);
+				    ssid, ssid_len, ie, ie_len, use_mfp, crypt,
+				    assoc_flags);
 	wdev_unlock(wdev);
 
 	return err;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 48260c2..3c4dab1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -197,6 +197,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_TDLS_OPERATION] = { .type = NLA_U8 },
 	[NL80211_ATTR_TDLS_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TDLS_EXTERNAL_SETUP] = { .type = NLA_FLAG },
+	[NL80211_ATTR_DISABLE_HT] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -4354,6 +4355,7 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	const u8 *bssid, *ssid, *ie = NULL, *prev_bssid = NULL;
 	int err, ssid_len, ie_len = 0;
 	bool use_mfp = false;
+	u32 flags = 0;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
@@ -4397,11 +4399,14 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_PREV_BSSID])
 		prev_bssid = nla_data(info->attrs[NL80211_ATTR_PREV_BSSID]);
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_HT]))
+		flags |= ASSOC_REQ_DISABLE_HT;
+
 	err = nl80211_crypto_settings(rdev, info, &crypto, 1);
 	if (!err)
 		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
 					  ssid, ssid_len, ie, ie_len, use_mfp,
-					  &crypto);
+					  &crypto, flags);
 
 	return err;
 }
@@ -4891,6 +4896,9 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 			return PTR_ERR(connkeys);
 	}
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_DISABLE_HT]))
+		connect.flags |= ASSOC_REQ_DISABLE_HT;
+
 	err = cfg80211_connect(rdev, dev, &connect, connkeys);
 	if (err)
 		kfree(connkeys);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 6e86d5a..449a19f 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -189,7 +189,8 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 					    prev_bssid,
 					    params->ssid, params->ssid_len,
 					    params->ie, params->ie_len,
-					    false, &params->crypto);
+					    false, &params->crypto,
+					    params->flags);
 		if (err)
 			__cfg80211_mlme_deauth(rdev, wdev->netdev, params->bssid,
 					       NULL, 0,
-- 
1.7.3.4


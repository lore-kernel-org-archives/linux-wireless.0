Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17484 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbdCCL5i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Mar 2017 06:57:38 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [RFC] cfg80211: Add support for FILS shared key authentication offload
Date: Fri, 3 Mar 2017 13:53:26 +0200
Message-ID: <1488542006-11776-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20170303_125804_415312_36FC4059)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>

Enhance nl80211 and cfg80211 connect request and response APIs to
support FILS shared key authentication Offload. The new nl80211
attributes can be used to provide additional information to the driver
to establish a FILS connection. Also enhance the set/del PMKSA to allow
support for adding and deleting PMKSA based on FILS cache identifier.

Add a new feature flag that drivers can use to advertize support for
FILS shared key authentication and association in station mode when
using their own SME.

Signed-off-by: Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/linux/ieee80211.h    |   9 ++++
 include/net/cfg80211.h       | 115 +++++++++++++++++++++++++++++++++++++++----
 include/uapi/linux/nl80211.h |  48 ++++++++++++++++--
 net/wireless/core.h          |  12 ++++-
 net/wireless/mlme.c          |   1 +
 net/wireless/nl80211.c       |  89 ++++++++++++++++++++++++++++++---
 net/wireless/nl80211.h       |   5 +-
 net/wireless/sme.c           |  64 ++++++++++++++++++------
 net/wireless/util.c          |   4 ++
 9 files changed, 311 insertions(+), 36 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 22bf067..51e2748 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1723,6 +1723,9 @@ enum ieee80211_statuscode {
 	WLAN_STATUS_REJECT_DSE_BAND = 96,
 	WLAN_STATUS_DENIED_WITH_SUGGESTED_BAND_AND_CHANNEL = 99,
 	WLAN_STATUS_DENIED_DUE_TO_SPECTRUM_MANAGEMENT = 103,
+	/* 802.11ai */
+	WLAN_STATUS_FILS_AUTHENTICATION_FAILURE = 108,
+	WLAN_STATUS_UNKNOWN_AUTHENTICATION_SERVER = 109,
 };
 
 
@@ -2104,6 +2107,12 @@ enum ieee80211_key_len {
 #define FILS_NONCE_LEN			16
 #define FILS_MAX_KEK_LEN		64
 
+#define FILS_ERP_MAX_USERNAME_LEN	16
+#define FILS_ERP_MAX_REALM_LEN		253
+#define FILS_ERP_MAX_RRK_LEN		64
+
+#define PMK_MAX_LEN			48
+
 /* Public action codes */
 enum ieee80211_pub_actioncode {
 	WLAN_PUB_ACTION_EXT_CHANSW_ANN = 4,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 86c12f8..a5009d0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2073,6 +2073,17 @@ struct cfg80211_bss_selection {
  *	the BSSID of the current association, i.e., to the value that is
  *	included in the Current AP address field of the Reassociation Request
  *	frame.
+ * @fils_erp_username: EAP re-authentication protocol (ERP) username part of the
+ *	NAI. This is used to refer to the keys used in ERP, i.e., rRK and rIK.
+ * @fils_erp_username_len: Length of @fils_erp_username in octets.
+ * @fils_erp_realm: EAP re-authentication protocol (ERP) realm part of NAI. This
+ *	specifies the domain name of ER server.
+ * @fils_erp_realm_len: Length of @fils_erp_realm in octets.
+ * @fils_erp_sequence_num: The start sequence number to be used in the next ERP
+ *	message.
+ * @fils_erp_rrk: ERP re-authentication Root Key (rRK) used to derive additional
+ *	keys in FILS.
+ * @fils_erp_rrk_len: Length of @fils_erp_rrk in octets.
  */
 struct cfg80211_connect_params {
 	struct ieee80211_channel *channel;
@@ -2098,6 +2109,13 @@ struct cfg80211_connect_params {
 	bool pbss;
 	struct cfg80211_bss_selection bss_select;
 	const u8 *prev_bssid;
+	const u8 *fils_erp_username;
+	size_t fils_erp_username_len;
+	const u8 *fils_erp_realm;
+	size_t fils_erp_realm_len;
+	u16 fils_erp_sequence_num;
+	const u8 *fils_erp_rrk;
+	size_t fils_erp_rrk_len;
 };
 
 /**
@@ -2137,11 +2155,24 @@ enum wiphy_params_flags {
  * caching.
  *
  * @bssid: The AP's BSSID.
- * @pmkid: The PMK material itself.
+ * @pmkid: The identifer to refer a PMKSA.
+ * @pmk: The PMK for the PMKSA identified by @pmkid. This is used for key
+ *	derivation by a FILS STA. Otherwise, %NULL.
+ * @pmk_len: Length of the @pmk. The length of @pmk can differ depending on
+ *	the hash algorithm used to generate this.
+ * @ssid: SSID to specify the ESS within which a PMKSA is valid.
+ * @ssid_len: Length of the @ssid in octets.
+ * @cache_id: Unsigned 16 bit identifier advertized by an AP identifying the
+ *	scope of PMKSA. This is valid only if @ssid_len is non-zero.
  */
 struct cfg80211_pmksa {
 	const u8 *bssid;
 	const u8 *pmkid;
+	const u8 *pmk;
+	size_t pmk_len;
+	const u8 *ssid;
+	size_t ssid_len;
+	u16 cache_id;
 };
 
 /**
@@ -5136,6 +5167,60 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
 #endif
 
 /**
+ * cfg80211_connect_done - notify cfg80211 of connection result
+ *
+ * @dev: network device
+ * @bssid: the BSSID of the AP
+ * @bss: entry of bss to which STA got connected to, can be obtained
+ *	through cfg80211_get_bss (may be %NULL)
+ * @req_ie: association request IEs (maybe be %NULL)
+ * @req_ie_len: association request IEs length
+ * @resp_ie: association response IEs (may be %NULL)
+ * @resp_ie_len: assoc response IEs length
+ * @fils_kek: KEK derived from a successful FILS connection (may be %NULL)
+ * @fils_kek_len: length of @fils_kek
+ * @update_erp_seq_num: Bool value to specify if the value in @fils_erp_seq_num
+ *	is valid.
+ * @fils_erp_seq_num: The last used ERP sequence number in FILS Authentication.
+ *	This value should be specified irrespective of the status for a FILS
+ *	connection.
+ * @pmk: A new PMK if derived from a successful FILS connection (may be %NULL).
+ * @pmk_len: Length of @pmk.
+ * @pmkid: A new PMKID if derived from a successful FILS connection (may be
+ *	%NULL).
+ * @status: status code, %WLAN_STATUS_SUCCESS for successful connection, use
+ *	%WLAN_STATUS_UNSPECIFIED_FAILURE if your device cannot give you
+ *	the real status code for failures. If this call is used to report a
+ *	failure due to a timeout (e.g., not receiving an Authentication frame
+ *	from the AP) instead of an explicit rejection by the AP, -1 is used to
+ *	indicate that this is a failure, but without a status code.
+ *	@timeout_reason is used to report the reason for the timeout in that
+ *	case.
+ * @gfp: allocation flags
+ * @timeout_reason: reason for connection timeout. This is used when the
+ *	connection fails due to a timeout instead of an explicit rejection from
+ *	the AP. %NL80211_TIMEOUT_UNSPECIFIED is used when the timeout reason is
+ *	not known. This value is used only if @status < 0 to indicate that the
+ *	failure is due to a timeout and not due to explicit rejection by the AP.
+ *	This value is ignored in other cases (@status >= 0).
+ *
+ * It should be called by the underlying driver once execution of the connection
+ * request from connect() has been completed. This is similar to
+ * cfg80211_connect_bss(), but with additional parameters that a user
+ * space should know to maintain a successful connection in case of FILS. Only
+ * one of the functions among cfg80211_connect_bss(), cfg80211_connect_result()
+ * cfg80211_connect_timeout() and cfg80211_connect_done() should be called.
+ */
+void cfg80211_connect_done(struct net_device *dev, const u8 *bssid,
+			   struct cfg80211_bss *bss, const u8 *req_ie,
+			   size_t req_ie_len, const u8 *resp_ie,
+			   size_t resp_ie_len, const u8 *fils_kek,
+			   size_t fils_kek_len, bool update_erp_seq_num,
+			   u16 fils_erp_seq_num, const u8 *pmk, size_t pmk_len,
+			   const u8 *pmkid, int status, gfp_t gfp,
+			   enum nl80211_timeout_reason timeout_reason);
+
+/**
  * cfg80211_connect_bss - notify cfg80211 of connection result
  *
  * @dev: network device
@@ -5165,13 +5250,21 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
  * It should be called by the underlying driver once execution of the connection
  * request from connect() has been completed. This is similar to
  * cfg80211_connect_result(), but with the option of identifying the exact bss
- * entry for the connection. Only one of these functions should be called.
+ * entry for the connection. Only one of the functions among
+ * cfg80211_connect_bss(), cfg80211_connect_result(),
+ * cfg80211_connect_timeout(), and cfg80211_connect_done() should be called.
  */
-void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
-			  struct cfg80211_bss *bss, const u8 *req_ie,
-			  size_t req_ie_len, const u8 *resp_ie,
-			  size_t resp_ie_len, int status, gfp_t gfp,
-			  enum nl80211_timeout_reason timeout_reason);
+static inline void
+cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
+		     struct cfg80211_bss *bss, const u8 *req_ie,
+		     size_t req_ie_len, const u8 *resp_ie,
+		     size_t resp_ie_len, int status, gfp_t gfp,
+		     enum nl80211_timeout_reason timeout_reason)
+{
+	cfg80211_connect_done(dev, bssid, bss, req_ie, req_ie_len, resp_ie,
+			      resp_ie_len, NULL, 0, false, 0, NULL, 0, NULL,
+			      status, gfp, timeout_reason);
+}
 
 /**
  * cfg80211_connect_result - notify cfg80211 of connection result
@@ -5190,7 +5283,9 @@ void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
  * It should be called by the underlying driver once execution of the connection
  * request from connect() has been completed. This is similar to
  * cfg80211_connect_bss() which allows the exact bss entry to be specified. Only
- * one of these functions should be called.
+ * one of the functions among cfg80211_connect_bss(),
+ * cfg80211_connect_result(), cfg80211_connect_timeout(), and
+ * cfg80211_connect_done() should be called.
  */
 static inline void
 cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
@@ -5217,7 +5312,9 @@ cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
  * in a sequence where no explicit authentication/association rejection was
  * received from the AP. This could happen, e.g., due to not being able to send
  * out the Authentication or Association Request frame or timing out while
- * waiting for the response.
+ * waiting for the response. Only one of the functions among
+ * cfg80211_connect_bss(), cfg80211_connect_result(), cfg80211_connect_timeout()
+ * and cfg80211_connect_done() should be called.
  */
 static inline void
 cfg80211_connect_timeout(struct net_device *dev, const u8 *bssid,
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9a499b1..08d8988 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -370,10 +370,16 @@
  * @NL80211_CMD_NEW_SURVEY_RESULTS: survey data notification (as a reply to
  *	NL80211_CMD_GET_SURVEY and on the "scan" multicast group)
  *
- * @NL80211_CMD_SET_PMKSA: Add a PMKSA cache entry, using %NL80211_ATTR_MAC
- *	(for the BSSID) and %NL80211_ATTR_PMKID.
+ * @NL80211_CMD_SET_PMKSA: Add a PMKSA cache entry using %NL80211_ATTR_MAC
+ *	(for the BSSID), %NL80211_ATTR_PMKID, and optionally %NL80211_ATTR_PMK
+ *	(for PTKSA derivation in case of FILS SK offload) or using
+ *	%NL80211_ATTR_SSID, %NL80211_ATTR_FILS_CACHE_ID,
+ *	%NL80211_ATTR_PMKID, and %NL80211_ATTR_PMK in case of FILS
+ *	authentication.
  * @NL80211_CMD_DEL_PMKSA: Delete a PMKSA cache entry, using %NL80211_ATTR_MAC
- *	(for the BSSID) and %NL80211_ATTR_PMKID.
+ *	(for the BSSID) and %NL80211_ATTR_PMKID or using %NL80211_ATTR_SSID,
+ *	%NL80211_ATTR_FILS_CACHE_ID, and %NL80211_ATTR_PMKID in case of FILS
+ *	authentication.
  * @NL80211_CMD_FLUSH_PMKSA: Flush all PMKSA cache entries.
  *
  * @NL80211_CMD_REG_CHANGE: indicates to userspace the regulatory domain
@@ -2012,6 +2018,31 @@ enum nl80211_commands {
  *	u32 attribute with an &enum nl80211_timeout_reason value. This is used,
  *	e.g., with %NL80211_CMD_CONNECT event.
  *
+ * @NL80211_ATTR_FILS_ERP_USERNAME: EAP Re-authentication Protocol (ERP)
+ *	username part of NAI used to refer keys rRK and rIK. This is used with
+ *	%NL80211_CMD_CONNECT.
+ *
+ * @NL80211_ATTR_FILS_ERP_REALM: EAP Re-authentication Protocol (ERP) realm part
+ *	of NAI specifying the domain name of the ER server. This is used with
+ *	%NL80211_CMD_CONNECT.
+ *
+ * @NL80211_ATTR_FILS_ERP_SEQUENCE_NUM: Unsigned 16-bit ERP sequence number used
+ *	for replay protection. This is used in generating the FILS wrapped data
+ *	for FILS authentication and is used with %NL80211_CMD_CONNECT.
+ *
+ * @NL80211_ATTR_FILS_ERP_RRK: ERP re-authentication Root Key (rRK) for the
+ *	NAI specified by %NL80211_ATTR_FILS_ERP_USERNAME and
+ *	%NL80211_ATTR_FILS_ERP_REALM. This is used for generating rIK and rMSK
+ *	from successful FILS authentication and is used with
+ *	%NL80211_CMD_CONNECT.
+ *
+ * @NL80211_ATTR_FILS_CACHE_ID: Unsigned 16 bit identifier advertized by a FILS
+ *	AP identifying the scope of PMKSAs. This is used with
+ *	@NL80211_CMD_SET_PMKSA and @NL80211_CMD_DEL_PMKSA.
+ *
+ * @NL80211_ATTR_PMK: PMK for the PMKSA identified by %NL80211_ATTR_PMKID.
+ *	This is used with @NL80211_CMD_SET_PMKSA.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2423,6 +2454,14 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TIMEOUT_REASON,
 
+	NL80211_ATTR_FILS_ERP_USERNAME,
+	NL80211_ATTR_FILS_ERP_REALM,
+	NL80211_ATTR_FILS_ERP_SEQUENCE_NUM,
+	NL80211_ATTR_FILS_ERP_RRK,
+	NL80211_ATTR_FILS_CACHE_ID,
+
+	NL80211_ATTR_PMK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4759,6 +4798,8 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_CQM_RSSI_LIST: With this driver the
  *	%NL80211_ATTR_CQM_RSSI_THOLD attribute accepts a list of zero or more
  *	RSSI threshold values to monitor rather than exactly one threshold.
+ * @NL80211_EXT_FEATURE_FILS_SK_OFFLOAD: Driver SME supports FILS shared key
+ *	authentication with %NL80211_CMD_CONNECT.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4778,6 +4819,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA_CONNECTED,
 	NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI,
 	NL80211_EXT_FEATURE_CQM_RSSI_LIST,
+	NL80211_EXT_FEATURE_FILS_SK_OFFLOAD,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index efa690a..ee6f6b5 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -227,6 +227,13 @@ struct cfg80211_event {
 			size_t req_ie_len;
 			size_t resp_ie_len;
 			struct cfg80211_bss *bss;
+			const u8 *kek;
+			size_t kek_len;
+			bool update_erp_seq_num;
+			u16 fils_erp_seq_num;
+			const u8 *pmk;
+			size_t pmk_len;
+			const u8 *pmkid;
 			int status; /* -1 = failed; 0..65535 = status code */
 			enum nl80211_timeout_reason timeout_reason;
 		} cr;
@@ -395,7 +402,10 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			       const u8 *req_ie, size_t req_ie_len,
 			       const u8 *resp_ie, size_t resp_ie_len,
-			       int status, bool wextev,
+			       const u8 *fils_kek, size_t fils_kek_len,
+			       bool update_erp_seq_num, u16 fils_erp_seq_num,
+			       const u8 *fils_pmk, size_t fils_pmk_len,
+			       const u8 *fils_pmkid, int status, bool wextev,
 			       struct cfg80211_bss *bss,
 			       enum nl80211_timeout_reason timeout_reason);
 void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 22b3d99..644527c 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -47,6 +47,7 @@ void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
 	nl80211_send_rx_assoc(rdev, dev, buf, len, GFP_KERNEL, uapsd_queues);
 	/* update current_bss etc., consumes the bss reference */
 	__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, ie, len - ieoffs,
+				  NULL, 0, false, 0, NULL, 0, NULL,
 				  status_code,
 				  status_code == WLAN_STATUS_SUCCESS, bss,
 				  NL80211_TIMEOUT_UNSPECIFIED);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d516527..d97020a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -410,6 +410,15 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 		.len = sizeof(struct nl80211_bss_select_rssi_adjust)
 	},
 	[NL80211_ATTR_TIMEOUT_REASON] = { .type = NLA_U32 },
+	[NL80211_ATTR_FILS_ERP_USERNAME] = { .type = NLA_BINARY,
+					     .len = FILS_ERP_MAX_USERNAME_LEN },
+	[NL80211_ATTR_FILS_ERP_REALM] = { .type = NLA_BINARY,
+					  .len = FILS_ERP_MAX_REALM_LEN },
+	[NL80211_ATTR_FILS_ERP_SEQUENCE_NUM] = { .type = NLA_U16 },
+	[NL80211_ATTR_FILS_ERP_RRK] = { .type = NLA_BINARY,
+					.len = FILS_ERP_MAX_RRK_LEN },
+	[NL80211_ATTR_FILS_CACHE_ID] = { .type = NLA_U16 },
+	[NL80211_ATTR_PMK] = { .type = NLA_BINARY, .len = PMK_MAX_LEN },
 };
 
 /* policy for the key attributes */
@@ -3832,6 +3841,19 @@ static bool nl80211_valid_auth_type(struct cfg80211_registered_device *rdev,
 			return false;
 		return true;
 	case NL80211_CMD_CONNECT:
+		/* SAE not supported yet */
+		if (auth_type == NL80211_AUTHTYPE_SAE)
+			return false;
+		/* FILS with SK PFS or PK not supported yet */
+		if (auth_type == NL80211_AUTHTYPE_FILS_SK_PFS ||
+		    auth_type == NL80211_AUTHTYPE_FILS_PK)
+			return false;
+		if (!wiphy_ext_feature_isset(
+			    &rdev->wiphy,
+			    NL80211_EXT_FEATURE_FILS_SK_OFFLOAD) &&
+		    auth_type == NL80211_AUTHTYPE_FILS_SK)
+			return false;
+		return true;
 	case NL80211_CMD_START_AP:
 		/* SAE not supported yet */
 		if (auth_type == NL80211_AUTHTYPE_SAE)
@@ -8874,6 +8896,34 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (wiphy_ext_feature_isset(&rdev->wiphy,
+				    NL80211_EXT_FEATURE_FILS_SK_OFFLOAD) &&
+	    info->attrs[NL80211_ATTR_FILS_ERP_USERNAME] &&
+	    info->attrs[NL80211_ATTR_FILS_ERP_REALM] &&
+	    info->attrs[NL80211_ATTR_FILS_ERP_SEQUENCE_NUM] &&
+	    info->attrs[NL80211_ATTR_FILS_ERP_RRK]) {
+		connect.fils_erp_username =
+			nla_data(info->attrs[NL80211_ATTR_FILS_ERP_USERNAME]);
+		connect.fils_erp_username_len =
+			nla_len(info->attrs[NL80211_ATTR_FILS_ERP_USERNAME]);
+		connect.fils_erp_realm =
+			nla_data(info->attrs[NL80211_ATTR_FILS_ERP_REALM]);
+		connect.fils_erp_realm_len =
+			nla_len(info->attrs[NL80211_ATTR_FILS_ERP_REALM]);
+		connect.fils_erp_sequence_num =
+			nla_get_u16(
+			   info->attrs[NL80211_ATTR_FILS_ERP_SEQUENCE_NUM]);
+		connect.fils_erp_rrk =
+			nla_data(info->attrs[NL80211_ATTR_FILS_ERP_RRK]);
+		connect.fils_erp_rrk_len =
+			nla_len(info->attrs[NL80211_ATTR_FILS_ERP_RRK]);
+	} else if (info->attrs[NL80211_ATTR_FILS_ERP_USERNAME] ||
+		   info->attrs[NL80211_ATTR_FILS_ERP_REALM] ||
+		   info->attrs[NL80211_ATTR_FILS_ERP_SEQUENCE_NUM] ||
+		   info->attrs[NL80211_ATTR_FILS_ERP_RRK]) {
+		return -EINVAL;
+	}
+
 	wdev_lock(dev->ieee80211_ptr);
 
 	err = cfg80211_connect(rdev, dev, &connect, connkeys,
@@ -8993,14 +9043,28 @@ static int nl80211_setdel_pmksa(struct sk_buff *skb, struct genl_info *info)
 
 	memset(&pmksa, 0, sizeof(struct cfg80211_pmksa));
 
-	if (!info->attrs[NL80211_ATTR_MAC])
-		return -EINVAL;
-
 	if (!info->attrs[NL80211_ATTR_PMKID])
 		return -EINVAL;
 
 	pmksa.pmkid = nla_data(info->attrs[NL80211_ATTR_PMKID]);
-	pmksa.bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (info->attrs[NL80211_ATTR_MAC]) {
+		pmksa.bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	} else if (info->attrs[NL80211_ATTR_SSID] &&
+		   info->attrs[NL80211_ATTR_FILS_CACHE_ID] &&
+		   (info->genlhdr->cmd == NL80211_CMD_DEL_PMKSA ||
+		    info->attrs[NL80211_ATTR_PMK])) {
+		pmksa.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
+		pmksa.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
+		pmksa.cache_id =
+			nla_get_u16(info->attrs[NL80211_ATTR_FILS_CACHE_ID]);
+	} else {
+		return -EINVAL;
+	}
+	if (info->attrs[NL80211_ATTR_PMK]) {
+		pmksa.pmk = nla_data(info->attrs[NL80211_ATTR_PMK]);
+		pmksa.pmk_len = nla_len(info->attrs[NL80211_ATTR_PMK]);
+	}
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT)
@@ -13415,7 +13479,10 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 				 struct net_device *netdev, const u8 *bssid,
 				 const u8 *req_ie, size_t req_ie_len,
 				 const u8 *resp_ie, size_t resp_ie_len,
-				 int status,
+				 const u8 *fils_kek, size_t fils_kek_len,
+				 bool update_erp_seq_num, u16 fils_erp_seq_num,
+				 const u8 *fils_pmk, size_t fils_pmk_len,
+				 const u8 *fils_pmkid, int status,
 				 enum nl80211_timeout_reason timeout_reason,
 				 gfp_t gfp)
 {
@@ -13444,7 +13511,17 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 	    (req_ie &&
 	     nla_put(msg, NL80211_ATTR_REQ_IE, req_ie_len, req_ie)) ||
 	    (resp_ie &&
-	     nla_put(msg, NL80211_ATTR_RESP_IE, resp_ie_len, resp_ie)))
+	     nla_put(msg, NL80211_ATTR_RESP_IE, resp_ie_len, resp_ie)) ||
+	    (update_erp_seq_num &&
+	     nla_put_u16(msg, NL80211_ATTR_FILS_ERP_SEQUENCE_NUM,
+			 fils_erp_seq_num)) ||
+	    (status == WLAN_STATUS_SUCCESS &&
+	     ((fils_kek &&
+	       nla_put(msg, NL80211_ATTR_FILS_KEK, fils_kek_len, fils_kek)) ||
+	      (fils_pmk &&
+	       nla_put(msg, NL80211_ATTR_PMK, fils_pmk_len, fils_pmk)) ||
+	      (fils_pmkid &&
+	       nla_put(msg, NL80211_ATTR_PMKID, WLAN_PMKID_LEN, fils_pmkid)))))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index e488dca..354dd44 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -56,7 +56,10 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 				 struct net_device *netdev, const u8 *bssid,
 				 const u8 *req_ie, size_t req_ie_len,
 				 const u8 *resp_ie, size_t resp_ie_len,
-				 int status,
+				 const u8 *fils_kek, size_t fils_kek_len,
+				 bool update_erp_seq_num, u16 fils_erp_seq_num,
+				 const u8 *fils_pmk, size_t fils_pmk_len,
+				 const u8 *fils_pmkid, int status,
 				 enum nl80211_timeout_reason timeout_reason,
 				 gfp_t gfp);
 void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index b347e63..5d5204f 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -255,7 +255,8 @@ void cfg80211_conn_work(struct work_struct *work)
 		if (cfg80211_conn_do_work(wdev, &treason)) {
 			__cfg80211_connect_result(
 					wdev->netdev, bssid,
-					NULL, 0, NULL, 0, -1, false, NULL,
+					NULL, 0, NULL, 0, NULL, 0, false, 0,
+					NULL, 0, NULL, -1, false, NULL,
 					treason);
 		}
 		wdev_unlock(wdev);
@@ -360,9 +361,9 @@ void cfg80211_sme_rx_auth(struct wireless_dev *wdev, const u8 *buf, size_t len)
 		schedule_work(&rdev->conn_work);
 	} else if (status_code != WLAN_STATUS_SUCCESS) {
 		__cfg80211_connect_result(wdev->netdev, mgmt->bssid,
-					  NULL, 0, NULL, 0,
-					  status_code, false, NULL,
-					  NL80211_TIMEOUT_UNSPECIFIED);
+					  NULL, 0, NULL, 0, NULL, 0, false, 0,
+					  NULL, 0, NULL, status_code, false,
+					  NULL, NL80211_TIMEOUT_UNSPECIFIED);
 	} else if (wdev->conn->state == CFG80211_CONN_AUTHENTICATING) {
 		wdev->conn->state = CFG80211_CONN_ASSOCIATE_NEXT;
 		schedule_work(&rdev->conn_work);
@@ -672,7 +673,10 @@ static DECLARE_WORK(cfg80211_disconnect_work, disconnect_work);
 void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			       const u8 *req_ie, size_t req_ie_len,
 			       const u8 *resp_ie, size_t resp_ie_len,
-			       int status, bool wextev,
+			       const u8 *fils_kek, size_t fils_kek_len,
+			       bool update_erp_seq_num, u16 fils_erp_seq_num,
+			       const u8 *fils_pmk, size_t fils_pmk_len,
+			       const u8 *fils_pmkid, int status, bool wextev,
 			       struct cfg80211_bss *bss,
 			       enum nl80211_timeout_reason timeout_reason)
 {
@@ -690,10 +694,12 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 		return;
 	}
 
-	nl80211_send_connect_result(wiphy_to_rdev(wdev->wiphy), dev,
-				    bssid, req_ie, req_ie_len,
-				    resp_ie, resp_ie_len,
-				    status, timeout_reason, GFP_KERNEL);
+	nl80211_send_connect_result(wiphy_to_rdev(wdev->wiphy), dev, bssid,
+				    req_ie, req_ie_len, resp_ie, resp_ie_len,
+				    fils_kek, fils_kek_len, update_erp_seq_num,
+				    fils_erp_seq_num, fils_pmk, fils_pmk_len,
+				    fils_pmkid, status, timeout_reason,
+				    GFP_KERNEL);
 
 #ifdef CONFIG_CFG80211_WEXT
 	if (wextev) {
@@ -781,11 +787,16 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 }
 
 /* Consumes bss object one way or another */
-void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
-			  struct cfg80211_bss *bss, const u8 *req_ie,
-			  size_t req_ie_len, const u8 *resp_ie,
-			  size_t resp_ie_len, int status, gfp_t gfp,
-			  enum nl80211_timeout_reason timeout_reason)
+void cfg80211_connect_done(struct net_device *dev,
+			   const u8 *bssid, struct cfg80211_bss *bss,
+			   const u8 *req_ie, size_t req_ie_len,
+			   const u8 *resp_ie, size_t resp_ie_len,
+			   const u8 *fils_kek, size_t fils_kek_len,
+			   bool update_erp_seq_num, u16 fils_erp_seq_num,
+			   const u8 *fils_pmk, size_t fils_pmk_len,
+			   const u8 *fils_pmkid,
+			   int status, gfp_t gfp,
+			   enum nl80211_timeout_reason timeout_reason)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
@@ -802,7 +813,8 @@ void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
 		}
 	}
 
-	ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);
+	ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len + fils_kek_len +
+		     fils_pmk_len + WLAN_PMKID_LEN, gfp);
 	if (!ev) {
 		cfg80211_put_bss(wdev->wiphy, bss);
 		return;
@@ -821,6 +833,26 @@ void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
 		ev->cr.resp_ie_len = resp_ie_len;
 		memcpy((void *)ev->cr.resp_ie, resp_ie, resp_ie_len);
 	}
+	if (fils_kek_len) {
+		ev->cr.kek = ((u8 *)ev) + sizeof(*ev) + req_ie_len +
+			     resp_ie_len;
+		ev->cr.kek_len = fils_kek_len;
+		memcpy((void *)ev->cr.kek, fils_kek, fils_kek_len);
+	}
+	if (fils_pmk_len) {
+		ev->cr.pmk = ((u8 *)ev) + sizeof(*ev) + req_ie_len +
+			     resp_ie_len + fils_kek_len;
+		ev->cr.pmk_len = fils_pmk_len;
+		memcpy((void *)ev->cr.pmk, fils_pmk, fils_pmk_len);
+	}
+	if (fils_pmkid) {
+		ev->cr.pmkid = ((u8 *)ev) + sizeof(*ev) + req_ie_len +
+			       resp_ie_len + fils_kek_len + fils_pmk_len;
+		memcpy((void *)ev->cr.pmkid, fils_pmkid, WLAN_PMKID_LEN);
+	}
+	ev->cr.update_erp_seq_num = update_erp_seq_num;
+	if (update_erp_seq_num)
+		ev->cr.fils_erp_seq_num = fils_erp_seq_num;
 	if (bss)
 		cfg80211_hold_bss(bss_from_pub(bss));
 	ev->cr.bss = bss;
@@ -832,7 +864,7 @@ void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
 	spin_unlock_irqrestore(&wdev->event_lock, flags);
 	queue_work(cfg80211_wq, &rdev->event_work);
 }
-EXPORT_SYMBOL(cfg80211_connect_bss);
+EXPORT_SYMBOL(cfg80211_connect_done);
 
 /* Consumes bss object one way or another */
 void __cfg80211_roamed(struct wireless_dev *wdev,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 737c9c2..78e004e 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -947,6 +947,10 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 				wdev->netdev, bssid,
 				ev->cr.req_ie, ev->cr.req_ie_len,
 				ev->cr.resp_ie, ev->cr.resp_ie_len,
+				ev->cr.kek, ev->cr.kek_len,
+				ev->cr.update_erp_seq_num,
+				ev->cr.fils_erp_seq_num,
+				ev->cr.pmk, ev->cr.pmk_len, ev->cr.pmkid,
 				ev->cr.status,
 				ev->cr.status == WLAN_STATUS_SUCCESS,
 				ev->cr.bss, ev->cr.timeout_reason);
-- 
2.7.4

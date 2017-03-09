Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8771 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753047AbdCIKKf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Mar 2017 05:10:35 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        "Kanchanapally, Vidyullatha" <vkanchan@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [RFC v2] cfg80211: Add support for FILS shared key authentication offload
Date: Thu, 9 Mar 2017 12:09:01 +0200
Message-ID: <1489054141-7848-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20170309_111059_861676_45113144)
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
 include/linux/ieee80211.h    |   9 +++
 include/net/cfg80211.h       | 143 ++++++++++++++++++++++++++++++++++---
 include/uapi/linux/nl80211.h |  86 ++++++++++++++++++++++-
 net/wireless/core.h          |  20 ++----
 net/wireless/mlme.c          |  20 +++---
 net/wireless/nl80211.c       | 116 +++++++++++++++++++++++++-----
 net/wireless/nl80211.h       |   7 +-
 net/wireless/sme.c           | 164 ++++++++++++++++++++++++++-----------------
 net/wireless/util.c          |  12 +---
 9 files changed, 442 insertions(+), 135 deletions(-)

v2:
- address comments from Johannes
  * add a new struct cfg80211_connect_resp_params to replace the long
    list of function parameters and use this within
    struct cfg80211_event as well
  * add a DOC: section describing flow and PMK use

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
index ffc0868..83845c5 100644
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
@@ -5136,6 +5167,78 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
 #endif
 
 /**
+ * struct cfg80211_connect_resp_params - Connection response params
+ * @status: status code, %WLAN_STATUS_SUCCESS for successful connection, use
+ *	%WLAN_STATUS_UNSPECIFIED_FAILURE if your device cannot give you
+ *	the real status code for failures. If this call is used to report a
+ *	failure due to a timeout (e.g., not receiving an Authentication frame
+ *	from the AP) instead of an explicit rejection by the AP, -1 is used to
+ *	indicate that this is a failure, but without a status code.
+ *	@timeout_reason is used to report the reason for the timeout in that
+ *	case.
+ * @bssid: the BSSID of the AP (all zeros if not set)
+ * @bss: entry of bss to which STA got connected to, can be obtained through
+ *	cfg80211_get_bss (may be %NULL). Only one parameter among @bssid and
+ *	@bss needs to be specified.
+ * @req_ie: association request IEs (may be %NULL)
+ * @req_ie_len: association request IEs length
+ * @resp_ie: association response IEs (may be %NULL)
+ * @resp_ie_len: assoc response IEs length
+ * @fils_kek: KEK derived from a successful FILS connection (may be %NULL)
+ * @fils_kek_len: length of @fils_kek in octets
+ * @update_erp_seq_num: Bool value to specify if the value in @fils_erp_seq_num
+ *	is valid.
+ * @fils_erp_seq_num: The last used ERP sequence number in FILS Authentication.
+ *	This value should be specified irrespective of the status for a FILS
+ *	connection.
+ * @pmk: A new PMK if derived from a successful FILS connection (may be %NULL).
+ * @pmk_len: Length of @pmk in octets.
+ * @pmkid: A new PMKID if derived from a successful FILS connection or the pmkid
+ *	used for this FILS connection (may be %NULL).
+ * @timeout_reason: reason for connection timeout. This is used when the
+ *	connection fails due to a timeout instead of an explicit rejection from
+ *	the AP. %NL80211_TIMEOUT_UNSPECIFIED is used when the timeout reason is
+ *	not known. This value is used only if @status < 0 to indicate that the
+ *	failure is due to a timeout and not due to explicit rejection by the AP.
+ *	This value is ignored in other cases (@status >= 0).
+ */
+struct cfg80211_connect_resp_params {
+	int status;
+	u8 bssid[ETH_ALEN];
+	struct cfg80211_bss *bss;
+	const u8 *req_ie;
+	size_t req_ie_len;
+	const u8 *resp_ie;
+	size_t resp_ie_len;
+	const u8 *fils_kek;
+	size_t fils_kek_len;
+	bool update_erp_seq_num;
+	u16 fils_erp_seq_num;
+	const u8 *pmk;
+	size_t pmk_len;
+	const u8 *pmkid;
+	enum nl80211_timeout_reason timeout_reason;
+};
+
+/**
+ * cfg80211_connect_done - notify cfg80211 of connection result
+ *
+ * @dev: network device
+ * @params: connection response parameters
+ * @gfp: allocation flags
+ *
+ * It should be called by the underlying driver once execution of the connection
+ * request from connect() has been completed. This is similar to
+ * cfg80211_connect_bss(), but with additional parameters that a user
+ * space should know to maintain a successful connection in case of FILS. Only
+ * one of the functions among cfg80211_connect_bss(), cfg80211_connect_result(),
+ * cfg80211_connect_timeout(), and cfg80211_connect_done() should be called.
+ */
+void cfg80211_connect_done(struct net_device *dev,
+			   struct cfg80211_connect_resp_params *params,
+			   gfp_t gfp);
+
+/**
  * cfg80211_connect_bss - notify cfg80211 of connection result
  *
  * @dev: network device
@@ -5165,13 +5268,32 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
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
+	struct cfg80211_connect_resp_params params;
+
+	memset(&params, 0, sizeof(params));
+	params.status = status;
+	if (bssid)
+		memcpy(params.bssid, bssid, ETH_ALEN);
+	params.bss = bss;
+	params.req_ie = req_ie;
+	params.req_ie_len = req_ie_len;
+	params.resp_ie = resp_ie;
+	params.resp_ie_len = resp_ie_len;
+	params.timeout_reason = timeout_reason;
+
+	cfg80211_connect_done(dev, &params, gfp);
+}
 
 /**
  * cfg80211_connect_result - notify cfg80211 of connection result
@@ -5190,7 +5312,8 @@ void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
  * It should be called by the underlying driver once execution of the connection
  * request from connect() has been completed. This is similar to
  * cfg80211_connect_bss() which allows the exact bss entry to be specified. Only
- * one of these functions should be called.
+ * one of the functions among cfg80211_connect_bss(), cfg80211_connect_result(),
+ * cfg80211_connect_timeout(), and cfg80211_connect_done() should be called.
  */
 static inline void
 cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
@@ -5217,7 +5340,9 @@ cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
  * in a sequence where no explicit authentication/association rejection was
  * received from the AP. This could happen, e.g., due to not being able to send
  * out the Authentication or Association Request frame or timing out while
- * waiting for the response.
+ * waiting for the response. Only one of the functions among
+ * cfg80211_connect_bss(), cfg80211_connect_result(),
+ * cfg80211_connect_timeout(), and cfg80211_connect_done() should be called.
  */
 static inline void
 cfg80211_connect_timeout(struct net_device *dev, const u8 *bssid,
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9a499b1..15c175c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -173,6 +173,42 @@
  */
 
 /**
+ * DOC: FILS shared key authentication offload
+ *
+ * FILS shared key authentication offload can be advertized by drivers by
+ * setting @NL80211_EXT_FEATURE_FILS_SK_OFFLOAD flag. The drivers that support
+ * FILS shared key authentication offload should be able to construct the
+ * authentication and association frames for FILS shared key authentication and
+ * eventually do a key derivation as per 802.11ai. The below additional
+ * parameters should be given to driver in %NL80211_CMD_CONNECT.
+ *	%NL80211_ATTR_FILS_ERP_USERNAME - used to construct keyname_nai
+ *	%NL80211_ATTR_FILS_ERP_REALM - used to construct keyname_nai
+ *	%NL80211_ATTR_FILS_ERP_SEQUENCE_NUM - used to construct erp message
+ *	%NL80211_ATTR_FILS_ERP_RRK - used to generate the rIK and rMSK
+ * rIK should be used to generate an authentication tag on the ERP message and
+ * rMSK should be used to derive a PMKSA.
+ * rIK, rMSK should be generated and keyname_nai, sequence number should be used
+ * as specified in IETF RFC 6696.
+ *
+ * When FILS shared key authentication is completed, driver needs to provide the
+ * below additional parameters to userspace.
+ *	%NL80211_ATTR_FILS_KEK - used for key renewal
+ *	%NL80211_ATTR_FILS_ERP_SEQUENCE_NUM - used in further EAP-RP exchanges
+ *	%NL80211_ATTR_PMKID - used to identify the PMKSA used/generated
+ *	%NL80211_ATTR_PMK - used to update PMKSA cache in userspace
+ * The PMKSA can be maintained in userspace persistently so that it can be used
+ * later after reboots or wifi turn off/on also.
+ *
+ * %NL80211_ATTR_FILS_CACHE_ID is the cache identifier advertized by a FILS
+ * capable AP supporting PMK caching. It specifies the scope within which the
+ * PMKSAs are cached in an ESS. %NL80211_CMD_SET_PMKSA and
+ * %NL80211_CMD_DEL_PMKSA are enhanced to allow support for PMKSA caching based
+ * on FILS cache identifier. Additionally %NL80211_ATTR_PMK is used with
+ * %NL80211_SET_PMKSA to specify the PMK corresponding to a PMKSA for driver to
+ * use in a FILS shared key connection with PMKSA caching.
+ */
+
+/**
  * enum nl80211_commands - supported nl80211 commands
  *
  * @NL80211_CMD_UNSPEC: unspecified command to catch errors
@@ -370,10 +406,18 @@
  * @NL80211_CMD_NEW_SURVEY_RESULTS: survey data notification (as a reply to
  *	NL80211_CMD_GET_SURVEY and on the "scan" multicast group)
  *
- * @NL80211_CMD_SET_PMKSA: Add a PMKSA cache entry, using %NL80211_ATTR_MAC
- *	(for the BSSID) and %NL80211_ATTR_PMKID.
+ * @NL80211_CMD_SET_PMKSA: Add a PMKSA cache entry using %NL80211_ATTR_MAC
+ *	(for the BSSID), %NL80211_ATTR_PMKID, and optionally %NL80211_ATTR_PMK
+ *	(PMK is used for PTKSA derivation in case of FILS shared key offload) or
+ *	using %NL80211_ATTR_SSID, %NL80211_ATTR_FILS_CACHE_ID,
+ *	%NL80211_ATTR_PMKID, and %NL80211_ATTR_PMK in case of FILS
+ *	authentication where %NL80211_ATTR_FILS_CACHE_ID is the identifier
+ *	advertized by a FILS capable AP identifying the scope of PMKSA in an
+ *	ESS.
  * @NL80211_CMD_DEL_PMKSA: Delete a PMKSA cache entry, using %NL80211_ATTR_MAC
- *	(for the BSSID) and %NL80211_ATTR_PMKID.
+ *	(for the BSSID) and %NL80211_ATTR_PMKID or using %NL80211_ATTR_SSID,
+ *	%NL80211_ATTR_FILS_CACHE_ID, and %NL80211_ATTR_PMKID in case of FILS
+ *	authentication.
  * @NL80211_CMD_FLUSH_PMKSA: Flush all PMKSA cache entries.
  *
  * @NL80211_CMD_REG_CHANGE: indicates to userspace the regulatory domain
@@ -2012,6 +2056,31 @@ enum nl80211_commands {
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
@@ -2423,6 +2492,14 @@ enum nl80211_attrs {
 
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
@@ -4759,6 +4836,8 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_CQM_RSSI_LIST: With this driver the
  *	%NL80211_ATTR_CQM_RSSI_THOLD attribute accepts a list of zero or more
  *	RSSI threshold values to monitor rather than exactly one threshold.
+ * @NL80211_EXT_FEATURE_FILS_SK_OFFLOAD: Driver SME supports FILS shared key
+ *	authentication with %NL80211_CMD_CONNECT.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4778,6 +4857,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA_CONNECTED,
 	NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI,
 	NL80211_EXT_FEATURE_CQM_RSSI_LIST,
+	NL80211_EXT_FEATURE_FILS_SK_OFFLOAD,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index efa690a..e8c8289 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -220,16 +220,7 @@ struct cfg80211_event {
 	enum cfg80211_event_type type;
 
 	union {
-		struct {
-			u8 bssid[ETH_ALEN];
-			const u8 *req_ie;
-			const u8 *resp_ie;
-			size_t req_ie_len;
-			size_t resp_ie_len;
-			struct cfg80211_bss *bss;
-			int status; /* -1 = failed; 0..65535 = status code */
-			enum nl80211_timeout_reason timeout_reason;
-		} cr;
+		struct cfg80211_connect_resp_params cr;
 		struct {
 			const u8 *req_ie;
 			const u8 *resp_ie;
@@ -392,12 +383,9 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 		     struct cfg80211_connect_params *connect,
 		     struct cfg80211_cached_keys *connkeys,
 		     const u8 *prev_bssid);
-void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
-			       const u8 *req_ie, size_t req_ie_len,
-			       const u8 *resp_ie, size_t resp_ie_len,
-			       int status, bool wextev,
-			       struct cfg80211_bss *bss,
-			       enum nl80211_timeout_reason timeout_reason);
+void __cfg80211_connect_result(struct net_device *dev,
+			       struct cfg80211_connect_resp_params *params,
+			       bool wextev);
 void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 			     size_t ie_len, u16 reason, bool from_ap);
 int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 22b3d99..3afe1a3 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -26,9 +26,16 @@ void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
-	u8 *ie = mgmt->u.assoc_resp.variable;
-	int ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
-	u16 status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
+	struct cfg80211_connect_resp_params cr;
+
+	memset(&cr, 0, sizeof(cr));
+	cr.status = (int)le16_to_cpu(mgmt->u.assoc_resp.status_code);
+	memcpy(cr.bssid, mgmt->bssid, ETH_ALEN);
+	cr.bss = bss;
+	cr.resp_ie = mgmt->u.assoc_resp.variable;
+	cr.resp_ie_len =
+		len - offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
+	cr.timeout_reason = NL80211_TIMEOUT_UNSPECIFIED;
 
 	trace_cfg80211_send_rx_assoc(dev, bss);
 
@@ -38,7 +45,7 @@ void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
 	 * and got a reject -- we only try again with an assoc
 	 * frame instead of reassoc.
 	 */
-	if (cfg80211_sme_rx_assoc_resp(wdev, status_code)) {
+	if (cfg80211_sme_rx_assoc_resp(wdev, cr.status)) {
 		cfg80211_unhold_bss(bss_from_pub(bss));
 		cfg80211_put_bss(wiphy, bss);
 		return;
@@ -46,10 +53,7 @@ void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
 
 	nl80211_send_rx_assoc(rdev, dev, buf, len, GFP_KERNEL, uapsd_queues);
 	/* update current_bss etc., consumes the bss reference */
-	__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, ie, len - ieoffs,
-				  status_code,
-				  status_code == WLAN_STATUS_SUCCESS, bss,
-				  NL80211_TIMEOUT_UNSPECIFIED);
+	__cfg80211_connect_result(dev, &cr, cr.status == WLAN_STATUS_SUCCESS);
 }
 EXPORT_SYMBOL(cfg80211_rx_assoc_resp);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d516527..f42190d8 100644
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
@@ -8874,6 +8896,35 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
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
+		kzfree(connkeys);
+		return -EINVAL;
+	}
+
 	wdev_lock(dev->ieee80211_ptr);
 
 	err = cfg80211_connect(rdev, dev, &connect, connkeys,
@@ -8993,14 +9044,28 @@ static int nl80211_setdel_pmksa(struct sk_buff *skb, struct genl_info *info)
 
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
@@ -13412,17 +13477,16 @@ void nl80211_send_assoc_timeout(struct cfg80211_registered_device *rdev,
 }
 
 void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
-				 struct net_device *netdev, const u8 *bssid,
-				 const u8 *req_ie, size_t req_ie_len,
-				 const u8 *resp_ie, size_t resp_ie_len,
-				 int status,
-				 enum nl80211_timeout_reason timeout_reason,
+				 struct net_device *netdev,
+				 struct cfg80211_connect_resp_params *cr,
 				 gfp_t gfp)
 {
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(100 + req_ie_len + resp_ie_len, gfp);
+	msg = nlmsg_new(100 + cr->req_ie_len + cr->resp_ie_len +
+			cr->fils_kek_len + cr->pmk_len +
+			(cr->pmkid ? WLAN_PMKID_LEN : 0), gfp);
 	if (!msg)
 		return;
 
@@ -13434,17 +13498,31 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
 	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
-	    (bssid && nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, bssid)) ||
+	    (cr->bssid &&
+	     nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, cr->bssid)) ||
 	    nla_put_u16(msg, NL80211_ATTR_STATUS_CODE,
-			status < 0 ? WLAN_STATUS_UNSPECIFIED_FAILURE :
-			status) ||
-	    (status < 0 &&
+			cr->status < 0 ? WLAN_STATUS_UNSPECIFIED_FAILURE :
+			cr->status) ||
+	    (cr->status < 0 &&
 	     (nla_put_flag(msg, NL80211_ATTR_TIMED_OUT) ||
-	      nla_put_u32(msg, NL80211_ATTR_TIMEOUT_REASON, timeout_reason))) ||
-	    (req_ie &&
-	     nla_put(msg, NL80211_ATTR_REQ_IE, req_ie_len, req_ie)) ||
-	    (resp_ie &&
-	     nla_put(msg, NL80211_ATTR_RESP_IE, resp_ie_len, resp_ie)))
+	      nla_put_u32(msg, NL80211_ATTR_TIMEOUT_REASON,
+			  cr->timeout_reason))) ||
+	    (cr->req_ie &&
+	     nla_put(msg, NL80211_ATTR_REQ_IE, cr->req_ie_len, cr->req_ie)) ||
+	    (cr->resp_ie &&
+	     nla_put(msg, NL80211_ATTR_RESP_IE, cr->resp_ie_len,
+		     cr->resp_ie)) ||
+	    (cr->update_erp_seq_num &&
+	     nla_put_u16(msg, NL80211_ATTR_FILS_ERP_SEQUENCE_NUM,
+			 cr->fils_erp_seq_num)) ||
+	    (cr->status == WLAN_STATUS_SUCCESS &&
+	     ((cr->fils_kek &&
+	       nla_put(msg, NL80211_ATTR_FILS_KEK, cr->fils_kek_len,
+		       cr->fils_kek)) ||
+	      (cr->pmk &&
+	       nla_put(msg, NL80211_ATTR_PMK, cr->pmk_len, cr->pmk)) ||
+	      (cr->pmkid &&
+	       nla_put(msg, NL80211_ATTR_PMKID, WLAN_PMKID_LEN, cr->pmkid)))))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index e488dca..3cb17cd 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -53,11 +53,8 @@ void nl80211_send_assoc_timeout(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev,
 				const u8 *addr, gfp_t gfp);
 void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
-				 struct net_device *netdev, const u8 *bssid,
-				 const u8 *req_ie, size_t req_ie_len,
-				 const u8 *resp_ie, size_t resp_ie_len,
-				 int status,
-				 enum nl80211_timeout_reason timeout_reason,
+				 struct net_device *netdev,
+				 struct cfg80211_connect_resp_params *params,
 				 gfp_t gfp);
 void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
 			 struct net_device *netdev, const u8 *bssid,
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index b347e63..3f57a54 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -253,10 +253,14 @@ void cfg80211_conn_work(struct work_struct *work)
 		}
 		treason = NL80211_TIMEOUT_UNSPECIFIED;
 		if (cfg80211_conn_do_work(wdev, &treason)) {
-			__cfg80211_connect_result(
-					wdev->netdev, bssid,
-					NULL, 0, NULL, 0, -1, false, NULL,
-					treason);
+			struct cfg80211_connect_resp_params cr;
+
+			memset(&cr, 0, sizeof(cr));
+			cr.status = -1;
+			if (bssid)
+				memcpy(cr.bssid, bssid, ETH_ALEN);
+			cr.timeout_reason = treason;
+			__cfg80211_connect_result(wdev->netdev, &cr, false);
 		}
 		wdev_unlock(wdev);
 	}
@@ -359,10 +363,13 @@ void cfg80211_sme_rx_auth(struct wireless_dev *wdev, const u8 *buf, size_t len)
 		wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
 		schedule_work(&rdev->conn_work);
 	} else if (status_code != WLAN_STATUS_SUCCESS) {
-		__cfg80211_connect_result(wdev->netdev, mgmt->bssid,
-					  NULL, 0, NULL, 0,
-					  status_code, false, NULL,
-					  NL80211_TIMEOUT_UNSPECIFIED);
+		struct cfg80211_connect_resp_params cr;
+
+		memset(&cr, 0, sizeof(cr));
+		cr.status = status_code;
+		memcpy(cr.bssid, mgmt->bssid, ETH_ALEN);
+		cr.timeout_reason = NL80211_TIMEOUT_UNSPECIFIED;
+		__cfg80211_connect_result(wdev->netdev, &cr, false);
 	} else if (wdev->conn->state == CFG80211_CONN_AUTHENTICATING) {
 		wdev->conn->state = CFG80211_CONN_ASSOCIATE_NEXT;
 		schedule_work(&rdev->conn_work);
@@ -669,49 +676,50 @@ static DECLARE_WORK(cfg80211_disconnect_work, disconnect_work);
  */
 
 /* This method must consume bss one way or another */
-void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
-			       const u8 *req_ie, size_t req_ie_len,
-			       const u8 *resp_ie, size_t resp_ie_len,
-			       int status, bool wextev,
-			       struct cfg80211_bss *bss,
-			       enum nl80211_timeout_reason timeout_reason)
+void __cfg80211_connect_result(struct net_device *dev,
+			       struct cfg80211_connect_resp_params *cr,
+			       bool wextev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	const u8 *country_ie;
 #ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 #endif
+	const u8 *bssid = NULL;
 
 	ASSERT_WDEV_LOCK(wdev);
 
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
 		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)) {
-		cfg80211_put_bss(wdev->wiphy, bss);
+		cfg80211_put_bss(wdev->wiphy, cr->bss);
 		return;
 	}
 
-	nl80211_send_connect_result(wiphy_to_rdev(wdev->wiphy), dev,
-				    bssid, req_ie, req_ie_len,
-				    resp_ie, resp_ie_len,
-				    status, timeout_reason, GFP_KERNEL);
+	if (!is_zero_ether_addr(cr->bssid))
+		bssid = cr->bssid;
+
+	nl80211_send_connect_result(wiphy_to_rdev(wdev->wiphy), dev, cr,
+				    GFP_KERNEL);
 
 #ifdef CONFIG_CFG80211_WEXT
 	if (wextev) {
-		if (req_ie && status == WLAN_STATUS_SUCCESS) {
+		if (cr->req_ie && cr->status == WLAN_STATUS_SUCCESS) {
 			memset(&wrqu, 0, sizeof(wrqu));
-			wrqu.data.length = req_ie_len;
-			wireless_send_event(dev, IWEVASSOCREQIE, &wrqu, req_ie);
+			wrqu.data.length = cr->req_ie_len;
+			wireless_send_event(dev, IWEVASSOCREQIE, &wrqu,
+					    cr->req_ie);
 		}
 
-		if (resp_ie && status == WLAN_STATUS_SUCCESS) {
+		if (cr->resp_ie && cr->status == WLAN_STATUS_SUCCESS) {
 			memset(&wrqu, 0, sizeof(wrqu));
-			wrqu.data.length = resp_ie_len;
-			wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, resp_ie);
+			wrqu.data.length = cr->resp_ie_len;
+			wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu,
+					    cr->resp_ie);
 		}
 
 		memset(&wrqu, 0, sizeof(wrqu));
 		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-		if (bssid && status == WLAN_STATUS_SUCCESS) {
+		if (bssid && cr->status == WLAN_STATUS_SUCCESS) {
 			memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
 			memcpy(wdev->wext.prev_bssid, bssid, ETH_ALEN);
 			wdev->wext.prev_bssid_valid = true;
@@ -720,14 +728,14 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 	}
 #endif
 
-	if (!bss && (status == WLAN_STATUS_SUCCESS)) {
+	if (!cr->bss && (cr->status == WLAN_STATUS_SUCCESS)) {
 		WARN_ON_ONCE(!wiphy_to_rdev(wdev->wiphy)->ops->connect);
-		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
-				       wdev->ssid, wdev->ssid_len,
-				       wdev->conn_bss_type,
-				       IEEE80211_PRIVACY_ANY);
-		if (bss)
-			cfg80211_hold_bss(bss_from_pub(bss));
+		cr->bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
+					   wdev->ssid, wdev->ssid_len,
+					   wdev->conn_bss_type,
+					   IEEE80211_PRIVACY_ANY);
+		if (cr->bss)
+			cfg80211_hold_bss(bss_from_pub(cr->bss));
 	}
 
 	if (wdev->current_bss) {
@@ -736,29 +744,29 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 		wdev->current_bss = NULL;
 	}
 
-	if (status != WLAN_STATUS_SUCCESS) {
+	if (cr->status != WLAN_STATUS_SUCCESS) {
 		kzfree(wdev->connect_keys);
 		wdev->connect_keys = NULL;
 		wdev->ssid_len = 0;
 		wdev->conn_owner_nlportid = 0;
-		if (bss) {
-			cfg80211_unhold_bss(bss_from_pub(bss));
-			cfg80211_put_bss(wdev->wiphy, bss);
+		if (cr->bss) {
+			cfg80211_unhold_bss(bss_from_pub(cr->bss));
+			cfg80211_put_bss(wdev->wiphy, cr->bss);
 		}
 		cfg80211_sme_free(wdev);
 		return;
 	}
 
-	if (WARN_ON(!bss))
+	if (WARN_ON(!cr->bss))
 		return;
 
-	wdev->current_bss = bss_from_pub(bss);
+	wdev->current_bss = bss_from_pub(cr->bss);
 
 	if (!(wdev->wiphy->flags & WIPHY_FLAG_HAS_STATIC_WEP))
 		cfg80211_upload_connect_keys(wdev);
 
 	rcu_read_lock();
-	country_ie = ieee80211_bss_get_ie(bss, WLAN_EID_COUNTRY);
+	country_ie = ieee80211_bss_get_ie(cr->bss, WLAN_EID_COUNTRY);
 	if (!country_ie) {
 		rcu_read_unlock();
 		return;
@@ -775,64 +783,88 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 	 * - country_ie + 2, the start of the country ie data, and
 	 * - and country_ie[1] which is the IE length
 	 */
-	regulatory_hint_country_ie(wdev->wiphy, bss->channel->band,
+	regulatory_hint_country_ie(wdev->wiphy, cr->bss->channel->band,
 				   country_ie + 2, country_ie[1]);
 	kfree(country_ie);
 }
 
 /* Consumes bss object one way or another */
-void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
-			  struct cfg80211_bss *bss, const u8 *req_ie,
-			  size_t req_ie_len, const u8 *resp_ie,
-			  size_t resp_ie_len, int status, gfp_t gfp,
-			  enum nl80211_timeout_reason timeout_reason)
+void cfg80211_connect_done(struct net_device *dev,
+			   struct cfg80211_connect_resp_params *params,
+			   gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_event *ev;
 	unsigned long flags;
 
-	if (bss) {
+	if (params->bss) {
 		/* Make sure the bss entry provided by the driver is valid. */
-		struct cfg80211_internal_bss *ibss = bss_from_pub(bss);
+		struct cfg80211_internal_bss *ibss = bss_from_pub(params->bss);
 
 		if (WARN_ON(list_empty(&ibss->list))) {
-			cfg80211_put_bss(wdev->wiphy, bss);
+			cfg80211_put_bss(wdev->wiphy, params->bss);
 			return;
 		}
 	}
 
-	ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);
+	ev = kzalloc(sizeof(*ev) + params->req_ie_len + params->resp_ie_len +
+		     params->fils_kek_len + params->pmk_len +
+		     (params->pmkid ? WLAN_PMKID_LEN : 0),
+		     gfp);
 	if (!ev) {
-		cfg80211_put_bss(wdev->wiphy, bss);
+		cfg80211_put_bss(wdev->wiphy, params->bss);
 		return;
 	}
 
 	ev->type = EVENT_CONNECT_RESULT;
-	if (bssid)
-		memcpy(ev->cr.bssid, bssid, ETH_ALEN);
-	if (req_ie_len) {
+	memcpy(ev->cr.bssid, params->bssid, ETH_ALEN);
+	if (params->req_ie_len) {
 		ev->cr.req_ie = ((u8 *)ev) + sizeof(*ev);
-		ev->cr.req_ie_len = req_ie_len;
-		memcpy((void *)ev->cr.req_ie, req_ie, req_ie_len);
+		ev->cr.req_ie_len = params->req_ie_len;
+		memcpy((void *)ev->cr.req_ie, params->req_ie,
+		       params->req_ie_len);
 	}
-	if (resp_ie_len) {
-		ev->cr.resp_ie = ((u8 *)ev) + sizeof(*ev) + req_ie_len;
-		ev->cr.resp_ie_len = resp_ie_len;
-		memcpy((void *)ev->cr.resp_ie, resp_ie, resp_ie_len);
+	if (params->resp_ie_len) {
+		ev->cr.resp_ie = ((u8 *)ev) + sizeof(*ev) + params->req_ie_len;
+		ev->cr.resp_ie_len = params->resp_ie_len;
+		memcpy((void *)ev->cr.resp_ie, params->resp_ie,
+		       params->resp_ie_len);
 	}
-	if (bss)
-		cfg80211_hold_bss(bss_from_pub(bss));
-	ev->cr.bss = bss;
-	ev->cr.status = status;
-	ev->cr.timeout_reason = timeout_reason;
+	if (params->fils_kek_len) {
+		ev->cr.fils_kek = ((u8 *)ev) + sizeof(*ev) +
+				  params->req_ie_len + params->resp_ie_len;
+		ev->cr.fils_kek_len = params->fils_kek_len;
+		memcpy((void *)ev->cr.fils_kek, params->fils_kek,
+		       params->fils_kek_len);
+	}
+	if (params->pmk_len) {
+		ev->cr.pmk = ((u8 *)ev) + sizeof(*ev) + params->req_ie_len +
+			     params->resp_ie_len + params->fils_kek_len;
+		ev->cr.pmk_len = params->pmk_len;
+		memcpy((void *)ev->cr.pmk, params->pmk, params->pmk_len);
+	}
+	if (params->pmkid) {
+		ev->cr.pmkid = ((u8 *)ev) + sizeof(*ev) + params->req_ie_len +
+			       params->resp_ie_len + params->fils_kek_len +
+			       params->pmk_len;
+		memcpy((void *)ev->cr.pmkid, params->pmkid, WLAN_PMKID_LEN);
+	}
+	ev->cr.update_erp_seq_num = params->update_erp_seq_num;
+	if (params->update_erp_seq_num)
+		ev->cr.fils_erp_seq_num = params->fils_erp_seq_num;
+	if (params->bss)
+		cfg80211_hold_bss(bss_from_pub(params->bss));
+	ev->cr.bss = params->bss;
+	ev->cr.status = params->status;
+	ev->cr.timeout_reason = params->timeout_reason;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
 	spin_unlock_irqrestore(&wdev->event_lock, flags);
 	queue_work(cfg80211_wq, &rdev->event_work);
 }
-EXPORT_SYMBOL(cfg80211_connect_bss);
+EXPORT_SYMBOL(cfg80211_connect_done);
 
 /* Consumes bss object one way or another */
 void __cfg80211_roamed(struct wireless_dev *wdev,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 737c9c2..8d6a0a7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -929,7 +929,6 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 {
 	struct cfg80211_event *ev;
 	unsigned long flags;
-	const u8 *bssid = NULL;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	while (!list_empty(&wdev->event_list)) {
@@ -941,15 +940,10 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 		wdev_lock(wdev);
 		switch (ev->type) {
 		case EVENT_CONNECT_RESULT:
-			if (!is_zero_ether_addr(ev->cr.bssid))
-				bssid = ev->cr.bssid;
 			__cfg80211_connect_result(
-				wdev->netdev, bssid,
-				ev->cr.req_ie, ev->cr.req_ie_len,
-				ev->cr.resp_ie, ev->cr.resp_ie_len,
-				ev->cr.status,
-				ev->cr.status == WLAN_STATUS_SUCCESS,
-				ev->cr.bss, ev->cr.timeout_reason);
+				wdev->netdev,
+				&ev->cr,
+				ev->cr.status == WLAN_STATUS_SUCCESS);
 			break;
 		case EVENT_ROAMED:
 			__cfg80211_roamed(wdev, ev->rm.bss, ev->rm.req_ie,
-- 
2.7.4

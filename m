Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3550 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2HLL2W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2012 07:28:22 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2] cfg80211: Support for 4-way handshake offloading for WPA2-Personal
Date: Sun, 12 Aug 2012 14:28:04 +0300
Message-ID: <1344770884-17102-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120812_132825_575696_1F8A75AC)
In-Reply-To: <1344770884-17102-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1344770884-17102-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Traditionally, WPA supplicant handle 4-way handshake and do all key derivation.
First, PSK calculated from the passphrase and SSID.
Finally, PTK supplied to the driver with add_key()

For firmware to implement offload, it need PSK.
In case of WPA2-Personal, PSK is available on the connect()/start_ap() time.

In case of WPS2-Enterprise, the PSK will be available only after the EAP authentication,
this is not addressed with this patch.

Based on code from
Rishi Panjwani <rpanjwan@qca.qualcomm.com>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 include/linux/ieee80211.h |    2 ++
 include/linux/nl80211.h   |   19 +++++++++++++++++++
 include/net/cfg80211.h    |   10 ++++++++++
 net/wireless/nl80211.c    |   16 ++++++++++++++++
 4 files changed, 47 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index e02fc68..95aafb3 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1787,6 +1787,8 @@ enum ieee80211_sa_query_action {
 
 #define WLAN_PMKID_LEN			16
 
+#define WLAN_PSK_LEN			32
+
 #define WLAN_OUI_WFA			0x506f9a
 #define WLAN_OUI_TYPE_WFA_P2P		9
 #define WLAN_OUI_MICROSOFT		0x0050f2
diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 2f38788..64f01a3 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1251,6 +1251,21 @@ enum nl80211_commands {
  *	was used to provide the hint. For the different types of
  *	allowed user regulatory hints see nl80211_user_reg_hint_type.
  *
+ * @NL80211_ATTR_4WAY_HANDSHAKE_OFFLOAD_STA: This is a flag that indicates to
+ *	WPA supplicant that 4-way handshake has been offloaded to the firmware
+ *	in the STA mode.
+ *	In this case, WPA supplicant will provide driver with PSK for
+ *	connect()
+ *
+ * @NL80211_ATTR_4WAY_HANDSHAKE_OFFLOAD_AP: This is a flag that indicates to
+ *	WPA supplicant that 4-way handshake has been offloaded to the firmware
+ *	in the AP mode.
+ *	In this case, WPA supplicant will provide driver with PSK for
+ *	start_ap()
+ *
+ * @NL80211_ATTR_PSK: The PSK calculated by WPA supplicant
+ *	length is WLAN_PSK_LEN (32) bytes
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1506,6 +1521,10 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_USER_REG_HINT_TYPE,
 
+	NL80211_ATTR_4WAY_HANDSHAKE_OFFLOAD_STA,
+	NL80211_ATTR_4WAY_HANDSHAKE_OFFLOAD_AP,
+	NL80211_ATTR_PSK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3d254e1..2b70ee2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -438,6 +438,7 @@ struct cfg80211_beacon_data {
  * @privacy: the BSS uses privacy
  * @auth_type: Authentication type (algorithm)
  * @inactivity_timeout: time in seconds to determine station's inactivity.
+ * @psk: The PSK that has been calculated by WPA supplicant
  */
 struct cfg80211_ap_settings {
 	struct ieee80211_channel *channel;
@@ -453,6 +454,7 @@ struct cfg80211_ap_settings {
 	bool privacy;
 	enum nl80211_auth_type auth_type;
 	int inactivity_timeout;
+	const u8 *psk;
 };
 
 /**
@@ -1307,6 +1309,7 @@ struct cfg80211_ibss_params {
  * @ht_capa:  HT Capabilities over-rides.  Values set in ht_capa_mask
  *   will be used in ht_capa.  Un-supported values will be ignored.
  * @ht_capa_mask:  The bits of ht_capa which are to be used.
+ * @psk: The PSK that has been calculated by WPA supplicant
  */
 struct cfg80211_connect_params {
 	struct ieee80211_channel *channel;
@@ -1324,6 +1327,7 @@ struct cfg80211_connect_params {
 	int bg_scan_period;
 	struct ieee80211_ht_cap ht_capa;
 	struct ieee80211_ht_cap ht_capa_mask;
+	const u8 *psk;
 };
 
 /**
@@ -1898,6 +1902,10 @@ struct cfg80211_ops {
  *	responds to probe-requests in hardware.
  * @WIPHY_FLAG_OFFCHAN_TX: Device supports direct off-channel TX.
  * @WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL: Device supports remain-on-channel call.
+ * @WIPHY_FLAG_4WAY_HANDSHAKE_OFFLOAD_STA: Device supports
+ *	4-way handshake offload in STA mode.
+ * @WIPHY_FLAG_4WAY_HANDSHAKE_OFFLOAD_AP: Device supports
+ *	4-way handshake offload in AP mode.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1921,6 +1929,8 @@ enum wiphy_flags {
 	WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD	= BIT(19),
 	WIPHY_FLAG_OFFCHAN_TX			= BIT(20),
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
+	WIPHY_FLAG_4WAY_HANDSHAKE_OFFLOAD_STA	= BIT(22),
+	WIPHY_FLAG_4WAY_HANDSHAKE_OFFLOAD_AP	= BIT(23),
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 97026f3..c74f01f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -355,6 +355,10 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
 	[NL80211_ATTR_WDEV] = { .type = NLA_U64 },
 	[NL80211_ATTR_USER_REG_HINT_TYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_4WAY_HANDSHAKE_OFFLOAD_STA] = { .type = NLA_FLAG },
+	[NL80211_ATTR_4WAY_HANDSHAKE_OFFLOAD_AP] = { .type = NLA_FLAG },
+	[NL80211_ATTR_PSK] = { .type = NLA_BINARY,
+			       .len = WLAN_PSK_LEN },
 };
 
 /* policy for the key attributes */
@@ -914,6 +918,12 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	if ((dev->wiphy.flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP) &&
 	    nla_put_flag(msg, NL80211_ATTR_TDLS_EXTERNAL_SETUP))
 		goto nla_put_failure;
+	if ((dev->wiphy.flags & WIPHY_FLAG_4WAY_HANDSHAKE_OFFLOAD_STA) &&
+	    nla_put_flag(msg, NL80211_ATTR_4WAY_HANDSHAKE_OFFLOAD_STA))
+		goto nla_put_failure;
+	if ((dev->wiphy.flags & WIPHY_FLAG_4WAY_HANDSHAKE_OFFLOAD_AP) &&
+	    nla_put_flag(msg, NL80211_ATTR_4WAY_HANDSHAKE_OFFLOAD_AP))
+		goto nla_put_failure;
 
 	if (nla_put(msg, NL80211_ATTR_CIPHER_SUITES,
 		    sizeof(u32) * dev->wiphy.n_cipher_suites,
@@ -2576,6 +2586,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 					  params.channel_type))
 		return -EINVAL;
 
+	if (info->attrs[NL80211_ATTR_PSK])
+		params.psk = nla_data(info->attrs[NL80211_ATTR_PSK]);
+
 	mutex_lock(&rdev->devlist_mtx);
 	err = cfg80211_can_use_chan(rdev, wdev, params.channel,
 				    CHAN_MODE_SHARED);
@@ -5640,6 +5653,9 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		       sizeof(connect.ht_capa));
 	}
 
+	if (info->attrs[NL80211_ATTR_PSK])
+		connect.psk = nla_data(info->attrs[NL80211_ATTR_PSK]);
+
 	err = cfg80211_connect(rdev, dev, &connect, connkeys);
 	if (err)
 		kfree(connkeys);
-- 
1.7.9.5


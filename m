Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:63505 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab3AOPQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2013 10:16:03 -0500
Date: Tue, 15 Jan 2013 17:15:57 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Allow use_mfp to be specified with the connect
 command
Message-ID: <20130115151557.GA17318@jouni.qca.qualcomm.com> (sfid-20130115_161608_548595_542DD271)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The NL80211_ATTR_USE_MFP attribute was originally added for
NL80211_CMD_ASSOCIATE, but it is actually as useful (if not even more
useful) with NL80211_CMD_CONNECT, so process that attribute with the
connect command, too.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       |    2 ++
 include/uapi/linux/nl80211.h |    6 +++---
 net/wireless/nl80211.c       |    8 ++++++++
 net/wireless/sme.c           |    3 ++-
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e5f085c..e870612 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1434,6 +1434,7 @@ struct cfg80211_ibss_params {
  * @ie: IEs for association request
  * @ie_len: Length of assoc_ie in octets
  * @privacy: indicates whether privacy-enabled APs should be used
+ * @mfp: indicate whether management frame protection is used
  * @crypto: crypto settings
  * @key_len: length of WEP key for shared key authentication
  * @key_idx: index of WEP key for shared key authentication
@@ -1454,6 +1455,7 @@ struct cfg80211_connect_params {
 	u8 *ie;
 	size_t ie_len;
 	bool privacy;
+	enum nl80211_mfp mfp;
 	struct cfg80211_crypto_settings crypto;
 	const u8 *key;
 	u8 key_len, key_idx;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5470171..81c0c34 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -374,8 +374,8 @@
  *	requests to connect to a specified network but without separating
  *	auth and assoc steps. For this, you need to specify the SSID in a
  *	%NL80211_ATTR_SSID attribute, and can optionally specify the association
- *	IEs in %NL80211_ATTR_IE, %NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_MAC,
- *	%NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
+ *	IEs in %NL80211_ATTR_IE, %NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_USE_MFP,
+ *	%NL80211_ATTR_MAC, %NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
  *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE and
  *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.
  *	Background scan period can optionally be
@@ -958,7 +958,7 @@ enum nl80211_commands {
  * @NL80211_ATTR_USE_MFP: Whether management frame protection (IEEE 802.11w) is
  *	used for the association (&enum nl80211_mfp, represented as a u32);
  *	this attribute can be used
- *	with %NL80211_CMD_ASSOCIATE request
+ *	with %NL80211_CMD_ASSOCIATE and %NL80211_CMD_CONNECT requests
  *
  * @NL80211_ATTR_STA_FLAGS2: Attribute containing a
  *	&struct nl80211_sta_flag_update.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9bd8340..07136fa 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5875,6 +5875,14 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		connect.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
+	if (info->attrs[NL80211_ATTR_USE_MFP]) {
+		connect.mfp = nla_get_u32(info->attrs[NL80211_ATTR_USE_MFP]);
+		if (connect.mfp != NL80211_MFP_REQUIRED &&
+		    connect.mfp != NL80211_MFP_NO)
+			return -EINVAL;
+	} else
+		connect.mfp = NL80211_MFP_NO;
+
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
 		connect.channel =
 			ieee80211_get_channel(wiphy,
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index d2d2651..a825dfe 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -192,7 +192,8 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 					    prev_bssid,
 					    params->ssid, params->ssid_len,
 					    params->ie, params->ie_len,
-					    false, &params->crypto,
+					    params->mfp != NL80211_MFP_NO,
+					    &params->crypto,
 					    params->flags, &params->ht_capa,
 					    &params->ht_capa_mask);
 		if (err)
-- 
1.7.9.5

-- 
Jouni Malinen                                            PGP id EFC895FA

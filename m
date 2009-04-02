Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZDBSOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 14:14:43 -0400
Subject: [PATCH] cfg80211: add cipher capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 20:14:06 +0200
Message-Id: <1238696046.5445.2.camel@johannes.local> (sfid-20090402_201446_592814_464353F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the necessary code and fields to let drivers specify
their cipher capabilities and exports them to userspace. Also
update mac80211 to export the ciphers it has.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/nl80211.h |    4 ++++
 include/net/wireless.h  |    5 +++++
 net/mac80211/main.c     |   14 ++++++++++++++
 net/wireless/nl80211.c  |   14 +++++++++++++-
 4 files changed, 36 insertions(+), 1 deletion(-)

--- wireless-testing.orig/include/net/wireless.h	2009-04-02 19:55:48.000000000 +0200
+++ wireless-testing/include/net/wireless.h	2009-04-02 19:56:15.000000000 +0200
@@ -205,6 +205,8 @@ struct ieee80211_supported_band {
  *	on the reg_notifier() if it chooses to ignore future
  *	regulatory domain changes caused by other drivers.
  * @signal_type: signal type reported in &struct cfg80211_bss.
+ * @cipher_suites: supported cipher suites
+ * @n_cipher_suites: number of supported cipher suites
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -224,6 +226,9 @@ struct wiphy {
 	u8 max_scan_ssids;
 	u16 max_scan_ie_len;
 
+	int n_cipher_suites;
+	const u32 *cipher_suites;
+
 	/* If multiple wiphys are registered and you're handed e.g.
 	 * a regular netdev with assigned ieee80211_ptr, you won't
 	 * know whether it points to a wiphy your driver has registered
--- wireless-testing.orig/net/wireless/nl80211.c	2009-04-02 19:56:12.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-04-02 19:56:15.000000000 +0200
@@ -184,6 +184,10 @@ static int nl80211_send_wiphy(struct sk_
 	NLA_PUT_U16(msg, NL80211_ATTR_MAX_SCAN_IE_LEN,
 		    dev->wiphy.max_scan_ie_len);
 
+	NLA_PUT(msg, NL80211_ATTR_CIPHER_SUITES,
+		sizeof(u32) * dev->wiphy.n_cipher_suites,
+		dev->wiphy.cipher_suites);
+
 	nl_modes = nla_nest_start(msg, NL80211_ATTR_SUPPORTED_IFTYPES);
 	if (!nl_modes)
 		goto nla_put_failure;
@@ -966,7 +970,7 @@ static int nl80211_set_key(struct sk_buf
 static int nl80211_new_key(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
-	int err;
+	int err, i;
 	struct net_device *dev;
 	struct key_params params;
 	u8 key_idx = 0;
@@ -1035,6 +1039,14 @@ static int nl80211_new_key(struct sk_buf
 	if (err)
 		goto unlock_rtnl;
 
+	for (i = 0; i < drv->wiphy.n_cipher_suites; i++)
+		if (params.cipher == drv->wiphy.cipher_suites[i])
+			break;
+	if (i == drv->wiphy.n_cipher_suites) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (!drv->ops->add_key) {
 		err = -EOPNOTSUPP;
 		goto out;
--- wireless-testing.orig/net/mac80211/main.c	2009-04-02 19:55:48.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-04-02 19:56:15.000000000 +0200
@@ -823,6 +823,15 @@ int ieee80211_register_hw(struct ieee802
 	struct ieee80211_master_priv *mpriv;
 	int channels, i, j, max_bitrates;
 	bool supp_ht;
+	static const u32 cipher_suites[] = {
+		WLAN_CIPHER_SUITE_WEP40,
+		WLAN_CIPHER_SUITE_WEP104,
+		WLAN_CIPHER_SUITE_TKIP,
+		WLAN_CIPHER_SUITE_CCMP,
+
+		/* keep last -- depends on hw flags! */
+		WLAN_CIPHER_SUITE_AES_CMAC
+	};
 
 	/*
 	 * generic code guarantees at least one band,
@@ -894,6 +903,11 @@ int ieee80211_register_hw(struct ieee802
 	if (local->hw.wiphy->max_scan_ie_len)
 		local->hw.wiphy->max_scan_ie_len -= local->scan_ies_len;
 
+	local->hw.wiphy->cipher_suites = cipher_suites;
+	local->hw.wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
+	if (!(local->hw.flags & IEEE80211_HW_MFP_CAPABLE))
+		local->hw.wiphy->n_cipher_suites--;
+
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
 		goto fail_wiphy_register;
--- wireless-testing.orig/include/linux/nl80211.h	2009-04-02 19:55:48.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2009-04-02 19:56:15.000000000 +0200
@@ -410,6 +410,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_REASON_CODE: ReasonCode for %NL80211_CMD_DEAUTHENTICATE and
  *	%NL80211_CMD_DISASSOCIATE, u16
  *
+ * @NL80211_ATTR_CIPHER_SUITES: a set of u32 values indicating the supported
+ *	cipher suites
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -495,6 +498,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_REASON_CODE,
 
 	NL80211_ATTR_MAX_SCAN_IE_LEN,
+	NL80211_ATTR_CIPHER_SUITES,
 
 	/* add attributes here, update the policy in nl80211.c */
 



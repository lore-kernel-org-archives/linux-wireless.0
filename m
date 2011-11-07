Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42237 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab1KGLjj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 06:39:39 -0500
Subject: [PATCH v3 05/12] nl80211: advertise device AP SME
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <anamtsov@gmail.com>
In-Reply-To: <20111104101943.704950080@sipsolutions.net> (sfid-20111104_112124_699843_CC5758F6)
References: <20111104101809.711636760@sipsolutions.net>
	 <20111104101943.704950080@sipsolutions.net>
	 (sfid-20111104_112124_699843_CC5758F6)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Nov 2011 12:39:33 +0100
Message-ID: <1320665973.3993.37.camel@jlt3.sipsolutions.net> (sfid-20111107_123942_666439_C85A5C55)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add the ability to advertise that the device
contains the AP SME and what features it can
support. There are currently no features in
the bitmap -- probe response offload will be
advertised by a few patches Arik is working
on now (who took over from Guy Eilam) and a
device with AP SME will typically implement
and require response offload.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: fix attribute name (thanks Eliad)
v3: remove WSC bit

 drivers/net/wireless/ath/ath6kl/init.c |    3 ++-
 include/linux/nl80211.h                |   15 +++++++++++++++
 include/net/cfg80211.h                 |    6 ++++++
 net/wireless/core.c                    |    4 ++++
 net/wireless/nl80211.c                 |    4 ++++
 5 files changed, 31 insertions(+), 1 deletion(-)

--- a/include/linux/nl80211.h	2011-11-04 11:21:17.000000000 +0100
+++ b/include/linux/nl80211.h	2011-11-07 12:35:59.000000000 +0100
@@ -1121,6 +1121,11 @@ enum nl80211_commands {
  *	%NL80211_CMD_TDLS_MGMT. Otherwise %NL80211_CMD_TDLS_OPER should be
  *	used for asking the driver to perform a TDLS operation.
  *
+ * @NL80211_ATTR_DEVICE_AP_SME: This u32 attribute may be listed for devices
+ *	that have AP support to indicate that they have the AP SME integrated
+ *	with support for the features listed in this attribute, see
+ *	&enum nl80211_ap_sme_features.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1349,6 +1354,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_TDLS_SUPPORT,
 	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
 
+	NL80211_ATTR_DEVICE_AP_SME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2662,4 +2669,12 @@ enum nl80211_tdls_operation {
 	NL80211_TDLS_DISABLE_LINK,
 };
 
+/*
+ * enum nl80211_ap_sme_features - device-integrated AP features
+ * Reserved for future use, no bits are defined in
+ * NL80211_ATTR_DEVICE_AP_SME yet.
+enum nl80211_ap_sme_features {
+};
+ */
+
 #endif /* __LINUX_NL80211_H */
--- a/include/net/cfg80211.h	2011-11-04 11:21:17.000000000 +0100
+++ b/include/net/cfg80211.h	2011-11-07 12:31:55.000000000 +0100
@@ -1675,6 +1675,7 @@ struct cfg80211_ops {
  *	teardown packets should be sent through the @NL80211_CMD_TDLS_MGMT
  *	command. When this flag is not set, @NL80211_CMD_TDLS_OPER should be
  *	used for asking the driver/firmware to perform a TDLS operation.
+ * @WIPHY_FLAG_HAVE_AP_SME: device integrates AP SME
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1693,6 +1694,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_AP_UAPSD			= BIT(14),
 	WIPHY_FLAG_SUPPORTS_TDLS		= BIT(15),
 	WIPHY_FLAG_TDLS_EXTERNAL_SETUP		= BIT(16),
+	WIPHY_FLAG_HAVE_AP_SME			= BIT(17),
 };
 
 /**
@@ -1903,6 +1905,8 @@ struct wiphy_wowlan_support {
  *	may request, if implemented.
  *
  * @wowlan: WoWLAN support information
+ *
+ * @ap_sme_capa: AP SME capabilities, flags from &enum nl80211_ap_sme_features.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -1926,6 +1930,8 @@ struct wiphy {
 
 	u32 flags;
 
+	u32 ap_sme_capa;
+
 	enum cfg80211_signal_type signal_type;
 
 	int bss_priv_size;
--- a/net/wireless/core.c	2011-11-03 14:41:41.000000000 +0100
+++ b/net/wireless/core.c	2011-11-04 11:21:17.000000000 +0100
@@ -492,6 +492,10 @@ int wiphy_register(struct wiphy *wiphy)
 		    !(wiphy->wowlan.flags & WIPHY_WOWLAN_SUPPORTS_GTK_REKEY)))
 		return -EINVAL;
 
+	if (WARN_ON(wiphy->ap_sme_capa &&
+		    !(wiphy->flags & WIPHY_FLAG_HAVE_AP_SME)))
+		return -EINVAL;
+
 	if (WARN_ON(wiphy->addresses && !wiphy->n_addresses))
 		return -EINVAL;
 
--- a/net/wireless/nl80211.c	2011-11-04 11:21:17.000000000 +0100
+++ b/net/wireless/nl80211.c	2011-11-07 12:31:55.000000000 +0100
@@ -1007,6 +1007,10 @@ static int nl80211_send_wiphy(struct sk_
 	if (nl80211_put_iface_combinations(&dev->wiphy, msg))
 		goto nla_put_failure;
 
+	if (dev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME)
+		NLA_PUT_U32(msg, NL80211_ATTR_DEVICE_AP_SME,
+			    dev->wiphy.ap_sme_capa);
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
--- a/drivers/net/wireless/ath/ath6kl/init.c	2011-11-03 14:41:41.000000000 +0100
+++ b/drivers/net/wireless/ath/ath6kl/init.c	2011-11-07 12:34:45.000000000 +0100
@@ -1548,7 +1548,8 @@ static int ath6kl_init(struct net_device
 	ar->conf_flags = ATH6KL_CONF_IGNORE_ERP_BARKER |
 			 ATH6KL_CONF_ENABLE_11N | ATH6KL_CONF_ENABLE_TX_BURST;
 
-	ar->wdev->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
+	ar->wdev->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM |
+				  WIPHY_FLAG_HAVE_AP_SME;
 
 	status = ath6kl_target_config_wlan_params(ar);
 	if (!status)



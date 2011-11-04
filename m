Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54764 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187Ab1KDKVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 06:21:22 -0400
Message-Id: <20111104101943.704950080@sipsolutions.net> (sfid-20111104_112124_699843_CC5758F6)
Date: Fri, 04 Nov 2011 11:18:14 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/12] nl80211: advertise device AP SME
References: <20111104101809.711636760@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add the ability to advertise that the device
contains the AP SME and what features it can
support.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: fix attribute name (thanks Eliad)

 drivers/net/wireless/ath/ath6kl/init.c |    4 +++-
 include/linux/nl80211.h                |   20 ++++++++++++++++++++
 include/net/cfg80211.h                 |    6 ++++++
 net/wireless/core.c                    |    4 ++++
 net/wireless/nl80211.c                 |    4 ++++
 5 files changed, 37 insertions(+), 1 deletion(-)

--- a/include/linux/nl80211.h	2011-11-03 11:52:49.000000000 +0100
+++ b/include/linux/nl80211.h	2011-11-03 11:52:51.000000000 +0100
@@ -1122,6 +1122,11 @@ enum nl80211_commands {
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
@@ -1350,6 +1355,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_TDLS_SUPPORT,
 	NL80211_ATTR_TDLS_EXTERNAL_SETUP,
 
+	NL80211_ATTR_DEVICE_AP_SME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2663,4 +2670,17 @@ enum nl80211_tdls_operation {
 	NL80211_TDLS_DISABLE_LINK,
 };
 
+/**
+ * enum nl80211_ap_sme_features - device-integrated AP features
+ * @NL80211_AP_SME_WSC: The driver is capable of indicating received probe
+ *	request frames to userspace via management frame subscription events
+ *	if the payload includes the WSC IE. The driver is capable of adding
+ *	the WSC IE as configured from userspace into beacons, probe responses
+ *	and (re)association reponse frame and allows userspace to update them
+ *	during the lifetime of the BSS.
+ */
+enum nl80211_ap_sme_features {
+	NL80211_AP_SME_WSC	= 1 << 0,
+};
+
 #endif /* __LINUX_NL80211_H */
--- a/include/net/cfg80211.h	2011-11-03 11:52:49.000000000 +0100
+++ b/include/net/cfg80211.h	2011-11-03 11:52:51.000000000 +0100
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
--- a/net/wireless/core.c	2011-11-03 10:54:14.000000000 +0100
+++ b/net/wireless/core.c	2011-11-03 11:52:51.000000000 +0100
@@ -492,6 +492,10 @@ int wiphy_register(struct wiphy *wiphy)
 		    !(wiphy->wowlan.flags & WIPHY_WOWLAN_SUPPORTS_GTK_REKEY)))
 		return -EINVAL;
 
+	if (WARN_ON(wiphy->ap_sme_capa &&
+		    !(wiphy->flags & WIPHY_FLAG_HAVE_AP_SME)))
+		return -EINVAL;
+
 	if (WARN_ON(wiphy->addresses && !wiphy->n_addresses))
 		return -EINVAL;
 
--- a/net/wireless/nl80211.c	2011-11-03 11:52:49.000000000 +0100
+++ b/net/wireless/nl80211.c	2011-11-03 11:52:51.000000000 +0100
@@ -1007,6 +1007,10 @@ static int nl80211_send_wiphy(struct sk_
 	if (nl80211_put_iface_combinations(&dev->wiphy, msg))
 		goto nla_put_failure;
 
+	if (dev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME)
+		NLA_PUT_U32(msg, NL80211_ATTR_DEVICE_AP_SME,
+			    dev->wiphy.ap_sme_capa);
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
--- a/drivers/net/wireless/ath/ath6kl/init.c	2011-11-03 10:54:14.000000000 +0100
+++ b/drivers/net/wireless/ath/ath6kl/init.c	2011-11-03 11:52:51.000000000 +0100
@@ -1548,7 +1548,9 @@ static int ath6kl_init(struct net_device
 	ar->conf_flags = ATH6KL_CONF_IGNORE_ERP_BARKER |
 			 ATH6KL_CONF_ENABLE_11N | ATH6KL_CONF_ENABLE_TX_BURST;
 
-	ar->wdev->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
+	ar->wdev->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM |
+				  WIPHY_FLAG_HAVE_AP_SME;
+	ar->wdev->wiphy->ap_sme_capa = NL80211_AP_SME_WSC;
 
 	status = ath6kl_target_config_wlan_params(ar);
 	if (!status)



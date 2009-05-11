Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:54949 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753978AbZEKS65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 14:58:57 -0400
Message-Id: <20090511185850.302244146@atheros.com>
References: <20090511185754.653711567@atheros.com>
Date: Mon, 11 May 2009 21:57:57 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 3/4] nl80211: Add IEEE 802.1X PAE control for station mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new NL80211_ATTR_CONTROL_PORT flag for NL80211_CMD_ASSOCIATE to
allow user space to indicate that it will control the IEEE 802.1X port
in station mode. Previously, mac80211 was always marking the port
authorized in station mode. This was enough when drop_unencrypted flag
was set. However, drop_unencrypted can currently be controlled only
with WEXT and the current nl80211 design does not allow fully secure
configuration. Fix this by providing a mechanism for user space to
control the IEEE 802.1X port in station mode (i.e., do the same that
we are already doing in AP mode).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/linux/nl80211.h    |    9 +++++++++
 include/net/cfg80211.h     |    5 +++++
 net/mac80211/cfg.c         |    5 +++++
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mlme.c        |    5 +++--
 net/mac80211/wext.c        |    3 +++
 net/wireless/nl80211.c     |    3 +++
 7 files changed, 29 insertions(+), 3 deletions(-)

--- uml.orig/include/linux/nl80211.h	2009-05-11 21:39:24.000000000 +0300
+++ uml/include/linux/nl80211.h	2009-05-11 21:39:26.000000000 +0300
@@ -504,6 +504,13 @@ enum nl80211_commands {
  * @NL80211_ATTR_STA_FLAGS2: Attribute containing a
  *	&struct nl80211_sta_flag_update.
  *
+ * @NL80211_ATTR_CONTROL_PORT: A flag indicating whether user space controls
+ *	IEEE 802.1X port, i.e., sets/clears %NL80211_STA_FLAG_AUTHORIZED, in
+ *	station mode. If the flag is included in %NL80211_CMD_ASSOCIATE
+ *	request, the driver will assume that the port is unauthorized until
+ *	authorized by user space. Otherwise, port is marked authorized by
+ *	default in station mode.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -610,6 +617,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_STA_FLAGS2,
 
+	NL80211_ATTR_CONTROL_PORT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- uml.orig/include/net/cfg80211.h	2009-05-11 21:39:24.000000000 +0300
+++ uml/include/net/cfg80211.h	2009-05-11 21:39:26.000000000 +0300
@@ -655,6 +655,10 @@ struct cfg80211_auth_request {
  * @ie: Extra IEs to add to (Re)Association Request frame or %NULL
  * @ie_len: Length of ie buffer in octets
  * @use_mfp: Use management frame protection (IEEE 802.11w) in this association
+ * @control_port: Whether user space controls IEEE 802.1X port, i.e.,
+ *	sets/clears %NL80211_STA_FLAG_AUTHORIZED. If true, the driver is
+ *	required to assume that the port is unauthorized until authorized by
+ *	user space. Otherwise, port is marked authorized by default.
  */
 struct cfg80211_assoc_request {
 	struct ieee80211_channel *chan;
@@ -664,6 +668,7 @@ struct cfg80211_assoc_request {
 	const u8 *ie;
 	size_t ie_len;
 	bool use_mfp;
+	bool control_port;
 };
 
 /**
--- uml.orig/net/mac80211/cfg.c	2009-05-11 21:39:24.000000000 +0300
+++ uml/net/mac80211/cfg.c	2009-05-11 21:39:26.000000000 +0300
@@ -1265,6 +1265,11 @@ static int ieee80211_assoc(struct wiphy 
 		sdata->u.mgd.flags &= ~IEEE80211_STA_MFP_ENABLED;
 	}
 
+	if (req->control_port)
+		sdata->u.mgd.flags |= IEEE80211_STA_CONTROL_PORT;
+	else
+		sdata->u.mgd.flags &= ~IEEE80211_STA_CONTROL_PORT;
+
 	sdata->u.mgd.flags |= IEEE80211_STA_EXT_SME;
 	sdata->u.mgd.state = IEEE80211_STA_MLME_ASSOCIATE;
 	ieee80211_sta_req_auth(sdata);
--- uml.orig/net/wireless/nl80211.c	2009-05-11 21:39:24.000000000 +0300
+++ uml/net/wireless/nl80211.c	2009-05-11 21:39:26.000000000 +0300
@@ -126,6 +126,7 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_STA_FLAGS2] = {
 		.len = sizeof(struct nl80211_sta_flag_update),
 	},
+	[NL80211_ATTR_CONTROL_PORT] = { .type = NLA_FLAG },
 };
 
 /* IE validation */
@@ -3040,6 +3041,8 @@ static int nl80211_associate(struct sk_b
 		}
 	}
 
+	req.control_port = info->attrs[NL80211_ATTR_CONTROL_PORT];
+
 	err = drv->ops->assoc(&drv->wiphy, dev, &req);
 
 out:
--- uml.orig/net/mac80211/ieee80211_i.h	2009-05-11 21:39:08.000000000 +0300
+++ uml/net/mac80211/ieee80211_i.h	2009-05-11 21:39:26.000000000 +0300
@@ -235,7 +235,7 @@ struct mesh_preq_queue {
 #define IEEE80211_STA_ASSOCIATED	BIT(4)
 #define IEEE80211_STA_PROBEREQ_POLL	BIT(5)
 #define IEEE80211_STA_CREATE_IBSS	BIT(6)
-/* hole at 7, please re-use */
+#define IEEE80211_STA_CONTROL_PORT	BIT(7)
 #define IEEE80211_STA_WMM_ENABLED	BIT(8)
 /* hole at 9, please re-use */
 #define IEEE80211_STA_AUTO_SSID_SEL	BIT(10)
--- uml.orig/net/mac80211/mlme.c	2009-05-11 21:39:08.000000000 +0300
+++ uml/net/mac80211/mlme.c	2009-05-11 21:39:26.000000000 +0300
@@ -1577,8 +1577,9 @@ static void ieee80211_rx_mgmt_assoc_resp
 	 *	  to between the sta_info_alloc() and sta_info_insert() above.
 	 */
 
-	set_sta_flags(sta, WLAN_STA_AUTH | WLAN_STA_ASSOC | WLAN_STA_ASSOC_AP |
-			   WLAN_STA_AUTHORIZED);
+	set_sta_flags(sta, WLAN_STA_AUTH | WLAN_STA_ASSOC | WLAN_STA_ASSOC_AP);
+	if (!(ifmgd->flags & IEEE80211_STA_CONTROL_PORT))
+		set_sta_flags(sta, WLAN_STA_AUTHORIZED);
 
 	rates = 0;
 	basic_rates = 0;
--- uml.orig/net/mac80211/wext.c	2009-05-11 21:39:21.000000000 +0300
+++ uml/net/mac80211/wext.c	2009-05-11 21:39:26.000000000 +0300
@@ -41,6 +41,7 @@ static int ieee80211_ioctl_siwgenie(stru
 			return ret;
 		sdata->u.mgd.flags &= ~IEEE80211_STA_AUTO_BSSID_SEL;
 		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
+		sdata->u.mgd.flags &= ~IEEE80211_STA_CONTROL_PORT;
 		ieee80211_sta_req_auth(sdata);
 		return 0;
 	}
@@ -124,6 +125,7 @@ static int ieee80211_ioctl_siwessid(stru
 			return ret;
 
 		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
+		sdata->u.mgd.flags &= ~IEEE80211_STA_CONTROL_PORT;
 		ieee80211_sta_req_auth(sdata);
 		return 0;
 	}
@@ -181,6 +183,7 @@ static int ieee80211_ioctl_siwap(struct 
 		if (ret)
 			return ret;
 		sdata->u.mgd.flags &= ~IEEE80211_STA_EXT_SME;
+		sdata->u.mgd.flags &= ~IEEE80211_STA_CONTROL_PORT;
 		ieee80211_sta_req_auth(sdata);
 		return 0;
 	} else if (sdata->vif.type == NL80211_IFTYPE_WDS) {

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA

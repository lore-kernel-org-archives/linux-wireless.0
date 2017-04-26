Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54552 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1956644AbdDZH7N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 03:59:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 26 Apr 2017 10:58:50 +0300
Message-Id: <20170426075854.13546-6-luca@coelho.fi> (sfid-20170426_095927_974275_914D4475)
In-Reply-To: <20170426075854.13546-1-luca@coelho.fi>
References: <20170426075854.13546-1-luca@coelho.fi>
Subject: [PATCH 5/9] cfg80211/nl80211: add authorized flag to roaming event
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Drivers that initiate roaming while being connected to a network that
uses 802.1X authentication need to inform user space if 802.1X
authentication is further required after roaming.
For example, when using the Fast transition protocol, roaming within
the mobility domain does not require new 802.1X authentication, but
roaming to another mobility domain does.
In addition, some drivers may not support 802.1X authentication
(so it has to be done in user space), while other drivers do.

Add a flag to the roaming notification to indicate if user space is
required to do 802.1X authentication after the roaming or not.
This flag will only be used for networks that use 802.1X
authentication. For networks that do not use 802.1X authentication it
is assumed that no further action is required from user space after
the roaming notification.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       |  4 ++++
 include/uapi/linux/nl80211.h | 14 ++++++++++++++
 net/wireless/nl80211.c       |  4 +++-
 net/wireless/sme.c           |  1 +
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 115f6fc5a34d..f9f4fde2dc09 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5384,6 +5384,9 @@ cfg80211_connect_timeout(struct net_device *dev, const u8 *bssid,
  * @req_ie_len: association request IEs length
  * @resp_ie: association response IEs (may be %NULL)
  * @resp_ie_len: assoc response IEs length
+ * @authorized: true if the 802.1X authentication was done by the driver or is
+ *	not needed (e.g., when Fast Transition protocol was used), false
+ *	otherwise. Ignored for networks that don't use 802.1X authentication.
  */
 struct cfg80211_roam_info {
 	struct ieee80211_channel *channel;
@@ -5393,6 +5396,7 @@ struct cfg80211_roam_info {
 	size_t req_ie_len;
 	const u8 *resp_ie;
 	size_t resp_ie_len;
+	bool authorized;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6095a6c4c412..7bdbce7c4147 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -546,6 +546,12 @@
  *	well to remain backwards compatible.
  * @NL80211_CMD_ROAM: request that the card roam (currently not implemented),
  *	sent as an event when the card/driver roamed by itself.
+ *	When used as an event, and the driver roamed in a network that requires
+ *	802.1X authentication, %NL80211_ATTR_CONNECTION_AUTHORIZED should be set
+ *	if the 802.1X authentication was done by the driver or if roaming was
+ *	done using Fast Transition protocol (in which case 802.1X authentication
+ *	is not needed). If %NL80211_ATTR_CONNECTION_AUTHORIZED is not set,
+ *	user space is responsible for the 802.1X authentication.
  * @NL80211_CMD_DISCONNECT: drop a given connection; also used to notify
  *	userspace that a connection was dropped by the AP or due to other
  *	reasons, for this the %NL80211_ATTR_DISCONNECTED_BY_AP and
@@ -2081,6 +2087,12 @@ enum nl80211_commands {
  * @NL80211_ATTR_PMK: PMK for the PMKSA identified by %NL80211_ATTR_PMKID.
  *	This is used with @NL80211_CMD_SET_PMKSA.
  *
+ * @NL80211_ATTR_CONNECTION_AUTHORIZED: A flag attribute used with
+ *	%NL80211_CMD_ROAM to indicate that 802.1X authentication was done by the
+ *	driver or is not needed (because roaming used the Fast Transition
+ *	protocol). Only valid for roaming in networks that require 802.1X
+ *	authentication.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2500,6 +2512,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PMK,
 
+	NL80211_ATTR_CONNECTION_AUTHORIZED,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ab9036e2d622..f3bf20584222 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13621,7 +13621,9 @@ void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
 		     info->req_ie)) ||
 	    (info->resp_ie &&
 	     nla_put(msg, NL80211_ATTR_RESP_IE, info->resp_ie_len,
-		     info->resp_ie)))
+		     info->resp_ie)) ||
+	    (info->authorized &&
+	     nla_put_flag(msg, NL80211_ATTR_CONNECTION_AUTHORIZED)))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 532a0007ce82..0a49b88070d0 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -960,6 +960,7 @@ void cfg80211_roamed(struct net_device *dev, struct cfg80211_roam_info *info,
 	ev->rm.resp_ie_len = info->resp_ie_len;
 	memcpy((void *)ev->rm.resp_ie, info->resp_ie, info->resp_ie_len);
 	ev->rm.bss = info->bss;
+	ev->rm.authorized = info->authorized;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
-- 
2.11.0

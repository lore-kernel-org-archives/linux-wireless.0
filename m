Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:35223 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751177AbdECKmY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 06:42:24 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 4/9] nl80211: add authorized flag to ROAM event
Date: Wed,  3 May 2017 11:42:09 +0100
Message-Id: <1493808134-4074-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170503_124228_841485_C646678F)
In-Reply-To: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
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
[arend.vanspriel@broadcom.com reuse NL80211_ATTR_PORT_AUTHORIZED]
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h       |  4 ++++
 include/uapi/linux/nl80211.h | 10 +++++++++-
 net/wireless/nl80211.c       |  4 +++-
 net/wireless/sme.c           |  1 +
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9e2719c..58475d1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5440,6 +5440,9 @@ void cfg80211_connect_done(struct net_device *dev,
  * @req_ie_len: association request IEs length
  * @resp_ie: association response IEs (may be %NULL)
  * @resp_ie_len: assoc response IEs length
+ * @authorized: true if the 802.1X authentication was done by the driver or is
+ *	not needed (e.g., when Fast Transition protocol was used), false
+ *	otherwise. Ignored for networks that don't use 802.1X authentication.
  */
 struct cfg80211_roam_info {
 	struct ieee80211_channel *channel;
@@ -5449,6 +5452,7 @@ struct cfg80211_roam_info {
 	size_t req_ie_len;
 	const u8 *resp_ie;
 	size_t resp_ie_len;
+	bool authorized;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 92bed43..1eaa340 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -548,6 +548,12 @@
  *	well to remain backwards compatible.
  * @NL80211_CMD_ROAM: request that the card roam (currently not implemented),
  *	sent as an event when the card/driver roamed by itself.
+ *	When used as an event, and the driver roamed in a network that requires
+ *	802.1X authentication, %NL80211_ATTR_PORT_AUTHORIZED should be set
+ *	if the 802.1X authentication was done by the driver or if roaming was
+ *	done using Fast Transition protocol (in which case 802.1X authentication
+ *	is not needed). If %NL80211_ATTR_PORT_AUTHORIZED is not set, user space
+ *	is responsible for the 802.1X authentication.
  * @NL80211_CMD_DISCONNECT: drop a given connection; also used to notify
  *	userspace that a connection was dropped by the AP or due to other
  *	reasons, for this the %NL80211_ATTR_DISCONNECTED_BY_AP and
@@ -2109,7 +2115,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_PMKR0_NAME: PMK-R0 Name for offloaded FT.
  * @NL80211_ATTR_PORT_AUTHORIZED: flag attribute used in %NL80211_CMD_CONNECT
  *	notification indicating that PTK/GTK handshakes for 802.1X have been
- *	completed successfully.
+ *	completed successfully. Also used in %NL80211_CMD_ROAM to indicate
+ *	that 802.1X authentication was done by the driver or is not needed
+ *	(because roaming used the Fast Transition protocol).
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 42e7811..eab60d7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13787,7 +13787,9 @@ void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
 		     info->req_ie)) ||
 	    (info->resp_ie &&
 	     nla_put(msg, NL80211_ATTR_RESP_IE, info->resp_ie_len,
-		     info->resp_ie)))
+		     info->resp_ie)) ||
+	    (info->authorized &&
+	     nla_put_flag(msg, NL80211_ATTR_PORT_AUTHORIZED)))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index a46eda8..9eb9234 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -961,6 +961,7 @@ void cfg80211_roamed(struct net_device *dev, struct cfg80211_roam_info *info,
 	ev->rm.resp_ie_len = info->resp_ie_len;
 	memcpy((void *)ev->rm.resp_ie, info->resp_ie, info->resp_ie_len);
 	ev->rm.bss = info->bss;
+	ev->rm.authorized = info->authorized;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
-- 
1.9.1

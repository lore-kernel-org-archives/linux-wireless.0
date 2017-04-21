Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:43741 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1040602AbdDUVCY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 17:02:24 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC] cfg80211: add control port state to struct cfg80211_connect_resp_params
Date: Fri, 21 Apr 2017 22:01:47 +0100
Message-Id: <1492808507-31224-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170421_230229_136776_B4899204)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the driver supports offloading of the PTK/GTK handshakes
completion of that during connect changes the layer 2 control
port state to authorized. This patch allows the driver to pass
that state in cfg80211_connect_done() resulting in adding the
new flag NL80211_ATTR_PORT_AUTHORIZED in the NL80211_CMD_CONNECT
notification.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
Hi Johannes, Jouni, et al

I have been working on 4-way handshake offloading and one of the
things discussed was the addition of PORT_AUTHORIZED flag. So
this is what I came up with, but I suppose wpa_supplicant wants
to know whether it can expect this attribute or not. One option
is to have PORT_UNAUTHORIZED flag instead. Another option would
be introducing it as nl80211 protocol feature although not sure
if it could be considered as such. What do you guys think?

Regards,
Arend
---
 include/net/cfg80211.h       | 9 +++++++++
 include/uapi/linux/nl80211.h | 3 +++
 net/wireless/nl80211.c       | 2 ++
 net/wireless/sme.c           | 1 +
 4 files changed, 15 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bdc4424..f416d55 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5236,6 +5236,12 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
 #define CFG80211_TESTMODE_DUMP(cmd)
 #endif
 
+enum cfg80211_control_port_state {
+	CONTROL_PORT_STATE_UNSPECIFIED,
+	CONTROL_PORT_STATE_UNAUTHORIZED,
+	CONTROL_PORT_STATE_AUTHORIZED
+};
+
 /**
  * struct cfg80211_connect_resp_params - Connection response params
  * @status: Status code, %WLAN_STATUS_SUCCESS for successful connection, use
@@ -5271,6 +5277,8 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
  *	not known. This value is used only if @status < 0 to indicate that the
  *	failure is due to a timeout and not due to explicit rejection by the AP.
  *	This value is ignored in other cases (@status >= 0).
+ * @port_state: Indicates whether the connection is ready to transport
+ *	data packets (see &enum cfg80211_control_port_state).
  */
 struct cfg80211_connect_resp_params {
 	int status;
@@ -5288,6 +5296,7 @@ struct cfg80211_connect_resp_params {
 	size_t pmk_len;
 	const u8 *pmkid;
 	enum nl80211_timeout_reason timeout_reason;
+	enum cfg80211_control_port_state port_state;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 087493d..34738df 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2106,6 +2106,8 @@ enum nl80211_commands {
  *	in %NL80211_CMD_CONNECT to indicate that for 802.1X authentication it
  *	wants to use the supported offload.
  * @NL80211_ATTR_PMKR0_NAME: PMK-R0 Name for offloaded FT.
+ * @NL80211_ATTR_PORT_AUTHORIZED: flag attribute used in %NL80211_CMD_CONNECT
+ *	notification indicating 4-way handshake offload finished successfully.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2531,6 +2533,7 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_WANT_1X_OFFLOAD,
 	NL80211_ATTR_PMKR0_NAME,
+	NL80211_ATTR_PORT_AUTHORIZED,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e08c0d3..7fff668 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13745,6 +13745,8 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 	     (nla_put_flag(msg, NL80211_ATTR_TIMED_OUT) ||
 	      nla_put_u32(msg, NL80211_ATTR_TIMEOUT_REASON,
 			  cr->timeout_reason))) ||
+	    (cr->port_state != CONTROL_PORT_STATE_UNAUTHORIZED &&
+	     nla_put_flag(msg, NL80211_ATTR_PORT_AUTHORIZED)) ||
 	    (cr->req_ie &&
 	     nla_put(msg, NL80211_ATTR_REQ_IE, cr->req_ie_len, cr->req_ie)) ||
 	    (cr->resp_ie &&
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 6459bb7..a0d4010 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -860,6 +860,7 @@ void cfg80211_connect_done(struct net_device *dev,
 	ev->cr.bss = params->bss;
 	ev->cr.status = params->status;
 	ev->cr.timeout_reason = params->timeout_reason;
+	ev->cr.port_state = params->port_state;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
-- 
1.9.1

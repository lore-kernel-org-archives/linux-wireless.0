Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:42890 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751622AbdFIMJA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 08:09:00 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V3 3/9] nl80211: add authorized flag to CONNECT event
Date: Fri,  9 Jun 2017 13:08:44 +0100
Message-Id: <1497010130-16186-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170609_140929_290980_B3C4256E)
In-Reply-To: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the driver supports offloading of the PTK/GTK handshakes
completion of that during connect changes the layer 2 control
port state to authorized. This patch allows the driver to pass
that state in cfg80211_connect_done() resulting in adding the
new flag NL80211_ATTR_PORT_AUTHORIZED in the NL80211_CMD_CONNECT
notification. For 802.1X the driver is expected to issue the
NL80211_CMD_CONNECT notification twice. First without the new
attribute to inform user-space that 802.1X authentication can
start and a second one with the new attribute to indicate the
completion of the handshakes.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h       | 3 +++
 include/uapi/linux/nl80211.h | 4 ++++
 net/wireless/nl80211.c       | 2 ++
 net/wireless/sme.c           | 1 +
 4 files changed, 10 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2174e51..7097310 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5280,6 +5280,8 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
  *	not known. This value is used only if @status < 0 to indicate that the
  *	failure is due to a timeout and not due to explicit rejection by the AP.
  *	This value is ignored in other cases (@status >= 0).
+ * @authorized: Indicates whether the connection is ready to transport
+ *	data packets.
  */
 struct cfg80211_connect_resp_params {
 	int status;
@@ -5297,6 +5299,7 @@ struct cfg80211_connect_resp_params {
 	size_t pmk_len;
 	const u8 *pmkid;
 	enum nl80211_timeout_reason timeout_reason;
+	bool authorized;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2f49275..6f139a3 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2130,6 +2130,9 @@ enum nl80211_commands {
  *	in %NL80211_CMD_CONNECT to indicate that for 802.1X authentication it
  *	wants to use the supported offload of the 4-way handshake.
  * @NL80211_ATTR_PMKR0_NAME: PMK-R0 Name for offloaded FT.
+ * @NL80211_ATTR_PORT_AUTHORIZED: flag attribute used in %NL80211_CMD_CONNECT
+ *	notification indicating that PTK/GTK handshakes for 802.1X have been
+ *	completed successfully.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2555,6 +2558,7 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_WANT_1X_4WAY_HS,
 	NL80211_ATTR_PMKR0_NAME,
+	NL80211_ATTR_PORT_AUTHORIZED,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8148b01..d0bf6bd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13745,6 +13745,8 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
 	     (nla_put_flag(msg, NL80211_ATTR_TIMED_OUT) ||
 	      nla_put_u32(msg, NL80211_ATTR_TIMEOUT_REASON,
 			  cr->timeout_reason))) ||
+	    (cr->authorized &&
+	     nla_put_flag(msg, NL80211_ATTR_PORT_AUTHORIZED)) ||
 	    (cr->req_ie &&
 	     nla_put(msg, NL80211_ATTR_REQ_IE, cr->req_ie_len, cr->req_ie)) ||
 	    (cr->resp_ie &&
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 532a000..a46eda8 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -861,6 +861,7 @@ void cfg80211_connect_done(struct net_device *dev,
 	ev->cr.bss = params->bss;
 	ev->cr.status = params->status;
 	ev->cr.timeout_reason = params->timeout_reason;
+	ev->cr.authorized = params->authorized;
 
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
-- 
1.9.1

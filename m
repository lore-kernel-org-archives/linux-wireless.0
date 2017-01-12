Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38195 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdALXNb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 18:13:31 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 4/4] cfg80211: Fix documentation for connect result
Date: Fri, 13 Jan 2017 01:12:22 +0200
Message-ID: <1484262742-3927-4-git-send-email-jouni@qca.qualcomm.com> (sfid-20170113_001334_590072_3135DD1C)
In-Reply-To: <1484262742-3927-1-git-send-email-jouni@qca.qualcomm.com>
References: <1484262742-3927-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function documentation for cfg80211_connect_bss() and
cfg80211_connect_result() was still claiming that they are used only for
a success case while these functions can now be used to report both
success and various failure cases. The actual use cases were already
described in the connect() documentation.

Update the function specific comments to note the failure cases and also
describe how the special status == -1 case is used in
cfg80211_connect_bss() to indicate a connection timeout based on the
internal implementation in cfg80211_connect_timeout().

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9b3427c..ed3d595 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5086,9 +5086,14 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
  * @req_ie_len: association request IEs length
  * @resp_ie: association response IEs (may be %NULL)
  * @resp_ie_len: assoc response IEs length
- * @status: status code, 0 for successful connection, use
+ * @status: status code, %WLAN_STATUS_SUCCESS for successful connection, use
  *      %WLAN_STATUS_UNSPECIFIED_FAILURE if your device cannot give you
- *      the real status code for failures.
+ *	the real status code for failures. If this call is used to report a
+ *	failure due to a timeout (e.g., not receiving an Authentication frame
+ *	from the AP) instead of an explicit rejection by the AP, -1 is used to
+ *	indicate that this is a failure, but without a status code.
+ *	@timeout_reason is used to report the reason for the timeout in that
+ *	case.
  * @gfp: allocation flags
  * @timeout_reason: reason for connection timeout. This is used when the
  *	connection fails due to a timeout instead of an explicit rejection from
@@ -5097,10 +5102,10 @@ static inline void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
  *	failure is due to a timeout and not due to explicit rejection by the AP.
  *	This value is ignored in other cases (@status >= 0).
  *
- * It should be called by the underlying driver whenever connect() has
- * succeeded. This is similar to cfg80211_connect_result(), but with the
- * option of identifying the exact bss entry for the connection. Only one of
- * these functions should be called.
+ * It should be called by the underlying driver once execution of the connection
+ * request from connect() has been completed. This is similar to
+ * cfg80211_connect_result(), but with the option of identifying the exact bss
+ * entry for the connection. Only one of these functions should be called.
  */
 void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
 			  struct cfg80211_bss *bss, const u8 *req_ie,
@@ -5117,13 +5122,15 @@ void cfg80211_connect_bss(struct net_device *dev, const u8 *bssid,
  * @req_ie_len: association request IEs length
  * @resp_ie: association response IEs (may be %NULL)
  * @resp_ie_len: assoc response IEs length
- * @status: status code, 0 for successful connection, use
+ * @status: status code, %WLAN_STATUS_SUCCESS for successful connection, use
  *	%WLAN_STATUS_UNSPECIFIED_FAILURE if your device cannot give you
  *	the real status code for failures.
  * @gfp: allocation flags
  *
- * It should be called by the underlying driver whenever connect() has
- * succeeded.
+ * It should be called by the underlying driver once execution of the connection
+ * request from connect() has been completed. This is similar to
+ * cfg80211_connect_bss() which allows the exact bss entry to be specified. Only
+ * one of these functions should be called.
  */
 static inline void
 cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
-- 
2.7.4

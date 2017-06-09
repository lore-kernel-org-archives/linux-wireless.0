Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:42942 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751672AbdFIMJC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 08:09:02 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V3 5/9] nl80211: remove desciption about request from NL80211_CMD_ROAM
Date: Fri,  9 Jun 2017 13:08:46 +0100
Message-Id: <1497010130-16186-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170609_140925_045423_71A6834B)
In-Reply-To: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The description of NL80211_CMD_ROAM indicated possibility for a
request to roam issued by user-space. However, it also states that
as not being implemented right now. This has been so since commit
b23aa676ab9d ("cfg80211: connect/disconnect API") added in 2009.
So it seems safe to assume it will not be added any time soon and
thus remove it.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/uapi/linux/nl80211.h | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c792234..c931263 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -569,14 +569,13 @@
  *	authentication/association or not receiving a response from the AP.
  *	Non-zero %NL80211_ATTR_STATUS_CODE value is indicated in that case as
  *	well to remain backwards compatible.
- * @NL80211_CMD_ROAM: request that the card roam (currently not implemented),
- *	sent as an event when the card/driver roamed by itself.
- *	When used as an event, and the driver roamed in a network that requires
- *	802.1X authentication, %NL80211_ATTR_PORT_AUTHORIZED should be set
- *	if the 802.1X authentication was done by the driver or if roaming was
- *	done using Fast Transition protocol (in which case 802.1X authentication
- *	is not needed). If %NL80211_ATTR_PORT_AUTHORIZED is not set, user space
- *	is responsible for the 802.1X authentication.
+ * @NL80211_CMD_ROAM: notifcation indicating the card/driver roamed by itself.
+ *	When the driver roamed in a network that requires 802.1X authentication,
+ *	%NL80211_ATTR_PORT_AUTHORIZED should be set if the 802.1X authentication
+ *	was done by the driver or if roaming was done using Fast Transition
+ *	protocol (in which case 802.1X authentication is not needed). If
+ *	%NL80211_ATTR_PORT_AUTHORIZED is not set, user space is responsible for
+ *	the 802.1X authentication.
  * @NL80211_CMD_DISCONNECT: drop a given connection; also used to notify
  *	userspace that a connection was dropped by the AP or due to other
  *	reasons, for this the %NL80211_ATTR_DISCONNECTED_BY_AP and
-- 
1.9.1

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26308 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111Ab2IUJjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 05:39:04 -0400
From: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <kvalo@qca.qualcomm.com>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Blocked client notification
Date: Fri, 21 Sep 2012 15:08:53 +0530
Message-ID: <1348220333-5466-1-git-send-email-c_ppitch@qca.qualcomm.com> (sfid-20120921_113910_421553_4783972C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a station tries to connect to an AP and if the MAC of the
station is in the AP's block list, the station cannot connect to the
AP. This is notified to the userspace with event 
NL80211_CMD_CONN_FAILED and attribute NL80211_ATTR_CONN_FAILED_REASON.
The reason sent will be NL80211_CONN_FAIL_BLOCKED_CLIENT.

Signed-off-by: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index cc2749a..bd50b6b 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1011,6 +1011,13 @@ void ath6kl_disconnect_event(struct ath6kl_vif *vif, u8 reason, u8 *bssid,
 					     GFP_KERNEL);
 		}
 
+		if (prot_reason_status == WMI_AP_REASON_ACL) {
+			/* send blocked client notification to user space */
+			cfg80211_conn_failed(vif->ndev, bssid,
+					     NL80211_CONN_FAIL_BLOCKED_CLIENT,
+					     GFP_KERNEL);
+		}
+
 		if (!ath6kl_remove_sta(ar, bssid, prot_reason_status))
 			return;
 
-- 
1.7.9.5


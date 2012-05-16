Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32497 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2EPUlR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:41:17 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH] ath6kl: issue wmi disconnect after notifying cfg80211
Date: Wed, 16 May 2012 13:41:13 -0700
Message-ID: <1337200873-3698-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120516_224129_759938_837F12D8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl would issue a wmi disconnect command in response to a remote
disconnect and return early without notifying cfg80211, only sending a
cfg80211_disconnected (with reason code always 3) in response to the
second disconnect firmware event.

Pass the right reason code to cfg80211 on the first disconnect instead.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index f3a6cfc..7845d33 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -860,20 +860,6 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 		}
 	}
 
-	/*
-	 * Send a disconnect command to target when a disconnect event is
-	 * received with reason code other than 3 (DISCONNECT_CMD - disconnect
-	 * request from host) to make the firmware stop trying to connect even
-	 * after giving disconnect event. There will be one more disconnect
-	 * event for this disconnect command with reason code DISCONNECT_CMD
-	 * which will be notified to cfg80211.
-	 */
-
-	if (reason != DISCONNECT_CMD) {
-		ath6kl_wmi_disconnect_cmd(ar->wmi, vif->fw_vif_idx);
-		return;
-	}
-
 	clear_bit(CONNECT_PEND, &vif->flags);
 
 	if (vif->sme_state == SME_CONNECTING) {
@@ -883,11 +869,22 @@ void ath6kl_cfg80211_disconnect_event(struct ath6kl_vif *vif, u8 reason,
 					WLAN_STATUS_UNSPECIFIED_FAILURE,
 					GFP_KERNEL);
 	} else if (vif->sme_state == SME_CONNECTED) {
-		cfg80211_disconnected(vif->ndev, reason,
+		cfg80211_disconnected(vif->ndev, proto_reason,
 				      NULL, 0, GFP_KERNEL);
 	}
 
 	vif->sme_state = SME_DISCONNECTED;
+
+	/*
+	 * Send a disconnect command to target when a disconnect event is
+	 * received with reason code other than 3 (DISCONNECT_CMD - disconnect
+	 * request from host) to make the firmware stop trying to connect even
+	 * after giving disconnect event. There will be one more disconnect
+	 * event for this disconnect command with reason code DISCONNECT_CMD
+	 * which won't be notified to cfg80211.
+	 */
+	if (reason != DISCONNECT_CMD)
+		ath6kl_wmi_disconnect_cmd(ar->wmi, vif->fw_vif_idx);
 }
 
 static int ath6kl_set_probed_ssids(struct ath6kl *ar,
-- 
1.7.4.1


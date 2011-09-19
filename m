Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55822 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab1ISQQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 12:16:01 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 4/9] ath6kl: Remove unnecessary node table update on disconnect event
Date: Mon, 19 Sep 2011 19:15:02 +0300
Message-ID: <1316448907-10166-5-git-send-email-jouni@qca.qualcomm.com> (sfid-20110919_181606_932919_09FEFDB5)
In-Reply-To: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
References: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since ath6kl does not actually update cfg80211 BSS table when this
event occurs, there is not much need for removing the entries from
the internal table that is not really used or exposed.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |   28 ----------------------------
 1 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index f21e4b1..55d3331 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1326,7 +1326,6 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 			     u8 assoc_resp_len, u8 *assoc_info,
 			     u16 prot_reason_status)
 {
-	struct bss *wmi_ssid_node = NULL;
 	unsigned long flags;
 
 	if (ar->nw_type == AP_NETWORK) {
@@ -1386,33 +1385,6 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 		}
 	}
 
-	if ((reason == NO_NETWORK_AVAIL) && test_bit(WMI_READY, &ar->flag))  {
-		ath6kl_wmi_node_free(ar->wmi, bssid);
-
-		/*
-		 * In case any other same SSID nodes are present remove it,
-		 * since those nodes also not available now.
-		 */
-		do {
-			/*
-			 * Find the nodes based on SSID and remove it
-			 *
-			 * Note: This case will not work out for
-			 * Hidden-SSID
-			 */
-			wmi_ssid_node = ath6kl_wmi_find_ssid_node(ar->wmi,
-								  ar->ssid,
-								  ar->ssid_len,
-								  false,
-								  true);
-
-			if (wmi_ssid_node)
-				ath6kl_wmi_node_free(ar->wmi,
-						     wmi_ssid_node->ni_macaddr);
-
-		} while (wmi_ssid_node);
-	}
-
 	/* update connect & link status atomically */
 	spin_lock_irqsave(&ar->lock, flags);
 	clear_bit(CONNECTED, &ar->flag);
-- 
1.7.4.1


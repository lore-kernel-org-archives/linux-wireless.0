Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13741 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2GJUSX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 16:18:23 -0400
From: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: use custom MAC address for newly created interfaces
Date: Tue, 10 Jul 2012 13:20:40 -0700
Message-ID: <1341951640-27434-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com> (sfid-20120710_221827_359095_827339DB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware and driver generate MAC addresses for the second and third interfaces.
In addition to the existing algorithm, flip bit 7 of 5th octet. Since both
firmware and driver individually generate the MAC addresses, introduce a new
firmware capability bit to keep them compatible.

Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 +++++-
 drivers/net/wireless/ath/ath6kl/core.h     |    3 +++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 230e35b..fc14d0e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3628,9 +3628,13 @@ struct net_device *ath6kl_interface_add(struct ath6kl *ar, char *name,
 	vif->htcap[IEEE80211_BAND_5GHZ].ht_enable = true;
 
 	memcpy(ndev->dev_addr, ar->mac_addr, ETH_ALEN);
-	if (fw_vif_idx != 0)
+	if (fw_vif_idx != 0) {
 		ndev->dev_addr[0] = (ndev->dev_addr[0] ^ (1 << fw_vif_idx)) |
 				     0x2;
+		if (test_bit(ATH6KL_FW_CAPABILITY_CUSTOM_MAC_ADDR,
+			    ar->fw_capabilities))
+			ndev->dev_addr[4] ^= 0x80;
+	}
 
 	init_netdev(ndev);
 
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index f36da4a..867c966 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -126,6 +126,9 @@ enum ath6kl_fw_capability {
 	 */
 	ATH6KL_FW_CAPABILITY_SCHED_SCAN_MATCH_LIST,
 
+	/* FW sets mac_addr[4] ^= 0x80 for newly created interfaces */
+	ATH6KL_FW_CAPABILITY_CUSTOM_MAC_ADDR,
+
 	/* this needs to be last */
 	ATH6KL_FW_CAPABILITY_MAX,
 };
-- 
1.7.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37371 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab1H2Mah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 08:30:37 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Edward Lu <shaol@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
Subject: [PATCH 19/20] ath6kl: Do not clear CONNECT bit setting in AP mode for STA disconnect
Date: Mon, 29 Aug 2011 15:24:00 +0300
Message-ID: <1314620641-24257-20-git-send-email-jouni@qca.qualcomm.com> (sfid-20110829_143040_539475_0B05BABD)
In-Reply-To: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Edward Lu <elu@qca.qualcomm.com>

Signed-off-by: Edward Lu <elu@qca.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index a19caec..69a1b451 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1284,7 +1284,8 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 			cfg80211_del_sta(ar->net_dev, bssid, GFP_KERNEL);
 		}
 
-		clear_bit(CONNECTED, &ar->flag);
+		if (memcmp(ar->net_dev->dev_addr, bssid, ETH_ALEN) == 0)
+			clear_bit(CONNECTED, &ar->flag);
 		return;
 	}
 
-- 
1.7.4.1


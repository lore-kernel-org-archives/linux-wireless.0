Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37995 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1GVFok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:44:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 28/31] ath6kl: fix atomicity in ath6kl_cfg80211_scan_node()
Date: Fri, 22 Jul 2011 08:42:01 +0300
Message-ID: <1311313324-6766-30-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074446_977926_77A7B18C)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl_cfg80211_scan_node() was calling cfg80211_inform_bss_frame()
with CFP_KERNEL but the function is executed with a spin lock taken.
This is wrong and the function must use GFP_ATOMIC instead.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index b9090b8..eff9983 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -720,6 +720,7 @@ static inline bool is_ch_11a(u16 ch)
 	return (!((ch >= 2412) && (ch <= 2484)));
 }
 
+/* struct ath6kl_node_table::nt_nodelock is locked when calling this */
 static void ath6kl_cfg80211_scan_node(void *arg, struct bss *ni)
 {
 	struct wiphy *wiphy = (struct wiphy *)arg;
@@ -769,7 +770,7 @@ static void ath6kl_cfg80211_scan_node(void *arg, struct bss *ni)
 		   "%s: bssid %pM ch %d freq %d size %d\n", __func__,
 		   mgmt->bssid, channel->hw_value, freq, size);
 	cfg80211_inform_bss_frame(wiphy, channel, mgmt,
-				  size, signal, GFP_KERNEL);
+				  size, signal, GFP_ATOMIC);
 
 	kfree(ieeemgmtbuf);
 }
-- 
1.7.1


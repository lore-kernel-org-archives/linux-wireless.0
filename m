Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5066 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab2B1OuW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 09:50:22 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V3 1/5] ath6kl: Group wiphy initialization into ath6kl_cfg80211_init()
Date: Tue, 28 Feb 2012 20:20:19 +0530
Message-ID: <1330440623-5649-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120228_155026_059512_A45B096F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some code which initializes various wiphy members
left outside ath6kl_cfg80211_init(), in ath6kl_core_init().
Move them into a single palce.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   14 ++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.c     |   14 --------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 5da0f29..bad9244 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3077,6 +3077,20 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 
 	wiphy->max_sched_scan_ssids = 10;
 
+	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM |
+			    WIPHY_FLAG_HAVE_AP_SME |
+			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
+			    WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
+
+	if (test_bit(ATH6KL_FW_CAPABILITY_SCHED_SCAN, ar->fw_capabilities))
+		ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
+
+	ar->wiphy->probe_resp_offload =
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P |
+		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U;
+
 	ret = wiphy_register(wiphy);
 	if (ret < 0) {
 		ath6kl_err("couldn't register wiphy device\n");
diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index 3968465..d078aed 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -154,20 +154,6 @@ int ath6kl_core_init(struct ath6kl *ar)
 	if (uart_debug)
 		ar->conf_flags |= ATH6KL_CONF_UART_DEBUG;
 
-	ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM |
-			    WIPHY_FLAG_HAVE_AP_SME |
-			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
-			    WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD;
-
-	if (test_bit(ATH6KL_FW_CAPABILITY_SCHED_SCAN, ar->fw_capabilities))
-		ar->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
-
-	ar->wiphy->probe_resp_offload =
-		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS |
-		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2 |
-		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P |
-		NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U;
-
 	set_bit(FIRST_BOOT, &ar->flag);
 
 	ndev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
-- 
1.7.0.4


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58960 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759823AbbKUJzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Nov 2015 04:55:14 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Enable AP + STA interface combination support for 10.x
Date: Sat, 21 Nov 2015 15:24:41 +0530
Message-ID: <1448099681-16448-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20151121_105524_723063_299045C6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Enable AP + STA interface combination support for 10.x and
this enables Repeater mode testing (with WDS Repeater combinations
as well). Fix indentation as well.

Based on the suggestions from Michal and Yanbo Li,
thanks to them

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |   30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 79490ad..9652384 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6766,35 +6766,39 @@ void ath10k_mac_destroy(struct ath10k *ar)
 
 static const struct ieee80211_iface_limit ath10k_if_limits[] = {
 	{
-	.max	= 8,
-	.types	= BIT(NL80211_IFTYPE_STATION)
-		| BIT(NL80211_IFTYPE_P2P_CLIENT)
+		.max	= 8,
+		.types	= BIT(NL80211_IFTYPE_STATION)
+			| BIT(NL80211_IFTYPE_P2P_CLIENT)
 	},
 	{
-	.max	= 3,
-	.types	= BIT(NL80211_IFTYPE_P2P_GO)
+		.max	= 3,
+		.types	= BIT(NL80211_IFTYPE_P2P_GO)
 	},
 	{
-	.max	= 1,
-	.types	= BIT(NL80211_IFTYPE_P2P_DEVICE)
+		.max	= 1,
+		.types	= BIT(NL80211_IFTYPE_P2P_DEVICE)
 	},
 	{
-	.max	= 7,
-	.types	= BIT(NL80211_IFTYPE_AP)
+		.max	= 7,
+		.types	= BIT(NL80211_IFTYPE_AP)
 #ifdef CONFIG_MAC80211_MESH
-		| BIT(NL80211_IFTYPE_MESH_POINT)
+			| BIT(NL80211_IFTYPE_MESH_POINT)
 #endif
 	},
 };
 
 static const struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
 	{
-	.max	= 8,
-	.types	= BIT(NL80211_IFTYPE_AP)
+		.max	= 8,
+		.types	= BIT(NL80211_IFTYPE_AP)
 #ifdef CONFIG_MAC80211_MESH
-		| BIT(NL80211_IFTYPE_MESH_POINT)
+			| BIT(NL80211_IFTYPE_MESH_POINT)
 #endif
 	},
+	{
+		.max	= 1,
+		.types	= BIT(NL80211_IFTYPE_STATION)
+	},
 };
 
 static const struct ieee80211_iface_combination ath10k_if_comb[] = {
-- 
1.7.9.5


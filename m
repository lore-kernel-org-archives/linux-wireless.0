Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:34276 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbbGILIz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 07:08:55 -0400
Received: by lagx9 with SMTP id x9so243845819lag.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 04:08:53 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 6/6] ath10k: tweak interface combinations
Date: Thu,  9 Jul 2015 13:08:39 +0200
Message-Id: <1436440119-30231-7-git-send-email-michal.kazior@tieto.com> (sfid-20150709_130905_148627_2F176911)
In-Reply-To: <1436440119-30231-1-git-send-email-michal.kazior@tieto.com>
References: <1436440119-30231-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Concurrent AP/GO operation on different channels
isn't really supported well by the firmware so
it's better to remove it from being advertised.

Also tune the way station and p2p client interface
limits are expressed to allow station + 2x p2p
client or station + p2p client + p2p go.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 39 ++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 0ef568c36db9..c41b34843a82 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6557,8 +6557,11 @@ static const struct ieee80211_iface_combination ath10k_10x_if_comb[] = {
 static const struct ieee80211_iface_limit ath10k_tlv_if_limit[] = {
 	{
 		.max = 2,
-		.types = BIT(NL80211_IFTYPE_STATION) |
-			 BIT(NL80211_IFTYPE_AP) |
+		.types = BIT(NL80211_IFTYPE_STATION),
+	},
+	{
+		.max = 2,
+		.types = BIT(NL80211_IFTYPE_AP) |
 			 BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			 BIT(NL80211_IFTYPE_P2P_GO),
 	},
@@ -6568,6 +6571,26 @@ static const struct ieee80211_iface_limit ath10k_tlv_if_limit[] = {
 	},
 };
 
+static const struct ieee80211_iface_limit ath10k_tlv_qcs_if_limit[] = {
+	{
+		.max = 2,
+		.types = BIT(NL80211_IFTYPE_STATION),
+	},
+	{
+		.max = 2,
+		.types = BIT(NL80211_IFTYPE_P2P_CLIENT),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_AP) |
+			 BIT(NL80211_IFTYPE_P2P_GO),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_DEVICE),
+	},
+};
+
 static const struct ieee80211_iface_limit ath10k_tlv_if_limit_ibss[] = {
 	{
 		.max = 1,
@@ -6586,7 +6609,7 @@ static struct ieee80211_iface_combination ath10k_tlv_if_comb[] = {
 	{
 		.limits = ath10k_tlv_if_limit,
 		.num_different_channels = 1,
-		.max_interfaces = 3,
+		.max_interfaces = 4,
 		.n_limits = ARRAY_SIZE(ath10k_tlv_if_limit),
 	},
 	{
@@ -6600,9 +6623,15 @@ static struct ieee80211_iface_combination ath10k_tlv_if_comb[] = {
 static struct ieee80211_iface_combination ath10k_tlv_qcs_if_comb[] = {
 	{
 		.limits = ath10k_tlv_if_limit,
+		.num_different_channels = 1,
+		.max_interfaces = 4,
+		.n_limits = ARRAY_SIZE(ath10k_tlv_if_limit),
+	},
+	{
+		.limits = ath10k_tlv_qcs_if_limit,
 		.num_different_channels = 2,
-		.max_interfaces = 3,
-		.n_limits = ARRAY_SIZE(ath10k_tlv_if_limit),
+		.max_interfaces = 4,
+		.n_limits = ARRAY_SIZE(ath10k_tlv_qcs_if_limit),
 	},
 	{
 		.limits = ath10k_tlv_if_limit_ibss,
-- 
2.1.4


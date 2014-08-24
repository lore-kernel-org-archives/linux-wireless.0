Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:48885 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbaHXPqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2014 11:46:13 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 3/4] ath9k: Fix interface limits
Date: Sun, 24 Aug 2014 21:16:12 +0530
Message-Id: <1408895173-3732-4-git-send-email-sujith@msujith.org> (sfid-20140824_174617_099517_4C71720D)
In-Reply-To: <1408895173-3732-1-git-send-email-sujith@msujith.org>
References: <1408895173-3732-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

There is no reason why managed/p2p interfaces have to
be limited to one. IBSS is the only type that needs
a restriction.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 5887499..ca10a8b 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -679,9 +679,11 @@ static const struct ieee80211_iface_limit wds_limits[] = {
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 
 static const struct ieee80211_iface_limit if_limits_multi[] = {
-	{ .max = 1,	.types = BIT(NL80211_IFTYPE_STATION) },
-	{ .max = 1,	.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
+	{ .max = 2,	.types = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_AP) |
+				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
 				 BIT(NL80211_IFTYPE_P2P_GO) },
+	{ .max = 1,	.types = BIT(NL80211_IFTYPE_ADHOC) },
 };
 
 static const struct ieee80211_iface_combination if_comb_multi[] = {
-- 
2.0.4


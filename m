Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:38801 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab3JGQlV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 12:41:21 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv2 3/3] ath9k: enable DFS for IBSS mode
Date: Mon,  7 Oct 2013 18:41:07 +0200
Message-Id: <1381164067-4830-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20131007_184127_452940_EB2BC02A)
In-Reply-To: <1381164067-4830-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1381164067-4830-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 9a1f349..bcc5698 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -791,7 +791,8 @@ static const struct ieee80211_iface_limit if_limits[] = {
 
 
 static const struct ieee80211_iface_limit if_dfs_limits[] = {
-	{ .max = 1,	.types = BIT(NL80211_IFTYPE_AP) },
+	{ .max = 1,	.types = BIT(NL80211_IFTYPE_AP) |
+				 BIT(NL80211_IFTYPE_ADHOC) },
 };
 
 static const struct ieee80211_iface_combination if_comb[] = {
-- 
1.7.10.4


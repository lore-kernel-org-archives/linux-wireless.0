Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([83.151.30.3]:51084 "EHLO m25s01.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648Ab3KHKfZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 05:35:25 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCHv2-resend] ath9k: enable DFS for IBSS mode
Date: Fri,  8 Nov 2013 11:35:19 +0100
Message-Id: <1383906919-8254-1-git-send-email-sw@simonwunderlich.de> (sfid-20131108_113528_760736_6392982D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e89db64..d8643eb 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -845,7 +845,8 @@ static const struct ieee80211_iface_limit if_limits[] = {
 };
 
 static const struct ieee80211_iface_limit if_dfs_limits[] = {
-	{ .max = 1,	.types = BIT(NL80211_IFTYPE_AP) },
+	{ .max = 1,	.types = BIT(NL80211_IFTYPE_AP) |
+				 BIT(NL80211_IFTYPE_ADHOC) },
 };
 
 static const struct ieee80211_iface_combination if_comb[] = {
-- 
1.7.10.4


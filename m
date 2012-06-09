Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19122 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934544Ab2FIAv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 20:51:27 -0400
Cc: <linux-wireless@vger.kernel.org>, <me@bobcopeland.com>,
	<mickflemm@gmail.com>, <kvalo@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
Subject: [RFC 3/3] ath9k: make CONFIG_ATH9K_DFS_CERTIFIED depend on CONFIG_CFG80211_EXPERT
Date: Fri, 8 Jun 2012 17:51:10 -0700
Message-ID: <1339203070-17979-4-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120609_025343_876663_0A21B46F)
In-Reply-To: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

Turns out every most standard Linux distributions enable
CONFIG_EXPERT, so use the shiny new CONFIG_CFG80211_EXPERT
which is meant by design to not be enabled by all Linux
distributions.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index e507e78..83463ed 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -64,7 +64,7 @@ config ATH9K_DEBUGFS
 
 config ATH9K_DFS_CERTIFIED
 	bool "Atheros DFS support for certified platforms"
-	depends on ATH9K && EXPERT
+	depends on ATH9K && CFG80211_EXPERT
 	default n
 	---help---
 	  This option enables DFS support for initiating radiation on
-- 
1.7.10.rc1.22.gf5241


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47875 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2GFWWF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 18:22:05 -0400
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	<arend@broadcom.com>, <henry@logout.com>,
	<senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
Subject: [PATCH v3 2/2] ath9k: make CONFIG_ATH9K_DFS_CERTIFIED depend on CFG80211_CERTIFICATION_ONUS
Date: Fri, 6 Jul 2012 15:21:52 -0700
Message-ID: <1341613312-11971-2-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120707_002209_415740_0D83080D)
In-Reply-To: <1341613312-11971-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1341613312-11971-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

Turns out every most standard Linux distributions enable
CONFIG_EXPERT, so use the shiny new CFG80211_CERTIFICATION_ONUS
which is meant by design to not be enabled by all Linux
distributions.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index e507e78..c7aa664 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -64,7 +64,7 @@ config ATH9K_DEBUGFS
 
 config ATH9K_DFS_CERTIFIED
 	bool "Atheros DFS support for certified platforms"
-	depends on ATH9K && EXPERT
+	depends on ATH9K && CFG80211_CERTIFICATION_ONUS
 	default n
 	---help---
 	  This option enables DFS support for initiating radiation on
-- 
1.7.10.rc1.22.gf5241


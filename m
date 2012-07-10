Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52065 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab2GJRZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 13:25:07 -0400
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	<arend@broadcom.com>, <henry@logout.com>,
	<senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
Subject: [PATCH v4 2/2] ath9k: make CONFIG_ATH9K_DFS_CERTIFIED depend on CFG80211_CERTIFICATION_ONUS
Date: Tue, 10 Jul 2012 10:24:54 -0700
Message-ID: <1341941094-11279-3-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120710_192518_781873_DBA8F8CE)
In-Reply-To: <1341941094-11279-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1341941094-11279-1-git-send-email-rodrigue@qca.qualcomm.com>
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


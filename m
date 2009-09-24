Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43110 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbZIXDHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 23:07:01 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/4] ath9k_hw: print device ID if not supported
Date: Wed, 23 Sep 2009 23:07:01 -0400
Message-Id: <1253761622-9530-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1253761622-9530-1-git-send-email-lrodriguez@atheros.com>
References: <1253761622-9530-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7d167a1..7bf0f8c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -900,8 +900,12 @@ int ath9k_hw_init(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	int r = 0;
 
-	if (!ath9k_hw_devid_supported(ah->hw_version.devid))
+	if (!ath9k_hw_devid_supported(ah->hw_version.devid)) {
+		ath_print(common, ATH_DBG_FATAL,
+			  "Unsupported device ID: 0x%0x\n",
+			  ah->hw_version.devid);
 		return -EOPNOTSUPP;
+	}
 
 	ath9k_hw_init_defaults(ah);
 	ath9k_hw_init_config(ah);
-- 
1.6.3.3


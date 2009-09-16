Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40559 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbZIPCzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 22:55:51 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: devel@linuxdriverproject.org, ath9k-devel@lists.ath9k.org,
	zhifeng.cai@atheros.com, Stephen.Chen@atheros.com,
	kevin@atheros.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC 2/3] ath: print device ID if not supported
Date: Tue, 15 Sep 2009 22:55:53 -0400
Message-Id: <1253069754-7470-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1253069754-7470-1-git-send-email-lrodriguez@atheros.com>
References: <1253069754-7470-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/hw.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/hw.c b/drivers/net/wireless/ath/hw.c
index faa5d32..a0a9647 100644
--- a/drivers/net/wireless/ath/hw.c
+++ b/drivers/net/wireless/ath/hw.c
@@ -883,8 +883,12 @@ int ath9k_hw_init(struct ath_hw *ah)
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


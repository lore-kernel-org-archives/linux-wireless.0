Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2FFNXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:35 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/29] iwlwifi: update mask value for SCD queue config
Date: Wed,  6 Jun 2012 15:22:01 +0200
Message-Id: <1338988930-11561-20-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152340_492018_ABA970A3)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Although we don't use bit 24, this bit is valid, but bit 23
is not. Update the mask accordingly.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-prph.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 3b10692..a9f0415 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -187,7 +187,7 @@
 #define SCD_QUEUE_STTS_REG_POS_ACTIVE	(3)
 #define SCD_QUEUE_STTS_REG_POS_WSL	(4)
 #define SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN (19)
-#define SCD_QUEUE_STTS_REG_MSK		(0x00FF0000)
+#define SCD_QUEUE_STTS_REG_MSK		(0x017F0000)
 
 #define SCD_QUEUE_CTX_REG1_CREDIT_POS		(8)
 #define SCD_QUEUE_CTX_REG1_CREDIT_MSK		(0x00FFFF00)
-- 
1.7.10


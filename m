Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61394 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbYGKD5I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 23:57:08 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 14/14] iwlwifi: make index unsigned int for iwl_send_led_cmd
Date: Fri, 11 Jul 2008 11:53:42 +0800
Message-Id: <1215748422-12672-15-git-send-email-yi.zhu@intel.com> (sfid-20080711_061545_165696_D0629C9B)
In-Reply-To: <1215748422-12672-14-git-send-email-yi.zhu@intel.com>
References: <1215748422-12672-1-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-2-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-3-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-4-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-5-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-6-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-7-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-8-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-9-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-10-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-11-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-12-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-13-git-send-email-yi.zhu@intel.com>
 <1215748422-12672-14-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

This is a small fix to change the idx type from int to unsigned.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-led.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-led.c      |    3 ++-
 drivers/net/wireless/iwlwifi/iwl-led.h      |    2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.h b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
index 6463e6e..47b7e0b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.h
@@ -54,7 +54,7 @@ struct iwl3945_led {
 	int (*led_on) (struct iwl3945_priv *priv, int led_id);
 	int (*led_off) (struct iwl3945_priv *priv, int led_id);
 	int (*led_pattern) (struct iwl3945_priv *priv, int led_id,
-			    int idx);
+			    unsigned int idx);
 
 	enum led_type type;
 	unsigned int registered;
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 0c09b90..899d7a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -106,7 +106,8 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 }
 
 /* Set led pattern command */
-static int iwl4965_led_pattern(struct iwl_priv *priv, int led_id, int idx)
+static int iwl4965_led_pattern(struct iwl_priv *priv, int led_id,
+			       unsigned int idx)
 {
 	struct iwl_led_cmd led_cmd = {
 		.id = led_id,
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.h b/drivers/net/wireless/iwlwifi/iwl-led.h
index 05e6a61..1980ae5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.h
+++ b/drivers/net/wireless/iwlwifi/iwl-led.h
@@ -55,7 +55,7 @@ struct iwl_led {
 
 	int (*led_on) (struct iwl_priv *priv, int led_id);
 	int (*led_off) (struct iwl_priv *priv, int led_id);
-	int (*led_pattern) (struct iwl_priv *priv, int led_id, int idx);
+	int (*led_pattern) (struct iwl_priv *priv, int led_id, unsigned int idx);
 
 	enum led_type type;
 	unsigned int registered;
-- 
1.5.3.6


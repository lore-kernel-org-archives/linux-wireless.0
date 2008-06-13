Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4097 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090AbYFMHrI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 03:47:08 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/3] iwlwifi: remove 4965 prefix from iwl4965_ucode
Date: Fri, 13 Jun 2008 15:44:54 +0800
Message-Id: <1213343095-8133-3-git-send-email-yi.zhu@intel.com> (sfid-20080613_094713_848313_F9B83434)
In-Reply-To: <1213343095-8133-2-git-send-email-yi.zhu@intel.com>
References: <1213343095-8133-1-git-send-email-yi.zhu@intel.com>
 <1213343095-8133-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

The patch removes 4965 prefix from iwl4965_ucode.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e6188f0..c508b11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -480,7 +480,7 @@ struct fw_desc {
 };
 
 /* uCode file layout */
-struct iwl4965_ucode {
+struct iwl_ucode {
 	__le32 ver;		/* major/minor/subminor */
 	__le32 inst_size;	/* bytes of runtime instructions */
 	__le32 data_size;	/* bytes of runtime data */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index c179b21..a9da17c 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -2002,7 +2002,7 @@ static void iwl4965_nic_start(struct iwl_priv *priv)
  */
 static int iwl4965_read_ucode(struct iwl_priv *priv)
 {
-	struct iwl4965_ucode *ucode;
+	struct iwl_ucode *ucode;
 	int ret;
 	const struct firmware *ucode_raw;
 	const char *name = priv->cfg->fw_name;
-- 
1.5.3.6


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49635 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab1FXTjI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 15:39:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/5] iwlagn: extend host command timeout
Date: Fri, 24 Jun 2011 12:07:15 -0700
Message-Id: <1308942437-6039-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110624_213925_357812_BB34374F)
In-Reply-To: <1308942437-6039-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308942437-6039-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We've infrequently seen timeouts, make the wait time
match the windows driver; hopefully our driver is
just too impatient.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-hcmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 7cdb1ec..e3e5fb6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -113,7 +113,7 @@ const char *get_cmd_string(u8 cmd)
 	}
 }
 
-#define HOST_COMPLETE_TIMEOUT (HZ / 2)
+#define HOST_COMPLETE_TIMEOUT (2 * HZ)
 
 static void iwl_generic_cmd_callback(struct iwl_priv *priv,
 				     struct iwl_device_cmd *cmd,
-- 
1.7.0.4


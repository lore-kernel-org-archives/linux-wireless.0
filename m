Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35816 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751653AbdF1UN5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:13:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:08 +0300
Message-Id: <20170628201330.9432-10-luca@coelho.fi> (sfid-20170628_221411_778935_ACD14583)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 09/31] iwlwifi: dvm: use macros for format strings
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some static checkers (e.g. smatch) complain if a non-constant
format string is used, even if that's a static const variable.
Since there's no impact on code generation, just change those
format strings to be macros.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
index 376c79337a0e..937be04c6c71 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c
@@ -681,11 +681,10 @@ DEBUGFS_READ_FILE_OPS(temperature);
 DEBUGFS_READ_WRITE_FILE_OPS(sleep_level_override);
 DEBUGFS_READ_FILE_OPS(current_sleep_command);
 
-static const char *fmt_value = "  %-30s %10u\n";
-static const char *fmt_hex   = "  %-30s       0x%02X\n";
-static const char *fmt_table = "  %-30s %10u  %10u  %10u  %10u\n";
-static const char *fmt_header =
-	"%-32s    current  cumulative       delta         max\n";
+#define fmt_value	"  %-30s %10u\n"
+#define fmt_hex		"  %-30s       0x%02X\n"
+#define fmt_table	"  %-30s %10u  %10u  %10u  %10u\n"
+#define fmt_header	"%-32s    current  cumulative       delta         max\n"
 
 static int iwl_statistics_flag(struct iwl_priv *priv, char *buf, int bufsz)
 {
-- 
2.11.0

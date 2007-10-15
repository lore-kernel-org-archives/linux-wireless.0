Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20717 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbXJOMlE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 08:41:04 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] iwlwifi: set correct base rate for A band in rs_dbgfs_set_mcs
Date: Mon, 15 Oct 2007 14:40:56 +0200
Message-Id: <1192452057872-git-send-email-tomas.winkler@intel.com> (sfid-20071015_134109_470914_41B80CD1)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch fixes base rate needed for fixed rate operation in A band

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index b88ed33..635661f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -2021,12 +2021,18 @@ static int open_file_generic(struct inode *inode, struct file *file)
 static void rs_dbgfs_set_mcs(struct iwl_rate_scale_priv *rs_priv,
 				struct iwl_rate *mcs, int index)
 {
-	const u32 cck_rate = 0x820A;
+	u32 base_rate;
+
+	if (rs_priv->phymode == (u8) MODE_IEEE80211A)
+		base_rate = 0x800D;
+	else
+		base_rate = 0x820A;
+
 	if (rs_priv->dbg_fixed.rate_n_flags) {
 		if (index < 12)
 			mcs->rate_n_flags = rs_priv->dbg_fixed.rate_n_flags;
 		else
-			mcs->rate_n_flags = cck_rate;
+			mcs->rate_n_flags = base_rate;
 		IWL_DEBUG_RATE("Fixed rate ON\n");
 		return;
 	}
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

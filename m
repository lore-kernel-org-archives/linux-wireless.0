Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41757 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab2HUQ5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 12:57:18 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.6 2/2] iwlwifi: protect SRAM debugfs
Date: Tue, 21 Aug 2012 18:57:11 +0200
Message-Id: <1345568231-20584-3-git-send-email-johannes@sipsolutions.net> (sfid-20120821_185725_108048_580DC130)
In-Reply-To: <1345568231-20584-1-git-send-email-johannes@sipsolutions.net>
References: <1345568231-20584-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the device is not started, we can't read its
SRAM and attempting to do so will cause issues.
Protect the debugfs read.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/debugfs.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/dvm/debugfs.c b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
index 46782f1..a47b306 100644
--- a/drivers/net/wireless/iwlwifi/dvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/debugfs.c
@@ -124,6 +124,9 @@ static ssize_t iwl_dbgfs_sram_read(struct file *file,
 	const struct fw_img *img;
 	size_t bufsz;
 
+	if (!iwl_is_ready_rf(priv))
+		return -EAGAIN;
+
 	/* default is to dump the entire data segment */
 	if (!priv->dbgfs_sram_offset && !priv->dbgfs_sram_len) {
 		priv->dbgfs_sram_offset = 0x800000;
-- 
1.7.10.4


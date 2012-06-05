Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36075 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2FEPyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 11:54:31 -0400
Message-ID: <1338911671.4514.48.camel@jlt3.sipsolutions.net> (sfid-20120605_175434_350103_558354EB)
Subject: [PATCH 3.5 v2] iwlwifi: fix double free/complete in firmware loading
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 05 Jun 2012 17:54:31 +0200
In-Reply-To: <1338881890.4514.13.camel@jlt3.sipsolutions.net> (sfid-20120605_093822_652064_2187C728)
References: <1338881890.4514.13.camel@jlt3.sipsolutions.net>
	 (sfid-20120605_093822_652064_2187C728)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Linus reported that due to mac80211 failing to register
the device (due to WoWLAN) his machine crashed etc. as
we double-freed the vmalloc() firmware area. His patch
to fix it was very similar to this one but I noticed
that there's another bug in the area: we complete the
completion before starting, so since we're running in
a work struct context stop() could be called while in
the middle of start() which will almost certainly lead
to issues.

Make a modification similar to his to avoid the double-
free but also move the completion to another spot so it
is only done after start() either finished or failed so
that stop() can have a consistent state.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index d742900..38fbbe7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -861,13 +861,18 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 
 	/* We have our copies now, allow OS release its copies */
 	release_firmware(ucode_raw);
-	complete(&drv->request_firmware_complete);
 
 	drv->op_mode = iwl_dvm_ops.start(drv->trans, drv->cfg, &drv->fw);
 
 	if (!drv->op_mode)
-		goto out_free_fw;
+		goto out_unbind;
 
+	/*
+	 * Complete the firmware request last so that
+	 * a driver unbind (stop) doesn't run while we
+	 * are doing the start() above.
+	 */
+	complete(&drv->request_firmware_complete);
 	return;
 
  try_again:
@@ -883,6 +888,7 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	release_firmware(ucode_raw);
  out_unbind:
 	complete(&drv->request_firmware_complete);
+ out_release_driver:
 	device_release_driver(drv->trans->dev);
 }
 
-- 
1.7.10




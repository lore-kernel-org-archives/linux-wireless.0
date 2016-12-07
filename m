Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33320 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752009AbcLGGgt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 01:36:49 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] iwlegacy: make il3945_mac_ops __ro_after_init
Date: Wed,  7 Dec 2016 07:36:46 +0100
Message-Id: <20161207063646.30969-1-johannes@sipsolutions.net> (sfid-20161207_073653_595076_2AB3237E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need for this to be only __read_mostly, since
it's only written in a single way depending on the module
parameter, so that can be moved into the module's __init
function, and the ops can be __ro_after_init.

This is a little bit safer since it means the ops can't
be overwritten (accidentally or otherwise), which would
otherwise cause an arbitrary function or bad pointer to
be called.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 466912eb2d87..e8e65115feba 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3469,7 +3469,7 @@ static struct attribute_group il3945_attribute_group = {
 	.attrs = il3945_sysfs_entries,
 };
 
-static struct ieee80211_ops il3945_mac_ops __read_mostly = {
+static struct ieee80211_ops il3945_mac_ops __ro_after_init = {
 	.tx = il3945_mac_tx,
 	.start = il3945_mac_start,
 	.stop = il3945_mac_stop,
@@ -3627,15 +3627,6 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	il->cmd_queue = IL39_CMD_QUEUE_NUM;
 
-	/*
-	 * Disabling hardware scan means that mac80211 will perform scans
-	 * "the hard way", rather than using device's scan.
-	 */
-	if (il3945_mod_params.disable_hw_scan) {
-		D_INFO("Disabling hw_scan\n");
-		il3945_mac_ops.hw_scan = NULL;
-	}
-
 	D_INFO("*** LOAD DRIVER ***\n");
 	il->cfg = cfg;
 	il->ops = &il3945_ops;
@@ -3913,6 +3904,15 @@ il3945_init(void)
 	pr_info(DRV_DESCRIPTION ", " DRV_VERSION "\n");
 	pr_info(DRV_COPYRIGHT "\n");
 
+	/*
+	 * Disabling hardware scan means that mac80211 will perform scans
+	 * "the hard way", rather than using device's scan.
+	 */
+	if (il3945_mod_params.disable_hw_scan) {
+		pr_info("hw_scan is disabled\n");
+		il3945_mac_ops.hw_scan = NULL;
+	}
+
 	ret = il3945_rate_control_register();
 	if (ret) {
 		pr_err("Unable to register rate control algorithm: %d\n", ret);
-- 
2.9.3

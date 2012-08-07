Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40013 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab2HGTqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 15:46:53 -0400
Message-ID: <1344368804.4766.4.camel@jlt3.sipsolutions.net> (sfid-20120807_214656_568440_9BA5DA61)
Subject: [PATCH] iwlegacy: clean up suspend/resume
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 07 Aug 2012 21:46:44 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to export the il_pci_suspend
and il_pci_resume functions since they're only
referenced from il_pm_ops. The latter can also
be defined using SIMPLE_DEV_PM_OPS instead of
open-coding it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlegacy/common.c |   15 +++------------
 drivers/net/wireless/iwlegacy/common.h |    2 --
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 0370403..eb99875 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4860,7 +4860,7 @@ EXPORT_SYMBOL(il_add_beacon_time);
 
 #ifdef CONFIG_PM
 
-int
+static int
 il_pci_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
@@ -4877,9 +4877,8 @@ il_pci_suspend(struct device *device)
 
 	return 0;
 }
-EXPORT_SYMBOL(il_pci_suspend);
 
-int
+static int
 il_pci_resume(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
@@ -4906,16 +4905,8 @@ il_pci_resume(struct device *device)
 
 	return 0;
 }
-EXPORT_SYMBOL(il_pci_resume);
 
-const struct dev_pm_ops il_pm_ops = {
-	.suspend = il_pci_suspend,
-	.resume = il_pci_resume,
-	.freeze = il_pci_suspend,
-	.thaw = il_pci_resume,
-	.poweroff = il_pci_suspend,
-	.restore = il_pci_resume,
-};
+SIMPLE_DEV_PM_OPS(il_pm_ops, il_pci_suspend, il_pci_resume);
 EXPORT_SYMBOL(il_pm_ops);
 
 #endif /* CONFIG_PM */
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 5f50177..3d3135e 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1845,8 +1845,6 @@ __le32 il_add_beacon_time(struct il_priv *il, u32 base, u32 addon,
 			  u32 beacon_interval);
 
 #ifdef CONFIG_PM
-int il_pci_suspend(struct device *device);
-int il_pci_resume(struct device *device);
 extern const struct dev_pm_ops il_pm_ops;
 
 #define IL_LEGACY_PM_OPS	(&il_pm_ops)
-- 
1.7.10.4




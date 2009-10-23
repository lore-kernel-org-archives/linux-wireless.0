Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24351 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbZJWUms (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 17/18] iwlwifi: make sure device is reset when unloading driver
Date: Fri, 23 Oct 2009 13:42:35 -0700
Message-Id: <1256330556-20997-18-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Add unconditional call to apm_ops.stop() to reset device to low power state
when unloading driver.  Some paths have existed to unload driver *without*
resetting device, therefore some errors have persisted through multiple
load/unload cycles, until the whole platform gets rebooted; this is an
attempt to remedy some of those situations.  Sorry, I can't seem to find
a bughost.org bug that specifically has these symptoms, but I had it happen
recently here.

Note that this will *not* fix situations in which the PCI express bus has
crashed (evidenced by register reads showing "0xffffffff"), e.g. bughost.org
1855 and 2096; device is unreachable from driver in those cases.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    9 +++++++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 +++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ea1b931..fa1672e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3256,6 +3256,15 @@ static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 		iwl_down(priv);
 	}
 
+	/*
+	 * Make sure device is reset to low power before unloading driver.
+	 * This may be redundant with iwl_down(), but there are paths to
+	 * run iwl_down() without calling apm_ops.stop(), and there are
+	 * paths to avoid running iwl_down() at all before leaving driver.
+	 * This (inexpensive) call *makes sure* device is reset.
+	 */
+	priv->cfg->ops->lib->apm_ops.stop(priv);
+
 	iwl_tt_exit(priv);
 
 	/* make sure we flush any pending irq or
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 9a430ee..bfd7f49 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4135,6 +4135,15 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 		iwl3945_down(priv);
 	}
 
+	/*
+	 * Make sure device is reset to low power before unloading driver.
+	 * This may be redundant with iwl_down(), but there are paths to
+	 * run iwl_down() without calling apm_ops.stop(), and there are
+	 * paths to avoid running iwl_down() at all before leaving driver.
+	 * This (inexpensive) call *makes sure* device is reset.
+	 */
+	priv->cfg->ops->lib->apm_ops.stop(priv);
+
 	/* make sure we flush any pending irq or
 	 * tasklet for the driver
 	 */
-- 
1.5.6.3


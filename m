Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60487 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbZLBGZU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 01:25:20 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] ipw2100: fix rebooting hang with driver loaded
Date: Wed,  2 Dec 2009 14:24:37 +0800
Message-Id: <1259735077-9668-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add PCI .shutdown method so that we can disable the device during
shutdown or reboot. Without this, the reboot doesn't work well on
some platforms.

This fixes http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2124

Tested-by: pablo <pablolm2005@gmail.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
This is for both .32 and -stable.

 drivers/net/wireless/ipw2x00/ipw2100.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 6c836c8..17a9cb3 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -6573,6 +6573,16 @@ static int ipw2100_resume(struct pci_dev *pci_dev)
 }
 #endif
 
+static void ipw2100_shutdown(struct pci_dev *pci_dev)
+{
+	struct ipw2100_priv *priv = pci_get_drvdata(pci_dev);
+
+	/* Take down the device; powers it off, etc. */
+	ipw2100_down(priv);
+
+	pci_disable_device(pci_dev);
+}
+
 #define IPW2100_DEV_ID(x) { PCI_VENDOR_ID_INTEL, 0x1043, 0x8086, x }
 
 static struct pci_device_id ipw2100_pci_id_table[] __devinitdata = {
@@ -6636,6 +6646,7 @@ static struct pci_driver ipw2100_pci_driver = {
 	.suspend = ipw2100_suspend,
 	.resume = ipw2100_resume,
 #endif
+	.shutdown = ipw2100_shutdown,
 };
 
 /**
-- 
1.6.3.3


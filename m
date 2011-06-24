Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab1FXJcP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 05:32:15 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlagn: fix rmmod crash
Date: Fri, 24 Jun 2011 11:34:34 +0200
Message-Id: <1308908074-4163-1-git-send-email-sgruszka@redhat.com> (sfid-20110624_113218_448692_96C81DBC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

priv->bus.bus_specific pointer is used after priv structures was freed,
in iwl_pci_remove(), what make ugly rmmod crash. This bug was introduced
by current pci changes.

On the way remove fake check, if prober error code is returned from
.probe() function, .remove() will never be called be null drvdata.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-pci.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 7328fbf..55a04b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -496,14 +496,11 @@ static void iwl_pci_down(void *bus)
 static void __devexit iwl_pci_remove(struct pci_dev *pdev)
 {
 	struct iwl_priv *priv = pci_get_drvdata(pdev);
-
-	/* This can happen if probe failed */
-	if (unlikely(!priv))
-		return;
+	void *bus_specific = priv->bus.bus_specific;
 
 	iwl_remove(priv);
 
-	iwl_pci_down(IWL_BUS_GET_PCI_BUS(&priv->bus));
+	iwl_pci_down(bus_specific);
 }
 
 #ifdef CONFIG_PM
-- 
1.7.1


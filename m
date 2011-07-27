Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab1G0MOD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 08:14:03 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-pci@vger.kernel.org
Subject: [RFC/RFT v2 10/12] pci: aspm: add settings changed callback
Date: Wed, 27 Jul 2011 14:14:57 +0200
Message-Id: <1311768899-4559-11-git-send-email-sgruszka@redhat.com> (sfid-20110727_141413_252917_D90F66CE)
In-Reply-To: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
References: <1311768899-4559-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Inform drivers that register pci_drviver->aspm_changed(), about new ASPM
settings. Callback is only called for child (endpoint) devices.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/pci/pcie/aspm.c |    5 ++++-
 include/linux/pci.h     |    3 +++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 2883fc3..d7acec8 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -474,8 +474,11 @@ static void pcie_config_aspm_link(struct pcie_link_state *link, u32 state)
 	 */
 	if (state & ASPM_STATE_L1)
 		pcie_config_aspm_dev(parent, upstream);
-	list_for_each_entry(child, &linkbus->devices, bus_list)
+	list_for_each_entry(child, &linkbus->devices, bus_list) {
 		pcie_config_aspm_dev(child, dwstream);
+		if (child->driver && child->driver->aspm_changed)
+			child->driver->aspm_changed(child, dwstream);
+	}
 	if (!(state & ASPM_STATE_L1))
 		pcie_config_aspm_dev(parent, upstream);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c446b5c..2110d63 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -555,6 +555,9 @@ struct pci_driver {
 	int  (*resume_early) (struct pci_dev *dev);
 	int  (*resume) (struct pci_dev *dev);	                /* Device woken up */
 	void (*shutdown) (struct pci_dev *dev);
+#ifdef CONFIG_PCIEASPM
+	void (*aspm_changed) (struct pci_dev *dev, u32 state);
+#endif
 	struct pci_error_handlers *err_handler;
 	struct device_driver	driver;
 	struct pci_dynids dynids;
-- 
1.7.1


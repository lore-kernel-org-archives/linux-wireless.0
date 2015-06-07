Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:47820 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbbFGN4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 09:56:44 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5/6] wil6210: platform hooks for modile init/exit
Date: Sun,  7 Jun 2015 16:56:30 +0300
Message-Id: <1433685391-9026-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150607_155651_337037_62A5BE48)
In-Reply-To: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1433685391-9026-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Provide platform hooks for module init/exit.
If platform require to perform some specific actions
in global context, this is where to do so.

Example may be turning on power for the PCIE based
on DT information.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c     | 22 +++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/wil_platform.c |  9 +++++++++
 drivers/net/wireless/ath/wil6210/wil_platform.h |  3 +++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 58c7916..a4417d4 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -291,7 +291,27 @@ static struct pci_driver wil6210_driver = {
 	.name		= WIL_NAME,
 };
 
-module_pci_driver(wil6210_driver);
+static int __init wil6210_driver_init(void)
+{
+	int rc;
+
+	rc = wil_platform_modinit();
+	if (rc)
+		return rc;
+
+	rc = pci_register_driver(&wil6210_driver);
+	if (rc)
+		wil_platform_modexit();
+	return rc;
+}
+module_init(wil6210_driver_init);
+
+static void __exit wil6210_driver_exit(void)
+{
+	pci_unregister_driver(&wil6210_driver);
+	wil_platform_modexit();
+}
+module_exit(wil6210_driver_exit);
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Qualcomm Atheros <wil6210@qca.qualcomm.com>");
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform.c b/drivers/net/wireless/ath/wil6210/wil_platform.c
index 976a071..1db680f 100644
--- a/drivers/net/wireless/ath/wil6210/wil_platform.c
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.c
@@ -17,6 +17,15 @@
 #include "linux/device.h"
 #include "wil_platform.h"
 
+int __init wil_platform_modinit(void)
+{
+	return 0;
+}
+
+void wil_platform_modexit(void)
+{
+}
+
 /**
  * wil_platform_init() - wil6210 platform module init
  *
diff --git a/drivers/net/wireless/ath/wil6210/wil_platform.h b/drivers/net/wireless/ath/wil6210/wil_platform.h
index 158c73b..d7fa19b 100644
--- a/drivers/net/wireless/ath/wil6210/wil_platform.h
+++ b/drivers/net/wireless/ath/wil6210/wil_platform.h
@@ -31,4 +31,7 @@ struct wil_platform_ops {
 
 void *wil_platform_init(struct device *dev, struct wil_platform_ops *ops);
 
+int __init wil_platform_modinit(void);
+void wil_platform_modexit(void);
+
 #endif /* __WIL_PLATFORM_H__ */
-- 
2.1.4


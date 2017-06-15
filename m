Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33989 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752640AbdFOSZ2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:28 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 22/23] nfctools: Move nciattach macros & enums to nciattach.c
Date: Thu, 15 Jun 2017 11:25:15 -0700
Message-Id: <20170615182516.4508-23-mgreer@animalcreek.com> (sfid-20170615_203119_736833_640C0AE5)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some header file macros and an enum were copied from Linux and placed
in neard's include/nfc_copy.h file.  That isn't the proper place as
nfc_copy.h is supposed to be a pristine copy of the Linux nfc.h file.
Move those header file definitions into tools/nciattach.c since that
is the only file that uses them.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 include/nfc_copy.h | 12 ------------
 tools/nciattach.c  | 12 ++++++++++++
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/nfc_copy.h b/include/nfc_copy.h
index 9e21738..0b25f5c 100644
--- a/include/nfc_copy.h
+++ b/include/nfc_copy.h
@@ -287,16 +287,4 @@ struct sockaddr_nfc_llcp {
 #define NFC_LLCP_REMOTE_LTO	3
 #define NFC_LLCP_REMOTE_RW	4
 
-#ifndef N_NCI
-#define N_NCI	25
-#endif
-
-/* Ioctl */
-#define NCIUARTSETDRIVER	_IOW('U', 0, char *)
-
-enum nci_uart_driver {
-	NCI_UART_DRIVER_MARVELL = 0,
-	NCI_UART_DRIVER_MAX
-};
-
 #endif /*__LINUX_NFC_H */
diff --git a/tools/nciattach.c b/tools/nciattach.c
index c71d9c7..370f98b 100644
--- a/tools/nciattach.c
+++ b/tools/nciattach.c
@@ -50,6 +50,18 @@
 #define ENABLE_PM	1
 #define DISABLE_PM	0
 
+#ifndef N_NCI
+#define N_NCI  25
+#endif
+
+/* Ioctl */
+#define NCIUARTSETDRIVER       _IOW('U', 0, char *)
+
+enum nci_uart_driver {
+	NCI_UART_DRIVER_MARVELL = 0,
+	NCI_UART_DRIVER_MAX
+};
+
 struct nci_driver_info {
 	const char *name;
 	enum nci_uart_driver driver_id;
-- 
2.13.0

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:19232 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965330Ab0COQW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Mar 2010 12:22:28 -0400
Received: by fg-out-1718.google.com with SMTP id 16so1530945fgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Mar 2010 09:22:27 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: fix warning when building rt2800pci with just soc support
Date: Mon, 15 Mar 2010 17:22:26 +0100
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201003151722.26406.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix compile warning "rt2800pci.c:1248: warning: 'rt2800pci_device_table'
defined but not used" when building rt2800pci with only soc support
(without pci).

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
Nothing important, had the patch in my tree and just noticed that I didn't
send it out yet.

 drivers/net/wireless/rt2x00/rt2800pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 10fafd0..0104906 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1184,6 +1184,7 @@ static const struct rt2x00_ops rt2800pci_ops = {
 /*
  * RT2800pci module information.
  */
+#ifdef CONFIG_RT2800PCI_PCI
 static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 	{ PCI_DEVICE(0x1814, 0x0601), PCI_DEVICE_DATA(&rt2800pci_ops) },
 	{ PCI_DEVICE(0x1814, 0x0681), PCI_DEVICE_DATA(&rt2800pci_ops) },
@@ -1211,6 +1212,7 @@ static DEFINE_PCI_DEVICE_TABLE(rt2800pci_device_table) = {
 #endif
 	{ 0, }
 };
+#endif /* CONFIG_RT2800PCI_PCI */
 
 MODULE_AUTHOR(DRV_PROJECT);
 MODULE_VERSION(DRV_VERSION);
-- 
1.6.0.2


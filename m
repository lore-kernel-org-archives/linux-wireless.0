Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48762 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab3JQHmx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 03:42:53 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 21/21] rt2x00: rt2800pci: use module_pci_driver macro
Date: Thu, 17 Oct 2013 09:42:35 +0200
Message-Id: <1381995755-16471-22-git-send-email-juhosg@openwrt.org> (sfid-20131017_094259_845749_4FDDFAC3)
In-Reply-To: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
References: <1381995755-16471-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the module_pci_driver() macro to make the code simpler
by eliminating module_init and module_exit calls.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800pci.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 260d2fd..b504455 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -470,16 +470,4 @@ static struct pci_driver rt2800pci_driver = {
 	.resume		= rt2x00pci_resume,
 };
 
-
-static int __init rt2800pci_init(void)
-{
-	return pci_register_driver(&rt2800pci_driver);
-}
-
-static void __exit rt2800pci_exit(void)
-{
-	pci_unregister_driver(&rt2800pci_driver);
-}
-
-module_init(rt2800pci_init);
-module_exit(rt2800pci_exit);
+module_pci_driver(rt2800pci_driver);
-- 
1.7.10

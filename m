Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:52808 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab0ADU4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:56:20 -0500
Date: Mon, 4 Jan 2010 21:56:19 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 10/14] mwl8k: add support for 88w8363 in STA mode
Message-ID: <20100104205619.GJ1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index fac8864..5f4f26e 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3346,11 +3346,17 @@ static void mwl8k_finalize_join_worker(struct work_struct *work)
 }
 
 enum {
-	MWL8687 = 0,
+	MWL8363 = 0,
+	MWL8687,
 	MWL8366,
 };
 
 static struct mwl8k_device_info mwl8k_info_tbl[] __devinitdata = {
+	[MWL8363] = {
+		.part_name	= "88w8363",
+		.helper_image	= "mwl8k/helper_8363.fw",
+		.fw_image	= "mwl8k/fmimage_8363.fw",
+	},
 	[MWL8687] = {
 		.part_name	= "88w8687",
 		.helper_image	= "mwl8k/helper_8687.fw",
@@ -3365,6 +3371,8 @@ static struct mwl8k_device_info mwl8k_info_tbl[] __devinitdata = {
 };
 
 static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
+	{ PCI_VDEVICE(MARVELL, 0x2a0c), .driver_data = MWL8363, },
+	{ PCI_VDEVICE(MARVELL, 0x2a24), .driver_data = MWL8363, },
 	{ PCI_VDEVICE(MARVELL, 0x2a2b), .driver_data = MWL8687, },
 	{ PCI_VDEVICE(MARVELL, 0x2a30), .driver_data = MWL8687, },
 	{ PCI_VDEVICE(MARVELL, 0x2a40), .driver_data = MWL8366, },
-- 
1.5.6.4

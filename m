Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58822 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab0ALMrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 07:47:23 -0500
Date: Tue, 12 Jan 2010 13:47:22 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 01/17] mwl8k: update MODULE_FIRMWARE tags
Message-ID: <20100112124722.GQ1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add MODULE_FIRMWARE tags for the mwl8k firmware images that don't
have them yet, and move them to where the firmware image names are
declared.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 13b0e32..01cabab 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -394,9 +394,6 @@ static int mwl8k_request_firmware(struct mwl8k_priv *priv)
 	return 0;
 }
 
-MODULE_FIRMWARE("mwl8k/helper_8687.fw");
-MODULE_FIRMWARE("mwl8k/fmimage_8687.fw");
-
 struct mwl8k_cmd_pkt {
 	__le16	code;
 	__le16	length;
@@ -3737,6 +3734,13 @@ static struct mwl8k_device_info mwl8k_info_tbl[] __devinitdata = {
 	},
 };
 
+MODULE_FIRMWARE("mwl8k/helper_8363.fw");
+MODULE_FIRMWARE("mwl8k/fmimage_8363.fw");
+MODULE_FIRMWARE("mwl8k/helper_8687.fw");
+MODULE_FIRMWARE("mwl8k/fmimage_8687.fw");
+MODULE_FIRMWARE("mwl8k/helper_8366.fw");
+MODULE_FIRMWARE("mwl8k/fmimage_8366.fw");
+
 static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
 	{ PCI_VDEVICE(MARVELL, 0x2a0c), .driver_data = MWL8363, },
 	{ PCI_VDEVICE(MARVELL, 0x2a24), .driver_data = MWL8363, },
-- 
1.5.6.4

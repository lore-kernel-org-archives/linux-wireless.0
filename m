Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45590 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbXLJRV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:21:58 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 31/48] libertas: cope with device which already has firmware loaded
Message-Id: <E1J1kpa-0006mc-OP@shinybook.infradead.org> (sfid-20071210_172200_889787_D1E9B02D)
Date: Mon, 10 Dec 2007 10:46:06 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 8 Dec 2007 23:49:06 +0000

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/if_usb.c |   35 ++++++++++++++++++++-----------
 drivers/net/wireless/libertas/if_usb.h |    2 +-
 2 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 87bed4a..141d185 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -374,20 +374,23 @@ static int if_prog_firmware(struct usb_card_rec *cardp)
 
 static int if_usb_reset_device(struct usb_card_rec *cardp)
 {
+	struct cmd_ds_command *cmd = (void *)&cardp->bulk_out_buffer[4];
 	int ret;
-	struct lbs_private *priv = cardp->priv;
 
 	lbs_deb_enter(LBS_DEB_USB);
 
-	/* Try a USB port reset first, if that fails send the reset
-	 * command to the firmware.
-	 */
+	*(__le32 *)cardp->bulk_out_buffer = cpu_to_le32(CMD_TYPE_REQUEST);
+
+	cmd->command = cpu_to_le16(CMD_802_11_RESET);
+	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_reset) + S_DS_GEN);
+	cmd->result = cpu_to_le16(0);
+	cmd->seqnum = cpu_to_le16(0x5a5a);
+	cmd->params.reset.action = cpu_to_le16(CMD_ACT_HALT);
+	usb_tx_block(cardp, cardp->bulk_out_buffer, 4 + S_DS_GEN + sizeof(struct cmd_ds_802_11_reset));
+
+	msleep(10);
 	ret = usb_reset_device(cardp->udev);
-	if (!ret && priv) {
-		msleep(10);
-		ret = lbs_reset_device(priv);
-		msleep(10);
-	}
+	msleep(10);
 
 	lbs_deb_leave_args(LBS_DEB_USB, "ret %d", ret);
 
@@ -508,9 +511,15 @@ static void if_usb_receive_fwload(struct urb *urb)
 			return;
 		}
 		if (bootcmdresp.u32magicnumber != cpu_to_le32(BOOT_CMD_MAGIC_NUMBER)) {
-			lbs_pr_info(
-				"boot cmd response wrong magic number (0x%x)\n",
-				le32_to_cpu(bootcmdresp.u32magicnumber));
+			if (bootcmdresp.u32magicnumber == cpu_to_le32(CMD_TYPE_REQUEST) ||
+			    bootcmdresp.u32magicnumber == cpu_to_le32(CMD_TYPE_DATA) ||
+			    bootcmdresp.u32magicnumber == cpu_to_le32(CMD_TYPE_INDICATION)) {
+				lbs_pr_info("Firmware already seems alive; resetting\n");
+				cardp->bootcmdresp = -1;
+			} else {
+				lbs_pr_info("boot cmd response wrong magic number (0x%x)\n",
+					    le32_to_cpu(bootcmdresp.u32magicnumber));
+			}
 		} else if (bootcmdresp.u8cmd_tag != BOOT_CMD_FW_BY_USB) {
 			lbs_pr_info(
 				"boot cmd response cmd_tag error (%d)\n",
@@ -883,7 +892,7 @@ restart:
 		} while (cardp->bootcmdresp == 0 && j < 10);
 	} while (cardp->bootcmdresp == 0 && i < 5);
 
-	if (cardp->bootcmdresp == 0) {
+	if (cardp->bootcmdresp <= 0) {
 		if (--reset_count >= 0) {
 			if_usb_reset_device(cardp);
 			goto restart;
diff --git a/drivers/net/wireless/libertas/if_usb.h b/drivers/net/wireless/libertas/if_usb.h
index f53ddb2..940a369 100644
--- a/drivers/net/wireless/libertas/if_usb.h
+++ b/drivers/net/wireless/libertas/if_usb.h
@@ -70,7 +70,7 @@ struct usb_card_rec {
 
 	u8 rx_urb_recall;
 
-	u8 bootcmdresp;
+	s8 bootcmdresp;
 };
 
 /** fwheader */
-- 
1.5.3.4


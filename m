Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:48814 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408AbYENA7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 20:59:13 -0400
Received: by py-out-1112.google.com with SMTP id u52so3171670pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 17:59:12 -0700 (PDT)
Message-ID: <482A3961.2010906@gmail.com> (sfid-20080514_025916_313567_6A4339C6)
Date: Tue, 13 May 2008 17:59:13 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Markus Becker <mab@comnets.uni-bremen.de>,
	hs4233@mail.mn-solutions.de, David@Woodhou.se,
	linux-wireless@vger.kernel.org
Subject: First patch to mrv8k driver?
Content-Type: multipart/mixed;
 boundary="------------090308060705030309060805"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090308060705030309060805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hey All,

My first patch for the mrv8k driver.  My machine locks up when I try to 
load a firmware, so I'm not sure if this patch helps anybody or not.

John Daiker



--------------090308060705030309060805
Content-Type: text/x-diff;
 name="formatting.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="formatting.diff"

Some formatting fixes, as well as a fwe mrv_reg_read32 returnvalue changes

Signed-off-by: John Daiker <daikerjohn@gmail.com>
---
 drivers/net/wireless/mrv8k/mrv8k.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mrv8k/mrv8k.c b/drivers/net/wireless/mrv8k/mrv8k.c
index a86ea9f..88497a1 100644
--- a/drivers/net/wireless/mrv8k/mrv8k.c
+++ b/drivers/net/wireless/mrv8k/mrv8k.c
@@ -241,8 +241,9 @@ static int mrv_upload_fw(struct mrv_priv *priv)
 
 	_mrv_send_cmd(priv, MRV_HWMEM_CMD_BOOT);
 
-	/* the boot code is stupid enought that it does not report any status when it
-	 * loads correctly and become alive. Wait 1 second..*/
+	/* The boot code is stupid enough that it does not report any status
+	 * when it loads correctly and become alive. Wait 1 second...
+	 */
 	msleep(1000);
 
 	err = request_firmware(&img, FW_FIRMWARE_FILENAME, &priv->pdev->dev);
@@ -260,12 +261,15 @@ static int mrv_upload_fw(struct mrv_priv *priv)
 		memcpy(cmd_data, img->data + i, 256);
 		mrv_send_cmd(priv);
 		for (j = 0; j < 500; j++) {
-			if (mrv_reg_read32(priv, MRV_REG_STATUS) == 5)
-			  break;
+			if (mrv_reg_read32(priv, MRV_REG_STATUS) == 0x5)
+				break;
 			mdelay(1);
 		}
+		/* We waited for 500 msecs and the card never went to the
+		 * magical 'Loading firmware' state
+		 */
 		if (j == 500) {
-			printk(KERN_ERR"Boot FW has failed to transfer real FW\n");
+			printk(KERN_ERR"Boot Firmware has failed to transfer a real Firmware\n");
 			return -2;
 		}
 	}
@@ -278,12 +282,15 @@ static int mrv_upload_fw(struct mrv_priv *priv)
 		memcpy(cmd_data, img->data + i, img->size - i);
 		mrv_send_cmd(priv);
 		for (j = 0; j < 500; j++) {
-			if (mrv_reg_read32(priv, MRV_REG_STATUS) == 5)
-			  break;
+			if (mrv_reg_read32(priv, MRV_REG_STATUS) == 0x5)
+				break;
 			mdelay(1);
 		}
+		/* We waited for 500 msecs and the card never transfered the
+		 * last portion of the firmware... return an error
+		 */
 		if (j == 500) {
-			printk(KERN_ERR"Boot FW has failed to transfer last real FW chunk\n");
+			printk(KERN_ERR"Boot Firmware has failed to transfer the last real Firmware chunk\n");
 			return -2;
 		}
 	}


--------------090308060705030309060805--

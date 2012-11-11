Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54521 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2KKOX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2012 09:23:58 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3615480wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 11 Nov 2012 06:23:57 -0800 (PST)
Message-ID: <1352643811.3000.49.camel@canaries32-MCP7A> (sfid-20121111_152402_577006_3C68E48A)
Subject: [PATCH] staging: vt6656: fix viawget_wpa_param size
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 11 Nov 2012 14:23:31 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

---
 drivers/staging/vt6656/iwctl.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 8f19874..e58049b 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1488,17 +1488,15 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 	size_t seq_len = 0;
 	size_t key_len = 0;
 	u8 *buf;
-	size_t blen;
 	u8 key_array[64];
 	int ret = 0;
 
-	PRINT_K("SIOCSIWENCODEEXT...... \n");
+	PRINT_K("SIOCSIWENCODEEXT......\n");
 
-	blen = sizeof(*param);
-	buf = kmalloc((int)blen, (int)GFP_KERNEL);
+	buf = kzalloc(sizeof(struct viawget_wpa_param), GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
-	memset(buf, 0, blen);
+
 	param = (struct viawget_wpa_param *)buf;
 
 // recover alg_name
@@ -1592,7 +1590,7 @@ int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 	spin_unlock_irq(&pDevice->lock);
 
 error:
-	kfree(param);
+	kfree(buf);
 	return ret;
 }
 
-- 
1.8.0




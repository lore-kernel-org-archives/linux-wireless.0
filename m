Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.zhinst.com ([212.126.164.98]:53329 "EHLO mail.zhinst.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933247AbcALM0r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 07:26:47 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8xxxu: Check return value of kmemdup()
Date: Tue, 12 Jan 2016 13:26:44 +0100
Message-Id: <1452601604-11309-1-git-send-email-tklauser@distanz.ch> (sfid-20160112_132650_219348_DD4B0C84)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In rtl8xxxu_load_firmware() check the return value of kmemdup() and
error out with -ENOMEM in case of NULL to prevent a NULL pointer
dereference.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 7d820c395375..59f70513c491 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2174,6 +2174,10 @@ static int rtl8xxxu_load_firmware(struct rtl8xxxu_priv *priv, char *fw_name)
 	}
 
 	priv->fw_data = kmemdup(fw->data, fw->size, GFP_KERNEL);
+	if (!priv->fw_data) {
+		ret = -ENOMEM;
+		goto exit;
+	}
 	priv->fw_size = fw->size - sizeof(struct rtl8xxxu_firmware_header);
 
 	signature = le16_to_cpu(priv->fw_data->signature);
-- 
2.7.0.1.g5e091f5



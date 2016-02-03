Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965910AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Tobias Klauser <tklauser@distanz.ch>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 09/28] rtl8xxxu: Check return value of kmemdup()
Date: Wed,  3 Feb 2016 13:39:43 -0500
Message-Id: <1454524802-26763-10-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_201501_709337_DD510DC1)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tobias Klauser <tklauser@distanz.ch>

In rtl8xxxu_load_firmware() check the return value of kmemdup() and
error out with -ENOMEM in case of NULL to prevent a NULL pointer
dereference.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index e98e053..08d8e1f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2197,6 +2197,10 @@ static int rtl8xxxu_load_firmware(struct rtl8xxxu_priv *priv, char *fw_name)
 	}
 
 	priv->fw_data = kmemdup(fw->data, fw->size, GFP_KERNEL);
+	if (!priv->fw_data) {
+		ret = -ENOMEM;
+		goto exit;
+	}
 	priv->fw_size = fw->size - sizeof(struct rtl8xxxu_firmware_header);
 
 	signature = le16_to_cpu(priv->fw_data->signature);
-- 
2.5.0


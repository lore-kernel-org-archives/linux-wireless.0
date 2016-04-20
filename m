Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34587 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbcDTG7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 02:59:41 -0400
Received: by mail-pf0-f182.google.com with SMTP id c20so15211491pfc.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2016 23:59:40 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com, helmut.schaa@googlemail.com,
	kvalo@qca.qualcomm.com, Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] rt2800usb: enable MFP if hw crypt is disabled
Date: Wed, 20 Apr 2016 14:59:32 +0800
Message-Id: <1461135572-7468-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20160420_085945_258848_874826B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If rt2800usb is loaded with nohwcrypt=1, mac80211 takes
care of the crypto with software encryption/decryption
and thus, MFP can be used.

Tested for secured mesh using ath9k_htc and ath9k.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 4b0bb6b..84ea329 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -48,6 +48,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");

 static bool rt2800usb_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
 {
+	ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
 	return modparam_nohwcrypt;
 }

--
2.3.0


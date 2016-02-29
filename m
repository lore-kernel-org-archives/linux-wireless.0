Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 033/113] rtl8xxxu: Do not overwrite rtl8xxxu_debug for untested chips
Date: Mon, 29 Feb 2016 17:04:31 -0500
Message-Id: <1456783551-28315-34-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230614_779479_2CD8D39D)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Fix a silly bug where the debug level was overwritten rather than
amended for untested chips.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 3829687..ac47b77 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -6391,7 +6391,7 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	}
 
 	if (untested) {
-		rtl8xxxu_debug = RTL8XXXU_DEBUG_EFUSE;
+		rtl8xxxu_debug |= RTL8XXXU_DEBUG_EFUSE;
 		dev_info(&udev->dev,
 			 "This Realtek USB WiFi dongle (0x%04x:0x%04x) is untested!\n",
 			 id->idVendor, id->idProduct);
-- 
2.5.0


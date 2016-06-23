Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbcFWSf5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 14:35:57 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 2/4] rtl8xxxu: Reduce console noise when removing the kernel module
Date: Thu, 23 Jun 2016 14:35:53 -0400
Message-Id: <1466706955-10339-3-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160623_203609_023050_FF8CC148)
In-Reply-To: <1466706955-10339-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1466706955-10339-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

USB urbs will return with a status != 0 when rmmod'ing the driver. No
need to fill the log with messages from rtl8xxxu_int_complete()

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 9f6dbb4..cfa5528 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5267,7 +5267,7 @@ static void rtl8xxxu_int_complete(struct urb *urb)
 		if (ret)
 			usb_unanchor_urb(urb);
 	} else {
-		dev_info(dev, "%s: Error %i\n", __func__, urb->status);
+		dev_dbg(dev, "%s: Error %i\n", __func__, urb->status);
 	}
 }
 
-- 
2.7.4


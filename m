Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59802 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbZEALMq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 May 2009 07:12:46 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: chunkeey@web.de
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] Fixes compile error with CONFIG_PM=n
Date: Fri,  1 May 2009 13:12:36 +0200
Message-Id: <1241176356-27531-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

/drivers/net/wireless/p54/p54usb.c: In function 'p54u_probe':
/drivers/net/wireless/p54/p54usb.c:923: error: 'struct usb_device' has no member named 'reset_resume'

In the struct usb_device the reset_resume attribute is only available when CONFIG_PM is defined.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/p54/p54usb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/p54/p54usb.c b/drivers/net/wireless/p54/p54usb.c
index ec6c954..f40c0f4 100644
--- a/drivers/net/wireless/p54/p54usb.c
+++ b/drivers/net/wireless/p54/p54usb.c
@@ -919,9 +919,11 @@ static int __devinit p54u_probe(struct usb_interface *intf,
 	priv->common.open = p54u_open;
 	priv->common.stop = p54u_stop;
 	if (recognized_pipes < P54U_PIPE_NUMBER) {
+#ifdef CONFIG_PM
 		/* ISL3887 needs a full reset on resume */
 		udev->reset_resume = 1;
 		err = p54u_device_reset(dev);
+#endif
 
 		priv->hw_type = P54U_3887;
 		dev->extra_tx_headroom += sizeof(struct lm87_tx_hdr);
-- 
1.6.2.1


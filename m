Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbcDNUhX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 16:37:23 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 13/16] rtl8xxxu: Fix OOPS if user tries to add device via /sys
Date: Thu, 14 Apr 2016 16:37:18 -0400
Message-Id: <1460666241-5365-14-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_225529_052526_1374F111)
In-Reply-To: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460666241-5365-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This driver relies on driver_info in struct usb_device_id, so allowing
adding a device via /sys/bus/usb/drivers/rtl8xxxu/new_id will cause a
NULL pointer dereference.

Set .no_dynamic_id = 1 to disable hot add of USB IDs.

Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index cf7832b..2d92e64 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -10141,6 +10141,7 @@ static struct usb_driver rtl8xxxu_driver = {
 	.probe = rtl8xxxu_probe,
 	.disconnect = rtl8xxxu_disconnect,
 	.id_table = dev_table,
+	.no_dynamic_id = 1,
 	.disable_hub_initiated_lpm = 1,
 };
 
-- 
2.5.5


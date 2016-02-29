Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbcB2WF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:57 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 099/113] rtl8xxxu: Define 8723b H2C ramask command structure
Date: Mon, 29 Feb 2016 17:05:37 -0500
Message-Id: <1456783551-28315-100-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232955_167345_DAD742E6)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Define H2C command structure for setting the rate mask.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 687b9a9..37657fe 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -893,7 +893,7 @@ enum h2c_cmd_8723b {
 	/*
 	 * Dynamic Mechanism Class: 010
 	 */
-	H2C_8723B_MACID_CFG = 0x40,
+	H2C_8723B_MACID_CFG_RAID = 0x40,
 	H2C_8723B_TXBF = 0x41,
 	H2C_8723B_RSSI_SETTING = 0x42,
 	H2C_8723B_AP_REQ_TXRPT = 0x43,
@@ -960,6 +960,15 @@ struct h2c_cmd {
 			u8 cmd;
 			u8 data1;
 			u8 data2;
+			u8 ramask1;
+			u8 ramask2;
+			u8 ramask3;
+			u8 ramask4;
+		} __packed b_macid_cfg;
+		struct {
+			u8 cmd;
+			u8 data1;
+			u8 data2;
 			u8 data3;
 			u8 data4;
 			u8 data5;
-- 
2.5.0


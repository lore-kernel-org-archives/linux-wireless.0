Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37316 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbbHFLWL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 07:22:11 -0400
From: Johannes Postma <jgmpostma@gmail.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Cc: Johannes Postma <jgmpostma@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] staging: rtl8723au: Fix sparse warning: cast to restricted __le16
Date: Thu,  6 Aug 2015 12:21:52 +0100
Message-Id: <1438860112-1786-1-git-send-email-jgmpostma@gmail.com> (sfid-20150806_132227_989734_EF7DB3AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usPtr is used as __le16 *, but was defined as u16 *.
This was reported by sparse as:
drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c:1850:29: warning: cast to
restricted __le16

This patch fixes the type of usPtr.

Signed-off-by: Johannes Postma <jgmpostma@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
index cb5076a..eb76ac4 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
@@ -1838,7 +1838,7 @@ Hal_EfuseParseThermalMeter_8723A(struct rtw_adapter *padapter,
 
 static void rtl8723a_cal_txdesc_chksum(struct tx_desc *ptxdesc)
 {
-	u16 *usPtr = (u16 *) ptxdesc;
+	__le16 *usPtr = (__le16 *)ptxdesc;
 	u32 count = 16;		/*  (32 bytes / 2 bytes per XOR) => 16 times */
 	u32 index;
 	u16 checksum = 0;
-- 
2.5.0


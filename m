Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:45310 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbbCKRVw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 13:21:52 -0400
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: Fix sparse warning cast to restricted __le16
Date: Wed, 11 Mar 2015 18:21:30 +0100
Message-Id: <1426094490-17065-1-git-send-email-marcus.folkesson@gmail.com> (sfid-20150311_182209_541251_A9FD63B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following sparse warnings:

  CHECK   drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
  drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c:265:37: warning:
  cast to restricted __le16
  drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c:267:39: warning:
  cast to restricted __le16

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
---
 drivers/staging/rtl8723au/include/rtl8723a_hal.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8723au/include/rtl8723a_hal.h b/drivers/staging/rtl8723au/include/rtl8723a_hal.h
index e146336..f642b11 100644
--- a/drivers/staging/rtl8723au/include/rtl8723a_hal.h
+++ b/drivers/staging/rtl8723au/include/rtl8723a_hal.h
@@ -255,10 +255,10 @@ struct hal_data_8723a {
 	struct hal_version		VersionID;
 	enum rt_customer_id CustomerID;
 
-	u16	FirmwareVersion;
-	u16	FirmwareVersionRev;
-	u16	FirmwareSubVersion;
-	u16	FirmwareSignature;
+	__le16	FirmwareVersion;
+	__le16	FirmwareVersionRev;
+	__le16	FirmwareSubVersion;
+	__le16	FirmwareSignature;
 
 	/* current WIFI_PHY values */
 	u32	ReceiveConfig;
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51303 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083Ab2CZSuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 14:50:18 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so8605045iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Mar 2012 11:50:18 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/6] rtlwifi: Add dm structs to private structure
Date: Mon, 26 Mar 2012 13:49:53 -0500
Message-Id: <1332787797-26475-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120326_205024_778321_79B1BC03)
In-Reply-To: <1332787797-26475-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1332787797-26475-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the dig_t and ps_t structures to the private variables.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/wifi.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/wifi.h b/drivers/net/wireless/rtlwifi/wifi.h
index 46e7505..e159190 100644
--- a/drivers/net/wireless/rtlwifi/wifi.h
+++ b/drivers/net/wireless/rtlwifi/wifi.h
@@ -1688,6 +1688,10 @@ struct rtl_priv {
 	   interface or hardware */
 	unsigned long status;
 
+	/* tables for dm */
+	struct dig_t dm_digtable;
+	struct ps_t dm_pstable;
+
 	/* data buffer pointer for USB reads */
 	__le32 *usb_data;
 	int usb_data_index;
-- 
1.7.7


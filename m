Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:63526 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111Ab3BAQku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 11:40:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 5/6] rtlwifi: rtl8192de: Fix W=1 build warnings
Date: Fri,  1 Feb 2013 10:40:26 -0600
Message-Id: <1359736827-30977-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130201_174104_191078_D17AF251)
In-Reply-To: <1359736827-30977-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1359736827-30977-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

when this driver is built with "make W=1", the following warning is printed:

drivers/net/wireless/rtlwifi/rtl8192de/dm.c:1058:5: warning: comparison is always false due to limited range of data type [-Wtype-limits]

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
index fd8df23..5251fb8 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
@@ -841,9 +841,9 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 	long ele_a = 0, ele_d, temp_cck, val_x, value32;
 	long val_y, ele_c = 0;
 	u8 ofdm_index[2];
-	u8 cck_index = 0;
+	s8 cck_index = 0;
 	u8 ofdm_index_old[2];
-	u8 cck_index_old = 0;
+	s8 cck_index_old = 0;
 	u8 index;
 	int i;
 	bool is2t = IS_92D_SINGLEPHY(rtlhal->version);
-- 
1.8.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:41576 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078Ab3BAQkr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 11:40:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 3/6] rtlwifi: rtl8192c: Fix W=1 warning
Date: Fri,  1 Feb 2013 10:40:24 -0600
Message-Id: <1359736827-30977-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130201_174114_558184_92F88F80)
In-Reply-To: <1359736827-30977-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1359736827-30977-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When this driver is built with "make W=1", the following warning occurs:

drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:907:4: warning: comparison is always false due to limited range of data type [-Wtype-limits]

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
index 1cdf5a2..b793a65 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c
@@ -669,7 +669,8 @@ static void rtl92c_dm_txpower_tracking_callback_thermalmeter(struct ieee80211_hw
 	u8 thermalvalue, delta, delta_lck, delta_iqk;
 	long ele_a, ele_d, temp_cck, val_x, value32;
 	long val_y, ele_c = 0;
-	u8 ofdm_index[2], cck_index = 0, ofdm_index_old[2], cck_index_old = 0;
+	u8 ofdm_index[2], ofdm_index_old[2], cck_index_old = 0;
+	s8 cck_index = 0;
 	int i;
 	bool is2t = IS_92C_SERIAL(rtlhal->version);
 	s8 txpwr_level[2] = {0, 0};
-- 
1.8.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:59832 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3EaVpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 17:45:38 -0400
Received: by mail-qe0-f74.google.com with SMTP id 1so192683qec.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 May 2013 14:45:37 -0700 (PDT)
From: Yunlian Jiang <yunlian@google.com>
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linville@tuxdriver.com, davem@davemloft.net, yunlian@google.com
Subject: [PATCH] rtlwifi: initialize local array and set value.
Date: Fri, 31 May 2013 14:45:21 -0700
Message-Id: <1370036721-18164-1-git-send-email-yunlian@google.com> (sfid-20130531_234541_520764_C527DEEC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

GCC 4.8 is spitting out uninitialized-variable warnings against
"drivers/net/wireless/rtlwifi/rtl8192de/dm.c".  

drivers/net/wireless/rtlwifi/rtl8192de/dm.c:941:31: 
error: 'ofdm_index_old[1]' may be used uninitialized in this
function [-Werror=maybe-uninitialized]
     rtlpriv->dm.ofdm_index[i] = ofdm_index_old[i];

This patch adds initialization to the variable and properly sets its value.
---
 drivers/net/wireless/rtlwifi/rtl8192de/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
index 19a7655..47875ba 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/dm.c
@@ -842,7 +842,7 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 	long val_y, ele_c = 0;
 	u8 ofdm_index[2];
 	s8 cck_index = 0;
-	u8 ofdm_index_old[2];
+	u8 ofdm_index_old[2] = {0, 0};
 	s8 cck_index_old = 0;
 	u8 index;
 	int i;
-- 
1.8.2.1


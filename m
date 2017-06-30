Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33079 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751729AbdF3ITu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Jun 2017 04:19:50 -0400
Received: by mail-pf0-f193.google.com with SMTP id e199so16208858pfh.0
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jun 2017 01:19:50 -0700 (PDT)
Date: Fri, 30 Jun 2017 13:49:45 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
To: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v3] rtlwifi: Replace hardcode value with macro
Message-ID: <20170630081945.GA3265@symbol-HP-ZBook-15> (sfid-20170630_101955_077006_8B4D8175)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
and hw->max_rate_tries are replaced by macro.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 6 +++---
 drivers/net/wireless/realtek/rtlwifi/base.h | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index bdc3791..f45d093 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -422,9 +422,9 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	hw->extra_tx_headroom = RTL_TX_HEADER_SIZE;

 	/* TODO: Correct this value for our hw */
-	/* TODO: define these hard code value */
-	hw->max_listen_interval = 10;
-	hw->max_rate_tries = 4;
+	/* defined these hard code values */
+	hw->max_listen_interval = MAX_LISTEN_INTERVAL;
+	hw->max_rate_tries = MAX_RATE_TRIES;
 	/* hw->max_rates = 1; */
 	hw->sta_data_size = sizeof(struct rtl_sta_info);

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
index 02ff0c5..d03e198 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.h
+++ b/drivers/net/wireless/realtek/rtlwifi/base.h
@@ -65,6 +65,8 @@ enum ap_peer {
 #define FRAME_OFFSET_ADDRESS3		16
 #define FRAME_OFFSET_SEQUENCE		22
 #define FRAME_OFFSET_ADDRESS4		24
+#define MAX_LISTEN_INTERVAL             10
+#define MAX_RATE_TRIES                  4

 #define SET_80211_HDR_FRAME_CONTROL(_hdr, _val)		\
 	WRITEEF2BYTE(_hdr, _val)
--
1.9.1

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33533 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753077AbdHBMUK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 08:20:10 -0400
Received: by mail-pf0-f195.google.com with SMTP id c65so5694922pfl.0
        for <linux-wireless@vger.kernel.org>; Wed, 02 Aug 2017 05:20:10 -0700 (PDT)
Date: Wed, 2 Aug 2017 17:50:05 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
To: arend.vanspriel@broadcom.com, kvalo@codeaurora.org,
        Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v5] rtlwifi: Replace hardcode value with macro
Message-ID: <20170802122005.GA4652@symbol-HP-ZBook-15> (sfid-20170802_142013_631987_48D555EB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
and hw->max_rate_tries are replaced by macro and removed the comment.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 5 ++---
 drivers/net/wireless/realtek/rtlwifi/base.h | 2 ++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 8b833e2..ea18aa7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -426,9 +426,8 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	hw->extra_tx_headroom = RTL_TX_HEADER_SIZE;

 	/* TODO: Correct this value for our hw */
-	/* TODO: define these hard code value */
-	hw->max_listen_interval = 10;
-	hw->max_rate_tries = 4;
+	hw->max_listen_interval = MAX_LISTEN_INTERVAL;
+	hw->max_rate_tries = MAX_RATE_TRIES;
 	/* hw->max_rates = 1; */
 	hw->sta_data_size = sizeof(struct rtl_sta_info);

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
index ab7d819..b56d1b7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.h
+++ b/drivers/net/wireless/realtek/rtlwifi/base.h
@@ -65,6 +65,8 @@ enum ap_peer {
 #define FRAME_OFFSET_ADDRESS3		16
 #define FRAME_OFFSET_SEQUENCE		22
 #define FRAME_OFFSET_ADDRESS4		24
+#define MAX_LISTEN_INTERVAL		10
+#define MAX_RATE_TRIES			4

 #define SET_80211_HDR_FRAME_CONTROL(_hdr, _val)		\
 	WRITEEF2BYTE(_hdr, _val)
--
1.9.1

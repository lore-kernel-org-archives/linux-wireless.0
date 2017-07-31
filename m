Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36072 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751054AbdGaLOt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2017 07:14:49 -0400
Received: by mail-pf0-f196.google.com with SMTP id t83so1145176pfj.3
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jul 2017 04:14:49 -0700 (PDT)
Date: Mon, 31 Jul 2017 16:44:45 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
To: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v4] rtlwifi: Replace hardcode value with macro
Message-ID: <20170731111445.GA4844@symbol-HP-ZBook-15> (sfid-20170731_131453_374514_AB0AA839)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In _rtl_init_mac80211(), hardcoded value for hw->max_listen_interval
and hw->max_rate_tries are replaced by macro.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index f45d093..52f2d0b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -422,7 +422,6 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 	hw->extra_tx_headroom = RTL_TX_HEADER_SIZE;

 	/* TODO: Correct this value for our hw */
-	/* defined these hard code values */
 	hw->max_listen_interval = MAX_LISTEN_INTERVAL;
 	hw->max_rate_tries = MAX_RATE_TRIES;
 	/* hw->max_rates = 1; */
--
1.9.1

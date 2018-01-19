Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:39529 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752190AbeASGqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 01:46:22 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 04/10] rtlwifi: btcoex: add scan_notify within ips_notify if RFON
Date: Fri, 19 Jan 2018 14:45:45 +0800
Message-ID: <20180119064551.10084-5-pkshih@realtek.com> (sfid-20180119_074633_606671_EA9A30CD)
In-Reply-To: <20180119064551.10084-1-pkshih@realtek.com>
References: <20180119064551.10084-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Three steps of connection procedure are scan, enter/leave IPS, auth.
There is no scan between leaving IPS and sending auth, but btcoex use scan
as an important clue that indicates user is going to connect. So add scan
notifications in ips_notify to correct btcoex's state.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
index bbc9517260b3..0111ab9e7b05 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/rtl_btc.c
@@ -212,6 +212,14 @@ void rtl_btc_ips_notify(struct rtl_priv *rtlpriv, u8 type)
 		return;
 
 	exhalbtc_ips_notify(btcoexist, type);
+
+	if (type == ERFON) {
+		/* In some situation, it doesn't scan after leaving IPS, and
+		 * this will cause btcoex in wrong state.
+		 */
+		exhalbtc_scan_notify(btcoexist, 1);
+		exhalbtc_scan_notify(btcoexist, 0);
+	}
 }
 
 void rtl_btc_lps_notify(struct rtl_priv *rtlpriv, u8 type)
-- 
2.15.1

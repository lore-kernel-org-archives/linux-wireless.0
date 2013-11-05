Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:40389 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3KEVQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 16:16:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: [PATCH 3/3] rtlwifi: rtl8192de: Fix incorrect signal strength for unassociated AP
Date: Tue,  5 Nov 2013 15:15:30 -0600
Message-Id: <1383686130-5113-4-git-send-email-Larry.Finger@lwfinger.net> (sfid-20131105_221612_730301_6AEC493B)
In-Reply-To: <1383686130-5113-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1383686130-5113-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The routine that processes received frames was returning the RSSI value for the
signal strength; however, that value is available only for associated APs. As
a result, the strength was the absurd value of 10 dBm. As a result, scans
return incorrect values for the strength, which causes unwanted attempts to roam.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org> [3.1+]
---
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
index 945ddec..0eb0f4a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -525,7 +525,7 @@ bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,	struct rtl_stats *stats,
 						   p_drvinfo);
 	}
 	/*rx_status->qual = stats->signal; */
-	rx_status->signal = stats->rssi + 10;
+	rx_status->signal = stats->recvsignalpower + 10;
 	return true;
 }
 
-- 
1.8.4


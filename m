Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:33634 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3IPSzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 14:55:54 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 6/8 V2] rtlwifi: Fix smatch warnings in usb.c
Date: Mon, 16 Sep 2013 13:55:20 -0500
Message-Id: <1379357722-17687-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130916_205559_742588_85700925)
In-Reply-To: <1379357722-17687-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1379357722-17687-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch displays the following:
  CHECK   drivers/net/wireless/rtlwifi/usb.c
drivers/net/wireless/rtlwifi/usb.c:458 _rtl_usb_rx_process_agg() warn: assigning (-98) to unsigned variable 'stats.noise'
drivers/net/wireless/rtlwifi/usb.c:503 _rtl_usb_rx_process_noagg() warn: assigning (-98) to unsigned variable 'stats.noise'
drivers/net/wireless/rtlwifi/usb.c:596 _rtl_rx_get_padding() info: ignoring unreachable code.
drivers/net/wireless/rtlwifi/usb.c:596 _rtl_rx_get_padding() info: ignoring unreachable code.

The negative number to an unsigned quantity is fixed by removing the variable
as it is no longer used. The unreachable code info is fixed by including the
appropriate section inside #ifdef .. #endif constructions.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/usb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index e56778c..60cb0b4 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -455,7 +455,6 @@ static void _rtl_usb_rx_process_agg(struct ieee80211_hw *hw,
 	struct ieee80211_rx_status rx_status = {0};
 	struct rtl_stats stats = {
 		.signal = 0,
-		.noise = -98,
 		.rate = 0,
 	};
 
@@ -498,7 +497,6 @@ static void _rtl_usb_rx_process_noagg(struct ieee80211_hw *hw,
 	struct ieee80211_rx_status rx_status = {0};
 	struct rtl_stats stats = {
 		.signal = 0,
-		.noise = -98,
 		.rate = 0,
 	};
 
@@ -582,12 +580,15 @@ static void _rtl_rx_work(unsigned long param)
 static unsigned int _rtl_rx_get_padding(struct ieee80211_hdr *hdr,
 					unsigned int len)
 {
+#if NET_IP_ALIGN != 0
 	unsigned int padding = 0;
+#endif
 
 	/* make function no-op when possible */
-	if (NET_IP_ALIGN == 0 || len < sizeof(*hdr))
+	if (NET_IP_ALIGN == 0 || len < sizeof(struct ieee80211_hdr))
 		return 0;
 
+#if NET_IP_ALIGN != 0
 	/* alignment calculation as in lbtf_rx() / carl9170_rx_copy_data() */
 	/* TODO: deduplicate common code, define helper function instead? */
 
@@ -608,6 +609,7 @@ static unsigned int _rtl_rx_get_padding(struct ieee80211_hdr *hdr,
 		padding ^= NET_IP_ALIGN;
 
 	return padding;
+#endif
 }
 
 #define __RADIO_TAP_SIZE_RSV	32
-- 
1.8.1.4


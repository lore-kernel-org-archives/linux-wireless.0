Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:60820 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab3IYR6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 13:58:14 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 6/8 V4] rtlwifi: Fix smatch warnings in usb.c
Date: Wed, 25 Sep 2013 12:57:47 -0500
Message-Id: <1380131869-19185-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130925_224458_328646_166EF5D4)
In-Reply-To: <1380131869-19185-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1380131869-19185-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch displays the following:
  CHECK   drivers/net/wireless/rtlwifi/usb.c
drivers/net/wireless/rtlwifi/usb.c:458 _rtl_usb_rx_process_agg() warn: assigning (-98) to unsigned variable 'stats.noise'
drivers/net/wireless/rtlwifi/usb.c:503 _rtl_usb_rx_process_noagg() warn: assigning (-98) to unsigned variable 'stats.noise'
drivers/net/wireless/rtlwifi/usb.c:596 _rtl_rx_get_padding() info: ignoring unreachable code.
drivers/net/wireless/rtlwifi/usb.c:596 _rtl_rx_get_padding() info: ignoring unreachable code.

The variable 'stats.noise' is not used, thus the initializers are removed.
The unreachable code info is fixed by including the appropriate section inside
#ifdef .. #endif constructions.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/usb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index e56778c..6e2b5c5 100644
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
 	if (NET_IP_ALIGN == 0 || len < sizeof(*hdr))
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


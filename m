Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:33149 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3IPSzv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Sep 2013 14:55:51 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 5/8 V2] [PATCH 5/7: rtlwifi: Fix smatch warning in pci.c
Date: Mon, 16 Sep 2013 13:55:19 -0500
Message-Id: <1379357722-17687-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130916_205640_210604_8C86C082)
In-Reply-To: <1379357722-17687-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1379357722-17687-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch reports the following:
  CHECK   drivers/net/wireless/rtlwifi/pci.c
drivers/net/wireless/rtlwifi/pci.c:739 _rtl_pci_rx_interrupt() warn: assigning (-98) to unsigned variable 'stats.noise'

This variable is not used and is removed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 703f839..6295ed2 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -736,7 +736,6 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 
 	struct rtl_stats stats = {
 		.signal = 0,
-		.noise = -98,
 		.rate = 0,
 	};
 	int index = rtlpci->rx_ring[rx_queue_idx].idx;
-- 
1.8.1.4


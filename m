Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:64688 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab3IRT72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 15:59:28 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org
Subject: [PATCH 5/8 V3] rtlwifi: Fix smatch warning in pci.c
Date: Wed, 18 Sep 2013 14:58:56 -0500
Message-Id: <1379534339-14895-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20130918_215934_687859_33087534)
In-Reply-To: <1379534339-14895-5-git-send-email-Larry.Finger@lwfinger.net>
References: <1379534339-14895-5-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch reports the following:
  CHECK   drivers/net/wireless/rtlwifi/pci.c
drivers/net/wireless/rtlwifi/pci.c:739 _rtl_pci_rx_interrupt() warn: assigning (-98) to unsigned variable 'stats.noise'

The variable 'stats.noise' is not used. That initializer is removed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/pci.c | 1 -
 1 file changed, 1 deletion(-)

Index: wireless-testing-save/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/pci.c
@@ -736,7 +736,6 @@ static void _rtl_pci_rx_interrupt(struct
 
 	struct rtl_stats stats = {
 		.signal = 0,
-		.noise = -98,
 		.rate = 0,
 	};
 	int index = rtlpci->rx_ring[rx_queue_idx].idx;

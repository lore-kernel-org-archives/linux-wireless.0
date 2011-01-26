Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54311 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1AZSU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 13:20:56 -0500
Received: by ywe10 with SMTP id 10so242284ywe.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jan 2011 10:20:55 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19776.26010.426561.683442@gargle.gargle.HOWL>
Date: Wed, 26 Jan 2011 23:49:06 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH] ath9k_hw: Add RX filters
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The HW has separate filter masks for compressed/uncompressed
BlockAcks and BlockAckRequests. Add them.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/mac.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 7512f97..04d58ae 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -639,6 +639,8 @@ enum ath9k_rx_filter {
 	ATH9K_RX_FILTER_PHYERR = 0x00000100,
 	ATH9K_RX_FILTER_MYBEACON = 0x00000200,
 	ATH9K_RX_FILTER_COMP_BAR = 0x00000400,
+	ATH9K_RX_FILTER_COMP_BA = 0x00000800,
+	ATH9K_RX_FILTER_UNCOMP_BA_BAR = 0x00001000,
 	ATH9K_RX_FILTER_PSPOLL = 0x00004000,
 	ATH9K_RX_FILTER_PHYRADAR = 0x00002000,
 	ATH9K_RX_FILTER_MCAST_BCAST_ALL = 0x00008000,
-- 
1.7.3.5


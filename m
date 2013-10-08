Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60851 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3JHDCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 23:02:45 -0400
Received: by mail-pd0-f176.google.com with SMTP id q10so8030845pdj.21
        for <linux-wireless@vger.kernel.org>; Mon, 07 Oct 2013 20:02:44 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix RX performance when using AP 10.X FW
Date: Mon,  7 Oct 2013 20:00:36 -0700
Message-Id: <1381201236-17035-1-git-send-email-michal.kazior@tieto.com> (sfid-20131008_050249_381215_079B40FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to oversight AP 10.X support was merged with
Ethernet RX decap mode.

Only Native Wifi RX decap mode guarantees IP
header is properly aligned and avoids sk_buff data
realignment (which is very expensive
performance-wise) in mac80211.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hw.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 3fd7b98..8aeb46d 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -123,7 +123,7 @@ enum ath10k_mcast2ucast_mode {
 #define TARGET_10X_RX_CHAIN_MASK		(BIT(0) | BIT(1) | BIT(2))
 #define TARGET_10X_RX_TIMEOUT_LO_PRI		100
 #define TARGET_10X_RX_TIMEOUT_HI_PRI		40
-#define TARGET_10X_RX_DECAP_MODE		ATH10K_HW_TXRX_ETHERNET
+#define TARGET_10X_RX_DECAP_MODE		ATH10K_HW_TXRX_NATIVE_WIFI
 #define TARGET_10X_SCAN_MAX_PENDING_REQS	4
 #define TARGET_10X_BMISS_OFFLOAD_MAX_VDEV	2
 #define TARGET_10X_ROAM_OFFLOAD_MAX_VDEV	2
-- 
1.8.4.rc3


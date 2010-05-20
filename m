Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22597 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404Ab0ETVrh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 17:47:37 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 14:47:37 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath9k: Fix bug in validating received data length for edma
Date: Thu, 20 May 2010 14:47:38 -0700
Message-ID: <1274392058-16317-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rx status length should also be taken into account while
validating the length of a received frame.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 95f1622..fc15b4b 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -827,6 +827,7 @@ static bool ath9k_rx_accept(struct ath_common *common,
 {
 	struct ath_hw *ah = common->ah;
 	__le16 fc;
+	u8 rx_status_len = ah->caps.rx_status_len;
 
 	fc = hdr->frame_control;
 
@@ -837,7 +838,7 @@ static bool ath9k_rx_accept(struct ath_common *common,
          * we can take a hint that hardware corrupted it, so ignore
          * those frames.
          */
-	if (rx_stats->rs_datalen > common->rx_bufsize)
+	if (rx_stats->rs_datalen > (common->rx_bufsize - rx_status_len))
 		return false;
 
 	/*
-- 
1.7.0.4


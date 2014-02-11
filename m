Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:44500 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaBKHhx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 02:37:53 -0500
Received: by mail-ea0-f169.google.com with SMTP id h10so3498585eak.14
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 23:37:51 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: remove excessive rx msdu len check
Date: Tue, 11 Feb 2014 08:37:06 +0100
Message-Id: <1392104226-12096-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20140211_083803_682291_518908ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This throw a lot of pointless warnings in case of DFS (radar
detection) and PHYERR events from firmware, when firmware may
actually insert more data, than we assume.

Besides of being noisy this debug does not protect or check
anything usefull currently. It was introduced long time ago
while debugging aggregations. So just removing it.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index fe8bd1b..f57f5cf 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -430,12 +430,6 @@ static int ath10k_htt_rx_amsdu_pop(struct ath10k_htt *htt,
 			msdu_chaining = 1;
 		}
 
-		if (msdu_len > 0) {
-			/* This may suggest FW bug? */
-			ath10k_warn("htt rx msdu len not consumed (%d)\n",
-				    msdu_len);
-		}
-
 		last_msdu = __le32_to_cpu(rx_desc->msdu_end.info0) &
 				RX_MSDU_END_INFO0_LAST_MSDU;
 
-- 
1.7.10


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49992 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439AbcEIXL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 19:11:27 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 13/21] ath10k: Document cycle count related counters.
Date: Mon,  9 May 2016 16:11:07 -0700
Message-Id: <1462835475-11079-14-git-send-email-greearb@candelatech.com> (sfid-20160510_011137_282951_659527DF)
In-Reply-To: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
References: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

They are not necessarily named in an intuitive manner,
so at least add some comments to help the next person.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index e7c228a..c4f649f 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -189,10 +189,10 @@ struct ath10k_fw_stats_pdev {
 
 	/* PDEV stats */
 	s32 ch_noise_floor;
-	u32 tx_frame_count;
-	u32 rx_frame_count;
-	u32 rx_clear_count;
-	u32 cycle_count;
+	u32 tx_frame_count; /* cycles spent transmitting frames */
+	u32 rx_frame_count; /* cycles spent receiving frames */
+	u32 rx_clear_count; /* Total channel busy time, evidently */
+	u32 cycle_count; /* Total on-channel time */
 	u32 phy_err_count;
 	u32 chan_tx_power;
 	u32 ack_rx_bad;
-- 
2.4.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13733 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbbBLVSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 16:18:30 -0500
From: Peter Oh <poh@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] ath10k: Update chirp value in pulse event
Date: Thu, 12 Feb 2015 13:17:04 -0800
Message-ID: <1423775825-19498-2-git-send-email-poh@qca.qualcomm.com> (sfid-20150212_221837_417961_89A314E1)
In-Reply-To: <1423775825-19498-1-git-send-email-poh@qca.qualcomm.com>
References: <1423775825-19498-1-git-send-email-poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware reports chirp status in phy error event if it's detected
and the chirp status is valuable to distinguish radar types.
So save it to use for DFS parttern detector.

Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 81561e4..0c06361 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2550,7 +2550,7 @@ static void ath10k_dfs_radar_report(struct ath10k *ar,
 	pe.freq = ar->hw->conf.chandef.chan->center_freq;
 	pe.width = width;
 	pe.rssi = rssi;
-
+	pe.chirp = (MS(reg0, RADAR_REPORT_REG0_PULSE_IS_CHIRP) != 0);
 	ath10k_dbg(ar, ATH10K_DBG_REGULATORY,
 		   "dfs add pulse freq: %d, width: %d, rssi %d, tsf: %llX\n",
 		   pe.freq, pe.width, pe.rssi, pe.ts);
-- 
1.9.1


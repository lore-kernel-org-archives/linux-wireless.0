Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34342 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730400AbeG3UdI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 16:33:08 -0400
Subject: [PATCH] ath10k: fix parenthesis alignment
From: Kalle Valo <kvalo@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Jul 2018 21:56:43 +0300
Message-ID: <153297700266.4874.12439168003972242663.stgit@potku.adurom.net> (sfid-20180730_205649_906176_C5BFEEFE)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These were recently introduced and found by checkpatch:

drivers/net/wireless/ath/ath10k/mac.c:6118: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/mac.c:6121: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/mac.c:6124: Alignment should match open parenthesis

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index f068e2b9eacc..b6830fa16e99 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6107,13 +6107,13 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
 
 		mode = chan_to_phymode(&def);
 		ath10k_dbg(ar, ATH10K_DBG_MAC, "mac update sta %pM peer bw %d phymode %d\n",
-				sta->addr, bw, mode);
+			   sta->addr, bw, mode);
 
 		err = ath10k_wmi_peer_set_param(ar, arvif->vdev_id, sta->addr,
-				WMI_PEER_PHYMODE, mode);
+						WMI_PEER_PHYMODE, mode);
 		if (err) {
 			ath10k_warn(ar, "failed to update STA %pM peer phymode %d: %d\n",
-					sta->addr, mode, err);
+				    sta->addr, mode, err);
 			goto exit;
 		}
 

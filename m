Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:12595 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758730Ab0FPKM7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:59 -0400
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0860683177
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 19:12:57 +0900 (JST)
Subject: [PATCH 17/17] ath5k: report PHY error frames only for chips which
	need it
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 16 Jun 2010 19:12:39 +0900
Message-ID: <20100616101239.10067.76859.stgit@tt-desk>
In-Reply-To: <20100616100809.10067.34787.stgit@tt-desk>
References: <20100616100809.10067.34787.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only report PHY error frames for ANI on chipsets which do not have PHY error
counters in hardware.

Signed-off-by: Bruno Randolf <br1@einfach.org>
Acked-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/desc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index c0037b6..4324438 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -651,7 +651,8 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 			rs->rs_status |= AR5K_RXERR_PHY;
 			rs->rs_phyerr = AR5K_REG_MS(rx_status->rx_status_1,
 				AR5K_5212_RX_DESC_STATUS1_PHY_ERROR_CODE);
-			ath5k_ani_phy_error_report(ah, rs->rs_phyerr);
+			if (!ah->ah_capabilities.cap_has_phyerr_counters)
+				ath5k_ani_phy_error_report(ah, rs->rs_phyerr);
 		}
 
 		if (rx_status->rx_status_1 &


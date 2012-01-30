Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:49102 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab2A3UCa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 15:02:30 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Santosh Sajjan <ssajjan@codeaurora.org>
Subject: [PATCH] ath6kl: Workaround to support Deep Sleep with MSM.
Date: Mon, 30 Jan 2012 22:02:26 +0200
Message-ID: <1327953746-5133-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120130_210233_582096_B2CD5FFB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Santosh Sajjan <ssajjan@codeaurora.org>

Set the host pm flag MMC_PM_WAKE_SDIO_IRQ to allow host
to disable the sdc2_clk and sdc2_h_clk,so that the MSM device
enter into TCXO shutdown.

Signed-off-by: Santosh Sajjan <ssajjan@codeaurora.org>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 07dcf00..4febee7 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -856,6 +856,19 @@ static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
 		if (ret)
 			goto cut_pwr;
 
+		/*
+		 * Workaround to support Deep Sleep with MSM, set the host pm
+		 * flag as MMC_PM_WAKE_SDIO_IRQ to allow SDCC deiver to disable
+		 * the sdc2_clock and internally allows MSM to enter
+		 * TCXO shutdown properly.
+		 */
+		if ((flags & MMC_PM_WAKE_SDIO_IRQ)) {
+			ret = sdio_set_host_pm_flags(func,
+						MMC_PM_WAKE_SDIO_IRQ);
+			if (ret)
+				goto cut_pwr;
+		}
+
 		ret = ath6kl_cfg80211_suspend(ar, ATH6KL_CFG_SUSPEND_DEEPSLEEP,
 					      NULL);
 		if (ret)
-- 
1.7.6


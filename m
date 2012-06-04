Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7336 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2FDK6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 06:58:50 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20428.38053.773721.647317@gargle.gargle.HOWL> (sfid-20120604_125852_523656_2E002DE4)
Date: Mon, 4 Jun 2012 16:27:41 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 07/20] ath9k: Add MCI interrupt to debugfs statistics
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    3 +++
 drivers/net/wireless/ath/ath9k/debug.h |    1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index fde700c..c134dda 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -374,6 +374,8 @@ void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status)
 		sc->debug.stats.istats.dtim++;
 	if (status & ATH9K_INT_TSFOOR)
 		sc->debug.stats.istats.tsfoor++;
+	if (status & ATH9K_INT_MCI)
+		sc->debug.stats.istats.mci++;
 }
 
 static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
@@ -418,6 +420,7 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 	PR_IS("DTIMSYNC", dtimsync);
 	PR_IS("DTIM", dtim);
 	PR_IS("TSFOOR", tsfoor);
+	PR_IS("MCI", mci);
 	PR_IS("TOTAL", total);
 
 	len += snprintf(buf + len, mxlen - len,
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index c34da09..d0f851c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -86,6 +86,7 @@ struct ath_interrupt_stats {
 	u32 dtim;
 	u32 bb_watchdog;
 	u32 tsfoor;
+	u32 mci;
 
 	/* Sync-cause stats */
 	u32 sync_cause_all;
-- 
1.7.10.3


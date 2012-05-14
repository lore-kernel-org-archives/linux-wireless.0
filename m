Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30716 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab2ENBye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 May 2012 21:54:34 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20400.26027.602254.846904@gargle.gargle.HOWL> (sfid-20120514_035436_608934_E34A045A)
Date: Mon, 14 May 2012 07:23:47 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 7/7] ath9k: Add MCI interrupt to debugfs statistics
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
1.7.10.2


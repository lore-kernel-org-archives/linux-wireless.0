Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:52010 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaL0OMc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2014 09:12:32 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so18718317wib.4
        for <linux-wireless@vger.kernel.org>; Sat, 27 Dec 2014 06:12:31 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: [RFC 3/3] ath9k: enable per-packet TPC on AR9002 based chips
Date: Sat, 27 Dec 2014 15:12:25 +0100
Message-Id: <1419689545-26965-4-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141227_151243_460860_69358A55)
In-Reply-To: <1419689545-26965-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1419689545-26965-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable per-packet TPC on AR9002 based chips by default

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/debug.c | 5 -----
 drivers/net/wireless/ath/ath9k/hw.c    | 3 +--
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index c43e2ad..a52cbf13 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1150,11 +1150,6 @@ static ssize_t write_file_tpc(struct file *file, const char __user *user_buf,
 	ssize_t len;
 	bool tpc_enabled;
 
-	if (!AR_SREV_9300_20_OR_LATER(ah)) {
-		/* ar9002 does not support TPC for the moment */
-		return -EOPNOTSUPP;
-	}
-
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 258c4d2..e2e4441 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -422,8 +422,7 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->power_mode = ATH9K_PM_UNDEFINED;
 	ah->htc_reset_init = true;
 
-	/* ar9002 does not support TPC for the moment */
-	ah->tpc_enabled = !!AR_SREV_9300_20_OR_LATER(ah);
+	ah->tpc_enabled = true;
 
 	ah->ani_function = ATH9K_ANI_ALL;
 	if (!AR_SREV_9300_20_OR_LATER(ah))
-- 
2.1.0


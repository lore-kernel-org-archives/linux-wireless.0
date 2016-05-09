Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49973 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbcEIXL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 19:11:26 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 03/21] ath10k: Support setting debug mask from driver code.
Date: Mon,  9 May 2016 16:10:57 -0700
Message-Id: <1462835475-11079-4-git-send-email-greearb@candelatech.com> (sfid-20160510_011133_824248_67635F7E)
In-Reply-To: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
References: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Might want to turn off verbose debug as soon as you
see a firmware crash, for instance.  Helps keep dmesg
output from over-running the stuff you care about.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 5 +++++
 drivers/net/wireless/ath/ath10k/debug.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index e251155..a689bf1 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -194,6 +194,11 @@ void ath10k_print_driver_info(struct ath10k *ar)
 }
 EXPORT_SYMBOL(ath10k_print_driver_info);
 
+void ath10k_set_debug_mask(unsigned int v) {
+	ath10k_debug_mask = v;
+}
+EXPORT_SYMBOL(ath10k_set_debug_mask);
+
 void ath10k_err(struct ath10k *ar, const char *fmt, ...)
 {
 	struct va_format vaf = {
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 75c89e3..a5c9aae 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -69,6 +69,7 @@ void ath10k_debug_print_hwfw_info(struct ath10k *ar);
 void ath10k_debug_print_board_info(struct ath10k *ar);
 void ath10k_debug_print_boot_info(struct ath10k *ar);
 void ath10k_print_driver_info(struct ath10k *ar);
+void ath10k_set_debug_mask(unsigned int v);
 
 #ifdef CONFIG_ATH10K_DEBUGFS
 int ath10k_debug_start(struct ath10k *ar);
-- 
2.4.3


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1959 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1IZJBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 05:01:13 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Fix compilation error while compiling w/o debug
Date: Mon, 26 Sep 2011 14:29:18 +0530
Message-ID: <1317027558-2691-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110926_110117_381989_1554FF64)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath/ath6kl/htc_hif.o:
In function `ath6kl_debug_fwlog_event':
drivers/net/wireless/ath/ath6kl/debug.h:109:
multiple definition of `ath6kl_debug_fwlog_event'
drivers/net/wireless/ath/ath6kl/debug.o:
drivers/net/wireless/ath/ath6kl/debug.h:109: first defined here
drivers/net/wireless/ath/ath6kl/htc_hif.o:
In function `ath6kl_debug_cleanup':
drivers/net/wireless/ath/ath6kl/debug.h:118:
multiple definition of `ath6kl_debug_cleanup'
drivers/net/wireless/ath/ath6kl/debug.o:
drivers/net/wireless/ath/ath6kl/debug.h:118: first defined here

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/debug.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index f0d6471..89bf8e1 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -105,7 +105,8 @@ static inline void dump_cred_dist_stats(struct htc_target *target)
 {
 }
 
-void ath6kl_debug_fwlog_event(struct ath6kl *ar, const void *buf, size_t len)
+static inline void ath6kl_debug_fwlog_event(struct ath6kl *ar,
+					    const void *buf, size_t len)
 {
 }
 
@@ -114,7 +115,7 @@ static inline int ath6kl_debug_init(struct ath6kl *ar)
 	return 0;
 }
 
-void ath6kl_debug_cleanup(struct ath6kl *ar)
+static inline void ath6kl_debug_cleanup(struct ath6kl *ar)
 {
 }
 
-- 
1.7.6.4


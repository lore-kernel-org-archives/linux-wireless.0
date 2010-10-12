Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:40830 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529Ab0JLOIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 10:08:09 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/3] ath9k: add missing locking around ath9k_hw_proc_mib_event
Date: Tue, 12 Oct 2010 16:08:03 +0200
Message-Id: <1286892483-71182-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1286892483-71182-2-git-send-email-nbd@openwrt.org>
References: <1286892483-71182-1-git-send-email-nbd@openwrt.org>
 <1286892483-71182-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_hw_proc_mib_event updates the cycle counters, so it common->cc_lock
must be acquired.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8656491..fa9be51 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -762,7 +762,9 @@ irqreturn_t ath_isr(int irq, void *dev)
 		 * it will clear whatever condition caused
 		 * the interrupt.
 		 */
+		spin_lock(&common->cc_lock);
 		ath9k_hw_proc_mib_event(ah);
+		spin_unlock(&common->cc_lock);
 		ath9k_hw_set_interrupts(ah, ah->imask);
 	}
 
-- 
1.7.2.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:27589 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932631Ab0I0DWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Sep 2010 23:22:35 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0205927752
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 12:22:32 +0900 (JST)
Subject: [PATCH 4/4] ath5k: Disable interrupts in ath5k_hw_get_tsf64
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 27 Sep 2010 12:22:32 +0900
Message-ID: <20100927032232.8754.25109.stgit@tt-desk>
In-Reply-To: <20100927032211.8754.49870.stgit@tt-desk>
References: <20100927032211.8754.49870.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code in ath5k_hw_get_tsf64() is time critical and will return wrong results
if we get interrupted, so disable local interrupts.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/pcu.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 604114f..095d30b 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -495,6 +495,10 @@ u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
 {
 	u32 tsf_lower, tsf_upper1, tsf_upper2;
 	int i;
+	unsigned long flags;
+
+	/* This code is time critical - we don't want to be interrupted here */
+	local_irq_save(flags);
 
 	/*
 	 * While reading TSF upper and then lower part, the clock is still
@@ -517,6 +521,8 @@ u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
 		tsf_upper1 = tsf_upper2;
 	}
 
+	local_irq_restore(flags);
+
 	WARN_ON( i == ATH5K_MAX_TSF_READ );
 
 	return (((u64)tsf_upper1 << 32) | tsf_lower);


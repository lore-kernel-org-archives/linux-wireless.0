Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:28421 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab3A1QiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:38:21 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 02/14] wil6210: rearrange IRQ debug printing
Date: Mon, 28 Jan 2013 18:30:57 +0200
Message-ID: <1359390669-9310-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173824_362422_90D8829B)
In-Reply-To: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make printings from IRQ appears in dmesg in chronological order

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index d2109d5..660bacf 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -390,6 +390,8 @@ static irqreturn_t wil6210_hardirq(int irq, void *cookie)
 	if (wil6210_debug_irq_mask(wil, pseudo_cause))
 		return IRQ_NONE;
 
+	wil_dbg_IRQ(wil, "Pseudo IRQ 0x%08x\n", pseudo_cause);
+
 	wil6210_mask_irq_pseudo(wil);
 
 	/* Discover real IRQ cause
@@ -421,8 +423,6 @@ static irqreturn_t wil6210_hardirq(int irq, void *cookie)
 	if (rc != IRQ_WAKE_THREAD)
 		wil6210_unmask_irq_pseudo(wil);
 
-	wil_dbg_IRQ(wil, "Hard IRQ 0x%08x\n", pseudo_cause);
-
 	return rc;
 }
 
-- 
1.7.10.4


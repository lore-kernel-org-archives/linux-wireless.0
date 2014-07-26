Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51712 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaGZEya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2014 00:54:30 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath9k: Initialize channel context ops on ahb probe
Date: Sat, 26 Jul 2014 10:25:41 +0530
Message-ID: <1406350541-16044-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140726_065433_990730_C9051F88)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not doing so, could fail on device probing when use_chanctx
module param is set to true.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index be3eb2a..4173838 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -113,6 +113,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 
 	irq = res->start;
 
+	ath9k_fill_chanctx_ops();
 	hw = ieee80211_alloc_hw(sizeof(struct ath_softc), &ath9k_ops);
 	if (hw == NULL) {
 		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
-- 
2.0.1


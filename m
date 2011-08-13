Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3509 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1HME6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 00:58:11 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 03/11] ath9k: Re-enable RXOEL interrupt after processing rx buffers
Date: Sat, 13 Aug 2011 10:28:10 +0530
Message-ID: <1313211498-14442-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110813_065817_678980_8F69897F)
In-Reply-To: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1313211498-14442-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once RXEOL was disabled, it never be enabled again. This patch
re-enables rxeol at the end of rx tasklet.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 7409402..c0c66e0 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1978,5 +1978,10 @@ requeue:
 
 	spin_unlock_bh(&sc->rx.rxbuflock);
 
+	if (!(ah->imask & ATH9K_INT_RXEOL)) {
+		ah->imask |= (ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
+		ath9k_hw_set_interrupts(ah, ah->imask);
+	}
+
 	return 0;
 }
-- 
1.7.6


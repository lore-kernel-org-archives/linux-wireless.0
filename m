Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55321 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaFXLhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 07:37:21 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 5/5] ath9k_hw: Fix pll2_divfrac for AR953x
Date: Tue, 24 Jun 2014 17:07:49 +0530
Message-ID: <1403609869-12901-5-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140624_133725_504809_F09148C2)
In-Reply-To: <1403609869-12901-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1403609869-12901-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ace4fe2..fd0158f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -791,7 +791,8 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
 				refdiv = 5;
 			} else {
 				pll2_divint = 0x11;
-				pll2_divfrac = 0x26666;
+				pll2_divfrac =
+					AR_SREV_9531(ah) ? 0x26665 : 0x26666;
 				refdiv = 1;
 			}
 		}
-- 
2.0.0


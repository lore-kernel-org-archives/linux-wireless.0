Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:42799 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbbHUNN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2015 09:13:28 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix compilation warnings in wmi phyerr pull function
Date: Fri, 21 Aug 2015 18:42:36 +0530
Message-ID: <1440162756-4025-1-git-send-email-rmani@qti.qualcomm.com> (sfid-20150821_151331_501856_14A3803D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Below compilation warnings are observed in gcc version 4.8.2.
Even though it's not seen in bit older gcc versions (for ex, 4.7.3),
It's good to fix it by changing format specifier from %d to
%zd in wmi pull phyerr functions.

wmi.c: In function 'ath10k_wmi_op_pull_phyerr_ev':
wmi.c:3567:8: warning: format '%d' expects argument of type 'int',
              but argument 4 has type 'long unsigned int' [-Wformat=]
              left_len, sizeof(*phyerr));
                        ^
wmi.c: In function 'ath10k_wmi_10_4_op_pull_phyerr_ev':
wmi.c:3612:8: warning: format '%d' expects argument of type 'int',
	      but argument 4 has type 'long unsigned int' [-Wformat=]
              left_len, sizeof(*phyerr));
                        ^
Fixes: 991adf71a6cd ("ath10k: refactor phyerr event handlers")
Fixes: 2b0a2e0d7c2f ("ath10k: handle 10.4 firmware phyerr event")

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 42c0aba..fe150e8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3563,7 +3563,7 @@ int ath10k_wmi_op_pull_phyerr_ev(struct ath10k *ar,
 	int i;
 
 	if (left_len < sizeof(*phyerr)) {
-		ath10k_warn(ar, "wrong phyerr event head len %d (need: >=%d)\n",
+		ath10k_warn(ar, "wrong phyerr event head len %d (need: >=%zd)\n",
 			    left_len, sizeof(*phyerr));
 		return -EINVAL;
 	}
@@ -3608,7 +3608,7 @@ static int ath10k_wmi_10_4_op_pull_phyerr_ev(struct ath10k *ar,
 	int i;
 
 	if (left_len < sizeof(*phyerr)) {
-		ath10k_warn(ar, "wrong phyerr event head len %d (need: >=%d)\n",
+		ath10k_warn(ar, "wrong phyerr event head len %d (need: >=%zd)\n",
 			    left_len, sizeof(*phyerr));
 		return -EINVAL;
 	}
-- 
1.8.1.2


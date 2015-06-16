Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:25629 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932289AbbFPIkW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 04:40:22 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: poh@qca.qualcomm.com, ath9k-devel@venema.h4ckr.net,
	ath10k@lists.infradead.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath: DFS - limit number of potential PRI sequences
Date: Tue, 16 Jun 2015 10:34:03 +0200
Message-Id: <1434443643-28477-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20150616_104059_350772_BEE69A5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the PRI detector, after the current radar pulse
has been checked agains existing PRI sequences, it
is considered as part of a new potential sequence.

Previously, the condition to accept a new sequence
was to have at least the same number of pulses as
the longest matching sequence. This was wrong,
since it led to duplicates of PRI sequences.

This patch changes the acceptance criteria for new
potential sequences from 'at least' to 'more than'
the longest existing.

Detection performance remains unaffected, while
the number of PRI sequences accounted at runtime
(and with it CPU load) is reduced by up to 50%.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/dfs_pri_detector.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/dfs_pri_detector.c b/drivers/net/wireless/ath/dfs_pri_detector.c
index 1b5ad19..cc5c592 100644
--- a/drivers/net/wireless/ath/dfs_pri_detector.c
+++ b/drivers/net/wireless/ath/dfs_pri_detector.c
@@ -273,7 +273,7 @@ static bool pseq_handler_create_sequences(struct pri_detector *pde,
 				tmp_false_count++;
 			}
 		}
-		if (ps.count < min_count)
+		if (ps.count <= min_count)
 			/* did not reach minimum count, drop sequence */
 			continue;
 
-- 
1.9.1


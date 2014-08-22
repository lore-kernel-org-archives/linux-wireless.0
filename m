Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:59300 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108AbaHVNSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 09:18:21 -0400
Received: by mail-ig0-f171.google.com with SMTP id l13so14897078iga.10
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 06:18:20 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, mickflemm@gmail.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/3] ath5k: drop useless comparison
Date: Fri, 22 Aug 2014 09:18:00 -0400
Message-Id: <1408713482-7917-1-git-send-email-me@bobcopeland.com> (sfid-20140822_151825_297344_0DD36919)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rxs->rate_idx is unsigned, so it will always be >= 0.
Found by Coverity.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
John & Nick,

This and the next two patches are some simple cleanups from static
checkers, but no actual bugs here, so they can wait for 3.18.

 drivers/net/wireless/ath/ath5k/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index ef35da8..03ab134 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1417,7 +1417,7 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
 		break;
 	}
 
-	if (rxs->rate_idx >= 0 && rs->rs_rate ==
+	if (rs->rs_rate ==
 	    ah->sbands[ah->curchan->band].bitrates[rxs->rate_idx].hw_value_short)
 		rxs->flag |= RX_FLAG_SHORTPRE;
 
-- 
1.7.10.4


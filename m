Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47300 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab1AGAqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 19:46:13 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>,
	Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH 1/3] ath9k: Decrease skb size to fit into one page.
Date: Thu,  6 Jan 2011 16:46:03 -0800
Message-Id: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Patch is from Eric Dumazet, as described here:
https://patchwork.kernel.org/patch/104271/

Reported-by: Michael Guntsche <mike@it-loops.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Ben Greear <greearb@candelatech.com>
---

NOTE:  This needs review by ath9k and/or other informed
people.

:100644 100644 b2497b8... 270661d... M	drivers/net/wireless/ath/ath9k/recv.c
 drivers/net/wireless/ath/ath9k/recv.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b2497b8..270661d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -230,11 +230,11 @@ static int ath_rx_edma_init(struct ath_softc *sc, int nbufs)
 	int error = 0, i;
 	u32 size;
 
-
-	common->rx_bufsize = roundup(IEEE80211_MAX_MPDU_LEN +
-				     ah->caps.rx_status_len,
-				     min(common->cachelsz, (u16)64));
-
+	size = roundup(IEEE80211_MAX_MPDU_LEN + ah->caps.rx_status_len,
+		       min(common->cachelsz, (u16)64));
+	common->rx_bufsize = max_t(u32, size,
+				   SKB_MAX_ORDER(NET_SKB_PAD
+						 + common->cachelsz, 0));
 	ath9k_hw_set_rx_bufsize(ah, common->rx_bufsize -
 				    ah->caps.rx_status_len);
 
-- 
1.7.2.3


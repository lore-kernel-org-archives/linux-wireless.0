Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49421 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768AbcCaU7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 16:59:55 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/3] ath10k:  Add BUG_ON if we over-write peer-map pointer.
Date: Thu, 31 Mar 2016 13:59:46 -0700
Message-Id: <1459457986-29222-3-git-send-email-greearb@candelatech.com> (sfid-20160331_230004_043349_ECE87FBF)
In-Reply-To: <1459457986-29222-1-git-send-email-greearb@candelatech.com>
References: <1459457986-29222-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Not sure this can happen, but seems like a reasonable sanity
check.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 94c27f6..172b1d6 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -309,6 +309,7 @@ void ath10k_peer_map_event(struct ath10k_htt *htt,
 	ath10k_warn(ar, /*ATH10K_DBG_HTT,*/ "htt peer map vdev %d peer %pM id %d\n",
 		   ev->vdev_id, ev->addr, ev->peer_id);
 
+	BUG_ON(ar->peer_map[ev->peer_id] && (ar->peer_map[ev->peer_id] != peer));
 	ar->peer_map[ev->peer_id] = peer;
 	set_bit(ev->peer_id, peer->peer_ids);
 exit:
-- 
2.4.3


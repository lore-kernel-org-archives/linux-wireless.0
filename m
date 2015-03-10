Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46108 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbbCJOog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 10:44:36 -0400
From: Florian Westphal <fw@strlen.de>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH next] ath9k: make ath_frame_info fit into reduced-size rate_driver_data
Date: Tue, 10 Mar 2015 15:44:22 +0100
Message-Id: <1425998662-28401-1-git-send-email-fw@strlen.de> (sfid-20150310_154441_961196_4D746EF3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pre-requisite to shrink size of ieee80211_tx_info which in turn is
needed to shrink skb->cb to 40 bytes again.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 7e89236..a7a81b3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -184,12 +184,12 @@ struct ath_frame_info {
 	struct ath_buf *bf;
 	u16 framelen;
 	s8 txq;
-	enum ath9k_key_type keytype;
 	u8 keyix;
 	u8 rtscts_rate;
 	u8 retries : 7;
 	u8 baw_tracked : 1;
 	u8 tx_power;
+	enum ath9k_key_type keytype:2;
 };
 
 struct ath_rxbuf {
-- 
2.0.5


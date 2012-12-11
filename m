Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35149 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab2LKNzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 08:55:10 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Gabor Juhos <juhosg@openwrt.org>,
	<ath5k-devel@lists.ath5k.org>
Subject: [PATCH 2/3] ath5k: zero-out rx_status
Date: Tue, 11 Dec 2012 14:55:04 +0100
Message-Id: <1355234105-12013-2-git-send-email-juhosg@openwrt.org> (sfid-20121211_145520_189923_F3FED058)
In-Reply-To: <1355234105-12013-1-git-send-email-juhosg@openwrt.org>
References: <1355234105-12013-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 'mac80211: support radiotap vendor namespace RX data'
new fields were added to 'struct ieee80211_rx_status'.
The ath5k driver does not initializes those fields and
this can cause unexpected behaviour. The patch ensures
that each field gets initialized with zeroes.

Cc: <ath5k-devel@lists.ath5k.org>
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Compile tested only.
---
 drivers/net/wireless/ath/ath5k/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 4ad40cf..8adf9c3 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1323,8 +1323,8 @@ ath5k_receive_frame(struct ath5k_hw *ah, struct sk_buff *skb,
 	ath5k_remove_padding(skb);
 
 	rxs = IEEE80211_SKB_RXCB(skb);
+	memset(rxs, 0, sizeof(*rxs));
 
-	rxs->flag = 0;
 	if (unlikely(rs->rs_status & AR5K_RXERR_MIC))
 		rxs->flag |= RX_FLAG_MMIC_ERROR;
 
-- 
1.7.10


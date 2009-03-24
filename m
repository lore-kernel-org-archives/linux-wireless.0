Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3988 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbZCXDgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 23:36:00 -0400
Date: Mon, 23 Mar 2009 23:35:37 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, mickflemm@gmail.com,
	jirislaby@gmail.com, lrodriguez@atheros.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: properly drop packets from ops->tx
Message-ID: <20090324033537.GA9333@hash.localnet> (sfid-20090324_043604_911288_9B094E6B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We shouldn't return NETDEV_TX_BUSY from the TX callback, especially
after we've mucked with the sk_buffs.  Drop the packets and return
NETDEV_TX_OK.

Changes-licensed-under: 3-Clause-BSD

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

ath5k seems to have the same issue identified in zd1211rw of attempting
retries after modifying the skb's.. and TX_BUSY isn't supposed to be
used anyway.

 drivers/net/wireless/ath5k/base.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 6580df2..5d57d77 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2562,7 +2562,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		if (skb_headroom(skb) < padsize) {
 			ATH5K_ERR(sc, "tx hdrlen not %%4: %d not enough"
 				  " headroom to pad %d\n", hdrlen, padsize);
-			return NETDEV_TX_BUSY;
+			goto drop_packet;
 		}
 		skb_push(skb, padsize);
 		memmove(skb->data, skb->data+padsize, hdrlen);
@@ -2573,7 +2573,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		ATH5K_ERR(sc, "no further txbuf available, dropping packet\n");
 		spin_unlock_irqrestore(&sc->txbuflock, flags);
 		ieee80211_stop_queue(hw, skb_get_queue_mapping(skb));
-		return NETDEV_TX_BUSY;
+		goto drop_packet;
 	}
 	bf = list_first_entry(&sc->txbuf, struct ath5k_buf, list);
 	list_del(&bf->list);
@@ -2590,10 +2590,12 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		list_add_tail(&bf->list, &sc->txbuf);
 		sc->txbuf_len++;
 		spin_unlock_irqrestore(&sc->txbuflock, flags);
-		dev_kfree_skb_any(skb);
-		return NETDEV_TX_OK;
+		goto drop_packet;
 	}
+	return NETDEV_TX_OK;
 
+drop_packet:
+	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
 
-- 
1.6.0.6



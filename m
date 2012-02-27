Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40109 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab2B0RB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 12:01:26 -0500
Received: by bkcik5 with SMTP id ik5so447234bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 09:01:24 -0800 (PST)
Message-Id: <d053a9a1ec34c2e1b15cf50b272ba7863fb17088.1330360738.git.chunkeey@googlemail.com> (sfid-20120227_180134_238474_A978DCB7)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 27 Feb 2012 17:10:16 +0100
Subject: [RFC 1/2] ath9k: use ieee80211_free_txskb
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, senthilb@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, mohammed@qca.qualcomm.com,
	mcgrof@qca.qualcomm.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the new tx status API: "mac80211: implement wifi TX status"
All skb originating from mac80211 needs to be given back to mac80211.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
It's high time we change all calls in the tx-path from
dev_kfree_skb into ieee80211_free_txskb.

The call in ath9k_tx is straightforward, but the one in
ath_tx_setup_buffer gives me headaches. I'm not sure if
we even need to check bf->bf_state.bfs_paprd at this
stage since ath_tx_start_dma sets bf->bf_state.bfs_paprd
"after" calling ath_tx_setup_buffer?!

Regards,
	Chr
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c81304d..4471ed9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1162,7 +1162,7 @@ static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	return;
 exit:
-	dev_kfree_skb_any(skb);
+	ieee80211_free_txskb(sc->hw, skb);
 }
 
 static void ath9k_stop(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3182408..0dadbc3 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1858,7 +1858,11 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 	return bf;
 
 error:
-	dev_kfree_skb_any(skb);
+
+	if (bf->bf_state.bfs_paprd)
+		dev_kfree_skb_any(skb);
+	else
+		ieee80211_free_txskb(sc->hw, skb);
 	return NULL;
 }
 
-- 
1.7.9.1


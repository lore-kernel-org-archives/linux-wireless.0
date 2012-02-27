Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41451 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2B0RB0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 12:01:26 -0500
Received: by bkcik5 with SMTP id ik5so447249bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 09:01:25 -0800 (PST)
Message-Id: <88bea301177cac98e77cd49490ac576d36b10c81.1330360738.git.chunkeey@googlemail.com> (sfid-20120227_180134_802644_B8939ABD)
In-Reply-To: <d053a9a1ec34c2e1b15cf50b272ba7863fb17088.1330360738.git.chunkeey@googlemail.com>
References: <d053a9a1ec34c2e1b15cf50b272ba7863fb17088.1330360738.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 27 Feb 2012 17:32:19 +0100
Subject: [RFC 2/2] ath9k_htc: use ieee80211_free_txskb
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
It compiles, but not tested.
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 3e40a64..e958704 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -451,7 +451,7 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
 
 	slot = strip_drv_header(priv, skb);
 	if (slot < 0) {
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(priv->hw, skb);
 		return;
 	}
 
@@ -687,7 +687,7 @@ void ath9k_htc_txep(void *drv_priv, struct sk_buff *skb,
 
 	epid_queue = get_htc_epid_queue(priv, ep_id);
 	if (!epid_queue) {
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(priv->hw, skb);
 		return;
 	}
 
-- 
1.7.9.1


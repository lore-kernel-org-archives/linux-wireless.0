Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:38596 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3KXQ5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 11:57:00 -0500
Received: by mail-ea0-f169.google.com with SMTP id l9so1901762eaj.0
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 08:56:58 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	sujith@msujith.org, johannes@sipsolutions.net,
	rmanohar@qca.qualcomm.com
Subject: [PATCH 3/3] ath9k: fix retry chain initialization in tx99 code
Date: Sun, 24 Nov 2013 17:56:51 +0100
Message-Id: <1385312211-3119-4-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20131124_175706_144315_3A5754D4)
In-Reply-To: <1385312211-3119-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1385312211-3119-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize first chain attempt counter to 1 in ath9k_build_tx99_skb().
Otherwise multi-retry chain is initialized to {idx,count} = {-1, 0} in
rate_control_fill_sta_table() and tx99 transmission rate is not configured in
rate_control_apply_mask() since first chain idx is set to -1

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/tx99.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/tx99.c b/drivers/net/wireless/ath/ath9k/tx99.c
index c90eca3..ab154fe 100644
--- a/drivers/net/wireless/ath/ath9k/tx99.c
+++ b/drivers/net/wireless/ath/ath9k/tx99.c
@@ -76,6 +76,7 @@ static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
 	tx_info->band = hw->conf.chandef.chan->band;
 	tx_info->flags = IEEE80211_TX_CTL_NO_ACK;
 	tx_info->control.vif = sc->tx99_vif;
+	tx_info->control.rates[0].count = 1;
 
 	memcpy(skb->data + sizeof(*hdr), PN9Data, sizeof(PN9Data));
 
-- 
1.8.3.2


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33367 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbbK0Ihh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:37:37 -0500
Received: by lfaz4 with SMTP id z4so121318728lfa.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 00:37:35 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 10/13] ath9k: MCC, add NOA also in case of an AP
Date: Fri, 27 Nov 2015 09:37:15 +0100
Message-Id: <1448613438-5173-10-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151127_093742_706246_C1FE9627)
In-Reply-To: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of MCC and AP interface, add also NOA attr
that will inform stations about absence of an AP.
There is a chance that some stations will handle
this NOA attr correctly and will know exactly when
AP is present/absent.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index f50a6bc..5cf0cd7 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -148,7 +148,8 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 
 	ath_assign_seq(common, skb);
 
-	if (vif->p2p)
+	/* Always assign NOA attr when MCC enabled */
+	if (ath9k_is_chanctx_enabled())
 		ath9k_beacon_add_noa(sc, avp, skb);
 
 	bf->bf_buf_addr = dma_map_single(sc->dev, skb->data,
-- 
1.9.1


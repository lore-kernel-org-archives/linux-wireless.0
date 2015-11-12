Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34008 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbbKLNQX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 08:16:23 -0500
Received: by lffu14 with SMTP id u14so33763538lff.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2015 05:16:21 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 10/12] ath9k: MCC, add NOA also in case of an AP
Date: Thu, 12 Nov 2015 14:15:47 +0100
Message-Id: <1447334149-15507-10-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151112_141633_694206_5C09C402)
In-Reply-To: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com>
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


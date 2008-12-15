Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:47458 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbYLOOCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 09:02:11 -0500
Date: Mon, 15 Dec 2008 16:02:04 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Remove MAC header pad before reporting TX status
Message-ID: <20081215140204.GA16197@jm.kir.nu> (sfid-20081215_150215_444374_BD750901)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the possible MAC header pad before reporting TX status to
mac80211. This pad is hardware specific operation and should not be
exposed outside the driver. This fixes the frame body in monitor
interfaces that could be used to check on TX status for transmitted
frames.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

(the context in the patch depends on the previous ath9k: Fix TX status
reporting for retries and MCS index patch, but other than that, this is
an independent change)

--- wireless-testing.orig/drivers/net/wireless/ath9k/xmit.c	2008-12-15 15:48:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/xmit.c	2008-12-15 15:54:37.000000000 +0200
@@ -106,6 +106,7 @@ static void ath_tx_complete(struct ath_s
 	struct ieee80211_hw *hw = sc->hw;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
+	int hdrlen, padsize;
 
 	DPRINTF(sc, ATH_DBG_XMIT, "TX complete: skb: %p\n", skb);
 
@@ -135,6 +136,17 @@ static void ath_tx_complete(struct ath_s
 				rate_table->info[idx].ratecode & 0x7f;
 	}
 
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	padsize = hdrlen & 3;
+	if (padsize && hdrlen >= 24) {
+		/*
+		 * Remove MAC header padding before giving the frame back to
+		 * mac80211.
+		 */
+		memmove(skb->data + padsize, skb->data, hdrlen);
+		skb_pull(skb, padsize);
+	}
+
 	ieee80211_tx_status(hw, skb);
 }
 

-- 
Jouni Malinen                                            PGP id EFC895FA

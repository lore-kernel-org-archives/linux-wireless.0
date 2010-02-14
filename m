Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:40322 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab0BNXeE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 18:34:04 -0500
From: Benoit Papillault <benoit.papillault@free.fr>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH 2/2] mac80211: Improved IBSS merges even if BSSID is the same
Date: Mon, 15 Feb 2010 00:33:55 +0100
Message-Id: <1266190435-2355-2-git-send-email-benoit.papillault@free.fr>
In-Reply-To: <1266190435-2355-1-git-send-email-benoit.papillault@free.fr>
References: <1266190435-2355-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to IEEE 802.11, we should merge even if the BSSID from the
received beacon is the same as our since merge can update more things
that BSSID itself.

This is specifically true for ath9k where the merge updates TBTT timers
as a side effect and this is indeed needed if the TSF has been updated
(if TSF is updated, we need to update TBTT timers as well).

However, it could cause continuous merges if the RX timestamp or
drv_get_tsf() is not accurate or not implemented.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 net/mac80211/ibss.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 9328395..5f343ed 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -372,10 +372,6 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				sdata->u.ibss.ssid_len))
 		goto put_bss;
 
-	/* same BSSID */
-	if (memcmp(cbss->bssid, sdata->u.ibss.bssid, ETH_ALEN) == 0)
-		goto put_bss;
-
 	if (rx_status->flag & RX_FLAG_TSFT) {
 		/*
 		 * For correct IBSS merging we need mactime; since mactime is
-- 
1.5.6.5


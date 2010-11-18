Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57995 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab0KRAh7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 19:37:59 -0500
Message-ID: <4CE47563.2090803@openwrt.org>
Date: Thu, 18 Nov 2010 01:37:55 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: recursive locking on wireless-testing.
References: <4CE446E3.3090604@candelatech.com>
In-Reply-To: <4CE446E3.3090604@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-17 10:19 PM, Ben Greear wrote:
> I found this while testing wpa_supplicant that shares scan results.
> The kernel has no scan-sharing hacks in it..just a few patches
> I've been using for a while (and the deadlock prevention patch
> previously mentioned in other threads).
> 
> 
> Nov 17 13:16:25 ath9k kernel: ieee80211 wiphy0: Removed STA 00:14:d1:c6:d2:54
> Nov 17 13:16:25 ath9k kernel: ieee80211 wiphy0: Destroyed STA 00:14:d1:c6:d2:54
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.37-rc1-wl+ #48
> ---------------------------------------------
This should fix it. ath_tx_complete is already called with the txq locked.

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1830,10 +1830,8 @@ static void ath_tx_complete(struct ath_s
 	else {
 		q = skb_get_queue_mapping(skb);
 		if (txq == sc->tx.txq_map[q]) {
-			spin_lock_bh(&txq->axq_lock);
 			if (WARN_ON(--txq->pending_frames < 0))
 				txq->pending_frames = 0;
-			spin_unlock_bh(&txq->axq_lock);
 		}

 		ieee80211_tx_status(hw, skb);

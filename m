Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46536 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762602AbYA1WMF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 17:12:05 -0500
Date: Tue, 29 Jan 2008 00:12:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linville@tuxdriver.com, j@w1.fi
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: [2.6 patch] hostap_80211.h: remove duplicate prototype
Message-ID: <20080128221232.GF8767@does.not.exist> (sfid-20080128_221224_594245_9C047C9D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

There were two identical prototypes for hostap_80211_rx() in 
drivers/net/wireless/hostap/hostap_80211.h.

This patch fixes kernel Bugzilla #8930.

Reported by Christoph Burger-Scheidlin.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
diff --git a/drivers/net/wireless/hostap/hostap_80211.h b/drivers/net/wireless/hostap/hostap_80211.h
index cc1ee7f..8466494 100644
--- a/drivers/net/wireless/hostap/hostap_80211.h
+++ b/drivers/net/wireless/hostap/hostap_80211.h
@@ -71,11 +71,6 @@ struct hostap_80211_rx_status {
 	u16 rate; /* in 100 kbps */
 };
 
-
-void hostap_80211_rx(struct net_device *dev, struct sk_buff *skb,
-		     struct hostap_80211_rx_status *rx_stats);
-
-
 /* prism2_rx_80211 'type' argument */
 enum {
 	PRISM2_RX_MONITOR, PRISM2_RX_MGMT, PRISM2_RX_NON_ASSOC,


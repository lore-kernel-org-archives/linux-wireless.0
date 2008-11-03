Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:34557 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783AbYKCUFE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 15:05:04 -0500
Message-ID: <490F596D.9010307@openwrt.org> (sfid-20081103_210512_828318_A56376AA)
Date: Mon, 03 Nov 2008 21:05:01 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] mac80211: fix BUILD_BUG_ON() caused by misalignment on arm
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On ARM alignment is done slightly different from other architectures.
struct ieee80211_tx_rate is aligned to word size, even though it only has 3
single-byte members, which triggers the BUILD_BUG_ON in
ieee80211_tx_info_clear_status

This patch marks the struct ieee80211_tx_rate as packed, so that ARM
behaves like the other architectures.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>

--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -299,7 +299,7 @@ struct ieee80211_tx_rate {
 	s8 idx;
 	u8 count;
 	u8 flags;
-};
+} __attribute__((packed));
 
 /**
  * struct ieee80211_tx_info - skb transmit information

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48476 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbZKOV1O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2009 16:27:14 -0500
Message-ID: <4B007235.3050108@openwrt.org>
Date: Sun, 15 Nov 2009 22:27:17 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: fix massive rx packet loss issue
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a regression introduced in

  commit 701396910a42dc69cf0284f4727e48f5e0f83151
  [PATCH 18/29] ath9k: avoid the copy skb->cb on every RX'd skb

With that change, the rx status in skb->cb was left uninitialized

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---

--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -203,6 +203,7 @@ int ath9k_cmn_rx_skb_preprocess(struct a
 {
 	struct ath_hw *ah = common->ah;
 
+	memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
 	if (!ath9k_rx_accept(common, skb, rx_status, rx_stats, decrypt_error))
 		return -EINVAL;
 


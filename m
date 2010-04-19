Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45927 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab0DSR5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 13:57:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH v2 9/9] ath9k: set the STBC flag in rate control if the peer supports it
Date: Mon, 19 Apr 2010 19:57:37 +0200
Message-Id: <1271699857-12366-9-git-send-email-nbd@openwrt.org>
In-Reply-To: <1271699857-12366-8-git-send-email-nbd@openwrt.org>
References: <1271699857-12366-1-git-send-email-nbd@openwrt.org>
 <1271699857-12366-2-git-send-email-nbd@openwrt.org>
 <1271699857-12366-3-git-send-email-nbd@openwrt.org>
 <1271699857-12366-4-git-send-email-nbd@openwrt.org>
 <1271699857-12366-5-git-send-email-nbd@openwrt.org>
 <1271699857-12366-6-git-send-email-nbd@openwrt.org>
 <1271699857-12366-7-git-send-email-nbd@openwrt.org>
 <1271699857-12366-8-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/rc.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index bf3ad7a..8519452 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -700,6 +700,10 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	    (sta->ht_cap.cap & IEEE80211_HT_CAP_LDPC_CODING))
 		tx_info->flags |= IEEE80211_TX_CTL_LDPC;
 
+	if (conf_is_ht(&sc->hw->conf) &&
+	    (sta->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC))
+		tx_info->flags |= (1 << IEEE80211_TX_CTL_STBC_SHIFT);
+
 	if (is_probe) {
 		/* set one try for probe rates. For the
 		 * probes don't enable rts */
-- 
1.6.4.2


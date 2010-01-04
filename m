Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:53800 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab0ADU6N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2010 15:58:13 -0500
Date: Mon, 4 Jan 2010 21:58:12 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 13/14] mwl8k: trivial rx-only ampdu implementation
Message-ID: <20100104205812.GM1735@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AMPDU receive doesn't need any special handling, so let's enable
this before tackling the transmit side.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 85e0d2d..887ce0f 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -3311,6 +3311,22 @@ static int mwl8k_get_stats(struct ieee80211_hw *hw,
 	return mwl8k_cmd_get_stat(hw, stats);
 }
 
+static int
+mwl8k_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		   enum ieee80211_ampdu_mlme_action action,
+		   struct ieee80211_sta *sta, u16 tid, u16 *ssn)
+{
+	switch (action) {
+	case IEEE80211_AMPDU_RX_START:
+	case IEEE80211_AMPDU_RX_STOP:
+		if (!(hw->flags & IEEE80211_HW_AMPDU_AGGREGATION))
+			return -ENOTSUPP;
+		return 0;
+	default:
+		return -ENOTSUPP;
+	}
+}
+
 static const struct ieee80211_ops mwl8k_ops = {
 	.tx			= mwl8k_tx,
 	.start			= mwl8k_start,
@@ -3326,6 +3342,7 @@ static const struct ieee80211_ops mwl8k_ops = {
 	.conf_tx		= mwl8k_conf_tx,
 	.get_tx_stats		= mwl8k_get_tx_stats,
 	.get_stats		= mwl8k_get_stats,
+	.ampdu_action		= mwl8k_ampdu_action,
 };
 
 static void mwl8k_tx_reclaim_handler(unsigned long data)
-- 
1.5.6.4

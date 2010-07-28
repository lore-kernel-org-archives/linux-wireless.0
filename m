Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47277 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab0G1VP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 17:15:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wl1251: update hw/fw version info in wiphy struct
Date: Wed, 28 Jul 2010 17:07:45 -0400
Message-Id: <1280351265-27791-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the information available through ethtool...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/wl12xx/wl1251_main.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index a6d8d1a..861a5f3 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -411,6 +411,7 @@ static int wl1251_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 static int wl1251_op_start(struct ieee80211_hw *hw)
 {
 	struct wl1251 *wl = hw->priv;
+	struct wiphy *wiphy = hw->wiphy;
 	int ret = 0;
 
 	wl1251_debug(DEBUG_MAC80211, "mac80211 start");
@@ -444,6 +445,10 @@ static int wl1251_op_start(struct ieee80211_hw *hw)
 
 	wl1251_info("firmware booted (%s)", wl->fw_ver);
 
+	/* update hw/fw version info in wiphy struct */
+	wiphy->hw_version = wl->chip_id;
+	strncpy(wiphy->fw_version, wl->fw_ver, sizeof(wiphy->fw_version));
+
 out:
 	if (ret < 0)
 		wl1251_power_off(wl);
-- 
1.7.1.1


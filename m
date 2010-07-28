Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47276 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab0G1VPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 17:15:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wl1271: update hw/fw version info in wiphy struct
Date: Wed, 28 Jul 2010 17:10:43 -0400
Message-Id: <1280351443-28535-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the information available through ethtool...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 374abf0..9d68f00 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -839,6 +839,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
 	struct wl1271 *wl = hw->priv;
+	struct wiphy *wiphy = hw->wiphy;
 	int retries = WL1271_BOOT_RETRIES;
 	int ret = 0;
 
@@ -892,6 +893,12 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 
 		wl->state = WL1271_STATE_ON;
 		wl1271_info("firmware booted (%s)", wl->chip.fw_ver);
+
+		/* update hw/fw version info in wiphy struct */
+		wiphy->hw_version = wl->chip.id;
+		strncpy(wiphy->fw_version, wl->chip.fw_ver,
+			sizeof(wiphy->fw_version));
+
 		goto out;
 
 irq_disable:
-- 
1.7.1.1


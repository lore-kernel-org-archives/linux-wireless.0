Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39600 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbeHLRbY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 13:31:24 -0400
From: Kristian Evensen <kristian.evensen@gmail.com>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH] mt76: Enable NL80211_EXT_FEATURE_CQM_RSSI_LIST
Date: Sun, 12 Aug 2018 16:52:07 +0200
Message-Id: <20180812145207.11395-1-kristian.evensen@gmail.com> (sfid-20180812_165339_367798_E60C7D1A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable the use of CQM with mt76-devices.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 029d54bc..3eb328ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -305,6 +305,8 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
 
 	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
 
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
+
 	wiphy->available_antennas_tx = dev->antenna_mask;
 	wiphy->available_antennas_rx = dev->antenna_mask;
 
-- 
2.14.1

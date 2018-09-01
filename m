Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36741 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbeIAMt4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Sep 2018 08:49:56 -0400
From: Kristian Evensen <kristian.evensen@gmail.com>
To: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH v2] mt76: Enable NL80211_EXT_FEATURE_CQM_RSSI_LIST
Date: Sat,  1 Sep 2018 10:38:34 +0200
Message-Id: <20180901083834.11201-1-kristian.evensen@gmail.com> (sfid-20180901_103908_829125_4EC85E07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable the use of CQM_RSSI_LIST with mt76-devices. The change has been
tested with the mt7602, mt7603 and mt7621 PCI wifi-cards. I passed a
list of RSSI thresholds to the driver, and when disconnecting/connecting
the antenna(s) I got an event each time the RSSI went above/below a
threshold.

While I have not been able to test the change with any of the mt76
USB-devices (no access to a device), the RX RSSI management code is
shared between the two device types. Thus, CQM should also work with the
mt76 USB-devices.

v1->v2:
* Updated commit message. Thanks Kalle Valo, Arend van Spriel,
Lorenzo Bianconi and Andrew Zaborowski.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 029d54bce9e8..3eb328ff8c0d 100644
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

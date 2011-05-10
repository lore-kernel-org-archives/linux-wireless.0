Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:59753 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab1EJEka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 00:40:30 -0400
Subject: [PATCH 1/2] ath6kl: iw dev wlan0 link implementation
To: gregkh@suse.de
From: Kalle Valo <kvalo@adurom.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Tue, 10 May 2011 07:40:23 +0300
Message-ID: <20110510044023.29589.38450.stgit@localhost6.localdomain6> (sfid-20110510_064045_290501_77D39D3C)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naveen Singh <nsingh@atheros.com>

implementing the cfg ops that gets called when iw dev wlan0
link is issued by user. The ops that needs to be implemented
is get_station.

kvalo: check the mac address and fix style issues

Signed-off-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Kalle Valo <kalle.valo@atheros.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c |  130 ++++++++++++++++++++++++++++
 1 files changed, 130 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index efd4ae5..cb3187e 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -1460,6 +1460,135 @@ u32 cipher_suites[] = {
     WLAN_CIPHER_SUITE_CCMP,
 };
 
+bool is_rate_legacy(s32 rate)
+{
+	static const s32 legacy[] = { 1000, 2000, 5500, 11000,
+				      6000, 9000, 12000, 18000, 24000,
+				      36000, 48000, 54000 };
+	u8 i;
+
+	for (i = 0; i < 12; i++) {
+		if (rate == legacy[i])
+			return true;
+	}
+
+	return false;
+}
+
+bool is_rate_ht20(s32 rate, u8 *mcs)
+{
+	static const s32 ht20[] = { 6500, 13000, 19500, 26000, 39000,
+				     52000, 58500, 65000, 72200 };
+	u8 i;
+
+	for (i = 0; i < 9; i++) {
+		if (rate == ht20[i]) {
+			*mcs = i;
+			return true;
+		}
+	}
+	return false;
+}
+
+bool is_rate_ht40(s32 rate, u8 *mcs)
+{
+	static const s32 ht40[] = { 13500, 27000, 40500, 54000,
+					  81000, 108000, 121500, 135000 };
+	u8 i;
+
+	for (i = 0; i < 9; i++) {
+		if (rate == ht40[i]) {
+			*mcs = i;
+			return true;
+		}
+	}
+
+	return false;
+}
+
+int ar6k_get_station(struct wiphy *wiphy, struct net_device *dev,
+		     u8 *mac, struct station_info *sinfo)
+{
+	struct ar6_softc *ar = ar6k_priv(dev);
+	u8 mcs, ret, timeout = false;
+
+	if (compare_ether_addr(mac, ar->arBssid))
+		return -ENOENT;
+
+	if (down_interruptible(&ar->arSem))
+		return -EBUSY;
+
+	ar->statsUpdatePending = true;
+
+	ret = wmi_get_stats_cmd(ar->arWmi);
+
+	if (ret != 0) {
+		up(&ar->arSem);
+		return -EIO;
+	}
+
+	wait_event_interruptible_timeout(arEvent,
+					 ar->statsUpdatePending == false,
+					 wmitimeout * HZ);
+
+	if (signal_pending(current)) {
+		timeout = true;
+		AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
+				("ar6000 : WMI get stats timeout\n"));
+	}
+
+	up(&ar->arSem);
+
+	if (timeout)
+		return -ETIMEDOUT;
+
+	if (ar->arTargetStats.rx_bytes) {
+		sinfo->rx_bytes = ar->arTargetStats.rx_bytes;
+		sinfo->filled |= STATION_INFO_RX_BYTES;
+		sinfo->rx_packets = ar->arTargetStats.rx_packets;
+		sinfo->filled |= STATION_INFO_RX_PACKETS;
+	}
+
+	if (ar->arTargetStats.tx_bytes) {
+		sinfo->tx_bytes = ar->arTargetStats.tx_bytes;
+		sinfo->filled |= STATION_INFO_TX_BYTES;
+		sinfo->tx_packets = ar->arTargetStats.tx_packets;
+		sinfo->filled |= STATION_INFO_TX_PACKETS;
+	}
+
+	sinfo->signal = ar->arTargetStats.cs_rssi;
+	sinfo->filled |= STATION_INFO_SIGNAL;
+
+	if (is_rate_legacy(ar->arTargetStats.tx_unicast_rate)) {
+		sinfo->txrate.legacy = ar->arTargetStats.tx_unicast_rate / 100;
+	} else if (is_rate_ht20(ar->arTargetStats.tx_unicast_rate, &mcs)) {
+		if (mcs == 0x08) {
+			sinfo->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
+			sinfo->txrate.mcs = mcs - 1;
+		} else {
+			sinfo->txrate.mcs = mcs;
+		}
+
+		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
+	} else if (is_rate_ht40(ar->arTargetStats.tx_unicast_rate, &mcs)) {
+		if (mcs == 0x08) {
+			sinfo->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
+			sinfo->txrate.mcs = mcs - 1;
+		} else {
+			sinfo->txrate.mcs = mcs;
+		}
+
+		sinfo->txrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
+	} else {
+		WARN(1, "invalid rate: %d", ar->arTargetStats.tx_unicast_rate);
+	}
+
+	sinfo->filled |= STATION_INFO_TX_BITRATE;
+
+	return 0;
+}
+
 static struct
 cfg80211_ops ar6k_cfg80211_ops = {
     .change_virtual_intf = ar6k_cfg80211_change_iface,
@@ -1480,6 +1609,7 @@ cfg80211_ops ar6k_cfg80211_ops = {
     .set_power_mgmt = ar6k_cfg80211_set_power_mgmt,
     .join_ibss = ar6k_cfg80211_join_ibss,
     .leave_ibss = ar6k_cfg80211_leave_ibss,
+    .get_station = ar6k_get_station,
 };
 
 struct wireless_dev *


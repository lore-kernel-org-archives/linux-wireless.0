Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:60649 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab1EKCDF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 22:03:05 -0400
Subject: [PATCH v2] ath6kl: iw dev wlan0 link implementation
To: gregkh@suse.de
From: Kalle Valo <kvalo@adurom.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Wed, 11 May 2011 05:02:57 +0300
Message-ID: <20110511020257.1752.97603.stgit@localhost6.localdomain6> (sfid-20110511_040308_715118_9E47B481)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naveen Singh <nsingh@atheros.com>

implementing the cfg ops that gets called when iw dev wlan0
link is issued by user. The ops that needs to be implemented
is get_station.

kvalo: check the mac address, remove signal_pending() and fix style issues

Signed-off-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Kalle Valo <kalle.valo@atheros.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c |  128 ++++++++++++++++++++++++++++
 1 files changed, 128 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index efd4ae5..3a89e33 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -1460,6 +1460,133 @@ u32 cipher_suites[] = {
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
+static int ar6k_get_station(struct wiphy *wiphy, struct net_device *dev,
+			    u8 *mac, struct station_info *sinfo)
+{
+	struct ar6_softc *ar = ar6k_priv(dev);
+	long left;
+	int ret;
+	u8 mcs;
+
+	if (memcmp(mac, ar->arBssid, ETH_ALEN) != 0)
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
+	left = wait_event_interruptible_timeout(arEvent,
+						ar->statsUpdatePending == false,
+						wmitimeout * HZ);
+
+	up(&ar->arSem);
+
+	if (left == 0)
+		return -ETIMEDOUT;
+	else if (left < 0)
+		return left;
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
@@ -1480,6 +1607,7 @@ cfg80211_ops ar6k_cfg80211_ops = {
     .set_power_mgmt = ar6k_cfg80211_set_power_mgmt,
     .join_ibss = ar6k_cfg80211_join_ibss,
     .leave_ibss = ar6k_cfg80211_leave_ibss,
+    .get_station = ar6k_get_station,
 };
 
 struct wireless_dev *


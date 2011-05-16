Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:57432 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab1EPMKW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 08:10:22 -0400
Subject: [PATCH v3] ath6kl: iw dev wlan0 link implementation
To: gregkh@suse.de
From: Kalle Valo <kvalo@adurom.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Mon, 16 May 2011 15:10:15 +0300
Message-ID: <20110516121015.5439.4858.stgit@x201> (sfid-20110516_141025_179388_DD03602B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Naveen Singh <nsingh@atheros.com>

implementing the cfg ops that gets called when iw dev wlan0
link is issued by user. The ops that needs to be implemented
is get_station.

kvalo: check the mac address, remove signal_pending(), use ARRAY_SIZE()
and fix style issues

Signed-off-by: Naveen Singh <nsingh@atheros.com>
Signed-off-by: Kalle Valo <kalle.valo@atheros.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c |  146 ++++++++++++++++++++++++++++
 1 files changed, 146 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index efd4ae5..4327133 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -1460,6 +1460,151 @@ u32 cipher_suites[] = {
     WLAN_CIPHER_SUITE_CCMP,
 };
 
+bool is_rate_legacy(s32 rate)
+{
+	static const s32 legacy[] = { 1000, 2000, 5500, 11000,
+				      6000, 9000, 12000, 18000, 24000,
+				      36000, 48000, 54000 };
+	u8 i;
+
+	for (i = 0; i < ARRAY_SIZE(legacy); i++) {
+		if (rate == legacy[i])
+			return true;
+	}
+
+	return false;
+}
+
+bool is_rate_ht20(s32 rate, u8 *mcs, bool *sgi)
+{
+	static const s32 ht20[] = { 6500, 13000, 19500, 26000, 39000,
+				    52000, 58500, 65000, 72200 };
+	u8 i;
+
+	for (i = 0; i < ARRAY_SIZE(ht20); i++) {
+		if (rate == ht20[i]) {
+			if (i == ARRAY_SIZE(ht20) - 1)
+				/* last rate uses sgi */
+				*sgi = true;
+			else
+				*sgi = false;
+
+			*mcs = i;
+			return true;
+		}
+	}
+	return false;
+}
+
+bool is_rate_ht40(s32 rate, u8 *mcs, bool *sgi)
+{
+	static const s32 ht40[] = { 13500, 27000, 40500, 54000,
+				    81000, 108000, 121500, 135000,
+				    150000 };
+	u8 i;
+
+	for (i = 0; i < ARRAY_SIZE(ht40); i++) {
+		if (rate == ht40[i]) {
+			if (i == ARRAY_SIZE(ht40) - 1)
+				/* last rate uses sgi */
+				*sgi = true;
+			else
+				*sgi = false;
+
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
+	bool sgi;
+	s32 rate;
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
+	rate = ar->arTargetStats.tx_unicast_rate;
+
+	if (is_rate_legacy(rate)) {
+		sinfo->txrate.legacy = rate / 100;
+	} else if (is_rate_ht20(rate, &mcs, &sgi)) {
+		if (sgi) {
+			sinfo->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
+			sinfo->txrate.mcs = mcs - 1;
+		} else {
+			sinfo->txrate.mcs = mcs;
+		}
+
+		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
+	} else if (is_rate_ht40(rate, &mcs, &sgi)) {
+		if (sgi) {
+			sinfo->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
+			sinfo->txrate.mcs = mcs - 1;
+		} else {
+			sinfo->txrate.mcs = mcs;
+		}
+
+		sinfo->txrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
+	} else {
+		WARN(1, "invalid rate: %d", rate);
+		return 0;
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
@@ -1480,6 +1625,7 @@ cfg80211_ops ar6k_cfg80211_ops = {
     .set_power_mgmt = ar6k_cfg80211_set_power_mgmt,
     .join_ibss = ar6k_cfg80211_join_ibss,
     .leave_ibss = ar6k_cfg80211_leave_ibss,
+    .get_station = ar6k_get_station,
 };
 
 struct wireless_dev *


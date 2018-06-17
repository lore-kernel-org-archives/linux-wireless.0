Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-he1eur01on0115.outbound.protection.outlook.com ([104.47.0.115]:21146
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933278AbeFQKHn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Jun 2018 06:07:43 -0400
From: Omer Efrat <omer.efrat@tandemg.com>
To: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Omer Efrat <omer.efrat@tandemg.com>
Subject: [PATCH v3 5/5] staging: use BIT_ULL for NL80211_STA_INFO_* attribute types
Date: Sun, 17 Jun 2018 13:07:36 +0300
Message-Id: <1529230056-18004-1-git-send-email-omer.efrat@tandemg.com> (sfid-20180617_120746_603878_061915D8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BIT macro uses unsigned long which some architectures handle as 32 bit
and therefore might cause macro's shift to overflow when used on a value
equals or larger than 32 (NL80211_STA_INFO_RX_DURATION and afterwards).

Since 'filled' member in station_info changed to u64, BIT_ULL macro
should be used with all NL80211_STA_INFO_* attribute types instead of BIT
to prevent future possible bugs when one will use BIT macro for higher
attributes by mistake.

This commit cleans up all usages of BIT macro with the above field
in cfg80211 by changing it to BIT_ULL instead.

Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 10 +++++-----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 14 +++++++-------
 drivers/staging/wlan-ng/cfg80211.c                |  4 ++--
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 02178e2..26b838f 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -1273,16 +1273,16 @@ static int cfg80211_rtw_get_station(struct wiphy *wiphy,
 			goto exit;
 		}
 
-		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 		sinfo->signal = translate_percentage_to_dbm(padapter->recvpriv.signal_strength);
 
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 		sinfo->txrate.legacy = rtw_get_cur_max_rate(padapter);
 
-		sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_RX_PACKETS);
 		sinfo->rx_packets = sta_rx_data_pkts(psta);
 
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_PACKETS);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_PACKETS);
 		sinfo->tx_packets = psta->sta_stats.tx_pkts;
 
 	}
@@ -3013,7 +3013,7 @@ static int	cfg80211_rtw_dump_station(struct wiphy *wiphy, struct net_device *nde
 		goto exit;
 	}
 	memcpy(mac, psta->hwaddr, ETH_ALEN);
-	sinfo->filled = BIT(NL80211_STA_INFO_SIGNAL);
+	sinfo->filled = BIT_ULL(NL80211_STA_INFO_SIGNAL);
 	sinfo->signal = psta->rssi;
 
 exit:
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e248702..13d3918 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1141,7 +1141,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 			return -ENOENT;
 		}
 
-		sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME);
 
 		wilc_get_inactive_time(vif, mac, &inactive_time);
 		sinfo->inactive_time = 1000 * inactive_time;
@@ -1150,11 +1150,11 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 		wilc_get_statistics(vif, &stats);
 
-		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL) |
-				 BIT(NL80211_STA_INFO_RX_PACKETS) |
-				 BIT(NL80211_STA_INFO_TX_PACKETS) |
-				 BIT(NL80211_STA_INFO_TX_FAILED) |
-				 BIT(NL80211_STA_INFO_TX_BITRATE);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL) |
+				 BIT_ULL(NL80211_STA_INFO_RX_PACKETS) |
+				 BIT_ULL(NL80211_STA_INFO_TX_PACKETS) |
+				 BIT_ULL(NL80211_STA_INFO_TX_FAILED) |
+				 BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 
 		sinfo->signal = stats.rssi;
 		sinfo->rx_packets = stats.rx_cnt;
@@ -1775,7 +1775,7 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
 	priv = wiphy_priv(wiphy);
 	vif = netdev_priv(priv->dev);
 
-	sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+	sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 
 	wilc_get_rssi(vif, &sinfo->signal);
 
diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 4291225..07c52e3 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -282,9 +282,9 @@ static int prism2_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (result == 0) {
 		sinfo->txrate.legacy = quality.txrate.data;
-		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 		sinfo->signal = quality.level.data;
-		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL);
 	}
 
 	return result;
-- 
2.7.4

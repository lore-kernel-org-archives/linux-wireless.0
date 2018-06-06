Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr20124.outbound.protection.outlook.com ([40.107.2.124]:55648
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932509AbeFFI1O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Jun 2018 04:27:14 -0400
From: Omer Efrat <omer.efrat@tandemg.com>
To: linux-wireless@vger.kernel.org
Cc: Omer Efrat <omer.efrat@tandemg.com>
Subject: [PATCH 3/3] staging: use BIT_ULL for NL80211_STA_INFO_* attribute types
Date: Wed,  6 Jun 2018 11:27:01 +0300
Message-Id: <1528273621-28116-3-git-send-email-omer.efrat@tandemg.com> (sfid-20180606_102725_381331_3E0399D6)
In-Reply-To: <1528273621-28116-1-git-send-email-omer.efrat@tandemg.com>
References: <1528273621-28116-1-git-send-email-omer.efrat@tandemg.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 'filled' member in station_info changed to u64, BIT_ULL macro
should be used with NL80211_STA_INFO_* attribute types instead of BIT.

The BIT macro uses unsigned long type which some architectures handle as 32bit
and this results in compilation warnings such as:

net/mac80211/sta_info.c:2223:2: warning: left shift count >= width of type
  sinfo->filled |= BIT(NL80211_STA_INFO_TID_STATS);
  ^

Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 46bc2e5..d0c5dbd 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -1281,16 +1281,16 @@ static int cfg80211_rtw_get_station(struct wiphy *wiphy,
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
@@ -3021,7 +3021,7 @@ static int	cfg80211_rtw_dump_station(struct wiphy *wiphy, struct net_device *nde
 		goto exit;
 	}
 	memcpy(mac, psta->hwaddr, ETH_ALEN);
-	sinfo->filled = BIT(NL80211_STA_INFO_SIGNAL);
+	sinfo->filled = BIT_ULL(NL80211_STA_INFO_SIGNAL);
 	sinfo->signal = psta->rssi;
 
 exit:
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 730d64f..830b48c 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1184,7 +1184,7 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 			return -ENOENT;
 		}
 
-		sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_INACTIVE_TIME);
 
 		wilc_get_inactive_time(vif, mac, &inactive_time);
 		sinfo->inactive_time = 1000 * inactive_time;
@@ -1195,11 +1195,11 @@ static int get_station(struct wiphy *wiphy, struct net_device *dev,
 
 		wilc_get_statistics(vif, &stats);
 
-		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL) |
-						BIT(NL80211_STA_INFO_RX_PACKETS) |
-						BIT(NL80211_STA_INFO_TX_PACKETS) |
-						BIT(NL80211_STA_INFO_TX_FAILED) |
-						BIT(NL80211_STA_INFO_TX_BITRATE);
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_SIGNAL) |
+						BIT_ULL(NL80211_STA_INFO_RX_PACKETS) |
+						BIT_ULL(NL80211_STA_INFO_TX_PACKETS) |
+						BIT_ULL(NL80211_STA_INFO_TX_FAILED) |
+						BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
 
 		sinfo->signal = stats.rssi;
 		sinfo->rx_packets = stats.rx_cnt;
@@ -1776,7 +1776,7 @@ static int dump_station(struct wiphy *wiphy, struct net_device *dev,
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

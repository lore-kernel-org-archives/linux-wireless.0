Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:2854 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755549AbeDWQfB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 12:35:01 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [RESEND 05/33] staging: wilc1000: rename WILC_WFI_p2p_rx & s32Freq to avoid camelCase
Date: Mon, 23 Apr 2018 22:03:07 +0530
Message-ID: <1524501215-4963-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180423_183510_840617_FFD168F6)
In-Reply-To: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
References: <1524501215-4963-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Avoid camelCase' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/staging/wilc1000/linux_wlan.c             |  2 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 18 +++++++++---------
 drivers/staging/wilc1000/wilc_wlan.h              |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 38a83bd..2236967 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1166,7 +1166,7 @@ void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
 	vif = netdev_priv(wilc->vif[1]->ndev);
 	if ((buff[0] == vif->frame_reg[0].type && vif->frame_reg[0].reg) ||
 	    (buff[0] == vif->frame_reg[1].type && vif->frame_reg[1].reg))
-		WILC_WFI_p2p_rx(wilc->vif[1]->ndev, buff, size);
+		wilc_wfi_p2p_rx(wilc->vif[1]->ndev, buff, size);
 }
 
 void wilc_netdev_cleanup(struct wilc *wilc)
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 7a6ca03..1bda7fc 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -359,7 +359,7 @@ static void cfg_scan_result(enum scan_event scan_event,
 {
 	struct wilc_priv *priv;
 	struct wiphy *wiphy;
-	s32 s32Freq;
+	s32 freq;
 	struct ieee80211_channel *channel;
 	struct cfg80211_bss *bss = NULL;
 
@@ -378,9 +378,9 @@ static void cfg_scan_result(enum scan_event scan_event,
 		    ((s32)network_info->rssi * 100) > 100))
 			return;
 
-		s32Freq = ieee80211_channel_to_frequency((s32)network_info->ch,
-							 NL80211_BAND_2GHZ);
-		channel = ieee80211_get_channel(wiphy, s32Freq);
+		freq = ieee80211_channel_to_frequency((s32)network_info->ch,
+						      NL80211_BAND_2GHZ);
+		channel = ieee80211_get_channel(wiphy, freq);
 
 		if (!channel)
 			return;
@@ -1396,12 +1396,12 @@ static void wilc_wfi_cfg_parse_rx_vendor_spec(struct wilc_priv *priv, u8 *buff,
 	}
 }
 
-void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
+void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 {
 	struct wilc_priv *priv;
 	u32 header, pkt_offset;
 	struct host_if_drv *wfi_drv;
-	s32 s32Freq;
+	s32 freq;
 
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
 	wfi_drv = (struct host_if_drv *)priv->hif_drv;
@@ -1422,10 +1422,10 @@ void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 		return;
 	}
 
-	s32Freq = ieee80211_channel_to_frequency(curr_channel, NL80211_BAND_2GHZ);
+	freq = ieee80211_channel_to_frequency(curr_channel, NL80211_BAND_2GHZ);
 
 	if (!ieee80211_is_action(buff[FRAME_TYPE_ID])) {
-		cfg80211_rx_mgmt(priv->wdev, s32Freq, 0, buff, size, 0);
+		cfg80211_rx_mgmt(priv->wdev, freq, 0, buff, size, 0);
 		return;
 	}
 
@@ -1461,7 +1461,7 @@ void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size)
 		}
 	}
 
-	cfg80211_rx_mgmt(priv->wdev, s32Freq, 0, buff, size, 0);
+	cfg80211_rx_mgmt(priv->wdev, freq, 0, buff, size, 0);
 }
 
 static void wilc_wfi_mgmt_tx_complete(void *priv, int status)
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index fa157a6..4abbfa7 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -300,7 +300,7 @@ void wilc_enable_tcp_ack_filter(bool value);
 int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc);
 int wilc_mac_xmit(struct sk_buff *skb, struct net_device *dev);
 
-void WILC_WFI_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
+void wilc_wfi_p2p_rx(struct net_device *dev, u8 *buff, u32 size);
 void host_wakeup_notify(struct wilc *wilc);
 void host_sleep_notify(struct wilc *wilc);
 extern bool wilc_enable_ps;
-- 
2.7.4

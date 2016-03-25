Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:49823 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbcCYMUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 08:20:10 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 04/11] staging: wilc1000: replaces g_struct_frame_reg with frame_reg
Date: Fri, 25 Mar 2016 21:16:49 +0900
Message-ID: <1458908216-12100-4-git-send-email-leo.kim@atmel.com> (sfid-20160325_132014_621381_05B9CECE)
In-Reply-To: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
References: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces g_struct_frame_reg with frame_reg.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 12 ++++++------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  8 ++++----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index e949f21..2f830cd 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -966,12 +966,12 @@ int wilc_mac_open(struct net_device *ndev)
 
 	wilc_mgmt_frame_register(vif->ndev->ieee80211_ptr->wiphy,
 				 vif->ndev->ieee80211_ptr,
-				 vif->g_struct_frame_reg[0].frame_type,
-				 vif->g_struct_frame_reg[0].reg);
+				 vif->frame_reg[0].frame_type,
+				 vif->frame_reg[0].reg);
 	wilc_mgmt_frame_register(vif->ndev->ieee80211_ptr->wiphy,
 				 vif->ndev->ieee80211_ptr,
-				 vif->g_struct_frame_reg[1].frame_type,
-				 vif->g_struct_frame_reg[1].reg);
+				 vif->frame_reg[1].frame_type,
+				 vif->frame_reg[1].reg);
 	netif_wake_queue(ndev);
 	wl->open_ifcs++;
 	vif->mac_opened = 1;
@@ -1260,8 +1260,8 @@ void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
 	}
 
 	vif = netdev_priv(wilc->vif[1]->ndev);
-	if ((buff[0] == vif->g_struct_frame_reg[0].frame_type && vif->g_struct_frame_reg[0].reg) ||
-	    (buff[0] == vif->g_struct_frame_reg[1].frame_type && vif->g_struct_frame_reg[1].reg))
+	if ((buff[0] == vif->frame_reg[0].frame_type && vif->frame_reg[0].reg) ||
+	    (buff[0] == vif->frame_reg[1].frame_type && vif->frame_reg[1].reg))
 		WILC_WFI_p2p_rx(wilc->vif[1]->ndev, buff, size);
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 70625f8..3e0ffee 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1745,15 +1745,15 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 	switch (frame_type) {
 	case PROBE_REQ:
 	{
-		vif->g_struct_frame_reg[0].frame_type = frame_type;
-		vif->g_struct_frame_reg[0].reg = reg;
+		vif->frame_reg[0].frame_type = frame_type;
+		vif->frame_reg[0].reg = reg;
 	}
 	break;
 
 	case ACTION:
 	{
-		vif->g_struct_frame_reg[1].frame_type = frame_type;
-		vif->g_struct_frame_reg[1].reg = reg;
+		vif->frame_reg[1].frame_type = frame_type;
+		vif->frame_reg[1].reg = reg;
 	}
 	break;
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index f394484..3abe481 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -149,7 +149,7 @@ struct wilc_vif {
 	u8 iftype;
 	int monitor_flag;
 	int mac_opened;
-	struct frame_reg g_struct_frame_reg[num_reg_frame];
+	struct frame_reg frame_reg[num_reg_frame];
 	struct net_device_stats netstats;
 	struct wilc *wilc;
 	u8 src_addr[ETH_ALEN];
-- 
1.9.1


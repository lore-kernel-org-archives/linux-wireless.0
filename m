Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:49843 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbcCYMUQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2016 08:20:16 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 05/11] staging: wilc1000: replaces frame_type with type of struct frame_reg
Date: Fri, 25 Mar 2016 21:16:50 +0900
Message-ID: <1458908216-12100-5-git-send-email-leo.kim@atmel.com> (sfid-20160325_132020_131382_4C427200)
In-Reply-To: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
References: <1458908216-12100-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replaces frame_type with type of struct frame_reg.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 8 ++++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ++--
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2f830cd..760d44d1 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -966,11 +966,11 @@ int wilc_mac_open(struct net_device *ndev)
 
 	wilc_mgmt_frame_register(vif->ndev->ieee80211_ptr->wiphy,
 				 vif->ndev->ieee80211_ptr,
-				 vif->frame_reg[0].frame_type,
+				 vif->frame_reg[0].type,
 				 vif->frame_reg[0].reg);
 	wilc_mgmt_frame_register(vif->ndev->ieee80211_ptr->wiphy,
 				 vif->ndev->ieee80211_ptr,
-				 vif->frame_reg[1].frame_type,
+				 vif->frame_reg[1].type,
 				 vif->frame_reg[1].reg);
 	netif_wake_queue(ndev);
 	wl->open_ifcs++;
@@ -1260,8 +1260,8 @@ void WILC_WFI_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
 	}
 
 	vif = netdev_priv(wilc->vif[1]->ndev);
-	if ((buff[0] == vif->frame_reg[0].frame_type && vif->frame_reg[0].reg) ||
-	    (buff[0] == vif->frame_reg[1].frame_type && vif->frame_reg[1].reg))
+	if ((buff[0] == vif->frame_reg[0].type && vif->frame_reg[0].reg) ||
+	    (buff[0] == vif->frame_reg[1].type && vif->frame_reg[1].reg))
 		WILC_WFI_p2p_rx(wilc->vif[1]->ndev, buff, size);
 }
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 3e0ffee..5785dda 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1745,14 +1745,14 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 	switch (frame_type) {
 	case PROBE_REQ:
 	{
-		vif->frame_reg[0].frame_type = frame_type;
+		vif->frame_reg[0].type = frame_type;
 		vif->frame_reg[0].reg = reg;
 	}
 	break;
 
 	case ACTION:
 	{
-		vif->frame_reg[1].frame_type = frame_type;
+		vif->frame_reg[1].type = frame_type;
 		vif->frame_reg[1].reg = reg;
 	}
 	break;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 3abe481..debb139 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -140,7 +140,7 @@ struct wilc_priv {
 };
 
 struct frame_reg {
-	u16 frame_type;
+	u16 type;
 	bool reg;
 };
 
-- 
1.9.1


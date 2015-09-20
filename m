Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33136 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbbITGwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:52:01 -0400
Received: by pacex6 with SMTP id ex6so87539446pac.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:52:01 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 08/18] staging: wilc1000: remove declaration of WILC_WFI_frame_register
Date: Sun, 20 Sep 2015 15:51:15 +0900
Message-Id: <1442731885-4344-8-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_085219_200492_EE5E60F6)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes function declaration of WILC_WFI_frame_register in
linux_wlan.c file, then adds it in wilc_wfi_cfgoperations.h file.

The compilation warning occurs because it is assigned to incorrect
pointer type of second parameter of WILC_WFI_frame_register.
It is assigned with struct wireless_dev pointer type.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c             | 7 ++-----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h | 2 ++
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 4534fb9..fd5cfd3 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1400,9 +1400,6 @@ int mac_init_fn(struct net_device *ndev)
 	return 0;
 }
 
-void    WILC_WFI_frame_register(struct wiphy *wiphy, struct net_device *dev,
-				u16 frame_type, bool reg);
-
 /* This fn is called, when this device is setup using ifconfig */
 int mac_open(struct net_device *ndev)
 {
@@ -1464,9 +1461,9 @@ int mac_open(struct net_device *ndev)
 		goto _err_;
 	}
 
-	WILC_WFI_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev,
+	WILC_WFI_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev->ieee80211_ptr,
 				nic->g_struct_frame_reg[0].frame_type, nic->g_struct_frame_reg[0].reg);
-	WILC_WFI_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev,
+	WILC_WFI_frame_register(nic->wilc_netdev->ieee80211_ptr->wiphy, nic->wilc_netdev->ieee80211_ptr,
 				nic->g_struct_frame_reg[1].frame_type, nic->g_struct_frame_reg[1].reg);
 	netif_wake_queue(ndev);
 	g_linux_wlan->open_ifcs++;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index 579bf2b..0bd23b4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -100,6 +100,8 @@ int WILC_WFI_InitHostInt(struct net_device *net);
 void WILC_WFI_monitor_rx(u8 *buff, u32 size);
 int WILC_WFI_deinit_mon_interface(void);
 struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_device *real_dev);
+void WILC_WFI_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
+			     u16 frame_type, bool reg);
 
 #define TCP_ACK_FILTER_LINK_SPEED_THRESH	54
 #define DEFAULT_LINK_SPEED			72
-- 
2.5.1


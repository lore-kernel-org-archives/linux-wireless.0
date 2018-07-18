Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:62492 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbeGSGqU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 02:46:20 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 10/23] staging: wilc1000: remove unnecessary elements from 'wilc_priv' struct
Date: Thu, 19 Jul 2018 04:15:06 +0530
Message-ID: <1531953919-20804-11-git-send-email-ajay.kathat@microchip.com> (sfid-20180719_080501_177342_D75D18BB)
In-Reply-To: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
References: <1531953919-20804-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unused elements from 'wilc_priv' structure.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 4 ----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 7 -------
 2 files changed, 11 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 8f1c595..1a27e81 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2276,8 +2276,6 @@ int wilc_init_host_int(struct net_device *net)
 	}
 	op_ifcs++;
 
-	priv->auto_rate_adjusted = false;
-
 	priv->p2p_listen_state = false;
 
 	mutex_init(&priv->scan_req_lock);
@@ -2297,8 +2295,6 @@ int wilc_deinit_host_int(struct net_device *net)
 	priv = wdev_priv(net->ieee80211_ptr);
 	vif = netdev_priv(priv->dev);
 
-	priv->auto_rate_adjusted = false;
-
 	priv->p2p_listen_state = false;
 
 	op_ifcs--;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 22f3486..87f8cdc 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -74,14 +74,10 @@ struct wilc_priv {
 
 	u8 associated_bss[ETH_ALEN];
 	struct sta_info assoc_stainfo;
-	struct net_device_stats stats;
-	u8 monitor_flag;
-	int status;
 	struct sk_buff *skb;
 	struct net_device *dev;
 	struct host_if_drv *hif_drv;
 	struct host_if_pmkid_attr pmkid_list;
-	struct wilc_wfi_stats netstats;
 	u8 wep_key[4][WLAN_KEY_LEN_WEP104];
 	u8 wep_key_len[4];
 	/* The real interface that the monitor is on */
@@ -91,9 +87,6 @@ struct wilc_priv {
 	u8 wilc_groupkey;
 	/* mutexes */
 	struct mutex scan_req_lock;
-	/*  */
-	bool auto_rate_adjusted;
-
 	bool p2p_listen_state;
 
 };
-- 
2.7.4

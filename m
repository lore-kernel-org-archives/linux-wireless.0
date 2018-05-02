Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:31900 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751100AbeEBHPQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:16 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/21] staging: wilc1000: remove unnecessary file and function header comments
Date: Wed, 2 May 2018 12:43:33 +0530
Message-ID: <1525245227-3924-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_092101_040475_35A30C3F)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the unnecessary comments used for file and functions
header.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/coreconfigurator.h       | 10 ------
 drivers/staging/wilc1000/linux_mon.c              | 44 -----------------------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |  8 -----
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  7 ----
 4 files changed, 69 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
index 6e61f3d..a58f44e 100644
--- a/drivers/staging/wilc1000/coreconfigurator.h
+++ b/drivers/staging/wilc1000/coreconfigurator.h
@@ -1,14 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-
-/*!
- *  @file	coreconfigurator.h
- *  @brief
- *  @author
- *  @sa		coreconfigurator.c
- *  @date	1 Mar 2012
- *  @version	1.0
- */
-
 #ifndef CORECONFIGURATOR_H
 #define CORECONFIGURATOR_H
 
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 169213f..02cbefd 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -1,12 +1,4 @@
 // SPDX-License-Identifier: GPL-2.0
-/*!
- *  @file	linux_mon.c
- *  @brief	File Operations OS wrapper functionality
- *  @author	mdaftedar
- *  @sa		wilc_wfi_netdevice.h
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 #include "wilc_wfi_cfgoperations.h"
 #include "wilc_wlan_if.h"
 #include "wilc_wlan.h"
@@ -28,15 +20,6 @@ static struct net_device *wilc_wfi_mon; /* global monitor netdev */
 static u8 srcadd[6];
 static u8 bssid[6];
 static u8 broadcast[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-/**
- *  @brief      WILC_WFI_monitor_rx
- *  @details
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	12 JUL 2012
- *  @version	1.0
- */
 
 #define IEEE80211_RADIOTAP_F_TX_RTS	0x0004  /* used rts/cts handshake */
 #define IEEE80211_RADIOTAP_F_TX_FAIL	0x0001  /* failed due to excessive*/
@@ -162,15 +145,6 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 	return 0;
 }
 
-/**
- *  @brief      WILC_WFI_mon_xmit
- *  @details
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	12 JUL 2012
- *  @version	1.0
- */
 static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 				     struct net_device *dev)
 {
@@ -248,15 +222,6 @@ static const struct net_device_ops wilc_wfi_netdev_ops = {
 
 };
 
-/**
- *  @brief      WILC_WFI_init_mon_interface
- *  @details
- *  @param[in]
- *  @return     Pointer to net_device
- *  @author	mdaftedar
- *  @date	12 JUL 2012
- *  @version	1.0
- */
 struct net_device *WILC_WFI_init_mon_interface(const char *name,
 					       struct net_device *real_dev)
 {
@@ -287,15 +252,6 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name,
 	return wilc_wfi_mon;
 }
 
-/**
- *  @brief      WILC_WFI_deinit_mon_interface
- *  @details
- *  @param[in]
- *  @return     int : Return 0 on Success
- *  @author	mdaftedar
- *  @date	12 JUL 2012
- *  @version	1.0
- */
 int WILC_WFI_deinit_mon_interface(void)
 {
 	bool rollback_lock = false;
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
index dfb7ec2..7372813 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.h
@@ -1,12 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*!
- *  @file	wilc_wfi_cfgoperations.h
- *  @brief	Definitions for the network module
- *  @author	syounan
- *  @sa		wilc_oswrapper.h top level OS wrapper file
- *  @date	31 Aug 2010
- *  @version	1.0
- */
 #ifndef NM_WFI_CFGOPERATIONS
 #define NM_WFI_CFGOPERATIONS
 #include "wilc_wfi_netdevice.h"
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index ab94d78f..02e9b07 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -1,11 +1,4 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/*!
- *  @file	wilc_wfi_netdevice.h
- *  @brief	Definitions for the network module
- *  @author	mdaftedar
- *  @date	01 MAR 2012
- *  @version	1.0
- */
 #ifndef WILC_WFI_NETDEVICE
 #define WILC_WFI_NETDEVICE
 
-- 
2.7.4

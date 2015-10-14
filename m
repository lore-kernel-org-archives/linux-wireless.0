Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43480 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbbJNLrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 07:47:03 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/16] staging: wilc1000: remove extern declarations of g_linux_wlan
Date: Wed, 14 Oct 2015 20:46:29 +0900
Message-ID: <1444823204-16736-1-git-send-email-tony.cho@atmel.com> (sfid-20151014_134714_860874_42360037)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes extern declaration of g_linux_wlan from the
followings because it is declared as extern in the wilc_wfi_netdevice.h
file.

- linux_mon.c
- linux_wlan_sdio.c
- wilc_wfi_cfgoperations.c

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_mon.c              | 2 --
 drivers/staging/wilc1000/linux_wlan_sdio.c        | 1 -
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 --
 3 files changed, 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index bde4095..450af1b 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -24,8 +24,6 @@ struct wilc_wfi_radiotap_cb_hdr {
 	u16 tx_flags;
 } __attribute__((packed));
 
-extern linux_wlan_t *g_linux_wlan;
-
 static struct net_device *wilc_wfi_mon; /* global monitor netdev */
 
 extern int  mac_xmit(struct sk_buff *skb, struct net_device *dev);
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index b1c6b6f..ebacd29 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -23,7 +23,6 @@
 
 
 struct sdio_func *local_sdio_func;
-extern linux_wlan_t *g_linux_wlan;
 extern int wilc_netdev_init(void);
 extern void wilc_handle_isr(void);
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 706912b..a950b04 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -35,7 +35,6 @@ static u8 op_ifcs;
 extern u8 u8ConnectedSSID[6];
 
 u8 g_wilc_initialized = 1;
-extern linux_wlan_t *g_linux_wlan;
 extern bool g_obtainingIP;
 
 #define CHAN2G(_channel, _freq, _flags) {	 \
@@ -2192,7 +2191,6 @@ void WILC_WFI_add_wilcvendorspec(u8 *buff)
  *  @date	01 JUL 2012
  *  @version
  */
-extern linux_wlan_t *g_linux_wlan;
 extern bool bEnablePS;
 static int mgmt_tx(struct wiphy *wiphy,
 		   struct wireless_dev *wdev,
-- 
1.9.1


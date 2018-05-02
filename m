Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:63761 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbeEBHPW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:22 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 09/21] staging: wilc1000: rename WILC_WFI_mon_priv to avoid uppercase for struct name
Date: Wed, 2 May 2018 12:43:35 +0530
Message-ID: <1525245227-3924-10-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_092101_660292_230F3D96)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to avoid 'struct' name with uppercase letters.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/linux_mon.c          | 6 +++---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index ff13e0d..1667646 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -149,7 +149,7 @@ static netdev_tx_t WILC_WFI_mon_xmit(struct sk_buff *skb,
 				     struct net_device *dev)
 {
 	u32 rtap_len, ret = 0;
-	struct WILC_WFI_mon_priv  *mon_priv;
+	struct wilc_wfi_mon_priv  *mon_priv;
 
 	struct sk_buff *skb2;
 	struct wilc_wfi_radiotap_cb_hdr *cb_hdr;
@@ -225,13 +225,13 @@ static const struct net_device_ops wilc_wfi_netdev_ops = {
 struct net_device *WILC_WFI_init_mon_interface(const char *name,
 					       struct net_device *real_dev)
 {
-	struct WILC_WFI_mon_priv *priv;
+	struct wilc_wfi_mon_priv *priv;
 
 	/*If monitor interface is already initialized, return it*/
 	if (wilc_wfi_mon)
 		return wilc_wfi_mon;
 
-	wilc_wfi_mon = alloc_etherdev(sizeof(struct WILC_WFI_mon_priv));
+	wilc_wfi_mon = alloc_etherdev(sizeof(struct wilc_wfi_mon_priv));
 	if (!wilc_wfi_mon)
 		return NULL;
 	wilc_wfi_mon->type = ARPHRD_IEEE80211_RADIOTAP;
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 02e9b07..5448c6b 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -196,7 +196,7 @@ struct wilc {
 	struct rf_info dummy_statistics;
 };
 
-struct WILC_WFI_mon_priv {
+struct wilc_wfi_mon_priv {
 	struct net_device *real_ndev;
 };
 
-- 
2.7.4

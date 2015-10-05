Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8804 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbJEG1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:27:01 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 09/18] staging: wilc1000: remove typedef from tstrHostIFpmkidAttr
Date: Mon, 5 Oct 2015 15:25:44 +0900
Message-ID: <1444026353-29024-9-git-send-email-tony.cho@atmel.com> (sfid-20151005_082705_858410_F2D49F45)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrHostIFpmkidAttr.
And rename it to host_if_pmkid_attr.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.c         | 4 ++--
 drivers/staging/wilc1000/host_interface.h         | 6 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b5de66a..adc81cd 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -127,7 +127,7 @@ struct host_if_wep_attr {
 union host_if_key_attr {
 	struct host_if_wep_attr strHostIFwepAttr;
 	struct host_if_wpa_attr strHostIFwpaAttr;
-	tstrHostIFpmkidAttr strHostIFpmkidAttr;
+	struct host_if_pmkid_attr strHostIFpmkidAttr;
 };
 
 /*!
@@ -4725,7 +4725,7 @@ s32 host_int_add_rx_gtk(tstrWILC_WFIDrv *hWFIDrv, const u8 *pu8RxGtk, u8 u8GtkKe
  *  @date		8 March 2012
  *  @version		1.0
  */
-s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray)
+s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, struct host_if_pmkid_attr *pu8PmkidInfoArray)
 {
 	s32 s32Error = 0;
 	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 856cab0..e9a9715 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -88,10 +88,10 @@ typedef struct _tstrHostIFpmkid {
 	u8 pmkid[PMKID_LEN];
 } tstrHostIFpmkid;
 
-typedef struct _tstrHostIFpmkidAttr {
+struct host_if_pmkid_attr {
 	u8 numpmkid;
 	tstrHostIFpmkid pmkidlist[WILC_MAX_NUM_PMKIDS];
-} tstrHostIFpmkidAttr;
+};
 
 typedef enum {
 	AUTORATE	= 0,
@@ -550,7 +550,7 @@ s32 host_int_add_tx_gtk(tstrWILC_WFIDrv *hWFIDrv, u8 u8KeyLen, u8 *pu8TxGtk, u8
  *  @version		1.0
  */
 
-s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, tstrHostIFpmkidAttr *pu8PmkidInfoArray);
+s32 host_int_set_pmkid_info(tstrWILC_WFIDrv *hWFIDrv, struct host_if_pmkid_attr *pu8PmkidInfoArray);
 /**
  *  @brief              gets the cached the pmkid info
  *  @details    valid only in BSS STA mode if External Supplicant
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 788cfaa..eac77ce3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1924,7 +1924,7 @@ static int flush_pmksa(struct wiphy *wiphy, struct net_device *netdev)
 	PRINT_D(CFG80211_DBG,  "Flushing  PMKID key values\n");
 
 	/*Get cashed Pmkids and set all with zeros*/
-	memset(&priv->pmkid_list, 0, sizeof(tstrHostIFpmkidAttr));
+	memset(&priv->pmkid_list, 0, sizeof(struct host_if_pmkid_attr));
 
 	return 0;
 }
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index d25092d..cb21968 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -122,7 +122,7 @@ struct wilc_priv {
 	struct net_device *dev;
 	struct napi_struct napi;
 	tstrWILC_WFIDrv *hWILCWFIDrv;
-	tstrHostIFpmkidAttr pmkid_list;
+	struct host_if_pmkid_attr pmkid_list;
 	struct WILC_WFI_stats netstats;
 	u8 WILC_WFI_wep_default;
 	u8 WILC_WFI_wep_key[4][WLAN_KEY_LEN_WEP104];
-- 
1.9.1


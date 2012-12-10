Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56144 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2LJWMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 17:12:18 -0500
Received: by mail-wi0-f180.google.com with SMTP id hj13so1788580wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 14:12:17 -0800 (PST)
Message-ID: <1355177527.4680.22.camel@canaries64> (sfid-20121210_231222_454012_158603D7)
Subject: [PATCH 07/11] staging: vt6656: iwctl/key/rf use new structures.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 22:12:07 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch cleans up function declarations, definitions and local variables
were appropriate replacing types defined in "ttype.h" with linux/types.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/iwctl.c | 100 ++++++++++++++---------------
 drivers/staging/vt6656/key.c   | 140 +++++++++++++++--------------------------
 drivers/staging/vt6656/key.h   |  96 ++++++++++------------------
 drivers/staging/vt6656/rf.c    | 134 +++++++++++++++++----------------------
 drivers/staging/vt6656/rf.h    |  26 +++-----
 5 files changed, 198 insertions(+), 298 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 52fce69..880c025 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -55,7 +55,7 @@ static int msglevel = MSG_LEVEL_INFO;
 
 struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	long ldBm;
 
 	pDevice->wstats.status = pDevice->eOPMode;
@@ -91,9 +91,9 @@ int iwctl_giwname(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwscan(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_point *wrq = &wrqu->data;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct iw_scan_req *req = (struct iw_scan_req *)extra;
 	BYTE abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
 	PWLAN_IE_SSID pItemSSID = NULL;
@@ -169,8 +169,8 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 	int ii;
 	int jj;
 	int kk;
-	PSDevice pDevice = netdev_priv(dev);
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_private *pDevice = netdev_priv(dev);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	PKnownBSS pBSS;
 	PWLAN_IE_SSID pItemSSID;
 	PWLAN_IE_SUPP_RATES pSuppRates;
@@ -309,7 +309,7 @@ int iwctl_giwscan(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_freq *wrq = &wrqu->freq;
 	int rc = 0;
 
@@ -348,9 +348,9 @@ int iwctl_siwfreq(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_freq *wrq = &wrqu->freq;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFREQ\n");
 
@@ -379,9 +379,9 @@ int iwctl_giwfreq(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	__u32 *wmode = &wrqu->mode;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	int rc = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWMODE\n");
@@ -492,9 +492,9 @@ int iwctl_siwmode(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwmode(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	__u32 *wmode = &wrqu->mode;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWMODE\n");
 
@@ -631,9 +631,9 @@ int iwctl_giwrange(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct sockaddr *wrq = &wrqu->ap_addr;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	int rc = 0;
 	BYTE ZeroBSSID[WLAN_BSSID_LEN] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 
@@ -683,9 +683,9 @@ int iwctl_siwap(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwap(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct sockaddr *wrq = &wrqu->ap_addr;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAP\n");
 
@@ -713,8 +713,8 @@ int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
 	struct iw_point *wrq = &wrqu->data;
 	struct sockaddr *sock;
 	struct iw_quality *qual;
-	PSDevice pDevice = netdev_priv(dev);
-	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
+	struct vnt_private *pDevice = netdev_priv(dev);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	PKnownBSS pBSS = &pMgmt->sBSSList[0];
 	int ii;
 	int jj;
@@ -771,9 +771,9 @@ int iwctl_giwaplist(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_point	*wrq = &wrqu->essid;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	PWLAN_IE_SSID pItemSSID;
 
 	if (pMgmt == NULL)
@@ -878,9 +878,9 @@ int iwctl_siwessid(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_point	*wrq = &wrqu->essid;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	PWLAN_IE_SSID pItemSSID;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWESSID\n");
@@ -908,7 +908,7 @@ int iwctl_giwessid(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_param *wrq = &wrqu->bitrate;
 	int rc = 0;
 	u8 brate = 0;
@@ -986,9 +986,9 @@ int iwctl_siwrate(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_param *wrq = &wrqu->bitrate;
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRATE\n");
 
@@ -1037,7 +1037,7 @@ int iwctl_giwrate(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwrts(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_param *wrq = &wrqu->rts;
 
 	if ((wrq->value < 0 || wrq->value > 2312) && !wrq->disabled)
@@ -1057,7 +1057,7 @@ int iwctl_siwrts(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_param *wrq = &wrqu->rts;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRTS\n");
@@ -1073,7 +1073,7 @@ int iwctl_giwrts(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_param *wrq = &wrqu->frag;
 	int rc = 0;
 	int fthr = wrq->value;
@@ -1097,7 +1097,7 @@ int iwctl_siwfrag(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_param *wrq = &wrqu->frag;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFRAG\n");
@@ -1113,7 +1113,7 @@ int iwctl_giwfrag(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_param *wrq = &wrqu->retry;
 	int rc = 0;
 
@@ -1146,7 +1146,7 @@ int iwctl_siwretry(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_param *wrq = &wrqu->retry;
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY\n");
 	wrq->disabled = 0; // Can't be disabled
@@ -1173,8 +1173,8 @@ int iwctl_giwretry(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_private *pDevice = netdev_priv(dev);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct iw_point *wrq = &wrqu->encoding;
 	u32 dwKeyIndex = (u32)(wrq->flags & IW_ENCODE_INDEX);
 	int ii;
@@ -1271,8 +1271,8 @@ int iwctl_siwencode(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_private *pDevice = netdev_priv(dev);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct iw_point *wrq = &wrqu->encoding;
 	char abyKey[WLAN_WEP232_KEYLEN];
 
@@ -1333,8 +1333,8 @@ int iwctl_giwencode(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_private *pDevice = netdev_priv(dev);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct iw_param *wrq = &wrqu->power;
 	int rc = 0;
 
@@ -1385,8 +1385,8 @@ int iwctl_siwpower(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_private *pDevice = netdev_priv(dev);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct iw_param *wrq = &wrqu->power;
 	int mode = pDevice->ePSMode;
 
@@ -1418,7 +1418,7 @@ int iwctl_giwpower(struct net_device *dev, struct iw_request_info *info,
 int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_param *wrq = &wrqu->sens;
 	long ldBm;
 
@@ -1437,8 +1437,8 @@ int iwctl_giwsens(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwauth(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_private *pDevice = netdev_priv(dev);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct iw_param *wrq = &wrqu->param;
 	int ret = 0;
 	static int wpa_version = 0; // must be static to save the last value, einsn liu
@@ -1547,8 +1547,8 @@ int iwctl_giwauth(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwgenie(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_private *pDevice = netdev_priv(dev);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct iw_point *wrq = &wrqu->data;
 	int ret = 0;
 
@@ -1582,8 +1582,8 @@ out: // not completely ...not necessary in wpa_supplicant 0.5.8
 int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_private *pDevice = netdev_priv(dev);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct iw_point *wrq = &wrqu->data;
 	int ret = 0;
 	int space = wrq->length;
@@ -1608,8 +1608,8 @@ int iwctl_giwgenie(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwencodeext(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_private *pDevice = netdev_priv(dev);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct iw_point *wrq = &wrqu->encoding;
 	struct iw_encode_ext *ext = (struct iw_encode_ext*)extra;
 	struct viawget_wpa_param *param=NULL;
@@ -1741,8 +1741,8 @@ int iwctl_giwencodeext(struct net_device *dev, struct iw_request_info *info,
 int iwctl_siwmlme(struct net_device *dev, struct iw_request_info *info,
 		union iwreq_data *wrqu, char *extra)
 {
-	PSDevice pDevice = netdev_priv(dev);
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+	struct vnt_private *pDevice = netdev_priv(dev);
+	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
 	int ret = 0;
 
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 6f6a219..87eab91 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -60,13 +60,12 @@ static int          msglevel                =MSG_LEVEL_INFO;
 /*---------------------  Static Variables  --------------------------*/
 
 /*---------------------  Static Functions  --------------------------*/
-static void s_vCheckKeyTableValid(void *pDeviceHandler,
-				  PSKeyManagement pTable)
+static void s_vCheckKeyTableValid(struct vnt_private *pDevice,
+	PSKeyManagement pTable)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    int         i;
-    WORD        wLength = 0;
-    BYTE        pbyData[MAX_KEY_TABLE];
+	int i;
+	u16 wLength = 0;
+	u8 pbyData[MAX_KEY_TABLE];
 
     for (i=0;i<MAX_KEY_TABLE;i++) {
         if ((pTable->KeyTable[i].bInUse == TRUE) &&
@@ -112,12 +111,10 @@ static void s_vCheckKeyTableValid(void *pDeviceHandler,
  * Return Value: none
  *
  */
-void KeyvInitTable(void *pDeviceHandler, PSKeyManagement pTable)
+void KeyvInitTable(struct vnt_private *pDevice, PSKeyManagement pTable)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    int i;
-    int jj;
-    BYTE       pbyData[MAX_KEY_TABLE+1];
+	int i, jj;
+	u8 pbyData[MAX_KEY_TABLE+1];
 
     spin_lock_irq(&pDevice->lock);
     for (i=0;i<MAX_KEY_TABLE;i++) {
@@ -164,12 +161,12 @@ void KeyvInitTable(void *pDeviceHandler, PSKeyManagement pTable)
  * Return Value: TRUE if found otherwise FALSE
  *
  */
-BOOL KeybGetKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyIndex,
-		PSKeyItem *pKey)
+int KeybGetKey(PSKeyManagement pTable, u8 *pbyBSSID, u32 dwKeyIndex,
+	PSKeyItem *pKey)
 {
-    int i;
+	int i;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KeybGetKey() \n");
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"KeybGetKey()\n");
 
     *pKey = NULL;
     for (i=0;i<MAX_KEY_TABLE;i++) {
@@ -218,22 +215,13 @@ BOOL KeybGetKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyIndex,
  * Return Value: TRUE if success otherwise FALSE
  *
  */
-BOOL KeybSetKey(
-    void *pDeviceHandler,
-    PSKeyManagement pTable,
-    PBYTE           pbyBSSID,
-    DWORD           dwKeyIndex,
-	u32 uKeyLength,
-	u64 *KeyRSC,
-    PBYTE           pbyKey,
-    BYTE            byKeyDecMode
-    )
+int KeybSetKey(struct vnt_private *pDevice, PSKeyManagement pTable,
+	u8 *pbyBSSID, u32 dwKeyIndex, u32 uKeyLength, u64 *KeyRSC, u8 *pbyKey,
+	u8 byKeyDecMode)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    int         i,j;
-    unsigned int        ii;
-    PSKeyItem   pKey;
-    unsigned int        uKeyIdx;
+	PSKeyItem   pKey;
+	int i, j, ii;
+	u32 uKeyIdx;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 		"Enter KeybSetKey: %X\n", dwKeyIndex);
@@ -397,16 +385,12 @@ BOOL KeybSetKey(
  * Return Value: TRUE if success otherwise FALSE
  *
  */
-BOOL KeybRemoveKey(
-    void *pDeviceHandler,
-    PSKeyManagement pTable,
-    PBYTE           pbyBSSID,
-    DWORD           dwKeyIndex
-    )
+
+int KeybRemoveKey(struct vnt_private *pDevice, PSKeyManagement pTable,
+	u8 *pbyBSSID, u32 dwKeyIndex)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    int     i;
-    BOOL    bReturnValue = FALSE;
+	int i;
+	int bReturnValue = FALSE;
 
     if (is_broadcast_ether_addr(pbyBSSID)) {
         // delete all keys
@@ -478,14 +462,10 @@ BOOL KeybRemoveKey(
  * Return Value: TRUE if success otherwise FALSE
  *
  */
-BOOL KeybRemoveAllKey(
-    void *pDeviceHandler,
-    PSKeyManagement pTable,
-    PBYTE           pbyBSSID
-    )
+int KeybRemoveAllKey(struct vnt_private *pDevice, PSKeyManagement pTable,
+	u8 *pbyBSSID)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    int  i,u;
+	int i, u;
 
     for (i=0;i<MAX_KEY_TABLE;i++) {
         if ((pTable->KeyTable[i].bInUse == TRUE) &&
@@ -514,13 +494,9 @@ BOOL KeybRemoveAllKey(
  * Return Value: TRUE if success otherwise FALSE
  *
  */
-void KeyvRemoveWEPKey(
-    void *pDeviceHandler,
-    PSKeyManagement pTable,
-    DWORD           dwKeyIndex
-    )
+void KeyvRemoveWEPKey(struct vnt_private *pDevice, PSKeyManagement pTable,
+	u32 dwKeyIndex)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
 
    if ((dwKeyIndex & 0x000000FF) < MAX_GROUP_KEY) {
         if (pTable->KeyTable[MAX_KEY_TABLE-1].bInUse == TRUE) {
@@ -537,9 +513,8 @@ void KeyvRemoveWEPKey(
     return;
 }
 
-void KeyvRemoveAllWEPKey(void *pDeviceHandler, PSKeyManagement pTable)
+void KeyvRemoveAllWEPKey(struct vnt_private *pDevice, PSKeyManagement pTable)
 {
-	PSDevice pDevice = (PSDevice) pDeviceHandler;
 	int i;
 
 	for (i = 0; i < MAX_GROUP_KEY; i++)
@@ -559,12 +534,13 @@ void KeyvRemoveAllWEPKey(void *pDeviceHandler, PSKeyManagement pTable)
  * Return Value: TRUE if found otherwise FALSE
  *
  */
-BOOL KeybGetTransmitKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyType,
-			PSKeyItem *pKey)
+int KeybGetTransmitKey(PSKeyManagement pTable, u8 *pbyBSSID, u32 dwKeyType,
+	PSKeyItem *pKey)
 {
-    int i, ii;
+	int i, ii;
+
+	*pKey = NULL;
 
-    *pKey = NULL;
     for (i = 0; i < MAX_KEY_TABLE; i++) {
         if ((pTable->KeyTable[i].bInUse == TRUE) &&
 	    !compare_ether_addr(pTable->KeyTable[i].abyBSSID, pbyBSSID)) {
@@ -636,11 +612,12 @@ BOOL KeybGetTransmitKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyType,
  * Return Value: TRUE if found otherwise FALSE
  *
  */
-BOOL KeybCheckPairewiseKey(PSKeyManagement pTable, PSKeyItem *pKey)
+int KeybCheckPairewiseKey(PSKeyManagement pTable, PSKeyItem *pKey)
 {
-    int i;
+	int i;
+
+	*pKey = NULL;
 
-    *pKey = NULL;
     for (i=0;i<MAX_KEY_TABLE;i++) {
         if ((pTable->KeyTable[i].bInUse == TRUE) &&
             (pTable->KeyTable[i].PairwiseKey.bKeyValid == TRUE)) {
@@ -667,20 +644,14 @@ BOOL KeybCheckPairewiseKey(PSKeyManagement pTable, PSKeyItem *pKey)
  * Return Value: TRUE if success otherwise FALSE
  *
  */
-BOOL KeybSetDefaultKey(
-    void *pDeviceHandler,
-    PSKeyManagement pTable,
-    DWORD           dwKeyIndex,
-	u32 uKeyLength,
-	u64 *KeyRSC,
-    PBYTE           pbyKey,
-    BYTE            byKeyDecMode
-    )
+
+int KeybSetDefaultKey(struct vnt_private *pDevice, PSKeyManagement pTable,
+	u32 dwKeyIndex, u32 uKeyLength, u64 *KeyRSC, u8 *pbyKey,
+	u8 byKeyDecMode)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    unsigned int        ii;
-    PSKeyItem   pKey;
-    unsigned int        uKeyIdx;
+	int ii;
+	PSKeyItem pKey;
+	u32 uKeyIdx;
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Enter KeybSetDefaultKey: %1x, %d\n",
 	    (int) dwKeyIndex, (int) uKeyLength);
@@ -783,21 +754,14 @@ BOOL KeybSetDefaultKey(
  * Return Value: TRUE if success otherwise FALSE
  *
  */
-BOOL KeybSetAllGroupKey(
-    void *pDeviceHandler,
-    PSKeyManagement pTable,
-    DWORD           dwKeyIndex,
-	u32 uKeyLength,
-	u64 *KeyRSC,
-    PBYTE           pbyKey,
-    BYTE            byKeyDecMode
-    )
+
+int KeybSetAllGroupKey(struct vnt_private *pDevice, PSKeyManagement pTable,
+	u32 dwKeyIndex, u32 uKeyLength, u64 *KeyRSC, u8 *pbyKey,
+	u8 byKeyDecMode)
 {
-    PSDevice    pDevice = (PSDevice) pDeviceHandler;
-    int         i;
-    unsigned int        ii;
-    PSKeyItem   pKey;
-    unsigned int        uKeyIdx;
+	int i, ii;
+	PSKeyItem pKey;
+	u32 uKeyIdx;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Enter KeybSetAllGroupKey: %X\n",
 		dwKeyIndex);
diff --git a/drivers/staging/vt6656/key.h b/drivers/staging/vt6656/key.h
index 863db7c..8889423 100644
--- a/drivers/staging/vt6656/key.h
+++ b/drivers/staging/vt6656/key.h
@@ -97,69 +97,37 @@ typedef struct tagSKeyManagement
 
 /*---------------------  Export Functions  --------------------------*/
 
-void KeyvInitTable(void *pDeviceHandler, PSKeyManagement pTable);
-
-BOOL KeybGetKey(PSKeyManagement pTable, PBYTE pbyBSSID, DWORD dwKeyIndex,
-		PSKeyItem *pKey);
-
-BOOL KeybSetKey(
-    void *pDeviceHandler,
-    PSKeyManagement pTable,
-    PBYTE           pbyBSSID,
-    DWORD           dwKeyIndex,
-	u32 uKeyLength,
-	u64 *KeyRSC,
-    PBYTE           pbyKey,
-    BYTE            byKeyDecMode
-    );
-
-BOOL KeybRemoveKey(
-    void *pDeviceHandler,
-    PSKeyManagement pTable,
-    PBYTE           pbyBSSID,
-    DWORD           dwKeyIndex
-    );
-
-BOOL KeybRemoveAllKey(
-    void *pDeviceHandler,
-    PSKeyManagement pTable,
-    PBYTE           pbyBSSID
-    );
-
-void KeyvRemoveWEPKey(
-    void *pDeviceHandler,
-    PSKeyManagement pTable,
-    DWORD           dwKeyIndex
-    );
-
-void KeyvRemoveAllWEPKey(
-    void *pDeviceHandler,
-    PSKeyManagement pTable
-    );
-
-BOOL KeybGetTransmitKey(PSKeyManagement pTable,	PBYTE pbyBSSID,	DWORD dwKeyType,
-			PSKeyItem *pKey);
-
-BOOL KeybCheckPairewiseKey(PSKeyManagement pTable, PSKeyItem *pKey);
-
-BOOL KeybSetDefaultKey(
-    void *pDeviceHandler,
-    PSKeyManagement pTable,
-    DWORD           dwKeyIndex,
-	u32 uKeyLength,
-	u64 *KeyRSC,
-    PBYTE           pbyKey,
-    BYTE            byKeyDecMode
-    );
-
-BOOL KeybSetAllGroupKey(
-    void *pDeviceHandler,
-    PSKeyManagement pTable,
-    DWORD           dwKeyIndex,
-	u32 uKeyLength,
-	u64 *KeyRSC,
-    PBYTE           pbyKey,
-    BYTE            byKeyDecMode
-    );
+void KeyvInitTable(struct vnt_private *, PSKeyManagement pTable);
+
+int KeybGetKey(PSKeyManagement pTable, u8 *pbyBSSID, u32 dwKeyIndex,
+	PSKeyItem *pKey);
+
+int KeybSetKey(struct vnt_private *, PSKeyManagement pTable, u8 *pbyBSSID,
+	u32 dwKeyIndex, u32 uKeyLength, u64 *KeyRSC, u8 *pbyKey,
+	u8 byKeyDecMode);
+
+int KeybRemoveKey(struct vnt_private *, PSKeyManagement pTable,
+	u8 *pbyBSSID, u32 dwKeyIndex);
+
+int KeybRemoveAllKey(struct vnt_private *, PSKeyManagement pTable,
+	u8 *pbyBSSID);
+
+void KeyvRemoveWEPKey(struct vnt_private *, PSKeyManagement pTable,
+	u32 dwKeyIndex);
+
+void KeyvRemoveAllWEPKey(struct vnt_private *, PSKeyManagement pTable);
+
+int KeybGetTransmitKey(PSKeyManagement pTable, u8 *pbyBSSID, u32 dwKeyType,
+	PSKeyItem *pKey);
+
+int KeybCheckPairewiseKey(PSKeyManagement pTable, PSKeyItem *pKey);
+
+int KeybSetDefaultKey(struct vnt_private *, PSKeyManagement pTable,
+	u32 dwKeyIndex, u32 uKeyLength, u64 *KeyRSC, u8 *pbyKey,
+	u8 byKeyDecMode);
+
+int KeybSetAllGroupKey(struct vnt_private *, PSKeyManagement pTable,
+	u32 dwKeyIndex, u32 uKeyLength, u64 *KeyRSC, u8 *pbyKey,
+	u8 byKeyDecMode);
 
 #endif /* __KEY_H__ */
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 74c0598..06cff8b 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -69,7 +69,7 @@ static int          msglevel                =MSG_LEVEL_INFO;
 


-BYTE abyAL2230InitTable[CB_AL2230_INIT_SEQ][3] = {
+u8 abyAL2230InitTable[CB_AL2230_INIT_SEQ][3] = {
     {0x03, 0xF7, 0x90},
     {0x03, 0x33, 0x31},
     {0x01, 0xB8, 0x02},
@@ -87,7 +87,7 @@ BYTE abyAL2230InitTable[CB_AL2230_INIT_SEQ][3] = {
     {0x00, 0x58, 0x0F}
     };
 
-BYTE abyAL2230ChannelTable0[CB_MAX_CHANNEL_24G][3] = {
+u8 abyAL2230ChannelTable0[CB_MAX_CHANNEL_24G][3] = {
     {0x03, 0xF7, 0x90}, // channel = 1, Tf = 2412MHz
     {0x03, 0xF7, 0x90}, // channel = 2, Tf = 2417MHz
     {0x03, 0xE7, 0x90}, // channel = 3, Tf = 2422MHz
@@ -104,7 +104,7 @@ BYTE abyAL2230ChannelTable0[CB_MAX_CHANNEL_24G][3] = {
     {0x03, 0xE7, 0xC0}  // channel = 14, Tf = 2412M
     };
 
-BYTE abyAL2230ChannelTable1[CB_MAX_CHANNEL_24G][3] = {
+u8 abyAL2230ChannelTable1[CB_MAX_CHANNEL_24G][3] = {
     {0x03, 0x33, 0x31}, // channel = 1, Tf = 2412MHz
     {0x0B, 0x33, 0x31}, // channel = 2, Tf = 2417MHz
     {0x03, 0x33, 0x31}, // channel = 3, Tf = 2422MHz
@@ -123,7 +123,7 @@ BYTE abyAL2230ChannelTable1[CB_MAX_CHANNEL_24G][3] = {
 
 // 40MHz reference frequency
 // Need to Pull PLLON(PE3) low when writing channel registers through 3-wire.
-BYTE abyAL7230InitTable[CB_AL7230_INIT_SEQ][3] = {
+u8 abyAL7230InitTable[CB_AL7230_INIT_SEQ][3] = {
     {0x20, 0x37, 0x90}, // Channel1 // Need modify for 11a
     {0x13, 0x33, 0x31}, // Channel1 // Need modify for 11a
     {0x84, 0x1F, 0xF2}, // Need modify for 11a: 451FE2
@@ -146,7 +146,7 @@ BYTE abyAL7230InitTable[CB_AL7230_INIT_SEQ][3] = {
     {0x1A, 0xBA, 0x8F} // Need modify for 11a: 12BACF
     };
 
-BYTE abyAL7230InitTableAMode[CB_AL7230_INIT_SEQ][3] = {
+u8 abyAL7230InitTableAMode[CB_AL7230_INIT_SEQ][3] = {
     {0x2F, 0xF5, 0x20}, // Channel184 // Need modify for 11b/g
     {0x00, 0x00, 0x01}, // Channel184 // Need modify for 11b/g
     {0x45, 0x1F, 0xE2}, // Need modify for 11b/g
@@ -165,7 +165,7 @@ BYTE abyAL7230InitTableAMode[CB_AL7230_INIT_SEQ][3] = {
     {0x12, 0xBA, 0xCF} // Need modify for 11b/g
     };
 
-BYTE abyAL7230ChannelTable0[CB_MAX_CHANNEL][3] = {
+u8 abyAL7230ChannelTable0[CB_MAX_CHANNEL][3] = {
     {0x20, 0x37, 0x90}, // channel =  1, Tf = 2412MHz
     {0x20, 0x37, 0x90}, // channel =  2, Tf = 2417MHz
     {0x20, 0x37, 0x90}, // channel =  3, Tf = 2422MHz
@@ -231,7 +231,7 @@ BYTE abyAL7230ChannelTable0[CB_MAX_CHANNEL][3] = {
     {0x2F, 0xF6, 0x10} // channel = 165, Tf = 5825MHz (56)
     };
 
-BYTE abyAL7230ChannelTable1[CB_MAX_CHANNEL][3] = {
+u8 abyAL7230ChannelTable1[CB_MAX_CHANNEL][3] = {
     {0x13, 0x33, 0x31}, // channel =  1, Tf = 2412MHz
     {0x1B, 0x33, 0x31}, // channel =  2, Tf = 2417MHz
     {0x03, 0x33, 0x31}, // channel =  3, Tf = 2422MHz
@@ -295,7 +295,7 @@ BYTE abyAL7230ChannelTable1[CB_MAX_CHANNEL][3] = {
     {0x02, 0xAA, 0xB1}  // channel = 165, Tf = 5825MHz (56)
     };
 
-BYTE abyAL7230ChannelTable2[CB_MAX_CHANNEL][3] = {
+u8 abyAL7230ChannelTable2[CB_MAX_CHANNEL][3] = {
     {0x7F, 0xD7, 0x84}, // channel =  1, Tf = 2412MHz
     {0x7F, 0xD7, 0x84}, // channel =  2, Tf = 2417MHz
     {0x7F, 0xD7, 0x84}, // channel =  3, Tf = 2422MHz
@@ -360,7 +360,7 @@ BYTE abyAL7230ChannelTable2[CB_MAX_CHANNEL][3] = {
     };
 
 ///{{RobertYu:20051111
-BYTE abyVT3226_InitTable[CB_VT3226_INIT_SEQ][3] = {
+u8 abyVT3226_InitTable[CB_VT3226_INIT_SEQ][3] = {
     {0x03, 0xFF, 0x80},
     {0x02, 0x82, 0xA1},
     {0x03, 0xC6, 0xA2},
@@ -374,7 +374,7 @@ BYTE abyVT3226_InitTable[CB_VT3226_INIT_SEQ][3] = {
     {0x02, 0x00, 0x2A}
     };
 
-BYTE abyVT3226D0_InitTable[CB_VT3226_INIT_SEQ][3] = {
+u8 abyVT3226D0_InitTable[CB_VT3226_INIT_SEQ][3] = {
     {0x03, 0xFF, 0x80},
     {0x03, 0x02, 0x21}, //RobertYu:20060327
     {0x03, 0xC6, 0xA2},
@@ -389,7 +389,7 @@ BYTE abyVT3226D0_InitTable[CB_VT3226_INIT_SEQ][3] = {
     };
 

-BYTE abyVT3226_ChannelTable0[CB_MAX_CHANNEL_24G][3] = {
+u8 abyVT3226_ChannelTable0[CB_MAX_CHANNEL_24G][3] = {
     {0x01, 0x97, 0x83}, // channel = 1, Tf = 2412MHz
     {0x01, 0x97, 0x83}, // channel = 2, Tf = 2417MHz
     {0x01, 0x97, 0x93}, // channel = 3, Tf = 2422MHz
@@ -406,7 +406,7 @@ BYTE abyVT3226_ChannelTable0[CB_MAX_CHANNEL_24G][3] = {
     {0x03, 0x37, 0xC3}  // channel = 14, Tf = 2484MHz
     };
 
-BYTE abyVT3226_ChannelTable1[CB_MAX_CHANNEL_24G][3] = {
+u8 abyVT3226_ChannelTable1[CB_MAX_CHANNEL_24G][3] = {
     {0x02, 0x66, 0x64}, // channel = 1, Tf = 2412MHz
     {0x03, 0x66, 0x64}, // channel = 2, Tf = 2417MHz
     {0x00, 0x66, 0x64}, // channel = 3, Tf = 2422MHz
@@ -426,7 +426,7 @@ BYTE abyVT3226_ChannelTable1[CB_MAX_CHANNEL_24G][3] = {
 

 //{{RobertYu:20060502, TWIF 1.14, LO Current for 11b mode
-DWORD dwVT3226D0LoCurrentTable[CB_MAX_CHANNEL_24G] = {
+u32 dwVT3226D0LoCurrentTable[CB_MAX_CHANNEL_24G] = {
     0x0135C600+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW, // channel = 1, Tf = 2412MHz
     0x0135C600+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW, // channel = 2, Tf = 2417MHz
     0x0235C600+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW, // channel = 3, Tf = 2422MHz
@@ -446,7 +446,7 @@ DWORD dwVT3226D0LoCurrentTable[CB_MAX_CHANNEL_24G] = {
 

 //{{RobertYu:20060609
-BYTE abyVT3342A0_InitTable[CB_VT3342_INIT_SEQ][3] = { // 11b/g mode
+u8 abyVT3342A0_InitTable[CB_VT3342_INIT_SEQ][3] = { /* 11b/g mode */
     {0x03, 0xFF, 0x80}, //update for mode//
     {0x02, 0x08, 0x81},
     {0x00, 0xC6, 0x02},
@@ -469,7 +469,7 @@ BYTE abyVT3342A0_InitTable[CB_VT3342_INIT_SEQ][3] = { // 11b/g mode
  // channel56, 5280MHz  0x00C402 for disable Frac
  // other channels 0x00C602
 
-BYTE abyVT3342_ChannelTable0[CB_MAX_CHANNEL][3] = {
+u8 abyVT3342_ChannelTable0[CB_MAX_CHANNEL][3] = {
     {0x02, 0x05, 0x03}, // channel = 1, Tf = 2412MHz
     {0x01, 0x15, 0x03}, // channel = 2, Tf = 2417MHz
     {0x03, 0xC5, 0x03}, // channel = 3, Tf = 2422MHz
@@ -535,7 +535,7 @@ BYTE abyVT3342_ChannelTable0[CB_MAX_CHANNEL][3] = {
     {0x00, 0x06, 0x03}  // channel = 165, Tf = 5825MHz (56), TBD
     };
 
-BYTE abyVT3342_ChannelTable1[CB_MAX_CHANNEL][3] = {
+u8 abyVT3342_ChannelTable1[CB_MAX_CHANNEL][3] = {
     {0x01, 0x99, 0x94}, // channel = 1, Tf = 2412MHz
     {0x02, 0x44, 0x44}, // channel = 2, Tf = 2417MHz
     {0x02, 0xEE, 0xE4}, // channel = 3, Tf = 2422MHz
@@ -606,7 +606,7 @@ BYTE abyVT3342_ChannelTable1[CB_MAX_CHANNEL][3] = {
  *
 -*/
 
-const DWORD dwAL2230PowerTable[AL2230_PWR_IDX_LEN] = {
+const u32 dwAL2230PowerTable[AL2230_PWR_IDX_LEN] = {
     0x04040900+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW,
     0x04041900+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW,
     0x04042900+(BY_AL2230_REG_LEN<<3)+IFREGCTL_REGW,
@@ -682,7 +682,7 @@ const DWORD dwAL2230PowerTable[AL2230_PWR_IDX_LEN] = {
 // 5G => Ch 7, 8, 9, 11, 12, 16, 34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64,
 // 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 149, 153, 157, 161, 165  (Value 23 ~ 56)
 
-const BYTE RFaby11aChannelIndex[200] = {
+const u8 RFaby11aChannelIndex[200] = {
   // 1   2   3   4   5   6   7   8   9  10
     00, 00, 00, 00, 00, 00, 23, 24, 25, 00,  // 10
     26, 27, 00, 00, 00, 28, 00, 00, 00, 00,  // 20
@@ -722,24 +722,20 @@ const BYTE RFaby11aChannelIndex[200] = {
  * Return Value: TRUE if succeeded; FALSE if failed.
  *
  */
-BOOL IFRFbWriteEmbedded (PSDevice pDevice, DWORD dwData)
+int IFRFbWriteEmbedded(struct vnt_private *pDevice, u32 dwData)
 {
-    BYTE        pbyData[4];
+	u8 pbyData[4];
 
-    pbyData[0] = (BYTE)dwData;
-    pbyData[1] = (BYTE)(dwData>>8);
-    pbyData[2] = (BYTE)(dwData>>16);
-    pbyData[3] = (BYTE)(dwData>>24);
-    CONTROLnsRequestOut(pDevice,
-                    MESSAGE_TYPE_WRITE_IFRF,
-                    0,
-                    0,
-                    4,
-                    pbyData
-                        );
+	pbyData[0] = (u8)dwData;
+	pbyData[1] = (u8)(dwData >> 8);
+	pbyData[2] = (u8)(dwData >> 16);
+	pbyData[3] = (u8)(dwData >> 24);
+
+	CONTROLnsRequestOut(pDevice,
+		MESSAGE_TYPE_WRITE_IFRF, 0, 0, 4, pbyData);
 

-    return TRUE;
+	return TRUE;
 }
 

@@ -756,18 +752,13 @@ BOOL IFRFbWriteEmbedded (PSDevice pDevice, DWORD dwData)
  * Return Value: TRUE if succeeded; FALSE if failed.
  *
  */
-BOOL RFbSetPower (
-      PSDevice  pDevice,
-      unsigned int      uRATE,
-      unsigned int      uCH
-    )
+int RFbSetPower(struct vnt_private *pDevice, u32 uRATE, u32 uCH)
 {
-BOOL    bResult = TRUE;
-BYTE    byPwr = pDevice->byCCKPwr;
+	int bResult = TRUE;
+	u8 byPwr = pDevice->byCCKPwr;
 
-    if (pDevice->dwDiagRefCount != 0) {
-        return TRUE;
-    }
+	if (pDevice->dwDiagRefCount)
+		return TRUE;
 
 	if (uCH == 0)
 		return -EINVAL;
@@ -813,13 +804,10 @@ BYTE    byPwr = pDevice->byCCKPwr;
  * Return Value: TRUE if succeeded; FALSE if failed.
  *
  */
-BOOL RFbRawSetPower (
-      PSDevice  pDevice,
-      BYTE      byPwr,
-      unsigned int      uRATE
-    )
+
+int RFbRawSetPower(struct vnt_private *pDevice, u8 byPwr, u32 uRATE)
 {
-BOOL        bResult = TRUE;
+	int bResult = TRUE;
 
     if (pDevice->byCurPwr == byPwr)
         return TRUE;
@@ -957,17 +945,12 @@ BOOL        bResult = TRUE;
  * Return Value: none
  *
 -*/
-void
-RFvRSSITodBm (
-      PSDevice pDevice,
-      BYTE     byCurrRSSI,
-    long *    pldBm
-    )
+void RFvRSSITodBm(struct vnt_private *pDevice, u8 byCurrRSSI, long *pldBm)
 {
-    BYTE byIdx = (((byCurrRSSI & 0xC0) >> 6) & 0x03);
-    signed long b = (byCurrRSSI & 0x3F);
-    signed long a = 0;
-    BYTE abyAIROHARF[4] = {0, 18, 0, 40};
+	u8 byIdx = (((byCurrRSSI & 0xC0) >> 6) & 0x03);
+	signed long b = (byCurrRSSI & 0x3F);
+	signed long a = 0;
+	u8 abyAIROHARF[4] = {0, 18, 0, 40};
 
     switch (pDevice->byRFType) {
         case RF_AL2230:
@@ -987,15 +970,12 @@ RFvRSSITodBm (
 


-void
-RFbRFTableDownload (
-      PSDevice pDevice
-    )
+void RFbRFTableDownload(struct vnt_private *pDevice)
 {
-WORD    wLength1 = 0,wLength2 = 0 ,wLength3 = 0;
-PBYTE   pbyAddr1 = NULL,pbyAddr2 = NULL,pbyAddr3 = NULL;
-WORD    wLength,wValue;
-BYTE    abyArray[256];
+	u16 wLength1 = 0, wLength2 = 0, wLength3 = 0;
+	u8 *pbyAddr1 = NULL, *pbyAddr2 = NULL, *pbyAddr3 = NULL;
+	u16 wLength, wValue;
+	u8 abyArray[256];
 
     switch ( pDevice->byRFType ) {
         case RF_AL2230:
@@ -1134,21 +1114,19 @@ BYTE    abyArray[256];
 
 }
 
-// RobertYu:20060412, TWIF1.11 adjust LO Current for 11b mode
-BOOL s_bVT3226D0_11bLoCurrentAdjust(
-      PSDevice    pDevice,
-      BYTE        byChannel,
-      BOOL        b11bMode)
+int s_bVT3226D0_11bLoCurrentAdjust(struct vnt_private *pDevice, u8 byChannel,
+	int b11bMode)
 {
-    BOOL    bResult;
+	int bResult = TRUE;
 
-    bResult = TRUE;
-    if( b11bMode )
-        bResult &= IFRFbWriteEmbedded(pDevice, dwVT3226D0LoCurrentTable[byChannel-1]);
-    else
-        bResult &= IFRFbWriteEmbedded(pDevice, 0x016BC600+(BY_VT3226_REG_LEN<<3)+IFREGCTL_REGW); //RobertYu:20060412
+	if (b11bMode)
+		bResult &= IFRFbWriteEmbedded(pDevice,
+			dwVT3226D0LoCurrentTable[byChannel-1]);
+	else
+		bResult &= IFRFbWriteEmbedded(pDevice, 0x016bc600 +
+			(BY_VT3226_REG_LEN << 3) + IFREGCTL_REGW);
 
-    return bResult;
+	return bResult;
 }
 

diff --git a/drivers/staging/vt6656/rf.h b/drivers/staging/vt6656/rf.h
index 72eb27a..9f70cf7 100644
--- a/drivers/staging/vt6656/rf.h
+++ b/drivers/staging/vt6656/rf.h
@@ -60,25 +60,15 @@
 /*---------------------  Export Classes  ----------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
-extern const BYTE RFaby11aChannelIndex[200];
+extern const u8 RFaby11aChannelIndex[200];
 /*---------------------  Export Functions  --------------------------*/
 
-BOOL IFRFbWriteEmbedded(PSDevice pDevice, DWORD dwData);
-BOOL RFbSetPower(PSDevice pDevice, unsigned int uRATE, unsigned int uCH);
-
-BOOL RFbRawSetPower(
-      PSDevice  pDevice,
-      BYTE      byPwr,
-      unsigned int      uRATE
-    );
-
-void RFvRSSITodBm(PSDevice pDevice, BYTE byCurrRSSI, long *pldBm);
-void RFbRFTableDownload(PSDevice pDevice);
-
-BOOL s_bVT3226D0_11bLoCurrentAdjust(
-      PSDevice    pDevice,
-      BYTE        byChannel,
-      BOOL        b11bMode
-    );
+int IFRFbWriteEmbedded(struct vnt_private *, u32 dwData);
+int RFbSetPower(struct vnt_private *, u32 uRATE, u32 uCH);
+int RFbRawSetPower(struct vnt_private *, u8 byPwr, u32 uRATE);
+void RFvRSSITodBm(struct vnt_private *, u8 byCurrRSSI, long *pldBm);
+void RFbRFTableDownload(struct vnt_private *pDevice);
+int s_bVT3226D0_11bLoCurrentAdjust(struct vnt_private *, u8 byChannel,
+	int b11bMode);
 
 #endif /* __RF_H__ */
-- 
1.8.0





Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61797 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2KXOgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2012 09:36:20 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so2786642wer.19
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2012 06:36:18 -0800 (PST)
Message-ID: <1353767772.2318.5.camel@user64-MCP7A> (sfid-20121124_153627_511078_DADA7BBD)
Subject: [PATCH 04/10] staging: vt6656: dead code removal : wpactl.c/h
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 24 Nov 2012 14:36:12 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Relates to redundant viawget, a proprietary version of wpa supplicant.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |    1 -
 drivers/staging/vt6656/main_usb.c |   14 +-
 drivers/staging/vt6656/wpactl.c   |  636 -------------------------------------
 drivers/staging/vt6656/wpactl.h   |    8 -
 4 files changed, 1 insertion(+), 658 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 9a04900..25bf03a 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -793,7 +793,6 @@ typedef struct __device_info {
     //WPA supplicant daemon
 	struct net_device       *wpadev;
 	BOOL                    bWPADEVUp;
-    struct sk_buff          *skb;
     //--
 
         BOOL                 bwextstep0;
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index c70bafb..5e55752 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1188,9 +1188,9 @@ static void vt6656_disconnect(struct usb_interface *intf)
 
 	if (device->dev) {
 		unregister_netdev(device->dev);
-		wpa_set_wpadev(device, 0);
 		free_netdev(device->dev);
 	}
+
 }
 
 static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev)
@@ -1579,18 +1579,6 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 		rc = vt6656_hostap_ioctl(pDevice, &wrq->u.data);
         break;
 
-    case IOCTL_CMD_WPA:
-
-		if (!(pDevice->flags & DEVICE_FLAGS_OPENED)) {
-		    rc = -EFAULT;
-		    break;
-		} else {
-		    rc = 0;
-		}
-
-		rc = wpa_ioctl(pDevice, &wrq->u.data);
-        break;
-
 	case SIOCETHTOOL:
         return ethtool_ioctl(dev, (void *) rq->ifr_data);
 
diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index 3e65aa1..4fe2e60 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -44,13 +44,6 @@
 
 /*---------------------  Static Definitions -------------------------*/
 
-#define VIAWGET_WPA_MAX_BUF_SIZE 1024
-
-static const int frequency_list[] = {
-	2412, 2417, 2422, 2427, 2432, 2437, 2442,
-	2447, 2452, 2457, 2462, 2467, 2472, 2484
-};
-
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
@@ -59,118 +52,7 @@ static int msglevel = MSG_LEVEL_INFO;
 /*---------------------  Static Functions  --------------------------*/
 
 /*---------------------  Export Variables  --------------------------*/
-static void wpadev_setup(struct net_device *dev)
-{
-	dev->type               = ARPHRD_IEEE80211;
-	dev->hard_header_len    = ETH_HLEN;
-	dev->mtu                = 2048;
-	dev->addr_len           = ETH_ALEN;
-	dev->tx_queue_len       = 1000;
-
-	memset(dev->broadcast, 0xFF, ETH_ALEN);
-
-	dev->flags              = IFF_BROADCAST | IFF_MULTICAST;
-}
-
-/*
- * Description:
- *      register netdev for wpa supplicant daemon
- *
- * Parameters:
- *  In:
- *      pDevice             -
- *      enable              -
- *  Out:
- *
- * Return Value:
- *
- */
-static int wpa_init_wpadev(PSDevice pDevice)
-{
-	PSDevice wpadev_priv;
-	struct net_device *dev = pDevice->dev;
-	int ret = 0;
-
-	pDevice->wpadev = alloc_netdev(sizeof(PSDevice), "vntwpa", wpadev_setup);
-	if (pDevice->wpadev == NULL)
-		return -ENOMEM;
-
-	wpadev_priv = netdev_priv(pDevice->wpadev);
-	*wpadev_priv = *pDevice;
-	memcpy(pDevice->wpadev->dev_addr, dev->dev_addr, ETH_ALEN);
-	pDevice->wpadev->base_addr = dev->base_addr;
-	pDevice->wpadev->irq = dev->irq;
-	pDevice->wpadev->mem_start = dev->mem_start;
-	pDevice->wpadev->mem_end = dev->mem_end;
-	ret = register_netdev(pDevice->wpadev);
-	if (ret) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: register_netdev(WPA) failed!\n",
-			dev->name);
-		free_netdev(pDevice->wpadev);
-		return -1;
-	}
-
-	if (pDevice->skb == NULL) {
-		pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-		if (pDevice->skb == NULL)
-			return -ENOMEM;
-	}
-
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Registered netdev %s for WPA management\n",
-		dev->name, pDevice->wpadev->name);
-
-	return 0;
-}
-
-/*
- * Description:
- *      unregister net_device (wpadev)
- *
- * Parameters:
- *  In:
- *      pDevice             -
- *  Out:
- *
- * Return Value:
- *
- */
-static int wpa_release_wpadev(PSDevice pDevice)
-{
-	if (pDevice->skb) {
-		dev_kfree_skb(pDevice->skb);
-		pDevice->skb = NULL;
-	}
-
-	if (pDevice->wpadev) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Netdevice %s unregistered\n",
-			pDevice->dev->name, pDevice->wpadev->name);
-		unregister_netdev(pDevice->wpadev);
-		free_netdev(pDevice->wpadev);
-		pDevice->wpadev = NULL;
-	}
-
-	return 0;
-}
 
-/*
- * Description:
- *      Set enable/disable dev for wpa supplicant daemon
- *
- * Parameters:
- *  In:
- *      pDevice             -
- *      val                 -
- *  Out:
- *
- * Return Value:
- *
- */
-int wpa_set_wpadev(PSDevice pDevice, int val)
-{
-	if (val)
-		return wpa_init_wpadev(pDevice);
-	return wpa_release_wpadev(pDevice);
-}
 
 /*
  * Description:
@@ -399,521 +281,3 @@ int wpa_set_wpadev(PSDevice pDevice, int val)
 }
 

-/*
- * Description:
- *      enable wpa auth & mode
- *
- * Parameters:
- *  In:
- *      pDevice   -
- *      param     -
- *  Out:
- *
- * Return Value:
- *
- */
-static int wpa_set_wpa(PSDevice pDevice, struct viawget_wpa_param *param)
-{
-	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
-	int ret = 0;
-
-	pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
-	pMgmt->bShareKeyAlgorithm = FALSE;
-
-	return ret;
-}
-
- /*
- * Description:
- *      set disassociate
- *
- * Parameters:
- *  In:
- *      pDevice   -
- *      param     -
- *  Out:
- *
- * Return Value:
- *
- */
-static int wpa_set_disassociate(PSDevice pDevice, struct viawget_wpa_param *param)
-{
-	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
-	int ret = 0;
-
-	spin_lock_irq(&pDevice->lock);
-	if (pDevice->bLinkPass) {
-		if (!memcmp(param->addr, pMgmt->abyCurrBSSID, 6))
-			bScheduleCommand((void *)pDevice, WLAN_CMD_DISASSOCIATE, NULL);
-	}
-	spin_unlock_irq(&pDevice->lock);
-
-	return ret;
-}
-
-/*
- * Description:
- *      enable scan process
- *
- * Parameters:
- *  In:
- *      pDevice   -
- *      param     -
- *  Out:
- *
- * Return Value:
- *
- */
-static int wpa_set_scan(PSDevice pDevice, struct viawget_wpa_param *param)
-{
-	int ret = 0;
-
-/**set ap_scan=1&&scan_ssid=1 under hidden ssid mode**/
-        PSMgmtObject pMgmt = &pDevice->sMgmtObj;
-        PWLAN_IE_SSID pItemSSID;
-	printk("wpa_set_scan-->desired [ssid=%s,ssid_len=%d]\n",
-		param->u.scan_req.ssid,param->u.scan_req.ssid_len);
-// Set the SSID
-	memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
-	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
-	pItemSSID->byElementID = WLAN_EID_SSID;
-	memcpy(pItemSSID->abySSID, param->u.scan_req.ssid, param->u.scan_req.ssid_len);
-	pItemSSID->len = param->u.scan_req.ssid_len;
-
-	spin_lock_irq(&pDevice->lock);
-	BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
-	bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN,
-			pMgmt->abyDesireSSID);
-	spin_unlock_irq(&pDevice->lock);
-
-	return ret;
-}
-
-/*
- * Description:
- *      get bssid
- *
- * Parameters:
- *  In:
- *      pDevice   -
- *      param     -
- *  Out:
- *
- * Return Value:
- *
- */
-static int wpa_get_bssid(PSDevice pDevice, struct viawget_wpa_param *param)
-{
-    PSMgmtObject pMgmt = &pDevice->sMgmtObj;
-    int ret = 0;
-    memcpy(param->u.wpa_associate.bssid, pMgmt->abyCurrBSSID, 6);
-
-    return ret;
-}
-
-/*
- * Description:
- *      get bssid
- *
- * Parameters:
- *  In:
- *      pDevice   -
- *      param     -
- *  Out:
- *
- * Return Value:
- *
- */
-static int wpa_get_ssid(PSDevice pDevice, struct viawget_wpa_param *param)
-{
-	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
-	PWLAN_IE_SSID pItemSSID;
-	int ret = 0;
-
-	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
-
-	memcpy(param->u.wpa_associate.ssid, pItemSSID->abySSID, pItemSSID->len);
-	param->u.wpa_associate.ssid_len = pItemSSID->len;
-
-	return ret;
-}
-
-/*
- * Description:
- *      get scan results
- *
- * Parameters:
- *  In:
- *      pDevice   -
- *      param     -
- *  Out:
- *
- * Return Value:
- *
- */
-static int wpa_get_scan(PSDevice pDevice, struct viawget_wpa_param *param)
-{
-	struct viawget_scan_result *scan_buf;
-	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
-	PWLAN_IE_SSID pItemSSID;
-	PKnownBSS pBSS;
-	PBYTE pBuf;
-	int ret = 0;
-	u16 count = 0;
-	u16 ii;
-	u16 jj;
-	long ldBm; //James //add
-
-//******mike:bubble sort by stronger RSSI*****//
-	PBYTE ptempBSS;
-
-	ptempBSS = kmalloc(sizeof(KnownBSS), GFP_ATOMIC);
-
-	if (ptempBSS == NULL) {
-		printk("bubble sort kmalloc memory fail@@@\n");
-		ret = -ENOMEM;
-		return ret;
-	}
-
-	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-		for (jj = 0; jj < MAX_BSS_NUM - ii - 1; jj++) {
-			if ((pMgmt->sBSSList[jj].bActive != TRUE)
-				|| ((pMgmt->sBSSList[jj].uRSSI > pMgmt->sBSSList[jj + 1].uRSSI)
-					&& (pMgmt->sBSSList[jj + 1].bActive != FALSE))) {
-				memcpy(ptempBSS,&pMgmt->sBSSList[jj], sizeof(KnownBSS));
-				memcpy(&pMgmt->sBSSList[jj], &pMgmt->sBSSList[jj + 1],
-					sizeof(KnownBSS));
-				memcpy(&pMgmt->sBSSList[jj + 1], ptempBSS, sizeof(KnownBSS));
-			}
-		}
-	}
-	kfree(ptempBSS);
-
-	count = 0;
-	pBSS = &(pMgmt->sBSSList[0]);
-	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-		pBSS = &(pMgmt->sBSSList[ii]);
-		if (!pBSS->bActive)
-			continue;
-		count++;
-	}
-
-	pBuf = kcalloc(count, sizeof(struct viawget_scan_result), GFP_ATOMIC);
-
-	if (pBuf == NULL) {
-		ret = -ENOMEM;
-		return ret;
-	}
-	scan_buf = (struct viawget_scan_result *)pBuf;
-	pBSS = &(pMgmt->sBSSList[0]);
-	for (ii = 0, jj = 0; ii < MAX_BSS_NUM; ii++) {
-		pBSS = &(pMgmt->sBSSList[ii]);
-		if (pBSS->bActive) {
-			if (jj >= count)
-				break;
-			memcpy(scan_buf->bssid, pBSS->abyBSSID, WLAN_BSSID_LEN);
-			pItemSSID = (PWLAN_IE_SSID)pBSS->abySSID;
-			memcpy(scan_buf->ssid, pItemSSID->abySSID, pItemSSID->len);
-			scan_buf->ssid_len = pItemSSID->len;
-			scan_buf->freq = frequency_list[pBSS->uChannel-1];
-			scan_buf->caps = pBSS->wCapInfo; // DavidWang for sharemode
-
-			RFvRSSITodBm(pDevice, (BYTE)(pBSS->uRSSI), &ldBm);
-			if (-ldBm < 50)
-				scan_buf->qual = 100;
-			else if (-ldBm > 90)
-				scan_buf->qual = 0;
-			else
-				scan_buf->qual=(40-(-ldBm-50))*100/40;
-
-			//James
-			//scan_buf->caps = pBSS->wCapInfo;
-			//scan_buf->qual =
-			scan_buf->noise = 0;
-			scan_buf->level = ldBm;
-
-			//scan_buf->maxrate =
-			if (pBSS->wWPALen != 0) {
-				scan_buf->wpa_ie_len = pBSS->wWPALen;
-				memcpy(scan_buf->wpa_ie, pBSS->byWPAIE, pBSS->wWPALen);
-			}
-			if (pBSS->wRSNLen != 0) {
-				scan_buf->rsn_ie_len = pBSS->wRSNLen;
-				memcpy(scan_buf->rsn_ie, pBSS->byRSNIE, pBSS->wRSNLen);
-			}
-			scan_buf = (struct viawget_scan_result *)((PBYTE)scan_buf + sizeof(struct viawget_scan_result));
-			jj ++;
-		}
-	}
-
-	if (jj < count)
-		count = jj;
-
-	if (copy_to_user(param->u.scan_results.buf, pBuf, sizeof(struct viawget_scan_result) * count))
-		ret = -EFAULT;
-
-	param->u.scan_results.scan_count = count;
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " param->u.scan_results.scan_count = %d\n", count);
-
-	kfree(pBuf);
-	return ret;
-}
-
-/*
- * Description:
- *      set associate with AP
- *
- * Parameters:
- *  In:
- *      pDevice   -
- *      param     -
- *  Out:
- *
- * Return Value:
- *
- */
-static int wpa_set_associate(PSDevice pDevice, struct viawget_wpa_param *param)
-{
-	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
-	PWLAN_IE_SSID pItemSSID;
-	BYTE abyNullAddr[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
-	BYTE abyWPAIE[64];
-	int ret = 0;
-	BOOL bwepEnabled=FALSE;
-
-	// set key type & algorithm
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pairwise_suite = %d\n", param->u.wpa_associate.pairwise_suite);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "group_suite = %d\n", param->u.wpa_associate.group_suite);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "key_mgmt_suite = %d\n", param->u.wpa_associate.key_mgmt_suite);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "auth_alg = %d\n", param->u.wpa_associate.auth_alg);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "mode = %d\n", param->u.wpa_associate.mode);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_ie_len = %d\n", param->u.wpa_associate.wpa_ie_len);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Roaming dBm = %d\n", param->u.wpa_associate.roam_dbm); // Davidwang
-
-	if (param->u.wpa_associate.wpa_ie) {
-		if (param->u.wpa_associate.wpa_ie_len > sizeof(abyWPAIE))
-			return -EINVAL;
-
-		if (copy_from_user(&abyWPAIE[0], param->u.wpa_associate.wpa_ie,
-					param->u.wpa_associate.wpa_ie_len))
-			return -EFAULT;
-	}
-
-	if (param->u.wpa_associate.mode == 1)
-		pMgmt->eConfigMode = WMAC_CONFIG_IBSS_STA;
-	else
-		pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
-
-	// set bssid
-	if (memcmp(param->u.wpa_associate.bssid, &abyNullAddr[0], 6) != 0)
-		memcpy(pMgmt->abyDesireBSSID, param->u.wpa_associate.bssid, 6);
-	// set ssid
-	memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
-	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
-	pItemSSID->byElementID = WLAN_EID_SSID;
-	pItemSSID->len = param->u.wpa_associate.ssid_len;
-	memcpy(pItemSSID->abySSID, param->u.wpa_associate.ssid, pItemSSID->len);
-
-	if (param->u.wpa_associate.wpa_ie_len == 0) {
-		if (param->u.wpa_associate.auth_alg & AUTH_ALG_SHARED_KEY)
-			pMgmt->eAuthenMode = WMAC_AUTH_SHAREKEY;
-		else
-			pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
-	} else if (abyWPAIE[0] == RSN_INFO_ELEM) {
-		if (param->u.wpa_associate.key_mgmt_suite == KEY_MGMT_PSK)
-			pMgmt->eAuthenMode = WMAC_AUTH_WPA2PSK;
-		else
-			pMgmt->eAuthenMode = WMAC_AUTH_WPA2;
-	} else {
-		if (param->u.wpa_associate.key_mgmt_suite == KEY_MGMT_WPA_NONE)
-			pMgmt->eAuthenMode = WMAC_AUTH_WPANONE;
-		else if (param->u.wpa_associate.key_mgmt_suite == KEY_MGMT_PSK)
-			pMgmt->eAuthenMode = WMAC_AUTH_WPAPSK;
-		else
-			pMgmt->eAuthenMode = WMAC_AUTH_WPA;
-	}
-
-	switch (param->u.wpa_associate.pairwise_suite) {
-	case CIPHER_CCMP:
-		pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
-		break;
-	case CIPHER_TKIP:
-		pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
-		break;
-	case CIPHER_WEP40:
-	case CIPHER_WEP104:
-		pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-		bwepEnabled = TRUE;
-		break;
-	case CIPHER_NONE:
-		if (param->u.wpa_associate.group_suite == CIPHER_CCMP)
-			pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
-		else
-			pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
-		break;
-	default:
-		pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
-	}
-
-	pMgmt->Roam_dbm = param->u.wpa_associate.roam_dbm;
-	if (pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY) { // @wep-sharekey
-		pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-		pMgmt->bShareKeyAlgorithm = TRUE;
-	} else if (pMgmt->eAuthenMode == WMAC_AUTH_OPEN) {
-		if(bwepEnabled==TRUE) { //@open-wep
-			pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-	   	} else {
-			// @only open
-			pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
-	   	}
-	}
-	// mike save old encryption status
-	pDevice->eOldEncryptionStatus = pDevice->eEncryptionStatus;
-
-	if (pDevice->eEncryptionStatus !=  Ndis802_11EncryptionDisabled)
-		pDevice->bEncryptionEnable = TRUE;
-	else
-		pDevice->bEncryptionEnable = FALSE;
-
-	if ((pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY) ||
-		((pMgmt->eAuthenMode == WMAC_AUTH_OPEN) && (bwepEnabled==TRUE)))  {
-		// mike re-comment:open-wep && sharekey-wep needn't do initial key!!
-	} else {
-		KeyvInitTable(pDevice,&pDevice->sKey);
-	}
-
-	spin_lock_irq(&pDevice->lock);
-	pDevice->bLinkPass = FALSE;
-	ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_SLOW);
-	memset(pMgmt->abyCurrBSSID, 0, 6);
-	pMgmt->eCurrState = WMAC_STATE_IDLE;
-	netif_stop_queue(pDevice->dev);
-
-/******* search if ap_scan=2, which is associating request in hidden ssid mode ****/
-	{
-		PKnownBSS pCurr = NULL;
-		pCurr = BSSpSearchBSSList(pDevice,
-					pMgmt->abyDesireBSSID,
-					pMgmt->abyDesireSSID,
-					pDevice->eConfigPHYMode
-			);
-
-		if (pCurr == NULL){
-			printk("wpa_set_associate---->hidden mode site survey before associate.......\n");
-			bScheduleCommand((void *)pDevice,
-					WLAN_CMD_BSSID_SCAN,
-					pMgmt->abyDesireSSID);
-		}
-	}
-/****************************************************************/
-
-	bScheduleCommand((void *)pDevice, WLAN_CMD_SSID, NULL);
-	spin_unlock_irq(&pDevice->lock);
-
-	return ret;
-}
-
-/*
- * Description:
- *      wpa_ioctl main function supported for wpa supplicant
- *
- * Parameters:
- *  In:
- *      pDevice   -
- *      iw_point  -
- *  Out:
- *
- * Return Value:
- *
- */
-int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
-{
-	struct viawget_wpa_param *param;
-	int ret = 0;
-	int wpa_ioctl = 0;
-
-	if (p->length < sizeof(struct viawget_wpa_param) ||
-		p->length > VIAWGET_WPA_MAX_BUF_SIZE || !p->pointer)
-		return -EINVAL;
-
-	param = kmalloc((int)p->length, GFP_KERNEL);
-	if (param == NULL)
-		return -ENOMEM;
-
-	if (copy_from_user(param, p->pointer, p->length)) {
-		ret = -EFAULT;
-		goto out;
-	}
-
-	switch (param->cmd) {
-	case VIAWGET_SET_WPA:
-		ret = wpa_set_wpa(pDevice, param);
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_WPA \n");
-		break;
-
-	case VIAWGET_SET_KEY:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_KEY \n");
-		spin_lock_irq(&pDevice->lock);
-		ret = wpa_set_keys(pDevice, param, FALSE);
-		spin_unlock_irq(&pDevice->lock);
-		break;
-
-	case VIAWGET_SET_SCAN:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_SCAN \n");
-		ret = wpa_set_scan(pDevice, param);
-		break;
-
-	case VIAWGET_GET_SCAN:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_SCAN\n");
-		ret = wpa_get_scan(pDevice, param);
-		wpa_ioctl = 1;
-		break;
-
-	case VIAWGET_GET_SSID:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_SSID \n");
-		ret = wpa_get_ssid(pDevice, param);
-		wpa_ioctl = 1;
-		break;
-
-	case VIAWGET_GET_BSSID:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_BSSID \n");
-		ret = wpa_get_bssid(pDevice, param);
-		wpa_ioctl = 1;
-		break;
-
-	case VIAWGET_SET_ASSOCIATE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_ASSOCIATE \n");
-		ret = wpa_set_associate(pDevice, param);
-		break;
-
-	case VIAWGET_SET_DISASSOCIATE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DISASSOCIATE \n");
-		ret = wpa_set_disassociate(pDevice, param);
-		break;
-
-	case VIAWGET_SET_DROP_UNENCRYPT:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DROP_UNENCRYPT \n");
-		break;
-
-	case VIAWGET_SET_DEAUTHENTICATE:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DEAUTHENTICATE \n");
-		break;
-
-	default:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_ioctl: unknown cmd=%d\n",
-			param->cmd);
-		kfree(param);
-		return -EOPNOTSUPP;
-	}
-
-	if ((ret == 0) && wpa_ioctl) {
-		if (copy_to_user(p->pointer, param, p->length)) {
-			ret = -EFAULT;
-			goto out;
-		}
-	}
-
-out:
-	kfree(param);
-	return ret;
-}
diff --git a/drivers/staging/vt6656/wpactl.h b/drivers/staging/vt6656/wpactl.h
index 19ab8b6..14dcf0b 100644
--- a/drivers/staging/vt6656/wpactl.h
+++ b/drivers/staging/vt6656/wpactl.h
@@ -38,17 +38,11 @@
 //WPA related
 
 typedef enum { WPA_ALG_NONE, WPA_ALG_WEP, WPA_ALG_TKIP, WPA_ALG_CCMP } wpa_alg;
-typedef enum { CIPHER_NONE, CIPHER_WEP40, CIPHER_TKIP, CIPHER_CCMP,
-	       CIPHER_WEP104 } wpa_cipher;
-typedef enum { KEY_MGMT_802_1X, KEY_MGMT_PSK, KEY_MGMT_NONE,
-	       KEY_MGMT_802_1X_NO_WPA, KEY_MGMT_WPA_NONE, KEY_MGMT_CCKM } wpa_key_mgmt;//20080717-02,<Modify> by James Li
 
 #define AUTH_ALG_OPEN_SYSTEM	0x01
 #define AUTH_ALG_SHARED_KEY	0x02
 #define AUTH_ALG_LEAP		0x04
 
-#define GENERIC_INFO_ELEM 0xdd
-#define RSN_INFO_ELEM 0x30
 
 typedef unsigned long long NDIS_802_11_KEY_RSC;
 
@@ -58,8 +52,6 @@ typedef unsigned long long NDIS_802_11_KEY_RSC;
 
 /*---------------------  Export Functions  --------------------------*/
 
-int wpa_set_wpadev(PSDevice pDevice, int val);
-int wpa_ioctl(PSDevice pDevice, struct iw_point *p);
 int wpa_set_keys(PSDevice pDevice, void *ctx, BOOL  fcpfkernel);
 
 #endif /* __WPACL_H__ */
-- 
1.7.10.4




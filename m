Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:59772 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaHJOsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 10:48:03 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so7482178wes.21
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 07:48:01 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/9] staging: vt6655: hostap/ioctl/iwctl use struct vnt_private
Date: Sun, 10 Aug 2014 15:47:00 +0100
Message-Id: <1407682023-2865-6-git-send-email-tvboxspy@gmail.com> (sfid-20140810_164917_084347_E52090BD)
In-Reply-To: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
References: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing PSDevice.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/hostap.c | 29 ++++++++++----------
 drivers/staging/vt6655/hostap.h |  4 +--
 drivers/staging/vt6655/ioctl.c  |  2 +-
 drivers/staging/vt6655/ioctl.h  |  2 +-
 drivers/staging/vt6655/iwctl.c  | 60 ++++++++++++++++++++---------------------
 5 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
index 29e8eb3..c10a1b5 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -68,9 +68,9 @@ static int msglevel = MSG_LEVEL_INFO;
  *
  */
 
-static int hostap_enable_hostapd(PSDevice pDevice, int rtnl_locked)
+static int hostap_enable_hostapd(struct vnt_private *pDevice, int rtnl_locked)
 {
-	PSDevice apdev_priv;
+	struct vnt_private *apdev_priv;
 	struct net_device *dev = pDevice->dev;
 	int ret;
 	const struct net_device_ops apdev_netdev_ops = {
@@ -130,7 +130,7 @@ static int hostap_enable_hostapd(PSDevice pDevice, int rtnl_locked)
  *
  */
 
-static int hostap_disable_hostapd(PSDevice pDevice, int rtnl_locked)
+static int hostap_disable_hostapd(struct vnt_private *pDevice, int rtnl_locked)
 {
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: disabling hostapd mode\n", pDevice->dev->name);
 
@@ -172,7 +172,8 @@ static int hostap_disable_hostapd(PSDevice pDevice, int rtnl_locked)
  *
  */
 
-int vt6655_hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked)
+int vt6655_hostap_set_hostapd(struct vnt_private *pDevice,
+			      int val, int rtnl_locked)
 {
 	if (val < 0 || val > 1)
 		return -EINVAL;
@@ -201,7 +202,7 @@ int vt6655_hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked)
  * Return Value:
  *
  */
-static int hostap_remove_sta(PSDevice pDevice,
+static int hostap_remove_sta(struct vnt_private *pDevice,
 			     struct viawget_hostapd_param *param)
 {
 	unsigned int uNodeIndex;
@@ -227,14 +228,14 @@ static int hostap_remove_sta(PSDevice pDevice,
  * Return Value:
  *
  */
-static int hostap_add_sta(PSDevice pDevice,
+static int hostap_add_sta(struct vnt_private *pDevice,
 			  struct viawget_hostapd_param *param)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	unsigned int uNodeIndex;
 
 	if (!BSSDBbIsSTAInNodeDB(pMgmt, param->sta_addr, &uNodeIndex))
-		BSSvCreateOneNode((PSDevice)pDevice, &uNodeIndex);
+		BSSvCreateOneNode(pDevice, &uNodeIndex);
 
 	memcpy(pMgmt->sNodeDBTable[uNodeIndex].abyMACAddr, param->sta_addr, WLAN_ADDR_LEN);
 	pMgmt->sNodeDBTable[uNodeIndex].eNodeState = NODE_ASSOC;
@@ -285,7 +286,7 @@ static int hostap_add_sta(PSDevice pDevice,
  *
  */
 
-static int hostap_get_info_sta(PSDevice pDevice,
+static int hostap_get_info_sta(struct vnt_private *pDevice,
 			       struct viawget_hostapd_param *param)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
@@ -314,7 +315,7 @@ static int hostap_get_info_sta(PSDevice pDevice,
  * Return Value:
  *
  */
-static int hostap_set_flags_sta(PSDevice pDevice,
+static int hostap_set_flags_sta(struct vnt_private *pDevice,
 				struct viawget_hostapd_param *param)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
@@ -345,7 +346,7 @@ static int hostap_set_flags_sta(PSDevice pDevice,
  * Return Value:
  *
  */
-static int hostap_set_generic_element(PSDevice pDevice,
+static int hostap_set_generic_element(struct vnt_private *pDevice,
 				      struct viawget_hostapd_param *param)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
@@ -389,7 +390,7 @@ static int hostap_set_generic_element(PSDevice pDevice,
  *
  */
 
-static void hostap_flush_sta(PSDevice pDevice)
+static void hostap_flush_sta(struct vnt_private *pDevice)
 {
 	// reserved node index =0 for multicast node.
 	BSSvClearNodeDBTable(pDevice, 1);
@@ -409,7 +410,7 @@ static void hostap_flush_sta(PSDevice pDevice)
  * Return Value:
  *
  */
-static int hostap_set_encryption(PSDevice pDevice,
+static int hostap_set_encryption(struct vnt_private *pDevice,
 				 struct viawget_hostapd_param *param,
 				 int param_len)
 {
@@ -635,7 +636,7 @@ static int hostap_set_encryption(PSDevice pDevice,
  * Return Value:
  *
  */
-static int hostap_get_encryption(PSDevice pDevice,
+static int hostap_get_encryption(struct vnt_private *pDevice,
 				 struct viawget_hostapd_param *param,
 				 int param_len)
 {
@@ -675,7 +676,7 @@ static int hostap_get_encryption(PSDevice pDevice,
  * Return Value:
  *
  */
-int vt6655_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
+int vt6655_hostap_ioctl(struct vnt_private *pDevice, struct iw_point *p)
 {
 	struct viawget_hostapd_param *param;
 	int ret = 0;
diff --git a/drivers/staging/vt6655/hostap.h b/drivers/staging/vt6655/hostap.h
index 6e801a4..17df4e4 100644
--- a/drivers/staging/vt6655/hostap.h
+++ b/drivers/staging/vt6655/hostap.h
@@ -52,7 +52,7 @@
 #define ARPHRD_IEEE80211 801
 #endif
 
-int vt6655_hostap_set_hostapd(PSDevice pDevice, int val, int rtnl_locked);
-int vt6655_hostap_ioctl(PSDevice pDevice, struct iw_point *p);
+int vt6655_hostap_set_hostapd(struct vnt_private *, int val, int rtnl_locked);
+int vt6655_hostap_ioctl(struct vnt_private *, struct iw_point *p);
 
 #endif // __HOSTAP_H__
diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index 65e5933..306a7db 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -44,7 +44,7 @@ static int msglevel = MSG_LEVEL_INFO;
 SWPAResult wpa_Result;
 #endif
 
-int private_ioctl(PSDevice pDevice, struct ifreq *rq)
+int private_ioctl(struct vnt_private *pDevice, struct ifreq *rq)
 {
 	PSCmdRequest	pReq = (PSCmdRequest)rq;
 	PSMgmtObject	pMgmt = pDevice->pMgmt;
diff --git a/drivers/staging/vt6655/ioctl.h b/drivers/staging/vt6655/ioctl.h
index 187fc91..2dc5a574 100644
--- a/drivers/staging/vt6655/ioctl.h
+++ b/drivers/staging/vt6655/ioctl.h
@@ -31,6 +31,6 @@
 
 #include "device.h"
 
-int private_ioctl(PSDevice pDevice, struct ifreq *rq);
+int private_ioctl(struct vnt_private *, struct ifreq *rq);
 
 #endif // __IOCTL_H__
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 7ce23b5..0c73064 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -76,7 +76,7 @@ static int msglevel = MSG_LEVEL_INFO;
 
 struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	long ldBm;
 
 	pDevice->wstats.status = pDevice->eOPMode;
@@ -134,7 +134,7 @@ static int iwctl_siwscan(struct net_device *dev,
 		  struct iw_point *wrq,
 		  char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	struct iw_scan_req  *req = (struct iw_scan_req *)extra;
 	unsigned char abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
@@ -198,7 +198,7 @@ static int iwctl_giwscan(struct net_device *dev,
 		  char *extra)
 {
 	int ii, jj, kk;
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	PKnownBSS           pBSS;
 	PWLAN_IE_SSID       pItemSSID;
@@ -350,7 +350,7 @@ int iwctl_siwfreq(struct net_device *dev,
 		  struct iw_freq *wrq,
 		  char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	int rc = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFREQ\n");
@@ -398,7 +398,7 @@ int iwctl_giwfreq(struct net_device *dev,
 		  struct iw_freq *wrq,
 		  char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFREQ\n");
@@ -429,7 +429,7 @@ int iwctl_siwmode(struct net_device *dev,
 		  __u32 *wmode,
 		  char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
 
@@ -495,7 +495,7 @@ int iwctl_giwmode(struct net_device *dev,
 		  __u32 *wmode,
 		  char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWMODE\n");
@@ -635,7 +635,7 @@ int iwctl_siwap(struct net_device *dev,
 		struct sockaddr *wrq,
 		char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
 	unsigned char ZeroBSSID[WLAN_BSSID_LEN] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
@@ -694,7 +694,7 @@ int iwctl_giwap(struct net_device *dev,
 		struct sockaddr *wrq,
 		char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAP\n");
@@ -728,7 +728,7 @@ int iwctl_giwaplist(struct net_device *dev,
 	struct iw_quality *q	= NULL;
 	PKnownBSS pBSS		= NULL;
 
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWAPLIST\n");
@@ -794,7 +794,7 @@ int iwctl_siwessid(struct net_device *dev,
 		   struct iw_point *wrq,
 		   char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	PWLAN_IE_SSID       pItemSSID;
 	//2008-0409-05, <Add> by Einsn Liu
@@ -903,7 +903,7 @@ int iwctl_giwessid(struct net_device *dev,
 		   struct iw_point *wrq,
 		   char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	PWLAN_IE_SSID       pItemSSID;
 
@@ -933,7 +933,7 @@ int iwctl_siwrate(struct net_device *dev,
 		  struct iw_param *wrq,
 		  char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	int rc = 0;
 	u8	brate = 0;
 	int	i;
@@ -1014,7 +1014,7 @@ int iwctl_giwrate(struct net_device *dev,
 		  struct iw_param *wrq,
 		  char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 //2007-0118-05,<Mark> by EinsnLiu
 //Mark the unnecessary sentences.
 //    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
@@ -1059,7 +1059,7 @@ int iwctl_siwrts(struct net_device *dev,
 		 struct iw_param *wrq,
 		 char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	int rc = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRTS\n");
@@ -1088,7 +1088,7 @@ int iwctl_giwrts(struct net_device *dev,
 		 struct iw_param *wrq,
 		 char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRTS\n");
 	wrq->value = pDevice->wRTSThreshold;
@@ -1107,7 +1107,7 @@ int iwctl_siwfrag(struct net_device *dev,
 		  struct iw_param *wrq,
 		  char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	int rc = 0;
 	int fthr = wrq->value;
 
@@ -1134,7 +1134,7 @@ int iwctl_giwfrag(struct net_device *dev,
 		  struct iw_param *wrq,
 		  char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFRAG\n");
 	wrq->value = pDevice->wFragmentationThreshold;
@@ -1152,7 +1152,7 @@ int iwctl_siwretry(struct net_device *dev,
 		   struct iw_param *wrq,
 		   char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	int rc = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRETRY\n");
@@ -1187,7 +1187,7 @@ int iwctl_giwretry(struct net_device *dev,
 		   struct iw_param *wrq,
 		   char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY\n");
 	wrq->disabled = 0;      // Can't be disabled
@@ -1217,7 +1217,7 @@ int iwctl_siwencode(struct net_device *dev,
 		    struct iw_point *wrq,
 		    char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	unsigned long dwKeyIndex = (unsigned long)(wrq->flags & IW_ENCODE_INDEX);
 	int ii, uu, rc = 0;
@@ -1348,7 +1348,7 @@ int iwctl_giwencode(struct net_device *dev,
 		    struct iw_point *wrq,
 		    char *extra)
 {
-	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject		pMgmt = &(pDevice->sMgmtObj);
 	char abyKey[WLAN_WEP232_KEYLEN];
 
@@ -1410,7 +1410,7 @@ int iwctl_siwpower(struct net_device *dev,
 		   struct iw_param *wrq,
 		   char *extra)
 {
-	PSDevice            pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	int rc = 0;
 
@@ -1460,7 +1460,7 @@ int iwctl_giwpower(struct net_device *dev,
 		   struct iw_param *wrq,
 		   char *extra)
 {
-	PSDevice            pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
 	int mode = pDevice->ePSMode;
 
@@ -1490,7 +1490,7 @@ int iwctl_giwsens(struct net_device *dev,
 		  struct iw_param *wrq,
 		  char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	long ldBm;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS\n");
@@ -1514,7 +1514,7 @@ int iwctl_siwauth(struct net_device *dev,
 		  struct iw_param *wrq,
 		  char *extra)
 {
-	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
 	int ret = 0;
 	static int wpa_version = 0;  //must be static to save the last value,einsn liu
@@ -1623,7 +1623,7 @@ int iwctl_siwgenie(struct net_device *dev,
 		   struct iw_point *wrq,
 		   char __user *extra)
 {
-	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
 	int ret = 0;
 	char length;
@@ -1663,7 +1663,7 @@ int iwctl_giwgenie(struct net_device *dev,
 		   struct iw_point *wrq,
 		   char __user *extra)
 {
-	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
 	int ret = 0;
 	int space = wrq->length;
@@ -1688,7 +1688,7 @@ int iwctl_siwencodeext(struct net_device *dev,
 		       struct iw_point *wrq,
 		       char *extra)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
 	struct viawget_wpa_param *param = NULL;
 //original member
@@ -1810,7 +1810,7 @@ int iwctl_siwmlme(struct net_device *dev,
 		  struct iw_point *wrq,
 		  char __user *extra)
 {
-	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
 	struct iw_mlme mime;
 
-- 
1.9.1


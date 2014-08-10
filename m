Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:56336 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHJOsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 10:48:04 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so7600831wes.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 07:48:03 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 7/9] staging: vt6655: rf/wpactl/wroute use struct vnt_private
Date: Sun, 10 Aug 2014 15:47:01 +0100
Message-Id: <1407682023-2865-7-git-send-email-tvboxspy@gmail.com> (sfid-20140810_164808_330958_0BEDB0E1)
In-Reply-To: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
References: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing PSDevice.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rf.c     |  8 ++++----
 drivers/staging/vt6655/rf.h     |  8 ++++----
 drivers/staging/vt6655/wpactl.c | 28 ++++++++++++++--------------
 drivers/staging/vt6655/wpactl.h |  6 +++---
 drivers/staging/vt6655/wroute.c |  2 +-
 drivers/staging/vt6655/wroute.h |  3 ++-
 6 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/vt6655/rf.c b/drivers/staging/vt6655/rf.c
index 42b257f..e505af9 100644
--- a/drivers/staging/vt6655/rf.c
+++ b/drivers/staging/vt6655/rf.c
@@ -746,7 +746,7 @@ static bool RFbAL2230SelectChannel(void __iomem *dwIoBase, unsigned char byChann
  *
  */
 bool RFbInit(
-	PSDevice  pDevice
+	struct vnt_private *pDevice
 )
 {
 	bool bResult = true;
@@ -897,7 +897,7 @@ bool RFvWriteWakeProgSyn(void __iomem *dwIoBase, unsigned char byRFType, unsigne
  *
  */
 bool RFbSetPower(
-	PSDevice  pDevice,
+	struct vnt_private *pDevice,
 	unsigned int uRATE,
 	unsigned int uCH
 )
@@ -978,7 +978,7 @@ bool RFbSetPower(
  */
 
 bool RFbRawSetPower(
-	PSDevice  pDevice,
+	struct vnt_private *pDevice,
 	unsigned char byPwr,
 	unsigned int uRATE
 )
@@ -1042,7 +1042,7 @@ bool RFbRawSetPower(
  -*/
 void
 RFvRSSITodBm(
-	PSDevice pDevice,
+	struct vnt_private *pDevice,
 	unsigned char byCurrRSSI,
 	long *pldBm
 	)
diff --git a/drivers/staging/vt6655/rf.h b/drivers/staging/vt6655/rf.h
index ba55561..be4ef88 100644
--- a/drivers/staging/vt6655/rf.h
+++ b/drivers/staging/vt6655/rf.h
@@ -77,19 +77,19 @@
 bool IFRFbWriteEmbedded(void __iomem *dwIoBase, unsigned long dwData);
 bool RFbSelectChannel(void __iomem *dwIoBase, unsigned char byRFType, unsigned char byChannel);
 bool RFbInit(
-	PSDevice  pDevice
+	struct vnt_private *
 );
 bool RFvWriteWakeProgSyn(void __iomem *dwIoBase, unsigned char byRFType, unsigned int uChannel);
-bool RFbSetPower(PSDevice pDevice, unsigned int uRATE, unsigned int uCH);
+bool RFbSetPower(struct vnt_private *, unsigned int uRATE, unsigned int uCH);
 bool RFbRawSetPower(
-	PSDevice  pDevice,
+	struct vnt_private *,
 	unsigned char byPwr,
 	unsigned int uRATE
 );
 
 void
 RFvRSSITodBm(
-	PSDevice pDevice,
+	struct vnt_private *,
 	unsigned char byCurrRSSI,
 	long    *pldBm
 );
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 6f29a69..c0c46a7 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -83,13 +83,13 @@ static void wpadev_setup(struct net_device *dev)
  *
  */
 
-static int wpa_init_wpadev(PSDevice pDevice)
+static int wpa_init_wpadev(struct vnt_private *pDevice)
 {
-	PSDevice wpadev_priv;
+	struct vnt_private *wpadev_priv;
 	struct net_device *dev = pDevice->dev;
 	int ret = 0;
 
-	pDevice->wpadev = alloc_netdev(sizeof(PSDevice), "vntwpa", wpadev_setup);
+	pDevice->wpadev = alloc_netdev(sizeof(*wpadev_priv), "vntwpa", wpadev_setup);
 	if (pDevice->wpadev == NULL)
 		return -ENOMEM;
 
@@ -133,7 +133,7 @@ static int wpa_init_wpadev(PSDevice pDevice)
  *
  */
 
-static int wpa_release_wpadev(PSDevice pDevice)
+static int wpa_release_wpadev(struct vnt_private *pDevice)
 {
 	if (pDevice->skb) {
 		dev_kfree_skb(pDevice->skb);
@@ -165,7 +165,7 @@ static int wpa_release_wpadev(PSDevice pDevice)
  *
  */
 
-int wpa_set_wpadev(PSDevice pDevice, int val)
+int wpa_set_wpadev(struct vnt_private *pDevice, int val)
 {
 	if (val)
 		return wpa_init_wpadev(pDevice);
@@ -187,7 +187,7 @@ int wpa_set_wpadev(PSDevice pDevice, int val)
  *
  */
 
-int wpa_set_keys(PSDevice pDevice, void *ctx,
+int wpa_set_keys(struct vnt_private *pDevice, void *ctx,
 		 bool fcpfkernel) __must_hold(&pDevice->lock)
 {
 	struct viawget_wpa_param *param = ctx;
@@ -407,7 +407,7 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
  *
  */
 
-static int wpa_set_wpa(PSDevice pDevice,
+static int wpa_set_wpa(struct vnt_private *pDevice,
 		       struct viawget_wpa_param *param)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
@@ -432,7 +432,7 @@ static int wpa_set_wpa(PSDevice pDevice,
  *
  */
 
-static int wpa_set_disassociate(PSDevice pDevice,
+static int wpa_set_disassociate(struct vnt_private *pDevice,
 				struct viawget_wpa_param *param)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
@@ -461,7 +461,7 @@ static int wpa_set_disassociate(PSDevice pDevice,
  *
  */
 
-static int wpa_set_scan(PSDevice pDevice,
+static int wpa_set_scan(struct vnt_private *pDevice,
 			struct viawget_wpa_param *param)
 {
 	spin_lock_irq(&pDevice->lock);
@@ -486,7 +486,7 @@ static int wpa_set_scan(PSDevice pDevice,
  *
  */
 
-static int wpa_get_bssid(PSDevice pDevice,
+static int wpa_get_bssid(struct vnt_private *pDevice,
 			 struct viawget_wpa_param *param)
 {
 	PSMgmtObject        pMgmt = pDevice->pMgmt;
@@ -510,7 +510,7 @@ static int wpa_get_bssid(PSDevice pDevice,
  *
  */
 
-static int wpa_get_ssid(PSDevice pDevice,
+static int wpa_get_ssid(struct vnt_private *pDevice,
 			struct viawget_wpa_param *param)
 {
 	PSMgmtObject        pMgmt = pDevice->pMgmt;
@@ -538,7 +538,7 @@ static int wpa_get_ssid(PSDevice pDevice,
  *
  */
 
-static int wpa_get_scan(PSDevice pDevice,
+static int wpa_get_scan(struct vnt_private *pDevice,
 			struct viawget_wpa_param *param)
 {
 	struct viawget_scan_result *scan_buf;
@@ -655,7 +655,7 @@ static int wpa_get_scan(PSDevice pDevice,
  *
  */
 
-static int wpa_set_associate(PSDevice pDevice,
+static int wpa_set_associate(struct vnt_private *pDevice,
 			     struct viawget_wpa_param *param)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
@@ -799,7 +799,7 @@ static int wpa_set_associate(PSDevice pDevice,
  *
  */
 
-int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
+int wpa_ioctl(struct vnt_private *pDevice, struct iw_point *p)
 {
 	struct viawget_wpa_param *param;
 	int ret = 0;
diff --git a/drivers/staging/vt6655/wpactl.h b/drivers/staging/vt6655/wpactl.h
index f7638ba..c1b4a72 100644
--- a/drivers/staging/vt6655/wpactl.h
+++ b/drivers/staging/vt6655/wpactl.h
@@ -57,8 +57,8 @@ enum wpa_key_mgmt { KEY_MGMT_802_1X, KEY_MGMT_CCKM, KEY_MGMT_PSK, KEY_MGMT_NONE,
 
 /*---------------------  Export Functions  --------------------------*/
 
-int wpa_set_wpadev(PSDevice pDevice, int val);
-int wpa_ioctl(PSDevice pDevice, struct iw_point *p);
-int wpa_set_keys(PSDevice pDevice, void *ctx, bool fcpfkernel);
+int wpa_set_wpadev(struct vnt_private *, int val);
+int wpa_ioctl(struct vnt_private *, struct iw_point *p);
+int wpa_set_keys(struct vnt_private *, void *ctx, bool fcpfkernel);
 
 #endif // __WPACL_H__
diff --git a/drivers/staging/vt6655/wroute.c b/drivers/staging/vt6655/wroute.c
index 4da3fef..44ce6e2 100644
--- a/drivers/staging/vt6655/wroute.c
+++ b/drivers/staging/vt6655/wroute.c
@@ -62,7 +62,7 @@ static int msglevel = MSG_LEVEL_INFO;
  * Return Value: true if packet duplicate; otherwise false
  *
  */
-bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData,
+bool ROUTEbRelay(struct vnt_private *pDevice, unsigned char *pbySkbData,
 		 unsigned int uDataLen, unsigned int uNodeIndex)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
diff --git a/drivers/staging/vt6655/wroute.h b/drivers/staging/vt6655/wroute.h
index 3abc1d3..e59eec9 100644
--- a/drivers/staging/vt6655/wroute.h
+++ b/drivers/staging/vt6655/wroute.h
@@ -39,6 +39,7 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
-bool ROUTEbRelay(PSDevice pDevice, unsigned char *pbySkbData, unsigned int uDataLen, unsigned int uNodeIndex);
+bool ROUTEbRelay(struct vnt_private *pDevice, unsigned char *pbySkbData,
+		 unsigned int uDataLen, unsigned int uNodeIndex);
 
 #endif /* __WROUTE_H__ */
-- 
1.9.1


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:46836 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZDYOdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 10:33:09 -0400
Date: Sat, 25 Apr 2009 10:32:35 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Greg KH <greg@kroah.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH 7/8] vt6655: Replace net_device->priv accesses with
	netdev_priv calls.
Message-ID: <20090425143235.GG11201@storm.local.network> (sfid-20090425_163313_820759_AE6721B8)
References: <20090425001405.GB23173@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RMedoP2+Pr6Rq0N2"
In-Reply-To: <20090425001405.GB23173@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--RMedoP2+Pr6Rq0N2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

vt6655: Replace net_device->priv accesses with netdev_priv calls.

Signed-off-by: Forest Bond <forest@alittletooquiet.net>
---
 drivers/staging/vt6655/device_main.c |   29 ++++++---------
 drivers/staging/vt6655/hostap.c      |    8 +++--
 drivers/staging/vt6655/iwctl.c       |   62 +++++++++++++++++-------------=
----
 drivers/staging/vt6655/wpactl.c      |    7 +++-
 4 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/=
device_main.c
index 126ecef..ca198a2 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -995,12 +995,14 @@ device_found1(struct pci_dev *pcid, const struct pci_=
device_id *ent)
         return -ENODEV;
     }
    =20
-   =20
+
 #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
-    dev =3D alloc_etherdev(0);
+    dev =3D alloc_etherdev(sizeof(DEVICE_INFO));
 #else
     dev =3D init_etherdev(dev, 0);
 #endif   =20
+
+    pDevice =3D (PSDevice) netdev_priv(dev);
    =20
     if (dev =3D=3D NULL) {
         printk(KERN_ERR DEVICE_NAME ": allocate net device failed \n");
@@ -1025,7 +1027,6 @@ device_found1(struct pci_dev *pcid, const struct pci_=
device_id *ent)
     pDevice->dev =3D dev;
     pDevice->next_module =3D root_device_dev;
     root_device_dev =3D dev;
-    dev->priv =3D pDevice;
     dev->irq =3D pcid->irq;
    =20
     if (pci_enable_device(pcid)) {
@@ -1226,11 +1227,6 @@ static BOOL device_init_info(struct pci_dev* pcid, P=
SDevice* ppDevice,
=20
     PSDevice p;
    =20
-    *ppDevice =3D kmalloc(sizeof(DEVICE_INFO),GFP_ATOMIC);
-   =20
-    if (*ppDevice =3D=3D NULL)
-        return FALSE;
-       =20
     memset(*ppDevice,0,sizeof(DEVICE_INFO));
    =20
     if (pDevice_Infos =3D=3D NULL) {
@@ -2059,7 +2055,7 @@ int __device_open(HANDLE pExDevice) {
 #else=20
=20
 static int  device_open(struct net_device *dev) {
-    PSDevice    pDevice=3D(PSDevice) dev->priv;   =20
+    PSDevice    pDevice=3D(PSDevice) netdev_priv(dev);   =20
     int i;
 #endif
     pDevice->rx_buf_sz =3D PKT_BUF_SZ;
@@ -2212,7 +2208,7 @@ int  __device_close(HANDLE pExDevice) {
=20
 #else=20
 static int  device_close(struct net_device *dev) {
-    PSDevice  pDevice=3D(PSDevice) dev->priv; =20
+    PSDevice  pDevice=3D(PSDevice) netdev_priv(dev); =20
 #endif           =20
     PSMgmtObject     pMgmt =3D pDevice->pMgmt;
  //PLICE_DEBUG->
@@ -2282,7 +2278,7 @@ int  __device_dma0_tx_80211(HANDLE pExDevice, struct =
sk_buff *skb) {
=20
=20
 static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *de=
v) {
-    PSDevice        pDevice=3Ddev->priv;
+    PSDevice        pDevice=3Dnetdev_priv(dev);
 #endif   =20
     PBYTE           pbMPDU;
     UINT            cbMPDULen =3D 0;
@@ -2494,7 +2490,7 @@ int  __device_xmit(HANDLE pExDevice, struct sk_buff *=
skb) {
    =20
 #else=20
 static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
-    PSDevice pDevice=3Ddev->priv;
+    PSDevice pDevice=3Dnetdev_priv(dev);
=20
 #endif
     PSMgmtObject    pMgmt =3D pDevice->pMgmt;
@@ -2950,7 +2946,7 @@ int __device_intr(int irq, HANDLE pExDevice, struct p=
t_regs *regs) {
 #else   =20
 static  irqreturn_t  device_intr(int irq,  void *dev_instance) {
     struct net_device* dev=3Ddev_instance;
-    PSDevice     pDevice=3D(PSDevice) dev->priv;
+    PSDevice     pDevice=3D(PSDevice) netdev_priv(dev);
 #endif
=20
     int             max_count=3D0;
@@ -3367,7 +3363,7 @@ void __device_set_multi(HANDLE pExDevice) {
 #else       =20
 =20
 static void device_set_multi(struct net_device *dev) {
-    PSDevice         pDevice =3D (PSDevice) dev->priv;
+    PSDevice         pDevice =3D (PSDevice) netdev_priv(dev);
 #endif                                                                    =
       =20
=20
     PSMgmtObject     pMgmt =3D pDevice->pMgmt;   =20
@@ -3441,7 +3437,7 @@ struct net_device_stats *__device_get_stats(HANDLE pE=
xDevice) {
=20
 #else
 static struct net_device_stats *device_get_stats(struct net_device *dev) {
-    PSDevice pDevice=3D(PSDevice) dev->priv; =20
+    PSDevice pDevice=3D(PSDevice) netdev_priv(dev); =20
 #endif   =20
=20
     return &pDevice->stats;
@@ -3458,7 +3454,7 @@ int __device_ioctl(HANDLE pExDevice, struct ifreq *rq=
, int cmd) {
 #else=20
=20
 static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd=
) {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
 #endif           =20
=20
 #ifdef WIRELESS_EXT   =20
@@ -4116,7 +4112,6 @@ int __device_hw_init(HANDLE pExDevice){
     PSDevice_info pDevice_info =3D (PSDevice_info)pExDevice;
     PSDevice    pDevice;
=20
-
     pDevice =3D (PSDevice)kmalloc(sizeof(DEVICE_INFO), (int)GFP_ATOMIC);
     if (pDevice =3D=3D NULL)=20
         return FALSE;
diff --git a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hosta=
p.c
index 7c47f5d..8c52625 100644
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -100,6 +100,7 @@ static int          msglevel                =3DMSG_LEVE=
L_INFO;
 =20
 static int hostap_enable_hostapd(PSDevice pDevice, int rtnl_locked)
 {
+    PSDevice apdev_priv;
 	struct net_device *dev =3D pDevice->dev;
 	int ret;
=20
@@ -124,12 +125,13 @@ static int hostap_enable_hostapd(PSDevice pDevice, in=
t rtnl_locked)
 	       dev->name, pDevice->apdev->name);=09
    =20
 #else
-	pDevice->apdev =3D (struct net_device *)kmalloc(sizeof(struct net_device)=
, GFP_KERNEL);
+    pDevice->apdev =3D (struct net_device *)kmalloc(sizeof(struct net_devi=
ce), GFP_KERNEL);
 	if (pDevice->apdev =3D=3D NULL)
 		return -ENOMEM;
 	memset(pDevice->apdev, 0, sizeof(struct net_device));
-=09
-	pDevice->apdev->priv =3D pDevice;
+
+    apdev_priv =3D netdev_priv(pDevice->apdev);
+    *apdev_priv =3D *pDevice;
 	memcpy(pDevice->apdev->dev_addr, dev->dev_addr, ETH_ALEN);
 	pDevice->apdev->hard_start_xmit =3D pDevice->tx_80211;
 	pDevice->apdev->type =3D ARPHRD_IEEE80211;
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 48e63f8..d8d72c6 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -113,7 +113,7 @@ static int          msglevel                =3DMSG_LEVE=
L_INFO;
=20
 struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 {
-	PSDevice pDevice =3D dev->priv;
+	PSDevice pDevice =3D netdev_priv(dev);
 	long ldBm;
 	pDevice->wstats.status =3D pDevice->eOPMode;
 	#ifdef Calcu_LinkQual
@@ -209,7 +209,7 @@ int iwctl_siwscan(struct net_device *dev,
 			 struct iw_point *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
 		struct iw_scan_req  *req =3D (struct iw_scan_req *)extra;
 		 PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
 	BYTE                abyScanSSID[WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1];
@@ -276,7 +276,7 @@ int iwctl_giwscan(struct net_device *dev,
              char *extra)
 {
     int ii, jj, kk;
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);    =20
     PKnownBSS           pBSS;
     PWLAN_IE_SSID       pItemSSID;
@@ -522,7 +522,7 @@ int iwctl_siwfreq(struct net_device *dev,
              struct iw_freq *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
 	int rc =3D 0;
 	   =20
     DEVICE_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWFREQ \n");=09
@@ -568,7 +568,7 @@ int iwctl_giwfreq(struct net_device *dev,
              struct iw_freq *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);   =20
    =20
     DEVICE_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFREQ \n");   =20
@@ -598,7 +598,7 @@ int iwctl_siwmode(struct net_device *dev,
              __u32 *wmode,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);=20
     int rc =3D 0;
    =20
@@ -665,7 +665,7 @@ int iwctl_giwmode(struct net_device *dev,
              __u32 *wmode,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);=20
=20
=20
@@ -819,7 +819,7 @@ int iwctl_siwap(struct net_device *dev,
 			 struct sockaddr *wrq,            =20
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;   =20
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);   =20
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj); =09
     int rc =3D 0;
         BYTE                 ZeroBSSID[WLAN_BSSID_LEN]=3D{0x00,0x00,0x00,0=
x00,0x00,0x00};
@@ -877,7 +877,7 @@ int iwctl_giwap(struct net_device *dev,
 			 struct sockaddr *wrq,                         =20
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;   =20
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);   =20
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj); =09
        =20
    =20
@@ -911,7 +911,7 @@ int iwctl_giwaplist(struct net_device *dev,
 	int ii,jj, rc =3D 0;
 	struct sockaddr sock[IW_MAX_AP];
 	struct iw_quality qual[IW_MAX_AP];   =20
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;   =20
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);   =20
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj); 	  =09
 =09
    =20
@@ -960,7 +960,7 @@ int iwctl_siwessid(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj); 	=09
     PWLAN_IE_SSID       pItemSSID;
   //2008-0409-05, <Add> by Einsn Liu
@@ -1089,7 +1089,7 @@ int iwctl_giwessid(struct net_device *dev,
              char *extra)
 {
=20
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj); =09
 	PWLAN_IE_SSID       pItemSSID;
 =09
@@ -1125,7 +1125,7 @@ int iwctl_siwrate(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     int rc =3D 0;   =20
 	u8	brate =3D 0;
 	int	i;
@@ -1210,7 +1210,7 @@ int iwctl_giwrate(struct net_device *dev,
              struct iw_param *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;   =20
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);   =20
 //2007-0118-05,<Mark> by EinsnLiu
 //Mark the unnecessary sentences.=20
 //    PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
@@ -1276,7 +1276,7 @@ int iwctl_siwrts(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
 	int rc =3D 0;
    =20
     DEVICE_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRTS \n");=09
@@ -1304,7 +1304,7 @@ int iwctl_giwrts(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-	PSDevice	        pDevice =3D (PSDevice)dev->priv;
+	PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
 	   =20
     DEVICE_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRTS \n");	=09
 	wrq->value =3D pDevice->wRTSThreshold;
@@ -1323,7 +1323,7 @@ int iwctl_siwfrag(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     int rc =3D 0;
     int fthr =3D wrq->value;   =20
    =20
@@ -1352,7 +1352,7 @@ int iwctl_giwfrag(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
    =20
     DEVICE_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWFRAG \n");
 	wrq->value =3D pDevice->wFragmentationThreshold;
@@ -1372,7 +1372,7 @@ int iwctl_siwretry(struct net_device *dev,
 			 struct iw_param *wrq,            =20
              char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     int rc =3D 0;   =20
    =20
        =20
@@ -1410,7 +1410,7 @@ int iwctl_giwretry(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;   =20
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);   =20
     DEVICE_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWRETRY \n");=09
 	wrq->disabled =3D 0;      // Can't be disabled=20
=20
@@ -1441,7 +1441,7 @@ int iwctl_siwencode(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;       =20
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);       =20
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);
 	DWORD dwKeyIndex =3D (DWORD)(wrq->flags & IW_ENCODE_INDEX);
 	int ii,uu, rc =3D 0;
@@ -1660,7 +1660,7 @@ int iwctl_giwencode(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);   =20
     int rc =3D 0;
     char abyKey[WLAN_WEP232_KEYLEN];
@@ -1729,7 +1729,7 @@ int iwctl_giwencode(struct net_device *dev,
 			struct iw_point *wrq,
 			char *extra)
 {
-	PSDevice			pDevice =3D (PSDevice)dev->priv;
+	PSDevice			pDevice =3D (PSDevice)netdev_priv(dev);
 	PSMgmtObject		pMgmt =3D &(pDevice->sMgmtObj);	=20
 	char abyKey[WLAN_WEP232_KEYLEN];
 =09
@@ -1790,7 +1790,7 @@ int iwctl_siwpower(struct net_device *dev,
 			 struct iw_param *wrq,
              char *extra)
 {
-    PSDevice            pDevice =3D (PSDevice)dev->priv;
+    PSDevice            pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);   =20
     int rc =3D 0;       =20
    =20
@@ -1840,7 +1840,7 @@ int iwctl_giwpower(struct net_device *dev,
 			 struct iw_param *wrq,            =20
              char *extra)
 {
-    PSDevice            pDevice =3D (PSDevice)dev->priv;
+    PSDevice            pDevice =3D (PSDevice)netdev_priv(dev);
     PSMgmtObject        pMgmt =3D &(pDevice->sMgmtObj);   =20
     int mode =3D pDevice->ePSMode;
=20
@@ -1872,7 +1872,7 @@ int iwctl_giwsens(struct net_device *dev,
 			 struct iw_param *wrq,
 			 char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);
     long ldBm;
    =20
     DEVICE_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWSENS \n");=09
@@ -1898,7 +1898,7 @@ int iwctl_siwauth(struct net_device *dev,
 			  struct iw_param *wrq,
 			  char *extra)
 {
-	PSDevice			pDevice =3D (PSDevice)dev->priv;
+	PSDevice			pDevice =3D (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt =3D &(pDevice->sMgmtObj);
 	int ret=3D0;
 	static int wpa_version=3D0;  //must be static to save the last value,eins=
n liu
@@ -2023,7 +2023,7 @@ int iwctl_siwgenie(struct net_device *dev,
 			  struct iw_point *wrq,
 			  char *extra)
 {
-	PSDevice			pDevice =3D (PSDevice)dev->priv;
+	PSDevice			pDevice =3D (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt =3D &(pDevice->sMgmtObj);
 	int ret=3D0;
=20
@@ -2056,7 +2056,7 @@ int iwctl_giwgenie(struct net_device *dev,
 			  struct iw_point *wrq,
 			  char *extra)
 {
-	PSDevice			pDevice =3D (PSDevice)dev->priv;
+	PSDevice			pDevice =3D (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt =3D &(pDevice->sMgmtObj);
 	int ret=3D0;
 	int space =3D wrq->length;
@@ -2081,7 +2081,7 @@ int iwctl_siwencodeext(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-    PSDevice	        pDevice =3D (PSDevice)dev->priv;       =20
+    PSDevice	        pDevice =3D (PSDevice)netdev_priv(dev);       =20
 	struct iw_encode_ext *ext =3D (struct iw_encode_ext*)extra;
     struct viawget_wpa_param *param=3DNULL;
 //original member
@@ -2232,7 +2232,7 @@ int iwctl_siwmlme(struct net_device *dev,
 				struct iw_point *wrq,
 				char *extra)
 {=09
-	PSDevice			pDevice =3D (PSDevice)dev->priv;
+	PSDevice			pDevice =3D (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt =3D &(pDevice->sMgmtObj);
 	struct iw_mlme *mlme =3D (struct iw_mlme *)extra;
 	//u16 reason =3D cpu_to_le16(mlme->reason_code);
diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpact=
l.c
index b4eadb8..a83f950 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -112,14 +112,17 @@ static void wpadev_setup(struct net_device *dev)
 =20
 static int wpa_init_wpadev(PSDevice pDevice)
 {
+    PSDevice wpadev_priv;
 	struct net_device *dev =3D pDevice->dev;
          int ret=3D0;
 		=20
-	pDevice->wpadev =3D alloc_netdev(0, "vntwpa", wpadev_setup);	=20
+	pDevice->wpadev =3D alloc_netdev(sizeof(PSDevice), "vntwpa", wpadev_setup=
);
 	if (pDevice->wpadev =3D=3D NULL)
 		return -ENOMEM;
=20
-	pDevice->wpadev->priv =3D pDevice;
+    wpadev_priv =3D netdev_priv(pDevice->wpadev);
+    *wpadev_priv =3D *pDevice;
+
 	memcpy(pDevice->wpadev->dev_addr, dev->dev_addr, U_ETHER_ADDR_LEN);
          pDevice->wpadev->base_addr =3D dev->base_addr;
 	pDevice->wpadev->irq =3D dev->irq;
--=20
1.5.4.3


--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--RMedoP2+Pr6Rq0N2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ8x8DRO4fQQdv5AwRAicvAJkBiZQBuVrFFFPAFY9HrleA3OpsswCfU4dq
u+VW3/NTvA1wOP42TxIZH34=
=w8Xt
-----END PGP SIGNATURE-----

--RMedoP2+Pr6Rq0N2--

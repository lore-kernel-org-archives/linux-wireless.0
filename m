Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:46864 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbZDYOdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Apr 2009 10:33:23 -0400
Date: Sat, 25 Apr 2009 10:32:46 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Greg KH <greg@kroah.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH 8/8] vt6655: Remove LINUX_VERSION_CODE preprocessor
	conditionals.
Message-ID: <20090425143246.GH11201@storm.local.network> (sfid-20090425_163328_019551_A82BF627)
References: <20090425001405.GB23173@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zq44+AAfm4giZpo5"
In-Reply-To: <20090425001405.GB23173@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--zq44+AAfm4giZpo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

vt6655: Remove LINUX_VERSION_CODE preprocessor conditionals.

Signed-off-by: Forest Bond <forest@alittletooquiet.net>
---
 drivers/staging/vt6655/bssdb.c       |    5 -
 drivers/staging/vt6655/device_main.c |   84 +-------------
 drivers/staging/vt6655/dpc.c         |   24 +----
 drivers/staging/vt6655/iwctl.c       |   78 ++-----------
 drivers/staging/vt6655/kcompat.h     |  218 ------------------------------=
----
 drivers/staging/vt6655/wmgr.c        |   16 +--
 6 files changed, 16 insertions(+), 409 deletions(-)

diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index 27b46d7..841e161 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -1335,12 +1335,7 @@ start:
              wpahdr->req_ie_len =3D 0;
              skb_put(pDevice->skb, sizeof(viawget_wpa_header));
              pDevice->skb->dev =3D pDevice->wpadev;
-//2008-4-3 modify by Chester for wpa=20
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,22) =20
              pDevice->skb->mac_header =3D pDevice->skb->data;
-#else
-            pDevice->skb->mac.raw =3D pDevice->skb->data;
-#endif
              pDevice->skb->pkt_type =3D PACKET_HOST;
              pDevice->skb->protocol =3D htons(ETH_P_802_2);
              memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/=
device_main.c
index ca198a2..68ce094 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -367,7 +367,6 @@ static void device_set_multi(struct net_device *dev);
 static int  device_close(struct net_device *dev);
 static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd=
);
=20
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,9)
 #ifdef CONFIG_PM
 static int device_notify_reboot(struct notifier_block *, unsigned long eve=
nt, void *ptr);
 static int viawget_suspend(struct pci_dev *pcid, u32 state);
@@ -378,7 +377,6 @@ struct notifier_block device_notifier =3D {
         priority:       0
 };
 #endif
-#endif=20
=20
 #endif // #ifndef PRIVATE_OBJ
=20
@@ -948,12 +946,7 @@ static BOOL device_release_WPADEV(PSDevice pDevice)
                  wpahdr->req_ie_len =3D 0;
                  skb_put(pDevice->skb, sizeof(viawget_wpa_header));
                  pDevice->skb->dev =3D pDevice->wpadev;
-//2008-4-3 modify by Chester for wpa=20
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,22)=20
                  pDevice->skb->mac_header =3D pDevice->skb->data;
-#else
-                 pDevice->skb->mac.raw =3D pDevice->skb->data;
-#endif
                  pDevice->skb->pkt_type =3D PACKET_HOST;
                  pDevice->skb->protocol =3D htons(ETH_P_802_2);
                  memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
@@ -984,23 +977,14 @@ device_found1(struct pci_dev *pcid, const struct pci_=
device_id *ent)
     struct net_device*  dev =3D NULL;
     PCHIP_INFO  pChip_info =3D (PCHIP_INFO)ent->driver_data;
     PSDevice    pDevice;
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)   =20
     int         rc;
-#endif   =20
-//#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,23)
- //  BYTE            fake_mac[U_ETHER_ADDR_LEN] =3D {0x00, 0x00, 0x00, 0x0=
0, 0x00, 0x01};//fake MAC address
-//#endif
     if (device_nics ++>=3D MAX_UINTS) {
         printk(KERN_NOTICE DEVICE_NAME ": already found %d NICs\n", device=
_nics);
         return -ENODEV;
     }
    =20
=20
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
     dev =3D alloc_etherdev(sizeof(DEVICE_INFO));
-#else
-    dev =3D init_etherdev(dev, 0);
-#endif   =20
=20
     pDevice =3D (PSDevice) netdev_priv(dev);
    =20
@@ -1009,11 +993,9 @@ device_found1(struct pci_dev *pcid, const struct pci_=
device_id *ent)
         return -ENODEV;
     }
    =20
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
     // Chain it all together=20
    // SET_MODULE_OWNER(dev);
     SET_NETDEV_DEV(dev, &pcid->dev);
-#endif       =20
    =20
     if (bFirst) {
         printk(KERN_NOTICE "%s Ver. %s\n",DEVICE_FULL_DRV_NAM, DEVICE_VERS=
ION);
@@ -1106,21 +1088,12 @@ device_found1(struct pci_dev *pcid, const struct pc=
i_device_id *ent)
=20
=20
=20
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
     rc =3D pci_request_regions(pcid, DEVICE_NAME);
     if (rc) {
         printk(KERN_ERR DEVICE_NAME ": Failed to find PCI device\n");
         device_free_info(pDevice);
         return -ENODEV;       =20
     }
-#else
-    if (check_region(pDevice->ioaddr, pDevice->io_size)) {
-        printk(KERN_ERR DEVICE_NAME ": Failed to find PCI device\n");
-        device_free_info(pDevice);
-        return -ENODEV;               =20
-    }
-    request_region(pDevice->ioaddr, pDevice->io_size, DEVICE_NAME);   =20
-#endif
    =20
     dev->base_addr =3D pDevice->ioaddr;
 #ifdef	PLICE_DEBUG
@@ -1177,10 +1150,6 @@ device_found1(struct pci_dev *pcid, const struct pci=
_device_id *ent)
 #endif /* WIRELESS_EXT > 12 */
 #endif /* WIRELESS_EXT */       =20
=20
- //  #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,23)
-  //  memcpy(pDevice->dev->dev_addr, fake_mac, U_ETHER_ADDR_LEN); //use fa=
ke mac address
- //  #endif
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
     rc =3D register_netdev(dev);
     if (rc)
     {
@@ -1188,7 +1157,6 @@ device_found1(struct pci_dev *pcid, const struct pci_=
device_id *ent)
         device_free_info(pDevice);
         return -ENODEV;         =20
     }
-#endif   =20
 //2008-07-21-01<Add>by MikeLiu
 //register wpadev
    if(wpa_set_wpadev(pDevice, 1)!=3D0) {
@@ -1355,17 +1323,10 @@ device_release_WPADEV(pDevice);
     if (pDevice->PortOffset)
         iounmap((PVOID)pDevice->PortOffset);
=20
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
     if (pDevice->pcid)  =20
         pci_release_regions(pDevice->pcid);
     if (dev)               =20
         free_netdev(dev);
-#else
-    if (pDevice->ioaddr)
-        release_region(pDevice->ioaddr,pDevice->io_size);
-    if (dev)       =20
-        kfree(dev);
-#endif
=20
     if (pDevice->pcid) {
         pci_set_drvdata(pDevice->pcid,NULL);
@@ -1880,11 +1841,7 @@ static int device_tx_srv(PSDevice pDevice, UINT uIdx=
) {
 #else
                     skb =3D pTD->pTDInfo->skb;
 	                skb->dev =3D pDevice->apdev;
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,22)
-			skb->mac_header =3D skb->data;
-#else
-			skb->mac.raw =3D skb->data;
-#endif
+			        skb->mac_header =3D skb->data;
 	                skb->pkt_type =3D PACKET_OTHERHOST;
     	            //skb->protocol =3D htons(ETH_P_802_2);
 	                memset(skb->cb, 0, sizeof(skb->cb));
@@ -2064,11 +2021,7 @@ static int  device_open(struct net_device *dev) {
     }
 //2008-5-13 <add> by chester
 #ifndef PRIVATE_OBJ
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,16)
     i=3Drequest_irq(pDevice->pcid->irq, &device_intr, IRQF_SHARED, dev->na=
me, dev);
-#else
-    i=3Drequest_irq(pDevice->pcid->irq, &device_intr, (unsigned long)SA_SH=
IRQ, dev->name, dev);
-#endif
     if (i)
         return i;
 #endif
@@ -2188,12 +2141,6 @@ DEVICE_PRT(MSG_LEVEL_DEBUG, KERN_INFO "call MACvIntE=
nable\n");
     }=20
     pDevice->flags |=3DDEVICE_FLAGS_OPENED;      =20
    =20
-#ifndef PRIVATE_OBJ   =20
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-    MOD_INC_USE_COUNT;
-#endif   =20
-#endif
-
     DEVICE_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_open success.. \n");
     return 0;
 }
@@ -2258,11 +2205,6 @@ device_release_WPADEV(pDevice);
 //PLICE_DEBUG->
 	//tasklet_kill(&pDevice->RxMngWorkItem);
 //PLICE_DEBUG<-
-#ifndef PRIVATE_OBJ   =20
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-    MOD_DEC_USE_COUNT;
-#endif
-#endif   =20
     DEVICE_PRT(MSG_LEVEL_DEBUG, KERN_INFO "device_close.. \n");
     return 0;
 }
@@ -3948,12 +3890,10 @@ static struct pci_driver device_driver =3D {
         id_table:   device_id_table,
         probe:      device_found1,
         remove:     device_remove1,
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,9)
 #ifdef CONFIG_PM
         suspend:    viawget_suspend,
         resume:     viawget_resume,
 #endif
-#endif
 };=20
=20
 static int __init device_init_module(void)
@@ -3963,17 +3903,11 @@ static int __init device_init_module(void)
=20
 //    ret=3Dpci_module_init(&device_driver);
 	//ret =3D pcie_port_service_register(&device_driver);
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,22)
 	ret =3D pci_register_driver(&device_driver);
-#else
-	ret =3D pci_module_init(&device_driver);
-#endif
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,9)
 #ifdef CONFIG_PM   =20
     if(ret >=3D 0)
         register_reboot_notifier(&device_notifier);
 #endif =20
-#endif
=20
     return ret;
 }
@@ -3982,11 +3916,9 @@ static void __exit device_cleanup_module(void)
 {
=20
 	   =20
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,9)
 #ifdef CONFIG_PM   =20
     unregister_reboot_notifier(&device_notifier);
 #endif =20
-#endif
     pci_unregister_driver(&device_driver);
    =20
 }
@@ -3995,7 +3927,6 @@ module_init(device_init_module);
 module_exit(device_cleanup_module);
=20
=20
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,4,9)
 #ifdef CONFIG_PM
 static int
 device_notify_reboot(struct notifier_block *nb, unsigned long event, void =
*p)
@@ -4005,11 +3936,7 @@ device_notify_reboot(struct notifier_block *nb, unsi=
gned long event, void *p)
     case SYS_DOWN:
     case SYS_HALT:
     case SYS_POWER_OFF:
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,0)
         while ((pdev =3D pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pdev)) !=
=3D NULL) {
-#else
-        pci_for_each_dev(pdev) {
-#endif   =20
             if(pci_dev_driver(pdev) =3D=3D &device_driver) {
                 if (pci_get_drvdata(pdev))
                     viawget_suspend(pdev, 3);
@@ -4029,11 +3956,7 @@ viawget_suspend(struct pci_dev *pcid, u32 state)
    =20
     netif_stop_queue(pDevice->dev);  =20
     spin_lock_irq(&pDevice->lock);
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,10)   =20
     pci_save_state(pcid);
-#else
-    pci_save_state(pcid, pDevice->pci_state);   =20
-#endif   =20
     del_timer(&pDevice->sTimerCommand);   =20
     del_timer(&pMgmt->sTimerSecondCallback);
     pDevice->cbFreeCmdQueue =3D CMD_Q_SIZE;
@@ -4061,11 +3984,7 @@ viawget_resume(struct pci_dev *pcid)
    =20
     power_status =3D pci_set_power_state(pcid, 0);
     power_status =3D pci_enable_wake(pcid, 0, 0);
-#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,10)       =20
     pci_restore_state(pcid); =20
-#else   =20
-    pci_restore_state(pcid, pDevice->pci_state);     =20
-#endif   =20
     if (netif_running(pDevice->dev)) {
         spin_lock_irq(&pDevice->lock);
         MACvRestoreContext(pDevice->PortOffset, pDevice->abyMacContext);
@@ -4094,7 +4013,6 @@ viawget_resume(struct pci_dev *pcid)
 }
=20
 #endif
-#endif
=20
 #endif //#ifndef PRIVATE_OBJ
=20
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index f8424bd..75496a7 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -709,11 +709,7 @@ device_receive_frame (
                 ref_skb_add_offset(skb->skb, 4);
                 ref_skb_set_dev(pDevice->apdev, skb->skb);
                 skb_put(skb->skb, FrameSize);
-#if	LINUX_VERSION_CODE	> KERNEL_VERSION(2,6,21)
 	            skb->mac_header =3D skb->data;
-#else
-			skb->mac.raw =3D skb->data;
-#endif
 	            *(skb->pkt_type) =3D PACKET_OTHERHOST;
     	        *(skb->protocol) =3D htons(ETH_P_802_2);
 	            memset(skb->cb, 0, sizeof(skb->cb));
@@ -722,11 +718,7 @@ device_receive_frame (
 	            skb->data +=3D 4;
 	            skb->tail +=3D 4;
                      skb_put(skb, FrameSize);
-#if	LINUX_VERSION_CODE > KERNEL_VERSION (2,6,21)
 	            skb->mac_header =3D skb->data;
-#else
-		skb->mac.raw =3D skb->data;
-#endif
 	            skb->pkt_type =3D PACKET_OTHERHOST;
     	        skb->protocol =3D htons(ETH_P_802_2);
 	            memset(skb->cb, 0, sizeof(skb->cb));
@@ -858,11 +850,7 @@ device_receive_frame (
             ref_skb_add_offset(skb->skb, (cbIVOffset + 4));
             ref_skb_set_dev(pDevice->apdev, skb->skb);
             skb_put(skb->skb, FrameSize);
-#if	LINUX_VERSION_CODE	> KERNEL_VERSION(2,6,21)
 			skb->mac_header =3D skb->data;
-#else
-			skb->mac.raw =3D skb->data;
-#endif
             *(skb->pkt_type) =3D PACKET_OTHERHOST;
 	        *(skb->protocol) =3D htons(ETH_P_802_2);
             memset(skb->cb, 0, sizeof(skb->cb));
@@ -871,11 +859,7 @@ device_receive_frame (
             skb->data +=3D  (cbIVOffset + 4);
             skb->tail +=3D  (cbIVOffset + 4);
             skb_put(skb, FrameSize);
-#if	LINUX_VERSION_CODE	> KERNEL_VERSION(2,6,21)
            skb->mac_header =3D skb->data;
-#else
-	skb->mac.raw =3D skb->data;
-#endif
=20
 	skb->pkt_type =3D PACKET_OTHERHOST;
             skb->protocol =3D htons(ETH_P_802_2);
@@ -998,12 +982,8 @@ device_receive_frame (
                      wpahdr->req_ie_len =3D 0;
                      skb_put(pDevice->skb, sizeof(viawget_wpa_header));
                      pDevice->skb->dev =3D pDevice->wpadev;
-#if	LINUX_VERSION_CODE	> KERNEL_VERSION(2,6,21)
-		pDevice->skb->mac_header =3D pDevice->skb->data;
-#else
-		pDevice->skb->mac.raw=3DpDevice->skb->data;
-#endif
-			pDevice->skb->pkt_type =3D PACKET_HOST;
+                     pDevice->skb->mac_header =3D pDevice->skb->data;
+                     pDevice->skb->pkt_type =3D PACKET_HOST;
                      pDevice->skb->protocol =3D htons(ETH_P_802_2);
                      memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
                      netif_rx(pDevice->skb);
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index d8d72c6..c538fa5 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -307,22 +307,14 @@ int iwctl_giwscan(struct net_device *dev,
 		    iwe.cmd =3D SIOCGIWAP;
 		    iwe.u.ap_addr.sa_family =3D ARPHRD_ETHER;
 			memcpy(iwe.u.ap_addr.sa_data, pBSS->abyBSSID, WLAN_BSSID_LEN);
-			#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27)   //mike add
-                           current_ev =3D iwe_stream_add_event(info,curren=
t_ev,end_buf, &iwe, IW_EV_ADDR_LEN);
-			#else
-			current_ev =3D iwe_stream_add_event(current_ev,end_buf, &iwe, IW_EV_ADD=
R_LEN);
-			 #endif
+            current_ev =3D iwe_stream_add_event(info,current_ev,end_buf, &=
iwe, IW_EV_ADDR_LEN);
                  //ADD ssid
 	             memset(&iwe, 0, sizeof(iwe));
                       iwe.cmd =3D SIOCGIWESSID;
                       pItemSSID =3D (PWLAN_IE_SSID)pBSS->abySSID;
                        iwe.u.data.length =3D pItemSSID->len;
                        iwe.u.data.flags =3D 1;
-		 #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27)   //mike add
-                      current_ev =3D iwe_stream_add_point(info,current_ev,=
end_buf, &iwe, pItemSSID->abySSID);
-		  #else			  =20
-       		    current_ev =3D iwe_stream_add_point(current_ev,end_buf, &iwe,=
 pItemSSID->abySSID);
-		   #endif
+            current_ev =3D iwe_stream_add_point(info,current_ev,end_buf, &=
iwe, pItemSSID->abySSID);
 		//ADD mode=09
 		    memset(&iwe, 0, sizeof(iwe));
 		    iwe.cmd =3D SIOCGIWMODE;
@@ -333,11 +325,7 @@ int iwctl_giwscan(struct net_device *dev,
                 iwe.u.mode =3D IW_MODE_ADHOC;
 		    }		   =20
 	        iwe.len =3D IW_EV_UINT_LEN;
-		 #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27)   //mike add
-                      current_ev =3D iwe_stream_add_event(info,current_ev,=
 end_buf, &iwe,  IW_EV_UINT_LEN);
-		 #else
-		    current_ev =3D iwe_stream_add_event(current_ev, end_buf, &iwe,  IW_E=
V_UINT_LEN);
-		  #endif
+            current_ev =3D iwe_stream_add_event(info,current_ev, end_buf, =
&iwe,  IW_EV_UINT_LEN);
            //ADD frequency=20
             pSuppRates =3D (PWLAN_IE_SUPP_RATES)pBSS->abySuppRates;
             pExtSuppRates =3D (PWLAN_IE_SUPP_RATES)pBSS->abyExtSuppRates;
@@ -346,11 +334,7 @@ int iwctl_giwscan(struct net_device *dev,
            	iwe.u.freq.m =3D pBSS->uChannel;
            	iwe.u.freq.e =3D 0;
            	iwe.u.freq.i =3D 0;
-	 #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27)   //mike add
-                  current_ev =3D iwe_stream_add_event(info,current_ev,end_=
buf, &iwe, IW_EV_FREQ_LEN);
-	     #else	=09
-           	current_ev =3D iwe_stream_add_event(current_ev,end_buf, &iwe, =
IW_EV_FREQ_LEN);
-		  #endif
+            current_ev =3D iwe_stream_add_event(info,current_ev,end_buf, &=
iwe, IW_EV_FREQ_LEN);
=20
=20
             //2008-0409-04, <Add> by Einsn Liu
@@ -360,11 +344,7 @@ int iwctl_giwscan(struct net_device *dev,
 			iwe.u.freq.m =3D frequency_list[f] * 100000;
 			iwe.u.freq.e =3D 1;
 			}
-	#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27)   //mike add
-                  current_ev =3D iwe_stream_add_event(info,current_ev,end_=
buf, &iwe, IW_EV_FREQ_LEN);
-	#else
-           	current_ev =3D iwe_stream_add_event(current_ev,end_buf, &iwe, =
IW_EV_FREQ_LEN);
-	 #endif
+            current_ev =3D iwe_stream_add_event(info,current_ev,end_buf, &=
iwe, IW_EV_FREQ_LEN);
        		//ADD quality
             memset(&iwe, 0, sizeof(iwe));       	=09
 	        iwe.cmd =3D IWEVQUAL;
@@ -382,11 +362,7 @@ int iwctl_giwscan(struct net_device *dev,
 			iwe.u.qual.updated=3D7;
 		=09
 	      //  iwe.u.qual.qual =3D 0;
-	   #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27)   //mike add
-                 current_ev =3D iwe_stream_add_event(info,current_ev, end_=
buf, &iwe, IW_EV_QUAL_LEN);
-	   #else
-	        current_ev =3D iwe_stream_add_event(current_ev, end_buf, &iwe, IW=
_EV_QUAL_LEN);
-	    #endif
+            current_ev =3D iwe_stream_add_event(info,current_ev, end_buf, =
&iwe, IW_EV_QUAL_LEN);
        	=09
             memset(&iwe, 0, sizeof(iwe));
             iwe.cmd =3D SIOCGIWENCODE;
@@ -396,11 +372,7 @@ int iwctl_giwscan(struct net_device *dev,
             }else {
                 iwe.u.data.flags =3D IW_ENCODE_DISABLED;
             }
-	#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27)   //mike add
             current_ev =3D iwe_stream_add_point(info,current_ev,end_buf, &=
iwe, pItemSSID->abySSID);
-	#else	=09
-            current_ev =3D iwe_stream_add_point(current_ev,end_buf, &iwe, =
pItemSSID->abySSID);
-	 #endif
            =20
             memset(&iwe, 0, sizeof(iwe));
             iwe.cmd =3D SIOCGIWRATE;
@@ -412,22 +384,14 @@ int iwctl_giwscan(struct net_device *dev,
 			        break;
 		        // Bit rate given in 500 kb/s units (+ 0x80)=20
 		        iwe.u.bitrate.value =3D ((pSuppRates->abyRates[kk] & 0x7f) * 500=
000);
-		#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27)   //mike add
-                          current_val =3D iwe_stream_add_value(info,curren=
t_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
-		     #else=09
-		        current_val =3D iwe_stream_add_value(current_ev, current_val, en=
d_buf, &iwe, IW_EV_PARAM_LEN);
-                        #endif
+                current_val =3D iwe_stream_add_value(info,current_ev, curr=
ent_val, end_buf, &iwe, IW_EV_PARAM_LEN);
 			}
        		for (kk =3D 0 ; kk < 8 ; kk++) {
 		        if (pExtSuppRates->abyRates[kk] =3D=3D 0)
 			        break;
 		        // Bit rate given in 500 kb/s units (+ 0x80)=20
 		        iwe.u.bitrate.value =3D ((pExtSuppRates->abyRates[kk] & 0x7f) * =
500000);
-		#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27)   //mike add
-                         current_val =3D iwe_stream_add_value(info,current=
_ev, current_val, end_buf, &iwe, IW_EV_PARAM_LEN);
-		    #else	=09
-		        current_val =3D iwe_stream_add_value(current_ev, current_val, en=
d_buf, &iwe, IW_EV_PARAM_LEN);
-		 #endif=09
+                current_val =3D iwe_stream_add_value(info,current_ev, curr=
ent_val, end_buf, &iwe, IW_EV_PARAM_LEN);
 	        }
 	        	       =20
 	        if((current_val - current_ev) > IW_EV_LCP_LEN)
@@ -438,33 +402,21 @@ int iwctl_giwscan(struct net_device *dev,
             iwe.cmd =3D IWEVCUSTOM;
             sprintf(buf, "bcn_int=3D%d", pBSS->wBeaconInterval);
             iwe.u.data.length =3D strlen(buf);
-	     #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27)   //mike add
-             current_ev =3D iwe_stream_add_point(info,current_ev, end_buf,=
 &iwe, buf);
-           #else	=09
-            current_ev =3D iwe_stream_add_point(current_ev, end_buf, &iwe,=
 buf);
-	 #endif
+            current_ev =3D iwe_stream_add_point(info,current_ev, end_buf, =
&iwe, buf);
            =20
 #if WIRELESS_EXT > 17
             if ((pBSS->wWPALen > 0) && (pBSS->wWPALen <=3D MAX_WPA_IE_LEN)=
) {
                 memset(&iwe, 0, sizeof(iwe));
                 iwe.cmd =3D IWEVGENIE;
                 iwe.u.data.length =3D pBSS->wWPALen;
-	 #if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27)   //mike add
                 current_ev =3D iwe_stream_add_point(info,current_ev, end_b=
uf, &iwe, pBSS->byWPAIE);
-	   #else		=09
-                current_ev =3D iwe_stream_add_point(current_ev, end_buf, &=
iwe, pBSS->byWPAIE);
-	    #endif
             }   =20
                =20
             if ((pBSS->wRSNLen > 0) && (pBSS->wRSNLen <=3D MAX_WPA_IE_LEN)=
) {
                 memset(&iwe, 0, sizeof(iwe));
                 iwe.cmd =3D IWEVGENIE;
                 iwe.u.data.length =3D pBSS->wRSNLen;
-		#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27)   //mike add
                 current_ev =3D iwe_stream_add_point(info,current_ev, end_b=
uf, &iwe, pBSS->byRSNIE);
-	   #else		=09
-                current_ev =3D iwe_stream_add_point(current_ev, end_buf, &=
iwe, pBSS->byRSNIE);
-	    #endif
             }                   =20
                =20
 #else // WIRELESS_EXT > 17=20
@@ -477,11 +429,7 @@ int iwctl_giwscan(struct net_device *dev,
 			        p +=3D sprintf(p, "%02x", pBSS->byWPAIE[ii]);
 		        }
 		        iwe.u.data.length =3D strlen(buf);
-		#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27)   //mike add
-                          current_ev =3D iwe_stream_add_point(info,current=
_ev, end_buf, &iwe, buf);
-		     #else	=09
-		        current_ev =3D iwe_stream_add_point(current_ev, end_buf, &iwe, b=
uf);
-			  #endif
+                current_ev =3D iwe_stream_add_point(info,current_ev, end_b=
uf, &iwe, buf);
 		    }   =20
                                =20
                                =20
@@ -494,11 +442,7 @@ int iwctl_giwscan(struct net_device *dev,
 			        p +=3D sprintf(p, "%02x", pBSS->byRSNIE[ii]);
 		        }
 		        iwe.u.data.length =3D strlen(buf);
-		#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,27)   //mike add
-                          current_ev =3D iwe_stream_add_point(info,current=
_ev, end_buf, &iwe, buf);
-		     #else	=09
-		        current_ev =3D iwe_stream_add_point(current_ev, end_buf, &iwe, b=
uf);
-			 #endif
+                current_ev =3D iwe_stream_add_point(info,current_ev, end_b=
uf, &iwe, buf);
 		    }
 #endif		   =20
 #endif		       =20
diff --git a/drivers/staging/vt6655/kcompat.h b/drivers/staging/vt6655/kcom=
pat.h
index a35959c..5923e14 100644
--- a/drivers/staging/vt6655/kcompat.h
+++ b/drivers/staging/vt6655/kcompat.h
@@ -74,229 +74,11 @@ typedef void irqreturn_t;
=20
 #endif
=20
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,2,18)
-
-typedef unsigned long dma_addr_t;
-typedef struct wait_queue *wait_queue_head_t;
-#define init_waitqueue_head(x)                  *(x)=3DNULL
-#define set_current_state(status)       { current->state =3D (status); mb(=
); }
-
-#ifdef MODULE
-
-#define module_init(fn) int  init_module   (void) { return fn(); }
-#define module_exit(fn) void cleanup_module(void) { return fn(); }
-
-#else /* MODULE */
-
-#define module_init(fn) int  e100_probe    (void) { return fn(); }
-#define module_exit(fn)  /* NOTHING */
-
-#endif /* MODULE */
-
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,2,18) */
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0)
-
-#ifdef MODVERSIONS
-#include <linux/modversions.h>
-#endif
-
-#include <linux/types.h>
-#include <linux/pci.h>
-#include <linux/slab.h>
-#include <asm/io.h>
-
-#define pci_resource_start(dev, bar)                            \
-    (((dev)->base_address[(bar)] & PCI_BASE_ADDRESS_SPACE_IO) ? \
-    ((dev)->base_address[(bar)] & PCI_BASE_ADDRESS_IO_MASK) :   \
-    ((dev)->base_address[(bar)] & PCI_BASE_ADDRESS_MEM_MASK))
-
-static inline int pci_enable_device(struct pci_dev *dev)=20
-{
-	1112=09
-	return 0;=20
-}
-#define __constant_cpu_to_le32 cpu_to_le32
-#define __constant_cpu_to_le16 cpu_to_le16
-
-#define PCI_DMA_TODEVICE   1
-#define PCI_DMA_FROMDEVICE 2
-
-extern inline void *pci_alloc_consistent (struct pci_dev *dev,=20
-                                          size_t size,=20
-                                          dma_addr_t *dma_handle) {
-    void *vaddr =3D kmalloc(size, GFP_ATOMIC);
-    if(vaddr !=3D NULL) {
-        *dma_handle =3D virt_to_bus(vaddr);
-    }
-    return vaddr;=20
-}
-
-#define pci_dma_sync_single(dev,dma_handle,size,direction)   do{} while(0)
-#define pci_dma_supported(dev, addr_mask)                    (1)
-#define pci_free_consistent(dev, size, cpu_addr, dma_handle) kfree(cpu_add=
r)
-#define pci_map_single(dev, addr, size, direction)           virt_to_bus(a=
ddr)
-#define pci_unmap_single(dev, dma_handle, size, direction)   do{} while(0)
-
-
-#define spin_lock_bh            spin_lock_irq
-#define spin_unlock_bh          spin_unlock_irq
-#define del_timer_sync(timer)   del_timer(timer)
-#define net_device              device
-
-#define netif_start_queue(dev)   ( clear_bit(0, &(dev)->tbusy))
-#define netif_stop_queue(dev)    (   set_bit(0, &(dev)->tbusy))
-#define netif_wake_queue(dev)    { clear_bit(0, &(dev)->tbusy); \
-                                   mark_bh(NET_BH); }
-#define netif_running(dev)       (  test_bit(0, &(dev)->start))
-#define netif_queue_stopped(dev) (  test_bit(0, &(dev)->tbusy))
-
-#define netif_device_attach(dev) \
-    do{ (dev)->start =3D 1; netif_start_queue(dev); } while (0)
-#define netif_device_detach(dev) \
-    do{ (dev)->start =3D 0; netif_stop_queue(dev); } while (0)
-
-#define dev_kfree_skb_irq(skb) dev_kfree_skb(skb)
-
-#define netif_carrier_on(dev)  do {} while (0)
-#define netif_carrier_off(dev) do {} while (0)
-
-
-#define PCI_ANY_ID (~0U)
-
-struct pci_device_id {
-    unsigned int vendor, device;
-    unsigned int subvendor, subdevice;
-    unsigned int class, classmask;
-    unsigned long driver_data;
-};
-
-#define MODULE_DEVICE_TABLE(bus, dev_table)
-#define PCI_MAX_NUM_NICS 256
-
-struct pci_driver {
-    char *name;
-    struct pci_device_id *id_table;
-    int (*probe)(struct pci_dev *dev, const struct pci_device_id *id);
-    void (*remove)(struct pci_dev *dev);
-    void (*suspend)(struct pci_dev *dev);
-    void (*resume)(struct pci_dev *dev);
-    struct pci_dev *pcimap[PCI_MAX_NUM_NICS];
-};
-
-static inline int pci_module_init(struct pci_driver *drv)
-{
-    struct pci_dev *pdev;
-    struct pci_device_id *pcid;
-    uint16_t subvendor, subdevice;
-    int board_count =3D 0;
-
-    /* walk the global pci device list looking for matches */
-    for (pdev =3D pci_devices; pdev && (board_count < PCI_MAX_NUM_NICS); p=
dev =3D pdev->next) {
-
-        pcid =3D &drv->id_table[0];
-        pci_read_config_word(pdev, PCI_SUBSYSTEM_VENDOR_ID, &subvendor);
-        pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &subdevice);
-       =20
-        while (pcid->vendor !=3D 0) {
-            if (((pcid->vendor =3D=3D pdev->vendor) || (pcid->vendor =3D=
=3D PCI_ANY_ID)) &&
-                ((pcid->device =3D=3D pdev->device) || (pcid->device =3D=
=3D PCI_ANY_ID)) &&
-                ((pcid->subvendor =3D=3D subvendor) || (pcid->subvendor =
=3D=3D PCI_ANY_ID)) &&
-                ((pcid->subdevice =3D=3D subdevice) || (pcid->subdevice =
=3D=3D PCI_ANY_ID))) {
-
-                if (drv->probe(pdev, pcid) =3D=3D 0) {
-                    drv->pcimap[board_count] =3D pdev;
-                    board_count++;
-                }
-                break;
-            }
-            pcid++;
-        }
-    }
-
-    if (board_count < PCI_MAX_NUM_NICS) {
-        drv->pcimap[board_count] =3D NULL;
-    }
-
-    return (board_count > 0) ? 0 : -ENODEV;
-}
-
-static inline void pci_unregister_driver(struct pci_driver *drv)
-{
-    int i;
-   =20
-    for (i =3D 0; i < PCI_MAX_NUM_NICS; i++) {
-        if (!drv->pcimap[i])
-            break;
-       =20
-        drv->remove(drv->pcimap[i]);
-    }
-}
-
-
-#define pci_set_drvdata(pcid, data)=20
-
-#define pci_get_drvdata(pcid) ({                            \
-    PSDevice pInfo;                                         \
-    for (pInfo =3D pDevice_Infos;                             \
-        pInfo; pInfo =3D pInfo->next) {                       \
-        if (pInfo->pcid =3D=3D pcid)                            \
-            break;                                          \
-    }                                                       \
-    pInfo; })
-
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0) */
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,5)
-
-#define skb_linearize(skb, gfp_mask) ({     \
-    struct sk_buff *tmp_skb;                \
-    tmp_skb =3D skb;                          \
-    skb =3D skb_copy(tmp_skb, gfp_mask);      \
-    dev_kfree_skb_irq(tmp_skb); })                             =20
-
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,4,5) */
=20
 #ifndef MODULE_LICESEN
 #define MODULE_LICESEN(x)=20
 #endif
=20
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,6)
-
-#include <linux/types.h>
-#include <linux/pci.h>
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,2)
-static inline int pci_set_power_state(struct pci_dev* pcid, int state) { r=
eturn 0; }
-#endif
-
-#define PMCSR       0xe0
-#define PM_ENABLE_BIT   0x0100
-#define PM_CLEAR_BIT    0x8000
-#define PM_STATE_MASK   0xFFFC
-#define PM_STATE_D1 0x0001
-
-static inline int
-pci_enable_wake(struct pci_dev *dev, u32 state, int enable)
-{
-    u16 p_state;
-
-    pci_read_config_word(dev, PMCSR, &p_state);
-    pci_write_config_word(dev, PMCSR, p_state | PM_CLEAR_BIT);
-
-    if (enable =3D=3D 0) {
-        p_state &=3D ~PM_ENABLE_BIT;
-    } else {
-        p_state |=3D PM_ENABLE_BIT;
-    }
-    p_state &=3D PM_STATE_MASK;
-    p_state |=3D state;
-
-    pci_write_config_word(dev, PMCSR, p_state);
-
-    return 0;
-}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,4,6) */
=20
 #endif
=20
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index 3b253b0..29fd0f2 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -1125,11 +1125,7 @@ s_vMgrRxAssocResponse(
                        );               =20
                 skb_put(pDevice->skb, sizeof(viawget_wpa_header) + wpahdr-=
>resp_ie_len + wpahdr->req_ie_len);
                 pDevice->skb->dev =3D pDevice->wpadev;
-#if	LINUX_VERSION_CODE	> KERNEL_VERSION(2,6,21)
-		pDevice->skb->mac_header =3D pDevice->skb->data;
-#else
-		pDevice->skb->mac.raw =3D pDevice->skb->data;
-#endif
+                pDevice->skb->mac_header =3D pDevice->skb->data;
                 pDevice->skb->pkt_type =3D PACKET_HOST;
                 pDevice->skb->protocol =3D htons(ETH_P_802_2);
                 memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
@@ -1765,11 +1761,7 @@ s_vMgrRxDisassociation(
              wpahdr->req_ie_len =3D 0;
              skb_put(pDevice->skb, sizeof(viawget_wpa_header));
              pDevice->skb->dev =3D pDevice->wpadev;
-#if	LINUX_VERSION_CODE	> KERNEL_VERSION(2,6,21)
 	         pDevice->skb->mac_header =3D pDevice->skb->data;
-#else
-		pDevice->skb->mac.raw =3D pDevice->skb->data;
-#endif
=20
              pDevice->skb->pkt_type =3D PACKET_HOST;
              pDevice->skb->protocol =3D htons(ETH_P_802_2);
@@ -1857,11 +1849,7 @@ s_vMgrRxDeauthentication(
                  wpahdr->req_ie_len =3D 0;
                  skb_put(pDevice->skb, sizeof(viawget_wpa_header));
                  pDevice->skb->dev =3D pDevice->wpadev;
-#if	LINUX_VERSION_CODE	> KERNEL_VERSION(2,6,21)
-	        pDevice->skb->mac_header =3D pDevice->skb->data;
-#else
-		pDevice->skb->mac.raw =3D pDevice->skb->data;
-#endif
+                 pDevice->skb->mac_header =3D pDevice->skb->data;
                  pDevice->skb->pkt_type =3D PACKET_HOST;
                  pDevice->skb->protocol =3D htons(ETH_P_802_2);
                  memset(pDevice->skb->cb, 0, sizeof(pDevice->skb->cb));
--=20
1.5.4.3


--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--zq44+AAfm4giZpo5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ8x8ORO4fQQdv5AwRAtOcAJ9kdQMPHH6+XUYwMdtK9INwYqfWVgCgvMns
t6XrmpBUBTjMneElrNJAwGQ=
=Guoc
-----END PGP SIGNATURE-----

--zq44+AAfm4giZpo5--

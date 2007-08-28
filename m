Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3707 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbXH1XpY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 19:45:24 -0400
Date: Tue, 28 Aug 2007 19:17:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Please pull 'upstream-jgarzik' branch of wireless-2.6
Message-ID: <20070828231731.GB2967@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff,

A few more for 2.6.24 -- mostly libertas.

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/up=
stream-jgarzik/

Thanks!

John

---

The following changes since commit e54cfa621f4cca9cca500019aa600c71d20f=
0592:
  Jeff Garzik (1):
        Merge branch 'upstream-jgarzik' of git://git.kernel.org/.../lin=
ville/wireless-2.6 into upstream

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.g=
it upstream-jgarzik

Andrew Morton (1):
      libertas: printk warning fixes

Brajesh Dave (1):
      libertas: advertise 11g ad-hoc rates

Dan Williams (4):
      libertas: fix inadvertant removal of bits from commit 83144186295=
6fffa17b9801db37e6ea1650b0f69
      libertas: reorganize and simplify init sequence
      libertas: don't stomp on interface-specific private data
      libertas: send reset command directly instead of calling libertas=
_reset_device

Jesper Juhl (1):
      net: Kill some unneeded allocation return value casts in libertas

Johannes Berg (1):
      rtl8187: remove IEEE80211_HW_DATA_NULLFUNC_ACK

John W. Linville (1):
      libertas: remove unused adhoc_rates_b definition

Marek Va=C5=A1ut (1):
      libertas: region code values specified as 8bit

Pierre Ossman (1):
      libertas: properly end commands on hardware failure

 drivers/net/wireless/libertas/cmd.c     |    2 +
 drivers/net/wireless/libertas/cmdresp.c |    6 +-
 drivers/net/wireless/libertas/debugfs.c |    2 +-
 drivers/net/wireless/libertas/decl.h    |    3 +-
 drivers/net/wireless/libertas/dev.h     |    4 -
 drivers/net/wireless/libertas/ethtool.c |    3 +-
 drivers/net/wireless/libertas/if_cs.c   |   58 +----
 drivers/net/wireless/libertas/if_usb.c  |  371 +++++++++++++----------=
------
 drivers/net/wireless/libertas/if_usb.h  |    4 +-
 drivers/net/wireless/libertas/join.c    |    7 +-
 drivers/net/wireless/libertas/main.c    |  408 +++++++++++++----------=
--------
 drivers/net/wireless/rtl8187_dev.c      |    3 +-
 12 files changed, 354 insertions(+), 517 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless=
/libertas/cmd.c
index 98092b9..33dbed0 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1009,7 +1009,9 @@ static int DownloadcommandToStation(wlan_private =
* priv,
 	if (ret !=3D 0) {
 		lbs_deb_host("DNLD_CMD: hw_host_to_card failed\n");
 		spin_lock_irqsave(&adapter->driver_lock, flags);
+		adapter->cur_cmd_retcode =3D ret;
 		__libertas_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
+		adapter->nr_cmd_pending--;
 		adapter->cur_cmd =3D NULL;
 		spin_unlock_irqrestore(&adapter->driver_lock, flags);
 		goto done;
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wire=
less/libertas/cmdresp.c
index 4c36e63..d64ad87 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -174,7 +174,11 @@ static int wlan_ret_get_hw_spec(wlan_private * pri=
v,
 	lbs_deb_cmd("GET_HW_SPEC: hardware interface 0x%x, hardware spec 0x%0=
4x\n",
 	       hwspec->hwifversion, hwspec->version);
=20
-	adapter->regioncode =3D le16_to_cpu(hwspec->regioncode);
+	/* Clamp region code to 8-bit since FW spec indicates that it should
+	 * only ever be 8-bit, even though the field size is 16-bit.  Some fi=
rmware
+	 * returns non-zero high 8 bits here.
+	 */
+	adapter->regioncode =3D le16_to_cpu(hwspec->regioncode) & 0xFF;
=20
 	for (i =3D 0; i < MRVDRV_MAX_REGION_CODE; i++) {
 		/* use the region code to search for the index */
diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wire=
less/libertas/debugfs.c
index 6d95148..816f42e 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -1838,7 +1838,7 @@ static ssize_t wlan_debugfs_write(struct file *f,=
 const char __user *buf,
 	char *p2;
 	struct debug_data *d =3D (struct debug_data *)f->private_data;
=20
-	pdata =3D (char *)kmalloc(cnt, GFP_KERNEL);
+	pdata =3D kmalloc(cnt, GFP_KERNEL);
 	if (pdata =3D=3D NULL)
 		return 0;
=20
diff --git a/drivers/net/wireless/libertas/decl.h b/drivers/net/wireles=
s/libertas/decl.h
index 095edf6..87fea9d 100644
--- a/drivers/net/wireless/libertas/decl.h
+++ b/drivers/net/wireless/libertas/decl.h
@@ -72,8 +72,9 @@ void libertas_send_iwevcustom_event(wlan_private * pr=
iv, s8 * str);
 struct chan_freq_power *libertas_get_region_cfp_table(u8 region, u8 ba=
nd,
 						             int *cfp_no);
 wlan_private *libertas_add_card(void *card, struct device *dmdev);
-int libertas_activate_card(wlan_private *priv);
 int libertas_remove_card(wlan_private *priv);
+int libertas_start_card(wlan_private *priv);
+int libertas_stop_card(wlan_private *priv);
 int libertas_add_mesh(wlan_private *priv, struct device *dev);
 void libertas_remove_mesh(wlan_private *priv);
 int libertas_reset_device(wlan_private *priv);
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless=
/libertas/dev.h
index a3c94d7..1fb807a 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -143,7 +143,6 @@ struct _wlan_private {
 	   all other bits reserved 0 */
 	u8 dnld_sent;
=20
-	const struct firmware *firmware;
 	struct device *hotplug_device;
=20
 	/** thread to service interrupts */
@@ -156,9 +155,6 @@ struct _wlan_private {
 	struct work_struct sync_channel;
=20
 	/** Hardware access */
-	int (*hw_register_dev) (wlan_private * priv);
-	int (*hw_unregister_dev) (wlan_private *);
-	int (*hw_prog_firmware) (wlan_private *);
 	int (*hw_host_to_card) (wlan_private * priv, u8 type, u8 * payload, u=
16 nb);
 	int (*hw_get_int_status) (wlan_private * priv, u8 *);
 	int (*hw_read_event_cause) (wlan_private *);
diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wire=
less/libertas/ethtool.c
index ec99cb8..d793d84 100644
--- a/drivers/net/wireless/libertas/ethtool.c
+++ b/drivers/net/wireless/libertas/ethtool.c
@@ -60,8 +60,7 @@ static int libertas_ethtool_get_eeprom(struct net_dev=
ice *dev,
=20
 //      mutex_lock(&priv->mutex);
=20
-	adapter->prdeeprom =3D
-		    (char *)kmalloc(eeprom->len+sizeof(regctrl), GFP_KERNEL);
+	adapter->prdeeprom =3D kmalloc(eeprom->len+sizeof(regctrl), GFP_KERNE=
L);
 	if (!adapter->prdeeprom)
 		return -ENOMEM;
 	memcpy(adapter->prdeeprom, &regctrl, sizeof(regctrl));
diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wirele=
ss/libertas/if_cs.c
index 888f023..09c87df 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -459,7 +459,7 @@ static int if_cs_prog_helper(struct if_cs_card *car=
d)
 		ret =3D -ENODEV;
 		goto done;
 	}
-	lbs_deb_cs("helper size %d\n", fw->size);
+	lbs_deb_cs("helper size %td\n", fw->size);
=20
 	/* "Set the 5 bytes of the helper image to 0" */
 	/* Not needed, this contains an ARM branch instruction */
@@ -535,7 +535,7 @@ static int if_cs_prog_real(struct if_cs_card *card)
 		ret =3D -ENODEV;
 		goto done;
 	}
-	lbs_deb_cs("fw size %d\n", fw->size);
+	lbs_deb_cs("fw size %td\n", fw->size);
=20
 	ret =3D if_cs_poll_while_fw_download(card, IF_CS_C_SQ_READ_LOW, IF_CS=
_C_SQ_HELPER_OK);
 	if (ret < 0) {
@@ -608,51 +608,6 @@ done:
 /* Callback functions for libertas.ko                               */
 /********************************************************************/
=20
-static int if_cs_register_dev(wlan_private *priv)
-{
-	struct if_cs_card *card =3D (struct if_cs_card *)priv->card;
-
-	lbs_deb_enter(LBS_DEB_CS);
-
-	card->priv =3D priv;
-
-	return 0;
-}
-
-
-static int if_cs_unregister_dev(wlan_private *priv)
-{
-	lbs_deb_enter(LBS_DEB_CS);
-
-	/*
-	 * Nothing special here. Because the device's power gets turned off
-	 * anyway, there's no need to send a RESET command like in if_usb.c
-	 */
-
-	return 0;
-}
-
-
-/*
- * This callback is a dummy. The reason is that the USB code needs
- * to have various things set up in order to be able to download the
- * firmware. That's not needed in our case.
- *
- * On the contrary, if libertas_add_card() has been called and we're
- * then later called via libertas_activate_card(), but without a valid
- * firmware, then it's quite tedious to tear down the half-installed
- * card. Therefore, we download the firmware before calling adding/
- * activating the card in the first place. If that doesn't work, we
- * won't call into libertas.ko at all.
- */
-
-static int if_cs_prog_firmware(wlan_private *priv)
-{
-	priv->adapter->fw_ready =3D 1;
-	return 0;
-}
-
-
 /* Send commands or data packets to the card */
 static int if_cs_host_to_card(wlan_private *priv, u8 type, u8 *buf, u1=
6 nb)
 {
@@ -902,14 +857,14 @@ static int if_cs_probe(struct pcmcia_device *p_de=
v)
 	}
=20
 	/* Store pointers to our call-back functions */
+	card->priv =3D priv;
 	priv->card =3D card;
-	priv->hw_register_dev     =3D if_cs_register_dev;
-	priv->hw_unregister_dev   =3D if_cs_unregister_dev;
-	priv->hw_prog_firmware    =3D if_cs_prog_firmware;
 	priv->hw_host_to_card     =3D if_cs_host_to_card;
 	priv->hw_get_int_status   =3D if_cs_get_int_status;
 	priv->hw_read_event_cause =3D if_cs_read_event_cause;
=20
+	priv->adapter->fw_ready =3D 1;
+
 	/* Now actually get the IRQ */
 	ret =3D request_irq(p_dev->irq.AssignedIRQ, if_cs_interrupt,
 		IRQF_SHARED, DRV_NAME, card);
@@ -919,7 +874,7 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
 	}
=20
 	/* And finally bring the card up */
-	if (libertas_activate_card(priv) !=3D 0) {
+	if (libertas_start_card(priv) !=3D 0) {
 		lbs_pr_err("could not activate card\n");
 		goto out3;
 	}
@@ -951,6 +906,7 @@ static void if_cs_detach(struct pcmcia_device *p_de=
v)
=20
 	lbs_deb_enter(LBS_DEB_CS);
=20
+	libertas_stop_card(card->priv);
 	libertas_remove_card(card->priv);
 	if_cs_release(p_dev);
 	kfree(card);
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wirel=
ess/libertas/if_usb.c
index 364eae3..8a3c70e 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -45,14 +45,14 @@ MODULE_DEVICE_TABLE(usb, if_usb_table);
=20
 static void if_usb_receive(struct urb *urb);
 static void if_usb_receive_fwload(struct urb *urb);
-static int if_usb_register_dev(wlan_private * priv);
-static int if_usb_unregister_dev(wlan_private *);
-static int if_usb_prog_firmware(wlan_private *);
+static int if_usb_prog_firmware(struct usb_card_rec *cardp);
 static int if_usb_host_to_card(wlan_private * priv, u8 type, u8 * payl=
oad, u16 nb);
 static int if_usb_get_int_status(wlan_private * priv, u8 *);
 static int if_usb_read_event_cause(wlan_private *);
-static int usb_tx_block(wlan_private *priv, u8 *payload, u16 nb);
+static int usb_tx_block(struct usb_card_rec *cardp, u8 *payload, u16 n=
b);
 static void if_usb_free(struct usb_card_rec *cardp);
+static int if_usb_submit_rx_urb(struct usb_card_rec *cardp);
+static int if_usb_reset_device(struct usb_card_rec *cardp);
=20
 /**
  *  @brief  call back function to handle the status of the URB
@@ -61,29 +61,40 @@ static void if_usb_free(struct usb_card_rec *cardp)=
;
  */
 static void if_usb_write_bulk_callback(struct urb *urb)
 {
-	wlan_private *priv =3D (wlan_private *) (urb->context);
-	wlan_adapter *adapter =3D priv->adapter;
-	struct net_device *dev =3D priv->dev;
+	struct usb_card_rec *cardp =3D (struct usb_card_rec *) urb->context;
=20
 	/* handle the transmission complete validations */
=20
-	if (urb->status !=3D 0) {
-		/* print the failure status number for debug */
-		lbs_pr_info("URB in failure status: %d\n", urb->status);
-	} else {
+	if (urb->status =3D=3D 0) {
+		wlan_private *priv =3D cardp->priv;
+
 		/*
 		lbs_deb_usbd(&urb->dev->dev, "URB status is successfull\n");
 		lbs_deb_usbd(&urb->dev->dev, "Actual length transmitted %d\n",
 		       urb->actual_length);
 		*/
-		priv->dnld_sent =3D DNLD_RES_RECEIVED;
-		/* Wake main thread if commands are pending */
-		if (!adapter->cur_cmd)
-			wake_up_interruptible(&priv->waitq);
-		if ((adapter->connect_status =3D=3D LIBERTAS_CONNECTED)) {
-			netif_wake_queue(dev);
-			netif_wake_queue(priv->mesh_dev);
+
+		/* Used for both firmware TX and regular TX.  priv isn't
+		 * valid at firmware load time.
+		 */
+		if (priv) {
+			wlan_adapter *adapter =3D priv->adapter;
+			struct net_device *dev =3D priv->dev;
+
+			priv->dnld_sent =3D DNLD_RES_RECEIVED;
+
+			/* Wake main thread if commands are pending */
+			if (!adapter->cur_cmd)
+				wake_up_interruptible(&priv->waitq);
+
+			if ((adapter->connect_status =3D=3D LIBERTAS_CONNECTED)) {
+				netif_wake_queue(dev);
+				netif_wake_queue(priv->mesh_dev);
+			}
 		}
+	} else {
+		/* print the failure status number for debug */
+		lbs_pr_info("URB in failure status: %d\n", urb->status);
 	}
=20
 	return;
@@ -205,24 +216,35 @@ static int if_usb_probe(struct usb_interface *int=
f,
 		}
 	}
=20
+	/* Upload firmware */
+	cardp->rinfo.cardp =3D cardp;
+	if (if_usb_prog_firmware(cardp)) {
+		lbs_deb_usbd(&udev->dev, "FW upload failed");
+		goto err_prog_firmware;
+	}
+
 	if (!(priv =3D libertas_add_card(cardp, &udev->dev)))
-		goto dealloc;
+		goto err_prog_firmware;
=20
-	udev->dev.driver_data =3D priv;
+	cardp->priv =3D priv;
=20
 	if (libertas_add_mesh(priv, &udev->dev))
 		goto err_add_mesh;
=20
-	priv->hw_register_dev =3D if_usb_register_dev;
-	priv->hw_unregister_dev =3D if_usb_unregister_dev;
-	priv->hw_prog_firmware =3D if_usb_prog_firmware;
+	cardp->eth_dev =3D priv->dev;
+
 	priv->hw_host_to_card =3D if_usb_host_to_card;
 	priv->hw_get_int_status =3D if_usb_get_int_status;
 	priv->hw_read_event_cause =3D if_usb_read_event_cause;
 	priv->boot2_version =3D udev->descriptor.bcdDevice;
=20
-	if (libertas_activate_card(priv))
-		goto err_activate_card;
+	/* Delay 200 ms to waiting for the FW ready */
+	if_usb_submit_rx_urb(cardp);
+	msleep_interruptible(200);
+	priv->adapter->fw_ready =3D 1;
+
+	if (libertas_start_card(priv))
+		goto err_start_card;
=20
 	list_add_tail(&cardp->list, &usb_devices);
=20
@@ -231,11 +253,12 @@ static int if_usb_probe(struct usb_interface *int=
f,
=20
 	return 0;
=20
-err_activate_card:
+err_start_card:
 	libertas_remove_mesh(priv);
 err_add_mesh:
-	free_netdev(priv->dev);
-	kfree(priv->adapter);
+	libertas_remove_card(priv);
+err_prog_firmware:
+	if_usb_reset_device(cardp);
 dealloc:
 	if_usb_free(cardp);
=20
@@ -252,21 +275,22 @@ static void if_usb_disconnect(struct usb_interfac=
e *intf)
 {
 	struct usb_card_rec *cardp =3D usb_get_intfdata(intf);
 	wlan_private *priv =3D (wlan_private *) cardp->priv;
-	wlan_adapter *adapter =3D NULL;
=20
-	adapter =3D priv->adapter;
+	lbs_deb_enter(LBS_DEB_MAIN);
=20
-	/*
-	 * Update Surprise removed to TRUE
-	 */
-	adapter->surpriseremoved =3D 1;
+	/* Update Surprise removed to TRUE */
+	cardp->surprise_removed =3D 1;
=20
 	list_del(&cardp->list);
=20
-	/* card is removed and we can call wlan_remove_card */
-	lbs_deb_usbd(&cardp->udev->dev, "call remove card\n");
-	libertas_remove_mesh(priv);
-	libertas_remove_card(priv);
+	if (priv) {
+		wlan_adapter *adapter =3D priv->adapter;
+
+		adapter->surpriseremoved =3D 1;
+		libertas_stop_card(priv);
+		libertas_remove_mesh(priv);
+		libertas_remove_card(priv);
+	}
=20
 	/* Unlink and free urb */
 	if_usb_free(cardp);
@@ -274,7 +298,7 @@ static void if_usb_disconnect(struct usb_interface =
*intf)
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
=20
-	return;
+	lbs_deb_leave(LBS_DEB_MAIN);
 }
=20
 /**
@@ -282,12 +306,11 @@ static void if_usb_disconnect(struct usb_interfac=
e *intf)
  *  @param priv		pointer to wlan_private
  *  @return 	   	0
  */
-static int if_prog_firmware(wlan_private * priv)
+static int if_prog_firmware(struct usb_card_rec *cardp)
 {
-	struct usb_card_rec *cardp =3D priv->card;
 	struct FWData *fwdata;
 	struct fwheader *fwheader;
-	u8 *firmware =3D priv->firmware->data;
+	u8 *firmware =3D cardp->fw->data;
=20
 	fwdata =3D kmalloc(sizeof(struct FWData), GFP_ATOMIC);
=20
@@ -335,7 +358,7 @@ static int if_prog_firmware(wlan_private * priv)
 			    cardp->totalbytes);
 		*/
 		memcpy(cardp->bulk_out_buffer, fwheader, FW_DATA_XMIT_SIZE);
-		usb_tx_block(priv, cardp->bulk_out_buffer, FW_DATA_XMIT_SIZE);
+		usb_tx_block(cardp, cardp->bulk_out_buffer, FW_DATA_XMIT_SIZE);
=20
 	} else if (fwdata->fwheader.dnldcmd =3D=3D cpu_to_le32(FW_HAS_LAST_BL=
OCK)) {
 		/*
@@ -345,7 +368,7 @@ static int if_prog_firmware(wlan_private * priv)
 			    "Donwloading FW JUMP BLOCK\n");
 		*/
 		memcpy(cardp->bulk_out_buffer, fwheader, FW_DATA_XMIT_SIZE);
-		usb_tx_block(priv, cardp->bulk_out_buffer, FW_DATA_XMIT_SIZE);
+		usb_tx_block(cardp, cardp->bulk_out_buffer, FW_DATA_XMIT_SIZE);
 		cardp->fwfinalblk =3D 1;
 	}
=20
@@ -360,10 +383,10 @@ static int if_prog_firmware(wlan_private * priv)
 	return 0;
 }
=20
-static int if_usb_reset_device(wlan_private *priv)
+static int if_usb_reset_device(struct usb_card_rec *cardp)
 {
 	int ret;
-	struct usb_card_rec *cardp =3D priv->card;
+	wlan_private * priv =3D cardp->priv;
=20
 	lbs_deb_enter(LBS_DEB_USB);
=20
@@ -371,7 +394,7 @@ static int if_usb_reset_device(wlan_private *priv)
 	 * command to the firmware.
 	 */
 	ret =3D usb_reset_device(cardp->udev);
-	if (!ret) {
+	if (!ret && priv) {
 		msleep(10);
 		ret =3D libertas_reset_device(priv);
 		msleep(10);
@@ -389,14 +412,12 @@ static int if_usb_reset_device(wlan_private *priv=
)
  *  @param nb		data length
  *  @return 	   	0 or -1
  */
-static int usb_tx_block(wlan_private * priv, u8 * payload, u16 nb)
+static int usb_tx_block(struct usb_card_rec *cardp, u8 * payload, u16 =
nb)
 {
-	/* pointer to card structure */
-	struct usb_card_rec *cardp =3D priv->card;
 	int ret =3D -1;
=20
 	/* check if device is removed */
-	if (priv->adapter->surpriseremoved) {
+	if (cardp->surprise_removed) {
 		lbs_deb_usbd(&cardp->udev->dev, "Device removed\n");
 		goto tx_ret;
 	}
@@ -404,7 +425,7 @@ static int usb_tx_block(wlan_private * priv, u8 * p=
ayload, u16 nb)
 	usb_fill_bulk_urb(cardp->tx_urb, cardp->udev,
 			  usb_sndbulkpipe(cardp->udev,
 					  cardp->bulk_out_endpointAddr),
-			  payload, nb, if_usb_write_bulk_callback, priv);
+			  payload, nb, if_usb_write_bulk_callback, cardp);
=20
 	cardp->tx_urb->transfer_flags |=3D URB_ZERO_PACKET;
=20
@@ -421,11 +442,9 @@ tx_ret:
 	return ret;
 }
=20
-static int __if_usb_submit_rx_urb(wlan_private * priv,
-				  void (*callbackfn)
-				  (struct urb *urb))
+static int __if_usb_submit_rx_urb(struct usb_card_rec *cardp,
+				  void (*callbackfn)(struct urb *urb))
 {
-	struct usb_card_rec *cardp =3D priv->card;
 	struct sk_buff *skb;
 	struct read_cb_info *rinfo =3D &cardp->rinfo;
 	int ret =3D -1;
@@ -461,22 +480,21 @@ rx_ret:
 	return ret;
 }
=20
-static inline int if_usb_submit_rx_urb_fwload(wlan_private * priv)
+static int if_usb_submit_rx_urb_fwload(struct usb_card_rec *cardp)
 {
-	return __if_usb_submit_rx_urb(priv, &if_usb_receive_fwload);
+	return __if_usb_submit_rx_urb(cardp, &if_usb_receive_fwload);
 }
=20
-static inline int if_usb_submit_rx_urb(wlan_private * priv)
+static int if_usb_submit_rx_urb(struct usb_card_rec *cardp)
 {
-	return __if_usb_submit_rx_urb(priv, &if_usb_receive);
+	return __if_usb_submit_rx_urb(cardp, &if_usb_receive);
 }
=20
 static void if_usb_receive_fwload(struct urb *urb)
 {
 	struct read_cb_info *rinfo =3D (struct read_cb_info *)urb->context;
-	wlan_private *priv =3D rinfo->priv;
 	struct sk_buff *skb =3D rinfo->skb;
-	struct usb_card_rec *cardp =3D (struct usb_card_rec *)priv->card;
+	struct usb_card_rec *cardp =3D (struct usb_card_rec *)rinfo->cardp;
 	struct fwsyncheader *syncfwheader;
 	struct bootcmdrespStr bootcmdresp;
=20
@@ -492,7 +510,7 @@ static void if_usb_receive_fwload(struct urb *urb)
 			sizeof(bootcmdresp));
 		if (le16_to_cpu(cardp->udev->descriptor.bcdDevice) < 0x3106) {
 			kfree_skb(skb);
-			if_usb_submit_rx_urb_fwload(priv);
+			if_usb_submit_rx_urb_fwload(cardp);
 			cardp->bootcmdresp =3D 1;
 			lbs_deb_usbd(&cardp->udev->dev,
 				    "Received valid boot command response\n");
@@ -516,7 +534,7 @@ static void if_usb_receive_fwload(struct urb *urb)
 				    "Received valid boot command response\n");
 		}
 		kfree_skb(skb);
-		if_usb_submit_rx_urb_fwload(priv);
+		if_usb_submit_rx_urb_fwload(cardp);
 		return;
 	}
=20
@@ -552,9 +570,9 @@ static void if_usb_receive_fwload(struct urb *urb)
 		goto exit;
 	}
=20
-	if_prog_firmware(priv);
+	if_prog_firmware(cardp);
=20
-	if_usb_submit_rx_urb_fwload(priv);
+	if_usb_submit_rx_urb_fwload(cardp);
 exit:
 	kfree(syncfwheader);
=20
@@ -633,9 +651,9 @@ static inline void process_cmdrequest(int recvlengt=
h, u8 *recvbuff,
 static void if_usb_receive(struct urb *urb)
 {
 	struct read_cb_info *rinfo =3D (struct read_cb_info *)urb->context;
-	wlan_private *priv =3D rinfo->priv;
 	struct sk_buff *skb =3D rinfo->skb;
-	struct usb_card_rec *cardp =3D (struct usb_card_rec *)priv->card;
+	struct usb_card_rec *cardp =3D (struct usb_card_rec *) rinfo->cardp;
+	wlan_private * priv =3D cardp->priv;
=20
 	int recvlength =3D urb->actual_length;
 	u8 *recvbuff =3D NULL;
@@ -696,7 +714,7 @@ static void if_usb_receive(struct urb *urb)
 	}
=20
 setup_for_next:
-	if_usb_submit_rx_urb(priv);
+	if_usb_submit_rx_urb(cardp);
 rx_exit:
 	lbs_deb_leave(LBS_DEB_USB);
 }
@@ -731,7 +749,7 @@ static int if_usb_host_to_card(wlan_private * priv,=
 u8 type, u8 * payload, u16 n
=20
 	memcpy((cardp->bulk_out_buffer + MESSAGE_HEADER_LEN), payload, nb);
=20
-	return usb_tx_block(priv, cardp->bulk_out_buffer,
+	return usb_tx_block(cardp, cardp->bulk_out_buffer,
 	                    nb + MESSAGE_HEADER_LEN);
 }
=20
@@ -751,46 +769,10 @@ static int if_usb_get_int_status(wlan_private * p=
riv, u8 * ireg)
 static int if_usb_read_event_cause(wlan_private * priv)
 {
 	struct usb_card_rec *cardp =3D priv->card;
+
 	priv->adapter->eventcause =3D cardp->usb_event_cause;
 	/* Re-submit rx urb here to avoid event lost issue */
-	if_usb_submit_rx_urb(priv);
-	return 0;
-}
-
-static int if_usb_unregister_dev(wlan_private * priv)
-{
-	int ret =3D 0;
-
-	/* Need to send a Reset command to device before USB resources freed
-	 * and wlan_remove_card() called, then device can handle FW download
-	 * again.
-	 */
-	if (priv)
-		libertas_reset_device(priv);
-
-	return ret;
-}
-
-
-/**
- *  @brief  This function register usb device and initialize parameter
- *  @param		priv pointer to wlan_private
- *  @return		0 or -1
- */
-static int if_usb_register_dev(wlan_private * priv)
-{
-	struct usb_card_rec *cardp =3D (struct usb_card_rec *)priv->card;
-
-	lbs_deb_enter(LBS_DEB_USB);
-
-	cardp->priv =3D priv;
-	cardp->eth_dev =3D priv->dev;
-	priv->hotplug_device =3D &(cardp->udev->dev);
-
-	lbs_deb_usbd(&cardp->udev->dev, "udev pointer is at %p\n",
-		    cardp->udev);
-
-	lbs_deb_leave(LBS_DEB_USB);
+	if_usb_submit_rx_urb(cardp);
 	return 0;
 }
=20
@@ -800,10 +782,9 @@ static int if_usb_register_dev(wlan_private * priv=
)
  *                  2:Boot from FW in EEPROM
  *  @return 	   	0
  */
-static int if_usb_issue_boot_command(wlan_private *priv, int ivalue)
+static int if_usb_issue_boot_command(struct usb_card_rec *cardp, int i=
value)
 {
-	struct usb_card_rec	*cardp =3D priv->card;
-	struct bootcmdstr	sbootcmd;
+	struct bootcmdstr sbootcmd;
 	int i;
=20
 	/* Prepare command */
@@ -814,28 +795,83 @@ static int if_usb_issue_boot_command(wlan_private=
 *priv, int ivalue)
 	memcpy(cardp->bulk_out_buffer, &sbootcmd, sizeof(struct bootcmdstr));
=20
 	/* Issue command */
-	usb_tx_block(priv, cardp->bulk_out_buffer, sizeof(struct bootcmdstr))=
;
+	usb_tx_block(cardp, cardp->bulk_out_buffer, sizeof(struct bootcmdstr)=
);
=20
 	return 0;
 }
=20
=20
-static int if_usb_do_prog_firmware(wlan_private * priv)
+/**
+ *  @brief This function checks the validity of Boot2/FW image.
+ *
+ *  @param data              pointer to image
+ *         len               image length
+ *  @return     0 or -1
+ */
+static int check_fwfile_format(u8 *data, u32 totlen)
+{
+	u32 bincmd, exit;
+	u32 blksize, offset, len;
+	int ret;
+
+	ret =3D 1;
+	exit =3D len =3D 0;
+
+	do {
+		struct fwheader *fwh =3D (void *)data;
+
+		bincmd =3D le32_to_cpu(fwh->dnldcmd);
+		blksize =3D le32_to_cpu(fwh->datalength);
+		switch (bincmd) {
+		case FW_HAS_DATA_TO_RECV:
+			offset =3D sizeof(struct fwheader) + blksize;
+			data +=3D offset;
+			len +=3D offset;
+			if (len >=3D totlen)
+				exit =3D 1;
+			break;
+		case FW_HAS_LAST_BLOCK:
+			exit =3D 1;
+			ret =3D 0;
+			break;
+		default:
+			exit =3D 1;
+			break;
+		}
+	} while (!exit);
+
+	if (ret)
+		lbs_pr_err("firmware file format check FAIL\n");
+	else
+		lbs_deb_fw("firmware file format check PASS\n");
+
+	return ret;
+}
+
+
+static int if_usb_prog_firmware(struct usb_card_rec *cardp)
 {
-	struct usb_card_rec *cardp =3D priv->card;
 	int i =3D 0;
 	static int reset_count =3D 10;
 	int ret =3D 0;
=20
 	lbs_deb_enter(LBS_DEB_USB);
=20
-	cardp->rinfo.priv =3D priv;
+	if ((ret =3D request_firmware(&cardp->fw, libertas_fw_name,
+				    &cardp->udev->dev)) < 0) {
+		lbs_pr_err("request_firmware() failed with %#x\n", ret);
+		lbs_pr_err("firmware %s not found\n", libertas_fw_name);
+		goto done;
+	}
+
+	if (check_fwfile_format(cardp->fw->data, cardp->fw->size))
+		goto release_fw;
=20
 restart:
-	if (if_usb_submit_rx_urb_fwload(priv) < 0) {
+	if (if_usb_submit_rx_urb_fwload(cardp) < 0) {
 		lbs_deb_usbd(&cardp->udev->dev, "URB submission is failed\n");
 		ret =3D -1;
-		goto done;
+		goto release_fw;
 	}
=20
 	cardp->bootcmdresp =3D 0;
@@ -843,7 +879,7 @@ restart:
 		int j =3D 0;
 		i++;
 		/* Issue Boot command =3D 1, Boot from Download-FW */
-		if_usb_issue_boot_command(priv, BOOT_CMD_FW_BY_USB);
+		if_usb_issue_boot_command(cardp, BOOT_CMD_FW_BY_USB);
 		/* wait for command response */
 		do {
 			j++;
@@ -853,14 +889,13 @@ restart:
=20
 	if (cardp->bootcmdresp =3D=3D 0) {
 		if (--reset_count >=3D 0) {
-			if_usb_reset_device(priv);
+			if_usb_reset_device(cardp);
 			goto restart;
 		}
 		return -1;
 	}
=20
 	i =3D 0;
-	priv->adapter->fw_ready =3D 0;
=20
 	cardp->totalbytes =3D 0;
 	cardp->fwlastblksent =3D 0;
@@ -870,113 +905,37 @@ restart:
 	cardp->totalbytes =3D 0;
 	cardp->fwfinalblk =3D 0;
=20
-	if_prog_firmware(priv);
+	if_prog_firmware(cardp);
=20
 	do {
 		lbs_deb_usbd(&cardp->udev->dev,"Wlan sched timeout\n");
 		i++;
 		msleep_interruptible(100);
-		if (priv->adapter->surpriseremoved || i >=3D 20)
+		if (cardp->surprise_removed || i >=3D 20)
 			break;
 	} while (!cardp->fwdnldover);
=20
 	if (!cardp->fwdnldover) {
 		lbs_pr_info("failed to load fw, resetting device!\n");
 		if (--reset_count >=3D 0) {
-			if_usb_reset_device(priv);
+			if_usb_reset_device(cardp);
 			goto restart;
 		}
=20
 		lbs_pr_info("FW download failure, time =3D %d ms\n", i * 100);
 		ret =3D -1;
-		goto done;
+		goto release_fw;
 	}
=20
-	if_usb_submit_rx_urb(priv);
-
-	/* Delay 200 ms to waiting for the FW ready */
-	msleep_interruptible(200);
-
-	priv->adapter->fw_ready =3D 1;
+release_fw:
+	release_firmware(cardp->fw);
+	cardp->fw =3D NULL;
=20
 done:
 	lbs_deb_leave_args(LBS_DEB_USB, "ret %d", ret);
 	return ret;
 }
=20
-/**
- *  @brief This function checks the validity of Boot2/FW image.
- *
- *  @param data              pointer to image
- *         len               image length
- *  @return     0 or -1
- */
-static int check_fwfile_format(u8 *data, u32 totlen)
-{
-	u32 bincmd, exit;
-	u32 blksize, offset, len;
-	int ret;
-
-	ret =3D 1;
-	exit =3D len =3D 0;
-
-	do {
-		struct fwheader *fwh =3D (void *)data;
-
-		bincmd =3D le32_to_cpu(fwh->dnldcmd);
-		blksize =3D le32_to_cpu(fwh->datalength);
-		switch (bincmd) {
-		case FW_HAS_DATA_TO_RECV:
-			offset =3D sizeof(struct fwheader) + blksize;
-			data +=3D offset;
-			len +=3D offset;
-			if (len >=3D totlen)
-				exit =3D 1;
-			break;
-		case FW_HAS_LAST_BLOCK:
-			exit =3D 1;
-			ret =3D 0;
-			break;
-		default:
-			exit =3D 1;
-			break;
-		}
-	} while (!exit);
-
-	if (ret)
-		lbs_pr_err("firmware file format check FAIL\n");
-	else
-		lbs_deb_fw("firmware file format check PASS\n");
-
-	return ret;
-}
-
-
-static int if_usb_prog_firmware(wlan_private *priv)
-{
-	int ret =3D -1;
-
-	lbs_deb_enter(LBS_DEB_FW);
-
-	if ((ret =3D request_firmware(&priv->firmware, libertas_fw_name,
-				    priv->hotplug_device)) < 0) {
-		lbs_pr_err("request_firmware() failed with %#x\n", ret);
-		lbs_pr_err("firmware %s not found\n", libertas_fw_name);
-		goto done;
-	}
-
-	if (check_fwfile_format(priv->firmware->data, priv->firmware->size)) =
{
-		release_firmware(priv->firmware);
-		goto done;
-	}
-
-	ret =3D if_usb_do_prog_firmware(priv);
-
-	release_firmware(priv->firmware);
-done:
-	return ret;
-}
-
=20
 #ifdef CONFIG_PM
 static int if_usb_suspend(struct usb_interface *intf, pm_message_t mes=
sage)
@@ -1085,8 +1044,10 @@ static void if_usb_exit_module(void)
=20
 	lbs_deb_enter(LBS_DEB_MAIN);
=20
-	list_for_each_entry_safe(cardp, cardp_temp, &usb_devices, list)
-		libertas_reset_device((wlan_private *) cardp->priv);
+	list_for_each_entry_safe(cardp, cardp_temp, &usb_devices, list) {
+		libertas_prepare_and_send_command(cardp->priv, CMD_802_11_RESET,
+		                                  CMD_ACT_HALT, 0, 0, NULL);
+	}
=20
 	/* API unregisters the driver from USB subsystem */
 	usb_deregister(&if_usb_driver);
diff --git a/drivers/net/wireless/libertas/if_usb.h b/drivers/net/wirel=
ess/libertas/if_usb.h
index 8b3b4f1..e07a10e 100644
--- a/drivers/net/wireless/libertas/if_usb.h
+++ b/drivers/net/wireless/libertas/if_usb.h
@@ -38,7 +38,7 @@ struct bootcmdrespStr
=20
 /* read callback private data */
 struct read_cb_info {
-        wlan_private *priv;
+        struct usb_card_rec *cardp;
         struct sk_buff *skb;
 };
=20
@@ -58,6 +58,7 @@ struct usb_card_rec {
 	int bulk_out_size;
 	u8 bulk_out_endpointAddr;
=20
+	const struct firmware *fw;
 	u8 CRC_OK;
 	u32 fwseqnum;
 	u32 lastseqnum;
@@ -65,6 +66,7 @@ struct usb_card_rec {
 	u32 fwlastblksent;
 	u8 fwdnldover;
 	u8 fwfinalblk;
+	u8 surprise_removed;
=20
 	u32 usb_event_cause;
 	u8 usb_int_cause;
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireles=
s/libertas/join.c
index ce49d3f..0ad1362 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -17,9 +17,6 @@
 #include "dev.h"
 #include "assoc.h"
=20
-/* Supported rates for ad-hoc B mode */
-static u8 adhoc_rates_b[5] =3D { 0x02, 0x04, 0x0b, 0x16, 0x00 };
-
 /* The firmware needs certain bits masked out of the beacon-derviced c=
apability
  * field when associating/joining to BSSs.
  */
@@ -550,8 +547,8 @@ int libertas_cmd_80211_ad_hoc_start(wlan_private * =
priv,
 	adhs->probedelay =3D cpu_to_le16(CMD_SCAN_PROBE_DELAY_TIME);
=20
 	memset(adhs->rates, 0, sizeof(adhs->rates));
-	ratesize =3D min(sizeof(adhs->rates), sizeof(adhoc_rates_b));
-	memcpy(adhs->rates, adhoc_rates_b, ratesize);
+	ratesize =3D min(sizeof(adhs->rates), sizeof(libertas_bg_rates));
+	memcpy(adhs->rates, libertas_bg_rates, ratesize);
=20
 	/* Copy the ad-hoc creating rates into Current BSS state structure */
 	memset(&adapter->curbssparams.rates, 0, sizeof(adapter->curbssparams.=
rates));
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireles=
s/libertas/main.c
index f0213ec..3feddcc 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -256,7 +256,7 @@ void libertas_remove_rtap(wlan_private *priv);
 static ssize_t libertas_rtap_get(struct device * dev,
 		struct device_attribute *attr, char * buf)
 {
-	wlan_private *priv =3D (wlan_private *) dev->driver_data;
+	wlan_private *priv =3D (wlan_private *) (to_net_dev(dev))->priv;
 	wlan_adapter *adapter =3D priv->adapter;
 	return snprintf(buf, 5, "0x%X\n", adapter->monitormode);
 }
@@ -268,7 +268,7 @@ static ssize_t libertas_rtap_set(struct device * de=
v,
 		struct device_attribute *attr, const char * buf, size_t count)
 {
 	int monitor_mode;
-	wlan_private *priv =3D (wlan_private *) dev->driver_data;
+	wlan_private *priv =3D (wlan_private *) (to_net_dev(dev))->priv;
 	wlan_adapter *adapter =3D priv->adapter;
=20
 	sscanf(buf, "%x", &monitor_mode);
@@ -768,6 +768,7 @@ static int libertas_thread(void *data)
=20
 	init_waitqueue_entry(&wait, current);
=20
+	set_freezable();
 	for (;;) {
 		lbs_deb_thread( "main-thread 111: intcounter=3D%d "
 		       "currenttxskb=3D%p dnld_sent=3D%d\n",
@@ -790,7 +791,6 @@ static int libertas_thread(void *data)
 		} else
 			spin_unlock_irq(&adapter->driver_lock);
=20
-
 		lbs_deb_thread(
 		       "main-thread 222 (waking up): intcounter=3D%d currenttxskb=3D=
%p "
 		       "dnld_sent=3D%d\n", adapter->intcounter,
@@ -925,7 +925,7 @@ static int libertas_thread(void *data)
  *  @param priv    A pointer to wlan_private structure
  *  @return 	   0 or -1
  */
-static int wlan_setup_station_hw(wlan_private * priv)
+static int wlan_setup_firmware(wlan_private * priv)
 {
 	int ret =3D -1;
 	wlan_adapter *adapter =3D priv->adapter;
@@ -933,14 +933,6 @@ static int wlan_setup_station_hw(wlan_private * pr=
iv)
=20
 	lbs_deb_enter(LBS_DEB_FW);
=20
-	ret =3D priv->hw_prog_firmware(priv);
-
-	if (ret) {
-		lbs_deb_fw("bootloader in invalid state\n");
-		ret =3D -1;
-		goto done;
-	}
-
 	/*
 	 * Read MAC address from HW
 	 */
@@ -991,8 +983,6 @@ done:
 	return ret;
 }
=20
-static void command_timer_fn(unsigned long data);
-
 /**
  *  This function handles the timeout of command sending.
  *  It will re-send the same command again.
@@ -1034,155 +1024,99 @@ static void command_timer_fn(unsigned long dat=
a)
 	return;
 }
=20
-static void libertas_free_adapter(wlan_private * priv)
+static int libertas_init_adapter(wlan_private * priv)
 {
 	wlan_adapter *adapter =3D priv->adapter;
-
-	if (!adapter) {
-		lbs_deb_fw("why double free adapter?\n");
-		return;
-	}
-
-	lbs_deb_fw("free command buffer\n");
-	libertas_free_cmd_buffer(priv);
-
-	lbs_deb_fw("free command_timer\n");
-	del_timer(&adapter->command_timer);
-
-	lbs_deb_fw("free scan results table\n");
-	kfree(adapter->networks);
-	adapter->networks =3D NULL;
-
-	/* Free the adapter object itself */
-	lbs_deb_fw("free adapter\n");
-	kfree(adapter);
-	priv->adapter =3D NULL;
-}
-
-static int wlan_allocate_adapter(wlan_private * priv)
-{
 	size_t bufsize;
-	wlan_adapter *adapter =3D priv->adapter;
+	int i, ret =3D 0;
=20
 	/* Allocate buffer to store the BSSID list */
 	bufsize =3D MAX_NETWORK_COUNT * sizeof(struct bss_descriptor);
 	adapter->networks =3D kzalloc(bufsize, GFP_KERNEL);
 	if (!adapter->networks) {
 		lbs_pr_err("Out of memory allocating beacons\n");
-		libertas_free_adapter(priv);
-		return -ENOMEM;
+		ret =3D -1;
+		goto out;
 	}
=20
-	/* Allocate the command buffers */
-	libertas_allocate_cmd_buffer(priv);
+	/* Initialize scan result lists */
+	INIT_LIST_HEAD(&adapter->network_free_list);
+	INIT_LIST_HEAD(&adapter->network_list);
+	for (i =3D 0; i < MAX_NETWORK_COUNT; i++) {
+		list_add_tail(&adapter->networks[i].list,
+			      &adapter->network_free_list);
+	}
=20
-	memset(&adapter->libertas_ps_confirm_sleep, 0, sizeof(struct PS_CMD_C=
onfirmSleep));
 	adapter->libertas_ps_confirm_sleep.seqnum =3D cpu_to_le16(++adapter->=
seqnum);
 	adapter->libertas_ps_confirm_sleep.command =3D
 	    cpu_to_le16(CMD_802_11_PS_MODE);
 	adapter->libertas_ps_confirm_sleep.size =3D
 	    cpu_to_le16(sizeof(struct PS_CMD_ConfirmSleep));
-	adapter->libertas_ps_confirm_sleep.result =3D 0;
 	adapter->libertas_ps_confirm_sleep.action =3D
 	    cpu_to_le16(CMD_SUBCMD_SLEEP_CONFIRMED);
=20
-	return 0;
-}
-
-static void wlan_init_adapter(wlan_private * priv)
-{
-	wlan_adapter *adapter =3D priv->adapter;
-	int i;
-
-	adapter->connect_status =3D LIBERTAS_DISCONNECTED;
 	memset(adapter->current_addr, 0xff, ETH_ALEN);
=20
-	/* 802.11 specific */
-	adapter->secinfo.wep_enabled =3D 0;
-	for (i =3D 0; i < sizeof(adapter->wep_keys) / sizeof(adapter->wep_key=
s[0]);
-	     i++)
-		memset(&adapter->wep_keys[i], 0, sizeof(struct enc_key));
-	adapter->wep_tx_keyidx =3D 0;
+	adapter->connect_status =3D LIBERTAS_DISCONNECTED;
 	adapter->secinfo.auth_mode =3D IW_AUTH_ALG_OPEN_SYSTEM;
 	adapter->mode =3D IW_MODE_INFRA;
-
-	adapter->pending_assoc_req =3D NULL;
-	adapter->in_progress_assoc_req =3D NULL;
-
-	/* Initialize scan result lists */
-	INIT_LIST_HEAD(&adapter->network_free_list);
-	INIT_LIST_HEAD(&adapter->network_list);
-	for (i =3D 0; i < MAX_NETWORK_COUNT; i++) {
-		list_add_tail(&adapter->networks[i].list,
-			      &adapter->network_free_list);
-	}
-
-	mutex_init(&adapter->lock);
-
-	memset(&adapter->curbssparams, 0, sizeof(adapter->curbssparams));
 	adapter->curbssparams.channel =3D DEFAULT_AD_HOC_CHANNEL;
-
-	/* PnP and power profile */
-	adapter->surpriseremoved =3D 0;
-
-	adapter->currentpacketfilter =3D
-	    CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
-
+	adapter->currentpacketfilter =3D CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_O=
N;
 	adapter->radioon =3D RADIO_ON;
-
 	adapter->auto_rate =3D 1;
-	adapter->cur_rate =3D 0;
-
-	// set default capabilities
 	adapter->capability =3D WLAN_CAPABILITY_SHORT_PREAMBLE;
-
 	adapter->psmode =3D WLAN802_11POWERMODECAM;
-
 	adapter->psstate =3D PS_STATE_FULL_POWER;
-	adapter->needtowakeup =3D 0;
=20
-	adapter->intcounter =3D 0;
-
-	adapter->currenttxskb =3D NULL;
+	mutex_init(&adapter->lock);
=20
 	memset(&adapter->tx_queue_ps, 0, NR_TX_QUEUE*sizeof(struct sk_buff*))=
;
 	adapter->tx_queue_idx =3D 0;
 	spin_lock_init(&adapter->txqueue_lock);
=20
-	return;
-}
+	setup_timer(&adapter->command_timer, command_timer_fn,
+	            (unsigned long)priv);
=20
-static int libertas_init_fw(wlan_private * priv)
-{
-	int ret =3D -1;
-	wlan_adapter *adapter =3D priv->adapter;
+	INIT_LIST_HEAD(&adapter->cmdfreeq);
+	INIT_LIST_HEAD(&adapter->cmdpendingq);
=20
-	lbs_deb_enter(LBS_DEB_FW);
+	spin_lock_init(&adapter->driver_lock);
+	init_waitqueue_head(&adapter->cmd_pending);
+	adapter->nr_cmd_pending =3D 0;
=20
-	/* Allocate adapter structure */
-	if ((ret =3D wlan_allocate_adapter(priv)) !=3D 0)
-		goto done;
+	/* Allocate the command buffers */
+	if (libertas_allocate_cmd_buffer(priv)) {
+		lbs_pr_err("Out of memory allocating command buffers\n");
+		ret =3D -1;
+	}
=20
-	/* init adapter structure */
-	wlan_init_adapter(priv);
+out:
+	return ret;
+}
=20
-	/* init timer etc. */
-	setup_timer(&adapter->command_timer, command_timer_fn,
-			(unsigned long)priv);
+static void libertas_free_adapter(wlan_private * priv)
+{
+	wlan_adapter *adapter =3D priv->adapter;
=20
-	/* download fimrware etc. */
-	if ((ret =3D wlan_setup_station_hw(priv)) !=3D 0) {
-		del_timer_sync(&adapter->command_timer);
-		goto done;
+	if (!adapter) {
+		lbs_deb_fw("why double free adapter?\n");
+		return;
 	}
=20
-	/* init 802.11d */
-	libertas_init_11d(priv);
+	lbs_deb_fw("free command buffer\n");
+	libertas_free_cmd_buffer(priv);
=20
-	ret =3D 0;
-done:
-	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
-	return ret;
+	lbs_deb_fw("free command_timer\n");
+	del_timer(&adapter->command_timer);
+
+	lbs_deb_fw("free scan results table\n");
+	kfree(adapter->networks);
+	adapter->networks =3D NULL;
+
+	/* Free the adapter object itself */
+	lbs_deb_fw("free adapter\n");
+	kfree(adapter);
+	priv->adapter =3D NULL;
 }
=20
 /**
@@ -1202,7 +1136,7 @@ wlan_private *libertas_add_card(void *card, struc=
t device *dmdev)
 	/* Allocate an Ethernet device and register it */
 	if (!(dev =3D alloc_etherdev(sizeof(wlan_private)))) {
 		lbs_pr_err("init ethX device failed\n");
-		return NULL;
+		goto done;
 	}
 	priv =3D dev->priv;
=20
@@ -1212,10 +1146,16 @@ wlan_private *libertas_add_card(void *card, str=
uct device *dmdev)
 		goto err_kzalloc;
 	}
=20
+	if (libertas_init_adapter(priv)) {
+		lbs_pr_err("failed to initialize adapter structure.\n");
+		goto err_init_adapter;
+	}
+
 	priv->dev =3D dev;
 	priv->card =3D card;
 	priv->mesh_open =3D 0;
 	priv->infra_open =3D 0;
+	priv->hotplug_device =3D dmdev;
=20
 	SET_MODULE_OWNER(dev);
=20
@@ -1238,87 +1178,144 @@ wlan_private *libertas_add_card(void *card, st=
ruct device *dmdev)
=20
 	SET_NETDEV_DEV(dev, dmdev);
=20
-	INIT_LIST_HEAD(&priv->adapter->cmdfreeq);
-	INIT_LIST_HEAD(&priv->adapter->cmdpendingq);
-
-	spin_lock_init(&priv->adapter->driver_lock);
-	init_waitqueue_head(&priv->adapter->cmd_pending);
-	priv->adapter->nr_cmd_pending =3D 0;
 	priv->rtap_net_dev =3D NULL;
 	if (device_create_file(dmdev, &dev_attr_libertas_rtap))
-		goto err_kzalloc;
+		goto err_init_adapter;
+
+	lbs_deb_thread("Starting main thread...\n");
+	init_waitqueue_head(&priv->waitq);
+	priv->main_thread =3D kthread_run(libertas_thread, dev, "libertas_mai=
n");
+	if (IS_ERR(priv->main_thread)) {
+		lbs_deb_thread("Error creating main thread.\n");
+		goto err_kthread_run;
+	}
+
+	priv->work_thread =3D create_singlethread_workqueue("libertas_worker"=
);
+	INIT_DELAYED_WORK(&priv->assoc_work, libertas_association_worker);
+	INIT_DELAYED_WORK(&priv->scan_work, libertas_scan_worker);
+	INIT_WORK(&priv->sync_channel, libertas_sync_channel);
+
 	goto done;
=20
+err_kthread_run:
+	device_remove_file(dmdev, &dev_attr_libertas_rtap);
+
+err_init_adapter:
+	libertas_free_adapter(priv);
+
 err_kzalloc:
 	free_netdev(dev);
 	priv =3D NULL;
+
 done:
 	lbs_deb_leave_args(LBS_DEB_NET, "priv %p", priv);
 	return priv;
 }
 EXPORT_SYMBOL_GPL(libertas_add_card);
=20
-int libertas_activate_card(wlan_private *priv)
+
+int libertas_remove_card(wlan_private *priv)
 {
+	wlan_adapter *adapter =3D priv->adapter;
 	struct net_device *dev =3D priv->dev;
-	int ret =3D -1;
+	union iwreq_data wrqu;
=20
 	lbs_deb_enter(LBS_DEB_MAIN);
=20
-	lbs_deb_thread("Starting main thread...\n");
-	init_waitqueue_head(&priv->waitq);
-	priv->main_thread =3D kthread_run(libertas_thread, dev, "libertas_mai=
n");
-	if (IS_ERR(priv->main_thread)) {
-		lbs_deb_thread("Error creating main thread.\n");
-		goto done;
-	}
+	libertas_remove_rtap(priv);
=20
-	priv->work_thread =3D create_singlethread_workqueue("libertas_worker"=
);
-	INIT_DELAYED_WORK(&priv->assoc_work, libertas_association_worker);
-	INIT_DELAYED_WORK(&priv->scan_work, libertas_scan_worker);
+	dev =3D priv->dev;
+	device_remove_file(priv->hotplug_device, &dev_attr_libertas_rtap);
=20
-	INIT_WORK(&priv->sync_channel, libertas_sync_channel);
+	cancel_delayed_work(&priv->scan_work);
+	cancel_delayed_work(&priv->assoc_work);
+	destroy_workqueue(priv->work_thread);
=20
-	/*
-	 * Register the device. Fillup the private data structure with
-	 * relevant information from the card and request for the required
-	 * IRQ.
-	 */
-	if (priv->hw_register_dev(priv) < 0) {
-		lbs_pr_err("failed to register WLAN device\n");
-		goto err_registerdev;
+	if (adapter->psmode =3D=3D WLAN802_11POWERMODEMAX_PSP) {
+		adapter->psmode =3D WLAN802_11POWERMODECAM;
+		libertas_ps_wakeup(priv, CMD_OPTION_WAITFORRSP);
 	}
=20
-	/* init FW and HW */
-	if (libertas_init_fw(priv)) {
-		lbs_pr_err("firmware init failed\n");
-		goto err_registerdev;
-	}
+	memset(wrqu.ap_addr.sa_data, 0xaa, ETH_ALEN);
+	wrqu.ap_addr.sa_family =3D ARPHRD_ETHER;
+	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
+
+	/* Stop the thread servicing the interrupts */
+	adapter->surpriseremoved =3D 1;
+	kthread_stop(priv->main_thread);
+
+	libertas_free_adapter(priv);
+
+	priv->dev =3D NULL;
+	free_netdev(dev);
+
+	lbs_deb_leave(LBS_DEB_MAIN);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(libertas_remove_card);
+
+
+int libertas_start_card(wlan_private *priv)
+{
+	struct net_device *dev =3D priv->dev;
+	int ret =3D -1;
+
+	lbs_deb_enter(LBS_DEB_MAIN);
+
+	/* poke the firmware */
+	ret =3D wlan_setup_firmware(priv);
+	if (ret)
+		goto done;
+
+	/* init 802.11d */
+	libertas_init_11d(priv);
=20
 	if (register_netdev(dev)) {
 		lbs_pr_err("cannot register ethX device\n");
-		goto err_init_fw;
+		goto done;
 	}
=20
-	lbs_pr_info("%s: Marvell WLAN 802.11 adapter\n", dev->name);
-
 	libertas_debugfs_init_one(priv, dev);
=20
+	lbs_pr_info("%s: Marvell WLAN 802.11 adapter\n", dev->name);
+
 	ret =3D 0;
-	goto done;
=20
-err_init_fw:
-	priv->hw_unregister_dev(priv);
-err_registerdev:
-	destroy_workqueue(priv->work_thread);
-	/* Stop the thread servicing the interrupts */
-	wake_up_interruptible(&priv->waitq);
-	kthread_stop(priv->main_thread);
 done:
-	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
+	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(libertas_activate_card);
+EXPORT_SYMBOL_GPL(libertas_start_card);
+
+
+int libertas_stop_card(wlan_private *priv)
+{
+	struct net_device *dev =3D priv->dev;
+	int ret =3D -1;
+	struct cmd_ctrl_node *cmdnode;
+	unsigned long flags;
+
+	lbs_deb_enter(LBS_DEB_MAIN);
+
+	netif_stop_queue(priv->dev);
+	netif_carrier_off(priv->dev);
+
+	libertas_debugfs_remove_one(priv);
+
+	/* Flush pending command nodes */
+	spin_lock_irqsave(&priv->adapter->driver_lock, flags);
+	list_for_each_entry(cmdnode, &priv->adapter->cmdpendingq, list) {
+		cmdnode->cmdwaitqwoken =3D 1;
+		wake_up_interruptible(&cmdnode->cmdwait_q);
+	}
+	spin_unlock_irqrestore(&priv->adapter->driver_lock, flags);
+
+	unregister_netdev(dev);
+
+	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(libertas_stop_card);
=20
=20
 /**
@@ -1388,89 +1385,12 @@ done:
 }
 EXPORT_SYMBOL_GPL(libertas_add_mesh);
=20
-static void wake_pending_cmdnodes(wlan_private *priv)
-{
-	struct cmd_ctrl_node *cmdnode;
-	unsigned long flags;
-
-	lbs_deb_enter(LBS_DEB_HOST);
-
-	spin_lock_irqsave(&priv->adapter->driver_lock, flags);
-	list_for_each_entry(cmdnode, &priv->adapter->cmdpendingq, list) {
-		cmdnode->cmdwaitqwoken =3D 1;
-		wake_up_interruptible(&cmdnode->cmdwait_q);
-	}
-	spin_unlock_irqrestore(&priv->adapter->driver_lock, flags);
-}
-
-
-int libertas_remove_card(wlan_private *priv)
-{
-	wlan_adapter *adapter;
-	struct net_device *dev;
-	union iwreq_data wrqu;
-
-	lbs_deb_enter(LBS_DEB_NET);
-
-	libertas_remove_rtap(priv);
-	if (!priv)
-		goto out;
-
-	adapter =3D priv->adapter;
-
-	if (!adapter)
-		goto out;
-
-	dev =3D priv->dev;
-	device_remove_file(priv->hotplug_device, &dev_attr_libertas_rtap);
-
-	netif_stop_queue(priv->dev);
-	netif_carrier_off(priv->dev);
-
-	wake_pending_cmdnodes(priv);
-
-	unregister_netdev(dev);
-
-	cancel_delayed_work(&priv->scan_work);
-	cancel_delayed_work(&priv->assoc_work);
-	destroy_workqueue(priv->work_thread);
-
-	if (adapter->psmode =3D=3D WLAN802_11POWERMODEMAX_PSP) {
-		adapter->psmode =3D WLAN802_11POWERMODECAM;
-		libertas_ps_wakeup(priv, CMD_OPTION_WAITFORRSP);
-	}
-
-	memset(wrqu.ap_addr.sa_data, 0xaa, ETH_ALEN);
-	wrqu.ap_addr.sa_family =3D ARPHRD_ETHER;
-	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
-
-	adapter->surpriseremoved =3D 1;
-
-	/* Stop the thread servicing the interrupts */
-	kthread_stop(priv->main_thread);
-
-	libertas_debugfs_remove_one(priv);
-
-	lbs_deb_net("free adapter\n");
-	libertas_free_adapter(priv);
-
-	lbs_deb_net("unregister finish\n");
-
-	priv->dev =3D NULL;
-	free_netdev(dev);
-
-out:
-	lbs_deb_leave(LBS_DEB_NET);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(libertas_remove_card);
-
=20
 void libertas_remove_mesh(wlan_private *priv)
 {
 	struct net_device *mesh_dev;
=20
-	lbs_deb_enter(LBS_DEB_NET);
+	lbs_deb_enter(LBS_DEB_MAIN);
=20
 	if (!priv)
 		goto out;
@@ -1487,7 +1407,7 @@ void libertas_remove_mesh(wlan_private *priv)
 	free_netdev(mesh_dev);
=20
 out:
-	lbs_deb_leave(LBS_DEB_NET);
+	lbs_deb_leave(LBS_DEB_MAIN);
 }
 EXPORT_SYMBOL_GPL(libertas_remove_mesh);
=20
diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/=
rtl8187_dev.c
index e61c6d5..d52e487 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -604,8 +604,7 @@ static int __devinit rtl8187_probe(struct usb_inter=
face *intf,
 	priv->mode =3D IEEE80211_IF_TYPE_MGMT;
 	dev->flags =3D IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 		     IEEE80211_HW_RX_INCLUDES_FCS |
-		     IEEE80211_HW_WEP_INCLUDE_IV |
-		     IEEE80211_HW_DATA_NULLFUNC_ACK;
+		     IEEE80211_HW_WEP_INCLUDE_IV;
 	dev->extra_tx_headroom =3D sizeof(struct rtl8187_tx_hdr);
 	dev->queues =3D 1;
 	dev->max_rssi =3D 65;
--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

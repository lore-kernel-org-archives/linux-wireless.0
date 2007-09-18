Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636AbXIRPM1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 11:12:27 -0400
Subject: Please pull 'for-linville' branch of libertas-2.6
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 18 Sep 2007 11:10:11 -0400
Message-Id: <1190128211.537.11.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Please pull the following fixes from the 'for-linville' branch.

Thanks!

Dan


The following changes since commit 93e07b4f5c44035a1f6e12af194f2d610983=
3d44:
  Dan Williams (1):
        libertas: don't stomp on interface-specific private data

are available in the git repository at:

  git://git.infradead.org/libertas-2.6 libertas

Brajesh Dave (1):
      libertas: advertise 11g ad-hoc rates

Dan Williams (1):
      libertas: send reset command directly instead of calling libertas=
_reset_device

Jesper Juhl (1):
      net: Kill some unneeded allocation return value casts in libertas

Marek Va=C5=A1ut (1):
      libertas: region code values specified as 8bit

Pierre Ossman (1):
      libertas: properly end commands on hardware failure

Ryan Mallon (2):
      libertas: set dnld_sent correctly for CF parts
      libertas: fix interrupts in CF driver

Vladimir Davydov (2):
      libertas: fix oops on the blackfin architecture
      libertas: fix oops on the blackfin architecture

 drivers/net/wireless/libertas/cmd.c     |    2 +
 drivers/net/wireless/libertas/cmdresp.c |    6 +++-
 drivers/net/wireless/libertas/debugfs.c |    2 +-
 drivers/net/wireless/libertas/ethtool.c |    3 +-
 drivers/net/wireless/libertas/if_cs.c   |   42 ++++++++++++++++++-----=
-------
 drivers/net/wireless/libertas/if_usb.c  |    6 +++-
 drivers/net/wireless/libertas/join.c    |    4 +-
 drivers/net/wireless/libertas/scan.c    |    8 +++--
 8 files changed, 45 insertions(+), 28 deletions(-)


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
index 4dffc5c..15a2671 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -248,22 +248,26 @@ static irqreturn_t if_cs_interrupt(int irq, void =
*data)
 	lbs_deb_enter(LBS_DEB_CS);
=20
 	int_cause =3D if_cs_read16(card, IF_CS_C_INT_CAUSE);
-	switch (int_cause) {
-	case 0x0000:
-		/* not for us */
+	if(int_cause =3D=3D 0x0) {
+		/* Not for us */
 		return IRQ_NONE;
-	case 0xffff:
-		/* if one reads junk, then probably the card was removed */
+=09
+	} else if(int_cause =3D=3D 0xffff) {
+		/* Read in junk, the card has probably been removed */
 		card->priv->adapter->surpriseremoved =3D 1;
-		break;
-	case IF_CS_H_IC_TX_OVER:
-		if (card->priv->adapter->connect_status =3D=3D LIBERTAS_CONNECTED)
-			netif_wake_queue(card->priv->dev);
-		/* fallthrought */
-	default:
+=09
+	} else {
+		if(int_cause & IF_CS_H_IC_TX_OVER) {
+			card->priv->dnld_sent =3D DNLD_RES_RECEIVED;
+			if (!card->priv->adapter->cur_cmd)=20
+				wake_up_interruptible(&card->priv->waitq);
+		=09
+			if (card->priv->adapter->connect_status =3D=3D LIBERTAS_CONNECTED)=20
+				netif_wake_queue(card->priv->dev);		=09
+		}
+	=09
 		/* clear interrupt */
 		if_cs_write16(card, IF_CS_C_INT_CAUSE, int_cause & IF_CS_C_IC_MASK);
-		if_cs_disable_ints(card);
 	}
=20
 	libertas_interrupt(card->priv->dev);
@@ -398,10 +402,12 @@ static struct sk_buff *if_cs_receive_data(wlan_pr=
ivate *priv)
 	}
=20
 	//TODO: skb =3D dev_alloc_skb(len+ETH_FRAME_LEN+MRVDRV_SNAP_HEADER_LE=
N+EXTRA_LEN);
-	skb =3D dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE);
+	skb =3D dev_alloc_skb(MRVDRV_ETH_RX_PACKET_BUFFER_SIZE + 2);
 	if (!skb)
 		goto out;
-	data =3D skb_put(skb, len);
+	skb_put(skb, len);
+	skb_reserve(skb, 2);/* 16 byte align */
+	data =3D skb->data;
=20
 	/* read even number of bytes, then odd byte if necessary */
 	if_cs_read16_rep(priv->card, IF_CS_H_READ, data, len/sizeof(u16));
@@ -617,11 +623,12 @@ static int if_cs_host_to_card(wlan_private *priv,=
 u8 type, u8 *buf, u16 nb)
=20
 	switch (type) {
 	case MVMS_DAT:
-		priv->dnld_sent =3D DNLD_CMD_SENT;
+		priv->dnld_sent =3D DNLD_DATA_SENT;
 		if_cs_send_data(priv, buf, nb);
 		ret =3D 0;
 		break;
 	case MVMS_CMD:
+		priv->dnld_sent =3D DNLD_CMD_SENT;
 		ret =3D if_cs_send_cmd(priv, buf, nb);
 		break;
 	default:
@@ -651,7 +658,6 @@ static int if_cs_get_int_status(wlan_private *priv,=
 u8 *ireg)
 	if_cs_write16(card, IF_CS_C_INT_CAUSE, int_cause);
=20
 	*ireg =3D if_cs_read16(card, IF_CS_C_STATUS) & IF_CS_C_S_MASK;
-	if_cs_enable_ints(card);
=20
 	if (!*ireg)
 		goto sbi_get_int_status_exit;
@@ -840,7 +846,6 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
 	       p_dev->irq.AssignedIRQ, p_dev->io.BasePort1,
 	       p_dev->io.BasePort1 + p_dev->io.NumPorts1 - 1);
=20
-	if_cs_enable_ints(card);
=20
 	/* Load the firmware early, before calling into libertas.ko */
 	ret =3D if_cs_prog_helper(card);
@@ -873,6 +878,8 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
 		goto out3;
 	}
=20
+	if_cs_enable_ints(card);
+
 	/* And finally bring the card up */
 	if (libertas_start_card(priv) !=3D 0) {
 		lbs_pr_err("could not activate card\n");
@@ -908,6 +915,7 @@ static void if_cs_detach(struct pcmcia_device *p_de=
v)
=20
 	libertas_stop_card(card->priv);
 	libertas_remove_card(card->priv);
+	if_cs_disable_ints(card);
 	if_cs_release(p_dev);
 	kfree(card);
=20
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wirel=
ess/libertas/if_usb.c
index 105a00a..8a3c70e 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -1044,8 +1044,10 @@ static void if_usb_exit_module(void)
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
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireles=
s/libertas/join.c
index ce49d3f..72f8120 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -550,8 +550,8 @@ int libertas_cmd_80211_ad_hoc_start(wlan_private * =
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
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireles=
s/libertas/scan.c
index e2e9ebc..e99fd64 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -13,6 +13,8 @@
 #include <net/ieee80211.h>
 #include <net/iw_handler.h>
=20
+#include <asm/unaligned.h>
+
 #include "host.h"
 #include "decl.h"
 #include "dev.h"
@@ -886,7 +888,7 @@ static int libertas_process_bss(struct bss_descript=
or * bss,
=20
 	if (*bytesleft >=3D sizeof(beaconsize)) {
 		/* Extract & convert beacon size from the command buffer */
-		beaconsize =3D le16_to_cpup((void *)*pbeaconinfo);
+		beaconsize =3D le16_to_cpu(get_unaligned((u16 *)*pbeaconinfo));
 		*bytesleft -=3D sizeof(beaconsize);
 		*pbeaconinfo +=3D sizeof(beaconsize);
 	}
@@ -1696,10 +1698,10 @@ int libertas_ret_80211_scan(wlan_private * priv=
, struct cmd_ds_command *resp)
 		goto done;
 	}
=20
-	bytesleft =3D le16_to_cpu(pscan->bssdescriptsize);
+	bytesleft =3D le16_to_cpu(get_unaligned((u16*)&pscan->bssdescriptsize=
));
 	lbs_deb_scan("SCAN_RESP: bssdescriptsize %d\n", bytesleft);
=20
-	scanrespsize =3D le16_to_cpu(resp->size);
+	scanrespsize =3D le16_to_cpu(get_unaligned((u16*)&resp->size));
 	lbs_deb_scan("SCAN_RESP: returned %d AP before parsing\n",
 	       pscan->nr_sets);
=20

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

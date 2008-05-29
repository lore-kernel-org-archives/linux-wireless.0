Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:42423 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbYE2USc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 16:18:32 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3083607wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2008 13:18:29 -0700 (PDT)
Subject: [PATCH 15/37] wireless: use get/put_endian helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch <linux-arch@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 29 May 2008 13:18:28 -0700
Message-Id: <1212092308.28403.117.camel@brick> (sfid-20080529_221900_617991_210BEC75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/adm8211.c             |   11 ++++-----
 drivers/net/wireless/airo.c                |   10 ++++----
 drivers/net/wireless/hostap/hostap_ioctl.c |    6 ++--
 drivers/net/wireless/ipw2200.c             |   19 ++++++---------
 drivers/net/wireless/libertas/cmd.c        |    6 +---
 drivers/net/wireless/libertas/if_usb.c     |    6 ++--
 drivers/net/wireless/libertas/scan.c       |    4 +-
 drivers/net/wireless/orinoco.c             |    2 +-
 drivers/net/wireless/prism54/islpci_eth.c  |    2 +-
 drivers/net/wireless/prism54/islpci_mgt.h  |    6 -----
 drivers/net/wireless/rtl8180_dev.c         |    4 +-
 drivers/net/wireless/zd1201.c              |   34 ++++++++++++++--------------
 drivers/net/wireless/zd1211rw/zd_mac.c     |    2 +-
 drivers/net/wireless/zd1211rw/zd_usb.c     |    2 +-
 14 files changed, 51 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 5c0d2b0..8405e3d 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1293,7 +1293,7 @@ static void adm8211_set_bssid(struct ieee80211_hw *dev, const u8 *bssid)
 	struct adm8211_priv *priv = dev->priv;
 	u32 reg;
 
-	ADM8211_CSR_WRITE(BSSID0, le32_to_cpu(*(__le32 *)bssid));
+	ADM8211_CSR_WRITE(BSSID0, get_le32((__le32 *)bssid));
 	reg = ADM8211_CSR_READ(ABDA1);
 	reg &= 0x0000ffff;
 	reg |= (bssid[4] << 16) | (bssid[5] << 24);
@@ -1425,8 +1425,8 @@ static int adm8211_add_interface(struct ieee80211_hw *dev,
 
 	ADM8211_IDLE();
 
-	ADM8211_CSR_WRITE(PAR0, le32_to_cpu(*(__le32 *)conf->mac_addr));
-	ADM8211_CSR_WRITE(PAR1, le16_to_cpu(*(__le16 *)(conf->mac_addr + 4)));
+	ADM8211_CSR_WRITE(PAR0, get_le32((__le32 *)conf->mac_addr));
+	ADM8211_CSR_WRITE(PAR1, get_le16((__le16 *)(conf->mac_addr + 4)));
 
 	adm8211_update_mode(dev);
 
@@ -1881,9 +1881,8 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 		goto err_iounmap;
 	}
 
-	*(__le32 *)perm_addr = cpu_to_le32(ADM8211_CSR_READ(PAR0));
-	*(__le16 *)&perm_addr[4] =
-		cpu_to_le16(ADM8211_CSR_READ(PAR1) & 0xFFFF);
+	put_le32(ADM8211_CSR_READ(PAR0), (__le32 *)perm_addr);
+	put_le16(ADM8211_CSR_READ(PAR1) & 0xFFFF, (__le16 *)&perm_addr[4]);
 
 	if (!is_valid_ether_addr(perm_addr)) {
 		printk(KERN_WARNING "%s (adm8211): Invalid hwaddr in EEPROM!\n",
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 4e1c690..fe19d03 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1640,7 +1640,7 @@ static void emmh32_setseed(emmh32_context *context, u8 *pkey, int keylen,
 		crypto_cipher_encrypt_one(tfm, plain, plain);
 		cipher = plain;
 		for (j = 0; (j < 16) && (i < ARRAY_SIZE(context->coeff)); ) {
-			context->coeff[i++] = ntohl(*(__be32 *)&cipher[j]);
+			context->coeff[i++] = get_be32((__be32 *)&cipher[j]);
 			j += 4;
 		}
 	}
@@ -1678,7 +1678,7 @@ static void emmh32_update(emmh32_context *context, u8 *pOctets, int len)
 
 	/* deal with full 32-bit words */
 	while (len >= 4) {
-		MIC_ACCUM(ntohl(*(__be32 *)pOctets));
+		MIC_ACCUM(get_be32((__be32 *)pOctets));
 		context->position += 4;
 		pOctets += 4;
 		len -= 4;
@@ -4087,7 +4087,7 @@ static int PC4500_readrid(struct airo_info *ai, u16 rid, void *pBuf, int len, in
 		// read the rid length field
 		bap_read(ai, pBuf, 2, BAP1);
 		// length for remaining part of rid
-		len = min(len, (int)le16_to_cpu(*(__le16*)pBuf)) - 2;
+		len = min(len, (int)get_le16((__le16 *)pBuf)) - 2;
 
 		if ( len <= 2 ) {
 			airo_print_err(ai->dev->name,
@@ -4113,7 +4113,7 @@ static int PC4500_writerid(struct airo_info *ai, u16 rid,
 	u16 status;
 	int rc = SUCCESS;
 
-	*(__le16*)pBuf = cpu_to_le16((u16)len);
+	put_le16((u16)len, (__le16 *)pBuf);
 
 	if (lock) {
 		if (down_interruptible(&ai->sem))
@@ -4293,7 +4293,7 @@ static int transmit_802_11_packet(struct airo_info *ai, int len, char *pPacket)
 	u16 txFid = len;
 	len >>= 16;
 
-	fc = *(__le16*)pPacket;
+	fc = *(__le16 *)pPacket;
 	hdrlen = header_len(fc);
 
 	if (len < hdrlen) {
diff --git a/drivers/net/wireless/hostap/hostap_ioctl.c b/drivers/net/wireless/hostap/hostap_ioctl.c
index 0ca0bfe..b44f502 100644
--- a/drivers/net/wireless/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/hostap/hostap_ioctl.c
@@ -84,7 +84,7 @@ static int prism2_get_datarates(struct net_device *dev, u8 *rates)
 	if (len < 2)
 		return 0;
 
-	val = le16_to_cpu(*(__le16 *) buf); /* string length */
+	val = get_le16((__le16 *)buf); /* string length */
 
 	if (len - 2 < val || val > 10)
 		return 0;
@@ -812,7 +812,7 @@ static int prism2_ioctl_giwnickn(struct net_device *dev,
 
 	len = local->func->get_rid(dev, HFA384X_RID_CNFOWNNAME,
 				   &name, MAX_NAME_LEN + 2, 0);
-	val = le16_to_cpu(*(__le16 *) name);
+	val = get_le16((__le16 *)name);
 	if (len > MAX_NAME_LEN + 2 || len < 0 || val > MAX_NAME_LEN)
 		return -EOPNOTSUPP;
 
@@ -963,7 +963,7 @@ static int prism2_ioctl_giwessid(struct net_device *dev,
 		memset(ssid, 0, sizeof(ssid));
 		len = local->func->get_rid(dev, HFA384X_RID_CURRENTSSID,
 					   &ssid, MAX_SSID_LEN + 2, 0);
-		val = le16_to_cpu(*(__le16 *) ssid);
+		val = get_le16((__le16 *)ssid);
 		if (len > MAX_SSID_LEN + 2 || len < 0 || val > MAX_SSID_LEN) {
 			return -EOPNOTSUPP;
 		}
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index d74c061..e72ecd0 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -10442,20 +10442,17 @@ static void ipw_handle_promiscuous_tx(struct ipw_priv *priv,
 		rt_hdr->it_present = 0; /* after all, it's just an idea */
 		rt_hdr->it_present |=  cpu_to_le32(1 << IEEE80211_RADIOTAP_CHANNEL);
 
-		*(__le16*)skb_put(dst, sizeof(u16)) = cpu_to_le16(
-			ieee80211chan2mhz(priv->channel));
+		put_le16(ieee80211chan2mhz(priv->channel),
+			 (__le16 *)skb_put(dst, sizeof(__le16)));
 		if (priv->channel > 14) 	/* 802.11a */
-			*(__le16*)skb_put(dst, sizeof(u16)) =
-				cpu_to_le16(IEEE80211_CHAN_OFDM |
-					     IEEE80211_CHAN_5GHZ);
+			put_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ,
+				 (__le16 *)skb_put(dst, sizeof(__le16)));
 		else if (priv->ieee->mode == IEEE_B) /* 802.11b */
-			*(__le16*)skb_put(dst, sizeof(u16)) =
-				cpu_to_le16(IEEE80211_CHAN_CCK |
-					     IEEE80211_CHAN_2GHZ);
+			put_le16(IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ,
+				 (__le16 *)skb_put(dst, sizeof(__le16)));
 		else 		/* 802.11g */
-			*(__le16*)skb_put(dst, sizeof(u16)) =
-				cpu_to_le16(IEEE80211_CHAN_OFDM |
-				 IEEE80211_CHAN_2GHZ);
+			put_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ,
+				 (__le16 *)skb_put(dst, sizeof(__le16)));
 
 		rt_hdr->it_len = cpu_to_le16(dst->len);
 
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 6328b95..180fbe5 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -575,9 +575,7 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 				pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
 				pSNMPMIB->bufsize = cpu_to_le16(sizeof(u16));
 				ulTemp = *((u32 *)pdata_buf);
-				*(__le16 *)(pSNMPMIB->value) =
-				    cpu_to_le16((u16) ulTemp);
-
+				put_le16(ulTemp, (__le16 *)pSNMPMIB->value);
 			}
 			break;
 		}
@@ -607,7 +605,7 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
 	       "SNMP_CMD: action 0x%x, oid 0x%x, oidsize 0x%x, value 0x%x\n",
 	       le16_to_cpu(pSNMPMIB->querytype), le16_to_cpu(pSNMPMIB->oid),
 	       le16_to_cpu(pSNMPMIB->bufsize),
-	       le16_to_cpu(*(__le16 *) pSNMPMIB->value));
+	       get_le16((__le16 *)pSNMPMIB->value));
 
 	lbs_deb_leave(LBS_DEB_CMD);
 	return 0;
diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index 8032df7..052742c 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -351,7 +351,7 @@ static int if_usb_reset_device(struct if_usb_card *cardp)
 
 	lbs_deb_enter(LBS_DEB_USB);
 
-	*(__le32 *)cardp->ep_out_buf = cpu_to_le32(CMD_TYPE_REQUEST);
+	put_le32(CMD_TYPE_REQUEST, (__le32 *)cardp->ep_out_buf);
 
 	cmd->command = cpu_to_le16(CMD_802_11_RESET);
 	cmd->size = cpu_to_le16(sizeof(struct cmd_ds_802_11_reset) + S_DS_GEN);
@@ -705,10 +705,10 @@ static int if_usb_host_to_card(struct lbs_private *priv, uint8_t type,
 	lbs_deb_usbd(&cardp->udev->dev,"size after = %d\n", nb);
 
 	if (type == MVMS_CMD) {
-		*(__le32 *)cardp->ep_out_buf = cpu_to_le32(CMD_TYPE_REQUEST);
+		put_le32(CMD_TYPE_REQUEST, (__le32 *)cardp->ep_out_buf);
 		priv->dnld_sent = DNLD_CMD_SENT;
 	} else {
-		*(__le32 *)cardp->ep_out_buf = cpu_to_le32(CMD_TYPE_DATA);
+		put_le32(CMD_TYPE_DATA, (__le32 *)cardp->ep_out_buf);
 		priv->dnld_sent = DNLD_DATA_SENT;
 	}
 
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index d448c97..4c94a46 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -567,11 +567,11 @@ static int lbs_process_bss(struct bss_descriptor *bss,
 	pos += 8;
 
 	/* beacon interval is 2 bytes long */
-	bss->beaconperiod = le16_to_cpup((void *) pos);
+	bss->beaconperiod = get_le16((__le16 *)pos);
 	pos += 2;
 
 	/* capability information is 2 bytes long */
-	bss->capability = le16_to_cpup((void *) pos);
+	bss->capability = get_le16((__le16 *)pos);
 	lbs_deb_scan("process_bss: capabilities 0x%04x\n", bss->capability);
 	pos += 2;
 
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 6d13a0d..f34330c 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -1167,7 +1167,7 @@ static int orinoco_process_scan_results(struct net_device *dev,
 	case FIRMWARE_TYPE_INTERSIL:
 		offset = 4;
 		if (priv->has_hostscan) {
-			atom_len = le16_to_cpup((__le16 *)buf);
+			atom_len = get_le16((__le16 *)buf);
 			/* Sanity check for atom_len */
 			if (atom_len < sizeof(struct prism2_scan_apinfo)) {
 				printk(KERN_ERR "%s: Invalid atom_len in scan "
diff --git a/drivers/net/wireless/prism54/islpci_eth.c b/drivers/net/wireless/prism54/islpci_eth.c
index 762e85b..8f1ae0a 100644
--- a/drivers/net/wireless/prism54/islpci_eth.c
+++ b/drivers/net/wireless/prism54/islpci_eth.c
@@ -471,7 +471,7 @@ islpci_eth_receive(islpci_private *priv)
 		wmb();
 
 		/* increment the driver read pointer */
-		add_le32p(&control_block->
+		le32_add_cpu(&control_block->
 			  driver_curr_frag[ISL38XX_CB_RX_DATA_LQ], 1);
 	}
 
diff --git a/drivers/net/wireless/prism54/islpci_mgt.h b/drivers/net/wireless/prism54/islpci_mgt.h
index f91a88f..87a1734 100644
--- a/drivers/net/wireless/prism54/islpci_mgt.h
+++ b/drivers/net/wireless/prism54/islpci_mgt.h
@@ -85,12 +85,6 @@ extern int pc_debug;
 #define PIMFOR_FLAG_APPLIC_ORIGIN               0x01
 #define PIMFOR_FLAG_LITTLE_ENDIAN               0x02
 
-static inline void
-add_le32p(__le32 * le_number, u32 add)
-{
-	*le_number = cpu_to_le32(le32_to_cpup(le_number) + add);
-}
-
 void display_buffer(char *, int);
 
 /*
diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index c181f23..d8d2ca3 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -688,9 +688,9 @@ static int rtl8180_add_interface(struct ieee80211_hw *dev,
 
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	rtl818x_iowrite32(priv, (__le32 __iomem *)&priv->map->MAC[0],
-			  le32_to_cpu(*(__le32 *)conf->mac_addr));
+			  get_le32((__le32 *)conf->mac_addr));
 	rtl818x_iowrite16(priv, (__le16 __iomem *)&priv->map->MAC[4],
-			  le16_to_cpu(*(__le16 *)(conf->mac_addr + 4)));
+			  get_le16((__le16 *)(conf->mac_addr + 4)));
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
 	return 0;
diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index d5c0c66..08d8487 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -224,13 +224,13 @@ static void zd1201_usbrx(struct urb *urb)
 	if (type == ZD1201_PACKET_INQUIRE) {
 		int i = 0;
 		unsigned short infotype, framelen, copylen;
-		framelen = le16_to_cpu(*(__le16*)&data[4]);
-		infotype = le16_to_cpu(*(__le16*)&data[6]);
+		framelen = get_le16((__le16 *)&data[4]);
+		infotype = get_le16((__le16 *)&data[6]);
 
 		if (infotype == ZD1201_INF_LINKSTATUS) {
 			short linkstatus;
 
-			linkstatus = le16_to_cpu(*(__le16*)&data[8]);
+			linkstatus = get_le16((__le16 *)&data[8]);
 			switch(linkstatus) {
 				case 1:
 					netif_carrier_on(zd->dev);
@@ -250,7 +250,7 @@ static void zd1201_usbrx(struct urb *urb)
 			goto resubmit;
 		}
 		if (infotype == ZD1201_INF_ASSOCSTATUS) {
-			short status = le16_to_cpu(*(__le16*)(data+8));
+			short status = get_le16((__le16 *)(data + 8));
 			int event;
 			union iwreq_data wrqu;
 
@@ -288,7 +288,7 @@ static void zd1201_usbrx(struct urb *urb)
 		/* Other infotypes are handled outside this handler */
 		zd->rxlen = 0;
 		while (i < urb->actual_length) {
-			copylen = le16_to_cpu(*(__le16*)&data[i+2]);
+			copylen = get_le16((__le16 *)&data[i + 2]);
 			/* Sanity check, sometimes we get junk */
 			if (copylen+zd->rxlen > sizeof(zd->rxdata))
 				break;
@@ -311,8 +311,8 @@ static void zd1201_usbrx(struct urb *urb)
 		len = ntohs(*(__be16 *)&data[datalen-2]);
 		if (len>datalen)
 			len=datalen;
-		fc = le16_to_cpu(*(__le16 *)&data[datalen-16]);
-		seq = le16_to_cpu(*(__le16 *)&data[datalen-24]);
+		fc = get_le16((__le16 *)&data[datalen - 16]);
+		seq = get_le16((__le16 *)&data[datalen - 24]);
 
 		if (zd->monitor) {
 			if (datalen < 24)
@@ -427,9 +427,9 @@ static int zd1201_getconfig(struct zd1201 *zd, int rid, void *riddata,
 	if (!zd->rxlen)
 		return -EIO;
 
-	code = le16_to_cpu(*(__le16*)(&zd->rxdata[4]));
-	rid_fid = le16_to_cpu(*(__le16*)(&zd->rxdata[6]));
-	length = le16_to_cpu(*(__le16*)(&zd->rxdata[8]));
+	code = get_le16((__le16 *)&zd->rxdata[4]);
+	rid_fid = get_le16((__le16 *)&zd->rxdata[6]);
+	length = get_le16((__le16 *)&zd->rxdata[8]);
 	if (length > zd->rxlen)
 		length = zd->rxlen-6;
 
@@ -538,8 +538,8 @@ static int zd1201_setconfig(struct zd1201 *zd, int rid, void *buf, int len, int
 		request[3] = 0;
 		if (request[1] == 0) {
 			/* add header */
-			*(__le16*)&request[4] = cpu_to_le16((len-2+1)/2);
-			*(__le16*)&request[6] = cpu_to_le16(rid);
+			put_le16((len - 2 + 1) / 2, (__le16 *)&request[4]);
+			put_le16(rid, (__le16 *)&request[6]);
 			memcpy(request+8, buf, reqlen-4);
 			buf += reqlen-4;
 		} else {
@@ -578,7 +578,7 @@ static int zd1201_setconfig(struct zd1201 *zd, int rid, void *buf, int len, int
 	
 	if (wait) {
 		wait_event_interruptible(zd->rxdataq, zd->rxdatas);
-		if (!zd->rxlen || le16_to_cpu(*(__le16*)&zd->rxdata[6]) != rid) {
+		if (!zd->rxlen || get_le16((__le16 *)&zd->rxdata[6]) != rid) {
 			dev_dbg(&zd->usb->dev, "wrong or no RID received\n");
 		}
 	}
@@ -716,7 +716,7 @@ static int zd1201_join(struct zd1201 *zd, char *essid, int essidlen)
 	if (err)
 		return err;
 
-	*(__le16 *)buf = cpu_to_le16(essidlen);
+	put_le16(essidlen, (__le16 *)buf);
 	memcpy(buf+2, essid, essidlen);
 	if (!zd->ap) {	/* Normal station */
 		err = zd1201_setconfig(zd, ZD1201_RID_CNFDESIREDSSID, buf,
@@ -998,7 +998,7 @@ static int zd1201_set_mode(struct net_device *dev,
 		return err;
 	if (zd->monitor && !monitor) {
 			zd1201_disable(zd);
-			*(__le16 *)buffer = cpu_to_le16(zd->essidlen);
+			put_le16(zd->essidlen, (__le16 *)buffer);
 			memcpy(buffer+2, zd->essid, zd->essidlen);
 			err = zd1201_setconfig(zd, ZD1201_RID_CNFDESIREDSSID,
 			    buffer, IW_ESSID_MAX_SIZE+2, 1);
@@ -1145,7 +1145,7 @@ static int zd1201_get_scan(struct net_device *dev,
 	if (!zd->rxlen)
 		return -EIO;
 
-	if (le16_to_cpu(*(__le16*)&zd->rxdata[2]) != ZD1201_INQ_SCANRESULTS)
+	if (get_le16((__le16 *)&zd->rxdata[2]) != ZD1201_INQ_SCANRESULTS)
 		return -EIO;
 
 	for(i=8; i<zd->rxlen; i+=62) {
@@ -1793,7 +1793,7 @@ static int zd1201_probe(struct usb_interface *interface,
 		goto err_net;
 
 	/* Set wildcard essid to match zd->essid */
-	*(__le16 *)buf = cpu_to_le16(0);
+	put_le16(0, (__le16 *)buf);
 	err = zd1201_setconfig(zd, ZD1201_RID_CNFDESIREDSSID, buf,
 	    IW_ESSID_MAX_SIZE+2, 1);
 	if (err)
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 6424e5a..93cb3c3 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -805,7 +805,7 @@ void zd_process_intr(struct work_struct *work)
 	u16 int_status;
 	struct zd_mac *mac = container_of(work, struct zd_mac, process_intr);
 
-	int_status = le16_to_cpu(*(__le16 *)(mac->intr_buffer+4));
+	int_status = get_le16((__le16 *)(mac->intr_buffer + 4));
 	if (int_status & INT_CFG_NEXT_BCN) {
 		if (net_ratelimit())
 			dev_dbg_f(zd_mac_dev(mac), "INT_CFG_NEXT_BCN\n");
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 8941f5e..ccf9c8b 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -342,7 +342,7 @@ static inline void handle_regs_int(struct urb *urb)
 	ZD_ASSERT(in_interrupt());
 	spin_lock(&intr->lock);
 
-	int_num = le16_to_cpu(*(__le16 *)(urb->transfer_buffer+2));
+	int_num = get_le16((__le16 *)(urb->transfer_buffer + 2));
 	if (int_num == CR_INTERRUPT) {
 		struct zd_mac *mac = zd_hw_mac(zd_usb_to_hw(urb->context));
 		memcpy(&mac->intr_buffer, urb->transfer_buffer,
-- 
1.5.6.rc0.277.g804cf



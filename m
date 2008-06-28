Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:21779 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbYF1Sjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 14:39:54 -0400
Received: by nf-out-0910.google.com with SMTP id d3so259538nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 11:39:53 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [RFC PATCH 19/19] orinoco: Add MIC on TX and check on RX
Date: Sat, 28 Jun 2008 19:38:25 +0100
Message-Id: <1214678305-7057-20-git-send-email-kilroyd@gmail.com> (sfid-20080628_210814_142600_52344B79)
In-Reply-To: <1214678305-7057-19-git-send-email-kilroyd@gmail.com>
References: <1214678305-7057-1-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-2-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-3-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-4-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-5-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-6-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-7-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-8-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-9-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-10-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-11-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-12-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-13-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-14-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-15-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-16-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-17-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-18-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-19-git-send-email-kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the MIC algorithm from the crypto subsystem.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/Kconfig   |    2 +
 drivers/net/wireless/hermes.h  |    7 ++
 drivers/net/wireless/orinoco.c |  234 +++++++++++++++++++++++++++++++++++++---
 drivers/net/wireless/orinoco.h |    2 +
 4 files changed, 229 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index beab733..a17def6 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -299,6 +299,8 @@ config HERMES
 	depends on (PPC_PMAC || PCI || PCMCIA) && WLAN_80211
 	select WIRELESS_EXT
 	select FW_LOADER
+	select CRYPTO
+	select CRYPTO_MICHAEL_MIC
 	---help---
 	  A driver for 802.11b wireless cards based on the "Hermes" or
 	  Intersil HFA384x (Prism 2) MAC controller.  This includes the vast
diff --git a/drivers/net/wireless/hermes.h b/drivers/net/wireless/hermes.h
index f4c47da..35cb3ce 100644
--- a/drivers/net/wireless/hermes.h
+++ b/drivers/net/wireless/hermes.h
@@ -184,13 +184,18 @@
 #define HERMES_RXSTAT_ERR		(0x0003)
 #define	HERMES_RXSTAT_BADCRC		(0x0001)
 #define	HERMES_RXSTAT_UNDECRYPTABLE	(0x0002)
+#define	HERMES_RXSTAT_MIC		(0x0010)	/* Frame contains MIC */
 #define	HERMES_RXSTAT_MACPORT		(0x0700)
 #define HERMES_RXSTAT_PCF		(0x1000)	/* Frame was received in CF period */
+#define	HERMES_RXSTAT_MIC_KEY_ID	(0x1800)	/* MIC key used */
 #define	HERMES_RXSTAT_MSGTYPE		(0xE000)
 #define	HERMES_RXSTAT_1042		(0x2000)	/* RFC-1042 frame */
 #define	HERMES_RXSTAT_TUNNEL		(0x4000)	/* bridge-tunnel encoded frame */
 #define	HERMES_RXSTAT_WMP		(0x6000)	/* Wavelan-II Management Protocol frame */
 
+/* Shift amount for key ID in RXSTAT and TXCTRL */
+#define	HERMES_MIC_KEY_ID_SHIFT		11
+
 struct hermes_tx_descriptor {
 	__le16 status;
 	__le16 reserved1;
@@ -209,6 +214,8 @@ struct hermes_tx_descriptor {
 #define HERMES_TXCTRL_TX_OK		(0x0002)	/* ?? interrupt on Tx complete */
 #define HERMES_TXCTRL_TX_EX		(0x0004)	/* ?? interrupt on Tx exception */
 #define HERMES_TXCTRL_802_11		(0x0008)	/* We supply 802.11 header */
+#define HERMES_TXCTRL_MIC		(0x0010)	/* 802.3 + TKIP */
+#define HERMES_TXCTRL_MIC_KEY_ID	(0x1800)	/* MIC Key ID mask */
 #define HERMES_TXCTRL_ALT_RTRY		(0x0020)
 
 /* Inquiry constants and data types */
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 4d85f61..3bfdbde 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -89,6 +89,9 @@
 #include <net/iw_handler.h>
 #include <net/ieee80211.h>
 
+#include <linux/scatterlist.h>
+#include <linux/crypto.h>
+
 #include "hermes_rid.h"
 #include "hermes_dld.h"
 #include "orinoco.h"
@@ -244,6 +247,74 @@ static int __orinoco_program_rids(struct net_device *dev);
 static void __orinoco_set_multicast_list(struct net_device *dev);
 
 /********************************************************************/
+/* Michael MIC crypto setup                                         */
+/********************************************************************/
+#define MICHAEL_MIC_LEN 8
+static int orinoco_mic_init(struct orinoco_private *priv)
+{
+	priv->tx_tfm_mic = crypto_alloc_hash("michael_mic", 0, 0);
+	if (IS_ERR(priv->tx_tfm_mic)) {
+		printk(KERN_DEBUG "orinoco_mic_init: could not allocate "
+		       "crypto API michael_mic\n");
+		priv->tx_tfm_mic = NULL;
+		return -ENOMEM;
+	}
+
+	priv->rx_tfm_mic = crypto_alloc_hash("michael_mic", 0, 0);
+	if (IS_ERR(priv->rx_tfm_mic)) {
+		printk(KERN_DEBUG "orinoco_mic_init: could not allocate "
+		       "crypto API michael_mic\n");
+		priv->rx_tfm_mic = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void orinoco_mic_free(struct orinoco_private *priv)
+{
+	if (priv->tx_tfm_mic)
+		crypto_free_hash(priv->tx_tfm_mic);
+	if (priv->rx_tfm_mic)
+		crypto_free_hash(priv->rx_tfm_mic);
+}
+
+static int michael_mic(struct crypto_hash *tfm_michael, u8 *key,
+		       u8 *da, u8 *sa, u8 priority,
+		       u8 *data, size_t data_len, u8 *mic)
+{
+	struct hash_desc desc;
+	struct scatterlist sg[2];
+	u8 hdr[ETH_HLEN + 2]; /* size of header + padding */
+
+	if (tfm_michael == NULL) {
+		printk(KERN_WARNING "michael_mic: tfm_michael == NULL\n");
+		return -1;
+	}
+
+	/* Copy header into buffer. We need the padding on the end zeroed */
+	memcpy(&hdr[0], da, ETH_ALEN);
+	memcpy(&hdr[ETH_ALEN], sa, ETH_ALEN);
+	hdr[ETH_ALEN*2] = priority;
+	hdr[ETH_ALEN*2+1] = 0;
+	hdr[ETH_ALEN*2+2] = 0;
+	hdr[ETH_ALEN*2+3] = 0;
+
+	/* Use scatter gather to MIC header and data in one go */
+	sg_init_table(sg, 2);
+	sg_set_buf(&sg[0], hdr, sizeof(hdr));
+	sg_set_buf(&sg[1], data, data_len);
+
+	if (crypto_hash_setkey(tfm_michael, key, MIC_KEYLEN))
+		return -1;
+
+	desc.tfm = tfm_michael;
+	desc.flags = 0;
+	return crypto_hash_digest(&desc, sg, data_len + sizeof(hdr),
+				  mic);
+}
+
+/********************************************************************/
 /* Internal helper functions                                        */
 /********************************************************************/
 
@@ -764,7 +835,6 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 	int err = 0;
 	u16 txfid = priv->txfid;
 	struct ethhdr *eh;
-	int data_off;
 	int tx_control;
 	unsigned long flags;
 
@@ -797,10 +867,12 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (skb->len < ETH_HLEN)
 		goto drop;
 
-	eh = (struct ethhdr *)skb->data;
-
 	tx_control = HERMES_TXCTRL_TX_OK | HERMES_TXCTRL_TX_EX;
 
+	if (priv->encode_alg == IW_ENCODE_ALG_TKIP)
+		tx_control |= (priv->tx_key << HERMES_MIC_KEY_ID_SHIFT) |
+			HERMES_TXCTRL_MIC;
+
 	if (priv->has_alt_txcntl) {
 		/* WPA enabled firmwares have tx_cntl at the end of
 		 * the 802.11 header.  So write zeroed descriptor and
@@ -842,6 +914,8 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 				   HERMES_802_3_OFFSET - HERMES_802_11_OFFSET);
 	}
 
+	eh = (struct ethhdr *)skb->data;
+
 	/* Encapsulate Ethernet-II frames */
 	if (ntohs(eh->h_proto) > ETH_DATA_LEN) { /* Ethernet-II frame */
 		struct header_struct {
@@ -851,33 +925,65 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		/* Strip destination and source from the data */
 		skb_pull(skb, 2 * ETH_ALEN);
-		data_off = HERMES_802_2_OFFSET + sizeof(encaps_hdr);
 
 		/* And move them to a separate header */
 		memcpy(&hdr.eth, eh, 2 * ETH_ALEN);
 		hdr.eth.h_proto = htons(sizeof(encaps_hdr) + skb->len);
 		memcpy(hdr.encap, encaps_hdr, sizeof(encaps_hdr));
 
-		err = hermes_bap_pwrite(hw, USER_BAP, &hdr, sizeof(hdr),
-					txfid, HERMES_802_3_OFFSET);
-		if (err) {
-			if (net_ratelimit())
-				printk(KERN_ERR "%s: Error %d writing packet "
-				       "header to BAP\n", dev->name, err);
-			goto busy;
+		/* Insert the SNAP header */
+		if (skb_headroom(skb) < sizeof(hdr)) {
+			printk(KERN_ERR
+			       "%s: Not enough headroom for 802.2 headers %d\n",
+			       dev->name, skb_headroom(skb));
+			goto drop;
 		}
-	} else { /* IEEE 802.3 frame */
-		data_off = HERMES_802_3_OFFSET;
+		eh = (struct ethhdr *) skb_push(skb, sizeof(hdr));
+		memcpy(eh, &hdr, sizeof(hdr));
 	}
 
 	err = hermes_bap_pwrite(hw, USER_BAP, skb->data, skb->len,
-				txfid, data_off);
+				txfid, HERMES_802_3_OFFSET);
 	if (err) {
 		printk(KERN_ERR "%s: Error %d writing packet to BAP\n",
 		       dev->name, err);
 		goto busy;
 	}
 
+	/* Calculate Michael MIC */
+	if (priv->encode_alg == IW_ENCODE_ALG_TKIP) {
+		u8 mic_buf[MICHAEL_MIC_LEN + 1];
+		u8 *mic;
+		size_t offset;
+		size_t len;
+
+		if (skb->len % 2) {
+			/* MIC start is on an odd boundary */
+			mic_buf[0] = skb->data[skb->len - 1];
+			mic = &mic_buf[1];
+			offset = skb->len - 1;
+			len = MICHAEL_MIC_LEN + 1;
+		} else {
+			mic = &mic_buf[0];
+			offset = skb->len;
+			len = MICHAEL_MIC_LEN;
+		}
+
+		michael_mic(priv->tx_tfm_mic,
+			    priv->tkip_key[priv->tx_key].tx_mic,
+			    eh->h_dest, eh->h_source, 0 /* priority */,
+			    skb->data + ETH_HLEN, skb->len - ETH_HLEN, mic);
+
+		/* Write the MIC */
+		err = hermes_bap_pwrite(hw, USER_BAP, &mic_buf[0], len,
+					txfid, HERMES_802_3_OFFSET + offset);
+		if (err) {
+			printk(KERN_ERR "%s: Error %d writing MIC to BAP\n",
+			       dev->name, err);
+			goto busy;
+		}
+	}
+
 	/* Finally, we actually initiate the send */
 	netif_stop_queue(dev);
 
@@ -892,7 +998,7 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	dev->trans_start = jiffies;
-	stats->tx_bytes += data_off + skb->len;
+	stats->tx_bytes += HERMES_802_3_OFFSET + skb->len;
 	goto ok;
 
  drop:
@@ -1172,6 +1278,25 @@ static void orinoco_rx_monitor(struct net_device *dev, u16 rxfid,
 	stats->rx_dropped++;
 }
 
+/* Get tsc from the firmware */
+static int orinoco_hw_get_tkip_iv(struct orinoco_private *priv, int key,
+				  u8 *tsc)
+{
+	hermes_t *hw = &priv->hw;
+	int err = 0;
+	u8 tsc_arr[4][IW_ENCODE_SEQ_MAX_SIZE];
+
+	if ((key < 0) || (key > 4))
+		return -EINVAL;
+
+	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENT_TKIP_IV,
+			      sizeof(tsc_arr), NULL, &tsc_arr);
+	if (!err)
+		memcpy(tsc, &tsc_arr[key][0], sizeof(tsc_arr[0]));
+
+	return err;
+}
+
 static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
@@ -1240,6 +1365,11 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 		goto update_stats;
 	}
 
+	/* Payload size does not include Michael MIC. Increase payload
+	 * size to read it together with the data. */
+	if (status & HERMES_RXSTAT_MIC)
+		length += MICHAEL_MIC_LEN;
+
 	/* We need space for the packet data itself, plus an ethernet
 	   header, plus 2 bytes so we can align the IP header on a
 	   32bit boundary, plus 1 byte so we can read in odd length
@@ -1303,6 +1433,63 @@ static void orinoco_rx(struct net_device *dev,
 	length = le16_to_cpu(desc->data_len);
 	fc = le16_to_cpu(desc->frame_ctl);
 
+	/* Calculate and check MIC */
+	if (status & HERMES_RXSTAT_MIC) {
+		int key_id = ((status & HERMES_RXSTAT_MIC_KEY_ID) >>
+			      HERMES_MIC_KEY_ID_SHIFT);
+		u8 mic[MICHAEL_MIC_LEN];
+		u8 *rxmic;
+		u8 *src = (fc & IEEE80211_FCTL_FROMDS) ?
+			desc->addr3 : desc->addr2;
+
+		/* Extract Michael MIC from payload */
+		rxmic = skb->data + skb->len - MICHAEL_MIC_LEN;
+
+		skb_trim(skb, skb->len - MICHAEL_MIC_LEN);
+		length -= MICHAEL_MIC_LEN;
+
+		michael_mic(priv->rx_tfm_mic,
+			    priv->tkip_key[key_id].rx_mic,
+			    desc->addr1,
+			    src,
+			    0, /* priority or QoS? */
+			    skb->data,
+			    skb->len,
+			    &mic[0]);
+
+		if (memcmp(mic, rxmic,
+			   MICHAEL_MIC_LEN)) {
+			union iwreq_data wrqu;
+			struct iw_michaelmicfailure wxmic;
+			DECLARE_MAC_BUF(mac);
+
+			printk(KERN_WARNING "%s: "
+			       "Invalid Michael MIC in data frame from %s, "
+			       "using key %i\n",
+			       dev->name, print_mac(mac, src), key_id);
+
+			/* TODO: update stats */
+
+			/* Notify userspace */
+			memset(&wxmic, 0, sizeof(wxmic));
+			wxmic.flags = key_id & IW_MICFAILURE_KEY_ID;
+			wxmic.flags |= (desc->addr1[0] & 1) ?
+				IW_MICFAILURE_GROUP : IW_MICFAILURE_PAIRWISE;
+			wxmic.src_addr.sa_family = ARPHRD_ETHER;
+			memcpy(wxmic.src_addr.sa_data, src, ETH_ALEN);
+
+			(void) orinoco_hw_get_tkip_iv(priv, key_id,
+						      &wxmic.tsc[0]);
+
+			memset(&wrqu, 0, sizeof(wrqu));
+			wrqu.data.length = sizeof(wxmic);
+			wireless_send_event(dev, IWEVMICHAELMICFAILURE, &wrqu,
+					    (char *) &wxmic);
+
+			goto drop;
+		}
+	}
+
 	/* Handle decapsulation
 	 * In most cases, the firmware tell us about SNAP frames.
 	 * For some reason, the SNAP frames sent by LinkSys APs
@@ -1342,6 +1529,11 @@ static void orinoco_rx(struct net_device *dev,
 	stats->rx_bytes += length;
 
 	return;
+
+ drop:
+	dev_kfree_skb(skb);
+	stats->rx_errors++;
+	stats->rx_dropped++;
 }
 
 static void orinoco_rx_isr_tasklet(unsigned long data)
@@ -3105,8 +3297,14 @@ static int orinoco_init(struct net_device *dev)
 		else
 			printk("40-bit key\n");
 	}
-	if (priv->has_wpa)
+	if (priv->has_wpa) {
 		printk(KERN_DEBUG "%s: WPA-PSK supported\n", dev->name);
+		if (orinoco_mic_init(priv)) {
+			printk(KERN_ERR "%s: Failed to setup MIC crypto "
+			       "algorithm. Disabling WPA support\n", dev->name);
+			priv->has_wpa = 0;
+		}
+	}
 
 	/* Now we have the firmware capabilities, allocate appropiate
 	 * sized scan buffers */
@@ -3285,6 +3483,9 @@ struct net_device
 	dev->set_multicast_list = orinoco_set_multicast_list;
 	/* we use the default eth_mac_addr for setting the MAC addr */
 
+	/* Reserve space in skb for the SNAP header */
+	dev->hard_header_len += ENCAPS_OVERHEAD;
+
 	/* Set up default callbacks */
 	dev->open = orinoco_open;
 	dev->stop = orinoco_stop;
@@ -3320,6 +3521,7 @@ void free_orinocodev(struct net_device *dev)
 	tasklet_kill(&priv->rx_tasklet);
 	priv->wpa_ie_len = 0;
 	kfree(priv->wpa_ie);
+	orinoco_mic_free(priv);
 	orinoco_bss_data_free(priv);
 	free_netdev(dev);
 }
diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoco.h
index e0c9be3..981570b 100644
--- a/drivers/net/wireless/orinoco.h
+++ b/drivers/net/wireless/orinoco.h
@@ -158,6 +158,8 @@ struct orinoco_private {
 	int wpa_ie_len;
 
 	struct orinoco_tkip_key tkip_key[ORINOCO_MAX_KEYS];
+	struct crypto_hash *rx_tfm_mic;
+	struct crypto_hash *tx_tfm_mic;
 
 	unsigned int wpa_enabled:1;
 	unsigned int tkip_cm_active:1;
-- 
1.5.4.5


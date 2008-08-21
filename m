Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:15324 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759534AbYHUW27 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:28:59 -0400
Received: by ik-out-1112.google.com with SMTP id c28so104766ika.5
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:28:59 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 10/19] orinoco: Fix transmit for Agere/Lucent with fw 9.x
Date: Thu, 21 Aug 2008 23:27:56 +0100
Message-Id: <347f1ce011aaeeb9b4d8f805fdfb6eb58fc467ca.1219352675.git.kilroyd@gmail.com> (sfid-20080822_005040_269556_55C6E50A)
In-Reply-To: <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
 <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
 <24148627bbab77e1365aa43c22a7f24ded1bed7a.1219352674.git.kilroyd@gmail.com>
 <6e9e9826934e0256adbe561e587f93212e042bf2.1219352674.git.kilroyd@gmail.com>
 <77df696e5b53b5e4db3b8c8e70b23cf5aaa2aca2.1219352674.git.kilroyd@gmail.com>
 <ac0da2799e97f5256019ad669f5a6c461bd0d82a.1219352674.git.kilroyd@gmail.com>
 <d792f6b1d5853becf1b1488e6572a4c3244eb769.1219352674.git.kilroyd@gmail.com>
 <6c4f63d9cc1bec763719e18ea8282919b6604503.1219352674.git.kilroyd@gmail.com>
 <9a54acb1147a2c0a7c1cf9b07b9ac756366d0877.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
In-Reply-To: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
References: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tx control word has moved into the 802.11 header area on these
firmwares.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/hermes.h  |    1 +
 drivers/net/wireless/orinoco.c |   59 +++++++++++++++++++++++++++++----------
 drivers/net/wireless/orinoco.h |    1 +
 3 files changed, 46 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/hermes.h b/drivers/net/wireless/hermes.h
index 287f536..1d0c584 100644
--- a/drivers/net/wireless/hermes.h
+++ b/drivers/net/wireless/hermes.h
@@ -179,6 +179,7 @@
 #define HERMES_802_11_OFFSET		(14)
 #define HERMES_802_3_OFFSET		(14+32)
 #define HERMES_802_2_OFFSET		(14+32+14)
+#define HERMES_TXCNTL2_OFFSET		(HERMES_802_3_OFFSET - 2)
 
 #define HERMES_RXSTAT_ERR		(0x0003)
 #define	HERMES_RXSTAT_BADCRC		(0x0001)
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 306697a..b83415d 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -722,7 +722,7 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 	u16 txfid = priv->txfid;
 	struct ethhdr *eh;
 	int data_off;
-	struct hermes_tx_descriptor desc;
+	int tx_control;
 	unsigned long flags;
 
 	if (! netif_running(dev)) {
@@ -756,21 +756,48 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	eh = (struct ethhdr *)skb->data;
 
-	memset(&desc, 0, sizeof(desc));
- 	desc.tx_control = cpu_to_le16(HERMES_TXCTRL_TX_OK | HERMES_TXCTRL_TX_EX);
-	err = hermes_bap_pwrite(hw, USER_BAP, &desc, sizeof(desc), txfid, 0);
-	if (err) {
-		if (net_ratelimit())
-			printk(KERN_ERR "%s: Error %d writing Tx descriptor "
-			       "to BAP\n", dev->name, err);
-		goto busy;
-	}
+	tx_control = HERMES_TXCTRL_TX_OK | HERMES_TXCTRL_TX_EX;
 
-	/* Clear the 802.11 header and data length fields - some
-	 * firmwares (e.g. Lucent/Agere 8.xx) appear to get confused
-	 * if this isn't done. */
-	hermes_clear_words(hw, HERMES_DATA0,
-			   HERMES_802_3_OFFSET - HERMES_802_11_OFFSET);
+	if (priv->has_alt_txcntl) {
+		/* WPA enabled firmwares have tx_cntl at the end of
+		 * the 802.11 header.  So write zeroed descriptor and
+		 * 802.11 header at the same time
+		 */
+		char desc[HERMES_802_3_OFFSET];
+		__le16 *txcntl = (__le16 *) &desc[HERMES_TXCNTL2_OFFSET];
+
+		memset(&desc, 0, sizeof(desc));
+
+		*txcntl = cpu_to_le16(tx_control);
+		err = hermes_bap_pwrite(hw, USER_BAP, &desc, sizeof(desc),
+					txfid, 0);
+		if (err) {
+			if (net_ratelimit())
+				printk(KERN_ERR "%s: Error %d writing Tx "
+				       "descriptor to BAP\n", dev->name, err);
+			goto busy;
+		}
+	} else {
+		struct hermes_tx_descriptor desc;
+
+		memset(&desc, 0, sizeof(desc));
+
+		desc.tx_control = cpu_to_le16(tx_control);
+		err = hermes_bap_pwrite(hw, USER_BAP, &desc, sizeof(desc),
+					txfid, 0);
+		if (err) {
+			if (net_ratelimit())
+				printk(KERN_ERR "%s: Error %d writing Tx "
+				       "descriptor to BAP\n", dev->name, err);
+			goto busy;
+		}
+
+		/* Clear the 802.11 header and data length fields - some
+		 * firmwares (e.g. Lucent/Agere 8.xx) appear to get confused
+		 * if this isn't done. */
+		hermes_clear_words(hw, HERMES_DATA0,
+				   HERMES_802_3_OFFSET - HERMES_802_11_OFFSET);
+	}
 
 	/* Encapsulate Ethernet-II frames */
 	if (ntohs(eh->h_proto) > ETH_DATA_LEN) { /* Ethernet-II frame */
@@ -2528,6 +2555,7 @@ static int determine_firmware(struct net_device *dev)
 	priv->has_ibss = 1;
 	priv->has_wep = 0;
 	priv->has_big_wep = 0;
+	priv->has_alt_txcntl = 0;
 	priv->do_fw_download = 0;
 
 	/* Determine capabilities from the firmware version */
@@ -2550,6 +2578,7 @@ static int determine_firmware(struct net_device *dev)
 		priv->has_hostscan = (firmver >= 0x8000a);
 		priv->do_fw_download = 1;
 		priv->broken_monitor = (firmver >= 0x80000);
+		priv->has_alt_txcntl = (firmver >= 0x90000); /* All 9.x ? */
 
 		/* Tested with Agere firmware :
 		 *	1.16 ; 4.08 ; 4.52 ; 6.04 ; 6.16 ; 7.28 => Jean II
diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoco.h
index e0acb63..f93752f 100644
--- a/drivers/net/wireless/orinoco.h
+++ b/drivers/net/wireless/orinoco.h
@@ -85,6 +85,7 @@ struct orinoco_private {
 	unsigned int has_preamble:1;
 	unsigned int has_sensitivity:1;
 	unsigned int has_hostscan:1;
+	unsigned int has_alt_txcntl:1;
 	unsigned int do_fw_download:1;
 	unsigned int broken_disableport:1;
 	unsigned int broken_monitor:1;
-- 
1.5.6.4


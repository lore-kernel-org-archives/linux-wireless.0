Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48195 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbYIYTy0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 15:54:26 -0400
Date: Thu, 25 Sep 2008 14:54:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>, chunkeey@web.de
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] p54: Fix sparse warnings
Message-ID: <48dbec74.8lfmFApZMynzSIpW%Larry.Finger@lwfinger.net> (sfid-20080925_215430_854564_9B75DA2C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The command

make C=2 CF="-D__CHECK_ENDIAN__" drivers/net/wireless/p54/

generates the following warnings:

.../p54common.c:152:38: warning: incorrect type in argument 1 (different base types)
.../p54common.c:152:38:    expected restricted __be32 const [usertype] *p
.../p54common.c:152:38:    got unsigned int *<noident>
.../p54common.c:184:15: warning: restricted __le32 degrades to integer
.../p54common.c:185:29: warning: cast to restricted __le16
.../p54common.c:309:11: warning: symbol 'p54_rf_chips' was not declared.
		        Should it be static?
.../p54common.c:313:5: warning: symbol 'p54_parse_eeprom' was not declared.
		       Should it be static?
.../p54common.c:620:43: warning: incorrect type in argument 3 (different base types)
.../p54common.c:620:43:    expected unsigned long [unsigned] [usertype] len
.../p54common.c:620:43:    got restricted __le16 [usertype] len
.../p54common.c:780:41: warning: restricted __le16 degrades to integer
.../p54common.c:781:32: warning: restricted __le16 degrades to integer
.../p54common.c:1250:28: warning: incorrect type in argument 2 (different base types)
.../p54common.c:1250:28:    expected unsigned short [unsigned] [usertype] filter_type
.../p54common.c:1250:28:    got restricted __le16 [usertype] filter_type
.../p54common.c:1252:28: warning: incorrect type in argument 2 (different base types)
.../p54common.c:1252:28:    expected unsigned short [unsigned] [usertype] filter_type
.../p54common.c:1252:28:    got restricted __le16 [usertype] filter_type
.../p54common.c:1257:42: warning: incorrect type in argument 2 (different base types)
.../p54common.c:1257:42:    expected unsigned short [unsigned] [usertype] filter_type
.../p54common.c:1257:42:    got restricted __le16
.../p54common.c:1260:42: warning: incorrect type in argument 2 (different base types)
.../p54common.c:1260:42:    expected unsigned short [unsigned] [usertype] filter_type
.../p54common.c:1260:42:    got restricted __le16
.../p54usb.c:228:10: warning: restricted __le32 degrades to integer
.../p54usb.c:228:23: warning: restricted __le32 degrades to integer
.../p54usb.c:228:7: warning: incorrect type in assignment (different base types)
.../p54usb.c:228:7:    expected restricted __le32 [assigned] [usertype] chk
.../p54usb.c:228:7:    got unsigned int
.../p54usb.c:221:8: warning: symbol 'p54u_lm87_chksum' was not declared.
		    Should it be static?

All of the above have been fixed. One question, however, remains: In struct
bootrec, the array "data" is treated in many places as native CPU order, but
it may be little-endian everywhere. As far as I can tell, this driver has only
been used with little-endian hardware.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.28 material.

Larry
---

 p54common.c |   33 ++++++++++++++++++---------------
 p54common.h |    3 ++-
 p54usb.c    |    8 ++++----
 3 files changed, 24 insertions(+), 20 deletions(-)

Index: wireless-testing/drivers/net/wireless/p54/p54usb.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54usb.c
+++ wireless-testing/drivers/net/wireless/p54/p54usb.c
@@ -218,17 +218,17 @@ static void p54u_tx_3887(struct ieee8021
 	usb_submit_urb(data_urb, GFP_ATOMIC);
 }
 
-__le32 p54u_lm87_chksum(const u32 *data, size_t length)
+static __le32 p54u_lm87_chksum(const u32 *data, size_t length)
 {
-	__le32 chk = 0;
+	u32 chk = 0;
 
 	length >>= 2;
 	while (length--) {
-		chk ^= cpu_to_le32(*data++);
+		chk ^= *data++;
 		chk = (chk >> 5) ^ (chk << 3);
 	}
 
-	return chk;
+	return cpu_to_le32(chk);
 }
 
 static void p54u_tx_lm87(struct ieee80211_hw *dev,
Index: wireless-testing/drivers/net/wireless/p54/p54common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c
+++ wireless-testing/drivers/net/wireless/p54/p54common.c
@@ -149,7 +149,8 @@ int p54_parse_firmware(struct ieee80211_
 		u32 code = le32_to_cpu(bootrec->code);
 		switch (code) {
 		case BR_CODE_COMPONENT_ID:
-			priv->fw_interface = be32_to_cpup(bootrec->data);
+			priv->fw_interface = be32_to_cpup((__be32 *)
+					     bootrec->data);
 			switch (priv->fw_interface) {
 			case FW_FMAC:
 				printk(KERN_INFO "p54: FreeMAC firmware\n");
@@ -181,9 +182,8 @@ int p54_parse_firmware(struct ieee80211_
 			priv->rx_end = le32_to_cpu(desc->rx_end) - 0x3500;
 			priv->headroom = desc->headroom;
 			priv->tailroom = desc->tailroom;
-			if (bootrec->len == 11)
-				priv->rx_mtu = (size_t) le16_to_cpu(
-					(__le16)bootrec->data[10]);
+			if (le32_to_cpu(bootrec->len) == 11)
+				priv->rx_mtu = le16_to_cpu(bootrec->rx_mtu);
 			else
 				priv->rx_mtu = (size_t)
 					0x620 - priv->tx_hdr_len;
@@ -306,11 +306,11 @@ static int p54_convert_rev1(struct ieee8
 	return 0;
 }
 
-const char* p54_rf_chips[] = { "NULL", "Indigo?", "Duette",
+static const char *p54_rf_chips[] = { "NULL", "Indigo?", "Duette",
                               "Frisbee", "Xbow", "Longbow" };
 static int p54_init_xbow_synth(struct ieee80211_hw *dev);
 
-int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
+static int p54_parse_eeprom(struct ieee80211_hw *dev, void *eeprom, int len)
 {
 	struct p54_common *priv = dev->priv;
 	struct eeprom_pda_wrap *wrap = NULL;
@@ -617,7 +617,7 @@ static void p54_rx_eeprom_readback(struc
 	if (!priv->eeprom)
 		return ;
 
-	memcpy(priv->eeprom, eeprom->data, eeprom->len);
+	memcpy(priv->eeprom, eeprom->data, le16_to_cpu(eeprom->len));
 
 	complete(&priv->eeprom_comp);
 }
@@ -777,8 +777,9 @@ int p54_read_eeprom(struct ieee80211_hw
 		hdr->len = cpu_to_le16(blocksize + sizeof(*eeprom_hdr));
 		eeprom_hdr->offset = cpu_to_le16(offset);
 		eeprom_hdr->len = cpu_to_le16(blocksize);
-		p54_assign_address(dev, NULL, hdr, hdr->len + sizeof(*hdr));
-	        priv->tx(dev, hdr, hdr->len + sizeof(*hdr), 0);
+		p54_assign_address(dev, NULL, hdr, le16_to_cpu(hdr->len) +
+				   sizeof(*hdr));
+		priv->tx(dev, hdr, le16_to_cpu(hdr->len) + sizeof(*hdr), 0);
 
 		if (!wait_for_completion_interruptible_timeout(&priv->eeprom_comp, HZ)) {
 			printk(KERN_ERR "%s: device does not respond!\n",
@@ -1247,18 +1248,20 @@ static void p54_configure_filter(struct
 
 	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
-			p54_set_filter(dev, priv->filter_type, NULL);
+			p54_set_filter(dev, le16_to_cpu(priv->filter_type),
+				 NULL);
 		else
-			p54_set_filter(dev, priv->filter_type, priv->bssid);
+			p54_set_filter(dev, le16_to_cpu(priv->filter_type),
+				 priv->bssid);
 	}
 
 	if (changed_flags & FIF_PROMISC_IN_BSS) {
 		if (*total_flags & FIF_PROMISC_IN_BSS)
-			p54_set_filter(dev, priv->filter_type |
-				cpu_to_le16(0x8), NULL);
+			p54_set_filter(dev, le16_to_cpu(priv->filter_type) |
+				0x8, NULL);
 		else
-			p54_set_filter(dev, priv->filter_type &
-				~cpu_to_le16(0x8), priv->bssid);
+			p54_set_filter(dev, le16_to_cpu(priv->filter_type) &
+				~0x8, priv->bssid);
 	}
 }
 
Index: wireless-testing/drivers/net/wireless/p54/p54common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.h
+++ wireless-testing/drivers/net/wireless/p54/p54common.h
@@ -18,7 +18,8 @@
 struct bootrec {
 	__le32 code;
 	__le32 len;
-	u32 data[0];
+	u32 data[10];
+	__le16 rx_mtu;
 } __attribute__((packed));
 
 struct bootrec_exp_if {

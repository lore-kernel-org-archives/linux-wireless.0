Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47845 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab1IHMje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 08:39:34 -0400
Received: by mail-ey0-f174.google.com with SMTP id 24so422913eyx.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 05:39:33 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 5/7] rt2x00: Make use of sta_add/remove callbacks in rt2800
Date: Thu, 8 Sep 2011 14:38:01 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201109081434.23635.IvDoorn@gmail.com> <201109081436.46401.IvDoorn@gmail.com> <201109081437.20667.IvDoorn@gmail.com>
In-Reply-To: <201109081437.20667.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109081438.02330.IvDoorn@gmail.com> (sfid-20110908_143938_956364_48319358)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

This allows us to assign a WCID to each STA even for STAs without
crypto key.

To achieve this search for an unused WCID in the HW WCID table and
assign it to the according STA. When configuring a pairwise key for this
STA we don't need to write the MAC address and BSSIDX anymore but just
update the crypto related fields in the WCID_ATTR table.

This has two advantages:

1) Setting a new key for an already available STA (PTK rekeying) is
slightly less expensive and should improve performance in situations
where a lot of rekeying happens (e.g. a huge number of stations and/or
a small rekeying interval)

2) The TXWI now gets a WCID assigned for unencrypted frames which will
be reflected in the corresponding tx status report. This should make tx
status reports in unencrypted AP mode more reliable as we can
distinguish between multiple key-less STAs.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  153 +++++++++++++++++++++++++------
 drivers/net/wireless/rt2x00/rt2800lib.h |    3 +
 drivers/net/wireless/rt2x00/rt2800pci.c |    4 +
 drivers/net/wireless/rt2x00/rt2800usb.c |    4 +
 4 files changed, 134 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 348fa23..7edd487 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -493,7 +493,7 @@ void rt2800_write_tx_data(struct queue_entry *entry,
 	rt2x00_set_field32(&word, TXWI_W1_BW_WIN_SIZE, txdesc->u.ht.ba_size);
 	rt2x00_set_field32(&word, TXWI_W1_WIRELESS_CLI_ID,
 			   test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags) ?
-			   txdesc->key_idx : 0xff);
+			   txdesc->key_idx : txdesc->u.ht.wcid);
 	rt2x00_set_field32(&word, TXWI_W1_MPDU_TOTAL_BYTE_COUNT,
 			   txdesc->length);
 	rt2x00_set_field32(&word, TXWI_W1_PACKETID_QUEUE, entry->queue->qid);
@@ -910,11 +910,51 @@ static void rt2800_init_led(struct rt2x00_dev *rt2x00dev,
 /*
  * Configuration handlers.
  */
-static void rt2800_config_wcid_attr(struct rt2x00_dev *rt2x00dev,
-				    struct rt2x00lib_crypto *crypto,
-				    struct ieee80211_key_conf *key)
+static void rt2800_config_wcid(struct rt2x00_dev *rt2x00dev,
+			       const u8 *address,
+			       int wcid)
 {
 	struct mac_wcid_entry wcid_entry;
+	u32 offset;
+
+	offset = MAC_WCID_ENTRY(wcid);
+
+	memset(&wcid_entry, 0xff, sizeof(wcid_entry));
+	if (address)
+		memcpy(wcid_entry.mac, address, ETH_ALEN);
+
+	rt2800_register_multiwrite(rt2x00dev, offset,
+				      &wcid_entry, sizeof(wcid_entry));
+}
+
+static void rt2800_delete_wcid_attr(struct rt2x00_dev *rt2x00dev, int wcid)
+{
+	u32 offset;
+	offset = MAC_WCID_ATTR_ENTRY(wcid);
+	rt2800_register_write(rt2x00dev, offset, 0);
+}
+
+static void rt2800_config_wcid_attr_bssidx(struct rt2x00_dev *rt2x00dev,
+					   int wcid, u32 bssidx)
+{
+	u32 offset = MAC_WCID_ATTR_ENTRY(wcid);
+	u32 reg;
+
+	/*
+	 * The BSS Idx numbers is split in a main value of 3 bits,
+	 * and a extended field for adding one additional bit to the value.
+	 */
+	rt2800_register_read(rt2x00dev, offset, &reg);
+	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_BSS_IDX, (bssidx & 0x7));
+	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_BSS_IDX_EXT,
+			   (bssidx & 0x8) >> 3);
+	rt2800_register_write(rt2x00dev, offset, reg);
+}
+
+static void rt2800_config_wcid_attr_cipher(struct rt2x00_dev *rt2x00dev,
+					   struct rt2x00lib_crypto *crypto,
+					   struct ieee80211_key_conf *key)
+{
 	struct mac_iveiv_entry iveiv_entry;
 	u32 offset;
 	u32 reg;
@@ -934,14 +974,16 @@ static void rt2800_config_wcid_attr(struct rt2x00_dev *rt2x00dev,
 				   (crypto->cipher & 0x7));
 		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_CIPHER_EXT,
 				   (crypto->cipher & 0x8) >> 3);
-		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_BSS_IDX,
-				   (crypto->bssidx & 0x7));
-		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_BSS_IDX_EXT,
-				   (crypto->bssidx & 0x8) >> 3);
 		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_RX_WIUDF, crypto->cipher);
 		rt2800_register_write(rt2x00dev, offset, reg);
 	} else {
-		rt2800_register_write(rt2x00dev, offset, 0);
+		/* Delete the cipher without touching the bssidx */
+		rt2800_register_read(rt2x00dev, offset, &reg);
+		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_KEYTAB, 0);
+		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_CIPHER, 0);
+		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_CIPHER_EXT, 0);
+		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_RX_WIUDF, 0);
+		rt2800_register_write(rt2x00dev, offset, reg);
 	}
 
 	offset = MAC_IVEIV_ENTRY(key->hw_key_idx);
@@ -954,14 +996,6 @@ static void rt2800_config_wcid_attr(struct rt2x00_dev *rt2x00dev,
 	iveiv_entry.iv[3] |= key->keyidx << 6;
 	rt2800_register_multiwrite(rt2x00dev, offset,
 				      &iveiv_entry, sizeof(iveiv_entry));
-
-	offset = MAC_WCID_ENTRY(key->hw_key_idx);
-
-	memset(&wcid_entry, 0, sizeof(wcid_entry));
-	if (crypto->cmd == SET_KEY)
-		memcpy(wcid_entry.mac, crypto->address, ETH_ALEN);
-	rt2800_register_multiwrite(rt2x00dev, offset,
-				      &wcid_entry, sizeof(wcid_entry));
 }
 
 int rt2800_config_shared_key(struct rt2x00_dev *rt2x00dev,
@@ -1008,20 +1042,24 @@ int rt2800_config_shared_key(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update WCID information
 	 */
-	rt2800_config_wcid_attr(rt2x00dev, crypto, key);
+	rt2800_config_wcid(rt2x00dev, crypto->address, key->hw_key_idx);
+	rt2800_config_wcid_attr_bssidx(rt2x00dev, key->hw_key_idx,
+				       crypto->bssidx);
+	rt2800_config_wcid_attr_cipher(rt2x00dev, crypto, key);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_config_shared_key);
 
-static inline int rt2800_find_pairwise_keyslot(struct rt2x00_dev *rt2x00dev)
+static inline int rt2800_find_wcid(struct rt2x00_dev *rt2x00dev)
 {
+	struct mac_wcid_entry wcid_entry;
 	int idx;
-	u32 offset, reg;
+	u32 offset;
 
 	/*
-	 * Search for the first free pairwise key entry and return the
-	 * corresponding index.
+	 * Search for the first free WCID entry and return the corresponding
+	 * index.
 	 *
 	 * Make sure the WCID starts _after_ the last possible shared key
 	 * entry (>32).
@@ -1031,11 +1069,17 @@ static inline int rt2800_find_pairwise_keyslot(struct rt2x00_dev *rt2x00dev)
 	 * first 222 entries.
 	 */
 	for (idx = 33; idx <= 222; idx++) {
-		offset = MAC_WCID_ATTR_ENTRY(idx);
-		rt2800_register_read(rt2x00dev, offset, &reg);
-		if (!reg)
+		offset = MAC_WCID_ENTRY(idx);
+		rt2800_register_multiread(rt2x00dev, offset, &wcid_entry,
+					  sizeof(wcid_entry));
+		if (is_broadcast_ether_addr(wcid_entry.mac))
 			return idx;
 	}
+
+	/*
+	 * Use -1 to indicate that we don't have any more space in the WCID
+	 * table.
+	 */
 	return -1;
 }
 
@@ -1045,13 +1089,15 @@ int rt2800_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 {
 	struct hw_key_entry key_entry;
 	u32 offset;
-	int idx;
 
 	if (crypto->cmd == SET_KEY) {
-		idx = rt2800_find_pairwise_keyslot(rt2x00dev);
-		if (idx < 0)
+		/*
+		 * Allow key configuration only for STAs that are
+		 * known by the hw.
+		 */
+		if (crypto->wcid < 0)
 			return -ENOSPC;
-		key->hw_key_idx = idx;
+		key->hw_key_idx = crypto->wcid;
 
 		memcpy(key_entry.key, crypto->key,
 		       sizeof(key_entry.key));
@@ -1068,12 +1114,59 @@ int rt2800_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Update WCID information
 	 */
-	rt2800_config_wcid_attr(rt2x00dev, crypto, key);
+	rt2800_config_wcid_attr_cipher(rt2x00dev, crypto, key);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_config_pairwise_key);
 
+int rt2800_sta_add(struct rt2x00_dev *rt2x00dev, struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta)
+{
+	int wcid;
+	struct rt2x00_sta *sta_priv = sta_to_rt2x00_sta(sta);
+
+	/*
+	 * Find next free WCID.
+	 */
+	wcid = rt2800_find_wcid(rt2x00dev);
+
+	/*
+	 * Store selected wcid even if it is invalid so that we can
+	 * later decide if the STA is uploaded into the hw.
+	 */
+	sta_priv->wcid = wcid;
+
+	/*
+	 * No space left in the device, however, we can still communicate
+	 * with the STA -> No error.
+	 */
+	if (wcid < 0)
+		return 0;
+
+	/*
+	 * Clean up WCID attributes and write STA address to the device.
+	 */
+	rt2800_delete_wcid_attr(rt2x00dev, wcid);
+	rt2800_config_wcid(rt2x00dev, sta->addr, wcid);
+	rt2800_config_wcid_attr_bssidx(rt2x00dev, wcid,
+				       rt2x00lib_get_bssidx(rt2x00dev, vif));
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2800_sta_add);
+
+int rt2800_sta_remove(struct rt2x00_dev *rt2x00dev, int wcid)
+{
+	/*
+	 * Remove WCID entry, no need to clean the attributes as they will
+	 * get renewed when the WCID is reused.
+	 */
+	rt2800_config_wcid(rt2x00dev, NULL, wcid);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2800_sta_remove);
+
 void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
 			  const unsigned int filter_flags)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index bef071c..7a2511f 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -166,6 +166,9 @@ int rt2800_config_shared_key(struct rt2x00_dev *rt2x00dev,
 int rt2800_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 			       struct rt2x00lib_crypto *crypto,
 			       struct ieee80211_key_conf *key);
+int rt2800_sta_add(struct rt2x00_dev *rt2x00dev, struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta);
+int rt2800_sta_remove(struct rt2x00_dev *rt2x00dev, int wcid);
 void rt2800_config_filter(struct rt2x00_dev *rt2x00dev,
 			  const unsigned int filter_flags);
 void rt2800_config_intf(struct rt2x00_dev *rt2x00dev, struct rt2x00_intf *intf,
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index e11a185..e0493fb 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1015,6 +1015,8 @@ static const struct ieee80211_ops rt2800pci_mac80211_ops = {
 	.get_stats		= rt2x00mac_get_stats,
 	.get_tkip_seq		= rt2800_get_tkip_seq,
 	.set_rts_threshold	= rt2800_set_rts_threshold,
+	.sta_add		= rt2x00mac_sta_add,
+	.sta_remove		= rt2x00mac_sta_remove,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2800_conf_tx,
 	.get_tsf		= rt2800_get_tsf,
@@ -1076,6 +1078,8 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.config_erp		= rt2800_config_erp,
 	.config_ant		= rt2800_config_ant,
 	.config			= rt2800_config,
+	.sta_add		= rt2800_sta_add,
+	.sta_remove		= rt2800_sta_remove,
 };
 
 static const struct data_queue_desc rt2800pci_queue_rx = {
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 1e947c0..0015526 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -760,6 +760,8 @@ static const struct ieee80211_ops rt2800usb_mac80211_ops = {
 	.get_stats		= rt2x00mac_get_stats,
 	.get_tkip_seq		= rt2800_get_tkip_seq,
 	.set_rts_threshold	= rt2800_set_rts_threshold,
+	.sta_add		= rt2x00mac_sta_add,
+	.sta_remove		= rt2x00mac_sta_remove,
 	.bss_info_changed	= rt2x00mac_bss_info_changed,
 	.conf_tx		= rt2800_conf_tx,
 	.get_tsf		= rt2800_get_tsf,
@@ -817,6 +819,8 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.config_erp		= rt2800_config_erp,
 	.config_ant		= rt2800_config_ant,
 	.config			= rt2800_config,
+	.sta_add		= rt2800_sta_add,
+	.sta_remove		= rt2800_sta_remove,
 };
 
 static const struct data_queue_desc rt2800usb_queue_rx = {
-- 
1.7.3.4

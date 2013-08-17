Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:53118 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab3HQR4Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 13:56:24 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 3/6] rt2x00: rt2800: serialize shared memory access
Date: Sat, 17 Aug 2013 19:56:04 +0200
Message-Id: <1376762167-24583-4-git-send-email-juhosg@openwrt.org> (sfid-20130817_195627_217587_726F5890)
In-Reply-To: <1376762167-24583-1-git-send-email-juhosg@openwrt.org>
References: <1376762167-24583-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The shared memory of the rt2800 devices is accessible
through the register offset range between 0x4000 and
0x8000. The size of this range is 16KB only and on
devices which have more than 16KB of shared memory either
the low or the high part of the memory is accessible at a
time.

Serialize all accesses to the shared memory by a mutex,
in order to avoid concurrent use of that.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   50 +++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h |   18 +++++++++++
 drivers/net/wireless/rt2x00/rt2800pci.c |   10 +++++++
 drivers/net/wireless/rt2x00/rt2800usb.c |    5 ++++
 4 files changed, 83 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 2d409e0..ee7eede 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -445,6 +445,7 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00_is_soc(rt2x00dev))
 		return;
 
+	rt2800_shared_mem_lock(rt2x00dev);
 	mutex_lock(&rt2x00dev->csr_mutex);
 
 	/*
@@ -464,6 +465,7 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 	}
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
+	rt2800_shared_mem_unlock(rt2x00dev);
 }
 EXPORT_SYMBOL_GPL(rt2800_mcu_request);
 
@@ -699,10 +701,16 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Initialize firmware.
 	 */
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2800_shared_mem_unlock(rt2x00dev);
+
 	if (rt2x00_is_usb(rt2x00dev)) {
+		rt2800_shared_mem_lock(rt2x00dev);
 		rt2800_register_write(rt2x00dev, H2M_INT_SRC, 0);
+		rt2800_shared_mem_unlock(rt2x00dev);
+
 		rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0, 0, 0);
 	}
 	msleep(1);
@@ -993,8 +1001,11 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 	}
 
 	beacon_base = HW_BEACON_BASE(entry->entry_idx);
+
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
 				   entry->skb->len + padding_len);
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	/*
 	 * Enable beaconing again.
@@ -1019,6 +1030,8 @@ static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
 
 	beacon_base = HW_BEACON_BASE(index);
 
+	rt2800_shared_mem_lock(rt2x00dev);
+
 	/*
 	 * For the Beacon base registers we only need to clear
 	 * the whole TXWI which (when set to 0) will invalidate
@@ -1026,6 +1039,8 @@ static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
 	 */
 	for (i = 0; i < txwi_desc_size; i += sizeof(__le32))
 		rt2800_register_write(rt2x00dev, beacon_base + i, 0);
+
+	rt2800_shared_mem_unlock(rt2x00dev);
 }
 
 void rt2800_clear_beacon(struct queue_entry *entry)
@@ -1209,7 +1224,9 @@ static void rt2800_delete_wcid_attr(struct rt2x00_dev *rt2x00dev, int wcid)
 {
 	u32 offset;
 	offset = MAC_WCID_ATTR_ENTRY(wcid);
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_write(rt2x00dev, offset, 0);
+	rt2800_shared_mem_unlock(rt2x00dev);
 }
 
 static void rt2800_config_wcid_attr_bssidx(struct rt2x00_dev *rt2x00dev,
@@ -1222,11 +1239,13 @@ static void rt2800_config_wcid_attr_bssidx(struct rt2x00_dev *rt2x00dev,
 	 * The BSS Idx numbers is split in a main value of 3 bits,
 	 * and a extended field for adding one additional bit to the value.
 	 */
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_read(rt2x00dev, offset, &reg);
 	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_BSS_IDX, (bssidx & 0x7));
 	rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_BSS_IDX_EXT,
 			   (bssidx & 0x8) >> 3);
 	rt2800_register_write(rt2x00dev, offset, reg);
+	rt2800_shared_mem_unlock(rt2x00dev);
 }
 
 static void rt2800_config_wcid_attr_cipher(struct rt2x00_dev *rt2x00dev,
@@ -1239,6 +1258,7 @@ static void rt2800_config_wcid_attr_cipher(struct rt2x00_dev *rt2x00dev,
 
 	offset = MAC_WCID_ATTR_ENTRY(key->hw_key_idx);
 
+	rt2800_shared_mem_lock(rt2x00dev);
 	if (crypto->cmd == SET_KEY) {
 		rt2800_register_read(rt2x00dev, offset, &reg);
 		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_KEYTAB,
@@ -1263,6 +1283,7 @@ static void rt2800_config_wcid_attr_cipher(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_RX_WIUDF, 0);
 		rt2800_register_write(rt2x00dev, offset, reg);
 	}
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	offset = MAC_IVEIV_ENTRY(key->hw_key_idx);
 
@@ -1272,8 +1293,11 @@ static void rt2800_config_wcid_attr_cipher(struct rt2x00_dev *rt2x00dev,
 	    (crypto->cipher == CIPHER_AES))
 		iveiv_entry.iv[3] |= 0x20;
 	iveiv_entry.iv[3] |= key->keyidx << 6;
+
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_multiwrite(rt2x00dev, offset,
 				      &iveiv_entry, sizeof(iveiv_entry));
+	rt2800_shared_mem_unlock(rt2x00dev);
 }
 
 int rt2800_config_shared_key(struct rt2x00_dev *rt2x00dev,
@@ -1296,8 +1320,11 @@ int rt2800_config_shared_key(struct rt2x00_dev *rt2x00dev,
 		       sizeof(key_entry.rx_mic));
 
 		offset = SHARED_KEY_ENTRY(key->hw_key_idx);
+
+		rt2800_shared_mem_lock(rt2x00dev);
 		rt2800_register_multiwrite(rt2x00dev, offset,
 					      &key_entry, sizeof(key_entry));
+		rt2800_shared_mem_unlock(rt2x00dev);
 	}
 
 	/*
@@ -1312,10 +1339,12 @@ int rt2800_config_shared_key(struct rt2x00_dev *rt2x00dev,
 
 	offset = SHARED_KEY_MODE_ENTRY(key->hw_key_idx / 8);
 
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_read(rt2x00dev, offset, &reg);
 	rt2x00_set_field32(&reg, field,
 			   (crypto->cmd == SET_KEY) * crypto->cipher);
 	rt2800_register_write(rt2x00dev, offset, reg);
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	/*
 	 * Update WCID information
@@ -1385,8 +1414,11 @@ int rt2800_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 		       sizeof(key_entry.rx_mic));
 
 		offset = PAIRWISE_KEY_ENTRY(key->hw_key_idx);
+
+		rt2800_shared_mem_lock(rt2x00dev);
 		rt2800_register_multiwrite(rt2x00dev, offset,
 					      &key_entry, sizeof(key_entry));
+		rt2800_shared_mem_unlock(rt2x00dev);
 	}
 
 	/*
@@ -4816,14 +4848,19 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * ASIC will keep garbage value after boot, clear encryption keys.
 	 */
+	rt2800_shared_mem_lock(rt2x00dev);
 	for (i = 0; i < 4; i++)
 		rt2800_register_write(rt2x00dev,
 					 SHARED_KEY_MODE_ENTRY(i), 0);
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	for (i = 0; i < 256; i++) {
 		rt2800_config_wcid(rt2x00dev, NULL, i);
 		rt2800_delete_wcid_attr(rt2x00dev, i);
+
+		rt2800_shared_mem_lock(rt2x00dev);
 		rt2800_register_write(rt2x00dev, MAC_IVEIV_ENTRY(i), 0);
+		rt2800_shared_mem_unlock(rt2x00dev);
 	}
 
 	/*
@@ -4949,8 +4986,10 @@ static int rt2800_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
 	 * BBP was enabled after firmware was loaded,
 	 * but we need to reactivate it now.
 	 */
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2800_shared_mem_unlock(rt2x00dev);
 	msleep(1);
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
@@ -6634,10 +6673,16 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Send signal to firmware during boot time.
 	 */
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2800_shared_mem_unlock(rt2x00dev);
+
 	if (rt2x00_is_usb(rt2x00dev)) {
+		rt2800_shared_mem_lock(rt2x00dev);
 		rt2800_register_write(rt2x00dev, H2M_INT_SRC, 0);
+		rt2800_shared_mem_unlock(rt2x00dev);
+
 		rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0, 0, 0);
 	}
 	msleep(1);
@@ -7701,6 +7746,8 @@ int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
 	int retval;
 	u32 reg;
 
+	mutex_init(&drv_data->shared_mem_mutex);
+
 	retval = rt2800_probe_rt(rt2x00dev);
 	if (retval)
 		return retval;
@@ -7785,8 +7832,11 @@ void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx, u32 *iv32,
 	u32 offset;
 
 	offset = MAC_IVEIV_ENTRY(hw_key_idx);
+
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_multiread(rt2x00dev, offset,
 				      &iveiv_entry, sizeof(iveiv_entry));
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	memcpy(iv16, &iveiv_entry.iv[0], sizeof(*iv16));
 	memcpy(iv32, &iveiv_entry.iv[4], sizeof(*iv32));
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index f89d413..f3f4404 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -37,6 +37,8 @@ struct rt2800_drv_data {
 	unsigned int tbtt_tick;
 
 	unsigned long rt2800_flags;
+
+	struct mutex shared_mem_mutex;
 };
 
 struct rt2800_ops {
@@ -76,6 +78,22 @@ static inline bool rt2800_has_high_shared_mem(struct rt2x00_dev *rt2x00dev)
 	return test_bit(RT2800_HAS_HIGH_SHARED_MEM, &drv_data->rt2800_flags);
 }
 
+static inline void rt2800_shared_mem_lock(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+
+	if (rt2800_has_high_shared_mem(rt2x00dev))
+		mutex_lock(&drv_data->shared_mem_mutex);
+}
+
+static inline void rt2800_shared_mem_unlock(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+
+	if (rt2800_has_high_shared_mem(rt2x00dev))
+		mutex_unlock(&drv_data->shared_mem_mutex);
+}
+
 static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
 					const unsigned int offset,
 					u32 *value)
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index f8f2abb..b14ddf6 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -71,6 +71,8 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 	if (rt2x00_is_soc(rt2x00dev))
 		return;
 
+	rt2800_shared_mem_lock(rt2x00dev);
+
 	for (i = 0; i < 200; i++) {
 		rt2x00mmio_register_read(rt2x00dev, H2M_MAILBOX_CID, &reg);
 
@@ -88,6 +90,8 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 
 	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
 	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
+
+	rt2800_shared_mem_unlock(rt2x00dev);
 }
 
 #if defined(CONFIG_SOC_RT288X) || defined(CONFIG_SOC_RT305X)
@@ -325,8 +329,10 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
 	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000);
 	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00001);
 
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2x00mmio_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
 	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	return 0;
 }
@@ -547,8 +553,10 @@ static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/* After resume MCU_BOOT_SIGNAL will trash these. */
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
 	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	rt2800_mcu_request(rt2x00dev, MCU_SLEEP, TOKEN_RADIO_OFF, 0xff, 0x02);
 	rt2800pci_mcu_status(rt2x00dev, TOKEN_RADIO_OFF);
@@ -576,10 +584,12 @@ static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
 				   0, 0x02);
 		rt2800pci_mcu_status(rt2x00dev, TOKEN_WAKEUP);
 	} else if (state == STATE_SLEEP) {
+		rt2800_shared_mem_lock(rt2x00dev);
 		rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_STATUS,
 					  0xffffffff);
 		rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CID,
 					  0xffffffff);
+		rt2800_shared_mem_unlock(rt2x00dev);
 		rt2800_mcu_request(rt2x00dev, MCU_SLEEP, TOKEN_SLEEP,
 				   0xff, 0x01);
 	}
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 338034e..4ff38b8 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -259,8 +259,10 @@ static int rt2800usb_write_firmware(struct rt2x00_dev *rt2x00dev,
 	rt2x00usb_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
 				      data + offset, length);
 
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
 	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	/*
 	 * Send firmware request to device to load firmware,
@@ -275,7 +277,10 @@ static int rt2800usb_write_firmware(struct rt2x00_dev *rt2x00dev,
 	}
 
 	msleep(10);
+
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	return 0;
 }
-- 
1.7.10

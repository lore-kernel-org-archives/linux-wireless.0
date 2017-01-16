Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:36975 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751281AbdAPC6m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Jan 2017 21:58:42 -0500
Date: Mon, 16 Jan 2017 03:58:24 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 03/14] rt2x00: rt2800: serialize shared memory access
Message-ID: <20170116025808.GA32179@makrotopia.org> (sfid-20170116_035847_239567_DB324BD2)
References: <874m114lwq.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <874m114lwq.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

The shared memory of the rt2800 devices is accessible
through the register offset range between 0x4000 and
0x8000. The size of this range is 16KB only and on
devices which have more than 16KB of shared memory either
the low or the high part of the memory is accessible at a
time.

Serialize all accesses to the shared memory by a mutex,
in order to avoid concurrent use of that.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c  | 55 ++++++++++++++++++++++++-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h  | 35 ++++++++++++++++
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c | 26 ++++++++++++
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.h |  4 ++
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c  | 14 +++++++
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c  |  3 ++
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c  | 31 ++++++++++++++
 7 files changed, 167 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 5045af1b0dc9..0fd67026f806 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -451,11 +451,13 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_CMD_TOKEN, token);
 		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_ARG0, arg0);
 		rt2x00_set_field32(&reg, H2M_MAILBOX_CSR_ARG1, arg1);
+		rt2800_shared_mem_lock(rt2x00dev);
 		rt2800_register_write_lock(rt2x00dev, H2M_MAILBOX_CSR, reg);
 
 		reg = 0;
 		rt2x00_set_field32(&reg, HOST_CMD_CSR_HOST_COMMAND, command);
 		rt2800_register_write_lock(rt2x00dev, HOST_CMD_CSR, reg);
+		rt2800_shared_mem_unlock(rt2x00dev);
 	}
 
 	mutex_unlock(&rt2x00dev->csr_mutex);
@@ -674,7 +676,9 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
 	 * Wait for device to stabilize.
 	 */
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+		rt2800_shared_mem_lock(rt2x00dev);
 		rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
+		rt2800_shared_mem_unlock(rt2x00dev);
 		if (rt2x00_get_field32(reg, PBF_SYS_CTRL_READY))
 			break;
 		msleep(1);
@@ -694,10 +698,16 @@ int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
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
@@ -1035,8 +1045,10 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
 
 	beacon_base = rt2800_hw_beacon_base(rt2x00dev, entry->entry_idx);
 
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
 				   entry->skb->len + padding_len);
+	rt2800_shared_mem_unlock(rt2x00dev);
 	__set_bit(ENTRY_BCN_ENABLED, &entry->flags);
 
 	/*
@@ -1066,6 +1078,8 @@ static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
 
 	beacon_base = rt2800_hw_beacon_base(rt2x00dev, index);
 
+	rt2800_shared_mem_lock(rt2x00dev);
+
 	/*
 	 * For the Beacon base registers we only need to clear
 	 * the whole TXWI which (when set to 0) will invalidate
@@ -1073,6 +1087,8 @@ static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
 	 */
 	for (i = 0; i < txwi_desc_size; i += sizeof(__le32))
 		rt2800_register_write(rt2x00dev, beacon_base + i, 0);
+
+	rt2800_shared_mem_unlock(rt2x00dev);
 }
 
 void rt2800_clear_beacon(struct queue_entry *entry)
@@ -1261,7 +1277,9 @@ static void rt2800_delete_wcid_attr(struct rt2x00_dev *rt2x00dev, int wcid)
 {
 	u32 offset;
 	offset = MAC_WCID_ATTR_ENTRY(wcid);
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_write(rt2x00dev, offset, 0);
+	rt2800_shared_mem_unlock(rt2x00dev);
 }
 
 static void rt2800_config_wcid_attr_bssidx(struct rt2x00_dev *rt2x00dev,
@@ -1274,11 +1292,13 @@ static void rt2800_config_wcid_attr_bssidx(struct rt2x00_dev *rt2x00dev,
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
@@ -1291,6 +1311,7 @@ static void rt2800_config_wcid_attr_cipher(struct rt2x00_dev *rt2x00dev,
 
 	offset = MAC_WCID_ATTR_ENTRY(key->hw_key_idx);
 
+	rt2800_shared_mem_lock(rt2x00dev);
 	if (crypto->cmd == SET_KEY) {
 		rt2800_register_read(rt2x00dev, offset, &reg);
 		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_KEYTAB,
@@ -1315,6 +1336,7 @@ static void rt2800_config_wcid_attr_cipher(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, MAC_WCID_ATTRIBUTE_RX_WIUDF, 0);
 		rt2800_register_write(rt2x00dev, offset, reg);
 	}
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	offset = MAC_IVEIV_ENTRY(key->hw_key_idx);
 
@@ -1324,8 +1346,11 @@ static void rt2800_config_wcid_attr_cipher(struct rt2x00_dev *rt2x00dev,
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
@@ -1348,8 +1373,11 @@ int rt2800_config_shared_key(struct rt2x00_dev *rt2x00dev,
 		       sizeof(key_entry.rx_mic));
 
 		offset = SHARED_KEY_ENTRY(key->hw_key_idx);
+
+		rt2800_shared_mem_lock(rt2x00dev);
 		rt2800_register_multiwrite(rt2x00dev, offset,
 					      &key_entry, sizeof(key_entry));
+		rt2800_shared_mem_unlock(rt2x00dev);
 	}
 
 	/*
@@ -1364,10 +1392,12 @@ int rt2800_config_shared_key(struct rt2x00_dev *rt2x00dev,
 
 	offset = SHARED_KEY_MODE_ENTRY(key->hw_key_idx / 8);
 
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_read(rt2x00dev, offset, &reg);
 	rt2x00_set_field32(&reg, field,
 			   (crypto->cmd == SET_KEY) * crypto->cipher);
 	rt2800_register_write(rt2x00dev, offset, reg);
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	/*
 	 * Update WCID information
@@ -1405,8 +1435,11 @@ int rt2800_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 		       sizeof(key_entry.rx_mic));
 
 		offset = PAIRWISE_KEY_ENTRY(key->hw_key_idx);
+
+		rt2800_shared_mem_lock(rt2x00dev);
 		rt2800_register_multiwrite(rt2x00dev, offset,
 					      &key_entry, sizeof(key_entry));
+		rt2800_shared_mem_unlock(rt2x00dev);
 	}
 
 	/*
@@ -4930,14 +4963,19 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
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
@@ -5063,8 +5101,10 @@ static int rt2800_wait_bbp_ready(struct rt2x00_dev *rt2x00dev)
 	 * BBP was enabled after firmware was loaded,
 	 * but we need to reactivate it now.
 	 */
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2800_shared_mem_unlock(rt2x00dev);
 	msleep(1);
 
 	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
@@ -6760,11 +6800,19 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Send signal during boot time to initialize firmware.
 	 */
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
-	if (rt2x00_is_usb(rt2x00dev))
+	rt2800_shared_mem_unlock(rt2x00dev);
+
+	if (rt2x00_is_usb(rt2x00dev)) {
+		rt2800_shared_mem_lock(rt2x00dev);
 		rt2800_register_write(rt2x00dev, H2M_INT_SRC, 0);
+		rt2800_shared_mem_unlock(rt2x00dev);
+	}
+
 	rt2800_mcu_request(rt2x00dev, MCU_BOOT_SIGNAL, 0, 0, 0);
+
 	msleep(1);
 
 	/*
@@ -7774,6 +7822,8 @@ int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev)
 	int retval;
 	u32 reg;
 
+	rt2800_shared_mem_init_lock(rt2x00dev);
+
 	retval = rt2800_probe_rt(rt2x00dev);
 	if (retval)
 		return retval;
@@ -7857,8 +7907,11 @@ void rt2800_get_key_seq(struct ieee80211_hw *hw,
 		return;
 
 	offset = MAC_IVEIV_ENTRY(key->hw_key_idx);
+
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2800_register_multiread(rt2x00dev, offset,
 				      &iveiv_entry, sizeof(iveiv_entry));
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	memcpy(&seq->tkip.iv16, &iveiv_entry.iv[0], 2);
 	memcpy(&seq->tkip.iv32, &iveiv_entry.iv[4], 4);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
index 4ee424dfe23f..ccfa8cf1f5ac 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.h
@@ -40,6 +40,14 @@ struct rt2800_drv_data {
 	DECLARE_BITMAP(sta_ids, STA_IDS_SIZE);
 
 	unsigned long rt2800_flags;
+
+	/* locks to serialize shared memory access */
+	union {
+		/* a spinlock is used for MMIO devices */
+		spinlock_t spin;
+		/* a mutex is used for PCI devices */
+		struct mutex mutex;
+	} shmem_lock;
 };
 
 struct rt2800_ops {
@@ -70,6 +78,10 @@ struct rt2800_ops {
 				  const u8 *data, const size_t len);
 	int (*drv_init_registers)(struct rt2x00_dev *rt2x00dev);
 	__le32 *(*drv_get_txwi)(struct queue_entry *entry);
+
+	void (*shmem_init_lock)(struct rt2x00_dev *rt2x00dev);
+	void (*shmem_lock)(struct rt2x00_dev *rt2x00dev);
+	void (*shmem_unlock)(struct rt2x00_dev *rt2x00dev);
 };
 
 static inline bool rt2800_has_high_shared_mem(struct rt2x00_dev *rt2x00dev)
@@ -79,6 +91,29 @@ static inline bool rt2800_has_high_shared_mem(struct rt2x00_dev *rt2x00dev)
 	return test_bit(RT2800_HAS_HIGH_SHARED_MEM, &drv_data->rt2800_flags);
 }
 
+static inline void rt2800_shared_mem_init_lock(struct rt2x00_dev *rt2x00dev)
+{
+	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
+
+	rt2800ops->shmem_init_lock(rt2x00dev);
+}
+
+static inline void rt2800_shared_mem_lock(struct rt2x00_dev *rt2x00dev)
+{
+	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
+
+	if (rt2800_has_high_shared_mem(rt2x00dev))
+		rt2800ops->shmem_lock(rt2x00dev);
+}
+
+static inline void rt2800_shared_mem_unlock(struct rt2x00_dev *rt2x00dev)
+{
+	const struct rt2800_ops *rt2800ops = rt2x00dev->ops->drv;
+
+	if (rt2800_has_high_shared_mem(rt2x00dev))
+		rt2800ops->shmem_unlock(rt2x00dev);
+}
+
 static inline void rt2800_register_read(struct rt2x00_dev *rt2x00dev,
 					const unsigned int offset,
 					u32 *value)
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index de4790b41be7..5f1936aa8fa7 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -820,8 +820,10 @@ int rt2800mmio_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, WPDMA_RST_IDX_DRX_IDX0, 1);
 	rt2x00mmio_register_write(rt2x00dev, WPDMA_RST_IDX, reg);
 
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e1f);
 	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000e00);
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	if (rt2x00_is_pcie(rt2x00dev) &&
 	    (rt2x00_rt(rt2x00dev, RT3090) ||
@@ -865,6 +867,30 @@ int rt2800mmio_enable_radio(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800mmio_enable_radio);
 
+void rt2800mmio_shmem_init_lock(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+
+	spin_lock_init(&drv_data->shmem_lock.spin);
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_shmem_init_lock);
+
+void rt2800mmio_shmem_lock(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+
+	spin_lock_bh(&drv_data->shmem_lock.spin);
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_shmem_lock);
+
+void rt2800mmio_shmem_unlock(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+
+	spin_unlock_bh(&drv_data->shmem_lock.spin);
+}
+EXPORT_SYMBOL_GPL(rt2800mmio_shmem_unlock);
+
 MODULE_AUTHOR(DRV_PROJECT);
 MODULE_VERSION(DRV_VERSION);
 MODULE_DESCRIPTION("rt2800 MMIO library");
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h
index b63312ce3f27..352b409dcff2 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.h
@@ -160,4 +160,8 @@ int rt2800mmio_init_registers(struct rt2x00_dev *rt2x00dev);
 /* Device state switch handlers. */
 int rt2800mmio_enable_radio(struct rt2x00_dev *rt2x00dev);
 
+void rt2800mmio_shmem_init_lock(struct rt2x00_dev *rt2x00dev);
+void rt2800mmio_shmem_lock(struct rt2x00_dev *rt2x00dev);
+void rt2800mmio_shmem_unlock(struct rt2x00_dev *rt2x00dev);
+
 #endif /* RT2800MMIO_H */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
index 0af22573a2eb..beb1199acccb 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
@@ -69,7 +69,9 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 		return;
 
 	for (i = 0; i < 200; i++) {
+		rt2800_shared_mem_lock(rt2x00dev);
 		rt2x00mmio_register_read(rt2x00dev, H2M_MAILBOX_CID, &reg);
+		rt2800_shared_mem_unlock(rt2x00dev);
 
 		if ((rt2x00_get_field32(reg, H2M_MAILBOX_CID_CMD0) == token) ||
 		    (rt2x00_get_field32(reg, H2M_MAILBOX_CID_CMD1) == token) ||
@@ -83,8 +85,10 @@ static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
 	if (i == 200)
 		rt2x00_err(rt2x00dev, "MCU request failed, no response from hardware\n");
 
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
 	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
+	rt2800_shared_mem_unlock(rt2x00dev);
 }
 
 static void rt2800pci_eepromregister_read(struct eeprom_93cx6 *eeprom)
@@ -184,6 +188,8 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
 	 */
 	reg = 0;
 	rt2x00_set_field32(&reg, PBF_SYS_CTRL_HOST_RAM_WRITE, 1);
+
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2x00mmio_register_write(rt2x00dev, PBF_SYS_CTRL, reg);
 
 	/*
@@ -197,6 +203,7 @@ static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00mmio_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
 	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	return 0;
 }
@@ -213,8 +220,10 @@ static int rt2800pci_enable_radio(struct rt2x00_dev *rt2x00dev)
 		return retval;
 
 	/* After resume MCU_BOOT_SIGNAL will trash these. */
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
 	rt2x00mmio_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	rt2800_mcu_request(rt2x00dev, MCU_SLEEP, TOKEN_RADIO_OFF, 0xff, 0x02);
 	rt2800pci_mcu_status(rt2x00dev, TOKEN_RADIO_OFF);
@@ -233,10 +242,12 @@ static int rt2800pci_set_state(struct rt2x00_dev *rt2x00dev,
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
@@ -337,6 +348,9 @@ static const struct rt2800_ops rt2800pci_rt2800_ops = {
 	.drv_write_firmware	= rt2800pci_write_firmware,
 	.drv_init_registers	= rt2800mmio_init_registers,
 	.drv_get_txwi		= rt2800mmio_get_txwi,
+	.shmem_init_lock	= rt2800mmio_shmem_init_lock,
+	.shmem_lock		= rt2800mmio_shmem_lock,
+	.shmem_unlock		= rt2800mmio_shmem_unlock,
 };
 
 static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800soc.c b/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
index a985a5a7945e..871d9d331046 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800soc.c
@@ -176,6 +176,9 @@ static const struct rt2800_ops rt2800soc_rt2800_ops = {
 	.drv_write_firmware	= rt2800soc_write_firmware,
 	.drv_init_registers	= rt2800mmio_init_registers,
 	.drv_get_txwi		= rt2800mmio_get_txwi,
+	.shmem_init_lock	= rt2800mmio_shmem_init_lock,
+	.shmem_lock		= rt2800mmio_shmem_lock,
+	.shmem_unlock		= rt2800mmio_shmem_unlock,
 };
 
 static const struct rt2x00lib_ops rt2800soc_rt2x00_ops = {
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index f38c44061b5b..f8d905c63ac8 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -51,6 +51,27 @@ static bool rt2800usb_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
 	return modparam_nohwcrypt;
 }
 
+static void rt2800usb_shmem_init_lock(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+
+	mutex_init(&drv_data->shmem_lock.mutex);
+}
+
+static void rt2800usb_shmem_lock(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+
+	mutex_lock(&drv_data->shmem_lock.mutex);
+}
+
+static void rt2800usb_shmem_unlock(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+
+	mutex_unlock(&drv_data->shmem_lock.mutex);
+}
+
 /*
  * Queue handlers.
  */
@@ -299,8 +320,10 @@ static int rt2800usb_write_firmware(struct rt2x00_dev *rt2x00dev,
 					      data + offset, length);
 	}
 
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_CID, ~0);
 	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_STATUS, ~0);
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	/*
 	 * Send firmware request to device to load firmware,
@@ -315,7 +338,10 @@ static int rt2800usb_write_firmware(struct rt2x00_dev *rt2x00dev,
 	}
 
 	msleep(10);
+
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2x00usb_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	return 0;
 }
@@ -333,8 +359,10 @@ static int rt2800usb_init_registers(struct rt2x00_dev *rt2x00dev)
 	if (rt2800_wait_csr_ready(rt2x00dev))
 		return -EBUSY;
 
+	rt2800_shared_mem_lock(rt2x00dev);
 	rt2x00usb_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
 	rt2x00usb_register_write(rt2x00dev, PBF_SYS_CTRL, reg & ~0x00002000);
+	rt2800_shared_mem_unlock(rt2x00dev);
 
 	reg = 0;
 	rt2x00_set_field32(&reg, MAC_SYS_CTRL_RESET_CSR, 1);
@@ -860,6 +888,9 @@ static const struct rt2800_ops rt2800usb_rt2800_ops = {
 	.drv_write_firmware	= rt2800usb_write_firmware,
 	.drv_init_registers	= rt2800usb_init_registers,
 	.drv_get_txwi		= rt2800usb_get_txwi,
+	.shmem_init_lock	= rt2800usb_shmem_init_lock,
+	.shmem_lock		= rt2800usb_shmem_lock,
+	.shmem_unlock		= rt2800usb_shmem_unlock,
 };
 
 static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
-- 
2.11.0

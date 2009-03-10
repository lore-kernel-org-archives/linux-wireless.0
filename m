Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33865 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbZCJCKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:10:35 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, dsd@gentoo.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC] zd1211rw: remove zd_addr_t typedef for a simple u16
Date: Mon,  9 Mar 2009 22:10:30 -0400
Message-Id: <1236651030-10331-1-git-send-email-lrodriguez@atheros.com> (sfid-20090310_032928_447835_9D8B0490)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The __nocast attribute is used to shut sparse up but we
don't need it, lets just use u16 directly.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Can someone test this for me? The zd1211rw device seems to require
a bit more tweaks to work so not sure ifs the patch, it wasn't working
with zd1211rw anyway. We will release another update to the vendor driver
to help with addition of new device support.

This cures sparse warning that was just making me itch.

 drivers/net/wireless/zd1211rw/zd_chip.c |   50 +++++++++++++++----------------
 drivers/net/wireless/zd1211rw/zd_chip.h |   34 ++++++++++----------
 drivers/net/wireless/zd1211rw/zd_def.h  |    2 -
 drivers/net/wireless/zd1211rw/zd_usb.c  |    4 +-
 drivers/net/wireless/zd1211rw/zd_usb.h  |   12 ++++----
 5 files changed, 49 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wireless/zd1211rw/zd_chip.c
index 2c813d8..9d8d873 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -87,7 +87,7 @@ static void print_id(struct zd_chip *chip)
 	dev_info(zd_chip_dev(chip), "%s\n", buffer);
 }
 
-static zd_addr_t inc_addr(zd_addr_t addr)
+static u16 inc_addr(u16 addr)
 {
 	u16 a = (u16)addr;
 	/* Control registers use byte addressing, but everything else uses word
@@ -96,18 +96,18 @@ static zd_addr_t inc_addr(zd_addr_t addr)
 		a += 2;
 	else
 		a += 1;
-	return (zd_addr_t)a;
+	return a;
 }
 
 /* Read a variable number of 32-bit values. Parameter count is not allowed to
  * exceed USB_MAX_IOREAD32_COUNT.
  */
-int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr,
+int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const u16 *addr,
 		 unsigned int count)
 {
 	int r;
 	int i;
-	zd_addr_t *a16;
+	u16 *a16;
 	u16 *v16;
 	unsigned int count16;
 
@@ -116,8 +116,7 @@ int zd_ioread32v_locked(struct zd_chip *chip, u32 *values, const zd_addr_t *addr
 
 	/* Allocate a single memory block for values and addresses. */
 	count16 = 2*count;
-	a16 = (zd_addr_t *) kmalloc(count16 * (sizeof(zd_addr_t) + sizeof(u16)),
-		                   GFP_KERNEL);
+	a16 = kmalloc(count16 * (sizeof(u16)), GFP_KERNEL);
 	if (!a16) {
 		dev_dbg_f(zd_chip_dev(chip),
 			  "error ENOMEM in allocation of a16\n");
@@ -260,7 +259,7 @@ int zd_iowrite32a_locked(struct zd_chip *chip,
 	return 0;
 }
 
-int zd_ioread16(struct zd_chip *chip, zd_addr_t addr, u16 *value)
+int zd_ioread16(struct zd_chip *chip, u16 addr, u16 *value)
 {
 	int r;
 
@@ -270,7 +269,7 @@ int zd_ioread16(struct zd_chip *chip, zd_addr_t addr, u16 *value)
 	return r;
 }
 
-int zd_ioread32(struct zd_chip *chip, zd_addr_t addr, u32 *value)
+int zd_ioread32(struct zd_chip *chip, u16 addr, u32 *value)
 {
 	int r;
 
@@ -280,7 +279,7 @@ int zd_ioread32(struct zd_chip *chip, zd_addr_t addr, u32 *value)
 	return r;
 }
 
-int zd_iowrite16(struct zd_chip *chip, zd_addr_t addr, u16 value)
+int zd_iowrite16(struct zd_chip *chip, u16 addr, u16 value)
 {
 	int r;
 
@@ -290,7 +289,7 @@ int zd_iowrite16(struct zd_chip *chip, zd_addr_t addr, u16 value)
 	return r;
 }
 
-int zd_iowrite32(struct zd_chip *chip, zd_addr_t addr, u32 value)
+int zd_iowrite32(struct zd_chip *chip, u16 addr, u32 value)
 {
 	int r;
 
@@ -300,7 +299,7 @@ int zd_iowrite32(struct zd_chip *chip, zd_addr_t addr, u32 value)
 	return r;
 }
 
-int zd_ioread32v(struct zd_chip *chip, const zd_addr_t *addresses,
+int zd_ioread32v(struct zd_chip *chip, const u16 *addresses,
 	          u32 *values, unsigned int count)
 {
 	int r;
@@ -415,7 +414,7 @@ int zd_read_regdomain(struct zd_chip *chip, u8 *regdomain)
 }
 
 static int read_values(struct zd_chip *chip, u8 *values, size_t count,
-	               zd_addr_t e2p_addr, u32 guard)
+		       u16 e2p_addr, u32 guard)
 {
 	int r;
 	int i;
@@ -423,8 +422,7 @@ static int read_values(struct zd_chip *chip, u8 *values, size_t count,
 
 	ZD_ASSERT(mutex_is_locked(&chip->mutex));
 	for (i = 0;;) {
-		r = zd_ioread32_locked(chip, &v,
-			               (zd_addr_t)((u16)e2p_addr+i/2));
+		r = zd_ioread32_locked(chip, &v, e2p_addr+i/2);
 		if (r)
 			return r;
 		v -= guard;
@@ -459,7 +457,7 @@ static int read_ofdm_cal_values(struct zd_chip *chip)
 {
 	int r;
 	int i;
-	static const zd_addr_t addresses[] = {
+	static const u16 addresses[] = {
 		E2P_36M_CAL_VALUE1,
 		E2P_48M_CAL_VALUE1,
 		E2P_54M_CAL_VALUE1,
@@ -827,11 +825,11 @@ struct aw_pt_bi {
 static int get_aw_pt_bi(struct zd_chip *chip, struct aw_pt_bi *s)
 {
 	int r;
-	static const zd_addr_t aw_pt_bi_addr[] =
+	static const u16 aw_pt_bi_addr[] =
 		{ CR_ATIM_WND_PERIOD, CR_PRE_TBTT, CR_BCN_INTERVAL };
 	u32 values[3];
 
-	r = zd_ioread32v_locked(chip, values, (const zd_addr_t *)aw_pt_bi_addr,
+	r = zd_ioread32v_locked(chip, values, (const u16 *)aw_pt_bi_addr,
 		         ARRAY_SIZE(aw_pt_bi_addr));
 	if (r) {
 		memset(s, 0, sizeof(*s));
@@ -906,13 +904,13 @@ static int hw_init(struct zd_chip *chip)
 	return set_beacon_interval(chip, 100);
 }
 
-static zd_addr_t fw_reg_addr(struct zd_chip *chip, u16 offset)
+static u16 fw_reg_addr(struct zd_chip *chip, u16 offset)
 {
-	return (zd_addr_t)((u16)chip->fw_regs_base + offset);
+	return chip->fw_regs_base + offset;
 }
 
 #ifdef DEBUG
-static int dump_cr(struct zd_chip *chip, const zd_addr_t addr,
+static int dump_cr(struct zd_chip *chip, const u16 addr,
 	           const char *addr_string)
 {
 	int r;
@@ -945,7 +943,7 @@ static int test_init(struct zd_chip *chip)
 
 static void dump_fw_registers(struct zd_chip *chip)
 {
-	const zd_addr_t addr[4] = {
+	const u16 addr[4] = {
 		fw_reg_addr(chip, FW_REG_FIRMWARE_VER),
 		fw_reg_addr(chip, FW_REG_USB_SPEED),
 		fw_reg_addr(chip, FW_REG_FIX_TX_RATE),
@@ -955,7 +953,7 @@ static void dump_fw_registers(struct zd_chip *chip)
 	int r;
 	u16 values[4];
 
-	r = zd_ioread16v_locked(chip, values, (const zd_addr_t*)addr,
+	r = zd_ioread16v_locked(chip, values, addr,
 		         ARRAY_SIZE(addr));
 	if (r) {
 		dev_dbg_f(zd_chip_dev(chip), "error %d zd_ioread16v_locked\n",
@@ -1257,7 +1255,7 @@ u8 zd_chip_get_channel(struct zd_chip *chip)
 
 int zd_chip_control_leds(struct zd_chip *chip, enum led_status status)
 {
-	const zd_addr_t a[] = {
+	const u16 a[] = {
 		fw_reg_addr(chip, FW_REG_LED_LINK_STATUS),
 		CR_LED,
 	};
@@ -1271,7 +1269,7 @@ int zd_chip_control_leds(struct zd_chip *chip, enum led_status status)
 	u16 other_led;
 
 	mutex_lock(&chip->mutex);
-	r = zd_ioread16v_locked(chip, v, (const zd_addr_t *)a, ARRAY_SIZE(a));
+	r = zd_ioread16v_locked(chip, v, a, ARRAY_SIZE(a));
 	if (r)
 		goto out;
 
@@ -1620,13 +1618,13 @@ int zd_chip_set_multicast_hash(struct zd_chip *chip,
 u64 zd_chip_get_tsf(struct zd_chip *chip)
 {
 	int r;
-	static const zd_addr_t aw_pt_bi_addr[] =
+	static const u16 aw_pt_bi_addr[] =
 		{ CR_TSF_LOW_PART, CR_TSF_HIGH_PART };
 	u32 values[2];
 	u64 tsf;
 
 	mutex_lock(&chip->mutex);
-	r = zd_ioread32v_locked(chip, values, (const zd_addr_t *)aw_pt_bi_addr,
+	r = zd_ioread32v_locked(chip, values, aw_pt_bi_addr,
 	                        ARRAY_SIZE(aw_pt_bi_addr));
 	mutex_unlock(&chip->mutex);
 	if (r)
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wireless/zd1211rw/zd_chip.h
index ee42751..7da1c4c 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -56,9 +56,9 @@ enum {
 	E2P_BOOT_CODE_OFFSET		= E2P_DATA_OFFSET + E2P_DATA_LEN,
 };
 
-#define CTL_REG(offset) ((zd_addr_t)(CR_START + (offset)))
-#define E2P_DATA(offset) ((zd_addr_t)(E2P_START + E2P_DATA_OFFSET + (offset)))
-#define FWRAW_DATA(offset) ((zd_addr_t)(FW_START + (offset)))
+#define CTL_REG(offset) (CR_START + (offset))
+#define E2P_DATA(offset) (E2P_START + E2P_DATA_OFFSET + (offset))
+#define FWRAW_DATA(offset) (FW_START + (offset))
 
 /* 8-bit hardware registers */
 #define CR0   CTL_REG(0x0000)
@@ -643,7 +643,7 @@ enum {
 #define CR_ZD1211B_RETRY_MAX		CTL_REG(0x0b28)
 
 /* Used to detect PLL lock */
-#define UW2453_INTR_REG			((zd_addr_t)0x85c1)
+#define UW2453_INTR_REG			0x85c1
 
 #define CWIN_SIZE			0x007f043f
 
@@ -737,7 +737,7 @@ struct zd_chip {
 	struct zd_rf rf;
 	struct mutex mutex;
 	/* Base address of FW_REG_ registers */
-	zd_addr_t fw_regs_base;
+	u16 fw_regs_base;
 	/* EepSetPoint in the vendor driver */
 	u8 pwr_cal_values[E2P_CHANNEL_COUNT];
 	/* integration values in the vendor driver */
@@ -777,7 +777,7 @@ static inline int zd_chip_is_zd1211b(struct zd_chip *chip)
 }
 
 static inline int zd_ioread16v_locked(struct zd_chip *chip, u16 *values,
-	                              const zd_addr_t *addresses,
+				      const u16 *addresses,
 				      unsigned int count)
 {
 	ZD_ASSERT(mutex_is_locked(&chip->mutex));
@@ -785,23 +785,23 @@ static inline int zd_ioread16v_locked(struct zd_chip *chip, u16 *values,
 }
 
 static inline int zd_ioread16_locked(struct zd_chip *chip, u16 *value,
-	                             const zd_addr_t addr)
+				     const u16 addr)
 {
 	ZD_ASSERT(mutex_is_locked(&chip->mutex));
 	return zd_usb_ioread16(&chip->usb, value, addr);
 }
 
 int zd_ioread32v_locked(struct zd_chip *chip, u32 *values,
-	                const zd_addr_t *addresses, unsigned int count);
+			const u16 *addresses, unsigned int count);
 
 static inline int zd_ioread32_locked(struct zd_chip *chip, u32 *value,
-	                             const zd_addr_t addr)
+				     const u16 addr)
 {
-	return zd_ioread32v_locked(chip, value, (const zd_addr_t *)&addr, 1);
+	return zd_ioread32v_locked(chip, value, &addr, 1);
 }
 
 static inline int zd_iowrite16_locked(struct zd_chip *chip, u16 value,
-	                              zd_addr_t addr)
+				      u16 addr)
 {
 	struct zd_ioreq16 ioreq;
 
@@ -819,7 +819,7 @@ int _zd_iowrite32v_locked(struct zd_chip *chip, const struct zd_ioreq32 *ioreqs,
 			  unsigned int count);
 
 static inline int zd_iowrite32_locked(struct zd_chip *chip, u32 value,
-	                              zd_addr_t addr)
+				      u16 addr)
 {
 	struct zd_ioreq32 ioreq;
 
@@ -848,11 +848,11 @@ int zd_rfwritev_cr_locked(struct zd_chip *chip,
 /* Locking functions for reading and writing registers.
  * The different parameters are intentional.
  */
-int zd_ioread16(struct zd_chip *chip, zd_addr_t addr, u16 *value);
-int zd_iowrite16(struct zd_chip *chip, zd_addr_t addr, u16 value);
-int zd_ioread32(struct zd_chip *chip, zd_addr_t addr, u32 *value);
-int zd_iowrite32(struct zd_chip *chip, zd_addr_t addr, u32 value);
-int zd_ioread32v(struct zd_chip *chip, const zd_addr_t *addresses,
+int zd_ioread16(struct zd_chip *chip, u16 addr, u16 *value);
+int zd_iowrite16(struct zd_chip *chip, u16 addr, u16 value);
+int zd_ioread32(struct zd_chip *chip, u16 addr, u32 *value);
+int zd_iowrite32(struct zd_chip *chip, u16 addr, u32 value);
+int zd_ioread32v(struct zd_chip *chip, const u16 *addresses,
 	          u32 *values, unsigned int count);
 int zd_iowrite32a(struct zd_chip *chip, const struct zd_ioreq32 *ioreqs,
 	           unsigned int count);
diff --git a/drivers/net/wireless/zd1211rw/zd_def.h b/drivers/net/wireless/zd1211rw/zd_def.h
index 6ac597f..7ae5f54 100644
--- a/drivers/net/wireless/zd1211rw/zd_def.h
+++ b/drivers/net/wireless/zd1211rw/zd_def.h
@@ -25,8 +25,6 @@
 #include <linux/stringify.h>
 #include <linux/device.h>
 
-typedef u16 __nocast zd_addr_t;
-
 #define dev_printk_f(level, dev, fmt, args...) \
 	dev_printk(level, dev, "%s() " fmt, __func__, ##args)
 
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index f0e5e94..4e2a860 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -316,7 +316,7 @@ error:
 
 /* Read data from device address space using "firmware interface" which does
  * not require firmware to be loaded. */
-int zd_usb_read_fw(struct zd_usb *usb, zd_addr_t addr, u8 *data, u16 len)
+int zd_usb_read_fw(struct zd_usb *usb, u16 addr, u8 *data, u16 len)
 {
 	int r;
 	struct usb_device *udev = zd_usb_to_usbdev(usb);
@@ -1348,7 +1348,7 @@ error_unlock:
 }
 
 int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
-	             const zd_addr_t *addresses, unsigned int count)
+		     const u16 *addresses, unsigned int count)
 {
 	int r;
 	int i, req_len, actual_req_len;
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index 049f8b9..82f38cf 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -149,12 +149,12 @@ struct read_regs_int {
 };
 
 struct zd_ioreq16 {
-	zd_addr_t addr;
+	u16 addr;
 	u16 value;
 };
 
 struct zd_ioreq32 {
-	zd_addr_t addr;
+	u16 addr;
 	u32 value;
 };
 
@@ -246,12 +246,12 @@ void zd_usb_disable_tx(struct zd_usb *usb);
 int zd_usb_tx(struct zd_usb *usb, struct sk_buff *skb);
 
 int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
-	         const zd_addr_t *addresses, unsigned int count);
+		     const u16 *addresses, unsigned int count);
 
 static inline int zd_usb_ioread16(struct zd_usb *usb, u16 *value,
-	                      const zd_addr_t addr)
+				  const u16 addr)
 {
-	return zd_usb_ioread16v(usb, value, (const zd_addr_t *)&addr, 1);
+	return zd_usb_ioread16v(usb, value, &addr, 1);
 }
 
 int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
@@ -259,7 +259,7 @@ int zd_usb_iowrite16v(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
 
 int zd_usb_rfwrite(struct zd_usb *usb, u32 value, u8 bits);
 
-int zd_usb_read_fw(struct zd_usb *usb, zd_addr_t addr, u8 *data, u16 len);
+int zd_usb_read_fw(struct zd_usb *usb, u16 addr, u8 *data, u16 len);
 
 extern struct workqueue_struct *zd_workqueue;
 
-- 
1.6.0.6


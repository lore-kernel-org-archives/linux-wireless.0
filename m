Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:49449 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3CBMLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 07:11:45 -0500
Date: Sat, 2 Mar 2013 07:11:40 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com
Subject: [PATCH/RFC v3] Add eeprom/efuse write supprot to rt2800usb
Message-ID: <20130302121139.GA1077@shaftnet.org> (sfid-20130302_131159_003776_5A258A0D)
References: <1360872580-24334-1-git-send-email-pizza@shaftnet.org>
 <1360872580-24334-2-git-send-email-pizza@shaftnet.org>
 <CAOZOX0Vva3ObJp6hW85i6m33zYxieTsbER78UVrp23uo=t4B9A@mail.gmail.com>
 <20130215125710.GB23323@shaftnet.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
In-Reply-To: <20130215125710.GB23323@shaftnet.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--/NkBOFFp2J2Af1nK
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The major addition from the last patch is the addition of eFuse write=20
support.  I used the the Ralink vendor drivers (gack!) as a reference.

There are several things that need to be addressed before this can be=20
committed (indepdently of any comments y'all may have):

 * some printk debug output is still present
 * Probably won't pass checkpatch scrutiny
 * debugfs interface to trigger load/store of eeprom data is unchanged
 * Only rt2800usb (rt2870+eeprom, rt3070+eeprom, rt3070+efuse) is tested
 * uses hardcoded efuse offsets/sizes for rt3070  (see '//' comments)

The latter point is the critical one, and I'd like suggestions on how to=20
handle this -- The vendor drivers use hardcoded values based on the=20
identified chip.  So far I've itentified four distinct types by perusing=20
the vendor USB drivers.  (PCI/SoC chips mayhave more variants too)

Is it worth setting globally at module init time, or just=20
hardcoded/handled in this function based on chip detection? Due to how=20
the efuse block mapping is handled, if the wrong offsets (or lengths)=20
are used, it's possible to brick the module.

If there's a reasonable shot at getting this patch (or a reworked=20
version) committed, I'll iterate this until it's acceptible.

Let me know,

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="xxxx-rt2800_eeprom_efuse_write.diff"
Content-Transfer-Encoding: quoted-printable

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt=
2x00/rt2800.h
index 4db1088..1cdfe0c 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -641,10 +641,18 @@
 #define EFUSE_CTRL			0x0580
 #define EFUSE_CTRL_ADDRESS_IN		FIELD32(0x03fe0000)
 #define EFUSE_CTRL_MODE			FIELD32(0x000000c0)
+#define EFUSE_CTRL_ADDRESS_OUT		FIELD32(0x0000003f)
 #define EFUSE_CTRL_KICK			FIELD32(0x40000000)
 #define EFUSE_CTRL_PRESENT		FIELD32(0x80000000)
=20
 /*
+ * EFUSE MODE selection
+ */
+#define EFUSE_CTRL_MODE_READ_VIRTUAL    0
+#define EFUSE_CTRL_MODE_READ_PHYSICAL   1
+#define EFUSE_CTRL_MODE_WRITE_PHYSICAL  3
+
+/*
  * EFUSE_DATA0
  */
 #define EFUSE_DATA0			0x0590
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless=
/rt2x00/rt2800lib.c
index 197b446..f882a93 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4574,7 +4574,8 @@ int rt2800_efuse_detect(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800_efuse_detect);
=20
-static void rt2800_efuse_read(struct rt2x00_dev *rt2x00dev, unsigned int i)
+static u8 rt2800_efuse_read(struct rt2x00_dev *rt2x00dev, u16 *eeprom,
+			    unsigned int addr, int physical)
 {
 	u32 reg;
 	u16 efuse_ctrl_reg;
@@ -4582,6 +4583,7 @@ static void rt2800_efuse_read(struct rt2x00_dev *rt2x=
00dev, unsigned int i)
 	u16 efuse_data1_reg;
 	u16 efuse_data2_reg;
 	u16 efuse_data3_reg;
+	u8 physaddr;
=20
 	if (rt2x00_rt(rt2x00dev, RT3290)) {
 		efuse_ctrl_reg =3D EFUSE_CTRL_3290;
@@ -4599,36 +4601,193 @@ static void rt2800_efuse_read(struct rt2x00_dev *r=
t2x00dev, unsigned int i)
 	mutex_lock(&rt2x00dev->csr_mutex);
=20
 	rt2800_register_read_lock(rt2x00dev, efuse_ctrl_reg, &reg);
-	rt2x00_set_field32(&reg, EFUSE_CTRL_ADDRESS_IN, i);
-	rt2x00_set_field32(&reg, EFUSE_CTRL_MODE, 0);
+	rt2x00_set_field32(&reg, EFUSE_CTRL_ADDRESS_IN, addr);
+	rt2x00_set_field32(&reg, EFUSE_CTRL_MODE,
+			   physical ? EFUSE_CTRL_MODE_READ_PHYSICAL :
+			   EFUSE_CTRL_MODE_READ_VIRTUAL);
 	rt2x00_set_field32(&reg, EFUSE_CTRL_KICK, 1);
 	rt2800_register_write_lock(rt2x00dev, efuse_ctrl_reg, reg);
=20
 	/* Wait until the EEPROM has been loaded */
 	rt2800_regbusy_read(rt2x00dev, efuse_ctrl_reg, EFUSE_CTRL_KICK, &reg);
+
+	/* Get the physical block mapping */
+	physaddr =3D rt2x00_get_field32(reg, EFUSE_CTRL_ADDRESS_OUT);
+
+	/* If we have no mapping for this address, don't bother reading. */
+	if (!physical && physaddr =3D=3D 0x3f) {
+		memset(eeprom, 0xff, 16);
+		goto done;
+	}
+
 	/* Apparently the data is read from end to start */
 	rt2800_register_read_lock(rt2x00dev, efuse_data3_reg, &reg);
 	/* The returned value is in CPU order, but eeprom is le */
-	*(u32 *)&rt2x00dev->eeprom[i] =3D cpu_to_le32(reg);
+	*(u32 *)&eeprom[0] =3D cpu_to_le32(reg);
 	rt2800_register_read_lock(rt2x00dev, efuse_data2_reg, &reg);
-	*(u32 *)&rt2x00dev->eeprom[i + 2] =3D cpu_to_le32(reg);
+	*(u32 *)&eeprom[2] =3D cpu_to_le32(reg);
 	rt2800_register_read_lock(rt2x00dev, efuse_data1_reg, &reg);
-	*(u32 *)&rt2x00dev->eeprom[i + 4] =3D cpu_to_le32(reg);
+	*(u32 *)&eeprom[4] =3D cpu_to_le32(reg);
 	rt2800_register_read_lock(rt2x00dev, efuse_data0_reg, &reg);
-	*(u32 *)&rt2x00dev->eeprom[i + 6] =3D cpu_to_le32(reg);
+	*(u32 *)&eeprom[6] =3D cpu_to_le32(reg);
=20
+done:
 	mutex_unlock(&rt2x00dev->csr_mutex);
+
+	return physaddr;
 }
=20
-void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
+void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev, u16 *eeprom,
+			      const u16 length)
 {
 	unsigned int i;
+	u8 addr;
=20
-	for (i =3D 0; i < EEPROM_SIZE / sizeof(u16); i +=3D 8)
-		rt2800_efuse_read(rt2x00dev, i);
+	for (i =3D 0; i < length / sizeof(u16); i +=3D 8) {
+		addr =3D rt2800_efuse_read(rt2x00dev, eeprom + i, i, 0);
+		printk(KERN_INFO "efuse @ %x: physaddr %x\n", i * 2, addr);
+	}
 }
 EXPORT_SYMBOL_GPL(rt2800_read_eeprom_efuse);
=20
+static void rt2800_efuse_write_phys(struct rt2x00_dev *rt2x00dev, u16 *eep=
rom,
+				    unsigned int addr)
+
+{
+	u32 reg;
+	u16 efuse_ctrl_reg;
+	u16 efuse_data0_reg;
+	u16 efuse_data1_reg;
+	u16 efuse_data2_reg;
+	u16 efuse_data3_reg;
+
+	if (rt2x00_rt(rt2x00dev, RT3290)) {
+		efuse_ctrl_reg =3D EFUSE_CTRL_3290;
+		efuse_data0_reg =3D EFUSE_DATA0_3290;
+		efuse_data1_reg =3D EFUSE_DATA1_3290;
+		efuse_data2_reg =3D EFUSE_DATA2_3290;
+		efuse_data3_reg =3D EFUSE_DATA3_3290;
+	} else {
+		efuse_ctrl_reg =3D EFUSE_CTRL;
+		efuse_data0_reg =3D EFUSE_DATA0;
+		efuse_data1_reg =3D EFUSE_DATA1;
+		efuse_data2_reg =3D EFUSE_DATA2;
+		efuse_data3_reg =3D EFUSE_DATA3;
+	}
+	mutex_lock(&rt2x00dev->csr_mutex);
+
+	/* Apparently the data is written from end to start */
+	/* And the data needs to be in CPU order (eeprom is LE) */
+	rt2800_register_write_lock(rt2x00dev, efuse_data3_reg, le32_to_cpu(*(u32 =
*)&eeprom[0]));
+	rt2800_register_write_lock(rt2x00dev, efuse_data2_reg, le32_to_cpu(*(u32 =
*)&eeprom[2]));
+	rt2800_register_write_lock(rt2x00dev, efuse_data1_reg, le32_to_cpu(*(u32 =
*)&eeprom[4]));
+	rt2800_register_write_lock(rt2x00dev, efuse_data0_reg, le32_to_cpu(*(u32 =
*)&eeprom[6]));
+
+	rt2800_register_read_lock(rt2x00dev, efuse_ctrl_reg, &reg);
+	rt2x00_set_field32(&reg, EFUSE_CTRL_ADDRESS_IN, addr);
+	rt2x00_set_field32(&reg, EFUSE_CTRL_MODE,
+			   EFUSE_CTRL_MODE_WRITE_PHYSICAL);
+	rt2x00_set_field32(&reg, EFUSE_CTRL_KICK, 1);
+	rt2800_register_write_lock(rt2x00dev, efuse_ctrl_reg, reg);
+
+	/* Wait until the EEPROM has been written */
+	rt2800_regbusy_read(rt2x00dev, efuse_ctrl_reg, EFUSE_CTRL_KICK, &reg);
+
+	mutex_unlock(&rt2x00dev->csr_mutex);
+}
+
+void rt2800_write_eeprom_efuse(struct rt2x00_dev *rt2x00dev, u16 *eeprom,
+			       const u16 length)
+{
+	unsigned int i, j;
+	u16 startblock, endblock;
+	u8 map[64], blocks;
+	u8 map_update =3D 0;
+
+	endblock =3D 0x2fc; // based on device
+	startblock =3D 0x2d0; // based on device
+	blocks =3D 45; // based on device ( =3D=3D startblock /16 )
+
+	/* Read in block map */
+	for (i =3D startblock ; i < endblock ; i +=3D 16) {
+		u32 temp[4];
+		rt2800_efuse_read(rt2x00dev, (u16 *)temp, i>>1, 1);
+		for (j =3D 0 ; j < 4 ; j++)
+			temp[j] =3D cpu_to_le32(temp[j]);
+		memcpy(map + (i - startblock), temp, sizeof(temp));
+	}
+
+	/* Figure out what's changed and write it */
+	for (i =3D 0; i < length / sizeof(u16); i +=3D 8) {
+		u16 temp[8];
+		u8 physblock;
+		u8 newmap =3D 0;
+
+		physblock =3D rt2800_efuse_read(rt2x00dev, temp, i, 0);
+		/* Don't bother if it's not been altered. */
+		if (!memcmp(eeprom + i, temp, sizeof(temp)))
+			continue;
+
+		printk(KERN_INFO "eFuse altered @ %02x, block 0x%02x\n",
+		       i * 2, physblock);
+
+	retry:
+		/* Find a new block if necessary */
+		if (physblock =3D=3D 0x3f) {
+			for (j =3D blocks - 1; j >=3D 0; j--)
+				if (map[j] =3D=3D 0)
+					break;
+			if (j < 0) {
+				printk(KERN_WARNING "No available eFuse blocks, aborting!\n");
+				return;
+			}
+			physblock =3D j;
+			newmap =3D 1;
+			printk(KERN_INFO "Allocating new eFuse block 0x%x\n", physblock);
+		}
+		/* Write updated data to eFuse */
+		rt2800_efuse_write_phys(rt2x00dev, eeprom + i, physblock << 3);
+
+		/* Perform readback test to make sure it "took" */
+		rt2800_efuse_read(rt2x00dev, temp, physblock << 3, 1);
+		if (memcmp(eeprom + i, temp, sizeof(temp))) {
+			printk(KERN_INFO "Block 0x%x readback failed -- marking invalid.\n", ph=
ysblock);
+			/* Invalidate existing map entry */
+			for (j =3D 0; j < 8 ; j++) {
+				if (!(map[physblock] & (1 << j))) {
+					map[physblock] |=3D 1 << j;
+					break;
+				}
+			}
+			map_update =3D 1;
+			physblock =3D 0x3f;
+			goto retry;
+		}
+
+		/* Update map */
+		if (newmap) {
+			u8 addr =3D i >> 3;
+			/* Generate parity */
+			addr |=3D ((~((addr & 0x01) ^ ( addr >> 1 & 0x01) ^  (addr >> 2 & 0x01)=
 ^  (addr >> 3 & 0x01))) << 6) & 0x40;
+			addr |=3D ((~( (addr >> 2 & 0x01) ^ (addr >> 3 & 0x01) ^ (addr >> 4 & 0=
x01) ^ ( addr >> 5 & 0x01))) << 7) & 0x80;
+			map[physblock] =3D addr;
+			map_update =3D 1;
+		}
+	}
+
+	if (map_update) {
+		/* Write updated map */
+		for (i =3D startblock ; i < endblock ; i +=3D 16) {
+			u32 temp[4];
+			memcpy(temp, map + (i - startblock), sizeof(temp));
+			for (j =3D 0 ; j < 4 ; j++)
+				temp[j] =3D le32_to_cpu(temp[j]);
+			rt2800_efuse_write_phys(rt2x00dev, (u16 *)temp, i>>1);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(rt2800_write_eeprom_efuse);
+
 static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	struct rt2800_drv_data *drv_data =3D rt2x00dev->drv_data;
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless=
/rt2x00/rt2800lib.h
index a128cea..c266c79 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -207,7 +207,10 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2800_disable_radio(struct rt2x00_dev *rt2x00dev);
=20
 int rt2800_efuse_detect(struct rt2x00_dev *rt2x00dev);
-void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev);
+void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev, u16 *eeprom,
+			      const u16 length);
+void rt2800_write_eeprom_efuse(struct rt2x00_dev *rt2x00dev, u16 *eeprom,
+			       const u16 length);
=20
 int rt2800_probe_hw(struct rt2x00_dev *rt2x00dev);
=20
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless=
/rt2x00/rt2800pci.c
index 9224d87..7782002 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -173,7 +173,7 @@ static int rt2800pci_efuse_detect(struct rt2x00_dev *rt=
2x00dev)
=20
 static inline void rt2800pci_read_eeprom_efuse(struct rt2x00_dev *rt2x00de=
v)
 {
-	rt2800_read_eeprom_efuse(rt2x00dev);
+	rt2800_read_eeprom_efuse(rt2x00dev, rt2x00dev->eeprom, EEPROM_SIZE);
 }
 #else
 static inline void rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless=
/rt2x00/rt2800usb.c
index 85a4b62..069be20 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -733,12 +733,42 @@ static void rt2800usb_fill_rxdone(struct queue_entry =
*entry,
 }
=20
 /*
+ *  EEPROM manipulation functions,
+ */
+static int rt2800usb_load_eeprom(struct rt2x00_dev *rt2x00dev,
+				 u16 *eeprom, const u16 length)
+{
+	u16 len =3D min_t(u16, length, EEPROM_SIZE);
+
+	if (rt2800_efuse_detect(rt2x00dev))
+		rt2800_read_eeprom_efuse(rt2x00dev, eeprom, len);
+	else
+		rt2x00usb_eeprom_read(rt2x00dev, eeprom, len);
+
+	return len;
+}
+
+static int rt2800usb_store_eeprom(struct rt2x00_dev *rt2x00dev,
+				  u16 *eeprom, const u16 length)
+{
+	u16 len =3D min_t(u16, length, EEPROM_SIZE);
+
+	if (rt2800_efuse_detect(rt2x00dev))
+		rt2800_write_eeprom_efuse(rt2x00dev, eeprom, len);
+	else
+		rt2x00usb_eeprom_write(rt2x00dev, eeprom, len);
+
+	return length;
+}
+
+/*
  * Device probe functions.
  */
 static void rt2800usb_read_eeprom(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2800_efuse_detect(rt2x00dev))
-		rt2800_read_eeprom_efuse(rt2x00dev);
+		rt2800_read_eeprom_efuse(rt2x00dev, rt2x00dev->eeprom,
+					 EEPROM_SIZE);
 	else
 		rt2x00usb_eeprom_read(rt2x00dev, rt2x00dev->eeprom,
 				      EEPROM_SIZE);
@@ -844,6 +874,9 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops =
=3D {
 	.config			=3D rt2800_config,
 	.sta_add		=3D rt2800_sta_add,
 	.sta_remove		=3D rt2800_sta_remove,
+
+	.eeprom_load            =3D rt2800usb_load_eeprom,
+	.eeprom_store           =3D rt2800usb_store_eeprom,
 };
=20
 static const struct data_queue_desc rt2800usb_queue_rx =3D {
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt=
2x00/rt2x00.h
index 0751b35..8fd81f5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -648,6 +648,12 @@ struct rt2x00lib_ops {
 			struct ieee80211_sta *sta);
 	int (*sta_remove) (struct rt2x00_dev *rt2x00dev,
 			   int wcid);
+
+	/* EEPROM manipulation */
+	int (*eeprom_load) (struct rt2x00_dev *rt2x00dev,
+			    u16 *eeprom, const u16 max_length);
+	int (*eeprom_store) (struct rt2x00_dev *rt2x00dev,
+			     u16 *eeprom, const u16 max_length);
 };
=20
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wirele=
ss/rt2x00/rt2x00debug.c
index 3bb8caf..1b8de4b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -86,6 +86,7 @@ struct rt2x00debug_intf {
 	struct dentry *csr_val_entry;
 	struct dentry *eeprom_off_entry;
 	struct dentry *eeprom_val_entry;
+	struct dentry *eeprom_commit_entry;
 	struct dentry *bbp_off_entry;
 	struct dentry *bbp_val_entry;
 	struct dentry *rf_off_entry;
@@ -650,6 +651,44 @@ static struct dentry *rt2x00debug_create_file_chipset(=
const char *name,
 	return debugfs_create_blob(name, S_IRUSR, intf->driver_folder, blob);
 }
=20
+static ssize_t rt2x00debug_eeprom_commit_write(struct file *file,
+					       const char __user *buf,
+					       size_t length,
+					       loff_t *offset)
+{
+	struct rt2x00debug_intf *intf =3D file->private_data;
+
+	if (intf->rt2x00dev->ops->lib->eeprom_store)
+		intf->rt2x00dev->ops->lib->eeprom_store(intf->rt2x00dev,
+							intf->rt2x00dev->eeprom,
+							intf->rt2x00dev->ops->eeprom_size);
+
+	return length;
+}
+static ssize_t rt2x00debug_eeprom_commit_read(struct file *file,
+					      char __user *buf,
+					      size_t length,
+					      loff_t *offset)
+{
+	struct rt2x00debug_intf *intf =3D file->private_data;
+
+	if (intf->rt2x00dev->ops->lib->eeprom_load)
+		intf->rt2x00dev->ops->lib->eeprom_load(intf->rt2x00dev,
+						       intf->rt2x00dev->eeprom,
+						       intf->rt2x00dev->ops->eeprom_size);
+
+	return 0;
+}
+
+static const struct file_operations rt2x00debug_fop_eeprom_commit =3D {
+	.owner		=3D THIS_MODULE,
+	.write		=3D rt2x00debug_eeprom_commit_write,
+	.read		=3D rt2x00debug_eeprom_commit_read,
+	.open		=3D rt2x00debug_file_open,
+	.release	=3D rt2x00debug_file_release,
+	.llseek		=3D default_llseek,
+};
+
 void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
 {
 	const struct rt2x00debug *debug =3D rt2x00dev->ops->debugfs;
@@ -730,6 +769,13 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
=20
 #undef RT2X00DEBUGFS_CREATE_REGISTER_ENTRY
=20
+	intf->eeprom_commit_entry =3D
+		debugfs_create_file("eeprom_commit", S_IRUSR | S_IWUSR,
+				    intf->register_folder,
+				    intf, &rt2x00debug_fop_eeprom_commit);
+	if (IS_ERR(intf->eeprom_commit_entry) || !intf->eeprom_commit_entry)
+		goto exit;
+
 	intf->queue_folder =3D
 	    debugfs_create_dir("queue", intf->driver_folder);
 	if (IS_ERR(intf->queue_folder) || !intf->queue_folder)
@@ -786,6 +832,7 @@ void rt2x00debug_deregister(struct rt2x00_dev *rt2x00de=
v)
 	debugfs_remove(intf->bbp_off_entry);
 	debugfs_remove(intf->eeprom_val_entry);
 	debugfs_remove(intf->eeprom_off_entry);
+	debugfs_remove(intf->eeprom_commit_entry);
 	debugfs_remove(intf->csr_val_entry);
 	debugfs_remove(intf->csr_off_entry);
 	debugfs_remove(intf->register_folder);
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless=
/rt2x00/rt2x00usb.h
index 323ca7b..f8ed3de 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.h
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
@@ -203,6 +203,25 @@ static inline int rt2x00usb_eeprom_read(struct rt2x00_=
dev *rt2x00dev,
 }
=20
 /**
+ * rt2x00usb_eeprom_write - Write eeprom to device
+ * @rt2x00dev: Pointer to &struct rt2x00_dev
+ * @eeprom: Pointer to eeprom array to copy the information from
+ * @length: Number of bytes to write to the eeprom
+ *
+ * Simple wrapper around rt2x00usb_vendor_request to write the eeprom
+ * to the device. Note that the eeprom argument _must_ be allocated using
+ * kmalloc for correct handling inside the kernel USB layer.
+ */
+static inline int rt2x00usb_eeprom_write(struct rt2x00_dev *rt2x00dev,
+					 __le16 *eeprom, const u16 length)
+{
+	return rt2x00usb_vendor_request(rt2x00dev, USB_EEPROM_WRITE,
+					USB_VENDOR_REQUEST_OUT, 0, 0,
+					eeprom, length,
+					REGISTER_TIMEOUT16(length));
+}
+
+/**
  * rt2x00usb_register_read - Read 32bit register word
  * @rt2x00dev: Device pointer, see &struct rt2x00_dev.
  * @offset: Register offset

--qMm9M+Fa2AknHoGS--

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRMex7PuLgii2759ARAlCLAJ0aHmuFdhEkIsmitTYed3E3c1mfdACfZQbz
zavQAdS2XYPMYU1EpWWKaMc=
=mqY9
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--

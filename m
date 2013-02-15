Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:63900 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161302Ab3BOM5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:15 -0500
Date: Fri, 15 Feb 2013 07:57:11 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH/RFC v2] Add eeprom write supprot to rt2800usb
Message-ID: <20130215125710.GB23323@shaftnet.org> (sfid-20130215_135727_394379_2DC99CB3)
References: <1360872580-24334-1-git-send-email-pizza@shaftnet.org>
 <1360872580-24334-2-git-send-email-pizza@shaftnet.org>
 <CAOZOX0Vva3ObJp6hW85i6m33zYxieTsbER78UVrp23uo=t4B9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
In-Reply-To: <CAOZOX0Vva3ObJp6hW85i6m33zYxieTsbER78UVrp23uo=t4B9A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--69pVuxX8awAiJ7fD
Content-Type: multipart/mixed; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 14, 2013 at 09:25:56PM +0100, Ivo Van Doorn wrote:
> rt2800 specific code doesn't belong in the generic code. You should=20
> make your solution completely driver independent.

Okay, I've attached my current WIP code.  I want to make sure I'm on an=20
acceptible track before I proceed further.

This patch is more invasive than the first, but functionally it's=20
identical to my first patch.

Comments?

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rt2800usb_eeprom_take2.diff"
Content-Transfer-Encoding: quoted-printable

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless=
/rt2x00/rt2800lib.c
index 197b446..82221e0 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4574,7 +4574,8 @@ int rt2800_efuse_detect(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800_efuse_detect);
=20
-static void rt2800_efuse_read(struct rt2x00_dev *rt2x00dev, unsigned int i)
+static void rt2800_efuse_read(struct rt2x00_dev *rt2x00dev,
+			      u16 *eeprom, unsigned int i)
 {
 	u32 reg;
 	u16 efuse_ctrl_reg;
@@ -4609,23 +4610,24 @@ static void rt2800_efuse_read(struct rt2x00_dev *rt=
2x00dev, unsigned int i)
 	/* Apparently the data is read from end to start */
 	rt2800_register_read_lock(rt2x00dev, efuse_data3_reg, &reg);
 	/* The returned value is in CPU order, but eeprom is le */
-	*(u32 *)&rt2x00dev->eeprom[i] =3D cpu_to_le32(reg);
+	*(u32 *)&eeprom[i] =3D cpu_to_le32(reg);
 	rt2800_register_read_lock(rt2x00dev, efuse_data2_reg, &reg);
-	*(u32 *)&rt2x00dev->eeprom[i + 2] =3D cpu_to_le32(reg);
+	*(u32 *)&eeprom[i + 2] =3D cpu_to_le32(reg);
 	rt2800_register_read_lock(rt2x00dev, efuse_data1_reg, &reg);
-	*(u32 *)&rt2x00dev->eeprom[i + 4] =3D cpu_to_le32(reg);
+	*(u32 *)&eeprom[i + 4] =3D cpu_to_le32(reg);
 	rt2800_register_read_lock(rt2x00dev, efuse_data0_reg, &reg);
-	*(u32 *)&rt2x00dev->eeprom[i + 6] =3D cpu_to_le32(reg);
+	*(u32 *)&eeprom[i + 6] =3D cpu_to_le32(reg);
=20
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
=20
-void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev)
+void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev,
+			      u16 *eeprom, const u16 length)
 {
 	unsigned int i;
=20
-	for (i =3D 0; i < EEPROM_SIZE / sizeof(u16); i +=3D 8)
-		rt2800_efuse_read(rt2x00dev, i);
+	for (i =3D 0; i < length / sizeof(u16); i +=3D 8)
+		rt2800_efuse_read(rt2x00dev, eeprom, i);
 }
 EXPORT_SYMBOL_GPL(rt2800_read_eeprom_efuse);
=20
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless=
/rt2x00/rt2800lib.h
index a128cea..3c5452d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -207,7 +207,8 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev);
 void rt2800_disable_radio(struct rt2x00_dev *rt2x00dev);
=20
 int rt2800_efuse_detect(struct rt2x00_dev *rt2x00dev);
-void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev);
+void rt2800_read_eeprom_efuse(struct rt2x00_dev *rt2x00dev,
+			      u16 *eeprom, const u16 length);
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
index 85a4b62..9a90fa1 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -733,12 +733,43 @@ static void rt2800usb_fill_rxdone(struct queue_entry =
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
+		rt2800_read_eeprom_efuse(rt2x00dev, eeprom,
+					 len);
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
+		return -EINVAL;
+
+	rt2x00usb_eeprom_write(rt2x00dev, eeprom, len);
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
@@ -844,6 +875,9 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops =
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

--i9LlY+UWpKt15+FH--

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRHjCmPuLgii2759ARAm4EAKC+1xESLP5wTItwcBUilpp4tW5oOgCghpdC
B8GFnDFC1pMr+QniG5mSVtI=
=9OnI
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--

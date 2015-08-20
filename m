Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:51951 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbbHTP1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 11:27:05 -0400
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
	m.szyprowski@samsung.com, pebolle@tiscali.nl,
	Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 3/3] nfc: s3fwrn5: Add driver for Samsung S3FWRN5 NFC Chip
Date: Thu, 20 Aug 2015 17:26:02 +0200
Message-id: <1440084362-27909-4-git-send-email-r.baldyga@samsung.com> (sfid-20150820_172731_424390_439B915D)
In-reply-to: <1440084362-27909-1-git-send-email-r.baldyga@samsung.com>
References: <1440084362-27909-1-git-send-email-r.baldyga@samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add driver for Samsung S3FWRN5 NFC controller.
S3FWRN5 is using NCI protocol and I2C communication interface.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 .../devicetree/bindings/net/nfc/s3fwrn5.txt        |  27 ++
 MAINTAINERS                                        |   6 +
 drivers/nfc/Kconfig                                |   1 +
 drivers/nfc/Makefile                               |   1 +
 drivers/nfc/s3fwrn5/Kconfig                        |  19 +
 drivers/nfc/s3fwrn5/Makefile                       |  11 +
 drivers/nfc/s3fwrn5/core.c                         | 219 +++++++++
 drivers/nfc/s3fwrn5/firmware.c                     | 511 +++++++++++++++++++++
 drivers/nfc/s3fwrn5/firmware.h                     | 111 +++++
 drivers/nfc/s3fwrn5/i2c.c                          | 306 ++++++++++++
 drivers/nfc/s3fwrn5/nci.c                          | 165 +++++++
 drivers/nfc/s3fwrn5/nci.h                          |  89 ++++
 drivers/nfc/s3fwrn5/s3fwrn5.h                      |  99 ++++
 13 files changed, 1565 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt
 create mode 100644 drivers/nfc/s3fwrn5/Kconfig
 create mode 100644 drivers/nfc/s3fwrn5/Makefile
 create mode 100644 drivers/nfc/s3fwrn5/core.c
 create mode 100644 drivers/nfc/s3fwrn5/firmware.c
 create mode 100644 drivers/nfc/s3fwrn5/firmware.h
 create mode 100644 drivers/nfc/s3fwrn5/i2c.c
 create mode 100644 drivers/nfc/s3fwrn5/nci.c
 create mode 100644 drivers/nfc/s3fwrn5/nci.h
 create mode 100644 drivers/nfc/s3fwrn5/s3fwrn5.h

diff --git a/Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt b/Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt
new file mode 100644
index 0000000..fb1e75f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt
@@ -0,0 +1,27 @@
+* Samsung S3FWRN5 NCI NFC Controller
+
+Required properties:
+- compatible: Should be "samsung,s3fwrn5-i2c".
+- reg: address on the bus
+- interrupt-parent: phandle for the interrupt gpio controller
+- interrupts: GPIO interrupt to which the chip is connected
+- s3fwrn5,en-gpios: Output GPIO pin used for enabling/disabling the chip
+- s3fwrn5,fw-gpios: Output GPIO pin used to enter firmware mode and
+  sleep/wakeup control
+
+Example:
+
+&hsi2c_4 {
+	status = "okay";
+	s3fwrn5@27 {
+		compatible = "samsung,s3fwrn5-i2c";
+
+		reg = <0x27>;
+
+		interrupt-parent = <&gpa1>;
+		interrupts = <3 0 0>;
+
+		s3fwrn5,en-gpios = <&gpf1 4 0>;
+		s3fwrn5,fw-gpios = <&gpj0 2 0>;
+	};
+};
diff --git a/MAINTAINERS b/MAINTAINERS
index ca51eba..7a3b1b9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8871,6 +8871,12 @@ L:	linux-media@vger.kernel.org
 S:	Supported
 F:	drivers/media/i2c/s5k5baf.c
 
+SAMSUNG S3FWRN5 NFC DRIVER
+M:	Robert Baldyga <r.baldyga@samsung.com>
+L:	linux-nfc@lists.01.org (moderated for non-subscribers)
+S:	Supported
+F:	drivers/nfc/s3fwrn5
+
 SAMSUNG SOC CLOCK DRIVERS
 M:	Sylwester Nawrocki <s.nawrocki@samsung.com>
 M:	Tomasz Figa <tomasz.figa@gmail.com>
diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
index 722673c..6639cd1 100644
--- a/drivers/nfc/Kconfig
+++ b/drivers/nfc/Kconfig
@@ -74,4 +74,5 @@ source "drivers/nfc/nfcmrvl/Kconfig"
 source "drivers/nfc/st21nfca/Kconfig"
 source "drivers/nfc/st-nci/Kconfig"
 source "drivers/nfc/nxp-nci/Kconfig"
+source "drivers/nfc/s3fwrn5/Kconfig"
 endmenu
diff --git a/drivers/nfc/Makefile b/drivers/nfc/Makefile
index 368b6df..2757fe1 100644
--- a/drivers/nfc/Makefile
+++ b/drivers/nfc/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_NFC_TRF7970A)	+= trf7970a.o
 obj-$(CONFIG_NFC_ST21NFCA)  	+= st21nfca/
 obj-$(CONFIG_NFC_ST_NCI)	+= st-nci/
 obj-$(CONFIG_NFC_NXP_NCI)	+= nxp-nci/
+obj-$(CONFIG_NFC_S3FWRN5)	+= s3fwrn5/
diff --git a/drivers/nfc/s3fwrn5/Kconfig b/drivers/nfc/s3fwrn5/Kconfig
new file mode 100644
index 0000000..7e3b255
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/Kconfig
@@ -0,0 +1,19 @@
+config NFC_S3FWRN5
+	tristate
+	---help---
+	  Core driver for Samsung S3FWRN5 NFC chip. Contains core utilities
+	  of chip. It's intended to be used by PHYs to avoid duplicating lots
+	  of common code.
+
+config NFC_S3FWRN5_I2C
+	tristate "Samsung S3FWRN5 I2C support"
+	depends on NFC_NCI && I2C
+	select NFC_S3FWRN5
+	default n
+	---help---
+	  This module adds support for an I2C interface to the S3FWRN5 chip.
+	  Select this if your platform is using the I2C bus.
+
+	  To compile this driver as a module, choose m here. The module will
+	  be called s3fwrn5_i2c.ko.
+	  Say N if unsure.
diff --git a/drivers/nfc/s3fwrn5/Makefile b/drivers/nfc/s3fwrn5/Makefile
new file mode 100644
index 0000000..3381c34
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/Makefile
@@ -0,0 +1,11 @@
+#
+# Makefile for Samsung S3FWRN5 NFC driver
+#
+
+s3fwrn5-objs = core.o firmware.o nci.o
+s3fwrn5_i2c-objs = i2c.o
+
+obj-$(CONFIG_NFC_S3FWRN5) += s3fwrn5.o
+obj-$(CONFIG_NFC_S3FWRN5_I2C) += s3fwrn5_i2c.o
+
+ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
diff --git a/drivers/nfc/s3fwrn5/core.c b/drivers/nfc/s3fwrn5/core.c
new file mode 100644
index 0000000..0d866ca
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/core.c
@@ -0,0 +1,219 @@
+/*
+ * NCI based driver for Samsung S3FWRN5 NFC chip
+ *
+ * Copyright (C) 2015 Samsung Electrnoics
+ * Robert Baldyga <r.baldyga@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <net/nfc/nci_core.h>
+
+#include "s3fwrn5.h"
+#include "firmware.h"
+#include "nci.h"
+
+#define S3FWRN5_NFC_PROTOCOLS  (NFC_PROTO_JEWEL_MASK | \
+				NFC_PROTO_MIFARE_MASK | \
+				NFC_PROTO_FELICA_MASK | \
+				NFC_PROTO_ISO14443_MASK | \
+				NFC_PROTO_ISO14443_B_MASK | \
+				NFC_PROTO_ISO15693_MASK)
+
+static int s3fwrn5_firmware_update(struct s3fwrn5_info *info)
+{
+	bool need_update;
+	int ret;
+
+	s3fwrn5_fw_init(&info->fw_info, "sec_s3fwrn5_firmware.bin");
+
+	/* Update firmware */
+
+	s3fwrn5_set_wake(info, false);
+	s3fwrn5_set_mode(info, S3FWRN5_MODE_FW);
+
+	ret = s3fwrn5_fw_setup(&info->fw_info);
+	if (ret < 0)
+		return ret;
+
+	need_update = s3fwrn5_fw_check_version(&info->fw_info,
+		info->ndev->manufact_specific_info);
+	if (!need_update)
+		goto out;
+
+	dev_info(&info->ndev->nfc_dev->dev, "Detected new firmware version\n");
+
+	ret = s3fwrn5_fw_download(&info->fw_info);
+	if (ret < 0)
+		goto out;
+
+	/* Update RF configuration */
+
+	s3fwrn5_set_mode(info, S3FWRN5_MODE_NCI);
+
+	s3fwrn5_set_wake(info, true);
+	ret = s3fwrn5_nci_rf_configure(info, "sec_s3fwrn5_rfreg.bin");
+	s3fwrn5_set_wake(info, false);
+
+out:
+	s3fwrn5_set_mode(info, S3FWRN5_MODE_COLD);
+	s3fwrn5_fw_cleanup(&info->fw_info);
+	return ret;
+}
+
+static int s3fwrn5_nci_open(struct nci_dev *ndev)
+{
+	struct s3fwrn5_info *info = nci_get_drvdata(ndev);
+
+	if (s3fwrn5_get_mode(info) != S3FWRN5_MODE_COLD)
+		return  -EBUSY;
+
+	s3fwrn5_set_mode(info, S3FWRN5_MODE_NCI);
+	s3fwrn5_set_wake(info, true);
+
+	return 0;
+}
+
+static int s3fwrn5_nci_close(struct nci_dev *ndev)
+{
+	struct s3fwrn5_info *info = nci_get_drvdata(ndev);
+
+	s3fwrn5_set_wake(info, false);
+	s3fwrn5_set_mode(info, S3FWRN5_MODE_COLD);
+
+	return 0;
+}
+
+static int s3fwrn5_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
+{
+	struct s3fwrn5_info *info = nci_get_drvdata(ndev);
+	int ret;
+
+	mutex_lock(&info->mutex);
+
+	if (s3fwrn5_get_mode(info) != S3FWRN5_MODE_NCI) {
+		mutex_unlock(&info->mutex);
+		return -EINVAL;
+	}
+
+	ret = s3fwrn5_write(info, skb);
+	if (ret < 0)
+		kfree_skb(skb);
+
+	mutex_unlock(&info->mutex);
+	return ret;
+}
+
+static int s3fwrn5_nci_post_setup(struct nci_dev *ndev)
+{
+	struct s3fwrn5_info *info = nci_get_drvdata(ndev);
+	int ret;
+
+	ret = s3fwrn5_firmware_update(info);
+	if (ret < 0)
+		goto out;
+
+	/* NCI core reset */
+
+	s3fwrn5_set_mode(info, S3FWRN5_MODE_NCI);
+	s3fwrn5_set_wake(info, true);
+
+	ret = nci_core_reset(info->ndev);
+	if (ret < 0)
+		goto out;
+
+	ret = nci_core_init(info->ndev);
+
+out:
+	return ret;
+}
+
+static struct nci_ops s3fwrn5_nci_ops = {
+	.open = s3fwrn5_nci_open,
+	.close = s3fwrn5_nci_close,
+	.send = s3fwrn5_nci_send,
+	.post_setup = s3fwrn5_nci_post_setup,
+};
+
+int s3fwrn5_probe(struct nci_dev **ndev, void *phy_id, struct device *pdev,
+	struct s3fwrn5_phy_ops *phy_ops, unsigned int max_payload)
+{
+	struct s3fwrn5_info *info;
+	int ret;
+
+	info = devm_kzalloc(pdev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->phy_id = phy_id;
+	info->pdev = pdev;
+	info->phy_ops = phy_ops;
+	info->max_payload = max_payload;
+	mutex_init(&info->mutex);
+
+	s3fwrn5_set_mode(info, S3FWRN5_MODE_COLD);
+
+	s3fwrn5_nci_get_prop_ops(&s3fwrn5_nci_ops.prop_ops,
+		&s3fwrn5_nci_ops.n_prop_ops);
+
+	info->ndev = nci_allocate_device(&s3fwrn5_nci_ops,
+		S3FWRN5_NFC_PROTOCOLS, 0, 0);
+	if (!info->ndev)
+		return -ENOMEM;
+
+	nci_set_parent_dev(info->ndev, pdev);
+	nci_set_drvdata(info->ndev, info);
+
+	ret = nci_register_device(info->ndev);
+	if (ret < 0) {
+		nci_free_device(info->ndev);
+		return ret;
+	}
+
+	info->fw_info.ndev = info->ndev;
+
+	*ndev = info->ndev;
+
+	return ret;
+}
+EXPORT_SYMBOL(s3fwrn5_probe);
+
+void s3fwrn5_remove(struct nci_dev *ndev)
+{
+	struct s3fwrn5_info *info = nci_get_drvdata(ndev);
+
+	s3fwrn5_set_mode(info, S3FWRN5_MODE_COLD);
+
+	nci_unregister_device(ndev);
+	nci_free_device(ndev);
+}
+EXPORT_SYMBOL(s3fwrn5_remove);
+
+int s3fwrn5_recv_frame(struct nci_dev *ndev, struct sk_buff *skb,
+	enum s3fwrn5_mode mode)
+{
+	switch (mode) {
+	case S3FWRN5_MODE_NCI:
+		return nci_recv_frame(ndev, skb);
+	case S3FWRN5_MODE_FW:
+		return s3fwrn5_fw_recv_frame(ndev, skb);
+	default:
+		return -ENODEV;
+	}
+}
+EXPORT_SYMBOL(s3fwrn5_recv_frame);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Samsung S3FWRN5 NFC driver");
+MODULE_AUTHOR("Robert Baldyga <r.baldyga@samsung.com>");
diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
new file mode 100644
index 0000000..64a9025
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/firmware.c
@@ -0,0 +1,511 @@
+/*
+ * NCI based driver for Samsung S3FWRN5 NFC chip
+ *
+ * Copyright (C) 2015 Samsung Electrnoics
+ * Robert Baldyga <r.baldyga@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/completion.h>
+#include <linux/firmware.h>
+#include <linux/crypto.h>
+#include <crypto/sha.h>
+
+#include "s3fwrn5.h"
+#include "firmware.h"
+
+struct s3fwrn5_fw_version {
+	__u8 major;
+	__u8 build1;
+	__u8 build2;
+	__u8 target;
+};
+
+static int s3fwrn5_fw_send_msg(struct s3fwrn5_fw_info *fw_info,
+	struct sk_buff *msg, struct sk_buff **rsp)
+{
+	struct s3fwrn5_info *info =
+		container_of(fw_info, struct s3fwrn5_info, fw_info);
+	long ret;
+
+	reinit_completion(&fw_info->completion);
+
+	ret = s3fwrn5_write(info, msg);
+	if (ret < 0)
+		return ret;
+
+	ret = wait_for_completion_interruptible_timeout(
+		&fw_info->completion, msecs_to_jiffies(1000));
+	if (ret < 0)
+		return ret;
+	else if (ret == 0)
+		return -ENXIO;
+
+	if (!fw_info->rsp)
+		return -EINVAL;
+
+	*rsp = fw_info->rsp;
+	fw_info->rsp = NULL;
+
+	return 0;
+}
+
+static int s3fwrn5_fw_prep_msg(struct s3fwrn5_fw_info *fw_info,
+	struct sk_buff **msg, u8 type, u8 code, const void *data, u16 len)
+{
+	struct s3fwrn5_fw_header hdr;
+	struct sk_buff *skb;
+
+	hdr.type = type | fw_info->parity;
+	fw_info->parity ^= 0x80;
+	hdr.code = code;
+	hdr.len = len;
+
+	skb = alloc_skb(S3FWRN5_FW_HDR_SIZE + len, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	memcpy(skb_put(skb, S3FWRN5_FW_HDR_SIZE), &hdr, S3FWRN5_FW_HDR_SIZE);
+	if (len)
+		memcpy(skb_put(skb, len), data, len);
+
+	*msg = skb;
+
+	return 0;
+}
+
+static int s3fwrn5_fw_get_bootinfo(struct s3fwrn5_fw_info *fw_info,
+	struct s3fwrn5_fw_cmd_get_bootinfo_rsp *bootinfo)
+{
+	struct sk_buff *msg, *rsp = NULL;
+	struct s3fwrn5_fw_header *hdr;
+	int ret;
+
+	/* Send GET_BOOTINFO command */
+
+	ret = s3fwrn5_fw_prep_msg(fw_info, &msg, S3FWRN5_FW_MSG_CMD,
+		S3FWRN5_FW_CMD_GET_BOOTINFO, NULL, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = s3fwrn5_fw_send_msg(fw_info, msg, &rsp);
+	kfree_skb(msg);
+	if (ret < 0)
+		return ret;
+
+	hdr = (struct s3fwrn5_fw_header *) rsp->data;
+	if (hdr->code != S3FWRN5_FW_RET_SUCCESS) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	memcpy(bootinfo, rsp->data + S3FWRN5_FW_HDR_SIZE, 10);
+
+out:
+	kfree_skb(rsp);
+	return ret;
+}
+
+static int s3fwrn5_fw_enter_update_mode(struct s3fwrn5_fw_info *fw_info,
+	const void *hash_data, u16 hash_size,
+	const void *sig_data, u16 sig_size)
+{
+	struct s3fwrn5_fw_cmd_enter_updatemode args;
+	struct sk_buff *msg, *rsp = NULL;
+	struct s3fwrn5_fw_header *hdr;
+	int ret;
+
+	/* Send ENTER_UPDATE_MODE command */
+
+	args.hashcode_size = hash_size;
+	args.signature_size = sig_size;
+
+	ret = s3fwrn5_fw_prep_msg(fw_info, &msg, S3FWRN5_FW_MSG_CMD,
+		S3FWRN5_FW_CMD_ENTER_UPDATE_MODE, &args, sizeof(args));
+	if (ret < 0)
+		return ret;
+
+	ret = s3fwrn5_fw_send_msg(fw_info, msg, &rsp);
+	kfree_skb(msg);
+	if (ret < 0)
+		return ret;
+
+	hdr = (struct s3fwrn5_fw_header *) rsp->data;
+	if (hdr->code != S3FWRN5_FW_RET_SUCCESS) {
+		ret = -EPROTO;
+		goto out;
+	}
+
+	kfree_skb(rsp);
+
+	/* Send hashcode data */
+
+	ret = s3fwrn5_fw_prep_msg(fw_info, &msg, S3FWRN5_FW_MSG_DATA, 0,
+		hash_data, hash_size);
+	if (ret < 0)
+		return ret;
+
+	ret = s3fwrn5_fw_send_msg(fw_info, msg, &rsp);
+	kfree_skb(msg);
+	if (ret < 0)
+		return ret;
+
+	hdr = (struct s3fwrn5_fw_header *) rsp->data;
+	if (hdr->code != S3FWRN5_FW_RET_SUCCESS) {
+		ret = -EPROTO;
+		goto out;
+	}
+
+	kfree_skb(rsp);
+
+	/* Send signature data */
+
+	ret = s3fwrn5_fw_prep_msg(fw_info, &msg, S3FWRN5_FW_MSG_DATA, 0,
+		sig_data, sig_size);
+	if (ret < 0)
+		return ret;
+
+	ret = s3fwrn5_fw_send_msg(fw_info, msg, &rsp);
+	kfree_skb(msg);
+	if (ret < 0)
+		return ret;
+
+	hdr = (struct s3fwrn5_fw_header *) rsp->data;
+	if (hdr->code != S3FWRN5_FW_RET_SUCCESS)
+		ret = -EPROTO;
+
+out:
+	kfree_skb(rsp);
+	return ret;
+}
+
+static int s3fwrn5_fw_update_sector(struct s3fwrn5_fw_info *fw_info,
+	u32 base_addr, const void *data)
+{
+	struct s3fwrn5_fw_cmd_update_sector args;
+	struct sk_buff *msg, *rsp = NULL;
+	struct s3fwrn5_fw_header *hdr;
+	int ret, i;
+
+	/* Send UPDATE_SECTOR command */
+
+	args.base_address = base_addr;
+
+	ret = s3fwrn5_fw_prep_msg(fw_info, &msg, S3FWRN5_FW_MSG_CMD,
+		S3FWRN5_FW_CMD_UPDATE_SECTOR, &args, sizeof(args));
+	if (ret < 0)
+		return ret;
+
+	ret = s3fwrn5_fw_send_msg(fw_info, msg, &rsp);
+	kfree_skb(msg);
+	if (ret < 0)
+		return ret;
+
+	hdr = (struct s3fwrn5_fw_header *) rsp->data;
+	if (hdr->code != S3FWRN5_FW_RET_SUCCESS) {
+		ret = -EPROTO;
+		goto err;
+	}
+
+	kfree_skb(rsp);
+
+	/* Send data split into 256-byte packets */
+
+	for (i = 0; i < 16; ++i) {
+		ret = s3fwrn5_fw_prep_msg(fw_info, &msg,
+			S3FWRN5_FW_MSG_DATA, 0, data+256*i, 256);
+		if (ret < 0)
+			break;
+
+		ret = s3fwrn5_fw_send_msg(fw_info, msg, &rsp);
+		kfree_skb(msg);
+		if (ret < 0)
+			break;
+
+		hdr = (struct s3fwrn5_fw_header *) rsp->data;
+		if (hdr->code != S3FWRN5_FW_RET_SUCCESS) {
+			ret = -EPROTO;
+			goto err;
+		}
+
+		kfree_skb(rsp);
+	}
+
+	return ret;
+
+err:
+	kfree_skb(rsp);
+	return ret;
+}
+
+static int s3fwrn5_fw_complete_update_mode(struct s3fwrn5_fw_info *fw_info)
+{
+	struct sk_buff *msg, *rsp = NULL;
+	struct s3fwrn5_fw_header *hdr;
+	int ret;
+
+	/* Send COMPLETE_UPDATE_MODE command */
+
+	ret = s3fwrn5_fw_prep_msg(fw_info, &msg, S3FWRN5_FW_MSG_CMD,
+		S3FWRN5_FW_CMD_COMPLETE_UPDATE_MODE, NULL, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = s3fwrn5_fw_send_msg(fw_info, msg, &rsp);
+	kfree_skb(msg);
+	if (ret < 0)
+		return ret;
+
+	hdr = (struct s3fwrn5_fw_header *) rsp->data;
+	if (hdr->code != S3FWRN5_FW_RET_SUCCESS)
+		ret = -EPROTO;
+
+	kfree_skb(rsp);
+
+	return ret;
+}
+
+/*
+ * Firmware header stucture:
+ *
+ * 0x00 - 0x0B : Date and time string (w/o NUL termination)
+ * 0x10 - 0x13 : Firmware version
+ * 0x14 - 0x17 : Signature address
+ * 0x18 - 0x1B : Signature size
+ * 0x1C - 0x1F : Firmware image address
+ * 0x20 - 0x23 : Firmware sectors count
+ * 0x24 - 0x27 : Custom signature address
+ * 0x28 - 0x2B : Custom signature size
+ */
+
+#define S3FWRN5_FW_IMAGE_HEADER_SIZE 44
+
+static int s3fwrn5_fw_request_firmware(struct s3fwrn5_fw_info *fw_info)
+{
+	struct s3fwrn5_fw_image *fw = &fw_info->fw;
+	u32 sig_off;
+	u32 image_off;
+	u32 custom_sig_off;
+	int ret;
+
+	ret = request_firmware(&fw->fw, fw_info->fw_name,
+		&fw_info->ndev->nfc_dev->dev);
+	if (ret < 0)
+		return ret;
+
+	if (fw->fw->size < S3FWRN5_FW_IMAGE_HEADER_SIZE)
+		return -EINVAL;
+
+	memcpy(fw->date, fw->fw->data + 0x00, 12);
+	fw->date[12] = '\0';
+
+	memcpy(&fw->version, fw->fw->data + 0x10, 4);
+
+	memcpy(&sig_off, fw->fw->data + 0x14, 4);
+	fw->sig = fw->fw->data + sig_off;
+	memcpy(&fw->sig_size, fw->fw->data + 0x18, 4);
+
+	memcpy(&image_off, fw->fw->data + 0x1C, 4);
+	fw->image = fw->fw->data + image_off;
+	memcpy(&fw->image_sectors, fw->fw->data + 0x20, 4);
+
+	memcpy(&custom_sig_off, fw->fw->data + 0x24, 4);
+	fw->custom_sig = fw->fw->data + custom_sig_off;
+	memcpy(&fw->custom_sig_size, fw->fw->data + 0x28, 4);
+
+	return 0;
+}
+
+static void s3fwrn5_fw_release_firmware(struct s3fwrn5_fw_info *fw_info)
+{
+	release_firmware(fw_info->fw.fw);
+}
+
+static int s3fwrn5_fw_get_base_addr(
+	struct s3fwrn5_fw_cmd_get_bootinfo_rsp *bootinfo, u32 *base_addr)
+{
+	int i;
+	struct {
+		u8 version[4];
+		u32 base_addr;
+	} match[] = {
+		{{0x05, 0x00, 0x00, 0x00}, 0x00005000},
+		{{0x05, 0x00, 0x00, 0x01}, 0x00003000},
+		{{0x05, 0x00, 0x00, 0x02}, 0x00003000},
+		{{0x05, 0x00, 0x00, 0x03}, 0x00003000},
+		{{0x05, 0x00, 0x00, 0x05}, 0x00003000}
+	};
+
+	for (i = 0; i < ARRAY_SIZE(match); ++i)
+		if (bootinfo->hw_version[0] == match[i].version[0] &&
+			bootinfo->hw_version[1] == match[i].version[1] &&
+			bootinfo->hw_version[3] == match[i].version[3]) {
+			*base_addr = match[i].base_addr;
+			return 0;
+		}
+
+	return -EINVAL;
+}
+
+static inline bool
+s3fwrn5_fw_is_custom(struct s3fwrn5_fw_cmd_get_bootinfo_rsp *bootinfo)
+{
+	return !!bootinfo->hw_version[2];
+}
+
+int s3fwrn5_fw_setup(struct s3fwrn5_fw_info *fw_info)
+{
+	struct s3fwrn5_fw_cmd_get_bootinfo_rsp bootinfo;
+	int ret;
+
+	/* Get firmware data */
+
+	ret = s3fwrn5_fw_request_firmware(fw_info);
+	if (ret < 0) {
+		dev_err(&fw_info->ndev->nfc_dev->dev,
+			"Failed to get fw file, ret=%02x\n", ret);
+		return ret;
+	}
+
+	/* Get bootloader info */
+
+	ret = s3fwrn5_fw_get_bootinfo(fw_info, &bootinfo);
+	if (ret < 0) {
+		dev_err(&fw_info->ndev->nfc_dev->dev,
+			"Failed to get bootinfo, ret=%02x\n", ret);
+		goto err;
+	}
+
+	/* Match hardware version to obtain firmware base address */
+
+	ret = s3fwrn5_fw_get_base_addr(&bootinfo, &fw_info->base_addr);
+	if (ret < 0) {
+		dev_err(&fw_info->ndev->nfc_dev->dev,
+			"Unknown hardware version\n");
+		goto err;
+	}
+
+	fw_info->sector_size = bootinfo.sector_size;
+
+	fw_info->sig_size = s3fwrn5_fw_is_custom(&bootinfo) ?
+		fw_info->fw.custom_sig_size : fw_info->fw.sig_size;
+	fw_info->sig = s3fwrn5_fw_is_custom(&bootinfo) ?
+		fw_info->fw.custom_sig : fw_info->fw.sig;
+
+	return 0;
+
+err:
+	s3fwrn5_fw_release_firmware(fw_info);
+	return ret;
+}
+
+bool s3fwrn5_fw_check_version(struct s3fwrn5_fw_info *fw_info, u32 version)
+{
+	struct s3fwrn5_fw_version *new = (void *) &fw_info->fw.version;
+	struct s3fwrn5_fw_version *old = (void *) &version;
+
+	if (new->major > old->major)
+		return true;
+	if (new->build1 > old->build1)
+		return true;
+	if (new->build2 > old->build2)
+		return true;
+
+	return false;
+}
+
+int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
+{
+	struct s3fwrn5_fw_image *fw = &fw_info->fw;
+	u8 hash_data[SHA1_DIGEST_SIZE];
+	struct scatterlist sg;
+	struct hash_desc desc;
+	u32 image_size, off;
+	int ret;
+
+	image_size = fw_info->sector_size * fw->image_sectors;
+
+	/* Compute SHA of firmware data */
+
+	sg_init_one(&sg, fw->image, image_size);
+	desc.tfm = crypto_alloc_hash("sha1", 0, CRYPTO_ALG_ASYNC);
+	crypto_hash_init(&desc);
+	crypto_hash_update(&desc, &sg, image_size);
+	crypto_hash_final(&desc, hash_data);
+	crypto_free_hash(desc.tfm);
+
+	/* Firmware update process */
+
+	dev_info(&fw_info->ndev->nfc_dev->dev,
+		"Firmware update: %s\n", fw_info->fw_name);
+
+	ret = s3fwrn5_fw_enter_update_mode(fw_info, hash_data,
+		SHA1_DIGEST_SIZE, fw_info->sig, fw_info->sig_size);
+	if (ret < 0) {
+		dev_err(&fw_info->ndev->nfc_dev->dev,
+			"Unable to enter update mode\n");
+		goto out;
+	}
+
+	for (off = 0; off < image_size; off += fw_info->sector_size) {
+		ret = s3fwrn5_fw_update_sector(fw_info,
+			fw_info->base_addr + off, fw->image + off);
+		if (ret < 0) {
+			dev_err(&fw_info->ndev->nfc_dev->dev,
+				"Firmware update error (code=%d)\n", ret);
+			goto out;
+		}
+	}
+
+	ret = s3fwrn5_fw_complete_update_mode(fw_info);
+	if (ret < 0) {
+		dev_err(&fw_info->ndev->nfc_dev->dev,
+			"Unable to complete update mode\n");
+		goto out;
+	}
+
+	dev_info(&fw_info->ndev->nfc_dev->dev,
+		"Firmware update: success\n");
+
+out:
+	return ret;
+}
+
+void s3fwrn5_fw_init(struct s3fwrn5_fw_info *fw_info, const char *fw_name)
+{
+	fw_info->parity = 0x00;
+	fw_info->rsp = NULL;
+	fw_info->fw.fw = NULL;
+	strcpy(fw_info->fw_name, fw_name);
+	init_completion(&fw_info->completion);
+}
+
+void s3fwrn5_fw_cleanup(struct s3fwrn5_fw_info *fw_info)
+{
+	s3fwrn5_fw_release_firmware(fw_info);
+}
+
+int s3fwrn5_fw_recv_frame(struct nci_dev *ndev, struct sk_buff *skb)
+{
+	struct s3fwrn5_info *info = nci_get_drvdata(ndev);
+	struct s3fwrn5_fw_info *fw_info = &info->fw_info;
+
+	BUG_ON(fw_info->rsp);
+
+	fw_info->rsp = skb;
+
+	complete(&fw_info->completion);
+
+	return 0;
+}
diff --git a/drivers/nfc/s3fwrn5/firmware.h b/drivers/nfc/s3fwrn5/firmware.h
new file mode 100644
index 0000000..1ec0647
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/firmware.h
@@ -0,0 +1,111 @@
+/*
+ * NCI based driver for Samsung S3FWRN5 NFC chip
+ *
+ * Copyright (C) 2015 Samsung Electrnoics
+ * Robert Baldyga <r.baldyga@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __LOCAL_S3FWRN5_FIRMWARE_H_
+#define __LOCAL_S3FWRN5_FIRMWARE_H_
+
+/* FW Message Types */
+#define S3FWRN5_FW_MSG_CMD			0x00
+#define S3FWRN5_FW_MSG_RSP			0x01
+#define S3FWRN5_FW_MSG_DATA			0x02
+
+/* FW Return Codes */
+#define S3FWRN5_FW_RET_SUCCESS			0x00
+#define S3FWRN5_FW_RET_MESSAGE_TYPE_INVALID	0x01
+#define S3FWRN5_FW_RET_COMMAND_INVALID		0x02
+#define S3FWRN5_FW_RET_PAGE_DATA_OVERFLOW	0x03
+#define S3FWRN5_FW_RET_SECT_DATA_OVERFLOW	0x04
+#define S3FWRN5_FW_RET_AUTHENTICATION_FAIL	0x05
+#define S3FWRN5_FW_RET_FLASH_OPERATION_FAIL	0x06
+#define S3FWRN5_FW_RET_ADDRESS_OUT_OF_RANGE	0x07
+#define S3FWRN5_FW_RET_PARAMETER_INVALID	0x08
+
+/* ---- FW Packet structures ---- */
+#define S3FWRN5_FW_HDR_SIZE 4
+
+struct s3fwrn5_fw_header {
+	__u8 type;
+	__u8 code;
+	__u16 len;
+};
+
+#define S3FWRN5_FW_CMD_RESET			0x00
+
+#define S3FWRN5_FW_CMD_GET_BOOTINFO		0x01
+
+struct s3fwrn5_fw_cmd_get_bootinfo_rsp {
+	__u8 hw_version[4];
+	__u16 sector_size;
+	__u16 page_size;
+	__u16 frame_max_size;
+	__u16 hw_buffer_size;
+};
+
+#define S3FWRN5_FW_CMD_ENTER_UPDATE_MODE	0x02
+
+struct s3fwrn5_fw_cmd_enter_updatemode {
+	__u16 hashcode_size;
+	__u16 signature_size;
+};
+
+#define S3FWRN5_FW_CMD_UPDATE_SECTOR		0x04
+
+struct s3fwrn5_fw_cmd_update_sector {
+	__u32 base_address;
+};
+
+#define S3FWRN5_FW_CMD_COMPLETE_UPDATE_MODE	0x05
+
+struct s3fwrn5_fw_image {
+	const struct firmware *fw;
+
+	char date[13];
+	u32 version;
+	const void *sig;
+	u32 sig_size;
+	const void *image;
+	u32 image_sectors;
+	const void *custom_sig;
+	u32 custom_sig_size;
+};
+
+struct s3fwrn5_fw_info {
+	struct nci_dev *ndev;
+	struct s3fwrn5_fw_image fw;
+	char fw_name[NFC_FIRMWARE_NAME_MAXSIZE + 1];
+
+	const void *sig;
+	u32 sig_size;
+	u32 sector_size;
+	u32 base_addr;
+
+	struct completion completion;
+	struct sk_buff *rsp;
+	char parity;
+};
+
+void s3fwrn5_fw_init(struct s3fwrn5_fw_info *fw_info, const char *fw_name);
+int s3fwrn5_fw_setup(struct s3fwrn5_fw_info *fw_info);
+bool s3fwrn5_fw_check_version(struct s3fwrn5_fw_info *fw_info, u32 version);
+int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info);
+void s3fwrn5_fw_cleanup(struct s3fwrn5_fw_info *fw_info);
+
+int s3fwrn5_fw_recv_frame(struct nci_dev *ndev, struct sk_buff *skb);
+
+#endif /* __LOCAL_S3FWRN5_FIRMWARE_H_ */
diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
new file mode 100644
index 0000000..b4dd7dd
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -0,0 +1,306 @@
+/*
+ * I2C Link Layer for Samsung S3FWRN5 NCI based Driver
+ *
+ * Copyright (C) 2015 Samsung Electrnoics
+ * Robert Baldyga <r.baldyga@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/of_gpio.h>
+#include <linux/of_irq.h>
+#include <linux/module.h>
+
+#include <net/nfc/nfc.h>
+
+#include "s3fwrn5.h"
+
+#define S3FWRN5_I2C_DRIVER_NAME "s3fwrn5_i2c"
+
+#define S3FWRN5_I2C_MAX_PAYLOAD 32
+#define S3FWRN5_EN_WAIT_TIME 150
+
+struct s3fwrn5_i2c_phy {
+	struct i2c_client *i2c_dev;
+	struct nci_dev *ndev;
+
+	unsigned int gpio_en;
+	unsigned int gpio_fw_wake;
+
+	struct mutex mutex;
+
+	enum s3fwrn5_mode mode;
+	unsigned int irq_skip:1;
+};
+
+static void s3fwrn5_i2c_set_wake(void *phy_id, bool wake)
+{
+	struct s3fwrn5_i2c_phy *phy = phy_id;
+
+	mutex_lock(&phy->mutex);
+	gpio_set_value(phy->gpio_fw_wake, wake);
+	msleep(S3FWRN5_EN_WAIT_TIME/2);
+	mutex_unlock(&phy->mutex);
+}
+
+static void s3fwrn5_i2c_set_mode(void *phy_id, enum s3fwrn5_mode mode)
+{
+	struct s3fwrn5_i2c_phy *phy = phy_id;
+
+	mutex_lock(&phy->mutex);
+
+	if (phy->mode == mode)
+		goto out;
+
+	phy->mode = mode;
+
+	gpio_set_value(phy->gpio_en, 1);
+	gpio_set_value(phy->gpio_fw_wake, 0);
+	if (mode == S3FWRN5_MODE_FW)
+		gpio_set_value(phy->gpio_fw_wake, 1);
+
+	if (mode != S3FWRN5_MODE_COLD) {
+		msleep(S3FWRN5_EN_WAIT_TIME);
+		gpio_set_value(phy->gpio_en, 0);
+		msleep(S3FWRN5_EN_WAIT_TIME/2);
+	}
+
+	phy->irq_skip = true;
+
+out:
+	mutex_unlock(&phy->mutex);
+}
+
+static enum s3fwrn5_mode s3fwrn5_i2c_get_mode(void *phy_id)
+{
+	struct s3fwrn5_i2c_phy *phy = phy_id;
+	enum s3fwrn5_mode mode;
+
+	mutex_lock(&phy->mutex);
+
+	mode = phy->mode;
+
+	mutex_unlock(&phy->mutex);
+
+	return mode;
+}
+
+static int s3fwrn5_i2c_write(void *phy_id, struct sk_buff *skb)
+{
+	struct s3fwrn5_i2c_phy *phy = phy_id;
+	int ret;
+
+	mutex_lock(&phy->mutex);
+
+	phy->irq_skip = false;
+
+	ret = i2c_master_send(phy->i2c_dev, skb->data, skb->len);
+	if (ret == -EREMOTEIO) {
+		/* Retry, chip was in standby */
+		usleep_range(110000, 120000);
+		ret  = i2c_master_send(phy->i2c_dev, skb->data, skb->len);
+	}
+
+	mutex_unlock(&phy->mutex);
+
+	if (ret < 0)
+		return ret;
+
+	if (ret != skb->len)
+		return -EREMOTEIO;
+
+	return 0;
+}
+
+static struct s3fwrn5_phy_ops i2c_phy_ops = {
+	.set_wake = s3fwrn5_i2c_set_wake,
+	.set_mode = s3fwrn5_i2c_set_mode,
+	.get_mode = s3fwrn5_i2c_get_mode,
+	.write = s3fwrn5_i2c_write,
+};
+
+static int s3fwrn5_i2c_read(struct s3fwrn5_i2c_phy *phy)
+{
+	struct sk_buff *skb;
+	size_t hdr_size;
+	size_t data_len;
+	char hdr[4];
+	int ret;
+
+	hdr_size = (phy->mode == S3FWRN5_MODE_NCI) ?
+		NCI_CTRL_HDR_SIZE : S3FWRN5_FW_HDR_SIZE;
+	ret = i2c_master_recv(phy->i2c_dev, hdr, hdr_size);
+	if (ret < 0)
+		return ret;
+
+	if (ret < hdr_size)
+		return -EBADMSG;
+
+	data_len = (phy->mode == S3FWRN5_MODE_NCI) ?
+		((struct nci_ctrl_hdr *)hdr)->plen :
+		((struct s3fwrn5_fw_header *)hdr)->len;
+
+	skb = alloc_skb(hdr_size + data_len, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	memcpy(skb_put(skb, hdr_size), hdr, hdr_size);
+
+	if (data_len == 0)
+		goto out;
+
+	ret = i2c_master_recv(phy->i2c_dev, skb_put(skb, data_len), data_len);
+	if (ret != data_len) {
+		kfree_skb(skb);
+		return -EBADMSG;
+	}
+
+out:
+	return s3fwrn5_recv_frame(phy->ndev, skb, phy->mode);
+}
+
+static irqreturn_t s3fwrn5_i2c_irq_thread_fn(int irq, void *phy_id)
+{
+	struct s3fwrn5_i2c_phy *phy = phy_id;
+	int ret = 0;
+
+	if (!phy || !phy->ndev) {
+		WARN_ON_ONCE(1);
+		return IRQ_NONE;
+	}
+
+	mutex_lock(&phy->mutex);
+
+	if (phy->irq_skip)
+		goto out;
+
+	switch (phy->mode) {
+	case S3FWRN5_MODE_NCI:
+	case S3FWRN5_MODE_FW:
+		ret = s3fwrn5_i2c_read(phy);
+		break;
+	case S3FWRN5_MODE_COLD:
+		ret = -EREMOTEIO;
+		break;
+	}
+
+out:
+	mutex_unlock(&phy->mutex);
+
+	return IRQ_HANDLED;
+}
+
+static int s3fwrn5_i2c_parse_dt(struct i2c_client *client)
+{
+	struct s3fwrn5_i2c_phy *phy = i2c_get_clientdata(client);
+	struct device_node *np = client->dev.of_node;
+
+	if (!np)
+		return -ENODEV;
+
+	phy->gpio_en = of_get_named_gpio(np, "s3fwrn5,en-gpios", 0);
+	if (!gpio_is_valid(phy->gpio_en))
+		return -ENODEV;
+
+	phy->gpio_fw_wake = of_get_named_gpio(np, "s3fwrn5,fw-gpios", 0);
+	if (!gpio_is_valid(phy->gpio_fw_wake))
+		return -ENODEV;
+
+	return 0;
+}
+
+static int s3fwrn5_i2c_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
+{
+	struct s3fwrn5_i2c_phy *phy;
+	int ret;
+
+	phy = devm_kzalloc(&client->dev, sizeof(*phy), GFP_KERNEL);
+	if (!phy)
+		return -ENOMEM;
+
+	mutex_init(&phy->mutex);
+	phy->mode = S3FWRN5_MODE_COLD;
+	phy->irq_skip = true;
+
+	phy->i2c_dev = client;
+	i2c_set_clientdata(client, phy);
+
+	ret = s3fwrn5_i2c_parse_dt(client);
+	if (ret < 0)
+		return ret;
+
+	ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->gpio_en,
+		GPIOF_OUT_INIT_HIGH, "s3fwrn5_en");
+	if (ret < 0)
+		return ret;
+
+	ret = devm_gpio_request_one(&phy->i2c_dev->dev, phy->gpio_fw_wake,
+		GPIOF_OUT_INIT_LOW, "s3fwrn5_fw_wake");
+	if (ret < 0)
+		return ret;
+
+	ret = s3fwrn5_probe(&phy->ndev, phy, &phy->i2c_dev->dev, &i2c_phy_ops,
+		S3FWRN5_I2C_MAX_PAYLOAD);
+	if (ret < 0)
+		return ret;
+
+	ret = request_threaded_irq(phy->i2c_dev->irq, NULL,
+		s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+		S3FWRN5_I2C_DRIVER_NAME, phy);
+	if (ret)
+		s3fwrn5_remove(phy->ndev);
+
+	return ret;
+}
+
+static int s3fwrn5_i2c_remove(struct i2c_client *client)
+{
+	struct s3fwrn5_i2c_phy *phy = i2c_get_clientdata(client);
+
+	s3fwrn5_remove(phy->ndev);
+
+	return 0;
+}
+
+static struct i2c_device_id s3fwrn5_i2c_id_table[] = {
+	{S3FWRN5_I2C_DRIVER_NAME, 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, s3fwrn5_i2c_id_table);
+
+static const struct of_device_id of_s3fwrn5_i2c_match[] = {
+	{ .compatible = "samsung,s3fwrn5-i2c", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, of_s3fwrn5_i2c_match);
+
+static struct i2c_driver s3fwrn5_i2c_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = S3FWRN5_I2C_DRIVER_NAME,
+		.of_match_table = of_match_ptr(of_s3fwrn5_i2c_match),
+	},
+	.probe = s3fwrn5_i2c_probe,
+	.remove = s3fwrn5_i2c_remove,
+	.id_table = s3fwrn5_i2c_id_table,
+};
+
+module_i2c_driver(s3fwrn5_i2c_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("I2C driver for Samsung S3FWRN5");
+MODULE_AUTHOR("Robert Baldyga <r.baldyga@samsung.com>");
diff --git a/drivers/nfc/s3fwrn5/nci.c b/drivers/nfc/s3fwrn5/nci.c
new file mode 100644
index 0000000..ace0071
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/nci.c
@@ -0,0 +1,165 @@
+/*
+ * NCI based driver for Samsung S3FWRN5 NFC chip
+ *
+ * Copyright (C) 2015 Samsung Electrnoics
+ * Robert Baldyga <r.baldyga@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/completion.h>
+#include <linux/firmware.h>
+
+#include "s3fwrn5.h"
+#include "nci.h"
+
+static int s3fwrn5_nci_prop_rsp(struct nci_dev *ndev, struct sk_buff *skb)
+{
+	__u8 status = skb->data[0];
+
+	nci_req_complete(ndev, status);
+	return 0;
+}
+
+static struct nci_prop_ops s3fwrn5_nci_prop_ops[] = {
+	{
+		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
+				NCI_PROP_AGAIN),
+		.rsp = s3fwrn5_nci_prop_rsp,
+	},
+	{
+		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
+				NCI_PROP_GET_RFREG),
+		.rsp = s3fwrn5_nci_prop_rsp,
+	},
+	{
+		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
+				NCI_PROP_SET_RFREG),
+		.rsp = s3fwrn5_nci_prop_rsp,
+	},
+	{
+		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
+				NCI_PROP_GET_RFREG_VER),
+		.rsp = s3fwrn5_nci_prop_rsp,
+	},
+	{
+		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
+				NCI_PROP_SET_RFREG_VER),
+		.rsp = s3fwrn5_nci_prop_rsp,
+	},
+	{
+		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
+				NCI_PROP_START_RFREG),
+		.rsp = s3fwrn5_nci_prop_rsp,
+	},
+	{
+		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
+				NCI_PROP_STOP_RFREG),
+		.rsp = s3fwrn5_nci_prop_rsp,
+	},
+	{
+		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
+				NCI_PROP_FW_CFG),
+		.rsp = s3fwrn5_nci_prop_rsp,
+	},
+	{
+		.opcode = nci_opcode_pack(NCI_GID_PROPRIETARY,
+				NCI_PROP_WR_RESET),
+		.rsp = s3fwrn5_nci_prop_rsp,
+	},
+};
+
+void s3fwrn5_nci_get_prop_ops(struct nci_prop_ops **ops, size_t *n)
+{
+	*ops = s3fwrn5_nci_prop_ops;
+	*n = ARRAY_SIZE(s3fwrn5_nci_prop_ops);
+}
+
+#define S3FWRN5_RFREG_SECTION_SIZE 252
+
+int s3fwrn5_nci_rf_configure(struct s3fwrn5_info *info, const char *fw_name)
+{
+	const struct firmware *fw;
+	struct nci_prop_fw_cfg_cmd fw_cfg;
+	struct nci_prop_set_rfreg_cmd set_rfreg;
+	struct nci_prop_stop_rfreg_cmd stop_rfreg;
+	u32 checksum;
+	int i, len;
+	int ret;
+
+	ret = request_firmware(&fw, fw_name, &info->ndev->nfc_dev->dev);
+	if (ret < 0)
+		return ret;
+
+	/* Compute rfreg checksum */
+
+	checksum = 0;
+	for (i = 0; i < fw->size; i += 4)
+		checksum += *((u32 *)(fw->data+i));
+
+	/* Set default clock configuration for external crystal */
+
+	fw_cfg.clk_type = 0x01;
+	fw_cfg.clk_speed = 0xff;
+	fw_cfg.clk_req = 0xff;
+	ret = nci_prop_cmd(info->ndev, NCI_PROP_FW_CFG,
+		sizeof(fw_cfg), (__u8 *)&fw_cfg);
+	if (ret < 0)
+		goto out;
+
+	/* Start rfreg configuration */
+
+	dev_info(&info->ndev->nfc_dev->dev,
+		"rfreg configuration update: %s\n", fw_name);
+
+	ret = nci_prop_cmd(info->ndev, NCI_PROP_START_RFREG, 0, NULL);
+	if (ret < 0) {
+		dev_err(&info->ndev->nfc_dev->dev,
+			"Unable to start rfreg update\n");
+		goto out;
+	}
+
+	/* Update rfreg */
+
+	set_rfreg.index = 0;
+	for (i = 0; i < fw->size; i += S3FWRN5_RFREG_SECTION_SIZE) {
+		len = (fw->size - i < S3FWRN5_RFREG_SECTION_SIZE) ?
+			(fw->size - i) : S3FWRN5_RFREG_SECTION_SIZE;
+		memcpy(set_rfreg.data, fw->data+i, len);
+		ret = nci_prop_cmd(info->ndev, NCI_PROP_SET_RFREG,
+			len+1, (__u8 *)&set_rfreg);
+		if (ret < 0) {
+			dev_err(&info->ndev->nfc_dev->dev,
+				"rfreg update error (code=%d)\n", ret);
+			goto out;
+		}
+		set_rfreg.index++;
+	}
+
+	/* Finish rfreg configuration */
+
+	stop_rfreg.checksum = checksum & 0xffff;
+	ret = nci_prop_cmd(info->ndev, NCI_PROP_STOP_RFREG,
+		sizeof(stop_rfreg), (__u8 *)&stop_rfreg);
+	if (ret < 0) {
+		dev_err(&info->ndev->nfc_dev->dev,
+			"Unable to stop rfreg update\n");
+		goto out;
+	}
+
+	dev_info(&info->ndev->nfc_dev->dev,
+		"rfreg configuration update: success\n");
+out:
+	release_firmware(fw);
+	return ret;
+}
diff --git a/drivers/nfc/s3fwrn5/nci.h b/drivers/nfc/s3fwrn5/nci.h
new file mode 100644
index 0000000..0e68d43
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/nci.h
@@ -0,0 +1,89 @@
+/*
+ * NCI based driver for Samsung S3FWRN5 NFC chip
+ *
+ * Copyright (C) 2015 Samsung Electrnoics
+ * Robert Baldyga <r.baldyga@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __LOCAL_S3FWRN5_NCI_H_
+#define __LOCAL_S3FWRN5_NCI_H_
+
+#include "s3fwrn5.h"
+
+#define NCI_PROP_AGAIN		0x01
+
+#define NCI_PROP_GET_RFREG	0x21
+#define NCI_PROP_SET_RFREG	0x22
+
+struct nci_prop_set_rfreg_cmd {
+	__u8 index;
+	__u8 data[252];
+};
+
+struct nci_prop_set_rfreg_rsp {
+	__u8 status;
+};
+
+#define NCI_PROP_GET_RFREG_VER	0x24
+
+struct nci_prop_get_rfreg_ver_rsp {
+	__u8 status;
+	__u8 data[8];
+};
+
+#define NCI_PROP_SET_RFREG_VER	0x25
+
+struct nci_prop_set_rfreg_ver_cmd {
+	__u8 data[8];
+};
+
+struct nci_prop_set_rfreg_ver_rsp {
+	__u8 status;
+};
+
+#define NCI_PROP_START_RFREG	0x26
+
+struct nci_prop_start_rfreg_rsp {
+	__u8 status;
+};
+
+#define NCI_PROP_STOP_RFREG	0x27
+
+struct nci_prop_stop_rfreg_cmd {
+	__u16 checksum;
+};
+
+struct nci_prop_stop_rfreg_rsp {
+	__u8 status;
+};
+
+#define NCI_PROP_FW_CFG		0x28
+
+struct nci_prop_fw_cfg_cmd {
+	__u8 clk_type;
+	__u8 clk_speed;
+	__u8 clk_req;
+};
+
+struct nci_prop_fw_cfg_rsp {
+	__u8 status;
+};
+
+#define NCI_PROP_WR_RESET	0x2f
+
+void s3fwrn5_nci_get_prop_ops(struct nci_prop_ops **ops, size_t *n);
+int s3fwrn5_nci_rf_configure(struct s3fwrn5_info *info, const char *fw_name);
+
+#endif /* __LOCAL_S3FWRN5_NCI_H_ */
diff --git a/drivers/nfc/s3fwrn5/s3fwrn5.h b/drivers/nfc/s3fwrn5/s3fwrn5.h
new file mode 100644
index 0000000..89210d4
--- /dev/null
+++ b/drivers/nfc/s3fwrn5/s3fwrn5.h
@@ -0,0 +1,99 @@
+/*
+ * NCI based driver for Samsung S3FWRN5 NFC chip
+ *
+ * Copyright (C) 2015 Samsung Electrnoics
+ * Robert Baldyga <r.baldyga@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2 or later, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __LOCAL_S3FWRN5_H_
+#define __LOCAL_S3FWRN5_H_
+
+#include <linux/nfc.h>
+
+#include <net/nfc/nci_core.h>
+
+#include "firmware.h"
+
+enum s3fwrn5_mode {
+	S3FWRN5_MODE_COLD,
+	S3FWRN5_MODE_NCI,
+	S3FWRN5_MODE_FW,
+};
+
+struct s3fwrn5_phy_ops {
+	void (*set_wake)(void *id, bool sleep);
+	void (*set_mode)(void *id, enum s3fwrn5_mode);
+	enum s3fwrn5_mode (*get_mode)(void *id);
+	int (*write)(void *id, struct sk_buff *skb);
+};
+
+struct s3fwrn5_info {
+	struct nci_dev *ndev;
+	void *phy_id;
+	struct device *pdev;
+
+	struct s3fwrn5_phy_ops *phy_ops;
+	unsigned int max_payload;
+
+	struct s3fwrn5_fw_info fw_info;
+
+	struct mutex mutex;
+};
+
+static inline int s3fwrn5_set_mode(struct s3fwrn5_info *info,
+	enum s3fwrn5_mode mode)
+{
+	if (!info->phy_ops->set_mode)
+		return -ENOTSUPP;
+
+	info->phy_ops->set_mode(info->phy_id, mode);
+
+	return 0;
+}
+
+static inline enum s3fwrn5_mode s3fwrn5_get_mode(struct s3fwrn5_info *info)
+{
+	if (!info->phy_ops->get_mode)
+		return -ENOTSUPP;
+
+	return info->phy_ops->get_mode(info->phy_id);
+}
+
+static inline int s3fwrn5_set_wake(struct s3fwrn5_info *info, bool wake)
+{
+	if (!info->phy_ops->set_wake)
+		return -ENOTSUPP;
+
+	info->phy_ops->set_wake(info->phy_id, wake);
+
+	return 0;
+}
+
+static inline int s3fwrn5_write(struct s3fwrn5_info *info, struct sk_buff *skb)
+{
+	if (!info->phy_ops->write)
+		return -ENOTSUPP;
+
+	return info->phy_ops->write(info->phy_id, skb);
+}
+
+int s3fwrn5_probe(struct nci_dev **ndev, void *phy_id, struct device *pdev,
+	struct s3fwrn5_phy_ops *phy_ops, unsigned int max_payload);
+void s3fwrn5_remove(struct nci_dev *ndev);
+
+int s3fwrn5_recv_frame(struct nci_dev *ndev, struct sk_buff *skb,
+	enum s3fwrn5_mode mode);
+
+#endif /* __LOCAL_S3FWRN5_H_ */
-- 
1.9.1


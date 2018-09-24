Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727430AbeIXLOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:14:16 -0400
From: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 11/11] qtnfmac_pcie: check for correct CHIP ID at pcie probe
Date: Mon, 24 Sep 2018 05:13:33 +0000
Message-ID: <20180924051246.13371-12-igor.mitsyanko.os@quantenna.com> (sfid-20180924_072419_476668_1DDB07FC)
References: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
In-Reply-To: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure that wifi device is of supported variant by checking it's CHIP ID
before completing a probe sequence.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 24 ++++++++++++++++++=
++++
 .../net/wireless/quantenna/qtnfmac/qtn_hw_ids.h    | 14 +++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 424e367..d7a8d20 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -1090,6 +1090,26 @@ static void qtnf_pearl_reclaim_tasklet_fn(unsigned l=
ong data)
 	qtnf_en_txdone_irq(ps);
 }
=20
+static int qtnf_pearl_check_chip_id(struct qtnf_pcie_pearl_state *ps)
+{
+	unsigned int chipid;
+
+	chipid =3D qtnf_chip_id_get(ps->base.sysctl_bar);
+
+	switch (chipid) {
+	case QTN_CHIP_ID_PEARL:
+	case QTN_CHIP_ID_PEARL_B:
+	case QTN_CHIP_ID_PEARL_C:
+		pr_info("chip ID is 0x%x\n", chipid);
+		break;
+	default:
+		pr_err("incorrect chip ID 0x%x\n", chipid);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int qtnf_pcie_pearl_probe(struct pci_dev *pdev, const struct pci_de=
vice_id *id)
 {
 	struct qtnf_shm_ipc_int ipc_int;
@@ -1129,6 +1149,10 @@ static int qtnf_pcie_pearl_probe(struct pci_dev *pde=
v, const struct pci_device_i
 	qtnf_pcie_init_shm_ipc(&ps->base, &ps->bda->bda_shm_reg1,
 			       &ps->bda->bda_shm_reg2, &ipc_int);
=20
+	ret =3D qtnf_pearl_check_chip_id(ps);
+	if (ret)
+		goto error;
+
 	ret =3D qtnf_pcie_pearl_init_xfer(ps);
 	if (ret) {
 		pr_err("PCIE xfer init failed\n");
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h b/drivers/=
net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
index c4ad40d..1fe798a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
@@ -25,8 +25,22 @@
=20
 #define	PCIE_DEVICE_ID_QTN_PEARL	(0x0008)
=20
+#define QTN_REG_SYS_CTRL_CSR		0x14
+#define QTN_CHIP_ID_MASK		0xF0
+#define QTN_CHIP_ID_TOPAZ		0x40
+#define QTN_CHIP_ID_PEARL		0x50
+#define QTN_CHIP_ID_PEARL_B		0x60
+#define QTN_CHIP_ID_PEARL_C		0x70
+
 /* FW names */
=20
 #define QTN_PCI_PEARL_FW_NAME		"qtn/fmac_qsr10g.img"
=20
+static inline unsigned int qtnf_chip_id_get(const void __iomem *regs_base)
+{
+	u32 board_rev =3D readl(regs_base + QTN_REG_SYS_CTRL_CSR);
+
+	return board_rev & QTN_CHIP_ID_MASK;
+}
+
 #endif	/* _QTN_HW_IDS_H_ */
--=20
2.9.5

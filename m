Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr700049.outbound.protection.outlook.com ([40.107.70.49]:61600
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725763AbeIXLN6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:13:58 -0400
From: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 01/11] qtnfmac_pcie: do not store FW name in driver state
 structure
Date: Mon, 24 Sep 2018 05:13:24 +0000
Message-ID: <20180924051246.13371-2-igor.mitsyanko.os@quantenna.com> (sfid-20180924_071406_278402_87CE99C4)
References: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
In-Reply-To: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware name is only needed at probe stage, no point in keeping it in
driver state structure.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h        | 1 -
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wir=
eless/quantenna/qtnfmac/bus.h
index 323e47c..2beca5b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -57,7 +57,6 @@ struct qtnf_bus {
 	struct qtnf_wmac *mac[QTNF_MAX_MAC];
 	struct qtnf_qlink_transport trans;
 	struct qtnf_hw_info hw_info;
-	char fwname[32];
 	struct napi_struct mux_napi;
 	struct net_device mux_dev;
 	struct completion firmware_init_complete;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/=
net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 3120d49..97cc7f2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -1177,13 +1177,14 @@ static void qtnf_fw_work_handler(struct work_struct=
 *work)
 	const struct firmware *fw;
 	int ret;
 	u32 state =3D QTN_RC_FW_LOADRDY | QTN_RC_FW_QLINK;
+	const char *fwname =3D QTN_PCI_PEARL_FW_NAME;
=20
 	if (flashboot) {
 		state |=3D QTN_RC_FW_FLASHBOOT;
 	} else {
-		ret =3D request_firmware(&fw, bus->fwname, &pdev->dev);
+		ret =3D request_firmware(&fw, fwname, &pdev->dev);
 		if (ret < 0) {
-			pr_err("failed to get firmware %s\n", bus->fwname);
+			pr_err("failed to get firmware %s\n", fwname);
 			goto fw_load_fail;
 		}
 	}
@@ -1205,7 +1206,7 @@ static void qtnf_fw_work_handler(struct work_struct *=
work)
 	if (flashboot) {
 		pr_info("booting firmware from flash\n");
 	} else {
-		pr_info("starting firmware upload: %s\n", bus->fwname);
+		pr_info("starting firmware upload: %s\n", fwname);
=20
 		ret =3D qtnf_ep_fw_load(priv, fw->data, fw->size);
 		release_firmware(fw);
@@ -1290,7 +1291,6 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
 	bus->fw_state =3D QTNF_FW_STATE_RESET;
 	pcie_priv->pdev =3D pdev;
=20
-	strcpy(bus->fwname, QTN_PCI_PEARL_FW_NAME);
 	init_completion(&bus->firmware_init_complete);
 	mutex_init(&bus->bus_lock);
 	spin_lock_init(&pcie_priv->tx0_lock);
--=20
2.9.5

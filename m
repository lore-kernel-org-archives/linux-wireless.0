Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0069.outbound.protection.outlook.com ([104.47.36.69]:44244
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753202AbeBEPFq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Feb 2018 10:05:46 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 4/6] qtnfmac: fix rmmod for missing firmware
Date: Mon,  5 Feb 2018 18:05:14 +0300
Message-Id: <20180205150516.16030-5-sergey.matyukevich.os@quantenna.com> (sfid-20180205_160632_202758_0C38C9AB)
In-Reply-To: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
References: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check that firmware exists prior to starting firmware download.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index c0d1c5d94ef0..86368e345276 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -1104,6 +1104,20 @@ static void qtnf_firmware_load(const struct firmware *fw, void *context)
 	complete(&bus->request_firmware_complete);
 }
 
+static int qtnf_fw_exists(struct qtnf_bus *bus)
+{
+	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	struct pci_dev *pdev = priv->pdev;
+	const struct firmware *fw;
+	int ret;
+
+	ret = request_firmware(&fw, bus->fwname, &pdev->dev);
+	if (!ret)
+		release_firmware(fw);
+
+	return !ret;
+}
+
 static int qtnf_bringup_fw(struct qtnf_bus *bus)
 {
 	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
@@ -1358,6 +1372,12 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	netif_napi_add(&bus->mux_dev, &bus->mux_napi,
 		       qtnf_rx_poll, 10);
 
+	if (!flashboot && !qtnf_fw_exists(bus)) {
+		pr_err("failed to get firmware %s\n", bus->fwname);
+		ret = -ENOENT;
+		goto err_fw;
+	}
+
 	ret = qtnf_bringup_fw(bus);
 	if (ret < 0)
 		goto err_fw;
-- 
2.11.0

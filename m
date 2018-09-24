Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727441AbeIXLOP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:14:15 -0400
From: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 10/11] qtnfmac: wait for FW load work to finish at PCIe remove
Date: Mon, 24 Sep 2018 05:13:32 +0000
Message-ID: <20180924051246.13371-11-igor.mitsyanko.os@quantenna.com> (sfid-20180924_071410_140875_3ED2F1CB)
References: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
In-Reply-To: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Waiting for "completion" to be set in FW load thread can not be used
in case PCIe remove is called before FW load work was scheduled.
Just wait for work completion instead to avoid problems.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h       | 1 -
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wir=
eless/quantenna/qtnfmac/bus.h
index 7c4f856..528ca7f 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -62,7 +62,6 @@ struct qtnf_bus {
 	struct qtnf_hw_info hw_info;
 	struct napi_struct mux_napi;
 	struct net_device mux_dev;
-	struct completion firmware_init_complete;
 	struct workqueue_struct *workqueue;
 	struct work_struct fw_work;
 	struct work_struct event_work;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/n=
et/wireless/quantenna/qtnfmac/pcie/pcie.c
index ab42d11..fd2f1a1 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -143,7 +143,6 @@ void qtnf_pcie_fw_boot_done(struct qtnf_bus *bus, bool =
boot_success,
 		bus->fw_state =3D QTNF_FW_STATE_DETACHED;
 	}
=20
-	complete(&bus->firmware_init_complete);
 	put_device(&pdev->dev);
 }
=20
@@ -317,7 +316,6 @@ int qtnf_pcie_probe(struct pci_dev *pdev, size_t priv_s=
ize,
 	pcie_priv->pdev =3D pdev;
 	pcie_priv->tx_stopped =3D 0;
=20
-	init_completion(&bus->firmware_init_complete);
 	mutex_init(&bus->bus_lock);
 	spin_lock_init(&pcie_priv->tx_lock);
 	spin_lock_init(&pcie_priv->tx_reclaim_lock);
@@ -389,7 +387,7 @@ static void qtnf_pcie_free_shm_ipc(struct qtnf_pcie_bus=
_priv *priv)
=20
 void qtnf_pcie_remove(struct qtnf_bus *bus, struct qtnf_pcie_bus_priv *pri=
v)
 {
-	wait_for_completion(&bus->firmware_init_complete);
+	cancel_work_sync(&bus->fw_work);
=20
 	if (bus->fw_state =3D=3D QTNF_FW_STATE_ACTIVE ||
 	    bus->fw_state =3D=3D QTNF_FW_STATE_EP_DEAD)
--=20
2.9.5

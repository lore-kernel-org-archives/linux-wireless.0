Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:28567
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726366AbeIXLOJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 07:14:09 -0400
From: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Igor Mitsyanko SO <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: [PATCH 05/11] qtnfmac_pcie: pearl: rename spinlock tx0_lock to
 tx_lock
Date: Mon, 24 Sep 2018 05:13:27 +0000
Message-ID: <20180924051246.13371-6-igor.mitsyanko.os@quantenna.com> (sfid-20180924_071408_024879_F8488EDD)
References: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
In-Reply-To: <20180924051246.13371-1-igor.mitsyanko.os@quantenna.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tx_lock name will later be reused when common pcie code is extracted to
separate files.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 4e9eb46..791a1e3 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -110,7 +110,7 @@ struct qtnf_pcie_pearl_state {
 	/* lock for tx reclaim operations */
 	spinlock_t tx_reclaim_lock;
 	/* lock for tx0 operations */
-	spinlock_t tx0_lock;
+	spinlock_t tx_lock;
 	u8 msi_enabled;
 	u8 tx_stopped;
 	int mps;
@@ -794,7 +794,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, stru=
ct sk_buff *skb)
 	u32 info;
 	int ret =3D 0;
=20
-	spin_lock_irqsave(&priv->tx0_lock, flags);
+	spin_lock_irqsave(&priv->tx_lock, flags);
=20
 	if (!qtnf_tx_queue_ready(priv)) {
 		if (skb->dev) {
@@ -802,7 +802,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, stru=
ct sk_buff *skb)
 			priv->tx_stopped =3D 1;
 		}
=20
-		spin_unlock_irqrestore(&priv->tx0_lock, flags);
+		spin_unlock_irqrestore(&priv->tx_lock, flags);
 		return NETDEV_TX_BUSY;
 	}
=20
@@ -852,7 +852,7 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, stru=
ct sk_buff *skb)
 	}
=20
 	priv->tx_done_count++;
-	spin_unlock_irqrestore(&priv->tx0_lock, flags);
+	spin_unlock_irqrestore(&priv->tx_lock, flags);
=20
 	qtnf_pcie_data_tx_reclaim(priv);
=20
@@ -1404,7 +1404,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
=20
 	init_completion(&bus->firmware_init_complete);
 	mutex_init(&bus->bus_lock);
-	spin_lock_init(&pcie_priv->tx0_lock);
+	spin_lock_init(&pcie_priv->tx_lock);
 	spin_lock_init(&pcie_priv->irq_lock);
 	spin_lock_init(&pcie_priv->tx_reclaim_lock);
=20
--=20
2.9.5

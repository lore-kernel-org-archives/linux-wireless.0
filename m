Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-dm3nam03on0075.outbound.protection.outlook.com ([104.47.41.75]:55935
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753102AbdH2MRJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 08:17:09 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 2/5] qtnfmac: module param sanity check
Date: Tue, 29 Aug 2017 15:16:20 +0300
Message-Id: <20170829121623.24761-3-sergey.matyukevich.os@quantenna.com> (sfid-20170829_141726_784421_C4694EED)
In-Reply-To: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
References: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linux built-in circ_buf implementation assumes that that the
circular buffer length is a power of 2. Make sure that
rx and tx descriptor queue lengths are power-of-2.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index cd2f2b667643..fd552d64f943 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -26,6 +26,7 @@
 #include <linux/crc32.h>
 #include <linux/spinlock.h>
 #include <linux/circ_buf.h>
+#include <linux/log2.h>
 
 #include "qtn_hw_ids.h"
 #include "pcie_bus_priv.h"
@@ -39,11 +40,11 @@ MODULE_PARM_DESC(use_msi, "set 0 to use legacy interrupt");
 
 static unsigned int tx_bd_size_param = 32;
 module_param(tx_bd_size_param, uint, 0644);
-MODULE_PARM_DESC(tx_bd_size_param, "Tx descriptors queue size");
+MODULE_PARM_DESC(tx_bd_size_param, "Tx descriptors queue size, power of two");
 
 static unsigned int rx_bd_size_param = 256;
 module_param(rx_bd_size_param, uint, 0644);
-MODULE_PARM_DESC(rx_bd_size_param, "Rx descriptors queue size");
+MODULE_PARM_DESC(rx_bd_size_param, "Rx descriptors queue size, power of two");
 
 static u8 flashboot = 1;
 module_param(flashboot, byte, 0644);
@@ -509,6 +510,18 @@ static int qtnf_pcie_init_xfer(struct qtnf_pcie_bus_priv *priv)
 	priv->rx_bd_w_index = 0;
 	priv->rx_bd_r_index = 0;
 
+	if (!priv->tx_bd_num || !is_power_of_2(priv->tx_bd_num)) {
+		pr_err("tx_bd_size_param %u is not power of two\n",
+		       priv->tx_bd_num);
+		return -EINVAL;
+	}
+
+	if (!priv->rx_bd_num || !is_power_of_2(priv->rx_bd_num)) {
+		pr_err("rx_bd_size_param %u is not power of two\n",
+		       priv->rx_bd_num);
+		return -EINVAL;
+	}
+
 	ret = alloc_skb_array(priv);
 	if (ret) {
 		pr_err("failed to allocate skb array\n");
-- 
2.11.0

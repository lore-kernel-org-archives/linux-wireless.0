Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0088.outbound.protection.outlook.com ([104.47.42.88]:23410
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933410AbeE2MAe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 08:00:34 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>
Subject: [PATCH 5/9] qtnfmac: improve control path timeout handling
Date: Tue, 29 May 2018 15:00:01 +0300
Message-Id: <20180529120005.21498-6-sergey.matyukevich.os@quantenna.com> (sfid-20180529_140052_008687_E8CB1134)
In-Reply-To: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
References: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dmitry Lebed <dlebed@quantenna.com>

Control path will not be operational after firmware failure. Change bus
state to QTNF_FW_STATE_EP_DEAD after the control path timeout.
Don't wait for timeout if control path is already dead.

Signed-off-by: Dmitry Lebed <dlebed@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h        |  3 ++-
 drivers/net/wireless/quantenna/qtnfmac/core.c       |  2 +-
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 15 ++++++++++++---
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wireless/quantenna/qtnfmac/bus.h
index 0a1604683bab..323e47cea1e2 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -27,7 +27,8 @@ enum qtnf_fw_state {
 	QTNF_FW_STATE_FW_DNLD_DONE,
 	QTNF_FW_STATE_BOOT_DONE,
 	QTNF_FW_STATE_ACTIVE,
-	QTNF_FW_STATE_DEAD,
+	QTNF_FW_STATE_DETACHED,
+	QTNF_FW_STATE_EP_DEAD,
 };
 
 struct qtnf_bus;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index 3ccbc427cf56..a6a450984f9a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -628,7 +628,7 @@ void qtnf_core_detach(struct qtnf_bus *bus)
 	if (bus->fw_state == QTNF_FW_STATE_ACTIVE)
 		qtnf_cmd_send_deinit_fw(bus);
 
-	bus->fw_state = QTNF_FW_STATE_DEAD;
+	bus->fw_state = QTNF_FW_STATE_DETACHED;
 
 	if (bus->workqueue) {
 		flush_workqueue(bus->workqueue);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index 6c1e139bb8f7..3120d49df565 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -751,8 +751,16 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 static int qtnf_pcie_control_tx(struct qtnf_bus *bus, struct sk_buff *skb)
 {
 	struct qtnf_pcie_bus_priv *priv = (void *)get_bus_priv(bus);
+	int ret;
+
+	ret = qtnf_shm_ipc_send(&priv->shm_ipc_ep_in, skb->data, skb->len);
 
-	return qtnf_shm_ipc_send(&priv->shm_ipc_ep_in, skb->data, skb->len);
+	if (ret == -ETIMEDOUT) {
+		pr_err("EP firmware is dead\n");
+		bus->fw_state = QTNF_FW_STATE_EP_DEAD;
+	}
+
+	return ret;
 }
 
 static irqreturn_t qtnf_interrupt(int irq, void *data)
@@ -1238,7 +1246,7 @@ static void qtnf_fw_work_handler(struct work_struct *work)
 	goto fw_load_exit;
 
 fw_load_fail:
-	bus->fw_state = QTNF_FW_STATE_DEAD;
+	bus->fw_state = QTNF_FW_STATE_DETACHED;
 
 fw_load_exit:
 	complete(&bus->firmware_init_complete);
@@ -1408,7 +1416,8 @@ static void qtnf_pcie_remove(struct pci_dev *pdev)
 
 	wait_for_completion(&bus->firmware_init_complete);
 
-	if (bus->fw_state == QTNF_FW_STATE_ACTIVE)
+	if (bus->fw_state == QTNF_FW_STATE_ACTIVE ||
+	    bus->fw_state == QTNF_FW_STATE_EP_DEAD)
 		qtnf_core_detach(bus);
 
 	priv = get_bus_priv(bus);
-- 
2.11.0

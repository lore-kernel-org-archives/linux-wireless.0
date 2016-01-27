Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51822 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbcA0J6g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 04:58:36 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 09/12] ath10k: add chip and bus halt logic in ahb
Date: Wed, 27 Jan 2016 15:24:30 +0530
Message-ID: <1453888473-2879-10-git-send-email-rmani@qti.qualcomm.com> (sfid-20160127_105901_114760_DEDB2223)
In-Reply-To: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
References: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add function to perform chip halt sequence and function to halt axi
bus in ahb module. Mainly used in the scenario like driver unload.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 113 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/ahb.h |  15 +++++
 2 files changed, 128 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index d1f1972..2305078 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -345,6 +345,119 @@ static int ath10k_ahb_release_reset(struct ath10k *ar)
 	return 0;
 }
 
+static void ath10k_ahb_halt_axi_bus(struct ath10k *ar, u32 haltreq_reg,
+				    u32 haltack_reg)
+{
+	unsigned long timeout;
+	u32 val;
+
+	/* Issue halt axi bus request */
+	val = ath10k_ahb_tcsr_read32(ar, haltreq_reg);
+	val |= AHB_AXI_BUS_HALT_REQ;
+	ath10k_ahb_tcsr_write32(ar, haltreq_reg, val);
+
+	/* Wait for axi bus halted ack */
+	timeout = jiffies + msecs_to_jiffies(ATH10K_AHB_AXI_BUS_HALT_TIMEOUT);
+	do {
+		val = ath10k_ahb_tcsr_read32(ar, haltack_reg);
+		if (val & AHB_AXI_BUS_HALT_ACK)
+			break;
+
+		mdelay(1);
+	} while (time_before(jiffies, timeout));
+
+	if (!(val & AHB_AXI_BUS_HALT_ACK)) {
+		ath10k_err(ar, "failed to halt axi bus: %d\n", val);
+		return;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_AHB, "axi bus halted\n");
+}
+
+static void ath10k_ahb_halt_chip(struct ath10k *ar)
+{
+	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
+	u32 core_id, glb_cfg_reg, haltreq_reg, haltack_reg;
+	u32 val;
+	int ret;
+
+	if (IS_ERR_OR_NULL(ar_ahb->core_cold_rst) ||
+	    IS_ERR_OR_NULL(ar_ahb->radio_cold_rst) ||
+	    IS_ERR_OR_NULL(ar_ahb->radio_warm_rst) ||
+	    IS_ERR_OR_NULL(ar_ahb->radio_srif_rst) ||
+	    IS_ERR_OR_NULL(ar_ahb->cpu_init_rst)) {
+		ath10k_err(ar, "rst ctrl(s) is/are not initialized\n");
+		return;
+	}
+
+	core_id = ath10k_ahb_read32(ar, ATH10K_AHB_WLAN_CORE_ID_REG);
+
+	switch (core_id) {
+	case 0:
+		glb_cfg_reg = ATH10K_AHB_TCSR_WIFI0_GLB_CFG;
+		haltreq_reg = ATH10K_AHB_TCSR_WCSS0_HALTREQ;
+		haltack_reg = ATH10K_AHB_TCSR_WCSS0_HALTACK;
+		break;
+	case 1:
+		glb_cfg_reg = ATH10K_AHB_TCSR_WIFI1_GLB_CFG;
+		haltreq_reg = ATH10K_AHB_TCSR_WCSS1_HALTREQ;
+		haltack_reg = ATH10K_AHB_TCSR_WCSS1_HALTACK;
+		break;
+	default:
+		ath10k_err(ar, "invalid core id %d found, skipping reset sequence\n",
+			   core_id);
+		return;
+	}
+
+	ath10k_ahb_halt_axi_bus(ar, haltreq_reg, haltack_reg);
+
+	val = ath10k_ahb_tcsr_read32(ar, glb_cfg_reg);
+	val |= TCSR_WIFIX_GLB_CFG_DISABLE_CORE_CLK;
+	ath10k_ahb_tcsr_write32(ar, glb_cfg_reg, val);
+
+	ret = reset_control_assert(ar_ahb->core_cold_rst);
+	if (ret)
+		ath10k_err(ar, "failed to assert core cold rst: %d\n", ret);
+	msleep(1);
+
+	ret = reset_control_assert(ar_ahb->radio_cold_rst);
+	if (ret)
+		ath10k_err(ar, "failed to assert radio cold rst: %d\n", ret);
+	msleep(1);
+
+	ret = reset_control_assert(ar_ahb->radio_warm_rst);
+	if (ret)
+		ath10k_err(ar, "failed to assert radio warm rst: %d\n", ret);
+	msleep(1);
+
+	ret = reset_control_assert(ar_ahb->radio_srif_rst);
+	if (ret)
+		ath10k_err(ar, "failed to assert radio srif rst: %d\n", ret);
+	msleep(1);
+
+	ret = reset_control_assert(ar_ahb->cpu_init_rst);
+	if (ret)
+		ath10k_err(ar, "failed to assert cpu init rst: %d\n", ret);
+	msleep(10);
+
+	/* Clear halt req and core clock disable req before
+	 * deasserting wifi core reset.
+	 */
+	val = ath10k_ahb_tcsr_read32(ar, haltreq_reg);
+	val &= ~AHB_AXI_BUS_HALT_REQ;
+	ath10k_ahb_tcsr_write32(ar, haltreq_reg, val);
+
+	val = ath10k_ahb_tcsr_read32(ar, glb_cfg_reg);
+	val &= ~TCSR_WIFIX_GLB_CFG_DISABLE_CORE_CLK;
+	ath10k_ahb_tcsr_write32(ar, glb_cfg_reg, val);
+
+	ret = reset_control_deassert(ar_ahb->core_cold_rst);
+	if (ret)
+		ath10k_err(ar, "failed to deassert core cold rst: %d\n", ret);
+
+	ath10k_dbg(ar, ATH10K_DBG_AHB, "core %d reset done\n", core_id);
+}
+
 static int ath10k_ahb_probe(struct platform_device *pdev)
 {
 	return 0;
diff --git a/drivers/net/wireless/ath/ath10k/ahb.h b/drivers/net/wireless/ath/ath10k/ahb.h
index 2904b7b..4761eeb 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.h
+++ b/drivers/net/wireless/ath/ath10k/ahb.h
@@ -39,6 +39,21 @@ struct ath10k_ahb {
 
 #ifdef CONFIG_ATH10K_AHB
 
+#define ATH10K_AHB_WLAN_CORE_ID_REG          0x82030
+
+#define ATH10K_AHB_TCSR_WIFI0_GLB_CFG        0x49000
+#define ATH10K_AHB_TCSR_WIFI1_GLB_CFG        0x49004
+#define TCSR_WIFIX_GLB_CFG_DISABLE_CORE_CLK  BIT(25)
+
+#define ATH10K_AHB_TCSR_WCSS0_HALTREQ        0x52000
+#define ATH10K_AHB_TCSR_WCSS1_HALTREQ        0x52010
+#define ATH10K_AHB_TCSR_WCSS0_HALTACK        0x52004
+#define ATH10K_AHB_TCSR_WCSS1_HALTACK        0x52014
+
+#define ATH10K_AHB_AXI_BUS_HALT_TIMEOUT      10 /* msec */
+#define AHB_AXI_BUS_HALT_REQ                 1
+#define AHB_AXI_BUS_HALT_ACK                 1
+
 int ath10k_ahb_init(void);
 void ath10k_ahb_exit(void);
 
-- 
1.8.1.2


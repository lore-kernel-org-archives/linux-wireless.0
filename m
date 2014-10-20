Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35562 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaJTM2f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 08:28:35 -0400
Received: by mail-lb0-f180.google.com with SMTP id n15so3804460lbi.11
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 05:28:33 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 4/6] ath10k: make warm reset a bit safer and faster
Date: Mon, 20 Oct 2014 14:14:40 +0200
Message-Id: <1413807282-27951-5-git-send-email-michal.kazior@tieto.com> (sfid-20141020_142841_091178_0B91E98B)
In-Reply-To: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com>
References: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One of the problems with warm reset I've found is
that it must be guaranteed that copy engine
registers are not being accessed while being
reset. Otherwise in worst case scenario the host
may lock up.

Instead of using sleeps and hoping the device is
operational in some arbitrary timeframes use
firmware indication register.

As a side effect this makes driver
boot/stop/recovery faster.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * fix kernel panic on early fw crash due to CE not being fully initialized [Janusz]

 drivers/net/wireless/ath/ath10k/pci.c | 110 +++++++++++++++-------------------
 1 file changed, 48 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index c8cf177..54213ac 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1707,89 +1707,75 @@ static void ath10k_pci_warm_reset_si0(struct ath10k *ar)
 	msleep(10);
 }
 
-static int ath10k_pci_warm_reset(struct ath10k *ar)
+static void ath10k_pci_warm_reset_cpu(struct ath10k *ar)
 {
 	u32 val;
 
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot warm reset\n");
-
-	spin_lock_bh(&ar->data_lock);
-
-	ar->stats.fw_warm_reset_counter++;
-
-	spin_unlock_bh(&ar->data_lock);
-
-	/* debug */
-	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
-				PCIE_INTR_CAUSE_ADDRESS);
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot host cpu intr cause: 0x%08x\n",
-		   val);
-
-	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
-				CPU_INTR_ADDRESS);
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot target cpu intr cause: 0x%08x\n",
-		   val);
-
-	/* disable pending irqs */
-	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS +
-			   PCIE_INTR_ENABLE_ADDRESS, 0);
-
-	ath10k_pci_write32(ar, SOC_CORE_BASE_ADDRESS +
-			   PCIE_INTR_CLR_ADDRESS, ~0);
-
-	msleep(100);
-
-	/* clear fw indicator */
 	ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS, 0);
 
-	/* clear target LF timer interrupts */
 	val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
-				SOC_LF_TIMER_CONTROL0_ADDRESS);
-	ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS +
-			   SOC_LF_TIMER_CONTROL0_ADDRESS,
-			   val & ~SOC_LF_TIMER_CONTROL0_ENABLE_MASK);
+				SOC_RESET_CONTROL_ADDRESS);
+	ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + SOC_RESET_CONTROL_ADDRESS,
+			   val | SOC_RESET_CONTROL_CPU_WARM_RST_MASK);
+}
+
+static void ath10k_pci_warm_reset_ce(struct ath10k *ar)
+{
+	u32 val;
 
-	/* reset CE */
 	val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
 				SOC_RESET_CONTROL_ADDRESS);
+
 	ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + SOC_RESET_CONTROL_ADDRESS,
 			   val | SOC_RESET_CONTROL_CE_RST_MASK);
-	val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
-				SOC_RESET_CONTROL_ADDRESS);
 	msleep(10);
-
-	/* unreset CE */
 	ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + SOC_RESET_CONTROL_ADDRESS,
 			   val & ~SOC_RESET_CONTROL_CE_RST_MASK);
+}
+
+static void ath10k_pci_warm_reset_clear_lf(struct ath10k *ar)
+{
+	u32 val;
+
 	val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
-				SOC_RESET_CONTROL_ADDRESS);
-	msleep(10);
+				SOC_LF_TIMER_CONTROL0_ADDRESS);
+	ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS +
+			   SOC_LF_TIMER_CONTROL0_ADDRESS,
+			   val & ~SOC_LF_TIMER_CONTROL0_ENABLE_MASK);
+}
 
-	ath10k_pci_warm_reset_si0(ar);
+static int ath10k_pci_warm_reset(struct ath10k *ar)
+{
+	int ret;
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot warm reset\n");
 
-	/* debug */
-	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
-				PCIE_INTR_CAUSE_ADDRESS);
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot host cpu intr cause: 0x%08x\n",
-		   val);
+	spin_lock_bh(&ar->data_lock);
+	ar->stats.fw_warm_reset_counter++;
+	spin_unlock_bh(&ar->data_lock);
 
-	val = ath10k_pci_read32(ar, SOC_CORE_BASE_ADDRESS +
-				CPU_INTR_ADDRESS);
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot target cpu intr cause: 0x%08x\n",
-		   val);
+	ath10k_pci_irq_disable(ar);
 
-	/* CPU warm reset */
-	val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
-				SOC_RESET_CONTROL_ADDRESS);
-	ath10k_pci_write32(ar, RTC_SOC_BASE_ADDRESS + SOC_RESET_CONTROL_ADDRESS,
-			   val | SOC_RESET_CONTROL_CPU_WARM_RST_MASK);
+	/* Make sure the target CPU is not doing anything dangerous, e.g. if it
+	 * were to access copy engine while host performs copy engine reset
+	 * then it is possible for the device to confuse pci-e controller to
+	 * the point of bringing host system to a complete stop (i.e. hang).
+	 */
+	ath10k_pci_warm_reset_si0(ar);
+	ath10k_pci_warm_reset_cpu(ar);
+	ath10k_pci_init_pipes(ar);
+	ath10k_pci_wait_for_target_init(ar);
 
-	val = ath10k_pci_read32(ar, RTC_SOC_BASE_ADDRESS +
-				SOC_RESET_CONTROL_ADDRESS);
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot target reset state: 0x%08x\n",
-		   val);
+	ath10k_pci_warm_reset_clear_lf(ar);
+	ath10k_pci_warm_reset_ce(ar);
+	ath10k_pci_warm_reset_cpu(ar);
+	ath10k_pci_init_pipes(ar);
 
-	msleep(100);
+	ret = ath10k_pci_wait_for_target_init(ar);
+	if (ret) {
+		ath10k_warn(ar, "failed to wait for target init: %d\n", ret);
+		return ret;
+	}
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot warm reset complete\n");
 
-- 
1.8.5.3


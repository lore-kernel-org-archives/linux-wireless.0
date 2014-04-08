Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65446 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126AbaDHIgr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 04:36:47 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 2/5] wil6210: fix printouts for better readability
Date: Tue, 8 Apr 2014 11:36:16 +0300
Message-ID: <1396946179-11677-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140408_103657_014567_B93642B6)
In-Reply-To: <1396946179-11677-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1396946179-11677-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reshuffle prints to consolidate firmware/hardware information
report upon card init

Convert print for unhandled MISC ISR bits to "debug" - it is
normal situation and not an "error"

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/interrupt.c | 2 +-
 drivers/net/wireless/ath/wil6210/main.c      | 4 ++--
 drivers/net/wireless/ath/wil6210/pcie_bus.c  | 2 --
 drivers/net/wireless/ath/wil6210/wmi.c       | 8 ++++----
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/interrupt.c b/drivers/net/wireless/ath/wil6210/interrupt.c
index 5824cd4..73593aa 100644
--- a/drivers/net/wireless/ath/wil6210/interrupt.c
+++ b/drivers/net/wireless/ath/wil6210/interrupt.c
@@ -338,7 +338,7 @@ static irqreturn_t wil6210_irq_misc_thread(int irq, void *cookie)
 	}
 
 	if (isr)
-		wil_err(wil, "un-handled MISC ISR bits 0x%08x\n", isr);
+		wil_dbg_irq(wil, "un-handled MISC ISR bits 0x%08x\n", isr);
 
 	wil->isr_misc = 0;
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 95f4efe..1b265fd 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -363,8 +363,8 @@ static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 		wil_err(wil, "Firmware not ready\n");
 		return -ETIME;
 	} else {
-		wil_dbg_misc(wil, "FW ready after %d ms\n",
-			     jiffies_to_msecs(to-left));
+		wil_info(wil, "FW ready after %d ms. HW version 0x%08x\n",
+			 jiffies_to_msecs(to-left), wil->hw_version);
 	}
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 58fc096..27746e8 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -76,8 +76,6 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 	if (rc)
 		goto release_irq;
 
-	wil_info(wil, "HW version: 0x%08x\n", wil->hw_version);
-
 	return 0;
 
  release_irq:
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 2ba56ee..b7764f3 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -192,7 +192,7 @@ static int __wmi_send(struct wil6210_priv *wil, u16 cmdid, void *buf, u16 len)
 	might_sleep();
 
 	if (!test_bit(wil_status_fwready, &wil->status)) {
-		wil_err(wil, "FW not ready\n");
+		wil_err(wil, "WMI: cannot send command while FW not ready\n");
 		return -EAGAIN;
 	}
 
@@ -276,8 +276,8 @@ static void wmi_evt_ready(struct wil6210_priv *wil, int id, void *d, int len)
 	wil->fw_version = le32_to_cpu(evt->sw_version);
 	wil->n_mids = evt->numof_additional_mids;
 
-	wil_dbg_wmi(wil, "FW ver. %d; MAC %pM; %d MID's\n", wil->fw_version,
-		    evt->mac, wil->n_mids);
+	wil_info(wil, "FW ver. %d; MAC %pM; %d MID's\n", wil->fw_version,
+		 evt->mac, wil->n_mids);
 
 	if (!is_valid_ether_addr(ndev->dev_addr)) {
 		memcpy(ndev->dev_addr, evt->mac, ETH_ALEN);
@@ -290,7 +290,7 @@ static void wmi_evt_ready(struct wil6210_priv *wil, int id, void *d, int len)
 static void wmi_evt_fw_ready(struct wil6210_priv *wil, int id, void *d,
 			     int len)
 {
-	wil_dbg_wmi(wil, "WMI: FW ready\n");
+	wil_dbg_wmi(wil, "WMI: got FW ready event\n");
 
 	set_bit(wil_status_fwready, &wil->status);
 	/* reuse wmi_ready for the firmware ready indication */
-- 
1.8.3.2


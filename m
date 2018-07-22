Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:39653 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728270AbeGVIqQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Jul 2018 04:46:16 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 16/20] wil6210: set default 3-MSI
Date: Sun, 22 Jul 2018 10:47:41 +0300
Message-Id: <1532245665-15249-17-git-send-email-merez@codeaurora.org> (sfid-20180722_095037_790217_714BB7EF)
In-Reply-To: <1532245665-15249-1-git-send-email-merez@codeaurora.org>
References: <1532245665-15249-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

Single MSI is the current default configuration.
With multiple MSI interrupts configuration, Tx/Rx processing could
run in parallel on different CPU cores and allow better balance
between the cores.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index e44b4ad..89119e7 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -24,9 +24,9 @@
 #include <linux/rtnetlink.h>
 #include <linux/pm_runtime.h>
 
-static int n_msi = 1;
+static int n_msi = 3;
 module_param(n_msi, int, 0444);
-MODULE_PARM_DESC(n_msi, " Use MSI interrupt: 0 - use INTx, 1 - (default) - single, or 3");
+MODULE_PARM_DESC(n_msi, " Use MSI interrupt: 0 - use INTx, 1 - single, or 3 - (default) ");
 
 bool ftm_mode;
 module_param(ftm_mode, bool, 0444);
-- 
1.9.1

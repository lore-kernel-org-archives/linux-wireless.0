Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63129 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066AbaFPQiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:25 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 08/25] wil6210: Allow driver load if FW not ready
Date: Mon, 16 Jun 2014 19:37:06 +0300
Message-ID: <1402936643-31819-9-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_183833_092032_9A02AFD7)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Usable for debugging, to be able to obtain FW traces

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 1e2e07b..e5d7ffe 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -27,6 +27,10 @@ MODULE_PARM_DESC(use_msi,
 		 " Use MSI interrupt: "
 		 "0 - don't, 1 - (default) - single, or 3");
 
+static bool debug_fw; /* = false; */
+module_param(debug_fw, bool, S_IRUGO);
+MODULE_PARM_DESC(debug_fw, " load driver if FW not ready. For FW debug");
+
 /* Bus ops */
 static int wil_if_pcie_enable(struct wil6210_priv *wil)
 {
@@ -71,6 +75,8 @@ static int wil_if_pcie_enable(struct wil6210_priv *wil)
 	mutex_lock(&wil->mutex);
 	rc = wil_reset(wil);
 	mutex_unlock(&wil->mutex);
+	if (debug_fw)
+		rc = 0;
 	if (rc)
 		goto release_irq;
 
-- 
1.9.1


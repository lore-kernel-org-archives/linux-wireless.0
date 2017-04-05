Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5508 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932933AbdDEL6b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 07:58:31 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 06/11] wil6210: protect against sporadic interrupt during suspend flow
Date: Wed,  5 Apr 2017 14:58:09 +0300
Message-Id: <1491393494-11816-7-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170405_140159_887936_24B541E7)
In-Reply-To: <1491393494-11816-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1491393494-11816-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During the suspend flow, wil6210 HW can send sporadic interrupts,
while PCIe bus is not operational.
To prevent that, keep the interrupts disabled during the suspend
flow and re-enable them only after PCIe enablement in resume.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/pm.c b/drivers/net/wireless/ath/wil6210/pm.c
index a0acb2d..7260bef 100644
--- a/drivers/net/wireless/ath/wil6210/pm.c
+++ b/drivers/net/wireless/ath/wil6210/pm.c
@@ -80,12 +80,20 @@ int wil_suspend(struct wil6210_priv *wil, bool is_runtime)
 		}
 	}
 
-	if (wil->platform_ops.suspend)
+	/* Disable PCIe IRQ to prevent sporadic IRQs when PCIe is suspending */
+	wil_dbg_pm(wil, "Disabling PCIe IRQ before suspending\n");
+	wil_disable_irq(wil);
+
+	if (wil->platform_ops.suspend) {
 		rc = wil->platform_ops.suspend(wil->platform_handle);
+		if (rc)
+			wil_enable_irq(wil);
+	}
 
 out:
 	wil_dbg_pm(wil, "suspend: %s => %d\n",
 		   is_runtime ? "runtime" : "system", rc);
+
 	return rc;
 }
 
@@ -104,6 +112,9 @@ int wil_resume(struct wil6210_priv *wil, bool is_runtime)
 		}
 	}
 
+	wil_dbg_pm(wil, "Enabling PCIe IRQ\n");
+	wil_enable_irq(wil);
+
 	/* if netif up, bring hardware up
 	 * During open(), IFF_UP set after actual device method
 	 * invocation. This prevent recursive call to wil_up()
-- 
1.9.1

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:58034 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752678AbeEOJPG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:15:06 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 3/8] brcmfmac: add support for sysfs initiated coredump
Date: Tue, 15 May 2018 11:14:46 +0200
Message-Id: <1526375691-31789-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180515_111608_989570_15055011)
In-Reply-To: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver already supports device coredump initiated by firmware
event. Since commit 3c47d19ff4dc ("drivers: base: add coredump driver
ops") it is also possible to initiate it from user-space through
sysfs. This patch adds support for SDIO and PCIe devices.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h    | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c   | 8 ++++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 1 +
 4 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index a191541..d2f788d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -1165,6 +1165,7 @@ static int brcmf_ops_sdio_resume(struct device *dev)
 #ifdef CONFIG_PM_SLEEP
 		.pm = &brcmf_sdio_pm_ops,
 #endif	/* CONFIG_PM_SLEEP */
+		.coredump = brcmf_dev_coredump,
 	},
 };
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 27e693e..c496518 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -250,6 +250,8 @@ int brcmf_bus_get_fwname(struct brcmf_bus *bus, const char *ext,
 void brcmf_detach(struct device *dev);
 /* Indication from bus module that dongle should be reset */
 void brcmf_dev_reset(struct device *dev);
+/* Request from bus module to initiate a coredump */
+void brcmf_dev_coredump(struct device *dev);
 
 /* Configure the "global" bus state used by upper layers */
 void brcmf_bus_change_state(struct brcmf_bus *bus, enum brcmf_bus_state state);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 8d4511e..72954fd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1180,6 +1180,14 @@ void brcmf_dev_reset(struct device *dev)
 		brcmf_fil_cmd_int_set(drvr->iflist[0], BRCMF_C_TERMINATED, 1);
 }
 
+void brcmf_dev_coredump(struct device *dev)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+
+	if (brcmf_debug_create_memdump(bus_if, NULL, 0) < 0)
+		brcmf_dbg(TRACE, "failed to create coredump\n");
+}
+
 void brcmf_detach(struct device *dev)
 {
 	s32 i;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index f0797ae..5baa837 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2044,6 +2044,7 @@ static int brcmf_pcie_pm_leave_D3(struct device *dev)
 #ifdef CONFIG_PM
 	.driver.pm = &brcmf_pciedrvr_pm,
 #endif
+	.driver.coredump = brcmf_dev_coredump,
 };
 
 
-- 
1.9.1

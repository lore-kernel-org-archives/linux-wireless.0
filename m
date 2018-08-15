Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44014 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729363AbeHOUya (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 16:54:30 -0400
Received: by mail-lf1-f66.google.com with SMTP id f135-v6so1469806lfg.10
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2018 11:01:19 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [DEBUG PATCH] brcmfmac: add firmware watchdog running on host machine
Date: Wed, 15 Aug 2018 20:01:01 +0200
Message-Id: <20180815180101.15087-1-zajec5@gmail.com> (sfid-20180815_200124_520354_DC80F290)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

It may happen for FullMAC firmware to crash. It should be detected and
ideally somehow handled by a driver.

Since commit ff4445a8502c ("brcmfmac: expose device memory to
devcoredump subsystem") brcmfmac has BRCMF_E_PSM_WATCHDOG event handler
but it wasn't enough to detect all kind of crashes. E.g. Netgear R8000
(BCM4709A0 + 3 x BCM43602) user was exepriencing firmware crashes that
never resulted in passing BRCMF_E_PSM_WATCHDOG to the host driver.

That made me implement this trivial software watchdog that simply checks
periodically if firmware still replies to the commands.

Luckily this patch DOES NOT seem to be needed anymore since the commit
8a3ab2f38f16 ("brcmfmac: trigger memory dump upon firmware halt
signal"). That change allows brcmfmac to detect firmware crashes
successfully.

This patch is being posted for research/debugging purposes only. It
SHOULD NOT be applied until someone notices a firmware crash that
doesn't trigger the BRCMF_D2H_DEV_FWHALT signal.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/core.c | 21 +++++++++++++++++++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/core.h |  2 ++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 03bfbcc3ca6e..4d928ca795b1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -40,6 +40,7 @@
 #include "common.h"
 
 #define MAX_WAIT_FOR_8021X_TX			msecs_to_jiffies(950)
+#define BRCMF_FW_WATCHDOG_POLL			msecs_to_jiffies(3000)
 
 #define BRCMF_BSSIDX_INVALID			-1
 
@@ -1088,6 +1089,20 @@ static int brcmf_revinfo_read(struct seq_file *s, void *data)
 	return 0;
 }
 
+static void brcmf_fw_watchdog(struct work_struct *work)
+{
+	struct brcmf_pub *pub = container_of(work, struct brcmf_pub, fw_watchdog.work);
+	struct brcmf_if *ifp = pub->iflist[0];
+	s32 ver;
+	int err;
+
+	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION, &ver);
+	if (err)
+		brcmf_err("Firmware didn't respond: %d (firmware crash?)\n", err);
+
+	schedule_delayed_work(&pub->fw_watchdog, BRCMF_FW_WATCHDOG_POLL);
+}
+
 static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
 {
 	int ret = -1;
@@ -1159,6 +1174,9 @@ static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
 #endif
 #endif /* CONFIG_INET */
 
+	INIT_DELAYED_WORK(&drvr->fw_watchdog, brcmf_fw_watchdog);
+	schedule_delayed_work(&drvr->fw_watchdog, BRCMF_FW_WATCHDOG_POLL);
+
 	/* populate debugfs */
 	brcmf_debugfs_add_entry(drvr, "revinfo", brcmf_revinfo_read);
 	brcmf_feat_debugfs_create(drvr);
@@ -1287,6 +1305,9 @@ void brcmf_detach(struct device *dev)
 	if (drvr == NULL)
 		return;
 
+	cancel_delayed_work(&drvr->fw_watchdog);
+	flush_scheduled_work();
+
 #ifdef CONFIG_INET
 	unregister_inetaddr_notifier(&drvr->inetaddr_notifier);
 #endif
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 2d37a2fc6a6f..1afb3f0ca585 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -143,6 +143,8 @@ struct brcmf_pub {
 	struct notifier_block inet6addr_notifier;
 	struct brcmf_mp_device *settings;
 
+	struct delayed_work fw_watchdog;
+
 	u8 clmver[BRCMF_DCMD_SMLEN];
 };
 
-- 
2.13.7

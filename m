Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35463 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755059AbcKBCZu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Nov 2016 22:25:50 -0400
Received: by mail-pf0-f196.google.com with SMTP id i88so269513pfk.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2016 19:25:50 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH v2 06/12] mwifiex: don't pretend to resume while remove()'ing
Date: Wed,  2 Nov 2016 10:24:42 +0800
Message-Id: <1478053488-16042-4-git-send-email-huxinming820@marvell.com> (sfid-20161102_032553_873979_40472D25)
In-Reply-To: <1478053488-16042-1-git-send-email-huxinming820@marvell.com>
References: <1478053488-16042-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

The device core will not allow suspend() to race with remove().

---
v2: Same as v1
---
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 5 -----
 drivers/net/wireless/marvell/mwifiex/sdio.c | 3 ---
 drivers/net/wireless/marvell/mwifiex/usb.c  | 5 -----
 3 files changed, 13 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index fb34b99..32fbb91 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -225,11 +225,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 		return;
 
 	if (user_rmmod && !adapter->mfg_mode) {
-#ifdef CONFIG_PM_SLEEP
-		if (adapter->is_suspended)
-			mwifiex_pcie_resume(&pdev->dev);
-#endif
-
 		mwifiex_deauthenticate_all(adapter);
 
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index 1f6ebde..a750edb 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -292,9 +292,6 @@ mwifiex_sdio_remove(struct sdio_func *func)
 	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
 
 	if (user_rmmod && !adapter->mfg_mode) {
-		if (adapter->is_suspended)
-			mwifiex_sdio_resume(adapter->dev);
-
 		mwifiex_deauthenticate_all(adapter);
 
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index c20ff2f..a61455c 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -614,11 +614,6 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 		return;
 
 	if (user_rmmod && !adapter->mfg_mode) {
-#ifdef CONFIG_PM
-		if (adapter->is_suspended)
-			mwifiex_usb_resume(intf);
-#endif
-
 		mwifiex_deauthenticate_all(adapter);
 
 		mwifiex_init_shutdown_fw(mwifiex_get_priv(adapter,
-- 
1.8.1.4

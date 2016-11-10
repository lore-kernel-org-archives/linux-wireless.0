Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36007 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755648AbcKJL5v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Nov 2016 06:57:51 -0500
Received: by mail-pf0-f195.google.com with SMTP id n85so3971515pfi.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Nov 2016 03:57:51 -0800 (PST)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH RESEND v2 05/11] mwifiex: don't pretend to resume while remove()'ing
Date: Thu, 10 Nov 2016 19:57:06 +0800
Message-Id: <1478779032-5165-5-git-send-email-huxinming820@marvell.com> (sfid-20161110_125754_755885_84CB0C85)
In-Reply-To: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
References: <1478779032-5165-1-git-send-email-huxinming820@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

The device core will not allow suspend() to race with remove().

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
v2: Same as v1
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 5 -----
 drivers/net/wireless/marvell/mwifiex/sdio.c | 3 ---
 drivers/net/wireless/marvell/mwifiex/usb.c  | 5 -----
 3 files changed, 13 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 6152f08..a2353f9 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -257,11 +257,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
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
index 90f45d9..a2257a4 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -246,9 +246,6 @@ static int mwifiex_sdio_resume(struct device *dev)
 	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
 
 	if (user_rmmod && !adapter->mfg_mode) {
-		if (adapter->is_suspended)
-			mwifiex_sdio_resume(adapter->dev);
-
 		mwifiex_deauthenticate_all(adapter);
 
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 14f89fe..558a7f1 100644
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

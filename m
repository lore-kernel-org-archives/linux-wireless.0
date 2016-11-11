Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45871 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756659AbcKKNLX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 08:11:23 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        <rajatja@google.com>, <briannorris@google.com>,
        <dmitry.torokhov@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3 05/11] mwifiex: don't pretend to resume while remove()'ing
Date: Fri, 11 Nov 2016 18:40:12 +0530
Message-ID: <1478869818-4340-5-git-send-email-akarwar@marvell.com> (sfid-20161111_141134_708709_A1F32A06)
In-Reply-To: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
References: <1478869818-4340-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Brian Norris <briannorris@chromium.org>

The device core will not allow suspend() to race with remove().

Signed-off-by: Brian Norris <briannorris@chromium.org>
Tested-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v3: Same as v1 and v2
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
1.9.1

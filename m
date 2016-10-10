Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33434 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753086AbcJJPZ1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 11:25:27 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH] Revert "rtlwifi: rtl818x: constify local structures"
Date: Mon, 10 Oct 2016 10:25:20 -0500
Message-Id: <20161010152520.9812-1-Larry.Finger@lwfinger.net> (sfid-20161010_172530_909818_2A75F665)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit d86e64768859fca82c78e52877ceeba04e25d27a.

For drivers rtl8188ee, rtl8192ce, rtl8192ee, rtl8723ae, and rtl8821ae,
the Coccinelle script missed the fact that the code changes the firmware
name. When that happens, the kernel issues a BUG splat because
it is unable to overwrite the old name.

Although this bug only affects 5 of the 8 drivers it touched, I decided to
revert the entire patch. Continuing to constantify the other three could
too easily lead to introduction of future bugs.

Fixes: d86e64768859 ("rtlwifi: rtl818x: constify local structures")
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org> 
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
---

Kalle,

My apologies for letting these bugs to get by my review and testing. As
they affect kernel 4.8, please push this patch as soon as possible.

Thanks,

Larry
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
index e7b11b4..47e32cb 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
@@ -280,7 +280,7 @@ static struct rtl_mod_params rtl88ee_mod_params = {
 	.debug = DBG_EMERG,
 };
 
-static const struct rtl_hal_cfg rtl88ee_hal_cfg = {
+static struct rtl_hal_cfg rtl88ee_hal_cfg = {
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl88e_pci",
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
index 5c46a98..5400a96 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
@@ -254,7 +254,7 @@ static struct rtl_mod_params rtl92ce_mod_params = {
 	.debug = DBG_EMERG,
 };
 
-static const struct rtl_hal_cfg rtl92ce_hal_cfg = {
+static struct rtl_hal_cfg rtl92ce_hal_cfg = {
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl92c_pci",
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
index a9c39eb..60f42ae 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
@@ -258,7 +258,7 @@ static struct rtl_mod_params rtl92de_mod_params = {
 	.debug = DBG_EMERG,
 };
 
-static const struct rtl_hal_cfg rtl92de_hal_cfg = {
+static struct rtl_hal_cfg rtl92de_hal_cfg = {
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl8192de",
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
index ac299cb..c31c6bf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
@@ -262,7 +262,7 @@ static struct rtl_mod_params rtl92ee_mod_params = {
 	.debug = DBG_EMERG,
 };
 
-static const struct rtl_hal_cfg rtl92ee_hal_cfg = {
+static struct rtl_hal_cfg rtl92ee_hal_cfg = {
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl92ee_pci",
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
index a652d45..9378b0d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
@@ -302,7 +302,7 @@ static struct rtl_mod_params rtl92se_mod_params = {
 
 /* Because memory R/W bursting will cause system hang/crash
  * for 92se, so we don't read back after every write action */
-static const struct rtl_hal_cfg rtl92se_hal_cfg = {
+static struct rtl_hal_cfg rtl92se_hal_cfg = {
 	.bar_id = 1,
 	.write_readback = false,
 	.name = "rtl92s_pci",
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
index 89c828a..ff49a8c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
@@ -276,7 +276,7 @@ static struct rtl_mod_params rtl8723e_mod_params = {
 	.disable_watchdog = false,
 };
 
-static const struct rtl_hal_cfg rtl8723e_hal_cfg = {
+static struct rtl_hal_cfg rtl8723e_hal_cfg = {
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl8723e_pci",
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
index 20b53f0..2101793 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
@@ -276,7 +276,7 @@ static struct rtl_mod_params rtl8723be_mod_params = {
 	.ant_sel = 0,
 };
 
-static const struct rtl_hal_cfg rtl8723be_hal_cfg = {
+static struct rtl_hal_cfg rtl8723be_hal_cfg = {
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl8723be_pci",
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index 22f687b1..4159f9b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -316,7 +316,7 @@ static struct rtl_mod_params rtl8821ae_mod_params = {
 	.disable_watchdog = 0,
 };
 
-static const struct rtl_hal_cfg rtl8821ae_hal_cfg = {
+static struct rtl_hal_cfg rtl8821ae_hal_cfg = {
 	.bar_id = 2,
 	.write_readback = true,
 	.name = "rtl8821ae_pci",
-- 
2.10.0

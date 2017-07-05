Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34968 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752261AbdGEGEE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 02:04:04 -0400
Received: by mail-pg0-f65.google.com with SMTP id d193so11716986pgc.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jul 2017 23:04:04 -0700 (PDT)
Date: Wed, 5 Jul 2017 11:34:00 +0530
From: Souptick Joarder <jrdr.linux@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Fix memory leak when firmware request fails
Message-ID: <20170705060400.GA9481@symbol-HP-ZBook-15> (sfid-20170705_080410_718994_AA055B1A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch will fix memory leak when firmware request fails

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c | 4 ++++
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 6 ++++++
 9 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
index 7661cfa..37489b4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c
@@ -175,6 +175,8 @@ int rtl88e_init_sw_vars(struct ieee80211_hw *hw)
 				      rtl_fw_cb);
 	if (err) {
 		pr_info("Failed to request firmware!\n");
+		vfree(rtlpriv->rtlhal.pfirmware);
+		rtlpriv->rtlhal.pfirmware = NULL;
 		return 1;
 	}

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
index bcbb0c6..38f85bf 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/sw.c
@@ -176,6 +176,8 @@ int rtl92c_init_sw_vars(struct ieee80211_hw *hw)
 				      rtl_fw_cb);
 	if (err) {
 		pr_err("Failed to request firmware!\n");
+		vfree(rtlpriv->rtlhal.pfirmware);
+		rtlpriv->rtlhal.pfirmware = NULL;
 		return 1;
 	}

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
index 62d9214..dfbbd35 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c
@@ -85,6 +85,10 @@ static int rtl92cu_init_sw_vars(struct ieee80211_hw *hw)
 	err = request_firmware_nowait(THIS_MODULE, 1,
 				      fw_name, rtlpriv->io.dev,
 				      GFP_KERNEL, hw, rtl_fw_cb);
+	if (err) {
+		vfree(rtlpriv->rtlhal.pfirmware);
+		rtlpriv->rtlhal.pfirmware = NULL;
+	}
 	return err;
 }

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
index 16132c6..e38d6f7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/sw.c
@@ -183,6 +183,8 @@ static int rtl92d_init_sw_vars(struct ieee80211_hw *hw)
 				      rtl_fw_cb);
 	if (err) {
 		pr_err("Failed to request firmware!\n");
+		vfree(rtlpriv->rtlhal.pfirmware);
+		rtlpriv->rtlhal.pfirmware = NULL;
 		return 1;
 	}

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
index 48820bc..6f2d1f0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
@@ -177,6 +177,8 @@ int rtl92ee_init_sw_vars(struct ieee80211_hw *hw)
 				      rtl_fw_cb);
 	if (err) {
 		pr_err("Failed to request firmware!\n");
+		vfree(rtlpriv->rtlhal.pfirmware);
+		rtlpriv->rtlhal.pfirmware = NULL;
 		return 1;
 	}

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
index 2006b09..1ec20ef 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/sw.c
@@ -216,6 +216,8 @@ static int rtl92s_init_sw_vars(struct ieee80211_hw *hw)
 				      rtl92se_fw_cb);
 	if (err) {
 		pr_err("Failed to request firmware!\n");
+		vfree(rtlpriv->rtlhal.pfirmware);
+		rtlpriv->rtlhal.pfirmware = NULL;
 		return 1;
 	}

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
index 7bf9f25..aab8666 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c
@@ -184,6 +184,8 @@ int rtl8723e_init_sw_vars(struct ieee80211_hw *hw)
 				      rtl_fw_cb);
 	if (err) {
 		pr_err("Failed to request firmware!\n");
+		vfree(rtlpriv->rtlhal.pfirmware);
+		rtlpriv->rtlhal.pfirmware = NULL;
 		return 1;
 	}
 	return 0;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
index 8c0ac96..b7a5f92 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c
@@ -195,6 +195,8 @@ int rtl8723be_init_sw_vars(struct ieee80211_hw *hw)
 					      rtl_fw_cb);
 		if (err) {
 			pr_err("Failed to request firmware!\n");
+			vfree(rtlpriv->rtlhal.pfirmware);
+			rtlpriv->rtlhal.pfirmware = NULL;
 			return 1;
 		}
 	}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index abaf34c..5272fb4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -196,6 +196,8 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 	rtlpriv->rtlhal.wowlan_firmware = vzalloc(0x8000);
 	if (!rtlpriv->rtlhal.wowlan_firmware) {
 		pr_err("Can't alloc buffer for wowlan fw.\n");
+		vfree(rtlpriv->rtlhal.pfirmware);
+		rtlpriv->rtlhal.pfirmware = NULL;
 		return 1;
 	}

@@ -222,6 +224,8 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 					      rtl_fw_cb);
 		if (err) {
 			pr_err("Failed to request normal firmware!\n");
+			vfree(rtlpriv->rtlhal.wowlan_firmware);
+			vfree(rtlpriv->rtlhal.pfirmware);
 			return 1;
 		}
 	}
@@ -233,6 +237,8 @@ int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 				      rtl_wowlan_fw_cb);
 	if (err) {
 		pr_err("Failed to request wowlan firmware!\n");
+		vfree(rtlpriv->rtlhal.wowlan_firmware);
+		vfree(rtlpriv->rtlhal.pfirmware);
 		return 1;
 	}
 	return 0;
--
1.9.1

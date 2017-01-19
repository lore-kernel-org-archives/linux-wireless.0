Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32854 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753812AbdASRuk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 12:50:40 -0500
Received: by mail-oi0-f66.google.com with SMTP id j15so3769435oih.0
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2017 09:50:23 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH v2 3/3] rtlwifi: Remove debugging entry in sysfs
Date: Thu, 19 Jan 2017 11:25:21 -0600
Message-Id: <20170119172521.32643-4-Larry.Finger@lwfinger.net> (sfid-20170119_185044_380868_D6D3D6AA)
In-Reply-To: <20170119172521.32643-1-Larry.Finger@lwfinger.net>
References: <20170119172521.32643-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As the kernel provides access to module parameters through entries in
/sys/module/<driver>/parameters/, there is no need for a private
interface. Thus the existing code for setting the debug level is
removed.

Reported-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
---
V2 - Switched the dynamic debug entries from a private sysfs entry
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 59 -----------------------------
 drivers/net/wireless/realtek/rtlwifi/base.h |  1 -
 drivers/net/wireless/realtek/rtlwifi/pci.c  |  8 ----
 3 files changed, 68 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 1b23b24..01cf0a9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2083,65 +2083,6 @@ void rtl_recognize_peer(struct ieee80211_hw *hw, u8 *data, unsigned int len)
 }
 EXPORT_SYMBOL_GPL(rtl_recognize_peer);
 
-/*********************************************************
- *
- * sysfs functions
- *
- *********************************************************/
-static ssize_t rtl_show_debug_level(struct device *d,
-				    struct device_attribute *attr, char *buf)
-{
-	struct ieee80211_hw *hw = dev_get_drvdata(d);
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-
-	return sprintf(buf, "0x%08X\n", rtlpriv->cfg->mod_params->debug_level);
-}
-
-static ssize_t rtl_store_debug_level(struct device *d,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
-{
-	struct ieee80211_hw *hw = dev_get_drvdata(d);
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	unsigned long val;
-	int ret;
-
-	ret = kstrtoul(buf, 0, &val);
-	if (ret) {
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
-			 "%s is not in hex or decimal form.\n", buf);
-	} else {
-		rtlpriv->cfg->mod_params->debug_level = val;
-		RT_TRACE(rtlpriv, COMP_ERR, DBG_DMESG,
-			 "debuglevel:%x\n",
-			 rtlpriv->cfg->mod_params->debug_level);
-	}
-
-	return strnlen(buf, count);
-}
-
-static DEVICE_ATTR(debug_level, S_IWUSR | S_IRUGO,
-		   rtl_show_debug_level, rtl_store_debug_level);
-
-static struct attribute *rtl_sysfs_entries[] = {
-
-	&dev_attr_debug_level.attr,
-
-	NULL
-};
-
-/*
- * "name" is folder name witch will be
- * put in device directory like :
- * sys/devices/pci0000:00/0000:00:1c.4/
- * 0000:06:00.0/rtl_sysfs
- */
-struct attribute_group rtl_attribute_group = {
-	.name = "rtlsysfs",
-	.attrs = rtl_sysfs_entries,
-};
-EXPORT_SYMBOL_GPL(rtl_attribute_group);
-
 MODULE_AUTHOR("lizhaoming	<chaoming_li@realsil.com.cn>");
 MODULE_AUTHOR("Realtek WlanFAE	<wlanfae@realtek.com>");
 MODULE_AUTHOR("Larry Finger	<Larry.FInger@lwfinger.net>");
diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
index 74233d6..6c770aec 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.h
+++ b/drivers/net/wireless/realtek/rtlwifi/base.h
@@ -148,7 +148,6 @@ int rtl_send_smps_action(struct ieee80211_hw *hw,
 u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie);
 void rtl_recognize_peer(struct ieee80211_hw *hw, u8 *data, unsigned int len);
 u8 rtl_tid_to_ac(u8 tid);
-extern struct attribute_group rtl_attribute_group;
 void rtl_easy_concurrent_retrytimer_callback(unsigned long data);
 extern struct rtl_global_var rtl_global_var;
 void rtl_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation);
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index f6d4dbe..b402f43 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2289,12 +2289,6 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	}
 	rtlpriv->mac80211.mac80211_registered = 1;
 
-	err = sysfs_create_group(&pdev->dev.kobj, &rtl_attribute_group);
-	if (err) {
-		pr_err("failed to create sysfs device attributes\n");
-		goto fail3;
-	}
-
 	/*init rfkill */
 	rtl_init_rfkill(hw);	/* Init PCI sw */
 
@@ -2344,8 +2338,6 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
 	wait_for_completion(&rtlpriv->firmware_loading_complete);
 	clear_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 
-	sysfs_remove_group(&pdev->dev.kobj, &rtl_attribute_group);
-
 	/*ieee80211_unregister_hw will call ops_stop */
 	if (rtlmac->mac80211_registered == 1) {
 		ieee80211_unregister_hw(hw);
-- 
2.10.2

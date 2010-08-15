Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55747 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab0HOPdm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 11:33:42 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat-wireless: make patches apply again.
Date: Sun, 15 Aug 2010 14:28:10 +0200
Message-Id: <1281875290-8821-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/28-pm-qos-params.patch |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/patches/28-pm-qos-params.patch b/patches/28-pm-qos-params.patch
index cd8feca..e28d7a7 100644
--- a/patches/28-pm-qos-params.patch
+++ b/patches/28-pm-qos-params.patch
@@ -58,8 +58,8 @@ little wierd.
  	/* We have to signal any supplicant if we are disassociating */
  	if (associated)
 @@ -6669,8 +6686,16 @@ static int __init ipw2100_init(void)
- 	if (ret)
- 		goto out;
+ 	printk(KERN_INFO DRV_NAME ": %s, %s\n", DRV_DESCRIPTION, DRV_VERSION);
+ 	printk(KERN_INFO DRV_NAME ": %s\n", DRV_COPYRIGHT);
  
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,36))
  	pm_qos_add_request(&ipw2100_pm_qos_req, PM_QOS_CPU_DMA_LATENCY,
@@ -71,10 +71,10 @@ little wierd.
 +	pm_qos_add_requirement(PM_QOS_CPU_DMA_LATENCY, "ipw2100",
 +			       PM_QOS_DEFAULT_VALUE);
 +#endif
- #ifdef CONFIG_IPW2100_DEBUG
- 	ipw2100_debug_level = debug;
- 	ret = driver_create_file(&ipw2100_pci_driver.driver,
-@@ -6692,7 +6717,13 @@ static void __exit ipw2100_exit(void)
+ 
+ 	ret = pci_register_driver(&ipw2100_pci_driver);
+ 	if (ret)
+@@ -6697,7 +6722,13 @@ static void __exit ipw2100_exit(void)
  			   &driver_attr_debug_level);
  #endif
  	pci_unregister_driver(&ipw2100_pci_driver);
@@ -104,7 +104,7 @@ little wierd.
  					found->vif.bss_conf.beacon_int);
 --- a/net/mac80211/scan.c
 +++ b/net/mac80211/scan.c
-@@ -514,7 +514,11 @@ static int ieee80211_scan_state_decision
+@@ -500,7 +500,11 @@ static int ieee80211_scan_state_decision
  		bad_latency = time_after(jiffies +
  				ieee80211_scan_get_channel_time(next_chan),
  				local->leave_oper_channel_time +
-- 
1.7.0.4


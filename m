Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51021 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477Ab0JGVVU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 17:21:20 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: make patch apply again
Date: Thu,  7 Oct 2010 23:21:08 +0200
Message-Id: <1286486469-18904-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1286486469-18904-1-git-send-email-hauke@hauke-m.de>
References: <1286486469-18904-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/04-netns.patch        |   38 ++++++++------------------------------
 patches/09-threaded-irq.patch |    9 +++++----
 2 files changed, 13 insertions(+), 34 deletions(-)

diff --git a/patches/04-netns.patch b/patches/04-netns.patch
index 3bdcdfb..44d3f84 100644
--- a/patches/04-netns.patch
+++ b/patches/04-netns.patch
@@ -4,31 +4,9 @@ for the other changes. It'd be nice to figure out a way to
 bring thise here cleanly and seprately but they touch the same
 files...
 
---- a/net/wireless/nl80211.c
-+++ b/net/wireless/nl80211.c
-@@ -30,7 +30,9 @@ static struct genl_family nl80211_fam = 
- 	.hdrsize = 0,		/* no private header */
- 	.version = 1,		/* no particular meaning now */
- 	.maxattr = NL80211_ATTR_MAX,
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,32))
- 	.netnsok = true,
-+#endif
- };
- 
- /* internal helper: get rdev and dev */
-@@ -4462,7 +4464,9 @@ static int nl80211_wiphy_netns(struct sk
- 
- 	err = cfg80211_switch_netns(rdev, net);
-  out_put_net:
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
- 	put_net(net);
-+#endif
-  out:
- 	cfg80211_unlock_rdev(rdev);
-  out_rtnl:
 --- a/net/wireless/core.c
 +++ b/net/wireless/core.c
-@@ -224,6 +224,7 @@ int cfg80211_dev_rename(struct cfg80211_
+@@ -208,6 +208,7 @@ int cfg80211_dev_rename(struct cfg80211_
  	return 0;
  }
  
@@ -36,7 +14,7 @@ files...
  int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
  			  struct net *net)
  {
-@@ -264,6 +265,7 @@ int cfg80211_switch_netns(struct cfg8021
+@@ -248,6 +249,7 @@ int cfg80211_switch_netns(struct cfg8021
  
  	return 0;
  }
@@ -44,7 +22,7 @@ files...
  
  static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
  {
-@@ -376,7 +378,9 @@ struct wiphy *wiphy_new(const struct cfg
+@@ -382,7 +384,9 @@ too_many_devs:
  	rdev->wiphy.flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
  #endif
  
@@ -54,7 +32,7 @@ files...
  
  	rdev->rfkill_ops.set_block = cfg80211_rfkill_set_block;
  	rdev->rfkill = rfkill_alloc(dev_name(&rdev->wiphy.dev),
-@@ -694,8 +698,10 @@ static int cfg80211_netdev_notifier_call
+@@ -700,8 +704,10 @@ static int cfg80211_netdev_notifier_call
  		mutex_lock(&rdev->devlist_mtx);
  		list_add_rcu(&wdev->list, &rdev->netdev_list);
  		rdev->devlist_generation++;
@@ -65,7 +43,7 @@ files...
  
  		if (sysfs_create_link(&dev->dev.kobj, &rdev->wiphy.dev.kobj,
  				      "phy80211")) {
-@@ -841,6 +847,7 @@ static struct notifier_block cfg80211_ne
+@@ -847,6 +853,7 @@ static struct notifier_block cfg80211_ne
  	.notifier_call = cfg80211_netdev_notifier_call,
  };
  
@@ -73,7 +51,7 @@ files...
  static void __net_exit cfg80211_pernet_exit(struct net *net)
  {
  	struct cfg80211_registered_device *rdev;
-@@ -858,14 +865,17 @@ static void __net_exit cfg80211_pernet_e
+@@ -864,14 +871,17 @@ static void __net_exit cfg80211_pernet_e
  static struct pernet_operations cfg80211_pernet_ops = {
  	.exit = cfg80211_pernet_exit,
  };
@@ -91,7 +69,7 @@ files...
  
  	err = wiphy_sysfs_init();
  	if (err)
-@@ -900,8 +910,10 @@ out_fail_nl80211:
+@@ -906,8 +916,10 @@ out_fail_nl80211:
  out_fail_notifier:
  	wiphy_sysfs_exit();
  out_fail_sysfs:
@@ -102,7 +80,7 @@ files...
  	return err;
  }
  subsys_initcall(cfg80211_init);
-@@ -913,7 +925,9 @@ static void __exit cfg80211_exit(void)
+@@ -919,7 +931,9 @@ static void __exit cfg80211_exit(void)
  	unregister_netdevice_notifier(&cfg80211_netdev_notifier);
  	wiphy_sysfs_exit();
  	regulatory_exit();
diff --git a/patches/09-threaded-irq.patch b/patches/09-threaded-irq.patch
index 86c1ae1..4c29f7f 100644
--- a/patches/09-threaded-irq.patch
+++ b/patches/09-threaded-irq.patch
@@ -51,7 +51,7 @@ thread in process context as well.
  	b43_release_firmware(dev);
 --- a/drivers/net/wireless/b43/b43.h
 +++ b/drivers/net/wireless/b43/b43.h
-@@ -756,6 +756,9 @@ struct b43_wldev {
+@@ -757,6 +757,9 @@ struct b43_wldev {
  	unsigned int tx_count;
  	unsigned int rx_count;
  #endif
@@ -63,10 +63,11 @@ thread in process context as well.
  /* Data structure for the WLAN parts (802.11 cores) of the b43 chip. */
 --- a/drivers/net/wireless/rt2x00/rt2x00.h
 +++ b/drivers/net/wireless/rt2x00/rt2x00.h
-@@ -884,6 +884,9 @@ struct rt2x00_dev {
- 	 * and interrupt thread routine.
+@@ -902,6 +902,10 @@ struct rt2x00_dev {
+ 	 * Tasklet for processing tx status reports (rt2800pci).
  	 */
- 	u32 irqvalue[2];
+ 	struct tasklet_struct txstatus_tasklet;
++
 +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
 +	struct compat_threaded_irq irq_compat;
 +#endif
-- 
1.7.0.4


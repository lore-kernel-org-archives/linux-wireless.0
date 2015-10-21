Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:63997 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbbJUOU6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 10:20:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>
Subject: [PATCH] fixup! staging/wilc1000: split out bus specific modules
Date: Wed, 21 Oct 2015 16:20:39 +0200
Message-ID: <5740053.Wvv4FSxjh3@wuerfel> (sfid-20151021_162120_817798_107DE705)
In-Reply-To: <1445381258-1455986-19-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de> <1445381258-1455986-19-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch to split out bus modules causes new valid build warnings without this.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8a5f4673c5d0..fe3b464f0d5c 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1594,7 +1594,7 @@ int wilc_netdev_init(struct device *dev, const struct wilc1000_ops *ops,
 }
 EXPORT_SYMBOL_GPL(wilc_netdev_init);
 
-void __init wilc1000_init_driver(void)
+void wilc1000_init_driver(void)
 {
 #if defined(WILC_DEBUGFS)
 	if (wilc_debugfs_init() < 0)
@@ -1606,7 +1606,7 @@ void __init wilc1000_init_driver(void)
 }
 EXPORT_SYMBOL_GPL(wilc1000_init_driver);
 
-void __exit wilc_netdev_free(struct wilc *wilc1000_dev)
+void wilc_netdev_free(struct wilc *wilc1000_dev)
 {
 	int i = 0;
 	perInterface_wlan_t *nic[NUM_CONCURRENT_IFC] = {NULL,};
@@ -1653,7 +1653,7 @@ void __exit wilc_netdev_free(struct wilc *wilc1000_dev)
 }
 EXPORT_SYMBOL_GPL(wilc_netdev_free);
 
-void __exit wilc1000_exit_driver(void)
+void wilc1000_exit_driver(void)
 {
 	kfree(wilc1000_dev);
 	wilc1000_dev = NULL;
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index f684d5bf465d..b460b7f6971a 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -320,7 +320,7 @@ int wilc1000_wlan_get_num_conn_ifcs(void);
 int wilc1000_mac_xmit(struct sk_buff *skb, struct net_device *dev);
 int wilc_netdev_init(struct device *, const struct wilc1000_ops *ops,
 		     const struct wilc1000_hif_ops *hif_ops, int gpio);
-void __exit wilc_netdev_free(struct wilc *wilc1000_dev);
+void wilc_netdev_free(struct wilc *wilc1000_dev);
 
 void wilc_handle_isr(void);
 
@@ -340,7 +340,7 @@ extern bool wilc1000_enable_ps;
 int wilc1000_firmware_download(struct wilc *p_nic);
 int wilc1000_start_firmware(struct wilc_per_interface *nic);
 
-void __init wilc1000_init_driver(void);
-void __exit wilc1000_exit_driver(void);
+void wilc1000_init_driver(void);
+void wilc1000_exit_driver(void);
 
 #endif




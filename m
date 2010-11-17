Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1497 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255Ab0KQD4v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 22:56:51 -0500
Subject: [PATCH wireless-next] net/wireless: Use pr_<level> and
 netdev_<level>
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 19:56:49 -0800
Message-ID: <1289966209.28741.274.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No change in output for pr_<level> prefixes.
netdev_<level> output is different, arguably improved.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/wireless/core.c                |    8 +++---
 net/wireless/lib80211.c            |    8 ++++--
 net/wireless/lib80211_crypt_tkip.c |   16 +++++-------
 net/wireless/reg.c                 |   47 +++++++++++++----------------------
 net/wireless/util.c                |   11 +++-----
 net/wireless/wext-core.c           |   10 ++++---
 6 files changed, 44 insertions(+), 56 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9c21ebf..630bcf0 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -4,6 +4,8 @@
  * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/if.h>
 #include <linux/module.h>
 #include <linux/err.h>
@@ -216,8 +218,7 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 			    rdev->wiphy.debugfsdir,
 			    rdev->wiphy.debugfsdir->d_parent,
 			    newname))
-		printk(KERN_ERR "cfg80211: failed to rename debugfs dir to %s!\n",
-		       newname);
+		pr_err("failed to rename debugfs dir to %s!\n", newname);
 
 	nl80211_notify_dev_rename(rdev);
 
@@ -699,8 +700,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 
 		if (sysfs_create_link(&dev->dev.kobj, &rdev->wiphy.dev.kobj,
 				      "phy80211")) {
-			printk(KERN_ERR "wireless: failed to add phy80211 "
-				"symlink to netdev!\n");
+			pr_err("failed to add phy80211 symlink to netdev!\n");
 		}
 		wdev->netdev = dev;
 		wdev->sme_state = CFG80211_SME_IDLE;
diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
index 97d411f..3268fac 100644
--- a/net/wireless/lib80211.c
+++ b/net/wireless/lib80211.c
@@ -13,6 +13,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/ieee80211.h>
@@ -224,8 +226,8 @@ int lib80211_unregister_crypto_ops(struct lib80211_crypto_ops *ops)
 	return -EINVAL;
 
       found:
-	printk(KERN_DEBUG "lib80211_crypt: unregistered algorithm "
-	       "'%s'\n", ops->name);
+	printk(KERN_DEBUG "lib80211_crypt: unregistered algorithm '%s'\n",
+	       ops->name);
 	list_del(&alg->list);
 	spin_unlock_irqrestore(&lib80211_crypto_lock, flags);
 	kfree(alg);
@@ -270,7 +272,7 @@ static struct lib80211_crypto_ops lib80211_crypt_null = {
 
 static int __init lib80211_init(void)
 {
-	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION "\n");
+	pr_info(DRV_DESCRIPTION "\n");
 	return lib80211_register_crypto_ops(&lib80211_crypt_null);
 }
 
diff --git a/net/wireless/lib80211_crypt_tkip.c b/net/wireless/lib80211_crypt_tkip.c
index 0fe4051..7ea4f2b 100644
--- a/net/wireless/lib80211_crypt_tkip.c
+++ b/net/wireless/lib80211_crypt_tkip.c
@@ -10,6 +10,8 @@
  * more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -99,8 +101,7 @@ static void *lib80211_tkip_init(int key_idx)
 	priv->tx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm_arc4)) {
-		printk(KERN_DEBUG "lib80211_crypt_tkip: could not allocate "
-		       "crypto API arc4\n");
+		printk(KERN_DEBUG pr_fmt("could not allocate crypto API arc4\n"));
 		priv->tx_tfm_arc4 = NULL;
 		goto fail;
 	}
@@ -108,8 +109,7 @@ static void *lib80211_tkip_init(int key_idx)
 	priv->tx_tfm_michael = crypto_alloc_hash("michael_mic", 0,
 						 CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm_michael)) {
-		printk(KERN_DEBUG "lib80211_crypt_tkip: could not allocate "
-		       "crypto API michael_mic\n");
+		printk(KERN_DEBUG pr_fmt("could not allocate crypto API michael_mic\n"));
 		priv->tx_tfm_michael = NULL;
 		goto fail;
 	}
@@ -117,8 +117,7 @@ static void *lib80211_tkip_init(int key_idx)
 	priv->rx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
 						CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->rx_tfm_arc4)) {
-		printk(KERN_DEBUG "lib80211_crypt_tkip: could not allocate "
-		       "crypto API arc4\n");
+		printk(KERN_DEBUG pr_fmt("could not allocate crypto API arc4\n"));
 		priv->rx_tfm_arc4 = NULL;
 		goto fail;
 	}
@@ -126,8 +125,7 @@ static void *lib80211_tkip_init(int key_idx)
 	priv->rx_tfm_michael = crypto_alloc_hash("michael_mic", 0,
 						 CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->rx_tfm_michael)) {
-		printk(KERN_DEBUG "lib80211_crypt_tkip: could not allocate "
-		       "crypto API michael_mic\n");
+		printk(KERN_DEBUG pr_fmt("could not allocate crypto API michael_mic\n"));
 		priv->rx_tfm_michael = NULL;
 		goto fail;
 	}
@@ -536,7 +534,7 @@ static int michael_mic(struct crypto_hash *tfm_michael, u8 * key, u8 * hdr,
 	struct scatterlist sg[2];
 
 	if (tfm_michael == NULL) {
-		printk(KERN_WARNING "michael_mic: tfm_michael == NULL\n");
+		pr_warn("%s(): tfm_michael == NULL\n", __func__);
 		return -1;
 	}
 	sg_init_table(sg, 2);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3be18d9..e1ffd4a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -32,6 +32,9 @@
  * rely on some SHA1 checksum of the regdomain for example.
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/list.h>
@@ -48,7 +51,7 @@
 #ifdef CONFIG_CFG80211_REG_DEBUG
 #define REG_DBG_PRINT(format, args...) \
 	do { \
-		printk(KERN_DEBUG "cfg80211: " format , ## args); \
+		printk(KERN_DEBUG pr_fmt(format), ##args);	\
 	} while (0)
 #else
 #define REG_DBG_PRINT(args...)
@@ -367,11 +370,10 @@ static int call_crda(const char *alpha2)
 	};
 
 	if (!is_world_regdom((char *) alpha2))
-		printk(KERN_INFO "cfg80211: Calling CRDA for country: %c%c\n",
+		pr_info("Calling CRDA for country: %c%c\n",
 			alpha2[0], alpha2[1]);
 	else
-		printk(KERN_INFO "cfg80211: Calling CRDA to update world "
-			"regulatory domain\n");
+		pr_info("Calling CRDA to update world regulatory domain\n");
 
 	/* query internal regulatory database (if it exists) */
 	reg_regdb_query(alpha2);
@@ -1823,8 +1825,7 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 	const struct ieee80211_freq_range *freq_range = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 
-	printk(KERN_INFO "    (start_freq - end_freq @ bandwidth), "
-		"(max_antenna_gain, max_eirp)\n");
+	pr_info("    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)\n");
 
 	for (i = 0; i < rd->n_reg_rules; i++) {
 		reg_rule = &rd->reg_rules[i];
@@ -1836,16 +1837,14 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 		 * in certain regions
 		 */
 		if (power_rule->max_antenna_gain)
-			printk(KERN_INFO "    (%d KHz - %d KHz @ %d KHz), "
-				"(%d mBi, %d mBm)\n",
+			pr_info("    (%d KHz - %d KHz @ %d KHz), (%d mBi, %d mBm)\n",
 				freq_range->start_freq_khz,
 				freq_range->end_freq_khz,
 				freq_range->max_bandwidth_khz,
 				power_rule->max_antenna_gain,
 				power_rule->max_eirp);
 		else
-			printk(KERN_INFO "    (%d KHz - %d KHz @ %d KHz), "
-				"(N/A, %d mBm)\n",
+			pr_info("    (%d KHz - %d KHz @ %d KHz), (N/A, %d mBm)\n",
 				freq_range->start_freq_khz,
 				freq_range->end_freq_khz,
 				freq_range->max_bandwidth_khz,
@@ -1864,27 +1863,20 @@ static void print_regdomain(const struct ieee80211_regdomain *rd)
 			rdev = cfg80211_rdev_by_wiphy_idx(
 				last_request->wiphy_idx);
 			if (rdev) {
-				printk(KERN_INFO "cfg80211: Current regulatory "
-					"domain updated by AP to: %c%c\n",
+				pr_info("Current regulatory domain updated by AP to: %c%c\n",
 					rdev->country_ie_alpha2[0],
 					rdev->country_ie_alpha2[1]);
 			} else
-				printk(KERN_INFO "cfg80211: Current regulatory "
-					"domain intersected:\n");
+				pr_info("Current regulatory domain intersected:\n");
 		} else
-			printk(KERN_INFO "cfg80211: Current regulatory "
-				"domain intersected:\n");
+			pr_info("Current regulatory domain intersected:\n");
 	} else if (is_world_regdom(rd->alpha2))
-		printk(KERN_INFO "cfg80211: World regulatory "
-			"domain updated:\n");
+		pr_info("World regulatory domain updated:\n");
 	else {
 		if (is_unknown_alpha2(rd->alpha2))
-			printk(KERN_INFO "cfg80211: Regulatory domain "
-				"changed to driver built-in settings "
-				"(unknown country)\n");
+			pr_info("Regulatory domain changed to driver built-in settings (unknown country)\n");
 		else
-			printk(KERN_INFO "cfg80211: Regulatory domain "
-				"changed to country: %c%c\n",
+			pr_info("Regulatory domain changed to country: %c%c\n",
 				rd->alpha2[0], rd->alpha2[1]);
 	}
 	print_rd_rules(rd);
@@ -1892,8 +1884,7 @@ static void print_regdomain(const struct ieee80211_regdomain *rd)
 
 static void print_regdomain_info(const struct ieee80211_regdomain *rd)
 {
-	printk(KERN_INFO "cfg80211: Regulatory domain: %c%c\n",
-		rd->alpha2[0], rd->alpha2[1]);
+	pr_info("Regulatory domain: %c%c\n", rd->alpha2[0], rd->alpha2[1]);
 	print_rd_rules(rd);
 }
 
@@ -1944,8 +1935,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		return -EINVAL;
 
 	if (!is_valid_rd(rd)) {
-		printk(KERN_ERR "cfg80211: Invalid "
-			"regulatory domain detected:\n");
+		pr_err("Invalid regulatory domain detected:\n");
 		print_regdomain_info(rd);
 		return -EINVAL;
 	}
@@ -2117,8 +2107,7 @@ int __init regulatory_init(void)
 		 * early boot for call_usermodehelper(). For now treat these
 		 * errors as non-fatal.
 		 */
-		printk(KERN_ERR "cfg80211: kobject_uevent_env() was unable "
-			"to call CRDA during init");
+		pr_err("kobject_uevent_env() was unable to call CRDA during init\n");
 #ifdef CONFIG_CFG80211_REG_DEBUG
 		/* We want to find out exactly why when debugging */
 		WARN_ON(err);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 76120ae..fee020b 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -502,7 +502,7 @@ int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
 			skb_orphan(skb);
 
 		if (pskb_expand_head(skb, head_need, 0, GFP_ATOMIC)) {
-			printk(KERN_ERR "failed to reallocate Tx buffer\n");
+			pr_err("failed to reallocate Tx buffer\n");
 			return -ENOMEM;
 		}
 		skb->truesize += head_need;
@@ -685,20 +685,17 @@ void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
 			continue;
 		if (rdev->ops->add_key(wdev->wiphy, dev, i, false, NULL,
 					&wdev->connect_keys->params[i])) {
-			printk(KERN_ERR "%s: failed to set key %d\n",
-				dev->name, i);
+			netdev_err(dev, "failed to set key %d\n", i);
 			continue;
 		}
 		if (wdev->connect_keys->def == i)
 			if (rdev->ops->set_default_key(wdev->wiphy, dev, i)) {
-				printk(KERN_ERR "%s: failed to set defkey %d\n",
-					dev->name, i);
+				netdev_err(dev, "failed to set defkey %d\n", i);
 				continue;
 			}
 		if (wdev->connect_keys->defmgmt == i)
 			if (rdev->ops->set_default_mgmt_key(wdev->wiphy, dev, i))
-				printk(KERN_ERR "%s: failed to set mgtdef %d\n",
-					dev->name, i);
+				netdev_err(dev, "failed to set mgtdef %d\n", i);
 	}
 
 	kfree(wdev->connect_keys);
diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index dc675a3..fdbc23c 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -467,8 +467,8 @@ void wireless_send_event(struct net_device *	dev,
 		 * The best the driver could do is to log an error message.
 		 * We will do it ourselves instead...
 		 */
-		printk(KERN_ERR "%s (WE) : Invalid/Unknown Wireless Event (0x%04X)\n",
-		       dev->name, cmd);
+		netdev_err(dev, "(WE) : Invalid/Unknown Wireless Event (0x%04X)\n",
+			   cmd);
 		return;
 	}
 
@@ -476,11 +476,13 @@ void wireless_send_event(struct net_device *	dev,
 	if (descr->header_type == IW_HEADER_TYPE_POINT) {
 		/* Check if number of token fits within bounds */
 		if (wrqu->data.length > descr->max_tokens) {
-			printk(KERN_ERR "%s (WE) : Wireless Event too big (%d)\n", dev->name, wrqu->data.length);
+			netdev_err(dev, "(WE) : Wireless Event too big (%d)\n",
+				   wrqu->data.length);
 			return;
 		}
 		if (wrqu->data.length < descr->min_tokens) {
-			printk(KERN_ERR "%s (WE) : Wireless Event too small (%d)\n", dev->name, wrqu->data.length);
+			netdev_err(dev, "(WE) : Wireless Event too small (%d)\n",
+				   wrqu->data.length);
 			return;
 		}
 		/* Calculate extra_len - extra is NULL for restricted events */



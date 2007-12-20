Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:47370 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753468AbXLTXOE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 18:14:04 -0500
Date: Fri, 21 Dec 2007 00:05:10 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mac80211: fix breakage
Message-ID: <20071221000510.61dc4d8c@morte> (sfid-20071220_231420_481702_409E4B9D)
In-Reply-To: <200712202035.45909.mb@bu3sch.de>
References: <200712202020.51320.mb@bu3sch.de>
	<200712202035.45909.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix breakage introduced by:

commit 14d9eab2febd9caa8821d2b578d84e961dda3103
Author: Stefano Brivio <stefano.brivio@polimi.it>
Date:   Wed Dec 19 01:26:16 2007 +0100
---
Index: wireless-2.6/net/mac80211/ieee80211.c
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211.c
+++ wireless-2.6/net/mac80211/ieee80211.c
@@ -1323,21 +1323,46 @@ static int __init ieee80211_init(void)
 
 	BUILD_BUG_ON(sizeof(struct ieee80211_tx_packet_data) > sizeof(skb->cb));
 
+	ret = ieee80211_rate_control_register(&mac80211_rcsimple);
+	if (ret)
+		goto fail;
+
+#ifdef CONFIG_MAC80211_RC_PID
+	ret = ieee80211_rate_control_register(&mac80211_rcpid);
+	if (ret)
+		goto fail;
+#endif
+
 	ret = ieee80211_wme_register();
 	if (ret) {
 		printk(KERN_DEBUG "ieee80211_init: failed to "
 		       "initialize WME (err=%d)\n", ret);
-		return ret;
+		goto fail;
 	}
 
 	ieee80211_debugfs_netdev_init();
 	ieee80211_regdomain_init();
 
 	return 0;
+
+fail:
+	ieee80211_rate_control_unregister(&mac80211_rcsimple);
+
+#ifdef CONFIG_MAC80211_RCPID
+	ieee80211_rate_control_unregister(&mac80211_rcpid);
+#endif
+
+	return ret;
 }
 
 static void __exit ieee80211_exit(void)
 {
+	ieee80211_rate_control_unregister(&mac80211_rcsimple);
+
+#ifdef CONFIG_MAC80211_RC_PID
+	ieee80211_rate_control_unregister(&mac80211_rcpid);
+#endif
+
 	ieee80211_wme_unregister();
 	ieee80211_debugfs_netdev_exit();
 }
Index: wireless-2.6/net/mac80211/ieee80211_rate.h
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211_rate.h
+++ wireless-2.6/net/mac80211/ieee80211_rate.h
@@ -58,6 +58,12 @@ struct rate_control_ref {
 	struct kref kref;
 };
 
+/* default 'simple' algorithm */
+extern struct rate_control_ops mac80211_rcsimple;
+
+/* 'PID' algorithm */
+extern struct rate_control_ops mac80211_rcpid;
+
 int ieee80211_rate_control_register(struct rate_control_ops *ops);
 void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
 
Index: wireless-2.6/net/mac80211/ieee80211_rate.c
===================================================================
--- wireless-2.6.orig/net/mac80211/ieee80211_rate.c
+++ wireless-2.6/net/mac80211/ieee80211_rate.c
@@ -94,8 +94,7 @@ ieee80211_try_rate_control_ops_get(const
 	return ops;
 }
 
-/* Get the rate control algorithm. If `name' is NULL, get the first
- * available algorithm. */
+/* Get the rate control algorithm. */
 static struct rate_control_ops *
 ieee80211_rate_control_ops_get(const char *name)
 {



-- 
Ciao
Stefano

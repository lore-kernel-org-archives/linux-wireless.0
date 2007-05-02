Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:46060 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993483AbXEBQYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 12:24:21 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH] mac80211: don't compile ieee80211 qdisc code without CONFIG_NET_SCHED
Date: Wed, 02 May 2007 12:22:31 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070502162231.13300.2898.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This patch prevents all the qdisc code from compiling without
CONFIG_NET_SCHED.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/wme.c |   13 +++----------
 net/mac80211/wme.h |   22 ++++++++++++++++++++--
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 9874d9a..3823f15 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -81,6 +81,7 @@ ieee80211_rx_h_remove_qos_control(struct ieee80211_txrx_data *rx)
 }
 
 
+#ifdef CONFIG_NET_SCHED
 /* maximum number of hardware queues we support. */
 #define TC_80211_MAX_QUEUES 8
 
@@ -99,7 +100,6 @@ static inline unsigned classify_1d(struct sk_buff *skb, struct Qdisc *qd)
 	int dscp;
 	int offset;
 
-#ifdef CONFIG_NET_SCHED
 	struct ieee80211_sched_data *q = qdisc_priv(qd);
 	struct tcf_result res = { -1, 0 };
 
@@ -109,7 +109,6 @@ static inline unsigned classify_1d(struct sk_buff *skb, struct Qdisc *qd)
 		if (res.class != -1)
 			return res.class;
 	}
-#endif /* CONFIG_NET_SCHED */
 
 	/* skb->priority values from 256->263 are magic values to
 	 * directly indicate a specific 802.1d priority.
@@ -660,18 +659,12 @@ int ieee80211_qdisc_installed(struct net_device *dev)
 
 int ieee80211_wme_register(void)
 {
-	int err = 0;
-
-#ifdef CONFIG_NET_SCHED
-	err = register_qdisc(&wme_qdisc_ops);
-#endif
-	return err;
+	return register_qdisc(&wme_qdisc_ops);
 }
 
 
 void ieee80211_wme_unregister(void)
 {
-#ifdef CONFIG_NET_SCHED
 	unregister_qdisc(&wme_qdisc_ops);
-#endif
 }
+#endif /* CONFIG_NET_SCHED */
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index 2a79262..d65945b 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -30,10 +30,28 @@ ieee80211_rx_h_parse_qos(struct ieee80211_txrx_data *rx);
 ieee80211_txrx_result
 ieee80211_rx_h_remove_qos_control(struct ieee80211_txrx_data *rx);
 
+#ifdef CONFIG_NET_SCHED
 void ieee80211_install_qdisc(struct net_device *dev);
 int ieee80211_qdisc_installed(struct net_device *dev);
 
 int ieee80211_wme_register(void);
 void ieee80211_wme_unregister(void);
-
-#endif
+#else
+static inline void ieee80211_install_qdisc(struct net_device *dev)
+{
+}
+static inline int ieee80211_qdisc_installed(struct net_device *dev)
+{
+	return 1;
+}
+
+static inline int ieee80211_wme_register(void)
+{
+	return 0;
+}
+static inline void ieee80211_wme_unregister(void)
+{
+}
+#endif /* CONFIG_NET_SCHED */
+
+#endif /* _WME_H */


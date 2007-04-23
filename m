Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:9501 "EHLO annwn14.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161556AbXDWS6U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 14:58:20 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 12/13] mac80211: prevent master device from going up without ieee80211 qdisc
Date: Mon, 23 Apr 2007 14:48:14 -0400
To: Jiri Benc <jbenc@suse.cz>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Message-Id: <20070423184814.7029.82059.stgit@magic.sourmilk.net>
In-Reply-To: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This patch ensures that the master device cannot be opened without the
ieee80211 qdisc installed.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 net/mac80211/ieee80211.c |    6 ++++++
 net/mac80211/wme.c       |    6 ++++++
 net/mac80211/wme.h       |    1 +
 3 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 17c6fde..e876e04 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2270,6 +2270,12 @@ static int ieee80211_master_open(struct net_device *dev)
 	struct ieee80211_sub_if_data *sdata;
 	int res = -EOPNOTSUPP;
 
+	if (!ieee80211_qdisc_installed(dev)) {
+		printk(KERN_ERR "%s: ieee80211 qdisc not installed\n",
+		       dev->name);
+		return res;
+	}
+
 	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		if (sdata->dev != dev && netif_running(sdata->dev)) {
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 79b4305..1cb6358 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -655,6 +655,12 @@ void ieee80211_install_qdisc(struct net_device *dev)
 }
 
 
+int ieee80211_qdisc_installed(struct net_device *dev)
+{
+	return dev->qdisc_sleeping->ops == &wme_qdisc_ops;
+}
+
+
 int ieee80211_wme_register(void)
 {
 	int err = 0;
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index 90add6e..2a79262 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -31,6 +31,7 @@ ieee80211_txrx_result
 ieee80211_rx_h_remove_qos_control(struct ieee80211_txrx_data *rx);
 
 void ieee80211_install_qdisc(struct net_device *dev);
+int ieee80211_qdisc_installed(struct net_device *dev);
 
 int ieee80211_wme_register(void);
 void ieee80211_wme_unregister(void);


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:48987
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab2KUMoJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 07:44:09 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/6] ath9k: Remove 'stations' debugfs file
Date: Wed, 21 Nov 2012 18:13:15 +0530
Message-Id: <1353501795-10378-6-git-send-email-sujith@msujith.org> (sfid-20121121_134413_195930_7463F2A1)
In-Reply-To: <1353501795-10378-1-git-send-email-sujith@msujith.org>
References: <1353501795-10378-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The 'stations' debugfs file has multiple issues. It doesn't scale
to an arbitrary number of associated stations and allocating
64K is not elegant either. Now that changes have been made in
mac80211 to support dynamic creation/deletion of driver-specific
debugfs files on station addition/removal, remove this file and
make use of the mac80211 hooks (which will be done in a sebsequent
patch).

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  5 ---
 drivers/net/wireless/ath/ath9k/debug.c | 74 ----------------------------------
 drivers/net/wireless/ath/ath9k/init.c  |  4 --
 drivers/net/wireless/ath/ath9k/main.c  | 12 ------
 4 files changed, 95 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 30dc9e2..e63804e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -259,9 +259,6 @@ struct ath_atx_tid {
 };
 
 struct ath_node {
-#ifdef CONFIG_ATH9K_DEBUGFS
-	struct list_head list; /* for sc->nodes */
-#endif
 	struct ieee80211_sta *sta; /* station struct we're part of */
 	struct ieee80211_vif *vif; /* interface with which we're associated */
 	struct ath_atx_tid tid[WME_NUM_TID];
@@ -722,8 +719,6 @@ struct ath_softc {
 
 #ifdef CONFIG_ATH9K_DEBUGFS
 	struct ath9k_debug debug;
-	spinlock_t nodes_lock;
-	struct list_head nodes; /* basically, stations */
 #endif
 	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index bbb6bd7..4f7ffae 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -602,71 +602,6 @@ static ssize_t read_file_queues(struct file *file, char __user *user_buf,
 	return retval;
 }
 
-static ssize_t read_file_stations(struct file *file, char __user *user_buf,
-				  size_t count, loff_t *ppos)
-{
-	struct ath_softc *sc = file->private_data;
-	char *buf;
-	unsigned int len = 0, size = 64000;
-	struct ath_node *an = NULL;
-	ssize_t retval = 0;
-	int q;
-
-	buf = kzalloc(size, GFP_KERNEL);
-	if (buf == NULL)
-		return -ENOMEM;
-
-	len += snprintf(buf + len, size - len,
-			"Stations:\n"
-			" tid: addr sched paused buf_q-empty an ac baw\n"
-			" ac: addr sched tid_q-empty txq\n");
-
-	spin_lock(&sc->nodes_lock);
-	list_for_each_entry(an, &sc->nodes, list) {
-		unsigned short ma = an->maxampdu;
-		if (ma == 0)
-			ma = 65535; /* see ath_lookup_rate */
-		len += snprintf(buf + len, size - len,
-				"iface: %pM  sta: %pM max-ampdu: %hu mpdu-density: %uus\n",
-				an->vif->addr, an->sta->addr, ma,
-				(unsigned int)(an->mpdudensity));
-		if (len >= size)
-			goto done;
-
-		for (q = 0; q < WME_NUM_TID; q++) {
-			struct ath_atx_tid *tid = &(an->tid[q]);
-			len += snprintf(buf + len, size - len,
-					" tid: %p %s %s %i %p %p %hu\n",
-					tid, tid->sched ? "sched" : "idle",
-					tid->paused ? "paused" : "running",
-					skb_queue_empty(&tid->buf_q),
-					tid->an, tid->ac, tid->baw_size);
-			if (len >= size)
-				goto done;
-		}
-
-		for (q = 0; q < IEEE80211_NUM_ACS; q++) {
-			struct ath_atx_ac *ac = &(an->ac[q]);
-			len += snprintf(buf + len, size - len,
-					" ac: %p %s %i %p\n",
-					ac, ac->sched ? "sched" : "idle",
-					list_empty(&ac->tid_q), ac->txq);
-			if (len >= size)
-				goto done;
-		}
-	}
-
-done:
-	spin_unlock(&sc->nodes_lock);
-	if (len > size)
-		len = size;
-
-	retval = simple_read_from_buffer(user_buf, count, ppos, buf, len);
-	kfree(buf);
-
-	return retval;
-}
-
 static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
@@ -876,13 +811,6 @@ static const struct file_operations fops_queues = {
 	.llseek = default_llseek,
 };
 
-static const struct file_operations fops_stations = {
-	.read = read_file_stations,
-	.open = simple_open,
-	.owner = THIS_MODULE,
-	.llseek = default_llseek,
-};
-
 static const struct file_operations fops_misc = {
 	.read = read_file_misc,
 	.open = simple_open,
@@ -1611,8 +1539,6 @@ int ath9k_init_debug(struct ath_hw *ah)
 			   &sc->tx.txq_max_pending[IEEE80211_AC_VI]);
 	debugfs_create_u32("qlen_vo", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
 			   &sc->tx.txq_max_pending[IEEE80211_AC_VO]);
-	debugfs_create_file("stations", S_IRUSR, sc->debug.debugfs_phy, sc,
-			    &fops_stations);
 	debugfs_create_file("misc", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_misc);
 	debugfs_create_file("reset", S_IRUSR, sc->debug.debugfs_phy, sc,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 345a01a..80cae53 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -563,10 +563,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	spin_lock_init(&sc->sc_serial_rw);
 	spin_lock_init(&sc->sc_pm_lock);
 	mutex_init(&sc->mutex);
-#ifdef CONFIG_ATH9K_DEBUGFS
-	spin_lock_init(&sc->nodes_lock);
-	INIT_LIST_HEAD(&sc->nodes);
-#endif
 #ifdef CONFIG_ATH9K_MAC_DEBUG
 	spin_lock_init(&sc->debug.samp_lock);
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 7030567..b2326b1 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -331,11 +331,6 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 	u8 density;
 	an = (struct ath_node *)sta->drv_priv;
 
-#ifdef CONFIG_ATH9K_DEBUGFS
-	spin_lock(&sc->nodes_lock);
-	list_add(&an->list, &sc->nodes);
-	spin_unlock(&sc->nodes_lock);
-#endif
 	an->sta = sta;
 	an->vif = vif;
 
@@ -352,13 +347,6 @@ static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 {
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 
-#ifdef CONFIG_ATH9K_DEBUGFS
-	spin_lock(&sc->nodes_lock);
-	list_del(&an->list);
-	spin_unlock(&sc->nodes_lock);
-	an->sta = NULL;
-#endif
-
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		ath_tx_node_cleanup(sc, an);
 }
-- 
1.8.0


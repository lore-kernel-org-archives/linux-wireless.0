Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:48991 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934088AbXCWUn2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:43:28 -0400
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070323214400.642621638.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/19] mac80211: remove useless callbacks from wmaster
Message-Id: <20070323204444.499A54849D@silver.suse.cz>
Date: Fri, 23 Mar 2007 21:44:44 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless handlers (and other callbacks) on master interface only confuse
users. Let's get rid of them.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/mac80211/ieee80211.c       |    3 ---
 net/mac80211/ieee80211_i.h     |    1 -
 net/mac80211/ieee80211_ioctl.c |   22 ----------------------
 3 files changed, 0 insertions(+), 26 deletions(-)

9e00ff1fabe362774319e9d24fe866a0140b0f34
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 3d4fabe..e7576c5 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4597,9 +4597,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	sta_info_init(local);
 
 	mdev->hard_start_xmit = ieee80211_master_start_xmit;
-	mdev->wireless_handlers = &ieee80211_iw_master_handler_def;
-	mdev->do_ioctl = ieee80211_ioctl;
-	mdev->change_mtu = ieee80211_change_mtu;
 	mdev->tx_timeout = ieee80211_tx_timeout;
 	mdev->get_stats = ieee80211_get_stats;
 	mdev->open = ieee80211_master_open;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9df8ef0..4398453 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -627,7 +627,6 @@ struct net_device_stats *ieee80211_dev_s
 /* ieee80211_ioctl.c */
 int ieee80211_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 extern const struct iw_handler_def ieee80211_iw_handler_def;
-extern const struct iw_handler_def ieee80211_iw_master_handler_def;
 
 /* Set hw encryption from ieee80211 */
 int ieee80211_set_hw_encryption(struct net_device *dev,
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index ae224c6..93a204b 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -3280,25 +3280,3 @@ const struct iw_handler_def ieee80211_iw
 	.private_args	= (struct iw_priv_args *) ieee80211_ioctl_priv,
 	.get_wireless_stats = ieee80211_get_wireless_stats,
 };
-
-/* Wireless handlers for master interface */
-
-static const iw_handler ieee80211_master_handler[] =
-{
-	[SIOCGIWNAME  - SIOCIWFIRST] = (iw_handler) ieee80211_ioctl_giwname,
-	[SIOCSIWFREQ  - SIOCIWFIRST] = (iw_handler) ieee80211_ioctl_siwfreq,
-	[SIOCGIWFREQ  - SIOCIWFIRST] = (iw_handler) ieee80211_ioctl_giwfreq,
-	[SIOCGIWRANGE - SIOCIWFIRST] = (iw_handler) ieee80211_ioctl_giwrange,
-	[SIOCSIWRTS   - SIOCIWFIRST] = (iw_handler) ieee80211_ioctl_siwrts,
-	[SIOCGIWRTS   - SIOCIWFIRST] = (iw_handler) ieee80211_ioctl_giwrts,
-	[SIOCSIWFRAG  - SIOCIWFIRST] = (iw_handler) ieee80211_ioctl_siwfrag,
-	[SIOCGIWFRAG  - SIOCIWFIRST] = (iw_handler) ieee80211_ioctl_giwfrag,
-	[SIOCSIWRETRY - SIOCIWFIRST] = (iw_handler) ieee80211_ioctl_siwretry,
-	[SIOCGIWRETRY - SIOCIWFIRST] = (iw_handler) ieee80211_ioctl_giwretry,
-};
-
-const struct iw_handler_def ieee80211_iw_master_handler_def =
-{
-	.num_standard	= sizeof(ieee80211_master_handler) / sizeof(iw_handler),
-	.standard	= ieee80211_master_handler,
-};
-- 
1.3.0


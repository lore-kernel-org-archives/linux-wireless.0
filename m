Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39075 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893AbYBAMJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:09:17 -0500
Message-Id: <20080131185053.184012000@sipsolutions.net> (sfid-20080201_120925_947106_0729C34E)
References: <20080131184819.103174000@sipsolutions.net>
Date: Thu, 31 Jan 2008 19:48:23 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 4/8] mac80211: Use monitor configuration flags
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

Take advantage of the monitor configuration flags now provided by cfg80211.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net> 
---

 net/mac80211/cfg.c             |   15 ++++++++++
 net/mac80211/ieee80211.c       |   56 ++++++++++++++++++++++++++++++-----------
 net/mac80211/ieee80211_i.h     |    3 ++
 net/mac80211/ieee80211_iface.c |    2 +
 4 files changed, 60 insertions(+), 16 deletions(-)

--- everything.orig/net/mac80211/cfg.c	2008-01-31 15:46:10.825789821 +0100
+++ everything/net/mac80211/cfg.c	2008-01-31 15:46:11.615800454 +0100
@@ -38,6 +38,9 @@ static int ieee80211_add_iface(struct wi
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	enum ieee80211_if_types itype;
+	struct net_device *dev;
+	struct ieee80211_sub_if_data *sdata;
+	int err;
 
 	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED))
 		return -ENODEV;
@@ -46,7 +49,13 @@ static int ieee80211_add_iface(struct wi
 	if (itype == IEEE80211_IF_TYPE_INVALID)
 		return -EINVAL;
 
-	return ieee80211_if_add(local->mdev, name, NULL, itype);
+	err = ieee80211_if_add(local->mdev, name, &dev, itype);
+	if (err || itype != IEEE80211_IF_TYPE_MNTR || !flags)
+		return err;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	sdata->u.mntr_flags = *flags;
+	return 0;
 }
 
 static int ieee80211_del_iface(struct wiphy *wiphy, int ifindex)
@@ -99,6 +108,10 @@ static int ieee80211_change_iface(struct
 	ieee80211_if_reinit(dev);
 	ieee80211_if_set_type(dev, itype);
 
+	if (sdata->vif.type != IEEE80211_IF_TYPE_MNTR || !flags)
+		return 0;
+
+	sdata->u.mntr_flags = *flags;
 	return 0;
 }
 
--- everything.orig/net/mac80211/ieee80211.c	2008-01-31 15:46:06.365796278 +0100
+++ everything/net/mac80211/ieee80211.c	2008-01-31 15:46:11.615800454 +0100
@@ -67,9 +67,19 @@ static void ieee80211_configure_filter(s
 		new_flags |= FIF_ALLMULTI;
 
 	if (local->monitors)
-		new_flags |= FIF_CONTROL |
-			     FIF_OTHER_BSS |
-			     FIF_BCN_PRBRESP_PROMISC;
+		new_flags |= FIF_BCN_PRBRESP_PROMISC;
+
+	if (local->fif_fcsfail)
+		new_flags |= FIF_FCSFAIL;
+
+	if (local->fif_plcpfail)
+		new_flags |= FIF_PLCPFAIL;
+
+	if (local->fif_control)
+		new_flags |= FIF_CONTROL;
+
+	if (local->fif_other_bss)
+		new_flags |= FIF_OTHER_BSS;
 
 	changed_flags = local->filter_flags ^ new_flags;
 
@@ -230,13 +240,21 @@ static int ieee80211_open(struct net_dev
 	case IEEE80211_IF_TYPE_MNTR:
 		/* must be before the call to ieee80211_configure_filter */
 		local->monitors++;
-		if (local->monitors == 1) {
-			netif_tx_lock_bh(local->mdev);
-			ieee80211_configure_filter(local);
-			netif_tx_unlock_bh(local->mdev);
-
+		if (local->monitors == 1)
 			local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
-		}
+
+		if (sdata->u.mntr_flags & MONITOR_FLAG_FCSFAIL)
+			local->fif_fcsfail++;
+		if (sdata->u.mntr_flags & MONITOR_FLAG_PLCPFAIL)
+			local->fif_plcpfail++;
+		if (sdata->u.mntr_flags & MONITOR_FLAG_CONTROL)
+			local->fif_control++;
+		if (sdata->u.mntr_flags & MONITOR_FLAG_OTHER_BSS)
+			local->fif_other_bss++;
+
+		netif_tx_lock_bh(local->mdev);
+		ieee80211_configure_filter(local);
+		netif_tx_unlock_bh(local->mdev);
 		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
@@ -350,13 +368,21 @@ static int ieee80211_stop(struct net_dev
 		break;
 	case IEEE80211_IF_TYPE_MNTR:
 		local->monitors--;
-		if (local->monitors == 0) {
-			netif_tx_lock_bh(local->mdev);
-			ieee80211_configure_filter(local);
-			netif_tx_unlock_bh(local->mdev);
-
+		if (local->monitors == 0)
 			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
-		}
+
+		if (sdata->u.mntr_flags & MONITOR_FLAG_FCSFAIL)
+			local->fif_fcsfail--;
+		if (sdata->u.mntr_flags & MONITOR_FLAG_PLCPFAIL)
+			local->fif_plcpfail--;
+		if (sdata->u.mntr_flags & MONITOR_FLAG_CONTROL)
+			local->fif_control--;
+		if (sdata->u.mntr_flags & MONITOR_FLAG_OTHER_BSS)
+			local->fif_other_bss--;
+
+		netif_tx_lock_bh(local->mdev);
+		ieee80211_configure_filter(local);
+		netif_tx_unlock_bh(local->mdev);
 		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
--- everything.orig/net/mac80211/ieee80211_i.h	2008-01-31 15:46:09.975794650 +0100
+++ everything/net/mac80211/ieee80211_i.h	2008-01-31 15:46:11.615800454 +0100
@@ -345,6 +345,7 @@ struct ieee80211_sub_if_data {
 		struct ieee80211_if_wds wds;
 		struct ieee80211_if_vlan vlan;
 		struct ieee80211_if_sta sta;
+		u32 mntr_flags;
 	} u;
 	int channel_use;
 	int channel_use_raw;
@@ -425,6 +426,8 @@ struct ieee80211_local {
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
 	int open_count;
 	int monitors;
+	/* number of interfaces with corresponding FIF_ flags */
+	int fif_fcsfail, fif_plcpfail, fif_control, fif_other_bss;
 	unsigned int filter_flags; /* FIF_* */
 	struct iw_statistics wstats;
 	u8 wstats_flags;
--- everything.orig/net/mac80211/ieee80211_iface.c	2008-01-31 15:45:56.075794649 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2008-01-31 15:46:11.615800454 +0100
@@ -160,6 +160,8 @@ void ieee80211_if_set_type(struct net_de
 	case IEEE80211_IF_TYPE_MNTR:
 		dev->type = ARPHRD_IEEE80211_RADIOTAP;
 		dev->hard_start_xmit = ieee80211_monitor_start_xmit;
+		sdata->u.mntr_flags = MONITOR_FLAG_CONTROL |
+				      MONITOR_FLAG_OTHER_BSS;
 		break;
 	default:
 		printk(KERN_WARNING "%s: %s: Unknown interface type 0x%x",

-- 


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:13037 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993028AbXDRSzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2007 14:55:53 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: rx racing against removing interfaces?
Date: Wed, 18 Apr 2007 14:52:25 -0400
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1174950322.25887.59.camel@johannes.berg> <20070418203151.30f32933@griffin.suse.cz>
In-Reply-To: <20070418203151.30f32933@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8176372.RSa72DYioP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704181452.30242.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart8176372.RSa72DYioP
Content-Type: multipart/mixed;
  boundary="Boundary-01=_qjmJGc8n5mka6fO"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_qjmJGc8n5mka6fO
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 18 April 2007 14:31, Jiri Benc wrote:
> Yes, there is a race.
>
> - sta_info should be holding a reference to a net_device in its dev
>   field (sta_info_add).
> - walking through the local->sub_if_list in __ieee80211_rx should
>   happen under a lock
> - while invoking rx handlers in the list_for_each_entry loop (they
>   shouldn't be called under the lock above - hm, another thing that
>   makes locking in mac80211 hard) we should hold a reference to the
>   appropriate net_device
This should be all fixed in the attached patch. It applies on top of johill=
's=20
no-rtnl-in-wext patch (because RTNLs are eliminated) and my radiotap RX pat=
ch=20
(just because I have it in my tree).

Unfortunately, it introduces a deadlock in the wext interface for removing=
=20
virtual interfaces, which is why this isn't signed off. I should be able to=
=20
figure that one out..

=2DMichael Wu

--Boundary-01=_qjmJGc8n5mka6fO
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="fix-subif-locking.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="fix-subif-locking.diff"

mac80211: fix virtual interface related locking

=46rom: Michael Wu <flamingice@sourmilk.net>

This converts sub_if_lock to a rw lock and makes all code touching
sub_if_list use it, grabs mdev's tx lock in set_multicast_list to
synchronize multicast configuration, and eliminates all explicit rtnl
locking.
=2D--

 net/mac80211/debugfs.c         |   15 ------
 net/mac80211/ieee80211.c       |   72 ++++++++++++++++--------------
 net/mac80211/ieee80211_cfg.c   |   36 +++------------
 net/mac80211/ieee80211_i.h     |    7 +--
 net/mac80211/ieee80211_iface.c |   95 ++++++++++++++----------------------=
=2D---
 net/mac80211/ieee80211_ioctl.c |   68 ++++++++++++++++-------------
 net/mac80211/ieee80211_sta.c   |   24 ++--------
 7 files changed, 124 insertions(+), 193 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index fbb003e..1a124c5 100644
=2D-- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -118,16 +118,6 @@ DEBUGFS_READONLY_FILE(rate_ctrl_alg, 100, "%s",
=20
 /* statistics stuff */
=20
=2Dstatic inline int rtnl_lock_local(struct ieee80211_local *local)
=2D{
=2D	rtnl_lock();
=2D	if (unlikely(local->reg_state !=3D IEEE80211_DEV_REGISTERED)) {
=2D		rtnl_unlock();
=2D		return -ENODEV;
=2D	}
=2D	return 0;
=2D}
=2D
 #define DEBUGFS_STATS_FILE(name, buflen, fmt, value...)			\
 	DEBUGFS_READONLY_FILE(stats_ ##name, buflen, fmt, ##value)
=20
@@ -144,12 +134,7 @@ static ssize_t format_devstat_counter(struct ieee80211=
_local *local,
 	if (!local->ops->get_stats)
 		return -EOPNOTSUPP;
=20
=2D	res =3D rtnl_lock_local(local);
=2D	if (res)
=2D		return res;
=2D
 	res =3D local->ops->get_stats(local_to_hw(local), &stats);
=2D	rtnl_unlock();
 	if (!res)
 		res =3D printvalue(&stats, buf, sizeof(buf));
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index ad84eef..fae3666 100644
=2D-- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -953,7 +953,7 @@ static void purge_old_ps_buffers(struct ieee80211_local=
 *local)
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
=20
=2D	spin_lock_bh(&local->sub_if_lock);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		struct ieee80211_if_ap *ap;
 		if (sdata->dev =3D=3D local->mdev ||
@@ -967,7 +967,7 @@ static void purge_old_ps_buffers(struct ieee80211_local=
 *local)
 		}
 		total +=3D skb_queue_len(&ap->ps_bc_buf);
 	}
=2D	spin_unlock_bh(&local->sub_if_lock);
+	read_unlock(&local->sub_if_lock);
=20
 	spin_lock_bh(&local->sta_lock);
 	list_for_each_entry(sta, &local->sta_list, list) {
@@ -2148,6 +2148,7 @@ static void ieee80211_set_multicast_list(struct net_d=
evice *dev)
 	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
 	unsigned short flags;
=20
+	netif_tx_lock(local->mdev);
 	if (((dev->flags & IFF_ALLMULTI) !=3D 0) ^ (sdata->allmulti !=3D 0)) {
 		if (sdata->allmulti) {
 			sdata->allmulti =3D 0;
@@ -2177,9 +2178,12 @@ static void ieee80211_set_multicast_list(struct net_=
device *dev)
 			flags |=3D IFF_ALLMULTI;
 		if (local->iff_promiscs)
 			flags |=3D IFF_PROMISC;
+		read_lock(&local->sub_if_lock);
 		local->ops->set_multicast_list(local_to_hw(local), flags,
 					      local->mc_count);
+		read_unlock(&local->sub_if_lock);
 	}
+	netif_tx_unlock(local->mdev);
 }
=20
 struct dev_mc_list *ieee80211_get_mc_list_item(struct ieee80211_hw *hw,
@@ -2220,12 +2224,11 @@ static struct net_device_stats *ieee80211_get_stats=
(struct net_device *dev)
 	return &(sdata->stats);
 }
=20
=2Dvoid ieee80211_if_shutdown(struct net_device *dev)
+static void ieee80211_if_shutdown(struct net_device *dev)
 {
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
=20
=2D	ASSERT_RTNL();
 	switch (sdata->type) {
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
@@ -2269,6 +2272,7 @@ static int ieee80211_master_open(struct net_device *d=
ev)
 	struct ieee80211_sub_if_data *sdata;
 	int res =3D -EOPNOTSUPP;
=20
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		if (sdata->dev !=3D dev && netif_running(sdata->dev)) {
 			res =3D 0;
@@ -2276,6 +2280,7 @@ static int ieee80211_master_open(struct net_device *d=
ev)
 			break;
 		}
 	}
+	read_unlock(&local->sub_if_lock);
 	return res;
 }
=20
@@ -2285,10 +2290,14 @@ static int ieee80211_master_stop(struct net_device =
*dev)
 	struct ieee80211_sub_if_data *sdata;
=20
 	tasklet_disable(&local->tx_pending_tasklet);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
=2D		if (sdata->dev !=3D dev && netif_running(sdata->dev))
+		if (sdata->dev !=3D dev && netif_running(sdata->dev)) {
+			read_unlock(&local->sub_if_lock);
 			return -EOPNOTSUPP;
+		}
 	}
+	read_unlock(&local->sub_if_lock);
 	return 0;
 }
=20
@@ -2346,14 +2355,18 @@ static int ieee80211_open(struct net_device *dev)
 	int res;
=20
 	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(nsdata, &local->sub_if_list, list) {
 		struct net_device *ndev =3D nsdata->dev;
=20
 		if (ndev !=3D dev && ndev !=3D local->mdev && netif_running(ndev) &&
 		    compare_ether_addr(dev->dev_addr, ndev->dev_addr) =3D=3D 0 &&
=2D		    !identical_mac_addr_allowed(sdata->type, nsdata->type))
+		    !identical_mac_addr_allowed(sdata->type, nsdata->type)) {
+			read_unlock(&local->sub_if_lock);
 			return -ENOTUNIQ;
+		}
 	}
+	read_unlock(&local->sub_if_lock);
=20
 	if (sdata->type =3D=3D IEEE80211_IF_TYPE_WDS &&
 	    is_zero_ether_addr(sdata->u.wds.remote_addr))
@@ -4004,6 +4017,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct s=
k_buff *skb,
 		struct sk_buff *skb_new;
 		u8 *bssid =3D ieee80211_get_bssid(hdr, skb->len - radiotap_len);
=20
+		read_lock(&local->sub_if_lock);
 		list_for_each_entry(sdata, &local->sub_if_list, list) {
 			rx.u.rx.ra_match =3D 1;
 			switch (sdata->type) {
@@ -4039,10 +4053,9 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct =
sk_buff *skb,
 					rx.u.rx.ra_match =3D 0;
 				} else if (!sta)
 					sta =3D rx.sta =3D
=2D						ieee80211_ibss_add_sta(local->mdev,
+						ieee80211_ibss_add_sta(sdata->dev,
 								       skb, bssid,
 								       hdr->addr2);
=2D						/* FIXME: call with sdata->dev */
 				break;
 			case IEEE80211_IF_TYPE_AP:
 				if (!bssid) {
@@ -4097,6 +4110,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct s=
k_buff *skb,
 						     &rx, sta);
 		} else
 			dev_kfree_skb(skb);
+		read_unlock(&local->sub_if_lock);
 	}
=20
   end:
@@ -4241,11 +4255,13 @@ static void ieee80211_stat_refresh(unsigned long da=
ta)
 	spin_unlock_bh(&local->sta_lock);
=20
 	/* go through all subinterfaces */
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		sdata->channel_use =3D (sdata->channel_use_raw /
 				      local->stat_time) / CHAN_UTIL_PER_10MS;
 		sdata->channel_use_raw =3D 0;
 	}
+	read_unlock(&local->sub_if_lock);
=20
 	/* hardware interface */
 	local->channel_use =3D (local->channel_use_raw /
@@ -4683,7 +4699,6 @@ int ieee80211_init_rate_ctrl_alg(struct ieee80211_loc=
al *local,
 {
 	struct rate_control_ref *ref, *old;
=20
=2D	ASSERT_RTNL();
 	if (local->open_count || netif_running(local->mdev) ||
 	    (local->apdev && netif_running(local->apdev)))
 		return -EBUSY;
@@ -4799,7 +4814,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_d=
ata_len,
=20
 	INIT_LIST_HEAD(&local->modes_list);
=20
=2D	spin_lock_init(&local->sub_if_lock);
+	rwlock_init(&local->sub_if_lock);
 	INIT_LIST_HEAD(&local->sub_if_list);
=20
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_sta_scan_work);
@@ -4841,7 +4856,6 @@ EXPORT_SYMBOL(ieee80211_alloc_hw);
 int ieee80211_register_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local =3D hw_to_local(hw);
=2D	struct net_device *sta_dev;
 	int result;
=20
 	result =3D wiphy_register(local->hw.wiphy);
@@ -4865,17 +4879,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (result < 0)
 		goto fail_sta_info;
=20
=2D	rtnl_lock();
=2D	result =3D dev_alloc_name(local->mdev, local->mdev->name);
=2D	if (result < 0) {
=2D		rtnl_unlock();
=2D		goto fail_dev;
=2D	}
=2D
 	memcpy(local->mdev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(local->mdev, wiphy_dev(local->hw.wiphy));
=20
=2D	result =3D register_netdevice(local->mdev);
+	result =3D register_netdev(local->mdev);
 	if (result < 0)
 		goto fail_dev;
=20
@@ -4896,16 +4903,16 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_wep;
 	}
=20
=2D	/* TODO: add rtnl locking around device creation and qdisc install */
 	ieee80211_install_qdisc(local->mdev);
=20
 	/* add one default STA interface */
=2D	result =3D ieee80211_if_add(local->mdev, "wlan%d", 1, &sta_dev);
=2D	if (result =3D=3D 0)
=2D		ieee80211_if_set_type(sta_dev, IEEE80211_IF_TYPE_STA);
+	result =3D ieee80211_if_add(local->mdev, "wlan%d", NULL,
+				  IEEE80211_IF_TYPE_STA);
+	if (result)
+		printk(KERN_WARNING "%s: Failed to add default virtual iface\n",
+		       local->mdev->name);
=20
 	local->reg_state =3D IEEE80211_DEV_REGISTERED;
=2D	rtnl_unlock();
=20
 	ieee80211_led_init(local);
=20
@@ -4915,9 +4922,8 @@ fail_wep:
 	rate_control_deinitialize(local);
 fail_rate:
 	ieee80211_debugfs_remove_netdev(IEEE80211_DEV_TO_SUB_IF(local->mdev));
=2D	unregister_netdevice(local->mdev);
+	unregister_netdev(local->mdev);
 fail_dev:
=2D	rtnl_unlock();
 	sta_info_stop(local);
 fail_sta_info:
 	debugfs_hw_del(local);
@@ -4962,23 +4968,24 @@ void ieee80211_unregister_hw(struct ieee80211_hw *h=
w)
 {
 	struct ieee80211_local *local =3D hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata, *tmp;
+	LIST_HEAD(tmp_list);
 	int i;
=20
 	tasklet_kill(&local->tx_pending_tasklet);
 	tasklet_kill(&local->tasklet);
=20
=2D	rtnl_lock();
=2D
 	BUG_ON(local->reg_state !=3D IEEE80211_DEV_REGISTERED);
=20
 	local->reg_state =3D IEEE80211_DEV_UNREGISTERED;
 	if (local->apdev)
 		ieee80211_if_del_mgmt(local);
=20
=2D	list_for_each_entry_safe(sdata, tmp, &local->sub_if_list, list)
=2D		__ieee80211_if_del(local, sdata);
+	write_lock_bh(&local->sub_if_lock);
+	list_replace_init(&local->sub_if_list, &tmp_list);
+	write_unlock_bh(&local->sub_if_lock);
=20
=2D	rtnl_unlock();
+	list_for_each_entry_safe(sdata, tmp, &tmp_list, list)
+		__ieee80211_if_del(local, sdata);
=20
 	if (local->stat_time)
 		del_timer_sync(&local->stat_timer);
@@ -4988,8 +4995,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 		flush_scheduled_work();
 		/* The scan_work is guaranteed not to be called at this
 		 * point. It is not scheduled and not running now. It can be
=2D		 * scheduled again only by sta_work (stopped by now) or under
=2D		 * rtnl lock. */
+		 * scheduled again only by sta_work (stopped by now). */
 	}
=20
 	ieee80211_rx_bss_list_deinit(local->mdev);
diff --git a/net/mac80211/ieee80211_cfg.c b/net/mac80211/ieee80211_cfg.c
index 11cfcf5..711754e 100644
=2D-- a/net/mac80211/ieee80211_cfg.c
+++ b/net/mac80211/ieee80211_cfg.c
@@ -12,24 +12,11 @@
 #include "ieee80211_i.h"
 #include "ieee80211_cfg.h"
=20
=2D/* copied from ieee80211_sysfs.c for now ... */
=2Dstatic inline int rtnl_lock_local(struct ieee80211_local *local)
=2D{
=2D	rtnl_lock();
=2D	if (unlikely(local->reg_state !=3D IEEE80211_DEV_REGISTERED)) {
=2D		rtnl_unlock();
=2D		return -ENODEV;
=2D	}
=2D	return 0;
=2D}
=2D
=2D
 static int ieee80211_add_iface(struct wiphy *wiphy, char *name,
 			       unsigned int type)
 {
 	struct ieee80211_local *local =3D wiphy_priv(wiphy);
=2D	struct net_device *new_dev;
=2D	int res, itype;
+	int itype;
=20
 	switch (type) {
 	case NL80211_IFTYPE_UNSPECIFIED:
@@ -54,34 +41,23 @@ static int ieee80211_add_iface(struct wiphy *wiphy, cha=
r *name,
 		return -EINVAL;
 	}
=20
=2D	res =3D rtnl_lock_local(local);
=2D	if (res)
=2D		return res;
=2D
=2D	res =3D ieee80211_if_add(local->mdev, name, 0, &new_dev);
=2D	if (res =3D=3D 0)
=2D		ieee80211_if_set_type(new_dev, itype);
=2D	rtnl_unlock();
=2D	return res;
+	return ieee80211_if_add(local->mdev, name, NULL, itype);
 }
=20
 static int ieee80211_del_iface(struct wiphy *wiphy, int ifindex)
 {
 	struct ieee80211_local *local =3D wiphy_priv(wiphy);
=2D	int res;
 	struct net_device *dev;
 	char *name;
=20
=2D	res =3D rtnl_lock_local(local);
=2D	if (res)
=2D		return res;
 	dev =3D dev_get_by_index(ifindex);
+	if (!dev)
+		return 0;
+
 	name =3D dev->name;
 	dev_put(dev);
=20
=2D	res =3D ieee80211_if_remove(local->mdev, name, -1);
=2D	rtnl_unlock();
=2D	return res;
+	return ieee80211_if_remove(local->mdev, name, -1);
 }
=20
 struct cfg80211_ops mac80211_config_ops =3D {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a756b18..2bf26cf 100644
=2D-- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -495,7 +495,7 @@ struct ieee80211_local {
 	ieee80211_rx_handler *rx_handlers;
 	ieee80211_tx_handler *tx_handlers;
=20
=2D	spinlock_t sub_if_lock; /* mutex for STA data structures */
+	rwlock_t sub_if_lock; /* protects sub_if_list */
 	struct list_head sub_if_list;
 	int sta_scanning;
 	int scan_channel_idx;
@@ -758,7 +758,6 @@ void ieee80211_tx_set_iswep(struct ieee80211_txrx_data =
*tx);
 int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr);
 void ieee80211_if_setup(struct net_device *dev);
 void ieee80211_if_mgmt_setup(struct net_device *dev);
=2Dvoid ieee80211_if_shutdown(struct net_device *dev);
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 				 const char *name);
 struct net_device_stats *ieee80211_dev_stats(struct net_device *dev);
@@ -835,15 +834,13 @@ int ieee80211_sta_disassociate(struct net_device *dev=
, u16 reason);
=20
 /* ieee80211_iface.c */
 int ieee80211_if_add(struct net_device *dev, const char *name,
=2D		     int format, struct net_device **new_dev);
+		     struct net_device **new_dev, int type);
 void ieee80211_if_set_type(struct net_device *dev, int type);
 void ieee80211_if_reinit(struct net_device *dev);
 void __ieee80211_if_del(struct ieee80211_local *local,
 			struct ieee80211_sub_if_data *sdata);
=2Dvoid ieee80211_if_del(struct net_device *dev);
 int ieee80211_if_remove(struct net_device *dev, const char *name, int id);
 void ieee80211_if_free(struct net_device *dev);
=2Dvoid ieee80211_if_flush(struct net_device *dev);
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata);
 int ieee80211_if_add_mgmt(struct ieee80211_local *local);
 void ieee80211_if_del_mgmt(struct ieee80211_local *local);
diff --git a/net/mac80211/ieee80211_iface.c b/net/mac80211/ieee80211_iface.c
index c97b45c..96346b9 100644
=2D-- a/net/mac80211/ieee80211_iface.c
+++ b/net/mac80211/ieee80211_iface.c
@@ -36,33 +36,19 @@ static void ieee80211_if_sdata_deinit(struct ieee80211_=
sub_if_data *sdata)
 	}
 }
=20
=2D/* Must be called with rtnl lock held. */
 int ieee80211_if_add(struct net_device *dev, const char *name,
=2D		     int format, struct net_device **new_dev)
+		     struct net_device **new_dev, int type)
 {
 	struct net_device *ndev;
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata =3D NULL;
 	int ret;
=20
=2D	ASSERT_RTNL();
=2D	ndev =3D *new_dev =3D alloc_netdev(sizeof(struct ieee80211_sub_if_data),
=2D				       "", ieee80211_if_setup);
+	ndev =3D alloc_netdev(sizeof(struct ieee80211_sub_if_data),
+			    name, ieee80211_if_setup);
 	if (!ndev)
 		return -ENOMEM;
=20
=2D	if (*name =3D=3D '\0') {
=2D		snprintf(ndev->name, IFNAMSIZ, "%s.%%d", dev->name);
=2D		format =3D 1;
=2D	}
=2D
=2D	if (format) {
=2D		ret =3D dev_alloc_name(ndev, name);
=2D		if (ret < 0)
=2D			goto fail;
=2D	} else
=2D		snprintf(ndev->name, IFNAMSIZ, "%s", name);
=2D
 	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 	ndev->base_addr =3D dev->base_addr;
 	ndev->irq =3D dev->irq;
@@ -78,19 +64,32 @@ int ieee80211_if_add(struct net_device *dev, const char=
 *name,
 	sdata->local =3D local;
 	ieee80211_if_sdata_init(sdata);
=20
=2D	ret =3D register_netdevice(ndev);
+	ret =3D register_netdev(ndev);
 	if (ret)
 		goto fail;
=20
 	ieee80211_debugfs_add_netdev(sdata);
+	ieee80211_if_set_type(ndev, type);
+
+	write_lock_bh(&local->sub_if_lock);
+	if (unlikely(local->reg_state =3D=3D IEEE80211_DEV_UNREGISTERED)) {
+		write_unlock_bh(&local->sub_if_lock);
+		__ieee80211_if_del(local, sdata);
+		return -ENODEV;
+	}
 	list_add(&sdata->list, &local->sub_if_list);
+	if (new_dev) {
+		dev_hold(ndev);
+		*new_dev =3D ndev;
+	}
+	write_unlock_bh(&local->sub_if_lock);
+
 	ieee80211_update_default_wep_only(local);
=20
 	return 0;
=20
 fail:
 	free_netdev(ndev);
=2D	*new_dev =3D NULL;
 	return ret;
 }
=20
@@ -100,15 +99,10 @@ int ieee80211_if_add_mgmt(struct ieee80211_local *loca=
l)
 	struct ieee80211_sub_if_data *nsdata;
 	int ret;
=20
=2D	ASSERT_RTNL();
=2D
=2D	ndev =3D alloc_netdev(sizeof(struct ieee80211_sub_if_data), "",
+	ndev =3D alloc_netdev(sizeof(struct ieee80211_sub_if_data), "wmgmt%d",
 			    ieee80211_if_mgmt_setup);
 	if (!ndev)
 		return -ENOMEM;
=2D	ret =3D dev_alloc_name(ndev, "wmgmt%d");
=2D	if (ret < 0)
=2D		goto fail;
=20
 	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
@@ -121,7 +115,7 @@ int ieee80211_if_add_mgmt(struct ieee80211_local *local)
 	nsdata->local =3D local;
 	ieee80211_if_sdata_init(nsdata);
=20
=2D	ret =3D register_netdevice(ndev);
+	ret =3D register_netdev(ndev);
 	if (ret)
 		goto fail;
=20
@@ -141,11 +135,10 @@ void ieee80211_if_del_mgmt(struct ieee80211_local *lo=
cal)
 {
 	struct net_device *apdev;
=20
=2D	ASSERT_RTNL();
 	apdev =3D local->apdev;
 	ieee80211_debugfs_remove_netdev(IEEE80211_DEV_TO_SUB_IF(apdev));
 	local->apdev =3D NULL;
=2D	unregister_netdevice(apdev);
+	unregister_netdev(apdev);
 }
=20
 void ieee80211_if_set_type(struct net_device *dev, int type)
@@ -203,7 +196,6 @@ void ieee80211_if_set_type(struct net_device *dev, int =
type)
 	ieee80211_update_default_wep_only(local);
 }
=20
=2D/* Must be called with rtnl lock held. */
 void ieee80211_if_reinit(struct net_device *dev)
 {
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
@@ -211,7 +203,6 @@ void ieee80211_if_reinit(struct net_device *dev)
 	struct sta_info *sta;
 	int i;
=20
=2D	ASSERT_RTNL();
 	ieee80211_if_sdata_deinit(sdata);
 	for (i =3D 0; i < NUM_DEFAULT_KEYS; i++) {
 		if (!sdata->keys[i])
@@ -233,16 +224,22 @@ void ieee80211_if_reinit(struct net_device *dev)
 		/* Remove all virtual interfaces that use this BSS
 		 * as their sdata->bss */
 		struct ieee80211_sub_if_data *tsdata, *n;
+		LIST_HEAD(tmp_list);
=20
+		write_lock_bh(&local->sub_if_lock);
 		list_for_each_entry_safe(tsdata, n, &local->sub_if_list, list) {
 			if (tsdata !=3D sdata && tsdata->bss =3D=3D &sdata->u.ap) {
 				printk(KERN_DEBUG "%s: removing virtual "
 				       "interface %s because its BSS interface"
 				       " is being removed\n",
 				       sdata->dev->name, tsdata->dev->name);
=2D				__ieee80211_if_del(local, tsdata);
+				list_move_tail(&tsdata->list, &tmp_list);
 			}
 		}
+		write_unlock_bh(&local->sub_if_lock);
+
+		list_for_each_entry_safe(tsdata, n, &tmp_list, list)
+			__ieee80211_if_del(local, tsdata);
=20
 		kfree(sdata->u.ap.beacon_head);
 		kfree(sdata->u.ap.beacon_tail);
@@ -296,36 +293,35 @@ void ieee80211_if_reinit(struct net_device *dev)
 	ieee80211_if_sdata_init(sdata);
 }
=20
=2D/* Must be called with rtnl lock held. */
 void __ieee80211_if_del(struct ieee80211_local *local,
 			struct ieee80211_sub_if_data *sdata)
 {
 	struct net_device *dev =3D sdata->dev;
=20
=2D	list_del(&sdata->list);
 	ieee80211_debugfs_remove_netdev(sdata);
=2D	unregister_netdevice(dev);
+	unregister_netdev(dev);
 	/* Except master interface, the net_device will be freed by
 	 * net_device->destructor (i. e. ieee80211_if_free). */
 }
=20
=2D/* Must be called with rtnl lock held. */
 int ieee80211_if_remove(struct net_device *dev, const char *name, int id)
 {
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata, *n;
=20
=2D	ASSERT_RTNL();
=2D
+	write_lock_bh(&local->sub_if_lock);
 	list_for_each_entry_safe(sdata, n, &local->sub_if_list, list) {
 		if ((sdata->type =3D=3D id || id =3D=3D -1) &&
 		    strcmp(name, sdata->dev->name) =3D=3D 0 &&
 		    sdata->dev !=3D local->mdev) {
+			list_del(&sdata->list);
+			write_unlock_bh(&local->sub_if_lock);
 			__ieee80211_if_del(local, sdata);
 			ieee80211_update_default_wep_only(local);
 			return 0;
 		}
 	}
+	write_unlock_bh(&local->sub_if_lock);
 	return -ENODEV;
 }
=20
@@ -339,28 +335,3 @@ void ieee80211_if_free(struct net_device *dev)
 	ieee80211_if_sdata_deinit(sdata);
 	free_netdev(dev);
 }
=2D
=2D/* Must be called with rtnl lock held. */
=2Dvoid ieee80211_if_flush(struct net_device *dev)
=2D{
=2D	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
=2D	struct ieee80211_sub_if_data *sdata, *n;
=2D
=2D	ASSERT_RTNL();
=2D	list_for_each_entry_safe(sdata, n, &local->sub_if_list, list) {
=2D		__ieee80211_if_del(local, sdata);
=2D	}
=2D}
=2D
=2Dvoid ieee80211_if_del(struct net_device *dev)
=2D{
=2D	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
=2D	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
=2D
=2D	rtnl_lock();
=2D	if (sdata->type =3D=3D IEEE80211_IF_TYPE_MGMT)
=2D		ieee80211_if_del_mgmt(local);
=2D	else
=2D		__ieee80211_if_del(local, sdata);
=2D	rtnl_unlock();
=2D}
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 2ff762d..17dbf05 100644
=2D-- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -1003,23 +1003,32 @@ static int ieee80211_ioctl_add_if(struct net_device=
 *dev,
 		if (left < sizeof(struct hostapd_if_wds))
 			return -EPROTO;
=20
=2D		res =3D ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
+		res =3D ieee80211_if_add(dev, param->u.if_info.name, &new_dev,
+				       IEEE80211_IF_TYPE_WDS);
 		if (res)
 			return res;
=2D		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_WDS);
 		res =3D ieee80211_if_update_wds(new_dev, wds->remote_addr);
=2D		if (res)
=2D			__ieee80211_if_del(wdev_priv(dev->ieee80211_ptr),
=2D					   IEEE80211_DEV_TO_SUB_IF(new_dev));
+		if (unlikely(res)) {
+			struct ieee80211_local *local =3D
+				wdev_priv(dev->ieee80211_ptr);
+			struct ieee80211_sub_if_data *sdata =3D=20
+				IEEE80211_DEV_TO_SUB_IF(new_dev);
+			write_lock_bh(&local->sub_if_lock);
+			list_del(&sdata->list);
+			dev_put(new_dev);
+			write_unlock_bh(&local->sub_if_lock);
+			__ieee80211_if_del(local, sdata);
+		} else
+			dev_put(new_dev);
 		return res;
 	case HOSTAP_IF_VLAN:
 		if (left < sizeof(struct hostapd_if_vlan))
 			return -EPROTO;
=20
=2D		res =3D ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
+		res =3D ieee80211_if_add(dev, param->u.if_info.name, NULL,
+				       IEEE80211_IF_TYPE_VLAN);
 		if (res)
 			return res;
=2D		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_VLAN);
 #if 0
 		res =3D ieee80211_if_update_vlan(new_dev, vlan->id);
 		if (res)
@@ -1033,21 +1042,22 @@ static int ieee80211_ioctl_add_if(struct net_device=
 *dev,
 		if (left < sizeof(struct hostapd_if_bss))
 			return -EPROTO;
=20
=2D		res =3D ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
+		res =3D ieee80211_if_add(dev, param->u.if_info.name, &new_dev,
+				       IEEE80211_IF_TYPE_AP);
 		if (res)
 			return res;
=2D		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_AP);
+
+		// BUG: somewhat racey.. hostap should just set dev_addr itself
 		memcpy(new_dev->dev_addr, bss->bssid, ETH_ALEN);
+		dev_put(new_dev);
 		return 0;
 	case HOSTAP_IF_STA:
 		if (left < sizeof(struct hostapd_if_sta))
 			return -EPROTO;
=20
=2D		res =3D ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
=2D		if (res)
=2D			return res;
=2D		ieee80211_if_set_type(new_dev, IEEE80211_IF_TYPE_STA);
=2D		return 0;
+		res =3D ieee80211_if_add(dev, param->u.if_info.name, NULL,
+				       IEEE80211_IF_TYPE_STA);
+		return res;
 	default:
 		return -EINVAL;
 	}
@@ -1093,36 +1103,34 @@ static int ieee80211_ioctl_update_if(struct net_dev=
ice *dev,
 		struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
 		struct net_device *wds_dev =3D NULL;
 		struct ieee80211_sub_if_data *sdata;
+		int ret;
=20
 		if (left < sizeof(struct ieee80211_if_wds))
 			return -EPROTO;
=20
+		read_lock(&local->sub_if_lock);
 		list_for_each_entry(sdata, &local->sub_if_list, list) {
 			if (strcmp(param->u.if_info.name,
 				   sdata->dev->name) =3D=3D 0) {
 				wds_dev =3D sdata->dev;
+				dev_hold(wds_dev);
 				break;
 			}
 		}
+		read_unlock(&local->sub_if_lock);
=20
 		if (!wds_dev || sdata->type !=3D IEEE80211_IF_TYPE_WDS)
 			return -ENODEV;
=20
=2D		return ieee80211_if_update_wds(wds_dev, wds->remote_addr);
+		ret =3D ieee80211_if_update_wds(wds_dev, wds->remote_addr);
+		dev_put(wds_dev);
+		return ret;
 	} else {
 		return -EOPNOTSUPP;
 	}
 }
=20
=20
=2Dstatic int ieee80211_ioctl_flush_ifs(struct net_device *dev,
=2D				     struct prism2_hostapd_param *param)
=2D{
=2D	ieee80211_if_flush(dev);
=2D	return 0;
=2D}
=2D
=2D
 static int ieee80211_ioctl_scan_req(struct net_device *dev,
 				    struct prism2_hostapd_param *param,
 				    int param_len)
@@ -1512,9 +1520,6 @@ static int ieee80211_ioctl_priv_hostapd(struct net_de=
vice *dev,
 	case PRISM2_HOSTAPD_MLME:
 		ret =3D ieee80211_ioctl_mlme(dev, param);
 		break;
=2D	case PRISM2_HOSTAPD_FLUSH_IFS:
=2D		ret =3D ieee80211_ioctl_flush_ifs(dev, param);
=2D		break;
 	case PRISM2_HOSTAPD_SET_RADAR_PARAMS:
 		ret =3D ieee80211_ioctl_set_radar_params(dev, param);
 		break;
@@ -2239,6 +2244,7 @@ static int ieee80211_ioctl_clear_keys(struct net_devi=
ce *dev)
 	struct sta_info *sta;
=20
 	memset(addr, 0xff, ETH_ALEN);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		for (i =3D 0; i < NUM_DEFAULT_KEYS; i++) {
 			keyconf =3D NULL;
@@ -2256,6 +2262,7 @@ static int ieee80211_ioctl_clear_keys(struct net_devi=
ce *dev)
 		}
 		sdata->default_key =3D NULL;
 	}
+	read_unlock(&local->sub_if_lock);
=20
 	spin_lock_bh(&local->sta_lock);
 	list_for_each_entry(sta, &local->sta_list, list) {
@@ -2388,6 +2395,7 @@ static int ieee80211_ioctl_default_wep_only(struct ie=
ee80211_local *local,
 	struct ieee80211_sub_if_data *sdata;
=20
 	local->default_wep_only =3D value;
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list)
 		for (i =3D 0; i < NUM_DEFAULT_KEYS; i++)
 			if (value)
@@ -2396,6 +2404,7 @@ static int ieee80211_ioctl_default_wep_only(struct ie=
ee80211_local *local,
 			else
 				ieee80211_key_disable_hwaccel(local,
 							      sdata->keys[i]);
+	read_unlock(&local->sub_if_lock);
=20
 	return 0;
 }
@@ -2406,7 +2415,7 @@ void ieee80211_update_default_wep_only(struct ieee802=
11_local *local)
 	int i =3D 0;
 	struct ieee80211_sub_if_data *sdata;
=20
=2D	spin_lock_bh(&local->sub_if_lock);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
=20
 		if (sdata->dev =3D=3D local->mdev)
@@ -2415,7 +2424,7 @@ void ieee80211_update_default_wep_only(struct ieee802=
11_local *local)
 		/* If there is an AP interface then depend on userspace to
 		   set default_wep_only correctly. */
 		if (sdata->type =3D=3D IEEE80211_IF_TYPE_AP) {
=2D			spin_unlock_bh(&local->sub_if_lock);
+			read_unlock(&local->sub_if_lock);
 			return;
 		}
=20
@@ -2427,7 +2436,7 @@ void ieee80211_update_default_wep_only(struct ieee802=
11_local *local)
 	else
 		ieee80211_ioctl_default_wep_only(local, 0);
=20
=2D	spin_unlock_bh(&local->sub_if_lock);
+	read_unlock(&local->sub_if_lock);
 }
=20
=20
@@ -3287,4 +3296,5 @@ const struct iw_handler_def ieee80211_iw_handler_def =
=3D
 	.private	=3D (iw_handler *) ieee80211_private_handler,
 	.private_args	=3D (struct iw_priv_args *) ieee80211_ioctl_priv,
 	.get_wireless_stats =3D ieee80211_get_wireless_stats,
+	.no_locking	=3D 1,
 };
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index c41f3d3..a6ea77f 100644
=2D-- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2728,7 +2728,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 	memset(&wrqu, 0, sizeof(wrqu));
 	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
=20
=2D	spin_lock_bh(&local->sub_if_lock);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA) {
 			if (sdata->u.sta.associated)
@@ -2737,7 +2737,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 		}
 		netif_wake_queue(sdata->dev);
 	}
=2D	spin_unlock_bh(&local->sub_if_lock);
+	read_unlock(&local->sub_if_lock);
=20
 	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type =3D=3D IEEE80211_IF_TYPE_IBSS) {
@@ -2873,14 +2873,14 @@ static int ieee80211_sta_start_scan(struct net_devi=
ce *dev,
=20
 	local->sta_scanning =3D 1;
=20
=2D	spin_lock_bh(&local->sub_if_lock);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		netif_stop_queue(sdata->dev);
 		if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA &&
 		    sdata->u.sta.associated)
 			ieee80211_send_nullfunc(local, sdata, 1);
 	}
=2D	spin_unlock_bh(&local->sub_if_lock);
+	read_unlock(&local->sub_if_lock);
=20
 	if (ssid) {
 		local->scan_ssid_len =3D ssid_len;
@@ -3124,7 +3124,6 @@ struct sta_info * ieee80211_ibss_add_sta(struct net_d=
evice *dev,
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata =3D NULL;
=2D	struct net_device *sta_dev =3D NULL;
=20
 	/* TODO: Could consider removing the least recently used entry and
 	 * allow new one to be added. */
@@ -3136,26 +3135,13 @@ struct sta_info * ieee80211_ibss_add_sta(struct net=
_device *dev,
 		return NULL;
 	}
=20
=2D	spin_lock_bh(&local->sub_if_lock);
=2D	list_for_each_entry(sdata, &local->sub_if_list, list)
=2D		if (sdata->type =3D=3D IEEE80211_IF_TYPE_IBSS &&
=2D		    memcmp(bssid, sdata->u.sta.bssid, ETH_ALEN) =3D=3D 0) {
=2D			sta_dev =3D sdata->dev;
=2D			break;
=2D		}
=2D	spin_unlock_bh(&local->sub_if_lock);
=2D
=2D	if (!sta_dev)
=2D		return NULL;
=2D
 	printk(KERN_DEBUG "%s: Adding new IBSS station " MAC_FMT " (dev=3D%s)\n",
=2D	       dev->name, MAC_ARG(addr), sta_dev->name);
+	       local->mdev->name, MAC_ARG(addr), dev->name);
=20
 	sta =3D sta_info_add(local, dev, addr, GFP_ATOMIC);
 	if (!sta)
 		return NULL;
=20
=2D	sta->dev =3D sta_dev;
 	sta->supp_rates =3D sdata->u.sta.supp_rates_bits;
=20
 	rate_control_rate_init(sta, local);

--Boundary-01=_qjmJGc8n5mka6fO--

--nextPart8176372.RSa72DYioP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGJmjuT3Oqt9AH4aERAsQzAKCQY+9HpO+AqlhmnxB+DZNMKDhBcQCgzU9z
FN4L5TTUT4WItBfFXCsypes=
=kDdw
-----END PGP SIGNATURE-----

--nextPart8176372.RSa72DYioP--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

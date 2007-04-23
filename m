Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:35499 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754379AbXDWWY2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 18:24:28 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 03/13] mac80211: fix virtual interface related locking
Date: Mon, 23 Apr 2007 18:20:21 -0400
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net> <20070423224116.03d99954@griffin.suse.cz> <200704231655.28314.flamingice@sourmilk.net>
In-Reply-To: <200704231655.28314.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1678019.aziMr8bVT6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704231820.25685.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1678019.aziMr8bVT6
Content-Type: multipart/mixed;
  boundary="Boundary-01=_mETLGg4YeHKP8db"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_mETLGg4YeHKP8db
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Updated patch attached. I did not add documentation about set_multicast_lis=
t=20
since documenting what conditions callbacks are called with is an issue=20
separate from this patch. I don't think I changed it much in this patch. Al=
so=20
did not remove the dead code since it never compiled in the first place so =
I=20
didn't make it any more broken. That can go in another patch. The random RT=
NL=20
changes were removed, one trailing space identified by Andy Green removed, =
an=20
unnecessary dev_hold/dev_put was removed, and the nested locking in=20
ieee80211_ioctl.c was removed.

Thanks,
=2DMichael Wu

--Boundary-01=_mETLGg4YeHKP8db
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="06-fix-subif-locking.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="06-fix-subif-locking.diff"

mac80211: fix virtual interface related locking

=46rom: Michael Wu <flamingice@sourmilk.net>

This converts sub_if_lock to a rw lock and makes all code touching
sub_if_list use it, grabs mdev's tx lock in set_multicast_list to
synchronize multicast configuration, and simplifies some related code.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/mac80211/ieee80211.c       |   50 +++++++++++++++++++--------
 net/mac80211/ieee80211_cfg.c   |   15 +++-----
 net/mac80211/ieee80211_i.h     |    7 +---
 net/mac80211/ieee80211_iface.c |   75 +++++++++++++++++-------------------=
=2D---
 net/mac80211/ieee80211_ioctl.c |   58 +++++++++++++++----------------
 net/mac80211/ieee80211_sta.c   |   24 +++----------
 6 files changed, 109 insertions(+), 120 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index 51ad624..934ad38 100644
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
@@ -2220,7 +2224,7 @@ static struct net_device_stats *ieee80211_get_stats(s=
truct net_device *dev)
 	return &(sdata->stats);
 }
=20
=2Dvoid ieee80211_if_shutdown(struct net_device *dev)
+static void ieee80211_if_shutdown(struct net_device *dev)
 {
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
@@ -2269,6 +2273,7 @@ static int ieee80211_master_open(struct net_device *d=
ev)
 	struct ieee80211_sub_if_data *sdata;
 	int res =3D -EOPNOTSUPP;
=20
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		if (sdata->dev !=3D dev && netif_running(sdata->dev)) {
 			res =3D 0;
@@ -2276,6 +2281,7 @@ static int ieee80211_master_open(struct net_device *d=
ev)
 			break;
 		}
 	}
+	read_unlock(&local->sub_if_lock);
 	return res;
 }
=20
@@ -2285,10 +2291,14 @@ static int ieee80211_master_stop(struct net_device =
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
@@ -2346,14 +2356,18 @@ static int ieee80211_open(struct net_device *dev)
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
@@ -3871,6 +3885,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct s=
k_buff *skb,
 		struct sk_buff *skb_new;
 		u8 *bssid =3D ieee80211_get_bssid(hdr, skb->len - radiotap_len);
=20
+		read_lock(&local->sub_if_lock);
 		list_for_each_entry(sdata, &local->sub_if_list, list) {
 			rx.u.rx.ra_match =3D 1;
 			switch (sdata->type) {
@@ -3906,10 +3921,9 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct =
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
@@ -3964,6 +3978,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct s=
k_buff *skb,
 						     &rx, sta);
 		} else
 			dev_kfree_skb(skb);
+		read_unlock(&local->sub_if_lock);
 	}
=20
   end:
@@ -4108,11 +4123,13 @@ static void ieee80211_stat_refresh(unsigned long da=
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
@@ -4665,7 +4682,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_d=
ata_len,
=20
 	INIT_LIST_HEAD(&local->modes_list);
=20
=2D	spin_lock_init(&local->sub_if_lock);
+	rwlock_init(&local->sub_if_lock);
 	INIT_LIST_HEAD(&local->sub_if_list);
=20
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_sta_scan_work);
@@ -4708,7 +4725,6 @@ EXPORT_SYMBOL(ieee80211_alloc_hw);
 int ieee80211_register_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local =3D hw_to_local(hw);
=2D	struct net_device *sta_dev;
 	int result;
=20
 	result =3D wiphy_register(local->hw.wiphy);
@@ -4763,13 +4779,14 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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
 	rtnl_unlock();
@@ -4829,6 +4846,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local =3D hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata, *tmp;
+	struct list_head tmp_list;
 	int i;
=20
 	tasklet_kill(&local->tx_pending_tasklet);
@@ -4842,7 +4860,11 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	if (local->apdev)
 		ieee80211_if_del_mgmt(local);
=20
=2D	list_for_each_entry_safe(sdata, tmp, &local->sub_if_list, list)
+	write_lock_bh(&local->sub_if_lock);
+	list_replace_init(&local->sub_if_list, &tmp_list);
+	write_unlock_bh(&local->sub_if_lock);
+
+	list_for_each_entry_safe(sdata, tmp, &tmp_list, list)
 		__ieee80211_if_del(local, sdata);
=20
 	rtnl_unlock();
diff --git a/net/mac80211/ieee80211_cfg.c b/net/mac80211/ieee80211_cfg.c
index e370b4b..0069826 100644
=2D-- a/net/mac80211/ieee80211_cfg.c
+++ b/net/mac80211/ieee80211_cfg.c
@@ -16,8 +16,7 @@ static int ieee80211_add_iface(struct wiphy *wiphy, char =
*name,
 			       unsigned int type)
 {
 	struct ieee80211_local *local =3D wiphy_priv(wiphy);
=2D	struct net_device *new_dev;
=2D	int res, itype;
+	int itype;
=20
 	if (unlikely(local->reg_state !=3D IEEE80211_DEV_REGISTERED))
 		return -ENODEV;
@@ -45,16 +44,12 @@ static int ieee80211_add_iface(struct wiphy *wiphy, cha=
r *name,
 		return -EINVAL;
 	}
=20
=2D	res =3D ieee80211_if_add(local->mdev, name, 0, &new_dev);
=2D	if (res =3D=3D 0)
=2D		ieee80211_if_set_type(new_dev, itype);
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
@@ -62,11 +57,13 @@ static int ieee80211_del_iface(struct wiphy *wiphy, int=
 ifindex)
 		return -ENODEV;
=20
 	dev =3D dev_get_by_index(ifindex);
+	if (!dev)
+		return 0;
+
 	name =3D dev->name;
 	dev_put(dev);
=20
=2D	res =3D ieee80211_if_remove(local->mdev, name, -1);
=2D	return res;
+	return ieee80211_if_remove(local->mdev, name, -1);
 }
=20
 struct cfg80211_ops mac80211_config_ops =3D {
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f6d389b..6b3e1c5 100644
=2D-- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -490,7 +490,7 @@ struct ieee80211_local {
 	ieee80211_rx_handler *rx_handlers;
 	ieee80211_tx_handler *tx_handlers;
=20
=2D	spinlock_t sub_if_lock; /* mutex for STA data structures */
+	rwlock_t sub_if_lock; /* protects sub_if_list */
 	struct list_head sub_if_list;
 	int sta_scanning;
 	int scan_channel_idx;
@@ -753,7 +753,6 @@ void ieee80211_tx_set_iswep(struct ieee80211_txrx_data =
*tx);
 int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr);
 void ieee80211_if_setup(struct net_device *dev);
 void ieee80211_if_mgmt_setup(struct net_device *dev);
=2Dvoid ieee80211_if_shutdown(struct net_device *dev);
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 				 const char *name);
 struct net_device_stats *ieee80211_dev_stats(struct net_device *dev);
@@ -830,15 +829,13 @@ int ieee80211_sta_disassociate(struct net_device *dev=
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
index 495177b..719bc21 100644
=2D-- a/net/mac80211/ieee80211_iface.c
+++ b/net/mac80211/ieee80211_iface.c
@@ -38,7 +38,7 @@ static void ieee80211_if_sdata_deinit(struct ieee80211_su=
b_if_data *sdata)
=20
 /* Must be called with rtnl lock held. */
 int ieee80211_if_add(struct net_device *dev, const char *name,
=2D		     int format, struct net_device **new_dev)
+		     struct net_device **new_dev, int type)
 {
 	struct net_device *ndev;
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
@@ -46,22 +46,14 @@ int ieee80211_if_add(struct net_device *dev, const char=
 *name,
 	int ret;
=20
 	ASSERT_RTNL();
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
+	ret =3D dev_alloc_name(ndev, ndev->name);
+	if (ret < 0)
+		goto fail;
=20
 	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
 	ndev->base_addr =3D dev->base_addr;
@@ -83,14 +75,25 @@ int ieee80211_if_add(struct net_device *dev, const char=
 *name,
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
+	if (new_dev)
+		*new_dev =3D ndev;
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
@@ -102,11 +105,11 @@ int ieee80211_if_add_mgmt(struct ieee80211_local *loc=
al)
=20
 	ASSERT_RTNL();
=20
=2D	ndev =3D alloc_netdev(sizeof(struct ieee80211_sub_if_data), "",
+	ndev =3D alloc_netdev(sizeof(struct ieee80211_sub_if_data), "wmgmt%d",
 			    ieee80211_if_mgmt_setup);
 	if (!ndev)
 		return -ENOMEM;
=2D	ret =3D dev_alloc_name(ndev, "wmgmt%d");
+	ret =3D dev_alloc_name(ndev, ndev->name);
 	if (ret < 0)
 		goto fail;
=20
@@ -232,16 +235,22 @@ void ieee80211_if_reinit(struct net_device *dev)
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
@@ -301,7 +310,6 @@ void __ieee80211_if_del(struct ieee80211_local *local,
 {
 	struct net_device *dev =3D sdata->dev;
=20
=2D	list_del(&sdata->list);
 	ieee80211_debugfs_remove_netdev(sdata);
 	unregister_netdevice(dev);
 	/* Except master interface, the net_device will be freed by
@@ -316,15 +324,19 @@ int ieee80211_if_remove(struct net_device *dev, const=
 char *name, int id)
=20
 	ASSERT_RTNL();
=20
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
@@ -338,28 +350,3 @@ void ieee80211_if_free(struct net_device *dev)
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
index 2ff762d..91bc633 100644
=2D-- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -1003,23 +1003,30 @@ static int ieee80211_ioctl_add_if(struct net_device=
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
+			struct ieee80211_sub_if_data *sdata =3D
+				IEEE80211_DEV_TO_SUB_IF(new_dev);
+			write_lock_bh(&local->sub_if_lock);
+			list_del(&sdata->list);
+			write_unlock_bh(&local->sub_if_lock);
+			__ieee80211_if_del(local, sdata);
+		}
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
@@ -1033,21 +1040,19 @@ static int ieee80211_ioctl_add_if(struct net_device=
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
 		memcpy(new_dev->dev_addr, bss->bssid, ETH_ALEN);
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
@@ -1097,6 +1102,7 @@ static int ieee80211_ioctl_update_if(struct net_devic=
e *dev,
 		if (left < sizeof(struct ieee80211_if_wds))
 			return -EPROTO;
=20
+		read_lock(&local->sub_if_lock);
 		list_for_each_entry(sdata, &local->sub_if_list, list) {
 			if (strcmp(param->u.if_info.name,
 				   sdata->dev->name) =3D=3D 0) {
@@ -1104,6 +1110,7 @@ static int ieee80211_ioctl_update_if(struct net_devic=
e *dev,
 				break;
 			}
 		}
+		read_unlock(&local->sub_if_lock);
=20
 		if (!wds_dev || sdata->type !=3D IEEE80211_IF_TYPE_WDS)
 			return -ENODEV;
@@ -1115,14 +1122,6 @@ static int ieee80211_ioctl_update_if(struct net_devi=
ce *dev,
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
@@ -1512,9 +1511,6 @@ static int ieee80211_ioctl_priv_hostapd(struct net_de=
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
@@ -2239,6 +2235,7 @@ static int ieee80211_ioctl_clear_keys(struct net_devi=
ce *dev)
 	struct sta_info *sta;
=20
 	memset(addr, 0xff, ETH_ALEN);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		for (i =3D 0; i < NUM_DEFAULT_KEYS; i++) {
 			keyconf =3D NULL;
@@ -2256,6 +2253,7 @@ static int ieee80211_ioctl_clear_keys(struct net_devi=
ce *dev)
 		}
 		sdata->default_key =3D NULL;
 	}
+	read_unlock(&local->sub_if_lock);
=20
 	spin_lock_bh(&local->sta_lock);
 	list_for_each_entry(sta, &local->sta_list, list) {
@@ -2388,6 +2386,7 @@ static int ieee80211_ioctl_default_wep_only(struct ie=
ee80211_local *local,
 	struct ieee80211_sub_if_data *sdata;
=20
 	local->default_wep_only =3D value;
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list)
 		for (i =3D 0; i < NUM_DEFAULT_KEYS; i++)
 			if (value)
@@ -2396,6 +2395,7 @@ static int ieee80211_ioctl_default_wep_only(struct ie=
ee80211_local *local,
 			else
 				ieee80211_key_disable_hwaccel(local,
 							      sdata->keys[i]);
+	read_unlock(&local->sub_if_lock);
=20
 	return 0;
 }
@@ -2406,7 +2406,7 @@ void ieee80211_update_default_wep_only(struct ieee802=
11_local *local)
 	int i =3D 0;
 	struct ieee80211_sub_if_data *sdata;
=20
=2D	spin_lock_bh(&local->sub_if_lock);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
=20
 		if (sdata->dev =3D=3D local->mdev)
@@ -2415,19 +2415,19 @@ void ieee80211_update_default_wep_only(struct ieee8=
0211_local *local)
 		/* If there is an AP interface then depend on userspace to
 		   set default_wep_only correctly. */
 		if (sdata->type =3D=3D IEEE80211_IF_TYPE_AP) {
=2D			spin_unlock_bh(&local->sub_if_lock);
+			read_unlock(&local->sub_if_lock);
 			return;
 		}
=20
 		i++;
 	}
=20
+	read_unlock(&local->sub_if_lock);
+
 	if (i <=3D 1)
 		ieee80211_ioctl_default_wep_only(local, 1);
 	else
 		ieee80211_ioctl_default_wep_only(local, 0);
=2D
=2D	spin_unlock_bh(&local->sub_if_lock);
 }
=20
=20
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 0b01800..3d16ed8 100644
=2D-- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -2569,7 +2569,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 	memset(&wrqu, 0, sizeof(wrqu));
 	wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
=20
=2D	spin_lock_bh(&local->sub_if_lock);
+	read_lock(&local->sub_if_lock);
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
 		if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA) {
 			if (sdata->u.sta.associated)
@@ -2578,7 +2578,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 		}
 		netif_wake_queue(sdata->dev);
 	}
=2D	spin_unlock_bh(&local->sub_if_lock);
+	read_unlock(&local->sub_if_lock);
=20
 	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type =3D=3D IEEE80211_IF_TYPE_IBSS) {
@@ -2714,14 +2714,14 @@ static int ieee80211_sta_start_scan(struct net_devi=
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
@@ -2965,7 +2965,6 @@ struct sta_info * ieee80211_ibss_add_sta(struct net_d=
evice *dev,
 	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata =3D NULL;
=2D	struct net_device *sta_dev =3D NULL;
=20
 	/* TODO: Could consider removing the least recently used entry and
 	 * allow new one to be added. */
@@ -2977,26 +2976,13 @@ struct sta_info * ieee80211_ibss_add_sta(struct net=
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

--Boundary-01=_mETLGg4YeHKP8db--

--nextPart1678019.aziMr8bVT6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGLTEpT3Oqt9AH4aERAuTzAKDb9T6oS1ok8t/ApBtuRAn11uMCvACgwl2H
2eTudLbJsBvdQXaMaPZ74Ac=
=VzBg
-----END PGP SIGNATURE-----

--nextPart1678019.aziMr8bVT6--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html

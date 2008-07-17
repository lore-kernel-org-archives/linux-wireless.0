Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54954 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbYGQQzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 12:55:44 -0400
Subject: Re: question about open11s installation
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?=EC=9E=84=EC=98=81=EB=B9=88?= <ybim@mmlab.snu.ac.kr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <da2e1ddd0807170905j5121737bia15429aee0f7ffd6@mail.gmail.com> (sfid-20080717_180552_377776_374E3F3F)
References: <da2e1ddd0807170905j5121737bia15429aee0f7ffd6@mail.gmail.com>
	 (sfid-20080717_180552_377776_374E3F3F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZdkTUQQfIixrFd9zv33X"
Date: Thu, 17 Jul 2008 18:55:40 +0200
Message-Id: <1216313740.3422.44.camel@johannes.berg> (sfid-20080717_185549_449026_FCE80DC8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZdkTUQQfIixrFd9zv33X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> [  276.676290] ------------[ cut here ]------------
> [  276.676290] kernel BUG at net/mac80211/ieee80211_i.h:757!
> [  276.676290] invalid opcode: 0000 [#1] SMP
> [  276.676290] Modules linked in: rfkill_input radeon drm rfcomm l2cap
> bluetooth ppdev speedstep_lib cpufreq_stats cpufreq_userspace
> cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative
> video output container sbs sbshc battery iptable_filter ip_tables
> x_tables ac lp arc4 ecb crypto_blkcipher b43 rfkill mac80211
> parport_pc parport cfg80211 led_class psmouse input_polldev serio_raw
> pcspkr iTCO_wdt iTCO_vendor_support sky2 button intel_agp agpgart
> shpchp pci_hotplug ipv6 evdev ext3 jbd mbcache sd_mod sg sr_mod cdrom
> pata_acpi ata_generic 8139too ata_piix libata scsi_mod dock 8139cp mii
> ssb ehci_hcd uhci_hcd usbcore thermal processor fan thermal_sys fuse
> [  276.676290]
> [  276.676290] Pid: 5495, comm: iw Not tainted (2.6.26-custom-wl #1)
> [  276.676290] EIP: 0060:[<e09d6e0c>] EFLAGS: 00010246 CPU: 0
> [  276.676290] EIP is at ieee80211_dump_mpath+0x6c/0x80 [mac80211]

Clearly, there's a BUG_ON being hit, and that's under RTNL so after that
nothing works any more.

Please try the patch below.

johannes

--- everything.orig/net/mac80211/cfg.c	2008-07-17 18:40:29.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-07-17 18:55:03.000000000 +0200
@@ -85,6 +85,7 @@ static int ieee80211_change_iface(struct
 				  enum nl80211_iftype type, u32 *flags,
 				  struct vif_params *params)
 {
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
 	struct net_device *dev;
 	enum ieee80211_if_types itype;
 	struct ieee80211_sub_if_data *sdata;
@@ -99,6 +100,9 @@ static int ieee80211_change_iface(struct
 	if (itype =3D=3D IEEE80211_IF_TYPE_INVALID)
 		return -EINVAL;
=20
+	if (dev =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
 	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
=20
 	ret =3D ieee80211_if_change_type(sdata, itype);
@@ -121,12 +125,16 @@ static int ieee80211_add_key(struct wiph
 			     u8 key_idx, u8 *mac_addr,
 			     struct key_params *params)
 {
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta =3D NULL;
 	enum ieee80211_key_alg alg;
 	struct ieee80211_key *key;
 	int err;
=20
+	if (dev =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
 	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
=20
 	switch (params->cipher) {
@@ -171,10 +179,14 @@ static int ieee80211_add_key(struct wiph
 static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 			     u8 key_idx, u8 *mac_addr)
 {
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	int ret;
=20
+	if (dev =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
 	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
=20
 	rcu_read_lock();
@@ -215,7 +227,8 @@ static int ieee80211_get_key(struct wiph
 			     void (*callback)(void *cookie,
 					      struct key_params *params))
 {
-	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta =3D NULL;
 	u8 seq[6] =3D {0};
 	struct key_params params;
@@ -224,6 +237,11 @@ static int ieee80211_get_key(struct wiph
 	u16 iv16;
 	int err =3D -ENOENT;
=20
+	if (dev =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+
 	rcu_read_lock();
=20
 	if (mac_addr) {
@@ -297,8 +315,12 @@ static int ieee80211_config_default_key(
 					struct net_device *dev,
 					u8 key_idx)
 {
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
=20
+	if (dev =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
 	rcu_read_lock();
=20
 	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
@@ -479,9 +501,15 @@ static int ieee80211_config_beacon(struc
 static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *de=
v,
 				struct beacon_parameters *params)
 {
-	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct beacon_data *old;
=20
+	if (dev =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_AP)
 		return -EINVAL;
=20
@@ -496,9 +524,15 @@ static int ieee80211_add_beacon(struct w
 static int ieee80211_set_beacon(struct wiphy *wiphy, struct net_device *de=
v,
 				struct beacon_parameters *params)
 {
-	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct beacon_data *old;
=20
+	if (dev =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_AP)
 		return -EINVAL;
=20
@@ -512,9 +546,15 @@ static int ieee80211_set_beacon(struct w
=20
 static int ieee80211_del_beacon(struct wiphy *wiphy, struct net_device *de=
v)
 {
-	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct beacon_data *old;
=20
+	if (dev =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_AP)
 		return -EINVAL;
=20
@@ -650,11 +690,14 @@ static void sta_apply_parameters(struct=20
 static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *d=
ev,
 				 u8 *mac, struct station_parameters *params)
 {
-	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
 	int err;
=20
+	if (dev =3D=3D local->mdev || params->vlan =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
 	/* Prevent a race with changing the rate control algorithm */
 	if (!netif_running(dev))
 		return -ENETDOWN;
@@ -705,10 +748,15 @@ static int ieee80211_add_station(struct=20
 static int ieee80211_del_station(struct wiphy *wiphy, struct net_device *d=
ev,
 				 u8 *mac)
 {
-	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local =3D sdata->local;
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
=20
+	if (dev =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (mac) {
 		rcu_read_lock();
=20
@@ -734,10 +782,13 @@ static int ieee80211_change_station(stru
 				    u8 *mac,
 				    struct station_parameters *params)
 {
-	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *vlansdata;
=20
+	if (dev =3D=3D local->mdev || params->vlan =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
 	rcu_read_lock();
=20
 	/* XXX: get sta belonging to dev */
@@ -756,7 +807,7 @@ static int ieee80211_change_station(stru
 			return -EINVAL;
 		}
=20
-		sta->sdata =3D IEEE80211_DEV_TO_SUB_IF(params->vlan);
+		sta->sdata =3D vlansdata;
 		ieee80211_send_layer2_update(sta);
 	}
=20
@@ -771,15 +822,20 @@ static int ieee80211_change_station(stru
 static int ieee80211_add_mpath(struct wiphy *wiphy, struct net_device *dev=
,
 				 u8 *dst, u8 *next_hop)
 {
-	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 	struct sta_info *sta;
 	int err;
=20
+	if (dev =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
 	if (!netif_running(dev))
 		return -ENETDOWN;
=20
+	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_MESH_POINT)
 		return -ENOTSUPP;
=20
@@ -821,14 +877,19 @@ static int ieee80211_change_mpath(struct
 				    struct net_device *dev,
 				    u8 *dst, u8 *next_hop)
 {
-	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 	struct sta_info *sta;
=20
+	if (dev =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
 	if (!netif_running(dev))
 		return -ENETDOWN;
=20
+	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_MESH_POINT)
 		return -ENOTSUPP;
=20
@@ -895,9 +956,15 @@ static int ieee80211_get_mpath(struct wi
 			       u8 *dst, u8 *next_hop, struct mpath_info *pinfo)
=20
 {
-	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
=20
+	if (dev =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_MESH_POINT)
 		return -ENOTSUPP;
=20
@@ -917,9 +984,15 @@ static int ieee80211_dump_mpath(struct w
 				 int idx, u8 *dst, u8 *next_hop,
 				 struct mpath_info *pinfo)
 {
-	struct ieee80211_sub_if_data *sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local =3D wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
=20
+	if (dev =3D=3D local->mdev)
+		return -EOPNOTSUPP;
+
+	sdata =3D IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_MESH_POINT)
 		return -ENOTSUPP;
=20


--=-ZdkTUQQfIixrFd9zv33X
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIf3mJAAoJEKVg1VMiehFYFskP/1Gx7SM+B0FIkcJ3LbcOdUGH
oAqxWp4ozauXYDAzmlrg5ZGibqu8FipYjwyomm3vySl9kA9sQ+FCg/HHAny1s5p7
mFS5OJiIpJglStLGcWwUiYIwYWCcZIXrON0+Gh6jszZ03mZg9z8Dq6W2WvI/4mhW
wMXasRGH+t87WGL4vBKZQhC+M1GYJj0gqyXEG97II6hjShq6O52/JDEBRHWF35f1
+dNMQ/Ml92a9RYeWf8lBx4n6yiThyKtqTTaFuEa330QlSGB9Q0NjkRMlsRD1XAX5
qxMSjg8IIXQ8Ht+NxOcIDMPaIF4zvzqsH15DJksFLZ9/0dDbYds//5BUonHYk4oC
XLmvhHIsRn6pu57n62L6a8NkB+yQ3Cz3jv9DdP7li/qVtFkuOZ5aUQ8DT5l0dcTG
jK68oplJcKT42oD+uJPP9Fuu4Fr7znCRHCSdaqsKzcnGe7fjZfen3+kjbtKF1gDR
coYF63FnVTJTNBrx6Kbk17aXYRRcevi0yt5gJLAcAHsiapRfyV/6E2c1QOdxTwOF
SDlRxBWljTB7EiJOD/pIU1c9Rh/jIYIOVjuOTCnyVj0Icu7GrF4h7zvFeD723k7v
G+lpPO6qQM9+om7EKej0lxSZDae2k8mKZ6i1HqJI1bXW5iLiHVgXiqMDxd5pt7mU
lVq2nVI723Fn3z+MKBUn
=OIvx
-----END PGP SIGNATURE-----

--=-ZdkTUQQfIixrFd9zv33X--


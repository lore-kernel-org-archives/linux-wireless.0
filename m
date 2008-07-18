Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:17365 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbYGRIv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 04:51:28 -0400
Received: by ti-out-0910.google.com with SMTP id b6so225908tic.23
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 01:51:27 -0700 (PDT)
Message-ID: <da2e1ddd0807180151k707c77eeyf31b6ea2948c6ec3@mail.gmail.com> (sfid-20080718_105136_638316_750E0594)
Date: Fri, 18 Jul 2008 17:51:26 +0900
From: "=?EUC-KR?B?wNO/tbrz?=" <ybim@mmlab.snu.ac.kr>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: question about open11s installation
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1216313740.3422.44.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <da2e1ddd0807170905j5121737bia15429aee0f7ffd6@mail.gmail.com>
	 <1216313740.3422.44.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks to your patch, I could avoid the strange operation of the
system when I executed the command for showing mesh path.
But the problem that there's no mesh connection established still remains.
My wlan cards use broadcom 4318 chipsets, and I installed
wireless-testing kernel, iw and libnl correctly, I think.
Then what will be the possible cause?

2008/7/18 Johannes Berg <johannes@sipsolutions.net>:
>
> > [  276.676290] ------------[ cut here ]------------
> > [  276.676290] kernel BUG at net/mac80211/ieee80211_i.h:757!
> > [  276.676290] invalid opcode: 0000 [#1] SMP
> > [  276.676290] Modules linked in: rfkill_input radeon drm rfcomm l2cap
> > bluetooth ppdev speedstep_lib cpufreq_stats cpufreq_userspace
> > cpufreq_powersave cpufreq_ondemand freq_table cpufreq_conservative
> > video output container sbs sbshc battery iptable_filter ip_tables
> > x_tables ac lp arc4 ecb crypto_blkcipher b43 rfkill mac80211
> > parport_pc parport cfg80211 led_class psmouse input_polldev serio_raw
> > pcspkr iTCO_wdt iTCO_vendor_support sky2 button intel_agp agpgart
> > shpchp pci_hotplug ipv6 evdev ext3 jbd mbcache sd_mod sg sr_mod cdrom
> > pata_acpi ata_generic 8139too ata_piix libata scsi_mod dock 8139cp mii
> > ssb ehci_hcd uhci_hcd usbcore thermal processor fan thermal_sys fuse
> > [  276.676290]
> > [  276.676290] Pid: 5495, comm: iw Not tainted (2.6.26-custom-wl #1)
> > [  276.676290] EIP: 0060:[<e09d6e0c>] EFLAGS: 00010246 CPU: 0
> > [  276.676290] EIP is at ieee80211_dump_mpath+0x6c/0x80 [mac80211]
>
> Clearly, there's a BUG_ON being hit, and that's under RTNL so after that
> nothing works any more.
>
> Please try the patch below.
>
> johannes
>
> --- everything.orig/net/mac80211/cfg.c  2008-07-17 18:40:29.000000000 +0200
> +++ everything/net/mac80211/cfg.c       2008-07-17 18:55:03.000000000 +0200
> @@ -85,6 +85,7 @@ static int ieee80211_change_iface(struct
>                                  enum nl80211_iftype type, u32 *flags,
>                                  struct vif_params *params)
>  {
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
>        struct net_device *dev;
>        enum ieee80211_if_types itype;
>        struct ieee80211_sub_if_data *sdata;
> @@ -99,6 +100,9 @@ static int ieee80211_change_iface(struct
>        if (itype == IEEE80211_IF_TYPE_INVALID)
>                return -EINVAL;
>
> +       if (dev == local->mdev)
> +               return -EOPNOTSUPP;
> +
>        sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>
>        ret = ieee80211_if_change_type(sdata, itype);
> @@ -121,12 +125,16 @@ static int ieee80211_add_key(struct wiph
>                             u8 key_idx, u8 *mac_addr,
>                             struct key_params *params)
>  {
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
>        struct ieee80211_sub_if_data *sdata;
>        struct sta_info *sta = NULL;
>        enum ieee80211_key_alg alg;
>        struct ieee80211_key *key;
>        int err;
>
> +       if (dev == local->mdev)
> +               return -EOPNOTSUPP;
> +
>        sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>
>        switch (params->cipher) {
> @@ -171,10 +179,14 @@ static int ieee80211_add_key(struct wiph
>  static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
>                             u8 key_idx, u8 *mac_addr)
>  {
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
>        struct ieee80211_sub_if_data *sdata;
>        struct sta_info *sta;
>        int ret;
>
> +       if (dev == local->mdev)
> +               return -EOPNOTSUPP;
> +
>        sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>
>        rcu_read_lock();
> @@ -215,7 +227,8 @@ static int ieee80211_get_key(struct wiph
>                             void (*callback)(void *cookie,
>                                              struct key_params *params))
>  {
> -       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
> +       struct ieee80211_sub_if_data *sdata;
>        struct sta_info *sta = NULL;
>        u8 seq[6] = {0};
>        struct key_params params;
> @@ -224,6 +237,11 @@ static int ieee80211_get_key(struct wiph
>        u16 iv16;
>        int err = -ENOENT;
>
> +       if (dev == local->mdev)
> +               return -EOPNOTSUPP;
> +
> +       sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +
>        rcu_read_lock();
>
>        if (mac_addr) {
> @@ -297,8 +315,12 @@ static int ieee80211_config_default_key(
>                                        struct net_device *dev,
>                                        u8 key_idx)
>  {
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
>        struct ieee80211_sub_if_data *sdata;
>
> +       if (dev == local->mdev)
> +               return -EOPNOTSUPP;
> +
>        rcu_read_lock();
>
>        sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> @@ -479,9 +501,15 @@ static int ieee80211_config_beacon(struc
>  static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *dev,
>                                struct beacon_parameters *params)
>  {
> -       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
> +       struct ieee80211_sub_if_data *sdata;
>        struct beacon_data *old;
>
> +       if (dev == local->mdev)
> +               return -EOPNOTSUPP;
> +
> +       sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +
>        if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
>                return -EINVAL;
>
> @@ -496,9 +524,15 @@ static int ieee80211_add_beacon(struct w
>  static int ieee80211_set_beacon(struct wiphy *wiphy, struct net_device *dev,
>                                struct beacon_parameters *params)
>  {
> -       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
> +       struct ieee80211_sub_if_data *sdata;
>        struct beacon_data *old;
>
> +       if (dev == local->mdev)
> +               return -EOPNOTSUPP;
> +
> +       sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +
>        if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
>                return -EINVAL;
>
> @@ -512,9 +546,15 @@ static int ieee80211_set_beacon(struct w
>
>  static int ieee80211_del_beacon(struct wiphy *wiphy, struct net_device *dev)
>  {
> -       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
> +       struct ieee80211_sub_if_data *sdata;
>        struct beacon_data *old;
>
> +       if (dev == local->mdev)
> +               return -EOPNOTSUPP;
> +
> +       sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +
>        if (sdata->vif.type != IEEE80211_IF_TYPE_AP)
>                return -EINVAL;
>
> @@ -650,11 +690,14 @@ static void sta_apply_parameters(struct
>  static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
>                                 u8 *mac, struct station_parameters *params)
>  {
> -       struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
>        struct sta_info *sta;
>        struct ieee80211_sub_if_data *sdata;
>        int err;
>
> +       if (dev == local->mdev || params->vlan == local->mdev)
> +               return -EOPNOTSUPP;
> +
>        /* Prevent a race with changing the rate control algorithm */
>        if (!netif_running(dev))
>                return -ENETDOWN;
> @@ -705,10 +748,15 @@ static int ieee80211_add_station(struct
>  static int ieee80211_del_station(struct wiphy *wiphy, struct net_device *dev,
>                                 u8 *mac)
>  {
> -       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> -       struct ieee80211_local *local = sdata->local;
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
> +       struct ieee80211_sub_if_data *sdata;
>        struct sta_info *sta;
>
> +       if (dev == local->mdev)
> +               return -EOPNOTSUPP;
> +
> +       sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +
>        if (mac) {
>                rcu_read_lock();
>
> @@ -734,10 +782,13 @@ static int ieee80211_change_station(stru
>                                    u8 *mac,
>                                    struct station_parameters *params)
>  {
> -       struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
>        struct sta_info *sta;
>        struct ieee80211_sub_if_data *vlansdata;
>
> +       if (dev == local->mdev || params->vlan == local->mdev)
> +               return -EOPNOTSUPP;
> +
>        rcu_read_lock();
>
>        /* XXX: get sta belonging to dev */
> @@ -756,7 +807,7 @@ static int ieee80211_change_station(stru
>                        return -EINVAL;
>                }
>
> -               sta->sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
> +               sta->sdata = vlansdata;
>                ieee80211_send_layer2_update(sta);
>        }
>
> @@ -771,15 +822,20 @@ static int ieee80211_change_station(stru
>  static int ieee80211_add_mpath(struct wiphy *wiphy, struct net_device *dev,
>                                 u8 *dst, u8 *next_hop)
>  {
> -       struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> -       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
> +       struct ieee80211_sub_if_data *sdata;
>        struct mesh_path *mpath;
>        struct sta_info *sta;
>        int err;
>
> +       if (dev == local->mdev)
> +               return -EOPNOTSUPP;
> +
>        if (!netif_running(dev))
>                return -ENETDOWN;
>
> +       sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +
>        if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
>                return -ENOTSUPP;
>
> @@ -821,14 +877,19 @@ static int ieee80211_change_mpath(struct
>                                    struct net_device *dev,
>                                    u8 *dst, u8 *next_hop)
>  {
> -       struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> -       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
> +       struct ieee80211_sub_if_data *sdata;
>        struct mesh_path *mpath;
>        struct sta_info *sta;
>
> +       if (dev == local->mdev)
> +               return -EOPNOTSUPP;
> +
>        if (!netif_running(dev))
>                return -ENETDOWN;
>
> +       sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +
>        if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
>                return -ENOTSUPP;
>
> @@ -895,9 +956,15 @@ static int ieee80211_get_mpath(struct wi
>                               u8 *dst, u8 *next_hop, struct mpath_info *pinfo)
>
>  {
> -       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
> +       struct ieee80211_sub_if_data *sdata;
>        struct mesh_path *mpath;
>
> +       if (dev == local->mdev)
> +               return -EOPNOTSUPP;
> +
> +       sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +
>        if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
>                return -ENOTSUPP;
>
> @@ -917,9 +984,15 @@ static int ieee80211_dump_mpath(struct w
>                                 int idx, u8 *dst, u8 *next_hop,
>                                 struct mpath_info *pinfo)
>  {
> -       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +       struct ieee80211_local *local = wiphy_priv(wiphy);
> +       struct ieee80211_sub_if_data *sdata;
>        struct mesh_path *mpath;
>
> +       if (dev == local->mdev)
> +               return -EOPNOTSUPP;
> +
> +       sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +
>        if (sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
>                return -ENOTSUPP;
>
>



--
YoungBin Im
Master Course Student
Multimedia & Mobile Communications Lab.
School of Computer Science and Engineering
Seoul National University, Republic of Korea.

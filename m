Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55821 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab2LEW6D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 17:58:03 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so3327461wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 14:58:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354745174-2941-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1354745174-2941-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 5 Dec 2012 14:57:40 -0800
Message-ID: <CAG6hwVOc=E67ZxuFZnk3goM8VVEOqSWOi6dn63L2rmEyWOfG1g@mail.gmail.com> (sfid-20121205_235811_327865_6E519FE0)
Subject: Re: [PATCH] {nl, cfg, mac}80211: set beacon interval and DTIM period
 on mesh join
To: devel@lists.open80211s.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 5, 2012 at 2:06 PM, Marco Porsch
<marco.porsch@etit.tu-chemnitz.de> wrote:
> Move the default mesh beacon interval and DTIM period to cfg80211 and
> make it accessible to nl80211. This enables setting both values when joining
> an MBSS.
>
> NOTE: In a mesh with links in PS mode it is not advised to use the default
> parameters 1000:4, as these cause excessive buffering delays that exceed
> various timeouts (e.g. HWMP path request).

Then make the default parameters reasonable? How is 1000:2?

> Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
> ---
>  include/net/cfg80211.h |    4 ++++
>  net/mac80211/cfg.c     |    3 +++
>  net/mac80211/mesh.c    |    1 -
>  net/mac80211/mesh.h    |    2 --
>  net/wireless/mesh.c    |    5 +++++
>  net/wireless/nl80211.c |   14 ++++++++++++++
>  6 files changed, 26 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index e78db2c..a31e893 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1009,6 +1009,8 @@ struct mesh_config {
>   * @ie_len: length of vendor information elements
>   * @is_authenticated: this mesh requires authentication
>   * @is_secure: this mesh uses security
> + * @dtim_period: DTIM period to use
> + * @beacon_interval: beacon interval to use
>   * @mcast_rate: multicat rate for Mesh Node [6Mbps is the default for 802.11a]
>   *
>   * These parameters are fixed when the mesh is created.
> @@ -1024,6 +1026,8 @@ struct mesh_setup {
>         u8 ie_len;
>         bool is_authenticated;
>         bool is_secure;
> +       u8 dtim_period;
> +       u16 beacon_interval;
>         int mcast_rate[IEEE80211_NUM_BANDS];
>  };
>
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 4965aa6..7227477 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1604,6 +1604,9 @@ static int copy_mesh_setup(struct ieee80211_if_mesh *ifmsh,
>         memcpy(sdata->vif.bss_conf.mcast_rate, setup->mcast_rate,
>                                                 sizeof(setup->mcast_rate));
>
> +       sdata->vif.bss_conf.beacon_int = setup->beacon_interval;
> +       sdata->vif.bss_conf.dtim_period = setup->dtim_period;
> +
>         return 0;
>  }
>
> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
> index 1bf03f9..a4b332c 100644
> --- a/net/mac80211/mesh.c
> +++ b/net/mac80211/mesh.c
> @@ -624,7 +624,6 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
>         ieee80211_queue_work(&local->hw, &sdata->work);
>         sdata->vif.bss_conf.ht_operation_mode =
>                                 ifmsh->mshcfg.ht_opmode;
> -       sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
>         sdata->vif.bss_conf.basic_rates =
>                 ieee80211_mandatory_rates(sdata->local,
>                                           ieee80211_get_sdata_band(sdata));
> diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
> index 7c9215f..7f3a78f 100644
> --- a/net/mac80211/mesh.h
> +++ b/net/mac80211/mesh.h
> @@ -191,8 +191,6 @@ struct mesh_rmc {
>  #define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
>  #define IEEE80211_MESH_HOUSEKEEPING_INTERVAL (60 * HZ)
>
> -#define MESH_DEFAULT_BEACON_INTERVAL           1000    /* in 1024 us units */
> -
>  #define MESH_PATH_EXPIRE (600 * HZ)
>
>  /* Default maximum number of plinks per interface */
> diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
> index 3ee5a72..38f3073 100644
> --- a/net/wireless/mesh.c
> +++ b/net/wireless/mesh.c
> @@ -44,6 +44,9 @@
>
>  #define MESH_SYNC_NEIGHBOR_OFFSET_MAX 50
>
> +#define MESH_DEFAULT_BEACON_INTERVAL   1000    /* in 1024 us units (=TUs) */
> +#define MESH_DEFAULT_DTIM_PERIOD       4
> +
>  const struct mesh_config default_mesh_config = {
>         .dot11MeshRetryTimeout = MESH_RET_T,
>         .dot11MeshConfirmTimeout = MESH_CONF_T,
> @@ -79,6 +82,8 @@ const struct mesh_setup default_mesh_setup = {
>         .ie = NULL,
>         .ie_len = 0,
>         .is_secure = false,
> +       .beacon_interval = MESH_DEFAULT_BEACON_INTERVAL,
> +       .dtim_period = MESH_DEFAULT_DTIM_PERIOD,
>  };
>
>  int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index d038fa4..00068a4 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -6643,6 +6643,20 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
>                             nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE])))
>                         return -EINVAL;
>
> +       if (info->attrs[NL80211_ATTR_BEACON_INTERVAL]) {
> +                       setup.beacon_interval =
> +                               nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
> +                       if (setup.beacon_interval < 10 || setup.beacon_interval > 10000)
> +                               return -EINVAL;
> +       }
> +
> +       if (info->attrs[NL80211_ATTR_DTIM_PERIOD]) {
> +                       setup.dtim_period =
> +                               nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
> +                       if (setup.dtim_period < 1 || setup.dtim_period > 100)
> +                               return -EINVAL;
> +       }
> +
>         if (info->attrs[NL80211_ATTR_MESH_SETUP]) {
>                 /* parse additional setup parameters if given */
>                 err = nl80211_parse_mesh_setup(info, &setup);
> --
> 1.7.9.5
>
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel

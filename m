Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47369 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab2JJBtt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2012 21:49:49 -0400
Received: by mail-ob0-f174.google.com with SMTP id uo13so6798obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2012 18:49:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj987-Jr5taecuQf62h7yGJ15yxRae0obHguXK2cEEJMGm4A@mail.gmail.com>
References: <1349814468-6512-1-git-send-email-ashok@cozybit.com>
 <1349814468-6512-2-git-send-email-ashok@cozybit.com> <CAEFj987-Jr5taecuQf62h7yGJ15yxRae0obHguXK2cEEJMGm4A@mail.gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 9 Oct 2012 18:49:28 -0700
Message-ID: <CAPjQAd9KQf7vNNLAsJwgvePe8w8TA7PZqUBiMDvf2TpLhuyhTQ@mail.gmail.com> (sfid-20121010_034951_961899_1F1866E7)
Subject: Re: [PATCH 2/2] [nl, cfg, mac]80211: Add nl80211 command to get mesh
 network statistics
To: devel@lists.open80211s.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chun-Yeow,

On Tue, Oct 9, 2012 at 6:31 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> Hi, Ashok
>
> Mesh Total Forwarded Frames = Mesh Forwarded Unicast Frame + Mesh
> Forwarded Multicast Frame
>
> Am I right?

Keep in mind that the patch does not modify those stats, just provides
a different way to access them from userspace.
These same stats are accessible today via debugfs:

grep -H . /sys/kernel/debug/ieee80211/phy1/netdev\:mesh1/mesh_stats/*
| grep fwded
/sys/kernel/debug/ieee80211/phy1/netdev:mesh1/mesh_stats/fwded_frames:2039
/sys/kernel/debug/ieee80211/phy1/netdev:mesh1/mesh_stats/fwded_mcast:13
/sys/kernel/debug/ieee80211/phy1/netdev:mesh1/mesh_stats/fwded_unicast:2026

Cheers,

Javier

> -----
> Chun-Yeow
>
> On Wed, Oct 10, 2012 at 4:27 AM, Ashok Nagarajan <ashok@cozybit.com> wrote:
>> The command NL80211_CMD_GET_MESH_STATS gets the statistical information about
>> the mesh network. Currently, the following statistics are provided:
>>
>> 1. Mesh forwarded multicast frames
>> 2. Mesh forwarded unicast frames
>> 3. Mesh total forwarded frames
>> 4. Dropped frames due to mesh_ttl == 0
>> 5. Dropped frames due to no route found
>> 6. Dropped frames due to congestion
>>
>> The attibute NL80211_ATTR_MESH_PARAMS enumerates the various mesh statistical
>> parameters. A new call back get_mesh_stats() is added. mesh_stats struct is
>> moved from mac80211/ieee80211_i.h to net/cfg80211.h.
>>
>> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
>> ---
>>  include/linux/nl80211.h    |   40 ++++++++++++++++++++++++
>>  include/net/cfg80211.h     |   26 ++++++++++++++++
>>  net/mac80211/cfg.c         |   12 +++++++
>>  net/mac80211/ieee80211_i.h |    9 -----
>>  net/wireless/nl80211.c     |   71 ++++++++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 149 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
>> index 7df9b50..1a30195 100644
>> --- a/include/linux/nl80211.h
>> +++ b/include/linux/nl80211.h
>> @@ -578,6 +578,9 @@
>>   *     station, due to particular reason. %NL80211_ATTR_CONN_FAILED_REASON
>>   *     is used for this.
>>   *
>> + * @NL80211_CMD_GET_MESH_STATS: Get mesh networking statistics for the
>> + *     interface identified by %NL80211_ATTR_IFINDEX
>> + *
>>   * @NL80211_CMD_MAX: highest used command number
>>   * @__NL80211_CMD_AFTER_LAST: internal use
>>   */
>> @@ -726,6 +729,8 @@ enum nl80211_commands {
>>
>>         NL80211_CMD_CONN_FAILED,
>>
>> +       NL80211_CMD_GET_MESH_STATS,
>> +
>>         /* add new commands above here */
>>
>>         /* used to define NL80211_CMD_MAX below */
>> @@ -1530,6 +1535,8 @@ enum nl80211_attrs {
>>
>>         NL80211_ATTR_CONN_FAILED_REASON,
>>
>> +       NL80211_ATTR_MESH_STATS,
>> +
>>         /* add attributes here, update the policy in nl80211.c */
>>
>>         __NL80211_ATTR_AFTER_LAST,
>> @@ -2188,6 +2195,39 @@ enum nl80211_mntr_flags {
>>  };
>>
>>  /**
>> + * enum nl80211_mesh_stats - mesh statisitics
>> + *
>> + * Provide statistical information about mesh.
>> + *
>> + * @__NL80211_MESH_STATS_INVALID: internal use
>> + * @NL80211_MESH_STATS_FWDED_MCAST: specifies the number of mesh forwarded
>> + *     multicast frames
>> + * @NL80211_MESH_STATS_FWDED_UNICAST: specifies the number of mesh forwarded
>> + *     unicast frames
>> + * @NL80211_MESH_STATS_FWDED_FRAMES: specifies the total number of mesh
>> + *     forwarded frames
>> + * @NL80211_MESH_STATS_DROPPED_FRAMES_TTL: specifies the number of mesh frames
>> + *     dropped since mesh_ttl == 0
>> + * @NL80211_MESH_STATS_DROPPED_FRAMES_NO_ROUTE: specifies the number of mesh
>> + *     frames dropped due to no route found
>> + * @NL80211_MESH_STATS_DROPPED_FRAMES_CONGESTION: specifies the number of mesh
>> + *     frames dropped due to congestion
>> + */
>> +enum nl80211_mesh_stats {
>> +       __NL80211_MESH_STATS_INVALID,
>> +       NL80211_MESH_STATS_FWDED_MCAST,
>> +       NL80211_MESH_STATS_FWDED_UNICAST,
>> +       NL80211_MESH_STATS_FWDED_FRAMES,
>> +       NL80211_MESH_STATS_DROPPED_FRAMES_TTL,
>> +       NL80211_MESH_STATS_DROPPED_FRAMES_NO_ROUTE,
>> +       NL80211_MESH_STATS_DROPPED_FRAMES_CONGESTION,
>> +
>> +       /* keep last */
>> +       __NL80211_MESH_STATS_ATTR_AFTER_LAST,
>> +       NL80211_MESH_STATS_ATTR_MAX = __NL80211_MESH_STATS_ATTR_AFTER_LAST - 1
>> +};
>> +
>> +/**
>>   * enum nl80211_meshconf_params - mesh configuration parameters
>>   *
>>   * Mesh configuration parameters. These can be changed while the mesh is
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index ab78b53..1926502 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -815,6 +815,27 @@ struct bss_parameters {
>>  };
>>
>>  /**
>> + * struct mesh_stats - 802.11s mesh statistics
>> + *
>> + * Used to provide statistical information about mesh
>> + *
>> + * @fwded_mcast: Mesh forwarded multicast frames
>> + * @fwded_unicast: Mesh forwarded unicast frames
>> + * @fwded_frames: Mesh total forwarded frames
>> + * @dropped_frames_ttl: Not transmitted since mesh_ttl == 0
>> + * @dropped_frames_no_route: Not transmitted, no route found
>> + * @dropped_frames_congestion: Not forwarded due to congestion
>> + */
>> +struct mesh_stats {
>> +       u32 fwded_mcast;
>> +       u32 fwded_unicast;
>> +       u32 fwded_frames;
>> +       u32 dropped_frames_ttl;
>> +       u32 dropped_frames_no_route;
>> +       u32 dropped_frames_congestion;
>> +};
>> +
>> +/**
>>   * struct mesh_config - 802.11s mesh configuration
>>   *
>>   * These parameters can be changed while the mesh is active.
>> @@ -1492,6 +1513,8 @@ struct cfg80211_gtk_rekey_data {
>>   *
>>   * @get_mesh_config: Get the current mesh configuration
>>   *
>> + * @get_mesh_stats: Get the current mesh statistics
>> + *
>>   * @update_mesh_config: Update mesh parameters on a running mesh.
>>   *     The mask is a bitfield which tells us which parameters to
>>   *     set, and which to leave alone.
>> @@ -1688,6 +1711,9 @@ struct cfg80211_ops {
>>         int     (*get_mesh_config)(struct wiphy *wiphy,
>>                                 struct net_device *dev,
>>                                 struct mesh_config *conf);
>> +       int     (*get_mesh_stats)(struct wiphy *wiphy,
>> +                                 struct net_device *dev,
>> +                                 struct mesh_stats *stats);
>>         int     (*update_mesh_config)(struct wiphy *wiphy,
>>                                       struct net_device *dev, u32 mask,
>>                                       const struct mesh_config *nconf);
>> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
>> index 05f3a31..5af9260 100644
>> --- a/net/mac80211/cfg.c
>> +++ b/net/mac80211/cfg.c
>> @@ -1496,6 +1496,17 @@ static int ieee80211_dump_mpath(struct wiphy *wiphy, struct net_device *dev,
>>         return 0;
>>  }
>>
>> +static int ieee80211_get_mesh_stats(struct wiphy *wiphy,
>> +                                   struct net_device *dev,
>> +                                   struct mesh_stats *stats)
>> +{
>> +       struct ieee80211_sub_if_data *sdata;
>> +       sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +
>> +       memcpy(stats, &sdata->u.mesh.mshstats, sizeof(*stats));
>> +       return 0;
>> +}
>> +
>>  static int ieee80211_get_mesh_config(struct wiphy *wiphy,
>>                                 struct net_device *dev,
>>                                 struct mesh_config *conf)
>> @@ -3082,6 +3093,7 @@ struct cfg80211_ops mac80211_config_ops = {
>>         .get_mpath = ieee80211_get_mpath,
>>         .dump_mpath = ieee80211_dump_mpath,
>>         .update_mesh_config = ieee80211_update_mesh_config,
>> +       .get_mesh_stats = ieee80211_get_mesh_stats,
>>         .get_mesh_config = ieee80211_get_mesh_config,
>>         .join_mesh = ieee80211_join_mesh,
>>         .leave_mesh = ieee80211_leave_mesh,
>> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
>> index 34f3cda..c30be38 100644
>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -309,15 +309,6 @@ struct ieee80211_if_vlan {
>>         struct sta_info __rcu *sta;
>>  };
>>
>> -struct mesh_stats {
>> -       __u32 fwded_mcast;              /* Mesh forwarded multicast frames */
>> -       __u32 fwded_unicast;            /* Mesh forwarded unicast frames */
>> -       __u32 fwded_frames;             /* Mesh total forwarded frames */
>> -       __u32 dropped_frames_ttl;       /* Not transmitted since mesh_ttl == 0*/
>> -       __u32 dropped_frames_no_route;  /* Not transmitted, no route found */
>> -       __u32 dropped_frames_congestion;/* Not forwarded due to congestion */
>> -};
>> -
>>  #define PREQ_Q_F_START         0x1
>>  #define PREQ_Q_F_REFRESH       0x2
>>  struct mesh_preq_queue {
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index f1047ae..279a106 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -275,6 +275,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
>>                                            .len = NL80211_MAX_SUPP_RATES },
>>         [NL80211_ATTR_BSS_HT_OPMODE] = { .type = NLA_U16 },
>>
>> +       [NL80211_ATTR_MESH_STATS] = { .type = NLA_NESTED },
>>         [NL80211_ATTR_MESH_CONFIG] = { .type = NLA_NESTED },
>>         [NL80211_ATTR_SUPPORT_MESH_AUTH] = { .type = NLA_FLAG },
>>
>> @@ -3645,6 +3646,68 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
>>         return r;
>>  }
>>
>> +static int nl80211_get_mesh_stats(struct sk_buff *skb,
>> +                                 struct genl_info *info)
>> +{
>> +       struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> +       struct net_device *dev = info->user_ptr[1];
>> +       struct wireless_dev *wdev = dev->ieee80211_ptr;
>> +       struct mesh_stats cur_stats;
>> +       int err = 0;
>> +       void *hdr;
>> +       struct nlattr *pinfoattr;
>> +       struct sk_buff *msg;
>> +
>> +       if (wdev->iftype != NL80211_IFTYPE_MESH_POINT)
>> +               return -EOPNOTSUPP;
>> +
>> +       if (!rdev->ops->get_mesh_stats)
>> +               return -EOPNOTSUPP;
>> +
>> +       wdev_lock(wdev);
>> +
>> +       err = rdev->ops->get_mesh_stats(&rdev->wiphy, dev, &cur_stats);
>> +       wdev_unlock(wdev);
>> +
>> +       if (err)
>> +               return err;
>> +
>> +       /* Draw up a netlink message to send back */
>> +       msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> +       if (!msg)
>> +               return -ENOMEM;
>> +       hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
>> +                            NL80211_CMD_GET_MESH_STATS);
>> +       if (!hdr)
>> +               goto out;
>> +       pinfoattr = nla_nest_start(msg, NL80211_ATTR_MESH_STATS);
>> +       if (!pinfoattr)
>> +               goto nla_put_failure;
>> +       if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
>> +           nla_put_u32(msg, NL80211_MESH_STATS_FWDED_MCAST,
>> +                       cur_stats.fwded_mcast) ||
>> +           nla_put_u32(msg, NL80211_MESH_STATS_FWDED_UNICAST,
>> +                       cur_stats.fwded_unicast) ||
>> +           nla_put_u32(msg, NL80211_MESH_STATS_FWDED_FRAMES,
>> +                       cur_stats.fwded_frames) ||
>> +           nla_put_u32(msg, NL80211_MESH_STATS_DROPPED_FRAMES_TTL,
>> +                       cur_stats.dropped_frames_ttl) ||
>> +           nla_put_u32(msg, NL80211_MESH_STATS_DROPPED_FRAMES_NO_ROUTE,
>> +                       cur_stats.dropped_frames_no_route) ||
>> +           nla_put_u32(msg, NL80211_MESH_STATS_DROPPED_FRAMES_CONGESTION,
>> +                       cur_stats.dropped_frames_congestion))
>> +               goto nla_put_failure;
>> +       nla_nest_end(msg, pinfoattr);
>> +       genlmsg_end(msg, hdr);
>> +       return genlmsg_reply(msg, info);
>> +
>> + nla_put_failure:
>> +       genlmsg_cancel(msg, hdr);
>> + out:
>> +       nlmsg_free(msg);
>> +       return -ENOBUFS;
>> +}
>> +
>>  static int nl80211_get_mesh_config(struct sk_buff *skb,
>>                                    struct genl_info *info)
>>  {
>> @@ -7202,6 +7265,14 @@ static struct genl_ops nl80211_ops[] = {
>>                 .flags = GENL_ADMIN_PERM,
>>         },
>>         {
>> +               .cmd = NL80211_CMD_GET_MESH_STATS,
>> +               .doit = nl80211_get_mesh_stats,
>> +               .policy = nl80211_policy,
>> +               /* can be retrieved by unprivileged users */
>> +               .internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
>> +                                 NL80211_FLAG_NEED_RTNL,
>> +       },
>> +       {
>>                 .cmd = NL80211_CMD_GET_MESH_CONFIG,
>>                 .doit = nl80211_get_mesh_config,
>>                 .policy = nl80211_policy,
>> --
>> 1.7.5.4
>>
>> _______________________________________________
>> Devel mailing list
>> Devel@lists.open80211s.org
>> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com

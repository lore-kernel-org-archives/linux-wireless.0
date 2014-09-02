Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:62771 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaIBG32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 02:29:28 -0400
Received: by mail-vc0-f178.google.com with SMTP id la4so6488431vcb.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 23:29:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGnRvurbvu5VX8cmgrDzMMjeqQRXoEu=CLEi=r3ncPWeV3tirA@mail.gmail.com>
References: <2937689.hWkxdbjQ3v@rogge-hp-probook-6470b>
	<CAGnRvurbvu5VX8cmgrDzMMjeqQRXoEu=CLEi=r3ncPWeV3tirA@mail.gmail.com>
Date: Tue, 2 Sep 2014 14:29:27 +0800
Message-ID: <CAEFj986gwjF0GVO1mJvS4hQtwTdDRs3+qbWPvvqqOJ=ZbZdfMw@mail.gmail.com> (sfid-20140902_082933_179109_43BEE080)
Subject: Re: [Patch]mac80211: Add support for mesh proxy path dump
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested with ath9k and working fine for me.

----
ChunYeow

On Mon, Sep 1, 2014 at 8:03 PM, Henning Rogge <hrogge@gmail.com> wrote:
> Hi,
>
> I forgot to add that the patch applies to the head of
> wireless-testing. I have also tested it on OpenWRT Barrier Breaker on
> a Ubiquiti Bullet M5 with the ath9k driver.
>
> Henning Rogge
>
> On Mon, Sep 1, 2014 at 1:26 PM, Henning Rogge <hrogge@gmail.com> wrote:
>> The following patch adds NL80211_CMD_GET_MPP as a new nl80211 command that
>> allows to query the content of the 'mesh proxy path' table of mac80211s via
>> 'get' or 'dump'  operation.
>>
>> Signed-off-by: Henning Rogge <henning.rogge@fkie.fraunhofer.de>
>> ---
>>  include/net/cfg80211.h       |  7 ++++
>>  include/uapi/linux/nl80211.h |  6 +++
>>  net/mac80211/cfg.c           | 53 ++++++++++++++++++++++++
>>  net/mac80211/mesh.h          |  3 ++
>>  net/mac80211/mesh_pathtbl.c  | 31 ++++++++++++++
>>  net/wireless/nl80211.c       | 99 ++++++++++++++++++++++++++++++++++++++++++++
>>  net/wireless/rdev-ops.h      | 27 +++++++++++-
>>  net/wireless/trace.h         | 45 ++++++++++++++++++++
>>  8 files changed, 270 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index 0a080c4..68fbcf5 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -2139,6 +2139,8 @@ struct cfg80211_qos_map {
>>   * @change_mpath: change a given mesh path
>>   * @get_mpath: get a mesh path for the given parameters
>>   * @dump_mpath: dump mesh path callback -- resume dump at index @idx
>> + * @get_mpp: get a mesh proxy path for the given parameters
>> + * @dump_mpp: dump mesh proxy path callback -- resume dump at index @idx
>>   * @join_mesh: join the mesh network with the specified parameters
>>   *     (invoked with the wireless_dev mutex held)
>>   * @leave_mesh: leave the current mesh network
>> @@ -2378,6 +2380,11 @@ struct cfg80211_ops {
>>         int     (*dump_mpath)(struct wiphy *wiphy, struct net_device *dev,
>>                               int idx, u8 *dst, u8 *next_hop,
>>                               struct mpath_info *pinfo);
>> +       int     (*get_mpp)(struct wiphy *wiphy, struct net_device *dev,
>> +                            u8 *dst, u8 *mpp, struct mpath_info *pinfo);
>> +       int     (*dump_mpp)(struct wiphy *wiphy, struct net_device *dev,
>> +                             int idx, u8 *dst, u8 *mpp,
>> +                             struct mpath_info *pinfo);
>>         int     (*get_mesh_config)(struct wiphy *wiphy,
>>                                 struct net_device *dev,
>>                                 struct mesh_config *conf);
>> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
>> index f1db15b..80cff48 100644
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -722,6 +722,10 @@
>>   *     QoS mapping is relevant for IP packets, it is only valid during an
>>   *     association. This is cleared on disassociation and AP restart.
>>   *
>> + * @NL80211_CMD_GET_MPP: Get mesh path attributes for mesh proxy path to
>> + *     destination %NL80211_ATTR_MAC on the interface identified by
>> + *     %NL80211_ATTR_IFINDEX.
>> + *
>>   * @NL80211_CMD_MAX: highest used command number
>>   * @__NL80211_CMD_AFTER_LAST: internal use
>>   */
>> @@ -893,6 +897,8 @@ enum nl80211_commands {
>>
>>         NL80211_CMD_SET_QOS_MAP,
>>
>> +       NL80211_CMD_GET_MPP,
>> +
>>         /* add new commands above here */
>>
>>         /* used to define NL80211_CMD_MAX below */
>> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
>> index 927b4ea..2b85eed 100644
>> --- a/net/mac80211/cfg.c
>> +++ b/net/mac80211/cfg.c
>> @@ -1511,6 +1511,57 @@ static int ieee80211_dump_mpath(struct wiphy *wiphy, struct net_device *dev,
>>         return 0;
>>  }
>>
>> +static void mpp_set_pinfo(struct mesh_path *mpath, u8 *mpp,
>> +                         struct mpath_info *pinfo)
>> +{
>> +       memset(pinfo, 0, sizeof(*pinfo));
>> +       memcpy(mpp, mpath->mpp, ETH_ALEN);
>> +
>> +       pinfo->generation = mpp_paths_generation;
>> +}
>> +
>> +static int ieee80211_get_mpp(struct wiphy *wiphy, struct net_device *dev,
>> +                            u8 *dst, u8 *mpp, struct mpath_info *pinfo)
>> +
>> +{
>> +       struct ieee80211_sub_if_data *sdata;
>> +       struct mesh_path *mpath;
>> +
>> +       sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +
>> +       rcu_read_lock();
>> +       mpath = mpp_path_lookup(sdata, dst);
>> +       if (!mpath) {
>> +               rcu_read_unlock();
>> +               return -ENOENT;
>> +       }
>> +       memcpy(dst, mpath->dst, ETH_ALEN);
>> +       mpp_set_pinfo(mpath, mpp, pinfo);
>> +       rcu_read_unlock();
>> +       return 0;
>> +}
>> +
>> +static int ieee80211_dump_mpp(struct wiphy *wiphy, struct net_device *dev,
>> +                             int idx, u8 *dst, u8 *mpp,
>> +                             struct mpath_info *pinfo)
>> +{
>> +       struct ieee80211_sub_if_data *sdata;
>> +       struct mesh_path *mpath;
>> +
>> +       sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>> +
>> +       rcu_read_lock();
>> +       mpath = mpp_path_lookup_by_idx(sdata, idx);
>> +       if (!mpath) {
>> +               rcu_read_unlock();
>> +               return -ENOENT;
>> +       }
>> +       memcpy(dst, mpath->dst, ETH_ALEN);
>> +       mpp_set_pinfo(mpath, mpp, pinfo);
>> +       rcu_read_unlock();
>> +       return 0;
>> +}
>> +
>>  static int ieee80211_get_mesh_config(struct wiphy *wiphy,
>>                                 struct net_device *dev,
>>                                 struct mesh_config *conf)
>> @@ -3507,6 +3558,8 @@ const struct cfg80211_ops mac80211_config_ops = {
>>         .change_mpath = ieee80211_change_mpath,
>>         .get_mpath = ieee80211_get_mpath,
>>         .dump_mpath = ieee80211_dump_mpath,
>> +       .get_mpp = ieee80211_get_mpp,
>> +       .dump_mpp = ieee80211_dump_mpp,
>>         .update_mesh_config = ieee80211_update_mesh_config,
>>         .get_mesh_config = ieee80211_get_mesh_config,
>>         .join_mesh = ieee80211_join_mesh,
>> diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
>> index f39a19f..50c8473 100644
>> --- a/net/mac80211/mesh.h
>> +++ b/net/mac80211/mesh.h
>> @@ -270,6 +270,8 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
>>                  const u8 *dst, const u8 *mpp);
>>  struct mesh_path *
>>  mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx);
>> +struct mesh_path *
>> +mpp_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx);
>>  void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop);
>>  void mesh_path_expire(struct ieee80211_sub_if_data *sdata);
>>  void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
>> @@ -317,6 +319,7 @@ void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata);
>>
>>  bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt);
>>  extern int mesh_paths_generation;
>> +extern int mpp_paths_generation;
>>
>>  #ifdef CONFIG_MAC80211_MESH
>>  static inline
>> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
>> index cf032a8..8630963 100644
>> --- a/net/mac80211/mesh_pathtbl.c
>> +++ b/net/mac80211/mesh_pathtbl.c
>> @@ -44,6 +44,7 @@ static struct mesh_table __rcu *mesh_paths;
>>  static struct mesh_table __rcu *mpp_paths; /* Store paths for MPP&MAP */
>>
>>  int mesh_paths_generation;
>> +int mpp_paths_generation;
>>
>>  /* This lock will have the grow table function as writer and add / delete nodes
>>   * as readers. RCU provides sufficient protection only when reading the table
>> @@ -410,6 +411,33 @@ mesh_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
>>  }
>>
>>  /**
>> + * mpp_path_lookup_by_idx - look up a path in the proxy path table by its index
>> + * @idx: index
>> + * @sdata: local subif, or NULL for all entries
>> + *
>> + * Returns: pointer to the proxy path structure, or NULL if not found.
>> + *
>> + * Locking: must be called within a read rcu section.
>> + */
>> +struct mesh_path *
>> +mpp_path_lookup_by_idx(struct ieee80211_sub_if_data *sdata, int idx)
>> +{
>> +       struct mesh_table *tbl = rcu_dereference(mpp_paths);
>> +       struct mpath_node *node;
>> +       int i;
>> +       int j = 0;
>> +
>> +       for_each_mesh_entry(tbl, node, i) {
>> +               if (sdata && node->mpath->sdata != sdata)
>> +                       continue;
>> +               if (j++ == idx)
>> +                       return node->mpath;
>> +       }
>> +
>> +       return NULL;
>> +}
>> +
>> +/**
>>   * mesh_path_add_gate - add the given mpath to a mesh gate to our path table
>>   * @mpath: gate path to add to table
>>   */
>> @@ -691,6 +719,9 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
>>
>>         spin_unlock(&tbl->hashwlock[hash_idx]);
>>         read_unlock_bh(&pathtbl_resize_lock);
>> +
>> +       mpp_paths_generation++;
>> +
>>         if (grow) {
>>                 set_bit(MESH_WORK_GROW_MPP_TABLE,  &ifmsh->wrkq_flags);
>>                 ieee80211_queue_work(&local->hw, &sdata->work);
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index df7b133..1e33f2f 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -4581,6 +4581,96 @@ static int nl80211_del_mpath(struct sk_buff *skb, struct genl_info *info)
>>         return rdev_del_mpath(rdev, dev, dst);
>>  }
>>
>> +static int nl80211_get_mpp(struct sk_buff *skb, struct genl_info *info)
>> +{
>> +       struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> +       int err;
>> +       struct net_device *dev = info->user_ptr[1];
>> +       struct mpath_info pinfo;
>> +       struct sk_buff *msg;
>> +       u8 *dst = NULL;
>> +       u8 mpp[ETH_ALEN];
>> +
>> +       memset(&pinfo, 0, sizeof(pinfo));
>> +
>> +       if (!info->attrs[NL80211_ATTR_MAC])
>> +               return -EINVAL;
>> +
>> +       dst = nla_data(info->attrs[NL80211_ATTR_MAC]);
>> +
>> +       if (!rdev->ops->get_mpp)
>> +               return -EOPNOTSUPP;
>> +
>> +       if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
>> +               return -EOPNOTSUPP;
>> +
>> +       err = rdev_get_mpp(rdev, dev, dst, mpp, &pinfo);
>> +       if (err)
>> +               return err;
>> +
>> +       msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> +       if (!msg)
>> +               return -ENOMEM;
>> +
>> +       if (nl80211_send_mpath(msg, info->snd_portid, info->snd_seq, 0,
>> +                              dev, dst, mpp, &pinfo) < 0) {
>> +               nlmsg_free(msg);
>> +               return -ENOBUFS;
>> +       }
>> +
>> +       return genlmsg_reply(msg, info);
>> +}
>> +
>> +static int nl80211_dump_mpp(struct sk_buff *skb,
>> +                           struct netlink_callback *cb)
>> +{
>> +       struct mpath_info pinfo;
>> +       struct cfg80211_registered_device *rdev;
>> +       struct wireless_dev *wdev;
>> +       u8 dst[ETH_ALEN];
>> +       u8 mpp[ETH_ALEN];
>> +       int path_idx = cb->args[2];
>> +       int err;
>> +
>> +       err = nl80211_prepare_wdev_dump(skb, cb, &rdev, &wdev);
>> +       if (err)
>> +               return err;
>> +
>> +       if (!rdev->ops->dump_mpp) {
>> +               err = -EOPNOTSUPP;
>> +               goto out_err;
>> +       }
>> +
>> +       if (wdev->iftype != NL80211_IFTYPE_MESH_POINT) {
>> +               err = -EOPNOTSUPP;
>> +               goto out_err;
>> +       }
>> +
>> +       while (1) {
>> +               err = rdev_dump_mpp(rdev, wdev->netdev, path_idx, dst,
>> +                                   mpp, &pinfo);
>> +               if (err == -ENOENT)
>> +                       break;
>> +               if (err)
>> +                       goto out_err;
>> +
>> +               if (nl80211_send_mpath(skb, NETLINK_CB(cb->skb).portid,
>> +                                      cb->nlh->nlmsg_seq, NLM_F_MULTI,
>> +                                      wdev->netdev, dst, mpp,
>> +                                      &pinfo) < 0)
>> +                       goto out;
>> +
>> +               path_idx++;
>> +       }
>> +
>> + out:
>> +       cb->args[2] = path_idx;
>> +       err = skb->len;
>> + out_err:
>> +       nl80211_finish_wdev_dump(rdev);
>> +       return err;
>> +}
>> +
>>  static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
>>  {
>>         struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> @@ -9603,6 +9693,15 @@ static const struct genl_ops nl80211_ops[] = {
>>                                   NL80211_FLAG_NEED_RTNL,
>>         },
>>         {
>> +               .cmd = NL80211_CMD_GET_MPP,
>> +               .doit = nl80211_get_mpp,
>> +               .dumpit = nl80211_dump_mpp,
>> +               .policy = nl80211_policy,
>> +               .flags = GENL_ADMIN_PERM,
>> +               .internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
>> +                                 NL80211_FLAG_NEED_RTNL,
>> +       },
>> +       {
>>                 .cmd = NL80211_CMD_SET_MPATH,
>>                 .doit = nl80211_set_mpath,
>>                 .policy = nl80211_policy,
>> diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
>> index 56c2240..e5560d5 100644
>> --- a/net/wireless/rdev-ops.h
>> +++ b/net/wireless/rdev-ops.h
>> @@ -263,6 +263,18 @@ static inline int rdev_get_mpath(struct cfg80211_registered_device *rdev,
>>
>>  }
>>
>> +static inline int rdev_get_mpp(struct cfg80211_registered_device *rdev,
>> +                              struct net_device *dev, u8 *dst, u8 *mpp,
>> +                              struct mpath_info *pinfo)
>> +{
>> +       int ret;
>> +
>> +       trace_rdev_get_mpp(&rdev->wiphy, dev, dst, mpp);
>> +       ret = rdev->ops->get_mpp(&rdev->wiphy, dev, dst, mpp, pinfo);
>> +       trace_rdev_return_int_mpath_info(&rdev->wiphy, ret, pinfo);
>> +       return ret;
>> +}
>> +
>>  static inline int rdev_dump_mpath(struct cfg80211_registered_device *rdev,
>>                                   struct net_device *dev, int idx, u8 *dst,
>>                                   u8 *next_hop, struct mpath_info *pinfo)
>> @@ -271,7 +283,20 @@ static inline int rdev_dump_mpath(struct cfg80211_registered_device *rdev,
>>         int ret;
>>         trace_rdev_dump_mpath(&rdev->wiphy, dev, idx, dst, next_hop);
>>         ret = rdev->ops->dump_mpath(&rdev->wiphy, dev, idx, dst, next_hop,
>> -                                    pinfo);
>> +                                   pinfo);
>> +       trace_rdev_return_int_mpath_info(&rdev->wiphy, ret, pinfo);
>> +       return ret;
>> +}
>> +
>> +static inline int rdev_dump_mpp(struct cfg80211_registered_device *rdev,
>> +                               struct net_device *dev, int idx, u8 *dst,
>> +                               u8 *mpp, struct mpath_info *pinfo)
>> +
>> +{
>> +       int ret;
>> +
>> +       trace_rdev_dump_mpp(&rdev->wiphy, dev, idx, dst, mpp);
>> +       ret = rdev->ops->dump_mpp(&rdev->wiphy, dev, idx, dst, mpp, pinfo);
>>         trace_rdev_return_int_mpath_info(&rdev->wiphy, ret, pinfo);
>>         return ret;
>>  }
>> diff --git a/net/wireless/trace.h b/net/wireless/trace.h
>> index 0c524cd..57ab727 100644
>> --- a/net/wireless/trace.h
>> +++ b/net/wireless/trace.h
>> @@ -801,6 +801,51 @@ TRACE_EVENT(rdev_dump_mpath,
>>                   MAC_PR_ARG(next_hop))
>>  );
>>
>> +TRACE_EVENT(rdev_get_mpp,
>> +       TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
>> +                u8 *dst, u8 *mpp),
>> +       TP_ARGS(wiphy, netdev, dst, mpp),
>> +       TP_STRUCT__entry(
>> +               WIPHY_ENTRY
>> +               NETDEV_ENTRY
>> +               MAC_ENTRY(dst)
>> +               MAC_ENTRY(mpp)
>> +       ),
>> +       TP_fast_assign(
>> +               WIPHY_ASSIGN;
>> +               NETDEV_ASSIGN;
>> +               MAC_ASSIGN(dst, dst);
>> +               MAC_ASSIGN(mpp, mpp);
>> +       ),
>> +       TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", destination: " MAC_PR_FMT
>> +                 ", mpp: " MAC_PR_FMT, WIPHY_PR_ARG, NETDEV_PR_ARG,
>> +                 MAC_PR_ARG(dst), MAC_PR_ARG(mpp))
>> +);
>> +
>> +TRACE_EVENT(rdev_dump_mpp,
>> +       TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, int idx,
>> +                u8 *dst, u8 *mpp),
>> +       TP_ARGS(wiphy, netdev, idx, mpp, dst),
>> +       TP_STRUCT__entry(
>> +               WIPHY_ENTRY
>> +               NETDEV_ENTRY
>> +               MAC_ENTRY(dst)
>> +               MAC_ENTRY(mpp)
>> +               __field(int, idx)
>> +       ),
>> +       TP_fast_assign(
>> +               WIPHY_ASSIGN;
>> +               NETDEV_ASSIGN;
>> +               MAC_ASSIGN(dst, dst);
>> +               MAC_ASSIGN(mpp, mpp);
>> +               __entry->idx = idx;
>> +       ),
>> +       TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", index: %d, destination: "
>> +                 MAC_PR_FMT ", mpp: " MAC_PR_FMT,
>> +                 WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->idx, MAC_PR_ARG(dst),
>> +                 MAC_PR_ARG(mpp))
>> +);
>> +
>>  TRACE_EVENT(rdev_return_int_mpath_info,
>>         TP_PROTO(struct wiphy *wiphy, int ret, struct mpath_info *pinfo),
>>         TP_ARGS(wiphy, ret, pinfo),
>> --
>> 1.9.1
>>
>>

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:32958 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaIJBLW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 21:11:22 -0400
Received: by mail-qa0-f49.google.com with SMTP id i13so1736660qae.36
        for <linux-wireless@vger.kernel.org>; Tue, 09 Sep 2014 18:11:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGnRvuo=jrtwK+WH1fh9pVRFY5jpE78Y=mWvy7pmChasKJ=O7g@mail.gmail.com>
References: <1410268021-9529-1-git-send-email-emmanuel.grumbach@intel.com> <CAGnRvuo=jrtwK+WH1fh9pVRFY5jpE78Y=mWvy7pmChasKJ=O7g@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 10 Sep 2014 11:11:01 +1000
Message-ID: <CAGRGNgUukF-qLVJ8REDXhm_rtXyudcrJTUjT9Z9+U6=SD=7dEA@mail.gmail.com> (sfid-20140910_031126_641789_9CE8F99F)
Subject: Re: [PATCH] cfg802111/nl80211: Add device motion indication API
To: Henning Rogge <hrogge@gmail.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henning,

On Wed, Sep 10, 2014 at 1:45 AM, Henning Rogge <hrogge@gmail.com> wrote:
> Hi,
>
> I am curious, what is the use case for this API? Is there really
> 802.11 hardware that tracks its physical motion?

I was thinking this might be useful for something like a combined WiFi
+ Bluetooth + cellular + GPS chipset in a tablet or laptop.

Thanks,

Julian Calaby


> Henning Rogge
>
> On Tue, Sep 9, 2014 at 3:07 PM, Emmanuel Grumbach
> <emmanuel.grumbach@intel.com> wrote:
>> From: Avraham Stern <avraham.stern@intel.com>
>>
>> Add API to notify user-space when the device is in motion
>> and the motion type.
>> This information can be used to react to the changing environment when
>> the device is on the move, or avoid some unnecessary activities when
>> the device is not moving. For example, longer scan intervals when the
>> device is not moving and there are probably no new AP's, shorter scan
>> intervals while the device is moving slowly and the environment is
>> constantly changing, and not scanning at all when the device is moving
>> fast and it is very unlikely to be able to connect to anything.
>>
>> Signed-off-by: Avraham Stern <avraham.stern@intel.com>
>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> ---
>>  include/net/cfg80211.h       | 14 ++++++++
>>  include/uapi/linux/nl80211.h | 39 ++++++++++++++++++++++
>>  net/wireless/core.h          |  2 ++
>>  net/wireless/nl80211.c       | 78 ++++++++++++++++++++++++++++++++++++++++++++
>>  net/wireless/trace.h         | 14 ++++++++
>>  5 files changed, 147 insertions(+)
>>
>> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
>> index b960c4d..6210822 100644
>> --- a/include/net/cfg80211.h
>> +++ b/include/net/cfg80211.h
>> @@ -4914,6 +4914,20 @@ void cfg80211_shutdown_all_interfaces(struct wiphy *wiphy);
>>  /* ethtool helper */
>>  void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info);
>>
>> +/*
>> + * cfg80211_device_motion_notify - notify device motion type
>> + *
>> + * @wiphy: the wiphy
>> + * @type: the motion type as specified in &enum nl80211_device_motion_type.
>> + * @gfp: allocation flags
>> + *
>> + * This function is used to report to userspace the type of motion the device
>> + * is currently in.
>> + */
>> +void cfg80211_device_motion_notify(struct wiphy *wiphy,
>> +                                  enum nl80211_device_motion_type type,
>> +                                  gfp_t gfp);
>> +
>>  /* Logging, debugging and troubleshooting/diagnostic helpers. */
>>
>>  /* wiphy_printk helpers, similar to dev_printk */
>> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
>> index 8270024..fae01c7 100644
>> --- a/include/uapi/linux/nl80211.h
>> +++ b/include/uapi/linux/nl80211.h
>> @@ -733,6 +733,19 @@
>>   *     QoS mapping is relevant for IP packets, it is only valid during an
>>   *     association. This is cleared on disassociation and AP restart.
>>   *
>> + * @NL80211_CMD_DEVICE_MOTION_NOTIFY: Device motion notification. This command
>> + *     is used as an event to indicate the motion type the device is currently
>> + *     in. This command can also be used by userspace to get the current
>> + *     motion type. The motion type is specified by the
>> + *     %NL80211_ATTR_DEVICE_MOTION_TYPE. This information can be used to react
>> + *     to the changing environment when the device is on the move, or avoid
>> + *     some unnecessary activities when the device is not moving. For example,
>> + *     longer scan intervals when the device is not moving and neighbor AP's
>> + *     probably stay the same, shorter scan intervals while the device is
>> + *     moving slowly and the environment is changing constantly, and not
>> + *     scanning at all when the device is moving fast and it is very unlikely
>> + *     to be able to connect to anything.
>> + *
>>   * @NL80211_CMD_MAX: highest used command number
>>   * @__NL80211_CMD_AFTER_LAST: internal use
>>   */
>> @@ -906,6 +919,8 @@ enum nl80211_commands {
>>
>>         NL80211_CMD_CH_SWITCH_STARTED_NOTIFY,
>>
>> +       NL80211_CMD_DEVICE_MOTION_NOTIFY,
>> +
>>         /* add new commands above here */
>>
>>         /* used to define NL80211_CMD_MAX below */
>> @@ -1620,6 +1635,9 @@ enum nl80211_commands {
>>   *     association request. In addition, it must also set the RRM capability
>>   *     flag in the association request's Capability Info field.
>>   *
>> + * @NL80211_ATTR_DEVICE_MOTION_TYPE: The type of motion the device is currently
>> + *     in. As specified in &enum nl80211_device_motion_type.
>> + *
>>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>>   * @__NL80211_ATTR_AFTER_LAST: internal use
>>   */
>> @@ -1964,6 +1982,8 @@ enum nl80211_attrs {
>>
>>         NL80211_ATTR_USE_RRM,
>>
>> +       NL80211_ATTR_DEVICE_MOTION_TYPE,
>> +
>>         /* add attributes here, update the policy in nl80211.c */
>>
>>         __NL80211_ATTR_AFTER_LAST,
>> @@ -4223,4 +4243,23 @@ enum nl80211_tdls_peer_capability {
>>         NL80211_TDLS_PEER_WMM = 1<<2,
>>  };
>>
>> +/**
>> + * enum nl80211_device_motion_type - device motion types
>> + * @NL80211_DEVICE_MOTION_TYPE_UNKNOWN: The device motion type is not known
>> + *     or has not been set yet.
>> + * @NL80211_DEVICE_MOTION_TYPE_NOT_MOVING: The device is not moving. This
>> + *     includes cases in which the device is moving but its immediate
>> + *     environment is moving as well, e.g. while on board a train.
>> + * @NL80211_DEVICE_MOTION_TYPE_MOVING_SLOWLY: The device is moving slowly enough
>> + *     to keep track of the changing environment.
>> + * @NL80211_DEVICE_MOTION_TYPE_MOVING_FAST: The device is moving fast which
>> + *     makes it hard to keep track of the changing environment.
>> + */
>> +enum nl80211_device_motion_type {
>> +       NL80211_DEVICE_MOTION_TYPE_UNKNOWN,
>> +       NL80211_DEVICE_MOTION_TYPE_NOT_MOVING,
>> +       NL80211_DEVICE_MOTION_TYPE_MOVING_SLOWLY,
>> +       NL80211_DEVICE_MOTION_TYPE_MOVING_FAST,
>> +};
>> +
>>  #endif /* __LINUX_NL80211_H */
>> diff --git a/net/wireless/core.h b/net/wireless/core.h
>> index 21d4b1d..a00be85 100644
>> --- a/net/wireless/core.h
>> +++ b/net/wireless/core.h
>> @@ -84,6 +84,8 @@ struct cfg80211_registered_device {
>>         struct list_head destroy_list;
>>         struct work_struct destroy_work;
>>
>> +       enum nl80211_device_motion_type motion_type;
>> +
>>         /* must be last because of the way we do wiphy_priv(),
>>          * and it should at least be aligned to NETDEV_ALIGN */
>>         struct wiphy wiphy __aligned(NETDEV_ALIGN);
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index 03b5b5e..c7c014c 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -9451,6 +9451,48 @@ static int nl80211_set_qos_map(struct sk_buff *skb,
>>         return ret;
>>  }
>>
>> +static int nl80211_send_motion(struct sk_buff *msg, u32 portid, u32 seq,
>> +                              int flags,
>> +                              struct cfg80211_registered_device *rdev)
>> +{
>> +       void *hdr;
>> +
>> +       hdr = nl80211hdr_put(msg, portid, seq, flags,
>> +                            NL80211_CMD_DEVICE_MOTION_NOTIFY);
>> +       if (!hdr)
>> +               return -ENOBUFS;
>> +
>> +       if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
>> +           nla_put_u32(msg, NL80211_ATTR_DEVICE_MOTION_TYPE,
>> +                       rdev->motion_type))
>> +               goto nla_put_failure;
>> +
>> +       return genlmsg_end(msg, hdr);
>> +
>> + nla_put_failure:
>> +       genlmsg_cancel(msg, hdr);
>> +       return -ENOBUFS;
>> +}
>> +
>> +static int nl80211_device_motion_notify(struct sk_buff *skb,
>> +                                       struct genl_info *info)
>> +{
>> +       struct sk_buff *msg;
>> +       struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> +
>> +       msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> +       if (!msg)
>> +               return -ENOMEM;
>> +
>> +       if (nl80211_send_motion(msg, genl_info_snd_portid(info), info->snd_seq,
>> +                               0, rdev) < 0) {
>> +               nlmsg_free(msg);
>> +               return -ENOBUFS;
>> +       }
>> +
>> +       return genlmsg_reply(msg, info);
>> +}
>> +
>>  #define NL80211_FLAG_NEED_WIPHY                0x01
>>  #define NL80211_FLAG_NEED_NETDEV       0x02
>>  #define NL80211_FLAG_NEED_RTNL         0x04
>> @@ -10197,6 +10239,14 @@ static __genl_const struct genl_ops nl80211_ops[] = {
>>                 .internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
>>                                   NL80211_FLAG_NEED_RTNL,
>>         },
>> +       {
>> +               .cmd = NL80211_CMD_DEVICE_MOTION_NOTIFY,
>> +               .doit = nl80211_device_motion_notify,
>> +               .policy = nl80211_policy,
>> +               .flags = GENL_ADMIN_PERM,
>> +               .internal_flags = NL80211_FLAG_NEED_WIPHY |
>> +                                 NL80211_FLAG_NEED_RTNL,
>> +       },
>>  };
>>
>>  /* notification functions */
>> @@ -12004,6 +12054,34 @@ void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp)
>>  }
>>  EXPORT_SYMBOL(cfg80211_crit_proto_stopped);
>>
>> +void cfg80211_device_motion_notify(struct wiphy *wiphy,
>> +                                  enum nl80211_device_motion_type type,
>> +                                  gfp_t gfp)
>> +{
>> +       struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
>> +       struct sk_buff *msg;
>> +
>> +       trace_cfg80211_device_motion_notify(wiphy, type);
>> +
>> +       if (rdev->motion_type == type)
>> +               return;
>> +
>> +       rdev->motion_type = type;
>> +
>> +       msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
>> +       if (!msg)
>> +               return;
>> +
>> +       if (nl80211_send_motion(msg, 0, 0, 0, rdev) < 0) {
>> +               nlmsg_free(msg);
>> +               return;
>> +       }
>> +
>> +       genlmsg_multicast_netns(&nl80211_fam, wiphy_net(wiphy), msg, 0,
>> +                               NL80211_MCGRP_SCAN, gfp);
>> +}
>> +EXPORT_SYMBOL(cfg80211_device_motion_notify);
>> +
>>  void nl80211_send_ap_stopped(struct wireless_dev *wdev)
>>  {
>>         struct wiphy *wiphy = wdev->wiphy;
>> diff --git a/net/wireless/trace.h b/net/wireless/trace.h
>> index 0f0901e..e39a950 100644
>> --- a/net/wireless/trace.h
>> +++ b/net/wireless/trace.h
>> @@ -2627,6 +2627,20 @@ TRACE_EVENT(cfg80211_stop_iface,
>>                   WIPHY_PR_ARG, WDEV_PR_ARG)
>>  );
>>
>> +TRACE_EVENT(cfg80211_device_motion_notify,
>> +       TP_PROTO(struct wiphy *wiphy, enum nl80211_device_motion_type type),
>> +       TP_ARGS(wiphy, type),
>> +       TP_STRUCT__entry(
>> +               WIPHY_ENTRY
>> +               __field(enum nl80211_device_motion_type, type)
>> +       ),
>> +       TP_fast_assign(
>> +               WIPHY_ASSIGN;
>> +               __entry->type = type;
>> +       ),
>> +       TP_printk(WIPHY_PR_FMT ", type: %d", WIPHY_PR_ARG, __entry->type)
>> +);
>> +
>>  #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
>>
>>  #undef TRACE_INCLUDE_PATH
>> --
>> 1.9.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/

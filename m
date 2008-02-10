Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:24334 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbYBJQay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 11:30:54 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1642026wah.23
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 08:30:54 -0800 (PST)
Message-ID: <1ba2fa240802100830t772b245fgf9e54ae058b384fa@mail.gmail.com> (sfid-20080210_163103_969483_C5C968DF)
Date: Sun, 10 Feb 2008 18:30:53 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211: net_sched vs. HT
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1202489552.24811.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1202489552.24811.10.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 8, 2008 6:52 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi,
>
> I'm currently evaluating moving to multiqueue netdevs (already have
> preliminary non-working patches) and am a bit confused. You have made
> dummy stubs for all the functions in wme.c that can't be defined without
> NET_SCHED. However, from all I can tell the 11n standard requires valid
> HT STAs to be QoS STAs; are we a valid QoS STA if we don't support
> multiple outgoing queues?

I don't really follow your question. The dummy functions in wme.h for
wme were there before we added only ht functions.
WME i.e. QoS is not defined when NET_SCHED is not defined. This is
more for code completeness then for anything else, in fact with do not
compile mac80211 without NET_SCHED support
Valid QoS STA  is when there is  QoS association and support 4 AC, etc

> My current plan involves registering the master netdev with as many
> queues as we have hardware queues and having the 802.11 qdisc live on
> top of that, allowing to change queue access parameters through the
> qdisc (for hostapd). The qdisc would be classful and have as many bands
> as queues that allow access parameter configuration (txop, cwmin etc.,
> I'm assuming here that the iwlwifi hw doesn't allow access parameter
> configuration on all queues since the extra queues are only used for
> ampdu)
>

AMPDU queues and also 4 AC queues are after all funneled to 4 AC lower
level queues we called them TX FIFOS, which are configured according
QoS parameters (not upper queues, but that's transparent). The major
purpose of AMPDU queue is handling reordering not AC.  AMDPU queue is
defined by Receiving address  TID pair.  RA/TID pair. Instead of
single packet the whole aggregation is transmitted as whole therefore
cannot be interleaved with packets from  another RA/TID.
The mapping between queue and RA/TID is dynamic according established
BA session. HW supports only limited number of queues therefore driver
cannot establish concurrently more sessions then number of supported
AMPDU queues.

In general for example in AP mode you would need to handle <number of
associated station>x<#TID=8> AMPDU queues which can come to a horrible
number.
The limited number of queues is acceptable again due to fact that
medium is shared and you cannot really utilize too many BA ssessions
at the same time. Some policy of eviction based on link quality is
required and still not implemented.




> Below is my current version of the patch, I've split up "queues" into
> "queues" and "ampdu_queues" (but not implemented that in iwlwifi yet)
That's fine

> I have no intentions of pushing this too soon, in fact, I'm not sure we
> can pull it off for 2.6.26, but wanted you to be aware of it.
I hope we can.

Thanks
Tomas

> johannes
>
> ---
>  drivers/net/wireless/adm8211.c              |    7 -
>  drivers/net/wireless/ath5k/base.c           |   10 +-
>  drivers/net/wireless/ath5k/base.h           |    4
>  drivers/net/wireless/b43/dma.c              |   15 +--
>  drivers/net/wireless/b43/main.c             |    3
>  drivers/net/wireless/b43legacy/dma.c        |   14 +-
>  drivers/net/wireless/b43legacy/main.c       |    3
>  drivers/net/wireless/b43legacy/pio.c        |    7 -
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |   17 +--
>  drivers/net/wireless/iwlwifi/iwl4965-base.c |   17 +--
>  drivers/net/wireless/p54.h                  |    2
>  drivers/net/wireless/p54common.c            |   34 +++---
>  drivers/net/wireless/rt2x00/rt2400pci.c     |   27 ++---
>  drivers/net/wireless/rt2x00/rt2500pci.c     |   21 +---
>  drivers/net/wireless/rt2x00/rt2500usb.c     |   11 --
>  drivers/net/wireless/rt2x00/rt2x00.h        |    5 -
>  drivers/net/wireless/rt2x00/rt2x00dev.c     |    8 -
>  drivers/net/wireless/rt2x00/rt2x00mac.c     |   25 ++---
>  drivers/net/wireless/rt2x00/rt2x00pci.c     |   14 ++
>  drivers/net/wireless/rt2x00/rt2x00usb.c     |   11 +-
>  drivers/net/wireless/rt2x00/rt61pci.c       |   19 +--
>  drivers/net/wireless/rt2x00/rt73usb.c       |   11 --
>  drivers/net/wireless/rtl8180_dev.c          |    4
>  include/net/mac80211.h                      |   82 +++++-----------
>  net/mac80211/Kconfig                        |    7 +
>  net/mac80211/Makefile                       |    2
>  net/mac80211/debugfs.c                      |   44 --------
>  net/mac80211/debugfs_sta.c                  |   38 -------
>  net/mac80211/ieee80211.c                    |   19 +--
>  net/mac80211/ieee80211_i.h                  |   16 ---
>  net/mac80211/ieee80211_sta.c                |   24 +---
>  net/mac80211/rx.c                           |    5 -
>  net/mac80211/sta_info.h                     |    9 -
>  net/mac80211/tx.c                           |  138 ++--------------------------
>  net/mac80211/util.c                         |   58 +++++++----
>  net/mac80211/wme.c                          |   79 +++++-----------
>  net/mac80211/wme.h                          |    6 -
>  37 files changed, 260 insertions(+), 556 deletions(-)
>
> --- everything.orig/net/mac80211/wme.c  2008-02-08 13:29:31.742022407 +0100
> +++ everything/net/mac80211/wme.c       2008-02-08 14:03:58.172002441 +0100
> @@ -18,17 +18,20 @@
>  #include "ieee80211_i.h"
>  #include "wme.h"
>
> -/* maximum number of hardware queues we support. */
> -#define TC_80211_MAX_QUEUES 16
> -
> +/*
> + * Default mapping in classifier to work with default
> + * queue setup.
> + */
>  const int ieee802_1d_to_ac[8] = { 2, 3, 3, 2, 1, 1, 0, 0 };
>
> +#define QD_MAX_QUEUES (IEEE80211_MAX_AMPDU_QUEUES + IEEE80211_MAX_QUEUES)
> +
>  struct ieee80211_sched_data
>  {
>         unsigned long qdisc_pool;
>         struct tcf_proto *filter_list;
> -       struct Qdisc *queues[TC_80211_MAX_QUEUES];
> -       struct sk_buff_head requeued[TC_80211_MAX_QUEUES];
> +       struct Qdisc *queues[QD_MAX_QUEUES];
> +       struct sk_buff_head requeued[QD_MAX_QUEUES];
>  };
>
>  static const char llc_ip_hdr[8] = {0xAA, 0xAA, 0x3, 0, 0, 0, 0x08, 0};
> @@ -95,7 +98,7 @@ static inline int wme_downgrade_ac(struc
>
>  /* positive return value indicates which queue to use
>   * negative return value indicates to drop the frame */
> -static inline int classify80211(struct sk_buff *skb, struct Qdisc *qd)
> +static int classify80211(struct sk_buff *skb, struct Qdisc *qd)
>  {
>         struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
>         struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> @@ -106,7 +109,7 @@ static inline int classify80211(struct s
>         if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA)) {
>                 /* management frames go on AC_VO queue, but are sent
>                 * without QoS control fields */
> -               return IEEE80211_TX_QUEUE_DATA0;
> +               return 0;
>         }
>
>         if (0 /* injected */) {
> @@ -147,12 +150,13 @@ static int wme_qdiscop_enqueue(struct sk
>         struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>         unsigned short fc = le16_to_cpu(hdr->frame_control);
>         struct Qdisc *qdisc;
> -       int err, queue;
> +       int err;
> +       int queue;
>         struct sta_info *sta;
>         u8 tid;
>
>         if (pkt_data->flags & IEEE80211_TXPD_REQUEUE) {
> -               queue = pkt_data->queue;
> +               queue = skb->queue_mapping;
>                 sta = sta_info_get(local, hdr->addr1);
>                 tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
>                 if (sta) {
> @@ -217,7 +221,7 @@ static int wme_qdiscop_enqueue(struct sk
>                         err = NET_XMIT_DROP;
>         } else {
>                 tid = skb->priority & QOS_CONTROL_TAG1D_MASK;
> -               pkt_data->queue = (unsigned int) queue;
> +               skb->queue_mapping = (u16) queue;
>                 qdisc = q->queues[queue];
>                 err = qdisc->enqueue(skb, qdisc);
>                 if (err == NET_XMIT_SUCCESS) {
> @@ -238,13 +242,11 @@ static int wme_qdiscop_enqueue(struct sk
>  static int wme_qdiscop_requeue(struct sk_buff *skb, struct Qdisc* qd)
>  {
>         struct ieee80211_sched_data *q = qdisc_priv(qd);
> -       struct ieee80211_tx_packet_data *pkt_data =
> -               (struct ieee80211_tx_packet_data *) skb->cb;
>         struct Qdisc *qdisc;
>         int err;
>
>         /* we recorded which queue to use earlier! */
> -       qdisc = q->queues[pkt_data->queue];
> +       qdisc = q->queues[skb->queue_mapping];
>
>         if ((err = qdisc->ops->requeue(skb, qdisc)) == 0) {
>                 qd->q.qlen++;
> @@ -268,11 +270,7 @@ static struct sk_buff *wme_qdiscop_deque
>         /* check all the h/w queues in numeric/priority order */
>         for (queue = 0; queue < hw->queues; queue++) {
>                 /* see if there is room in this hardware queue */
> -               if ((test_bit(IEEE80211_LINK_STATE_XOFF,
> -                               &local->state[queue])) ||
> -                   (test_bit(IEEE80211_LINK_STATE_PENDING,
> -                               &local->state[queue])) ||
> -                        (!test_bit(queue, &q->qdisc_pool)))
> +               if (__netif_subqueue_stopped(local->mdev, queue))
>                         continue;
>
>                 /* there is space - try and get a frame */
> @@ -333,17 +331,6 @@ static void wme_qdiscop_destroy(struct Q
>  /* called whenever parameters are updated on existing qdisc */
>  static int wme_qdiscop_tune(struct Qdisc *qd, struct rtattr *opt)
>  {
> -/*     struct ieee80211_sched_data *q = qdisc_priv(qd);
> -*/
> -       /* check our options block is the right size */
> -       /* copy any options to our local structure */
> -/*     Ignore options block for now - always use static mapping
> -       struct tc_ieee80211_qopt *qopt = RTA_DATA(opt);
> -
> -       if (opt->rta_len < RTA_LENGTH(sizeof(*qopt)))
> -               return -EINVAL;
> -       memcpy(q->tag2queue, qopt->tag2queue, sizeof(qopt->tag2queue));
> -*/
>         return 0;
>  }
>
> @@ -362,26 +349,24 @@ static int wme_qdiscop_init(struct Qdisc
>             dev->ieee80211_ptr->wiphy->privid != mac80211_wiphy_privid)
>                 return -EINVAL;
>
> -       /* check this device is an ieee80211 master type device */
> -       if (dev->type != ARPHRD_IEEE80211)
> +       local = wdev_priv(dev->ieee80211_ptr);
> +
> +       /* only allow on master dev */
> +       if (dev != local->mdev)
>                 return -EINVAL;
>
> -       /* check that there is no qdisc currently attached to device
> -        * this ensures that we will be the root qdisc. (I can't find a better
> -        * way to test this explicitly) */
> -       if (dev->qdisc_sleeping != &noop_qdisc)
> +       /* ensure that we are root qdisc */
> +       if (qd->parent != TC_H_ROOT)
>                 return -EINVAL;
>
>         if (qd->flags & TCQ_F_INGRESS)
>                 return -EINVAL;
>
> -       local = wdev_priv(dev->ieee80211_ptr);
>         queues = local->hw.queues;
>
>         /* if options were passed in, set them */
> -       if (opt) {
> +       if (opt)
>                 err = wme_qdiscop_tune(qd, opt);
> -       }
>
>         /* create child queues */
>         for (i = 0; i < queues; i++) {
> @@ -394,25 +379,11 @@ static int wme_qdiscop_init(struct Qdisc
>                 }
>         }
>
> -       /* reserve all legacy QoS queues */
> -       for (i = 0; i < min(IEEE80211_TX_QUEUE_DATA4, queues); i++)
> -               set_bit(i, &q->qdisc_pool);
> -
>         return err;
>  }
>
>  static int wme_qdiscop_dump(struct Qdisc *qd, struct sk_buff *skb)
>  {
> -/*     struct ieee80211_sched_data *q = qdisc_priv(qd);
> -       unsigned char *p = skb->tail;
> -       struct tc_ieee80211_qopt opt;
> -
> -       memcpy(&opt.tag2queue, q->tag2queue, TC_80211_MAX_TAG + 1);
> -       RTA_PUT(skb, TCA_OPTIONS, sizeof(opt), &opt);
> -*/     return skb->len;
> -/*
> -rtattr_failure:
> -       skb_trim(skb, p - skb->data);*/
>         return -1;
>  }
>
> @@ -653,10 +624,10 @@ int ieee80211_ht_agg_queue_add(struct ie
>         DECLARE_MAC_BUF(mac);
>
>         /* prepare the filter and save it for the SW queue
> -        * matching the recieved HW queue */
> +        * matching the received HW queue */
>
>         /* try to get a Qdisc from the pool */
> -       for (i = IEEE80211_TX_QUEUE_BEACON; i < local->hw.queues; i++)
> +       for (i = 0; i < local->hw.ampdu_queues; i++)
>                 if (!test_and_set_bit(i, &q->qdisc_pool)) {
>                         ieee80211_stop_queue(local_to_hw(local), i);
>                         sta->tid_to_tx_q[tid] = i;
> --- everything.orig/net/mac80211/wme.h  2008-02-08 13:29:31.762003418 +0100
> +++ everything/net/mac80211/wme.h       2008-02-08 14:03:58.172002441 +0100
> @@ -39,7 +39,8 @@ int ieee80211_ht_agg_queue_add(struct ie
>  void ieee80211_ht_agg_queue_remove(struct ieee80211_local *local,
>                                    struct sta_info *sta, u16 tid,
>                                    u8 requeue);
> -void ieee80211_requeue(struct ieee80211_local *local, int queue);
> +void ieee80211_requeue(struct ieee80211_local *local,
> +                      int queue);
>  int ieee80211_wme_register(void);
>  void ieee80211_wme_unregister(void);
>  #else
> @@ -60,7 +61,8 @@ static inline void ieee80211_ht_agg_queu
>                                                  u8 requeue)
>  {
>  }
> -static inline void ieee80211_requeue(struct ieee80211_local *local, int queue)
> +static inline void ieee80211_requeue(struct ieee80211_local *local,
> +                                    int queue)
>  {
>  }
>  static inline int ieee80211_wme_register(void)
> --- everything.orig/include/net/mac80211.h      2008-02-08 13:36:26.182000814 +0100
> +++ everything/include/net/mac80211.h   2008-02-08 14:29:23.642004666 +0100
> @@ -86,6 +86,18 @@ struct ieee80211_ht_bss_info {
>  };
>
>  /**
> + * enum ieee80211_max_queues - maximum number of queues
> + *
> + * @IEEE80211_MAX_QUEUES: Maximum number of regular device queues.
> + * @IEEE80211_MAX_AMPDU_QUEUES: Maximum number of queues usable
> + *     for A-MPDU operation.
> + */
> +enum ieee80211_max_queues {
> +       IEEE80211_MAX_QUEUES =          16,
> +       IEEE80211_MAX_AMPDU_QUEUES =    16,
> +};
> +
> +/**
>   * struct ieee80211_tx_queue_params - transmit queue configuration
>   *
>   * The information provided in this structure is required for QoS
> @@ -105,58 +117,18 @@ struct ieee80211_tx_queue_params {
>  };
>
>  /**
> - * struct ieee80211_tx_queue_stats_data - transmit queue statistics
> + * struct ieee80211_tx_queue_stats - transmit queue statistics
>   *
>   * @len: number of packets in queue
>   * @limit: queue length limit
>   * @count: number of frames sent
>   */
> -struct ieee80211_tx_queue_stats_data {
> +struct ieee80211_tx_queue_stats {
>         unsigned int len;
>         unsigned int limit;
>         unsigned int count;
>  };
>
> -/**
> - * enum ieee80211_tx_queue - transmit queue number
> - *
> - * These constants are used with some callbacks that take a
> - * queue number to set parameters for a queue.
> - *
> - * @IEEE80211_TX_QUEUE_DATA0: data queue 0
> - * @IEEE80211_TX_QUEUE_DATA1: data queue 1
> - * @IEEE80211_TX_QUEUE_DATA2: data queue 2
> - * @IEEE80211_TX_QUEUE_DATA3: data queue 3
> - * @IEEE80211_TX_QUEUE_DATA4: data queue 4
> - * @IEEE80211_TX_QUEUE_SVP: ??
> - * @NUM_TX_DATA_QUEUES: number of data queues
> - * @IEEE80211_TX_QUEUE_AFTER_BEACON: transmit queue for frames to be
> - *     sent after a beacon
> - * @IEEE80211_TX_QUEUE_BEACON: transmit queue for beacon frames
> - * @NUM_TX_DATA_QUEUES_AMPDU: adding more queues for A-MPDU
> - */
> -enum ieee80211_tx_queue {
> -       IEEE80211_TX_QUEUE_DATA0,
> -       IEEE80211_TX_QUEUE_DATA1,
> -       IEEE80211_TX_QUEUE_DATA2,
> -       IEEE80211_TX_QUEUE_DATA3,
> -       IEEE80211_TX_QUEUE_DATA4,
> -       IEEE80211_TX_QUEUE_SVP,
> -
> -       NUM_TX_DATA_QUEUES,
> -
> -/* due to stupidity in the sub-ioctl userspace interface, the items in
> - * this struct need to have fixed values. As soon as it is removed, we can
> - * fix these entries. */
> -       IEEE80211_TX_QUEUE_AFTER_BEACON = 6,
> -       IEEE80211_TX_QUEUE_BEACON = 7,
> -       NUM_TX_DATA_QUEUES_AMPDU = 16
> -};
> -
> -struct ieee80211_tx_queue_stats {
> -       struct ieee80211_tx_queue_stats_data data[NUM_TX_DATA_QUEUES_AMPDU];
> -};
> -
>  struct ieee80211_low_level_stats {
>         unsigned int dot11ACKFailureCount;
>         unsigned int dot11RTSFailureCount;
> @@ -252,9 +224,6 @@ struct ieee80211_tx_control {
>         u8 antenna_sel_tx;      /* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
>         u8 icv_len;             /* length of the ICV/MIC field in octets */
>         u8 iv_len;              /* length of the IV field in octets */
> -       u8 queue;               /* hardware queue to use for this frame;
> -                                * 0 = highest, hw->queues-1 = lowest */
> -       int type;       /* internal */
>  };
>
>
> @@ -351,8 +320,6 @@ enum ieee80211_tx_status_flags {
>   * @ampdu_ack_map: block ack bit map for the aggregation.
>   *     relevant only if IEEE80211_TX_STATUS_AMPDU was set.
>   * @ack_signal: signal strength of the ACK frame
> - * @queue_length: ?? REMOVE
> - * @queue_number: ?? REMOVE
>   */
>  struct ieee80211_tx_status {
>         struct ieee80211_tx_control control;
> @@ -362,8 +329,6 @@ struct ieee80211_tx_status {
>         u8 ampdu_ack_len;
>         u64 ampdu_ack_map;
>         int ack_signal;
> -       int queue_length;
> -       int queue_number;
>  };
>
>  /**
> @@ -683,7 +648,12 @@ enum ieee80211_hw_flags {
>   * @max_noise: like @max_rssi, but for the noise value.
>   *
>   * @queues: number of available hardware transmit queues for
> - *     data packets. WMM/QoS requires at least four.
> + *     data packets. WMM/QoS requires at least four, these
> + *     queues need to have configurable access parameters.
> + *
> + * @ampdu_queues: number of available hardware transmit queues
> + *     for A-MPDU packets, these have no access parameters
> + *     because they're used only for A-MPDU frames.
>   *
>   * @rate_control_algorithm: rate control algorithm for this hardware.
>   *     If unset (NULL), the default algorithm will be used. Must be
> @@ -702,7 +672,7 @@ struct ieee80211_hw {
>         unsigned int extra_tx_headroom;
>         int channel_change_time;
>         int vif_data_size;
> -       u8 queues;
> +       u16 queues, ampdu_queues;
>         s8 max_rssi;
>         s8 max_signal;
>         s8 max_noise;
> @@ -957,15 +927,13 @@ enum ieee80211_ampdu_mlme_action {
>   *     of assocaited station or AP.
>   *
>   * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
> - *     bursting) for a hardware TX queue. The @queue parameter uses the
> - *     %IEEE80211_TX_QUEUE_* constants. Must be atomic.
> + *     bursting) for a hardware TX queue. Must be atomic.
>   *
>   * @get_tx_stats: Get statistics of the current TX queue status. This is used
>   *     to get number of currently queued packets (queue length), maximum queue
>   *     size (limit), and total number of packets sent using each TX queue
> - *     (count). This information is used for WMM to find out which TX
> - *     queues have room for more packets and by hostapd to provide
> - *     statistics about the current queueing state to external programs.
> + *     (count). The 'stats' pointer points to an array that has hw->queues +
> + *     hw->ampdu_queues items.
>   *
>   * @get_tsf: Get the current TSF timer value from firmware/hardware. Currently,
>   *     this is only used for IBSS mode debugging and, as such, is not a
> @@ -1036,7 +1004,7 @@ struct ieee80211_ops {
>                                u32 short_retry, u32 long_retr);
>         void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>                         enum sta_notify_cmd, const u8 *addr);
> -       int (*conf_tx)(struct ieee80211_hw *hw, int queue,
> +       int (*conf_tx)(struct ieee80211_hw *hw, u16 queue,
>                        const struct ieee80211_tx_queue_params *params);
>         int (*get_tx_stats)(struct ieee80211_hw *hw,
>                             struct ieee80211_tx_queue_stats *stats);
> --- everything.orig/net/mac80211/Kconfig        2008-02-08 13:29:31.812005154 +0100
> +++ everything/net/mac80211/Kconfig     2008-02-08 14:03:58.232000705 +0100
> @@ -7,11 +7,16 @@ config MAC80211
>         select CRC32
>         select WIRELESS_EXT
>         select CFG80211
> -       select NET_SCH_FIFO
>         ---help---
>           This option enables the hardware independent IEEE 802.11
>           networking stack.
>
> +config MAC80211_QOS
> +       def_bool y
> +       depends on MAC80211
> +       depends on NET_SCHED
> +       depends on NETDEVICES_MULTIQUEUE
> +
>  menu "Rate control algorithm selection"
>         depends on MAC80211 != n
>
> --- everything.orig/net/mac80211/Makefile       2008-02-08 13:29:31.852027995 +0100
> +++ everything/net/mac80211/Makefile    2008-02-08 14:03:58.242111599 +0100
> @@ -29,7 +29,7 @@ mac80211-y := \
>         event.o
>
>  mac80211-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
> -mac80211-$(CONFIG_NET_SCHED) += wme.o
> +mac80211-$(CONFIG_MAC80211_QOS) += wme.o
>  mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
>         debugfs.o \
>         debugfs_sta.o \
> --- everything.orig/net/mac80211/debugfs.c      2008-02-08 13:29:31.892004557 +0100
> +++ everything/net/mac80211/debugfs.c   2008-02-08 14:03:58.242111599 +0100
> @@ -196,46 +196,6 @@ DEBUGFS_STATS_FILE(rx_handlers_fragments
>                    local->rx_handlers_fragments);
>  DEBUGFS_STATS_FILE(tx_status_drop, 20, "%u",
>                    local->tx_status_drop);
> -
> -static ssize_t stats_wme_rx_queue_read(struct file *file,
> -                                      char __user *userbuf,
> -                                      size_t count, loff_t *ppos)
> -{
> -       struct ieee80211_local *local = file->private_data;
> -       char buf[NUM_RX_DATA_QUEUES*15], *p = buf;
> -       int i;
> -
> -       for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
> -               p += scnprintf(p, sizeof(buf)+buf-p,
> -                              "%u\n", local->wme_rx_queue[i]);
> -
> -       return simple_read_from_buffer(userbuf, count, ppos, buf, p-buf);
> -}
> -
> -static const struct file_operations stats_wme_rx_queue_ops = {
> -       .read = stats_wme_rx_queue_read,
> -       .open = mac80211_open_file_generic,
> -};
> -
> -static ssize_t stats_wme_tx_queue_read(struct file *file,
> -                                      char __user *userbuf,
> -                                      size_t count, loff_t *ppos)
> -{
> -       struct ieee80211_local *local = file->private_data;
> -       char buf[NUM_TX_DATA_QUEUES*15], *p = buf;
> -       int i;
> -
> -       for (i = 0; i < NUM_TX_DATA_QUEUES; i++)
> -               p += scnprintf(p, sizeof(buf)+buf-p,
> -                              "%u\n", local->wme_tx_queue[i]);
> -
> -       return simple_read_from_buffer(userbuf, count, ppos, buf, p-buf);
> -}
> -
> -static const struct file_operations stats_wme_tx_queue_ops = {
> -       .read = stats_wme_tx_queue_read,
> -       .open = mac80211_open_file_generic,
> -};
>  #endif
>
>  DEBUGFS_DEVSTATS_FILE(dot11ACKFailureCount);
> @@ -303,8 +263,6 @@ void debugfs_hw_add(struct ieee80211_loc
>         DEBUGFS_STATS_ADD(rx_expand_skb_head2);
>         DEBUGFS_STATS_ADD(rx_handlers_fragments);
>         DEBUGFS_STATS_ADD(tx_status_drop);
> -       DEBUGFS_STATS_ADD(wme_tx_queue);
> -       DEBUGFS_STATS_ADD(wme_rx_queue);
>  #endif
>         DEBUGFS_STATS_ADD(dot11ACKFailureCount);
>         DEBUGFS_STATS_ADD(dot11RTSFailureCount);
> @@ -356,8 +314,6 @@ void debugfs_hw_del(struct ieee80211_loc
>         DEBUGFS_STATS_DEL(rx_expand_skb_head2);
>         DEBUGFS_STATS_DEL(rx_handlers_fragments);
>         DEBUGFS_STATS_DEL(tx_status_drop);
> -       DEBUGFS_STATS_DEL(wme_tx_queue);
> -       DEBUGFS_STATS_DEL(wme_rx_queue);
>  #endif
>         DEBUGFS_STATS_DEL(dot11ACKFailureCount);
>         DEBUGFS_STATS_DEL(dot11RTSFailureCount);
> --- everything.orig/net/mac80211/debugfs_sta.c  2008-02-08 13:29:31.922003472 +0100
> +++ everything/net/mac80211/debugfs_sta.c       2008-02-08 14:03:58.242111599 +0100
> @@ -149,36 +149,6 @@ static ssize_t sta_last_seq_ctrl_read(st
>  }
>  STA_OPS(last_seq_ctrl);
>
> -#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
> -static ssize_t sta_wme_rx_queue_read(struct file *file, char __user *userbuf,
> -                                    size_t count, loff_t *ppos)
> -{
> -       char buf[15*NUM_RX_DATA_QUEUES], *p = buf;
> -       int i;
> -       struct sta_info *sta = file->private_data;
> -       for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
> -               p += scnprintf(p, sizeof(buf)+buf-p, "%u ",
> -                              sta->wme_rx_queue[i]);
> -       p += scnprintf(p, sizeof(buf)+buf-p, "\n");
> -       return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
> -}
> -STA_OPS(wme_rx_queue);
> -
> -static ssize_t sta_wme_tx_queue_read(struct file *file, char __user *userbuf,
> -                                    size_t count, loff_t *ppos)
> -{
> -       char buf[15*NUM_TX_DATA_QUEUES], *p = buf;
> -       int i;
> -       struct sta_info *sta = file->private_data;
> -       for (i = 0; i < NUM_TX_DATA_QUEUES; i++)
> -               p += scnprintf(p, sizeof(buf)+buf-p, "%u ",
> -                              sta->wme_tx_queue[i]);
> -       p += scnprintf(p, sizeof(buf)+buf-p, "\n");
> -       return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
> -}
> -STA_OPS(wme_tx_queue);
> -#endif
> -
>  static ssize_t sta_agg_status_read(struct file *file, char __user *userbuf,
>                                         size_t count, loff_t *ppos)
>  {
> @@ -315,10 +285,6 @@ void ieee80211_sta_debugfs_add(struct st
>         DEBUGFS_ADD(last_ack_ms);
>         DEBUGFS_ADD(inactive_ms);
>         DEBUGFS_ADD(last_seq_ctrl);
> -#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
> -       DEBUGFS_ADD(wme_rx_queue);
> -       DEBUGFS_ADD(wme_tx_queue);
> -#endif
>         DEBUGFS_ADD(agg_status);
>  }
>
> @@ -330,10 +296,6 @@ void ieee80211_sta_debugfs_remove(struct
>         DEBUGFS_DEL(last_ack_ms);
>         DEBUGFS_DEL(inactive_ms);
>         DEBUGFS_DEL(last_seq_ctrl);
> -#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
> -       DEBUGFS_DEL(wme_rx_queue);
> -       DEBUGFS_DEL(wme_tx_queue);
> -#endif
>         DEBUGFS_DEL(agg_status);
>
>         debugfs_remove(sta->debugfs.dir);
> --- everything.orig/net/mac80211/ieee80211.c    2008-02-08 13:29:31.972004557 +0100
> +++ everything/net/mac80211/ieee80211.c 2008-02-08 14:27:48.522002821 +0100
> @@ -289,7 +289,6 @@ static int ieee80211_open(struct net_dev
>         if (local->open_count == 0) {
>                 res = dev_open(local->mdev);
>                 WARN_ON(res);
> -               tasklet_enable(&local->tx_pending_tasklet);
>                 tasklet_enable(&local->tasklet);
>         }
>
> @@ -440,7 +439,6 @@ static int ieee80211_stop(struct net_dev
>
>                 ieee80211_led_radio(local, 0);
>
> -               tasklet_disable(&local->tx_pending_tasklet);
>                 tasklet_disable(&local->tasklet);
>         }
>
> @@ -1130,7 +1128,6 @@ static void ieee80211_remove_tx_extra(st
>                 pkt_data->flags |= IEEE80211_TXPD_REQUEUE;
>         if (control->flags & IEEE80211_TXCTL_EAPOL_FRAME)
>                 pkt_data->flags |= IEEE80211_TXPD_EAPOL_FRAME;
> -       pkt_data->queue = control->queue;
>
>         hdrlen = ieee80211_get_hdrlen_from_skb(skb);
>
> @@ -1434,10 +1431,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
>
>         sta_info_init(local);
>
> -       tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
> -                    (unsigned long)local);
> -       tasklet_disable(&local->tx_pending_tasklet);
> -
>         tasklet_init(&local->tasklet,
>                      ieee80211_tasklet_handler,
>                      (unsigned long) local);
> @@ -1482,8 +1475,9 @@ int ieee80211_register_hw(struct ieee802
>                 return result;
>
>         /* for now, mdev needs sub_if_data :/ */
> -       mdev = alloc_netdev(sizeof(struct ieee80211_sub_if_data),
> -                           "wmaster%d", ether_setup);
> +       mdev = alloc_netdev_mq(sizeof(struct ieee80211_sub_if_data),
> +                              "wmaster%d", ether_setup,
> +                              hw->queues + hw->ampdu_queues);
>         if (!mdev)
>                 goto fail_mdev_alloc;
>
> @@ -1575,6 +1569,11 @@ int ieee80211_register_hw(struct ieee802
>                 goto fail_wep;
>         }
>
> +       if (hw->queues > IEEE80211_MAX_QUEUES)
> +               hw->queues = IEEE80211_MAX_QUEUES;
> +       if (hw->ampdu_queues > IEEE80211_MAX_AMPDU_QUEUES)
> +               hw->ampdu_queues = IEEE80211_MAX_AMPDU_QUEUES;
> +
>         ieee80211_install_qdisc(local->mdev);
>
>         /* add one default STA interface */
> @@ -1616,7 +1615,6 @@ void ieee80211_unregister_hw(struct ieee
>         struct ieee80211_local *local = hw_to_local(hw);
>         struct ieee80211_sub_if_data *sdata, *tmp;
>
> -       tasklet_kill(&local->tx_pending_tasklet);
>         tasklet_kill(&local->tasklet);
>
>         rtnl_lock();
> @@ -1650,7 +1648,6 @@ void ieee80211_unregister_hw(struct ieee
>         rtnl_unlock();
>
>         ieee80211_rx_bss_list_deinit(local->mdev);
> -       ieee80211_clear_tx_pending(local);
>         sta_info_stop(local);
>         rate_control_deinitialize(local);
>         debugfs_hw_del(local);
> --- everything.orig/net/mac80211/ieee80211_i.h  2008-02-08 13:29:32.002004449 +0100
> +++ everything/net/mac80211/ieee80211_i.h       2008-02-08 14:03:58.252005100 +0100
> @@ -179,7 +179,6 @@ struct ieee80211_tx_packet_data {
>         int ifindex;
>         unsigned long jiffies;
>         unsigned int flags;
> -       u8 queue;
>  };
>
>  struct ieee80211_tx_stored_packet {
> @@ -450,10 +449,6 @@ struct ieee80211_local {
>         struct sta_info *sta_hash[STA_HASH_SIZE];
>         struct timer_list sta_cleanup;
>
> -       unsigned long state[NUM_TX_DATA_QUEUES_AMPDU];
> -       struct ieee80211_tx_stored_packet pending_packet[NUM_TX_DATA_QUEUES_AMPDU];
> -       struct tasklet_struct tx_pending_tasklet;
> -
>         /* number of interfaces with corresponding IFF_ flags */
>         atomic_t iff_allmultis, iff_promiscs;
>
> @@ -538,8 +533,6 @@ struct ieee80211_local {
>         unsigned int rx_expand_skb_head2;
>         unsigned int rx_handlers_fragments;
>         unsigned int tx_status_drop;
> -       unsigned int wme_rx_queue[NUM_RX_DATA_QUEUES];
> -       unsigned int wme_tx_queue[NUM_RX_DATA_QUEUES];
>  #define I802_DEBUG_INC(c) (c)++
>  #else /* CONFIG_MAC80211_DEBUG_COUNTERS */
>  #define I802_DEBUG_INC(c) do { } while (0)
> @@ -597,8 +590,6 @@ struct ieee80211_local {
>                         struct dentry *rx_expand_skb_head2;
>                         struct dentry *rx_handlers_fragments;
>                         struct dentry *tx_status_drop;
> -                       struct dentry *wme_tx_queue;
> -                       struct dentry *wme_rx_queue;
>  #endif
>                         struct dentry *dot11ACKFailureCount;
>                         struct dentry *dot11RTSFailureCount;
> @@ -629,11 +620,6 @@ static inline struct ieee80211_hw *local
>         return &local->hw;
>  }
>
> -enum ieee80211_link_state_t {
> -       IEEE80211_LINK_STATE_XOFF = 0,
> -       IEEE80211_LINK_STATE_PENDING,
> -};
> -
>  struct sta_attribute {
>         struct attribute attr;
>         ssize_t (*show)(const struct sta_info *, char *buf);
> @@ -772,8 +758,6 @@ void ieee80211_if_free(struct net_device
>  void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata);
>
>  /* tx handling */
> -void ieee80211_clear_tx_pending(struct ieee80211_local *local);
> -void ieee80211_tx_pending(unsigned long data);
>  int ieee80211_master_start_xmit(struct sk_buff *skb, struct net_device *dev);
>  int ieee80211_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
>  int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
> --- everything.orig/net/mac80211/ieee80211_sta.c        2008-02-08 13:41:13.292004015 +0100
> +++ everything/net/mac80211/ieee80211_sta.c     2008-02-08 14:03:58.262036350 +0100
> @@ -268,26 +268,26 @@ static void ieee80211_sta_wmm_params(str
>
>                 switch (aci) {
>                 case 1:
> -                       queue = IEEE80211_TX_QUEUE_DATA3;
> +                       queue = 3;
>                         if (acm) {
>                                 local->wmm_acm |= BIT(0) | BIT(3);
>                         }
>                         break;
>                 case 2:
> -                       queue = IEEE80211_TX_QUEUE_DATA1;
> +                       queue = 1;
>                         if (acm) {
>                                 local->wmm_acm |= BIT(4) | BIT(5);
>                         }
>                         break;
>                 case 3:
> -                       queue = IEEE80211_TX_QUEUE_DATA0;
> +                       queue = 0;
>                         if (acm) {
>                                 local->wmm_acm |= BIT(6) | BIT(7);
>                         }
>                         break;
>                 case 0:
>                 default:
> -                       queue = IEEE80211_TX_QUEUE_DATA2;
> +                       queue = 2;
>                         if (acm) {
>                                 local->wmm_acm |= BIT(1) | BIT(2);
>                         }
> @@ -3213,8 +3213,6 @@ int ieee80211_sta_set_ssid(struct net_de
>         if (len > IEEE80211_MAX_SSID_LEN)
>                 return -EINVAL;
>
> -       /* TODO: This should always be done for IBSS, even if IEEE80211_QOS is
> -        * not defined. */
>         if (local->ops->conf_tx) {
>                 struct ieee80211_tx_queue_params qparam;
>                 int i;
> @@ -3232,17 +3230,9 @@ int ieee80211_sta_set_ssid(struct net_de
>                 qparam.cw_max = 1023;
>                 qparam.txop = 0;
>
> -               for (i = IEEE80211_TX_QUEUE_DATA0; i < NUM_TX_DATA_QUEUES; i++)
> -                       local->ops->conf_tx(local_to_hw(local),
> -                                          i + IEEE80211_TX_QUEUE_DATA0,
> -                                          &qparam);
> -
> -               /* IBSS uses different parameters for Beacon sending */
> -               qparam.cw_min++;
> -               qparam.cw_min *= 2;
> -               qparam.cw_min--;
> -               local->ops->conf_tx(local_to_hw(local),
> -                                  IEEE80211_TX_QUEUE_BEACON, &qparam);
> +               for (i = 0; i < local_to_hw(local)->queues; i++)
> +                       local->ops->conf_tx(local_to_hw(local), i,
> +                                           &qparam);
>         }
>
>         ifsta = &sdata->u.sta;
> --- everything.orig/net/mac80211/rx.c   2008-02-08 13:29:32.102003581 +0100
> +++ everything/net/mac80211/rx.c        2008-02-08 14:03:58.272005317 +0100
> @@ -273,11 +273,6 @@ static void ieee80211_parse_qos(struct i
>                 }
>         }
>
> -       I802_DEBUG_INC(rx->local->wme_rx_queue[tid]);
> -       /* only a debug counter, sta might not be assigned properly yet */
> -       if (rx->sta)
> -               I802_DEBUG_INC(rx->sta->wme_rx_queue[tid]);
> -
>         rx->u.rx.queue = tid;
>         /* Set skb->priority to 1d tag if highest order bit of TID is not set.
>          * For now, set skb->priority to 0 for other cases. */
> --- everything.orig/net/mac80211/sta_info.h     2008-02-08 13:29:32.132005588 +0100
> +++ everything/net/mac80211/sta_info.h  2008-02-08 14:03:58.272005317 +0100
> @@ -181,11 +181,6 @@ struct sta_info {
>         int channel_use;
>         int channel_use_raw;
>
> -#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
> -       unsigned int wme_rx_queue[NUM_RX_DATA_QUEUES];
> -       unsigned int wme_tx_queue[NUM_RX_DATA_QUEUES];
> -#endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
> -
>         u16 listen_interval;
>
>         struct ieee80211_ht_info ht_info; /* 802.11n HT capabilities
> @@ -203,10 +198,6 @@ struct sta_info {
>                 struct dentry *last_ack_ms;
>                 struct dentry *inactive_ms;
>                 struct dentry *last_seq_ctrl;
> -#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
> -               struct dentry *wme_rx_queue;
> -               struct dentry *wme_tx_queue;
> -#endif
>                 struct dentry *agg_status;
>         } debugfs;
>  #endif
> --- everything.orig/net/mac80211/tx.c   2008-02-08 13:29:32.202003906 +0100
> +++ everything/net/mac80211/tx.c        2008-02-08 14:03:58.282004774 +0100
> @@ -31,9 +31,6 @@
>  #include "wme.h"
>  #include "ieee80211_rate.h"
>
> -#define IEEE80211_TX_OK                0
> -#define IEEE80211_TX_AGAIN     1
> -#define IEEE80211_TX_FRAG_AGAIN        2
>
>  /* misc utils */
>
> @@ -211,18 +208,6 @@ static u16 ieee80211_duration(struct iee
>         return dur;
>  }
>
> -static inline int __ieee80211_queue_stopped(const struct ieee80211_local *local,
> -                                           int queue)
> -{
> -       return test_bit(IEEE80211_LINK_STATE_XOFF, &local->state[queue]);
> -}
> -
> -static inline int __ieee80211_queue_pending(const struct ieee80211_local *local,
> -                                           int queue)
> -{
> -       return test_bit(IEEE80211_LINK_STATE_PENDING, &local->state[queue]);
> -}
> -
>  static int inline is_ieee80211_device(struct net_device *dev,
>                                       struct net_device *master)
>  {
> @@ -1070,17 +1055,12 @@ static int __ieee80211_tx(struct ieee802
>         struct ieee80211_tx_control *control = tx->u.tx.control;
>         int ret, i;
>
> -       if (!ieee80211_qdisc_installed(local->mdev) &&
> -           __ieee80211_queue_stopped(local, 0)) {
> -               netif_stop_queue(local->mdev);
> -               return IEEE80211_TX_AGAIN;
> -       }
>         if (skb) {
>                 ieee80211_dump_frame(wiphy_name(local->hw.wiphy),
>                                      "TX to low-level driver", skb);
>                 ret = local->ops->tx(local_to_hw(local), skb, control);
>                 if (ret)
> -                       return IEEE80211_TX_AGAIN;
> +                       return NETDEV_TX_BUSY;
>                 local->mdev->trans_start = jiffies;
>                 ieee80211_led_tx(local, 1);
>         }
> @@ -1092,8 +1072,14 @@ static int __ieee80211_tx(struct ieee802
>                 for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
>                         if (!tx->u.tx.extra_frag[i])
>                                 continue;
> -                       if (__ieee80211_queue_stopped(local, control->queue))
> -                               return IEEE80211_TX_FRAG_AGAIN;
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
> +                       if (__netif_subqueue_stopped(local->mdev,
> +                                       tx->u.tx.extra_frag[i]->queue_mapping))
> +                               return NETDEV_TX_BUSY; /* XXX: FRAG AGAIN! */
> +#else
> +                       if (netif_queue_stopped(local->mdev))
> +                               return NETDEV_TX_BUSY; /* XXX: FRAG AGAIN! */
> +#endif
>                         if (i == tx->u.tx.num_extra_frag) {
>                                 control->tx_rate = tx->u.tx.last_frag_rate;
>
> @@ -1112,7 +1098,7 @@ static int __ieee80211_tx(struct ieee802
>                                             tx->u.tx.extra_frag[i],
>                                             control);
>                         if (ret)
> -                               return IEEE80211_TX_FRAG_AGAIN;
> +                               return NETDEV_TX_BUSY; /* XXX: FRAG AGAIN! */
>                         local->mdev->trans_start = jiffies;
>                         ieee80211_led_tx(local, 1);
>                         tx->u.tx.extra_frag[i] = NULL;
> @@ -1120,7 +1106,7 @@ static int __ieee80211_tx(struct ieee802
>                 kfree(tx->u.tx.extra_frag);
>                 tx->u.tx.extra_frag = NULL;
>         }
> -       return IEEE80211_TX_OK;
> +       return NETDEV_TX_OK;
>  }
>
>  static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb,
> @@ -1133,8 +1119,6 @@ static int ieee80211_tx(struct net_devic
>         ieee80211_tx_result res = TX_DROP, res_prepare;
>         int ret, i;
>
> -       WARN_ON(__ieee80211_queue_pending(local, control->queue));
> -
>         if (unlikely(skb->len < 10)) {
>                 dev_kfree_skb(skb);
>                 return 0;
> @@ -1198,42 +1182,9 @@ static int ieee80211_tx(struct net_devic
>                 }
>         }
>
> -retry:
>         ret = __ieee80211_tx(local, skb, &tx);
> -       if (ret) {
> -               struct ieee80211_tx_stored_packet *store =
> -                       &local->pending_packet[control->queue];
> -
> -               if (ret == IEEE80211_TX_FRAG_AGAIN)
> -                       skb = NULL;
> -               set_bit(IEEE80211_LINK_STATE_PENDING,
> -                       &local->state[control->queue]);
> -               smp_mb();
> -               /* When the driver gets out of buffers during sending of
> -                * fragments and calls ieee80211_stop_queue, there is
> -                * a small window between IEEE80211_LINK_STATE_XOFF and
> -                * IEEE80211_LINK_STATE_PENDING flags are set. If a buffer
> -                * gets available in that window (i.e. driver calls
> -                * ieee80211_wake_queue), we would end up with ieee80211_tx
> -                * called with IEEE80211_LINK_STATE_PENDING. Prevent this by
> -                * continuing transmitting here when that situation is
> -                * possible to have happened. */
> -               if (!__ieee80211_queue_stopped(local, control->queue)) {
> -                       clear_bit(IEEE80211_LINK_STATE_PENDING,
> -                                 &local->state[control->queue]);
> -                       goto retry;
> -               }
> -               memcpy(&store->control, control,
> -                      sizeof(struct ieee80211_tx_control));
> -               store->skb = skb;
> -               store->extra_frag = tx.u.tx.extra_frag;
> -               store->num_extra_frag = tx.u.tx.num_extra_frag;
> -               store->last_frag_rate = tx.u.tx.last_frag_rate;
> -               store->last_frag_rate_ctrl_probe =
> -                       !!(tx.flags & IEEE80211_TXRXD_TXPROBE_LAST_FRAG);
> -       }
>         rcu_read_unlock();
> -       return 0;
> +       return ret;
>
>   drop:
>         if (skb)
> @@ -1290,7 +1241,6 @@ int ieee80211_master_start_xmit(struct s
>         }
>
>         control.vif = &osdata->vif;
> -       control.type = osdata->vif.type;
>         if (pkt_data->flags & IEEE80211_TXPD_REQ_TX_STATUS)
>                 control.flags |= IEEE80211_TXCTL_REQ_TX_STATUS;
>         if (pkt_data->flags & IEEE80211_TXPD_DO_NOT_ENCRYPT)
> @@ -1301,7 +1251,6 @@ int ieee80211_master_start_xmit(struct s
>                 control.flags |= IEEE80211_TXCTL_EAPOL_FRAME;
>         if (pkt_data->flags & IEEE80211_TXPD_AMPDU)
>                 control.flags |= IEEE80211_TXCTL_AMPDU;
> -       control.queue = pkt_data->queue;
>
>         ret = ieee80211_tx(odev, skb, &control);
>         dev_put(odev);
> @@ -1607,69 +1556,6 @@ int ieee80211_subif_start_xmit(struct sk
>         return ret;
>  }
>
> -/* helper functions for pending packets for when queues are stopped */
> -
> -void ieee80211_clear_tx_pending(struct ieee80211_local *local)
> -{
> -       int i, j;
> -       struct ieee80211_tx_stored_packet *store;
> -
> -       for (i = 0; i < local->hw.queues; i++) {
> -               if (!__ieee80211_queue_pending(local, i))
> -                       continue;
> -               store = &local->pending_packet[i];
> -               kfree_skb(store->skb);
> -               for (j = 0; j < store->num_extra_frag; j++)
> -                       kfree_skb(store->extra_frag[j]);
> -               kfree(store->extra_frag);
> -               clear_bit(IEEE80211_LINK_STATE_PENDING, &local->state[i]);
> -       }
> -}
> -
> -void ieee80211_tx_pending(unsigned long data)
> -{
> -       struct ieee80211_local *local = (struct ieee80211_local *)data;
> -       struct net_device *dev = local->mdev;
> -       struct ieee80211_tx_stored_packet *store;
> -       struct ieee80211_txrx_data tx;
> -       int i, ret, reschedule = 0;
> -
> -       netif_tx_lock_bh(dev);
> -       for (i = 0; i < local->hw.queues; i++) {
> -               if (__ieee80211_queue_stopped(local, i))
> -                       continue;
> -               if (!__ieee80211_queue_pending(local, i)) {
> -                       reschedule = 1;
> -                       continue;
> -               }
> -               store = &local->pending_packet[i];
> -               tx.u.tx.control = &store->control;
> -               tx.u.tx.extra_frag = store->extra_frag;
> -               tx.u.tx.num_extra_frag = store->num_extra_frag;
> -               tx.u.tx.last_frag_rate = store->last_frag_rate;
> -               tx.flags = 0;
> -               if (store->last_frag_rate_ctrl_probe)
> -                       tx.flags |= IEEE80211_TXRXD_TXPROBE_LAST_FRAG;
> -               ret = __ieee80211_tx(local, store->skb, &tx);
> -               if (ret) {
> -                       if (ret == IEEE80211_TX_FRAG_AGAIN)
> -                               store->skb = NULL;
> -               } else {
> -                       clear_bit(IEEE80211_LINK_STATE_PENDING,
> -                                 &local->state[i]);
> -                       reschedule = 1;
> -               }
> -       }
> -       netif_tx_unlock_bh(dev);
> -       if (reschedule) {
> -               if (!ieee80211_qdisc_installed(dev)) {
> -                       if (!__ieee80211_queue_stopped(local, 0))
> -                               netif_wake_queue(dev);
> -               } else
> -                       netif_schedule(dev);
> -       }
> -}
> -
>  /* functions for drivers to get certain frames */
>
>  static void ieee80211_beacon_add_tim(struct ieee80211_local *local,
> --- everything.orig/net/mac80211/util.c 2008-02-08 13:29:32.242006673 +0100
> +++ everything/net/mac80211/util.c      2008-02-08 14:03:58.282004774 +0100
> @@ -302,22 +302,28 @@ __le16 ieee80211_ctstoself_duration(stru
>  }
>  EXPORT_SYMBOL(ieee80211_ctstoself_duration);
>
> +void ieee80211_start_queue(struct ieee80211_hw *hw, int queue)
> +{
> +       struct ieee80211_local *local = hw_to_local(hw);
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
> +       netif_start_subqueue(local->mdev, queue);
> +#else
> +       WARN_ON(queue != 0);
> +       netif_start_queue(local->mdev);
> +#endif
> +}
> +EXPORT_SYMBOL(ieee80211_start_queue);
> +
>  void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
>  {
>         struct ieee80211_local *local = hw_to_local(hw);
>
> -       if (test_and_clear_bit(IEEE80211_LINK_STATE_XOFF,
> -                              &local->state[queue])) {
> -               if (test_bit(IEEE80211_LINK_STATE_PENDING,
> -                            &local->state[queue]))
> -                       tasklet_schedule(&local->tx_pending_tasklet);
> -               else
> -                       if (!ieee80211_qdisc_installed(local->mdev)) {
> -                               if (queue == 0)
> -                                       netif_wake_queue(local->mdev);
> -                       } else
> -                               __netif_schedule(local->mdev);
> -       }
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
> +       netif_wake_subqueue(local->mdev, queue);
> +#else
> +       WARN_ON(queue != 0);
> +       netif_wake_queue(local->mdev);
> +#endif
>  }
>  EXPORT_SYMBOL(ieee80211_wake_queue);
>
> @@ -325,39 +331,51 @@ void ieee80211_stop_queue(struct ieee802
>  {
>         struct ieee80211_local *local = hw_to_local(hw);
>
> -       if (!ieee80211_qdisc_installed(local->mdev) && queue == 0)
> -               netif_stop_queue(local->mdev);
> -       set_bit(IEEE80211_LINK_STATE_XOFF, &local->state[queue]);
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
> +       netif_stop_subqueue(local->mdev, queue);
> +#else
> +       WARN_ON(queue != 0);
> +       netif_stop_queue(local->mdev);
> +#endif
>  }
>  EXPORT_SYMBOL(ieee80211_stop_queue);
>
>  void ieee80211_start_queues(struct ieee80211_hw *hw)
>  {
> -       struct ieee80211_local *local = hw_to_local(hw);
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
>         int i;
>
> -       for (i = 0; i < local->hw.queues; i++)
> -               clear_bit(IEEE80211_LINK_STATE_XOFF, &local->state[i]);
> -       if (!ieee80211_qdisc_installed(local->mdev))
> -               netif_start_queue(local->mdev);
> +       for (i = 0; i < hw->queues; i++)
> +               ieee80211_start_queue(hw, i);
> +#else
> +       netif_start_queue(local->mdev);
> +#endif
>  }
>  EXPORT_SYMBOL(ieee80211_start_queues);
>
>  void ieee80211_stop_queues(struct ieee80211_hw *hw)
>  {
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
>         int i;
>
>         for (i = 0; i < hw->queues; i++)
>                 ieee80211_stop_queue(hw, i);
> +#else
> +       netif_stop_queue(local->mdev);
> +#endif
>  }
>  EXPORT_SYMBOL(ieee80211_stop_queues);
>
>  void ieee80211_wake_queues(struct ieee80211_hw *hw)
>  {
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
>         int i;
>
>         for (i = 0; i < hw->queues; i++)
>                 ieee80211_wake_queue(hw, i);
> +#else
> +       netif_wake_queue(local->mdev);
> +#endif
>  }
>  EXPORT_SYMBOL(ieee80211_wake_queues);
>
> --- everything.orig/drivers/net/wireless/rtl8180_dev.c  2008-02-08 13:29:32.342004557 +0100
> +++ everything/drivers/net/wireless/rtl8180_dev.c       2008-02-08 14:03:58.322001790 +0100
> @@ -249,7 +249,7 @@ static int rtl8180_tx(struct ieee80211_h
>         u16 plcp_len = 0;
>         __le16 rts_duration = 0;
>
> -       prio = control->queue;
> +       prio = skb_get_queue_mapping(skb);
>         ring = &priv->tx_ring[prio];
>
>         mapping = pci_map_single(priv->pdev, skb->data,
> @@ -301,7 +301,7 @@ static int rtl8180_tx(struct ieee80211_h
>         entry->flags = cpu_to_le32(tx_flags);
>         __skb_queue_tail(&ring->queue, skb);
>         if (ring->entries - skb_queue_len(&ring->queue) < 2)
> -               ieee80211_stop_queue(dev, control->queue);
> +               ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
>         spin_unlock_irqrestore(&priv->lock, flags);
>
>         rtl818x_iowrite8(priv, &priv->map->TX_DMA_POLLING, (1 << (prio + 4)));
> --- everything.orig/drivers/net/wireless/adm8211.c      2008-02-08 13:29:32.392005100 +0100
> +++ everything/drivers/net/wireless/adm8211.c   2008-02-08 14:03:58.322001790 +0100
> @@ -306,11 +306,10 @@ static int adm8211_get_tx_stats(struct i
>                                 struct ieee80211_tx_queue_stats *stats)
>  {
>         struct adm8211_priv *priv = dev->priv;
> -       struct ieee80211_tx_queue_stats_data *data = &stats->data[0];
>
> -       data->len = priv->cur_tx - priv->dirty_tx;
> -       data->limit = priv->tx_ring_size - 2;
> -       data->count = priv->dirty_tx;
> +       stats[0].len = priv->cur_tx - priv->dirty_tx;
> +       stats[0].limit = priv->tx_ring_size - 2;
> +       stats[0].count = priv->dirty_tx;
>
>         return 0;
>  }
> --- everything.orig/drivers/net/wireless/ath5k/base.c   2008-02-08 13:29:32.442006293 +0100
> +++ everything/drivers/net/wireless/ath5k/base.c        2008-02-08 14:03:58.342004449 +0100
> @@ -1331,7 +1331,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc
>
>         spin_lock_bh(&txq->lock);
>         list_add_tail(&bf->list, &txq->q);
> -       sc->tx_stats.data[txq->qnum].len++;
> +       sc->tx_stats[txq->qnum].len++;
>         if (txq->link == NULL) /* is this first packet? */
>                 ath5k_hw_put_tx_buf(ah, txq->qnum, bf->daddr);
>         else /* no, so only link it */
> @@ -1563,7 +1563,7 @@ ath5k_txq_drainq(struct ath5k_softc *sc,
>                 ath5k_txbuf_free(sc, bf);
>
>                 spin_lock_bh(&sc->txbuflock);
> -               sc->tx_stats.data[txq->qnum].len--;
> +               sc->tx_stats[txq->qnum].len--;
>                 list_move_tail(&bf->list, &sc->txbuf);
>                 sc->txbuf_len++;
>                 spin_unlock_bh(&sc->txbuflock);
> @@ -1934,10 +1934,10 @@ ath5k_tx_processq(struct ath5k_softc *sc
>                 }
>
>                 ieee80211_tx_status(sc->hw, skb, &txs);
> -               sc->tx_stats.data[txq->qnum].count++;
> +               sc->tx_stats[txq->qnum].count++;
>
>                 spin_lock(&sc->txbuflock);
> -               sc->tx_stats.data[txq->qnum].len--;
> +               sc->tx_stats[txq->qnum].len--;
>                 list_move_tail(&bf->list, &sc->txbuf);
>                 sc->txbuf_len++;
>                 spin_unlock(&sc->txbuflock);
> @@ -2619,7 +2619,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct
>         if (list_empty(&sc->txbuf)) {
>                 ATH5K_ERR(sc, "no further txbuf available, dropping packet\n");
>                 spin_unlock_irqrestore(&sc->txbuflock, flags);
> -               ieee80211_stop_queue(hw, ctl->queue);
> +               ieee80211_stop_queue(hw, skb_get_queue_mapping(skb));
>                 return -1;
>         }
>         bf = list_first_entry(&sc->txbuf, struct ath5k_buf, list);
> --- everything.orig/drivers/net/wireless/ath5k/base.h   2008-02-08 13:29:32.472004015 +0100
> +++ everything/drivers/net/wireless/ath5k/base.h        2008-02-08 14:03:58.342004449 +0100
> @@ -92,7 +92,9 @@ struct ath5k_softc {
>         struct pci_dev          *pdev;          /* for dma mapping */
>         void __iomem            *iobase;        /* address of the device */
>         struct mutex            lock;           /* dev-level lock */
> -       struct ieee80211_tx_queue_stats tx_stats;
> +       struct ieee80211_tx_queue_stats tx_stats[20]; /* XXX how many is this really?
> +                                                       I can't find this driver setting
> +                                                       hw->queues at all! */
>         struct ieee80211_low_level_stats ll_stats;
>         struct ieee80211_hw     *hw;            /* IEEE 802.11 common */
>         struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
> --- everything.orig/drivers/net/wireless/b43/main.c     2008-02-08 13:29:32.542004774 +0100
> +++ everything/drivers/net/wireless/b43/main.c  2008-02-08 14:03:58.352004340 +0100
> @@ -2614,8 +2614,7 @@ out:
>         return NETDEV_TX_OK;
>  }
>
> -static int b43_op_conf_tx(struct ieee80211_hw *hw,
> -                         int queue,
> +static int b43_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
>                           const struct ieee80211_tx_queue_params *params)
>  {
>         return 0;
> --- everything.orig/drivers/net/wireless/b43legacy/main.c       2008-02-08 13:29:32.642005371 +0100
> +++ everything/drivers/net/wireless/b43legacy/main.c    2008-02-08 14:03:58.362004394 +0100
> @@ -2360,8 +2360,7 @@ out:
>         return NETDEV_TX_OK;
>  }
>
> -static int b43legacy_op_conf_tx(struct ieee80211_hw *hw,
> -                               int queue,
> +static int b43legacy_op_conf_tx(struct ieee80211_hw *hw, u16 queue,
>                                 const struct ieee80211_tx_queue_params *params)
>  {
>         return 0;
> --- everything.orig/drivers/net/wireless/p54.h  2008-02-08 13:29:32.742003689 +0100
> +++ everything/drivers/net/wireless/p54.h       2008-02-08 14:03:58.362004394 +0100
> @@ -64,7 +64,7 @@ struct p54_common {
>         unsigned int tx_hdr_len;
>         void *cached_vdcf;
>         unsigned int fw_var;
> -       struct ieee80211_tx_queue_stats tx_stats;
> +       struct ieee80211_tx_queue_stats tx_stats[4];
>  };
>
>  int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb);
> --- everything.orig/drivers/net/wireless/p54common.c    2008-02-08 13:55:04.952001085 +0100
> +++ everything/drivers/net/wireless/p54common.c 2008-02-08 14:03:58.372004015 +0100
> @@ -144,14 +144,16 @@ void p54_parse_firmware(struct ieee80211
>                 printk(KERN_INFO "p54: FW rev %s - Softmac protocol %x.%x\n",
>                         fw_version, priv->fw_var >> 8, priv->fw_var & 0xff);
>
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
>         if (priv->fw_var >= 0x300) {
>                 /* Firmware supports QoS, use it! */
> -               priv->tx_stats.data[0].limit = 3;
> -               priv->tx_stats.data[1].limit = 4;
> -               priv->tx_stats.data[2].limit = 3;
> -               priv->tx_stats.data[3].limit = 1;
> +               priv->tx_stats[0].limit = 3;
> +               priv->tx_stats[1].limit = 4;
> +               priv->tx_stats[2].limit = 3;
> +               priv->tx_stats[3].limit = 1;
>                 dev->queues = 4;
>         }
> +#endif
>  }
>  EXPORT_SYMBOL_GPL(p54_parse_firmware);
>
> @@ -371,7 +373,7 @@ static void inline p54_wake_free_queues(
>          * But, what if some are full? */
>
>         for (i = 0; i < dev->queues; i++)
> -               if (priv->tx_stats.data[i].len < priv->tx_stats.data[i].limit)
> +               if (priv->tx_stats[i].len < priv->tx_stats[i].limit)
>                         ieee80211_wake_queue(dev, i);
>  }
>
> @@ -408,8 +410,7 @@ static void p54_rx_frame_sent(struct iee
>                         memcpy(&status.control, range->control,
>                                sizeof(status.control));
>                         kfree(range->control);
> -                       priv->tx_stats.data[status.control.queue].len--;
> -
> +                       priv->tx_stats[skb_get_queue_mapping(skb)].len--;
>                         entry_hdr = (struct p54_control_hdr *) entry->data;
>                         entry_data = (struct p54_tx_control_allocdata *) entry_hdr->data;
>                         if ((entry_hdr->magic1 & cpu_to_le16(0x4000)) != 0)
> @@ -546,7 +547,7 @@ static void p54_assign_address(struct ie
>  static int p54_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
>                   struct ieee80211_tx_control *control)
>  {
> -       struct ieee80211_tx_queue_stats_data *current_queue;
> +       struct ieee80211_tx_queue_stats *current_queue;
>         struct p54_common *priv = dev->priv;
>         struct p54_control_hdr *hdr;
>         struct p54_tx_control_allocdata *txhdr;
> @@ -554,13 +555,13 @@ static int p54_tx(struct ieee80211_hw *d
>         size_t padding, len;
>         u8 rate;
>
> -       current_queue = &priv->tx_stats.data[control->queue];
> +       current_queue = &priv->tx_stats[skb_get_queue_mapping(skb)];
>         if (unlikely(current_queue->len > current_queue->limit))
>                 return NETDEV_TX_BUSY;
>         current_queue->len++;
>         current_queue->count++;
>         if (current_queue->len == current_queue->limit)
> -               ieee80211_stop_queue(dev, control->queue);
> +               ieee80211_stop_queue(dev, skb_get_queue_mapping(skb));
>
>         padding = (unsigned long)(skb->data - (sizeof(*hdr) + sizeof(*txhdr))) & 3;
>         len = skb->len;
> @@ -597,7 +598,7 @@ static int p54_tx(struct ieee80211_hw *d
>         memset(txhdr->rateset, rate, 8);
>         txhdr->wep_key_present = 0;
>         txhdr->wep_key_len = 0;
> -       txhdr->frame_type = cpu_to_le32(control->queue + 4);
> +       txhdr->frame_type = cpu_to_le32(skb_get_queue_mapping(skb) + 4);
>         txhdr->magic4 = 0;
>         txhdr->antenna = (control->antenna_sel_tx == 0) ?
>                 2 : control->antenna_sel_tx - 1;
> @@ -933,7 +934,7 @@ static void p54_configure_filter(struct
>         }
>  }
>
> -static int p54_conf_tx(struct ieee80211_hw *dev, int queue,
> +static int p54_conf_tx(struct ieee80211_hw *dev, u16 queue,
>                        const struct ieee80211_tx_queue_params *params)
>  {
>         struct p54_common *priv = dev->priv;
> @@ -942,7 +943,7 @@ static int p54_conf_tx(struct ieee80211_
>         vdcf = (struct p54_tx_control_vdcf *)(((struct p54_control_hdr *)
>                 ((void *)priv->cached_vdcf + priv->tx_hdr_len))->data);
>
> -       if ((params) && !((queue < 0) || (queue > 4))) {
> +       if (params && queue < dev->queues) {
>                 P54_SET_QUEUE(vdcf->queue[queue], params->aifs,
>                         params->cw_min, params->cw_max, params->txop);
>         } else
> @@ -964,11 +965,8 @@ static int p54_get_tx_stats(struct ieee8
>                             struct ieee80211_tx_queue_stats *stats)
>  {
>         struct p54_common *priv = dev->priv;
> -       unsigned int i;
>
> -       for (i = 0; i < dev->queues; i++)
> -               memcpy(&stats->data[i], &priv->tx_stats.data[i],
> -                       sizeof(stats->data[i]));
> +       memcpy(stats, &priv->tx_stats, sizeof(stats[0]) * dev->queues);
>
>         return 0;
>  }
> @@ -1005,7 +1003,7 @@ struct ieee80211_hw *p54_init_common(siz
>         dev->channel_change_time = 1000;        /* TODO: find actual value */
>         dev->max_rssi = 127;
>
> -       priv->tx_stats.data[0].limit = 5;
> +       priv->tx_stats[0].limit = 5;
>         dev->queues = 1;
>
>         dev->extra_tx_headroom = sizeof(struct p54_control_hdr) + 4 +
> --- everything.orig/drivers/net/wireless/b43/dma.c      2008-02-08 13:29:32.572003743 +0100
> +++ everything/drivers/net/wireless/b43/dma.c   2008-02-08 14:03:58.382057020 +0100
> @@ -1294,7 +1294,12 @@ int b43_dma_tx(struct b43_wldev *dev,
>                 hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
>         } else {
>                 /* Decide by priority where to put this frame. */
> -               ring = priority_to_txring(dev, ctl->queue);
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
> +               ring = priority_to_txring(dev, skb->queue_mapping);
> +#else
> +               /* XXX: b43 qos needs a lot of work */
> +               ring = 1;
> +#endif
>         }
>
>         spin_lock_irqsave(&ring->lock, flags);
> @@ -1419,18 +1424,16 @@ void b43_dma_get_tx_stats(struct b43_wld
>  {
>         const int nr_queues = dev->wl->hw->queues;
>         struct b43_dmaring *ring;
> -       struct ieee80211_tx_queue_stats_data *data;
>         unsigned long flags;
>         int i;
>
>         for (i = 0; i < nr_queues; i++) {
> -               data = &(stats->data[i]);
>                 ring = priority_to_txring(dev, i);
>
>                 spin_lock_irqsave(&ring->lock, flags);
> -               data->len = ring->used_slots / SLOTS_PER_PACKET;
> -               data->limit = ring->nr_slots / SLOTS_PER_PACKET;
> -               data->count = ring->nr_tx_packets;
> +               stats[i].len = ring->used_slots / SLOTS_PER_PACKET;
> +               stats[i].limit = ring->nr_slots / SLOTS_PER_PACKET;
> +               stats[i].count = ring->nr_tx_packets;
>                 spin_unlock_irqrestore(&ring->lock, flags);
>         }
>  }
> --- everything.orig/drivers/net/wireless/b43legacy/dma.c        2008-02-08 13:29:32.672003581 +0100
> +++ everything/drivers/net/wireless/b43legacy/dma.c     2008-02-08 14:03:58.382057020 +0100
> @@ -1280,7 +1280,11 @@ int b43legacy_dma_tx(struct b43legacy_wl
>         int err = 0;
>         unsigned long flags;
>
> -       ring = priority_to_txring(dev, ctl->queue);
> +#ifdef CONFIG_NETDEVICES_MULTIQUEUE
> +       ring = priority_to_txring(dev, skb->queue_mapping);
> +#else
> +       ring = 1;
> +#endif
>         spin_lock_irqsave(&ring->lock, flags);
>         B43legacy_WARN_ON(!ring->tx);
>         if (unlikely(free_slots(ring) < SLOTS_PER_PACKET)) {
> @@ -1405,18 +1409,16 @@ void b43legacy_dma_get_tx_stats(struct b
>  {
>         const int nr_queues = dev->wl->hw->queues;
>         struct b43legacy_dmaring *ring;
> -       struct ieee80211_tx_queue_stats_data *data;
>         unsigned long flags;
>         int i;
>
>         for (i = 0; i < nr_queues; i++) {
> -               data = &(stats->data[i]);
>                 ring = priority_to_txring(dev, i);
>
>                 spin_lock_irqsave(&ring->lock, flags);
> -               data->len = ring->used_slots / SLOTS_PER_PACKET;
> -               data->limit = ring->nr_slots / SLOTS_PER_PACKET;
> -               data->count = ring->nr_tx_packets;
> +               stats[i].len = ring->used_slots / SLOTS_PER_PACKET;
> +               stats[i].limit = ring->nr_slots / SLOTS_PER_PACKET;
> +               stats[i].count = ring->nr_tx_packets;
>                 spin_unlock_irqrestore(&ring->lock, flags);
>         }
>  }
> --- everything.orig/drivers/net/wireless/b43legacy/pio.c        2008-02-08 13:29:32.722008409 +0100
> +++ everything/drivers/net/wireless/b43legacy/pio.c     2008-02-08 14:03:58.392035156 +0100
> @@ -528,10 +528,9 @@ void b43legacy_pio_get_tx_stats(struct b
>         struct ieee80211_tx_queue_stats_data *data;
>
>         queue = pio->queue1;
> -       data = &(stats->data[0]);
> -       data->len = B43legacy_PIO_MAXTXPACKETS - queue->nr_txfree;
> -       data->limit = B43legacy_PIO_MAXTXPACKETS;
> -       data->count = queue->nr_tx_packets;
> +       stats[0].len = B43legacy_PIO_MAXTXPACKETS - queue->nr_txfree;
> +       stats[0].limit = B43legacy_PIO_MAXTXPACKETS;
> +       stats[0].count = queue->nr_tx_packets;
>  }
>
>  static void pio_rx_error(struct b43legacy_pioqueue *queue,
> --- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c 2008-02-08 13:40:40.472004774 +0100
> +++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c      2008-02-08 14:03:58.432002767 +0100
> @@ -2755,7 +2755,7 @@ static int iwl3945_tx_skb(struct iwl3945
>         struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>         struct iwl3945_tfd_frame *tfd;
>         u32 *control_flags;
> -       int txq_id = ctl->queue;
> +       int txq_id = skb_get_queue_mapping(skb);
>         struct iwl3945_tx_queue *txq = NULL;
>         struct iwl3945_queue *q = NULL;
>         dma_addr_t phys_addr;
> @@ -2968,7 +2968,7 @@ static int iwl3945_tx_skb(struct iwl3945
>                         spin_unlock_irqrestore(&priv->lock, flags);
>                 }
>
> -               ieee80211_stop_queue(priv->hw, ctl->queue);
> +               ieee80211_stop_queue(priv->hw, skb_get_queue_mapping(skb));
>         }
>
>         return 0;
> @@ -3318,8 +3318,6 @@ static void iwl3945_txstatus_to_ieee(str
>
>         tx_sta->status.ack_signal = 0;
>         tx_sta->status.excessive_retries = 0;
> -       tx_sta->status.queue_length = 0;
> -       tx_sta->status.queue_number = 0;
>
>         if (in_interrupt())
>                 ieee80211_tx_status_irqsafe(priv->hw,
> @@ -3411,9 +3409,6 @@ static void iwl3945_rx_reply_tx(struct i
>         tx_status = &(txq->txb[txq->q.read_ptr].status);
>
>         tx_status->retry_count = tx_resp->failure_frame;
> -       tx_status->queue_number = status;
> -       tx_status->queue_length = tx_resp->bt_kill_count;
> -       tx_status->queue_length |= tx_resp->failure_rts;
>
>         tx_status->flags =
>             iwl3945_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
> @@ -7402,7 +7397,7 @@ static int iwl3945_mac_set_key(struct ie
>         return rc;
>  }
>
> -static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, int queue,
> +static int iwl3945_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
>                            const struct ieee80211_tx_queue_params *params)
>  {
>         struct iwl3945_priv *priv = hw->priv;
> @@ -7481,9 +7476,9 @@ static int iwl3945_mac_get_tx_stats(stru
>                 q = &txq->q;
>                 avail = iwl3945_queue_space(q);
>
> -               stats->data[i].len = q->n_window - avail;
> -               stats->data[i].limit = q->n_window - q->high_mark;
> -               stats->data[i].count = q->n_window;
> +               stats[i].len = q->n_window - avail;
> +               stats[i].limit = q->n_window - q->high_mark;
> +               stats[i].count = q->n_window;
>
>         }
>         spin_unlock_irqrestore(&priv->lock, flags);
> --- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c 2008-02-08 13:40:18.732003852 +0100
> +++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c      2008-02-08 14:03:58.452003689 +0100
> @@ -2879,7 +2879,7 @@ static int iwl4965_tx_skb(struct iwl4965
>         struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>         struct iwl4965_tfd_frame *tfd;
>         u32 *control_flags;
> -       int txq_id = ctl->queue;
> +       int txq_id = skb_get_queue_mapping(skb);
>         struct iwl4965_tx_queue *txq = NULL;
>         struct iwl4965_queue *q = NULL;
>         dma_addr_t phys_addr;
> @@ -3101,7 +3101,7 @@ static int iwl4965_tx_skb(struct iwl4965
>                         spin_unlock_irqrestore(&priv->lock, flags);
>                 }
>
> -               ieee80211_stop_queue(priv->hw, ctl->queue);
> +               ieee80211_stop_queue(priv->hw, skb_get_queue_mapping(skb));
>         }
>
>         return 0;
> @@ -3446,8 +3446,6 @@ static void iwl4965_txstatus_to_ieee(str
>
>         tx_sta->status.ack_signal = 0;
>         tx_sta->status.excessive_retries = 0;
> -       tx_sta->status.queue_length = 0;
> -       tx_sta->status.queue_number = 0;
>
>         if (in_interrupt())
>                 ieee80211_tx_status_irqsafe(priv->hw,
> @@ -3744,9 +3742,6 @@ static void iwl4965_rx_reply_tx(struct i
>         tx_status = &(txq->txb[txq->q.read_ptr].status);
>
>         tx_status->retry_count = tx_resp->failure_frame;
> -       tx_status->queue_number = status;
> -       tx_status->queue_length = tx_resp->bt_kill_count;
> -       tx_status->queue_length |= tx_resp->failure_rts;
>
>         tx_status->flags =
>             iwl4965_is_tx_success(status) ? IEEE80211_TX_STATUS_ACK : 0;
> @@ -7880,7 +7875,7 @@ static int iwl4965_mac_set_key(struct ie
>         return rc;
>  }
>
> -static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, int queue,
> +static int iwl4965_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
>                            const struct ieee80211_tx_queue_params *params)
>  {
>         struct iwl4965_priv *priv = hw->priv;
> @@ -7959,9 +7954,9 @@ static int iwl4965_mac_get_tx_stats(stru
>                 q = &txq->q;
>                 avail = iwl4965_queue_space(q);
>
> -               stats->data[i].len = q->n_window - avail;
> -               stats->data[i].limit = q->n_window - q->high_mark;
> -               stats->data[i].count = q->n_window;
> +               stats[i].len = q->n_window - avail;
> +               stats[i].limit = q->n_window - q->high_mark;
> +               stats[i].count = q->n_window;
>
>         }
>         spin_unlock_irqrestore(&priv->lock, flags);
> --- everything.orig/drivers/net/wireless/rt2x00/rt2x00dev.c     2008-02-08 13:29:32.942005208 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2x00dev.c  2008-02-08 14:03:58.472004449 +0100
> @@ -526,9 +526,6 @@ void rt2x00lib_txdone(struct queue_entry
>                         rt2x00dev->low_level_stats.dot11ACKFailureCount++;
>         }
>
> -       tx_status.queue_length = entry->queue->limit;
> -       tx_status.queue_number = tx_status.control.queue;
> -
>         if (tx_status.control.flags & IEEE80211_TXCTL_USE_RTS_CTS) {
>                 if (success)
>                         rt2x00dev->low_level_stats.dot11RTSSuccessCount++;
> @@ -611,7 +608,8 @@ EXPORT_SYMBOL_GPL(rt2x00lib_rxdone);
>   */
>  void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
>                              struct sk_buff *skb,
> -                            struct ieee80211_tx_control *control)
> +                            struct ieee80211_tx_control *control,
> +                            u16 queue)
>  {
>         struct txentry_desc txdesc;
>         struct skb_frame_desc *skbdesc = get_skb_frame_desc(skb);
> @@ -673,7 +671,7 @@ void rt2x00lib_write_tx_desc(struct rt2x
>          * Beacons and probe responses require the tsf timestamp
>          * to be inserted into the frame.
>          */
> -       if (control->queue == RT2X00_BCN_QUEUE_BEACON ||
> +       if (queue == RT2X00_BCN_QUEUE_BEACON ||
>             is_probe_resp(frame_control))
>                 __set_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc.flags);
>
> --- everything.orig/drivers/net/wireless/rt2x00/rt2x00mac.c     2008-02-08 13:29:32.962004557 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2x00mac.c  2008-02-08 14:03:58.492003960 +0100
> @@ -90,12 +90,12 @@ int rt2x00mac_tx(struct ieee80211_hw *hw
>         /*
>          * Determine which queue to put packet on.
>          */
> -       queue = rt2x00queue_get_queue(rt2x00dev, control->queue);
> +       queue = rt2x00queue_get_queue(rt2x00dev, skb_get_queue_mapping(skb));
>         if (unlikely(!queue)) {
>                 ERROR(rt2x00dev,
>                       "Attempt to send packet over invalid queue %d.\n"
>                       "Please file bug report to %s.\n",
> -                     control->queue, DRV_PROJECT);
> +                     skb_get_queue_mapping(skb), DRV_PROJECT);
>                 dev_kfree_skb_any(skb);
>                 return NETDEV_TX_OK;
>         }
> @@ -111,26 +111,29 @@ int rt2x00mac_tx(struct ieee80211_hw *hw
>             (control->flags & (IEEE80211_TXCTL_USE_RTS_CTS |
>                                IEEE80211_TXCTL_USE_CTS_PROTECT))) {
>                 if (rt2x00queue_available(queue) <= 1) {
> -                       ieee80211_stop_queue(rt2x00dev->hw, control->queue);
> +                       ieee80211_stop_queue(rt2x00dev->hw,
> +                                            skb_get_queue_mapping(skb));
>                         return NETDEV_TX_BUSY;
>                 }
>
>                 if (rt2x00mac_tx_rts_cts(rt2x00dev, queue, skb, control)) {
> -                       ieee80211_stop_queue(rt2x00dev->hw, control->queue);
> +                       ieee80211_stop_queue(rt2x00dev->hw,
> +                                            skb_get_queue_mapping(skb));
>                         return NETDEV_TX_BUSY;
>                 }
>         }
>
>         if (rt2x00dev->ops->lib->write_tx_data(rt2x00dev, queue, skb, control)) {
> -               ieee80211_stop_queue(rt2x00dev->hw, control->queue);
> +               ieee80211_stop_queue(rt2x00dev->hw, skb_get_queue_mapping(skb));
>                 return NETDEV_TX_BUSY;
>         }
>
>         if (rt2x00queue_full(queue))
> -               ieee80211_stop_queue(rt2x00dev->hw, control->queue);
> +               ieee80211_stop_queue(rt2x00dev->hw, skb_get_queue_mapping(skb));
>
>         if (rt2x00dev->ops->lib->kick_tx_queue)
> -               rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, control->queue);
> +               rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev,
> +                                                  skb_get_queue_mapping(skb));
>
>         return NETDEV_TX_OK;
>  }
> @@ -377,9 +380,9 @@ int rt2x00mac_get_tx_stats(struct ieee80
>         unsigned int i;
>
>         for (i = 0; i < hw->queues; i++) {
> -               stats->data[i].len = rt2x00dev->tx[i].length;
> -               stats->data[i].limit = rt2x00dev->tx[i].limit;
> -               stats->data[i].count = rt2x00dev->tx[i].count;
> +               stats[i].len = rt2x00dev->tx[i].length;
> +               stats[i].limit = rt2x00dev->tx[i].limit;
> +               stats[i].count = rt2x00dev->tx[i].count;
>         }
>
>         return 0;
> @@ -424,7 +427,7 @@ void rt2x00mac_bss_info_changed(struct i
>  }
>  EXPORT_SYMBOL_GPL(rt2x00mac_bss_info_changed);
>
> -int rt2x00mac_conf_tx(struct ieee80211_hw *hw, int queue_idx,
> +int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue_idx,
>                       const struct ieee80211_tx_queue_params *params)
>  {
>         struct rt2x00_dev *rt2x00dev = hw->priv;
> --- everything.orig/drivers/net/wireless/rt2x00/rt2400pci.c     2008-02-08 13:29:33.012003526 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2400pci.c  2008-02-08 14:03:58.502004232 +0100
> @@ -1043,9 +1043,9 @@ static void rt2400pci_kick_tx_queue(stru
>
>         rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
>         rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO,
> -                          (queue == IEEE80211_TX_QUEUE_DATA0));
> +                          (queue == 0));
>         rt2x00_set_field32(&reg, TXCSR0_KICK_TX,
> -                          (queue == IEEE80211_TX_QUEUE_DATA1));
> +                          (queue == 1));
>         rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM,
>                            (queue == RT2X00_BCN_QUEUE_ATIM));
>         rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
> @@ -1085,7 +1085,7 @@ static void rt2400pci_fill_rxdone(struct
>   * Interrupt functions.
>   */
>  static void rt2400pci_txdone(struct rt2x00_dev *rt2x00dev,
> -                            const enum ieee80211_tx_queue queue_idx)
> +                            const u16 queue_idx)
>  {
>         struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
>         struct queue_entry_priv_pci_tx *priv_tx;
> @@ -1158,13 +1158,13 @@ static irqreturn_t rt2400pci_interrupt(i
>          * 4 - Priority ring transmit done interrupt.
>          */
>         if (rt2x00_get_field32(reg, CSR7_TXDONE_PRIORING))
> -               rt2400pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_DATA0);
> +               rt2400pci_txdone(rt2x00dev, 0);
>
>         /*
>          * 5 - Tx ring transmit done interrupt.
>          */
>         if (rt2x00_get_field32(reg, CSR7_TXDONE_TXRING))
> -               rt2400pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_DATA1);
> +               rt2400pci_txdone(rt2x00dev, 1);
>
>         return IRQ_HANDLED;
>  }
> @@ -1465,8 +1465,7 @@ static int rt2400pci_set_retry_limit(str
>         return 0;
>  }
>
> -static int rt2400pci_conf_tx(struct ieee80211_hw *hw,
> -                            int queue,
> +static int rt2400pci_conf_tx(struct ieee80211_hw *hw, u16 queue,
>                              const struct ieee80211_tx_queue_params *params)
>  {
>         struct rt2x00_dev *rt2x00dev = hw->priv;
> @@ -1476,7 +1475,7 @@ static int rt2400pci_conf_tx(struct ieee
>          * per queue. So by default we only configure the TX queue,
>          * and ignore all other configurations.
>          */
> -       if (queue != IEEE80211_TX_QUEUE_DATA0)
> +       if (queue != 0)
>                 return -EINVAL;
>
>         if (rt2x00mac_conf_tx(hw, queue, params))
> @@ -1537,13 +1536,8 @@ static int rt2400pci_beacon_update(struc
>         skbdesc->desc_len = intf->beacon->queue->desc_size;
>         skbdesc->entry = intf->beacon;
>
> -       /*
> -        * mac80211 doesn't provide the control->queue variable
> -        * for beacons. Set our own queue identification so
> -        * it can be used during descriptor initialization.
> -        */
> -       control->queue = RT2X00_BCN_QUEUE_BEACON;
> -       rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
> +       rt2x00lib_write_tx_desc(rt2x00dev, skb, control,
> +                               RT2X00_BCN_QUEUE_BEACON);
>
>         /*
>          * Enable beacon generation.
> @@ -1551,7 +1545,8 @@ static int rt2400pci_beacon_update(struc
>          * and kick the beacon generator.
>          */
>         memcpy(priv_tx->data, skb->data, skb->len);
> -       rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, control->queue);
> +       rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, RT2X00_BCN_QUEUE_BEACON);
> +
>
>         return 0;
>  }
> --- everything.orig/drivers/net/wireless/rt2x00/rt2x00pci.c     2008-02-08 13:29:33.062003472 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2x00pci.c  2008-02-08 14:03:58.502004232 +0100
> @@ -53,7 +53,7 @@ int rt2x00pci_write_tx_data(struct rt2x0
>                 ERROR(rt2x00dev,
>                       "Arrived at non-free entry in the non-full queue %d.\n"
>                       "Please file bug report to %s.\n",
> -                     control->queue, DRV_PROJECT);
> +                     skb_get_queue_mapping(skb), DRV_PROJECT);
>                 return -EINVAL;
>         }
>
> @@ -69,7 +69,10 @@ int rt2x00pci_write_tx_data(struct rt2x0
>         skbdesc->entry = entry;
>
>         memcpy(priv_tx->data, skb->data, skb->len);
> -       rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
> +#if TODO
> +Is this correct??
> +#endif
> +       rt2x00lib_write_tx_desc(rt2x00dev, skb, control, queue->qid);
>
>         rt2x00queue_index_inc(queue, Q_INDEX);
>
> @@ -176,10 +179,13 @@ void rt2x00pci_txdone(struct rt2x00_dev
>          * If the data queue was full before the txdone handler
>          * we must make sure the packet queue in the mac80211 stack
>          * is reenabled when the txdone handler has finished.
> +        *
> +        * XXX: Is this correct wrt. the queue number?
>          */
> +#if TODO
> +#endif
>         if (!rt2x00queue_full(entry->queue))
> -               ieee80211_wake_queue(rt2x00dev->hw, priv_tx->control.queue);
> -
> +               ieee80211_wake_queue(rt2x00dev->hw, entry->queue->qid);
>  }
>  EXPORT_SYMBOL_GPL(rt2x00pci_txdone);
>
> --- everything.orig/drivers/net/wireless/rt2x00/rt2x00usb.c     2008-02-08 13:29:33.082003526 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2x00usb.c  2008-02-08 14:03:58.512003147 +0100
> @@ -216,9 +216,13 @@ static void rt2x00usb_interrupt_txdone(s
>          * If the data queue was full before the txdone handler
>          * we must make sure the packet queue in the mac80211 stack
>          * is reenabled when the txdone handler has finished.
> +        *
> +        * XXX: Is  this correct wrt. the queue number?
>          */
> +#if TODO
> +#endif
>         if (!rt2x00queue_full(entry->queue))
> -               ieee80211_wake_queue(rt2x00dev->hw, priv_tx->control.queue);
> +               ieee80211_wake_queue(rt2x00dev->hw, entry->queue->qid);
>  }
>
>  int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
> @@ -238,7 +242,7 @@ int rt2x00usb_write_tx_data(struct rt2x0
>                 ERROR(rt2x00dev,
>                       "Arrived at non-free entry in the non-full queue %d.\n"
>                       "Please file bug report to %s.\n",
> -                     control->queue, DRV_PROJECT);
> +                     skb_get_queue_mapping(skb), DRV_PROJECT);
>                 return -EINVAL;
>         }
>
> @@ -259,7 +263,8 @@ int rt2x00usb_write_tx_data(struct rt2x0
>         skbdesc->desc_len = queue->desc_size;
>         skbdesc->entry = entry;
>
> -       rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
> +       rt2x00lib_write_tx_desc(rt2x00dev, skb, control,
> +                               skb_get_queue_mapping(skb));
>
>         /*
>          * USB devices cannot blindly pass the skb->len as the
> --- everything.orig/drivers/net/wireless/rt2x00/rt2500pci.c     2008-02-08 13:29:33.132003852 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2500pci.c  2008-02-08 14:03:58.512003147 +0100
> @@ -1197,9 +1197,9 @@ static void rt2500pci_kick_tx_queue(stru
>
>         rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
>         rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO,
> -                          (queue == IEEE80211_TX_QUEUE_DATA0));
> +                          (queue == 0));
>         rt2x00_set_field32(&reg, TXCSR0_KICK_TX,
> -                          (queue == IEEE80211_TX_QUEUE_DATA1));
> +                          (queue == 1));
>         rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM,
>                            (queue == RT2X00_BCN_QUEUE_ATIM));
>         rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
> @@ -1236,7 +1236,7 @@ static void rt2500pci_fill_rxdone(struct
>   * Interrupt functions.
>   */
>  static void rt2500pci_txdone(struct rt2x00_dev *rt2x00dev,
> -                            const enum ieee80211_tx_queue queue_idx)
> +                            const u16 queue_idx)
>  {
>         struct data_queue *queue = rt2x00queue_get_queue(rt2x00dev, queue_idx);
>         struct queue_entry_priv_pci_tx *priv_tx;
> @@ -1309,13 +1309,13 @@ static irqreturn_t rt2500pci_interrupt(i
>          * 4 - Priority ring transmit done interrupt.
>          */
>         if (rt2x00_get_field32(reg, CSR7_TXDONE_PRIORING))
> -               rt2500pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_DATA0);
> +               rt2500pci_txdone(rt2x00dev, 0);
>
>         /*
>          * 5 - Tx ring transmit done interrupt.
>          */
>         if (rt2x00_get_field32(reg, CSR7_TXDONE_TXRING))
> -               rt2500pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_DATA1);
> +               rt2500pci_txdone(rt2x00dev, 1);
>
>         return IRQ_HANDLED;
>  }
> @@ -1849,13 +1849,8 @@ static int rt2500pci_beacon_update(struc
>         skbdesc->desc_len = intf->beacon->queue->desc_size;
>         skbdesc->entry = intf->beacon;
>
> -       /*
> -        * mac80211 doesn't provide the control->queue variable
> -        * for beacons. Set our own queue identification so
> -        * it can be used during descriptor initialization.
> -        */
> -       control->queue = RT2X00_BCN_QUEUE_BEACON;
> -       rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
> +       rt2x00lib_write_tx_desc(rt2x00dev, skb, control,
> +                               RT2X00_BCN_QUEUE_BEACON);
>
>         /*
>          * Enable beacon generation.
> @@ -1863,7 +1858,7 @@ static int rt2500pci_beacon_update(struc
>          * and kick the beacon generator.
>          */
>         memcpy(priv_tx->data, skb->data, skb->len);
> -       rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, control->queue);
> +       rt2x00dev->ops->lib->kick_tx_queue(rt2x00dev, RT2X00_BCN_QUEUE_BEACON);
>
>         return 0;
>  }
> --- everything.orig/drivers/net/wireless/rt2x00/rt2500usb.c     2008-02-08 13:29:33.182003743 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2500usb.c  2008-02-08 14:03:58.522023383 +0100
> @@ -1757,13 +1757,8 @@ static int rt2500usb_beacon_update(struc
>         skbdesc->desc_len = intf->beacon->queue->desc_size;
>         skbdesc->entry = intf->beacon;
>
> -       /*
> -        * mac80211 doesn't provide the control->queue variable
> -        * for beacons. Set our own queue identification so
> -        * it can be used during descriptor initialization.
> -        */
> -       control->queue = RT2X00_BCN_QUEUE_BEACON;
> -       rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
> +       rt2x00lib_write_tx_desc(rt2x00dev, skb, control,
> +                               RT2X00_BCN_QUEUE_BEACON);
>
>         /*
>          * USB devices cannot blindly pass the skb->len as the
> @@ -1794,7 +1789,7 @@ static int rt2500usb_beacon_update(struc
>         /*
>          * Enable beacon generation.
>          */
> -       rt2500usb_kick_tx_queue(rt2x00dev, control->queue);
> +       rt2500usb_kick_tx_queue(rt2x00dev, RT2X00_BCN_QUEUE_BEACON);
>
>         return 0;
>  }
> --- everything.orig/drivers/net/wireless/rt2x00/rt2x00.h        2008-02-08 13:29:33.202003906 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2x00.h     2008-02-08 14:03:58.522023383 +0100
> @@ -950,7 +950,8 @@ void rt2x00lib_rxdone(struct queue_entry
>   */
>  void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
>                              struct sk_buff *skb,
> -                            struct ieee80211_tx_control *control);
> +                            struct ieee80211_tx_control *control,
> +                            u16 queue);
>
>  /*
>   * mac80211 handlers.
> @@ -975,7 +976,7 @@ void rt2x00mac_bss_info_changed(struct i
>                                 struct ieee80211_vif *vif,
>                                 struct ieee80211_bss_conf *bss_conf,
>                                 u32 changes);
> -int rt2x00mac_conf_tx(struct ieee80211_hw *hw, int queue,
> +int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
>                       const struct ieee80211_tx_queue_params *params);
>
>  /*
> --- everything.orig/drivers/net/wireless/rt2x00/rt61pci.c       2008-02-08 13:29:33.252003852 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt61pci.c    2008-02-08 14:03:58.532004340 +0100
> @@ -1567,13 +1567,13 @@ static void rt61pci_kick_tx_queue(struct
>
>         rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
>         rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0,
> -                          (queue == IEEE80211_TX_QUEUE_DATA0));
> +                          (queue == 0));
>         rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1,
> -                          (queue == IEEE80211_TX_QUEUE_DATA1));
> +                          (queue == 1));
>         rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC2,
> -                          (queue == IEEE80211_TX_QUEUE_DATA2));
> +                          (queue == 2));
>         rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3,
> -                          (queue == IEEE80211_TX_QUEUE_DATA3));
> +                          (queue == 3));
>         rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
>  }
>
> @@ -2410,13 +2410,8 @@ static int rt61pci_beacon_update(struct
>         skbdesc->desc_len = intf->beacon->queue->desc_size;
>         skbdesc->entry = intf->beacon;
>
> -       /*
> -        * mac80211 doesn't provide the control->queue variable
> -        * for beacons. Set our own queue identification so
> -        * it can be used during descriptor initialization.
> -        */
> -       control->queue = RT2X00_BCN_QUEUE_BEACON;
> -       rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
> +       rt2x00lib_write_tx_desc(rt2x00dev, skb, control,
> +                               RT2X00_BCN_QUEUE_BEACON);
>
>         /*
>          * Write entire beacon with descriptor to register,
> @@ -2425,7 +2420,7 @@ static int rt61pci_beacon_update(struct
>         beacon_base = HW_BEACON_OFFSET(intf->beacon->entry_idx);
>         rt2x00pci_register_multiwrite(rt2x00dev, beacon_base,
>                                       skb->data, skb->len);
> -       rt61pci_kick_tx_queue(rt2x00dev, control->queue);
> +       rt61pci_kick_tx_queue(rt2x00dev, RT2X00_BCN_QUEUE_BEACON);
>
>         return 0;
>  }
> --- everything.orig/drivers/net/wireless/rt2x00/rt73usb.c       2008-02-08 13:29:33.312003472 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt73usb.c    2008-02-08 14:03:58.542004394 +0100
> @@ -2010,13 +2010,8 @@ static int rt73usb_beacon_update(struct
>         skbdesc->desc_len = intf->beacon->queue->desc_size;
>         skbdesc->entry = intf->beacon;
>
> -       /*
> -        * mac80211 doesn't provide the control->queue variable
> -        * for beacons. Set our own queue identification so
> -        * it can be used during descriptor initialization.
> -        */
> -       control->queue = RT2X00_BCN_QUEUE_BEACON;
> -       rt2x00lib_write_tx_desc(rt2x00dev, skb, control);
> +       rt2x00lib_write_tx_desc(rt2x00dev, skb, control,
> +                               RT2X00_BCN_QUEUE_BEACON);
>
>         /*
>          * Write entire beacon with descriptor to register,
> @@ -2027,7 +2022,7 @@ static int rt73usb_beacon_update(struct
>         rt2x00usb_vendor_request(rt2x00dev, USB_MULTI_WRITE,
>                                  USB_VENDOR_REQUEST_OUT, beacon_base, 0,
>                                  skb->data, skb->len, timeout);
> -       rt73usb_kick_tx_queue(rt2x00dev, control->queue);
> +       rt73usb_kick_tx_queue(rt2x00dev, RT2X00_BCN_QUEUE_BEACON);
>
>         return 0;
>  }
>
>
>

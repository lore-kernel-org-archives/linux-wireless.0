Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:52877 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759982AbYBAXYO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 18:24:14 -0500
Received: by wa-out-1112.google.com with SMTP id v27so971244wah.23
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2008 15:24:14 -0800 (PST)
Message-ID: <1ba2fa240802011524g38a9583fs7c4b792bda844327@mail.gmail.com> (sfid-20080201_232421_375806_95FB3636)
Date: Sat, 2 Feb 2008 01:24:13 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 QoS/aggregation questions, thoughts
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jouni Malinen" <j@w1.fi>, "Ivo van Doorn" <ivdoorn@gmail.com>,
	"Patrick McHardy" <kaber@trash.net>
In-Reply-To: <1201902217.4188.82.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1201882512.4188.66.camel@johannes.berg>
	 <1201902217.4188.82.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 1, 2008 11:43 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Any thoughts on this patch? The only thing it should really actually
> change is removing the IBSS beacon queue configuration, but as I've
> explained previously that really has to be done by the driver because we
> don't know whether the driver even uses queues for beaconing... Also we
> never reset that info.
>
> Also, I'm wondering, iwl4965 has 16 queues, can it use 4 for regular WMM
> and the other 12 for aggregation? And how does it configure the access
> parameters for aggregation? I don't see conf_tx() calls anywhere for
> that.
>

4965 has 4 queues which are used for regular WMM.  Only 11 queues
might be used for aggregation, but in AP mode we might map one of the
queues to after beacon multicast traffic.
One queue is reserved for communicating with FW.  The number my differ
on further NICs.

All the traffic queues 4 WMM + 11 AGG are served according regular WMM
policy, 4 AC - these are configured by conf_tx.  The aggregation
queues are needed for handling ordering of frames correctly and not
for on media prioritizing

Sorry but I have to review your patch later
Thanks
Tomas



> johannes
>
> ---
>  drivers/net/wireless/rt2x00/rt2400pci.c |    6 +++---
>  drivers/net/wireless/rt2x00/rt2500pci.c |    8 ++++----
>  drivers/net/wireless/rt2x00/rt2500usb.c |   10 ++++------
>  drivers/net/wireless/rt2x00/rt2x00.h    |    6 ++++++
>  drivers/net/wireless/rt2x00/rt2x00dev.c |   12 ++++++------
>  drivers/net/wireless/rt2x00/rt2x00pci.c |    7 +++----
>  drivers/net/wireless/rt2x00/rt61pci.c   |   19 ++++++++++---------
>  drivers/net/wireless/rt2x00/rt73usb.c   |   10 ++++------
>  include/net/mac80211.h                  |   24 +++++-------------------
>  net/mac80211/debugfs.c                  |    4 ++--
>  net/mac80211/debugfs_sta.c              |    4 ++--
>  net/mac80211/ieee80211_i.h              |    4 ++--
>  net/mac80211/ieee80211_sta.c            |   10 ++--------
>  net/mac80211/wme.c                      |    4 ++--
>  14 files changed, 55 insertions(+), 73 deletions(-)
>
> --- everything.orig/include/net/mac80211.h      2008-02-01 21:49:26.168180664 +0100
> +++ everything/include/net/mac80211.h   2008-02-01 21:56:28.158178981 +0100
> @@ -127,34 +127,20 @@ struct ieee80211_tx_queue_stats_data {
>   * @IEEE80211_TX_QUEUE_DATA1: data queue 1
>   * @IEEE80211_TX_QUEUE_DATA2: data queue 2
>   * @IEEE80211_TX_QUEUE_DATA3: data queue 3
> - * @IEEE80211_TX_QUEUE_DATA4: data queue 4
> - * @IEEE80211_TX_QUEUE_SVP: ??
> - * @NUM_TX_DATA_QUEUES: number of data queues
> - * @IEEE80211_TX_QUEUE_AFTER_BEACON: transmit queue for frames to be
> - *     sent after a beacon
> - * @IEEE80211_TX_QUEUE_BEACON: transmit queue for beacon frames
> - * @NUM_TX_DATA_QUEUES_AMPDU: adding more queues for A-MPDU
> + * @IEEE80211_NUM_TX_DATA_QUEUES: number of data queues
> + * @IEEE80211_NUM_TX_DATA_QUEUES_AMPDU: adding more queues for A-MPDU
>   */
>  enum ieee80211_tx_queue {
>         IEEE80211_TX_QUEUE_DATA0,
>         IEEE80211_TX_QUEUE_DATA1,
>         IEEE80211_TX_QUEUE_DATA2,
>         IEEE80211_TX_QUEUE_DATA3,
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
> +       IEEE80211_NUM_TX_DATA_QUEUES,
> +       IEEE80211_NUM_TX_DATA_QUEUES_AMPDU = 16,
>  };
>
>  struct ieee80211_tx_queue_stats {
> -       struct ieee80211_tx_queue_stats_data data[NUM_TX_DATA_QUEUES_AMPDU];
> +       struct ieee80211_tx_queue_stats_data data[IEEE80211_NUM_TX_DATA_QUEUES_AMPDU];
>  };
>
>  struct ieee80211_low_level_stats {
> --- everything.orig/net/mac80211/ieee80211_i.h  2008-02-01 21:56:41.678182617 +0100
> +++ everything/net/mac80211/ieee80211_i.h       2008-02-01 21:57:13.008180501 +0100
> @@ -450,8 +450,8 @@ struct ieee80211_local {
>         struct sta_info *sta_hash[STA_HASH_SIZE];
>         struct timer_list sta_cleanup;
>
> -       unsigned long state[NUM_TX_DATA_QUEUES_AMPDU];
> -       struct ieee80211_tx_stored_packet pending_packet[NUM_TX_DATA_QUEUES_AMPDU];
> +       unsigned long state[IEEE80211_NUM_TX_DATA_QUEUES_AMPDU];
> +       struct ieee80211_tx_stored_packet pending_packet[IEEE80211_NUM_TX_DATA_QUEUES_AMPDU];
>         struct tasklet_struct tx_pending_tasklet;
>
>         /* number of interfaces with corresponding IFF_ flags */
> --- everything.orig/net/mac80211/ieee80211_sta.c        2008-02-01 21:52:05.988181315 +0100
> +++ everything/net/mac80211/ieee80211_sta.c     2008-02-01 21:58:02.408180935 +0100
> @@ -3231,17 +3231,11 @@ int ieee80211_sta_set_ssid(struct net_de
>                 qparam.cw_max = 1023;
>                 qparam.burst_time = 0;
>
> -               for (i = IEEE80211_TX_QUEUE_DATA0; i < NUM_TX_DATA_QUEUES; i++)
> +               for (i = IEEE80211_TX_QUEUE_DATA0;
> +                    i < IEEE80211_NUM_TX_DATA_QUEUES; i++)
>                         local->ops->conf_tx(local_to_hw(local),
>                                            i + IEEE80211_TX_QUEUE_DATA0,
>                                            &qparam);
> -
> -               /* IBSS uses different parameters for Beacon sending */
> -               qparam.cw_min++;
> -               qparam.cw_min *= 2;
> -               qparam.cw_min--;
> -               local->ops->conf_tx(local_to_hw(local),
> -                                  IEEE80211_TX_QUEUE_BEACON, &qparam);
>         }
>
>         ifsta = &sdata->u.sta;
> --- everything.orig/net/mac80211/wme.c  2008-02-01 21:54:35.928182237 +0100
> +++ everything/net/mac80211/wme.c       2008-02-01 21:57:42.178178982 +0100
> @@ -406,7 +406,7 @@ static int wme_qdiscop_init(struct Qdisc
>         }
>
>         /* reserve all legacy QoS queues */
> -       for (i = 0; i < min(IEEE80211_TX_QUEUE_DATA4, queues); i++)
> +       for (i = 0; i < min(IEEE80211_NUM_TX_DATA_QUEUES, queues); i++)
>                 set_bit(i, &q->qdisc_pool);
>
>         return err;
> @@ -667,7 +667,7 @@ int ieee80211_ht_agg_queue_add(struct ie
>          * matching the recieved HW queue */
>
>         /* try to get a Qdisc from the pool */
> -       for (i = IEEE80211_TX_QUEUE_BEACON; i < local->hw.queues; i++)
> +       for (i = IEEE80211_NUM_TX_DATA_QUEUES; i < local->hw.queues; i++)
>                 if (!test_and_set_bit(i, &q->qdisc_pool)) {
>                         ieee80211_stop_queue(local_to_hw(local), i);
>                         sta->tid_to_tx_q[tid] = i;
> --- everything.orig/net/mac80211/debugfs.c      2008-02-01 21:58:36.578182400 +0100
> +++ everything/net/mac80211/debugfs.c   2008-02-01 22:00:02.748177137 +0100
> @@ -222,10 +222,10 @@ static ssize_t stats_wme_tx_queue_read(s
>                                        size_t count, loff_t *ppos)
>  {
>         struct ieee80211_local *local = file->private_data;
> -       char buf[NUM_TX_DATA_QUEUES*15], *p = buf;
> +       char buf[IEEE80211_NUM_TX_DATA_QUEUES * 15], *p = buf;
>         int i;
>
> -       for (i = 0; i < NUM_TX_DATA_QUEUES; i++)
> +       for (i = 0; i < IEEE80211_NUM_TX_DATA_QUEUES; i++)
>                 p += scnprintf(p, sizeof(buf)+buf-p,
>                                "%u\n", local->wme_tx_queue[i]);
>
> --- everything.orig/net/mac80211/debugfs_sta.c  2008-02-01 21:59:01.668182074 +0100
> +++ everything/net/mac80211/debugfs_sta.c       2008-02-01 21:59:11.768178819 +0100
> @@ -167,10 +167,10 @@ STA_OPS(wme_rx_queue);
>  static ssize_t sta_wme_tx_queue_read(struct file *file, char __user *userbuf,
>                                      size_t count, loff_t *ppos)
>  {
> -       char buf[15*NUM_TX_DATA_QUEUES], *p = buf;
> +       char buf[15 * IEEE80211_NUM_TX_DATA_QUEUES], *p = buf;
>         int i;
>         struct sta_info *sta = file->private_data;
> -       for (i = 0; i < NUM_TX_DATA_QUEUES; i++)
> +       for (i = 0; i < IEEE80211_NUM_TX_DATA_QUEUES; i++)
>                 p += scnprintf(p, sizeof(buf)+buf-p, "%u ",
>                                sta->wme_tx_queue[i]);
>         p += scnprintf(p, sizeof(buf)+buf-p, "\n");
> --- everything.orig/drivers/net/wireless/rt2x00/rt2400pci.c     2008-02-01 22:07:51.948181639 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2400pci.c  2008-02-01 22:08:23.088177517 +0100
> @@ -1040,7 +1040,7 @@ static void rt2400pci_kick_tx_queue(stru
>  {
>         u32 reg;
>
> -       if (queue == IEEE80211_TX_QUEUE_BEACON) {
> +       if (queue == RT2X00_QUEUE_BEACON) {
>                 rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
>                 if (!rt2x00_get_field32(reg, CSR14_BEACON_GEN)) {
>                         rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
> @@ -1055,7 +1055,7 @@ static void rt2400pci_kick_tx_queue(stru
>         rt2x00_set_field32(&reg, TXCSR0_KICK_TX,
>                            (queue == IEEE80211_TX_QUEUE_DATA1));
>         rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM,
> -                          (queue == IEEE80211_TX_QUEUE_AFTER_BEACON));
> +                          (queue == RT2X00_QUEUE_BCMC));
>         rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
>  }
>
> @@ -1160,7 +1160,7 @@ static irqreturn_t rt2400pci_interrupt(i
>          * 3 - Atim ring transmit done interrupt.
>          */
>         if (rt2x00_get_field32(reg, CSR7_TXDONE_ATIMRING))
> -               rt2400pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_AFTER_BEACON);
> +               rt2400pci_txdone(rt2x00dev, RT2X00_QUEUE_BCMC);
>
>         /*
>          * 4 - Priority ring transmit done interrupt.
> --- everything.orig/drivers/net/wireless/rt2x00/rt2500pci.c     2008-02-01 22:08:36.438230143 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2500pci.c  2008-02-01 22:09:05.988178765 +0100
> @@ -275,7 +275,7 @@ static void rt2500pci_config_type(struct
>                            PREAMBLE + get_duration(IEEE80211_HEADER, 20));
>         rt2x00_set_field32(&reg, BCNCSR1_BEACON_CWMIN,
>                            rt2x00lib_get_ring(rt2x00dev,
> -                                             IEEE80211_TX_QUEUE_BEACON)
> +                                             RT2X00_QUEUE_BEACON)
>                            ->tx_params.cw_min);
>         rt2x00pci_register_write(rt2x00dev, BCNCSR1, reg);
>
> @@ -1192,7 +1192,7 @@ static void rt2500pci_kick_tx_queue(stru
>  {
>         u32 reg;
>
> -       if (queue == IEEE80211_TX_QUEUE_BEACON) {
> +       if (queue == RT2X00_QUEUE_BEACON) {
>                 rt2x00pci_register_read(rt2x00dev, CSR14, &reg);
>                 if (!rt2x00_get_field32(reg, CSR14_BEACON_GEN)) {
>                         rt2x00_set_field32(&reg, CSR14_BEACON_GEN, 1);
> @@ -1207,7 +1207,7 @@ static void rt2500pci_kick_tx_queue(stru
>         rt2x00_set_field32(&reg, TXCSR0_KICK_TX,
>                            (queue == IEEE80211_TX_QUEUE_DATA1));
>         rt2x00_set_field32(&reg, TXCSR0_KICK_ATIM,
> -                          (queue == IEEE80211_TX_QUEUE_AFTER_BEACON));
> +                          (queue == RT2X00_QUEUE_BCMC));
>         rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
>  }
>
> @@ -1309,7 +1309,7 @@ static irqreturn_t rt2500pci_interrupt(i
>          * 3 - Atim ring transmit done interrupt.
>          */
>         if (rt2x00_get_field32(reg, CSR7_TXDONE_ATIMRING))
> -               rt2500pci_txdone(rt2x00dev, IEEE80211_TX_QUEUE_AFTER_BEACON);
> +               rt2500pci_txdone(rt2x00dev, RT2X00_QUEUE_BCMC);
>
>         /*
>          * 4 - Priority ring transmit done interrupt.
> --- everything.orig/drivers/net/wireless/rt2x00/rt2500usb.c     2008-02-01 22:12:41.858182942 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2500usb.c  2008-02-01 22:13:04.698180447 +0100
> @@ -1088,7 +1088,7 @@ static void rt2500usb_kick_tx_queue(stru
>  {
>         u16 reg;
>
> -       if (queue != IEEE80211_TX_QUEUE_BEACON)
> +       if (queue != RT2X00_QUEUE_BEACON)
>                 return;
>
>         rt2500usb_register_read(rt2x00dev, TXRX_CSR19, &reg);
> @@ -1697,11 +1697,9 @@ static int rt2500usb_beacon_update(struc
>         int length;
>
>         /*
> -        * Just in case the ieee80211 doesn't set this,
> -        * but we need this queue set for the descriptor
> -        * initialization.
> +        * mac80211 doesn't set this but we use a queue for beacons
>          */
> -       control->queue = IEEE80211_TX_QUEUE_BEACON;
> +       control->queue = RT2X00_QUEUE_BEACON;
>         ring = rt2x00lib_get_ring(rt2x00dev, control->queue);
>
>         /*
> @@ -1758,7 +1756,7 @@ static int rt2500usb_beacon_update(struc
>         /*
>          * Enable beacon generation.
>          */
> -       rt2500usb_kick_tx_queue(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
> +       rt2500usb_kick_tx_queue(rt2x00dev, RT2X00_QUEUE_BEACON);
>
>         return 0;
>  }
> --- everything.orig/drivers/net/wireless/rt2x00/rt2x00.h        2008-02-01 22:05:11.038210937 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2x00.h     2008-02-01 22:09:22.358177843 +0100
> @@ -100,6 +100,12 @@
>  #define MGMT_FRAME_SIZE        256
>
>  /*
> + * Internal queue numbers for beacon and buffered broadcast/multicast traffic.
> + */
> +#define RT2X00_QUEUE_BEACON    100
> +#define RT2X00_QUEUE_BCMC      101
> +
> +/*
>   * Number of entries in a packet ring.
>   * PCI devices only need 1 Beacon entry,
>   * but USB devices require a second because they
> --- everything.orig/drivers/net/wireless/rt2x00/rt2x00dev.c     2008-02-01 22:02:56.938182780 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2x00dev.c  2008-02-01 22:06:28.338180393 +0100
> @@ -49,9 +49,9 @@ struct data_ring *rt2x00lib_get_ring(str
>         if (!rt2x00dev->bcn || !beacon)
>                 return NULL;
>
> -       if (queue == IEEE80211_TX_QUEUE_BEACON)
> +       if (queue == RT2X00_QUEUE_BEACON)
>                 return &rt2x00dev->bcn[0];
> -       else if (queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
> +       else if (queue == RT2X00_QUEUE_BCMC)
>                 return &rt2x00dev->bcn[1];
>
>         return NULL;
> @@ -502,7 +502,7 @@ static void rt2x00lib_beacondone_schedul
>         struct rt2x00_dev *rt2x00dev =
>             container_of(work, struct rt2x00_dev, beacon_work);
>         struct data_ring *ring =
> -           rt2x00lib_get_ring(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
> +           rt2x00lib_get_ring(rt2x00dev, RT2X00_QUEUE_BEACON);
>         struct data_entry *entry = rt2x00_get_data_entry(ring);
>         struct sk_buff *skb;
>
> @@ -665,8 +665,8 @@ void rt2x00lib_write_tx_desc(struct rt2x
>          */
>         if (control->queue < rt2x00dev->hw->queues)
>                 desc.queue = control->queue;
> -       else if (control->queue == IEEE80211_TX_QUEUE_BEACON ||
> -                control->queue == IEEE80211_TX_QUEUE_AFTER_BEACON)
> +       else if (control->queue == RT2X00_QUEUE_BEACON ||
> +                control->queue == RT2X00_QUEUE_BCMC)
>                 desc.queue = QUEUE_MGMT;
>         else
>                 desc.queue = QUEUE_OTHER;
> @@ -717,7 +717,7 @@ void rt2x00lib_write_tx_desc(struct rt2x
>          * Beacons and probe responses require the tsf timestamp
>          * to be inserted into the frame.
>          */
> -       if (control->queue == IEEE80211_TX_QUEUE_BEACON ||
> +       if (control->queue == RT2X00_QUEUE_BEACON ||
>             is_probe_resp(frame_control))
>                 __set_bit(ENTRY_TXD_REQ_TIMESTAMP, &desc.flags);
>
> --- everything.orig/drivers/net/wireless/rt2x00/rt2x00pci.c     2008-02-01 22:07:08.708181857 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt2x00pci.c  2008-02-01 22:07:41.538180176 +0100
> @@ -43,11 +43,10 @@ int rt2x00pci_beacon_update(struct ieee8
>         struct data_entry *entry;
>
>         /*
> -        * Just in case mac80211 doesn't set this correctly,
> -        * but we need this queue set for the descriptor
> -        * initialization.
> +        * mac80211 doesn't set the queue but we use an internal
> +        * number here that we later translate to the right thing.
>          */
> -       control->queue = IEEE80211_TX_QUEUE_BEACON;
> +       control->queue = RT2X00_QUEUE_BEACON;
>         ring = rt2x00lib_get_ring(rt2x00dev, control->queue);
>         entry = rt2x00_get_data_entry(ring);
>
> --- everything.orig/drivers/net/wireless/rt2x00/rt61pci.c       2008-02-01 22:09:43.378180447 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt61pci.c    2008-02-01 22:12:26.208178873 +0100
> @@ -1049,8 +1049,9 @@ static int rt61pci_init_rings(struct rt2
>         rt2x00pci_register_write(rt2x00dev, TX_RING_CSR0, reg);
>
>         rt2x00pci_register_read(rt2x00dev, TX_RING_CSR1, &reg);
> +       /* XXX: what is this fifth queue? */
>         rt2x00_set_field32(&reg, TX_RING_CSR1_MGMT_RING_SIZE,
> -                          rt2x00dev->tx[IEEE80211_TX_QUEUE_DATA4].stats.limit);
> +                          rt2x00dev->tx[4].stats.limit);
>         rt2x00_set_field32(&reg, TX_RING_CSR1_TXD_SIZE,
>                            rt2x00dev->tx[IEEE80211_TX_QUEUE_DATA0].desc_size /
>                            4);
> @@ -1077,8 +1078,9 @@ static int rt61pci_init_rings(struct rt2
>         rt2x00pci_register_write(rt2x00dev, AC3_BASE_CSR, reg);
>
>         rt2x00pci_register_read(rt2x00dev, MGMT_BASE_CSR, &reg);
> +       /* fifth queue again? */
>         rt2x00_set_field32(&reg, MGMT_BASE_CSR_RING_REGISTER,
> -                          rt2x00dev->tx[IEEE80211_TX_QUEUE_DATA4].data_dma);
> +                          rt2x00dev->tx[4].data_dma);
>         rt2x00pci_register_write(rt2x00dev, MGMT_BASE_CSR, reg);
>
>         rt2x00pci_register_read(rt2x00dev, RX_RING_CSR, &reg);
> @@ -1572,7 +1574,7 @@ static void rt61pci_kick_tx_queue(struct
>  {
>         u32 reg;
>
> -       if (queue == IEEE80211_TX_QUEUE_BEACON) {
> +       if (queue == RT2X00_QUEUE_BEACON) {
>                 /*
>                  * For Wi-Fi faily generated beacons between participating
>                  * stations. Set TBTT phase adaptive adjustment step to 8us.
> @@ -1596,8 +1598,9 @@ static void rt61pci_kick_tx_queue(struct
>                            (queue == IEEE80211_TX_QUEUE_DATA2));
>         rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3,
>                            (queue == IEEE80211_TX_QUEUE_DATA3));
> +       /* fifth queue? never used in mac80211 right now... */
>         rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_MGMT,
> -                          (queue == IEEE80211_TX_QUEUE_DATA4));
> +                          (queue == 4));
>         rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
>  }
>
> @@ -2383,11 +2386,9 @@ static int rt61pci_beacon_update(struct
>         struct data_entry *entry;
>
>         /*
> -        * Just in case the ieee80211 doesn't set this,
> -        * but we need this queue set for the descriptor
> -        * initialization.
> +        * mac80211 doesn't set this but we need it
>          */
> -       control->queue = IEEE80211_TX_QUEUE_BEACON;
> +       control->queue = RT2X00_QUEUE_BEACON;
>         ring = rt2x00lib_get_ring(rt2x00dev, control->queue);
>         entry = rt2x00_get_data_entry(ring);
>
> @@ -2427,7 +2428,7 @@ static int rt61pci_beacon_update(struct
>          */
>         rt2x00pci_register_multiwrite(rt2x00dev, HW_BEACON_BASE0,
>                                       skb->data, skb->len);
> -       rt61pci_kick_tx_queue(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
> +       rt61pci_kick_tx_queue(rt2x00dev, RT2X00_QUEUE_BEACON);
>
>         return 0;
>  }
> --- everything.orig/drivers/net/wireless/rt2x00/rt73usb.c       2008-02-01 22:13:24.188182129 +0100
> +++ everything/drivers/net/wireless/rt2x00/rt73usb.c    2008-02-01 22:13:55.278180827 +0100
> @@ -1310,7 +1310,7 @@ static void rt73usb_kick_tx_queue(struct
>  {
>         u32 reg;
>
> -       if (queue != IEEE80211_TX_QUEUE_BEACON)
> +       if (queue != RT2X00_QUEUE_BEACON)
>                 return;
>
>         /*
> @@ -1970,11 +1970,9 @@ static int rt73usb_beacon_update(struct
>         int timeout;
>
>         /*
> -        * Just in case the ieee80211 doesn't set this,
> -        * but we need this queue set for the descriptor
> -        * initialization.
> +        * mac80211 doesn't set this but we use a queue for beacons
>          */
> -       control->queue = IEEE80211_TX_QUEUE_BEACON;
> +       control->queue = RT2X00_QUEUE_BEACON;
>         ring = rt2x00lib_get_ring(rt2x00dev, control->queue);
>         entry = rt2x00_get_data_entry(ring);
>
> @@ -2006,7 +2004,7 @@ static int rt73usb_beacon_update(struct
>                                  USB_VENDOR_REQUEST_OUT,
>                                  HW_BEACON_BASE0, 0x0000,
>                                  skb->data, skb->len, timeout);
> -       rt73usb_kick_tx_queue(rt2x00dev, IEEE80211_TX_QUEUE_BEACON);
> +       rt73usb_kick_tx_queue(rt2x00dev, RT2X00_QUEUE_BEACON);
>
>         return 0;
>  }
>
>

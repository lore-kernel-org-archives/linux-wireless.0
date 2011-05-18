Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59475 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab1ERAJZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 20:09:25 -0400
Received: by vxi39 with SMTP id 39so753643vxi.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 17:09:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305149577-2636-1-git-send-email-jlopex@gmail.com>
References: <BANLkTi=_snQBSFH-d344bjk8-aSeC9Jh5w@mail.gmail.com> <1305149577-2636-1-git-send-email-jlopex@gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Tue, 17 May 2011 17:09:04 -0700
Message-ID: <BANLkTi=r4pVifQ_6X7pARvkUWVGAfMgmHg@mail.gmail.com> (sfid-20110518_020929_899832_A1C56A45)
Subject: Re: [PATCH v4] mac80211_hwsim driver support userspace frame tx/rx
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, j@w1.fi,
	Javier Lopez <jlopex@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

We've confirmed that this works as documented and makes hwsim very
useful for testing the wireless stack over lossy channels.  If no one
has major objections, can you consider it for inclusion?

Cheers,

Javier


On Wed, May 11, 2011 at 2:32 PM, Javier Lopez <jlopex@gmail.com> wrote:
> Hi all,
>
> Thanks for all your previous comments Johannes, I tried to implement all the solutions you proposed me, they were very helpful.
>
> In this new version of the patch I avoid the exchange of the Custom Buffer with the userspace. Instead of this I enqueue all pending skb's, for each pending skb a cookie is created and attached to the HWSIM_CMD_FRAME and HWSIM_CMD_TX_INFO.
>
> Any new comments from this patch?
>
> Thanks a lot,
>
> Feel free to download the last version of the wmediumd tool from GitHub:
>
> - Last version tarball: https://github.com/jlopex/cozybit/tarball/master
> - Or visiting my github tree: https://github.com/jlopex/cozybit/tree
>
> Javi
>
> Signed-off-by: Javier Lopez <jlopex@gmail.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c |  401 +++++++++++++++++++++++++++++++--
>  drivers/net/wireless/mac80211_hwsim.h |  114 ++++++++++
>  2 files changed, 499 insertions(+), 16 deletions(-)
>  create mode 100644 drivers/net/wireless/mac80211_hwsim.h
>
> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
> index f4f4257..fdb8a00 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -1,6 +1,7 @@
>  /*
>  * mac80211_hwsim - software simulator of 802.11 radio(s) for mac80211
>  * Copyright (c) 2008, Jouni Malinen <j@w1.fi>
> + * Copyright (c) 2011, Javier Lopez <jlopex@gmail.com>
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License version 2 as
> @@ -25,11 +26,18 @@
>  #include <linux/rtnetlink.h>
>  #include <linux/etherdevice.h>
>  #include <linux/debugfs.h>
> +#include <net/genetlink.h>
> +#include "mac80211_hwsim.h"
> +
> +#define WARN_QUEUE 100
> +#define MAX_QUEUE 200
>
>  MODULE_AUTHOR("Jouni Malinen");
>  MODULE_DESCRIPTION("Software simulator of 802.11 radio(s) for mac80211");
>  MODULE_LICENSE("GPL");
>
> +static atomic_t wmediumd_pid;
> +
>  static int radios = 2;
>  module_param(radios, int, 0444);
>  MODULE_PARM_DESC(radios, "Number of simulated radios");
> @@ -302,6 +310,8 @@ struct mac80211_hwsim_data {
>        struct dentry *debugfs;
>        struct dentry *debugfs_ps;
>
> +       struct sk_buff_head pending;    /* packets pending */
> +
>        /*
>         * Only radios in the same group can communicate together (the
>         * channel has to match too). Each bit represents a group. A
> @@ -322,6 +332,14 @@ struct hwsim_radiotap_hdr {
>        __le16 rt_chbitmask;
>  } __packed;
>
> +/* MAC80211_HWSIM netlink family */
> +static struct genl_family hwsim_genl_family = {
> +       .id = GENL_ID_GENERATE,
> +       .hdrsize = 0,
> +       .name = "MAC80211_HWSIM",
> +       .version = VERSION_NR,
> +       .maxattr = HWSIM_ATTR_MAX,
> +};
>
>  static netdev_tx_t hwsim_mon_xmit(struct sk_buff *skb,
>                                        struct net_device *dev)
> @@ -478,21 +496,90 @@ static bool mac80211_hwsim_addr_match(struct mac80211_hwsim_data *data,
>        return md.ret;
>  }
>
> +static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
> +                                   struct sk_buff *my_skb)
> +{
> +       struct sk_buff *skb;
> +       struct mac80211_hwsim_data *data = hw->priv;
> +       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) my_skb->data;
> +       struct ieee80211_tx_info *info = IEEE80211_SKB_CB(my_skb);
> +       void *msg_head;
>
> -static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
> -                                   struct sk_buff *skb)
> +       if (data->idle) {
> +               wiphy_debug(hw->wiphy, "Trying to TX when idle - reject\n");
> +               dev_kfree_skb(my_skb);
> +               return;
> +       }
> +
> +       if (data->ps != PS_DISABLED)
> +               hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
> +
> +       /* If the queue contains MAX_QUEUE skb's drop some */
> +       if (skb_queue_len(&data->pending) >= MAX_QUEUE) {
> +
> +               printk(KERN_DEBUG "mac80211_hwsim: queues at maximum level, "
> +                       "droping some old frames\n");
> +               while (skb_queue_len(&data->pending) >= WARN_QUEUE)
> +                       skb_dequeue(&data->pending);
> +       }
> +
> +       skb = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
> +       if (skb == NULL)
> +               goto nla_put_failure;
> +
> +       msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
> +                              HWSIM_CMD_FRAME);
> +       if (msg_head == NULL) {
> +               printk(KERN_DEBUG "mac80211_hwsim: problem with msg_head\n");
> +               goto nla_put_failure;
> +       }
> +
> +       NLA_PUT(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
> +                    sizeof(struct mac_address), data->addresses[1].addr);
> +
> +       /* We get the skb->data */
> +       NLA_PUT(skb, HWSIM_ATTR_FRAME, my_skb->len, my_skb->data);
> +
> +       /* We get the flags for this transmission, wmediumd maybe
> +          changes its behaviour depending on the flags */
> +       NLA_PUT_U32(skb, HWSIM_ATTR_FLAGS, info->flags);
> +
> +       /* We get the tx control (rate and retries) info*/
> +       NLA_PUT(skb, HWSIM_ATTR_TX_INFO,
> +                    sizeof(struct ieee80211_tx_rate)*IEEE80211_TX_MAX_RATES,
> +                    info->control.rates);
> +       /* We create a cookie to identify this skb */
> +       NLA_PUT_U32(skb, HWSIM_ATTR_COOKIE, (unsigned long) my_skb);
> +
> +       genlmsg_end(skb, msg_head);
> +       genlmsg_unicast(&init_net, skb, atomic_read(&wmediumd_pid));
> +
> +       /* Enqueue the packet */
> +       skb_queue_tail(&data->pending, my_skb);
> +       return;
> +
> +nla_put_failure:
> +       printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
> +}
> +
> +static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
> +                                         struct sk_buff *skb)
>  {
>        struct mac80211_hwsim_data *data = hw->priv, *data2;
> -       bool ack = false;
>        struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>        struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>        struct ieee80211_rx_status rx_status;
>
> +       bool ack = false;
> +
>        if (data->idle) {
>                wiphy_debug(hw->wiphy, "Trying to TX when idle - reject\n");
>                return false;
>        }
>
> +       if (data->ps != PS_DISABLED)
> +               hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
> +
>        memset(&rx_status, 0, sizeof(rx_status));
>        /* TODO: set mactime */
>        rx_status.freq = data->channel->center_freq;
> @@ -501,9 +588,6 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
>        /* TODO: simulate real signal strength (and optional packet loss) */
>        rx_status.signal = data->power_level - 50;
>
> -       if (data->ps != PS_DISABLED)
> -               hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
> -
>        /* release the skb's source info */
>        skb_orphan(skb);
>        skb_dst_drop(skb);
> @@ -530,9 +614,10 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
>                if (nskb == NULL)
>                        continue;
>
> +               memcpy(IEEE80211_SKB_RXCB(nskb), &rx_status, sizeof(rx_status));
> +
>                if (mac80211_hwsim_addr_match(data2, hdr->addr1))
>                        ack = true;
> -               memcpy(IEEE80211_SKB_RXCB(nskb), &rx_status, sizeof(rx_status));
>                ieee80211_rx_irqsafe(data2->hw, nskb);
>        }
>        spin_unlock(&hwsim_radio_lock);
> @@ -540,6 +625,15 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
>        return ack;
>  }
>
> +static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
> +                                   struct sk_buff *skb)
> +{
> +       if (atomic_read(&wmediumd_pid)) {
> +               mac80211_hwsim_tx_frame_nl(hw, skb);
> +               return true;
> +       } else
> +               return mac80211_hwsim_tx_frame_no_nl(hw, skb);
> +}
>
>  static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  {
> @@ -555,6 +649,12 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>        }
>
>        ack = mac80211_hwsim_tx_frame(hw, skb);
> +
> +       /* wmediumd mode*/
> +       if (atomic_read(&wmediumd_pid))
> +               return;
> +
> +       /* NO wmediumd, normal mac80211_hwsim behaviour*/
>        if (ack && skb->len >= 16) {
>                struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
>                mac80211_hwsim_monitor_ack(hw, hdr->addr2);
> @@ -571,6 +671,7 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>        if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK) && ack)
>                txi->flags |= IEEE80211_TX_STAT_ACK;
>        ieee80211_tx_status_irqsafe(hw, skb);
> +
>  }
>
>
> @@ -650,7 +751,6 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
>
>        mac80211_hwsim_monitor_rx(hw, skb);
>        mac80211_hwsim_tx_frame(hw, skb);
> -       dev_kfree_skb(skb);
>  }
>
>
> @@ -966,12 +1066,9 @@ static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
>
>  static void mac80211_hwsim_flush(struct ieee80211_hw *hw, bool drop)
>  {
> -       /*
> -        * In this special case, there's nothing we need to
> -        * do because hwsim does transmission synchronously.
> -        * In the future, when it does transmissions via
> -        * userspace, we may need to do something.
> -        */
> +       /* Let's purge the pending queue */
> +       struct mac80211_hwsim_data *data = hw->priv;
> +       skb_queue_purge(&data->pending);
>  }
>
>  struct hw_scan_done {
> @@ -1139,7 +1236,6 @@ static void hwsim_send_ps_poll(void *dat, u8 *mac, struct ieee80211_vif *vif)
>        memcpy(pspoll->ta, mac, ETH_ALEN);
>        if (!mac80211_hwsim_tx_frame(data->hw, skb))
>                printk(KERN_DEBUG "%s: PS-Poll frame not ack'ed\n", __func__);
> -       dev_kfree_skb(skb);
>  }
>
>
> @@ -1170,7 +1266,6 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
>        memcpy(hdr->addr3, vp->bssid, ETH_ALEN);
>        if (!mac80211_hwsim_tx_frame(data->hw, skb))
>                printk(KERN_DEBUG "%s: nullfunc frame not ack'ed\n", __func__);
> -       dev_kfree_skb(skb);
>  }
>
>
> @@ -1244,6 +1339,264 @@ static int hwsim_fops_group_write(void *dat, u64 val)
>        return 0;
>  }
>
> +
> +struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(
> +                            struct mac_address *addr)
> +{
> +       struct mac80211_hwsim_data *data;
> +       bool _found = false;
> +
> +       spin_lock_bh(&hwsim_radio_lock);
> +       list_for_each_entry(data, &hwsim_radios, list) {
> +               if (memcmp(data->addresses[1].addr, addr,
> +                         sizeof(struct mac_address)) == 0) {
> +                       _found = true;
> +                       break;
> +               }
> +       }
> +       spin_unlock_bh(&hwsim_radio_lock);
> +
> +       if (!_found) {
> +               printk(KERN_DEBUG "mac80211_hwsim: invalid radio ID\n");
> +               return NULL;
> +       }
> +
> +       return data;
> +}
> +
> +static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
> +                                          struct genl_info *info)
> +{
> +
> +       struct ieee80211_hdr *hdr;
> +       struct mac80211_hwsim_data *data2;
> +       struct ieee80211_tx_info *txi;
> +       struct ieee80211_tx_rate *tx_attempts;
> +       struct sk_buff __user *ret_skb;
> +       struct sk_buff *skb = NULL, *tmp;
> +
> +       int i;
> +       bool found = false;
> +
> +       struct mac_address *dst = (struct mac_address *)nla_data(
> +                                  info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
> +       int flags = nla_get_u32(info->attrs[HWSIM_ATTR_FLAGS]);
> +
> +       ret_skb = (struct sk_buff __user *)
> +                 (unsigned long) nla_get_u32(info->attrs[HWSIM_ATTR_COOKIE]);
> +
> +       data2 = get_hwsim_data_ref_from_addr(dst);
> +
> +       if (data2 == NULL)
> +               goto out;
> +
> +       /* look for the skb matching the cookie passed back from user */
> +       skb_queue_walk_safe(&data2->pending, skb, tmp) {
> +               if (skb == ret_skb) {
> +                       skb_unlink(skb, &data2->pending);
> +                       found = true;
> +                       break;
> +               }
> +       }
> +
> +       /* not found */
> +       if (!found)
> +               return -1;
> +
> +       /* Tx info received because the frame was broadcasted on user space,
> +        so we get all the necessary info: tx attempts and skb control buff */
> +
> +       tx_attempts = (struct ieee80211_tx_rate *)nla_data(
> +                      info->attrs[HWSIM_ATTR_TX_INFO]);
> +
> +       if (tx_attempts == NULL)
> +               goto out;
> +
> +       /* now send back TX status */
> +       txi = IEEE80211_SKB_CB(skb);
> +
> +       if (txi->control.vif)
> +               hwsim_check_magic(txi->control.vif);
> +       if (txi->control.sta)
> +               hwsim_check_sta_magic(txi->control.sta);
> +
> +       ieee80211_tx_info_clear_status(txi);
> +       txi->flags = flags;
> +
> +       for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
> +               txi->status.rates[i].idx = tx_attempts[i].idx;
> +               txi->status.rates[i].count = tx_attempts[i].count;
> +               txi->status.rates[i].flags = tx_attempts[i].flags;
> +       }
> +
> +       txi->status.ack_signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
> +
> +       if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK) &&
> +          (txi->flags & IEEE80211_TX_STAT_ACK)) {
> +               if (skb->len >= 16) {
> +                       hdr = (struct ieee80211_hdr *) skb->data;
> +                       mac80211_hwsim_monitor_ack(data2->hw, hdr->addr2);
> +               }
> +       }
> +       ieee80211_tx_status_irqsafe(data2->hw, skb);
> +
> +       return 0;
> +
> +out:
> +       printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
> +       return -1;
> +
> +}
> +
> +static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
> +                                         struct genl_info *info)
> +{
> +
> +       struct mac80211_hwsim_data *data2;
> +       struct ieee80211_rx_status rx_status;
> +
> +       struct mac_address *dst = (struct mac_address *)nla_data(
> +                                  info->attrs[HWSIM_ATTR_ADDR_RECEIVER]);
> +
> +       int frame_data_len = nla_len(info->attrs[HWSIM_ATTR_FRAME]);
> +       char* frame_data = (char *)nla_data(info->attrs[HWSIM_ATTR_FRAME]);
> +       /* Allocate new skb here */
> +       struct sk_buff *skb = alloc_skb(frame_data_len, GFP_KERNEL);
> +       if (skb == NULL)
> +               goto out;
> +
> +       if (frame_data_len <= IEEE80211_MAX_DATA_LEN) {
> +               /* Copy the data */
> +               memcpy(skb_put(skb, frame_data_len), frame_data,
> +                      frame_data_len);
> +       } else
> +               goto out;
> +
> +       data2 = get_hwsim_data_ref_from_addr(dst);
> +
> +       if (data2 == NULL)
> +               goto out;
> +
> +       /*A frame is received from user space*/
> +       memset(&rx_status, 0, sizeof(rx_status));
> +       rx_status.freq = data2->channel->center_freq;
> +       rx_status.band = data2->channel->band;
> +       rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
> +       rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
> +
> +       memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
> +       ieee80211_rx_irqsafe(data2->hw, skb);
> +
> +       return 0;
> +out:
> +       kfree_skb(skb);
> +       printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
> +       return -1;
> +}
> +
> +static int hwsim_register_received_nl(struct sk_buff *skb_2,
> +                                     struct genl_info *info)
> +{
> +       if (info == NULL)
> +               goto out;
> +
> +       atomic_set(&wmediumd_pid, info->snd_pid);
> +
> +       printk(KERN_DEBUG "mac80211_hwsim: received a REGISTER, "
> +              "switching to wmediumd mode with pid %d\n", info->snd_pid);
> +
> +       return 0;
> +
> +out:
> +       printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
> +       return -1;
> +}
> +
> +/* Generic Netlink operations array */
> +static struct genl_ops hwsim_ops[] = {
> +       {
> +               .cmd = HWSIM_CMD_REGISTER,
> +               .flags = 0,
> +               .policy = hwsim_genl_policy,
> +               .doit = hwsim_register_received_nl,
> +               .dumpit = NULL,
> +       },
> +       {
> +               .cmd = HWSIM_CMD_FRAME,
> +               .flags = 0,
> +               .policy = hwsim_genl_policy,
> +               .doit = hwsim_cloned_frame_received_nl,
> +               .dumpit = NULL,
> +       },
> +       {
> +               .cmd = HWSIM_CMD_TX_INFO_FRAME,
> +               .flags = 0,
> +               .policy = hwsim_genl_policy,
> +               .doit = hwsim_tx_info_frame_received_nl,
> +               .dumpit = NULL,
> +       },
> +};
> +
> +static int mac80211_hwsim_netlink_notify(struct notifier_block *nb,
> +                                        unsigned long state,
> +                                        void *_notify)
> +{
> +       struct netlink_notify *notify = _notify;
> +
> +       if (state != NETLINK_URELEASE)
> +               return NOTIFY_DONE;
> +
> +       if (notify->pid == atomic_read(&wmediumd_pid)) {
> +               printk(KERN_INFO "mac80211_hwsim: wmediumd released netlink"
> +                      " socket, switching to perfect channel medium\n");
> +               atomic_set(&wmediumd_pid, 0);
> +       }
> +       return NOTIFY_DONE;
> +
> +}
> +
> +static struct notifier_block hwsim_netlink_notifier = {
> +       .notifier_call = mac80211_hwsim_netlink_notify,
> +};
> +
> +static int hwsim_init_netlink(void)
> +{
> +       int rc;
> +       printk(KERN_INFO "mac80211_hwsim: initializing netlink\n");
> +
> +       atomic_set(&wmediumd_pid, 0);
> +
> +       rc = genl_register_family_with_ops(&hwsim_genl_family,
> +               hwsim_ops, ARRAY_SIZE(hwsim_ops));
> +       if (rc)
> +               goto failure;
> +
> +       rc = netlink_register_notifier(&hwsim_netlink_notifier);
> +       if (rc)
> +               goto failure;
> +
> +       return 0;
> +
> +failure:
> +       printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
> +       return -1;
> +}
> +
> +static void hwsim_exit_netlink(void)
> +{
> +       int ret;
> +
> +       printk(KERN_INFO "mac80211_hwsim: closing netlink\n");
> +       /* unregister the notifier */
> +       netlink_unregister_notifier(&hwsim_netlink_notifier);
> +       /* unregister the family */
> +       ret = genl_unregister_family(&hwsim_genl_family);
> +       if (ret)
> +               printk(KERN_DEBUG "mac80211_hwsim: "
> +                      "unregister family %i\n", ret);
> +}
> +
> +
>  DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_group,
>                        hwsim_fops_group_read, hwsim_fops_group_write,
>                        "%llx\n");
> @@ -1299,6 +1652,8 @@ static int __init init_mac80211_hwsim(void)
>                }
>                data->dev->driver = &mac80211_hwsim_driver;
>
> +               skb_queue_head_init(&data->pending);
> +
>                SET_IEEE80211_DEV(hw, data->dev);
>                addr[3] = i >> 8;
>                addr[4] = i;
> @@ -1379,6 +1734,10 @@ static int __init init_mac80211_hwsim(void)
>                data->group = 1;
>                mutex_init(&data->mutex);
>
> +               /* Enable frame retransmission mechanism for a lossy channel */
> +               hw->max_rates = 4;
> +               hw->max_rate_tries = 11;
> +
>                /* Work to be done prior to ieee80211_register_hw() */
>                switch (regtest) {
>                case HWSIM_REGTEST_DISABLED:
> @@ -1528,8 +1887,16 @@ static int __init init_mac80211_hwsim(void)
>
>        rtnl_unlock();
>
> +       err = hwsim_init_netlink();
> +       if (err < 0)
> +               goto failed_nl;
> +
>        return 0;
>
> +failed_nl:
> +       printk(KERN_DEBUG "mac80211_hwsim: failed initializing netlink\n");
> +       return err;
> +
>  failed_mon:
>        rtnl_unlock();
>        free_netdev(hwsim_mon);
> @@ -1550,6 +1917,8 @@ static void __exit exit_mac80211_hwsim(void)
>  {
>        printk(KERN_DEBUG "mac80211_hwsim: unregister radios\n");
>
> +       hwsim_exit_netlink();
> +
>        mac80211_hwsim_free();
>        unregister_netdev(hwsim_mon);
>  }
> diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
> new file mode 100644
> index 0000000..803786e
> --- /dev/null
> +++ b/drivers/net/wireless/mac80211_hwsim.h
> @@ -0,0 +1,114 @@
> +/*
> + * mac80211_hwsim - software simulator of 802.11 radio(s) for mac80211
> + * Copyright (c) 2008, Jouni Malinen <j@w1.fi>
> + * Copyright (c) 2011, Javier Lopez <jlopex@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <net/mac80211.h>
> +
> +/**
> + * DOC: Frame transmission/registration support
> + *
> + * Frame transmission and registration support exists to allow userspace
> + * entities such as wmediumd to receive and process all broadcasted
> + * frames from a mac80211_hwsim radio device.
> + *
> + * This allow user space applications to decide if the frame should be
> + * dropped or not and implement a wireless medium simulator at user space.
> + *
> + * Registration is done by sending a register message to the driver and
> + * will be automatically unregistered if the user application doesn't
> + * responds to sent frames.
> + * Once registered the user application has to take responsibility of
> + * broadcasting the frames to all listening mac80211_hwsim radio
> + * interfaces.
> + *
> + * For more technical details, see the corresponding command descriptions
> + * below.
> + */
> +
> +/**
> + * enum hwsim_commands - supported hwsim commands
> + *
> + * @HWSIM_CMD_UNSPEC: unspecified command to catch errors
> + *
> + * @HWSIM_CMD_REGISTER: request to register and received all broadcasted
> + *     frames by any mac80211_hwsim radio device.
> + * @HWSIM_CMD_FRAME: send/receive a broadcasted frame from/to kernel/user
> + * space, uses:
> + *     %HWSIM_ATTR_ADDR_TRANSMITTER, %HWSIM_ATTR_ADDR_RECEIVER,
> + *     %HWSIM_ATTR_FRAME, %HWSIM_ATTR_FLAGS, %HWSIM_ATTR_RX_RATE,
> + *     %HWSIM_ATTR_SIGNAL, %HWSIM_ATTR_COOKIE
> + * @HWSIM_CMD_TX_INFO_FRAME: Transmission info report from user space to
> + * kernel, uses:
> + *     %HWSIM_ATTR_ADDR_TRANSMITTER, %HWSIM_ATTR_FLAGS,
> + *     %HWSIM_ATTR_TX_INFO, %HWSIM_ATTR_SIGNAL, %HWSIM_ATTR_COOKIE
> + * @__HWSIM_CMD_MAX: enum limit
> + */
> +enum {
> +       HWSIM_CMD_UNSPEC,
> +       HWSIM_CMD_REGISTER,
> +       HWSIM_CMD_FRAME,
> +       HWSIM_CMD_TX_INFO_FRAME,
> +       __HWSIM_CMD_MAX,
> +};
> +#define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
> +
> +/**
> + * enum hwsim_attrs - hwsim netlink attributes
> + *
> + * @HWSIM_ATTR_UNSPEC: unspecified attribute to catch errors
> + *
> + * @HWSIM_ATTR_ADDR_RECEIVER: MAC address of the radio device that
> + *     the frame is broadcasted to
> + * @HWSIM_ATTR_ADDR_TRANSMITTER: MAC address of the radio device that
> + *     the frame was broadcasted from
> + * @HWSIM_ATTR_FRAME: Data array
> + * @HWSIM_ATTR_FLAGS: mac80211 transmission flags, used to process
> +       properly the frame at user space
> + * @HWSIM_ATTR_RX_RATE: estimated rx rate index for this frame at user
> +       space
> + * @HWSIM_ATTR_SIGNAL: estimated RX signal for this frame at user
> +       space
> + * @HWSIM_ATTR_TX_INFO: ieee80211_tx_rate array
> + * @HWSIM_ATTR_COOKIE: sk_buff cookie to identify the frame
> + * @__HWSIM_ATTR_MAX: enum limit
> + */
> +
> +
> +enum {
> +       HWSIM_ATTR_UNSPEC,
> +       HWSIM_ATTR_ADDR_RECEIVER,
> +       HWSIM_ATTR_ADDR_TRANSMITTER,
> +       HWSIM_ATTR_FRAME,
> +       HWSIM_ATTR_FLAGS,
> +       HWSIM_ATTR_RX_RATE,
> +       HWSIM_ATTR_SIGNAL,
> +       HWSIM_ATTR_TX_INFO,
> +       HWSIM_ATTR_COOKIE,
> +       __HWSIM_ATTR_MAX,
> +};
> +#define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
> +
> +static struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
> +       [HWSIM_ATTR_ADDR_RECEIVER] = { .type = NLA_UNSPEC,
> +                                      .len = 6*sizeof(u8) },
> +       [HWSIM_ATTR_ADDR_TRANSMITTER] = { .type = NLA_UNSPEC,
> +                                         .len = 6*sizeof(u8) },
> +       [HWSIM_ATTR_FRAME] = { .type = NLA_BINARY,
> +                              .len = IEEE80211_MAX_DATA_LEN },
> +       [HWSIM_ATTR_FLAGS] = { .type = NLA_U32 },
> +       [HWSIM_ATTR_RX_RATE] = { .type = NLA_U32 },
> +       [HWSIM_ATTR_SIGNAL] = { .type = NLA_U32 },
> +       [HWSIM_ATTR_TX_INFO] = { .type = NLA_UNSPEC,
> +                                .len = IEEE80211_TX_MAX_RATES*sizeof(
> +                                       struct ieee80211_tx_rate)},
> +       [HWSIM_ATTR_COOKIE] = { .type = NLA_U32 },
> +};
> +
> +#define VERSION_NR 1
> +
> --
> 1.7.0.4
>
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com

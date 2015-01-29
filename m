Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:51803 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbbA2Bc1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 20:32:27 -0500
Received: by mail-oi0-f44.google.com with SMTP id a3so22057624oib.3
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2015 17:32:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1397040531-6224-3-git-send-email-michal.kazior@tieto.com>
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-3-git-send-email-michal.kazior@tieto.com>
Date: Wed, 28 Jan 2015 17:32:26 -0800
Message-ID: <CAFuUQkiVB7DVXpBCrSy_LFMCm3CX9wPi_awq3x16FHDB2OmasA@mail.gmail.com> (sfid-20150129_023233_176957_D83BD505)
Subject: Re: [RFTv2 2/5] ath10k: fix wmi-htc tx credit starvation
From: YanBo <dreamfly281@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	greearb@candelatech.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michal,

What the conclusion about this patch, it  looks like this patch not be
merged into ath10K due to introduce some unstable issue, I'v got
another issue that when move the station enter hibernate mode. the AP
will continue report message like before
[ 3958.681293] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
00:03:7f:40:04:5b
[ 3959.681449] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
00:03:7f:40:04:5b
[ 3960.681696] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
00:03:7f:40:04:5b
[ 3961.681877] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
00:03:7f:40:04:5b
[ 3962.682080] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
00:03:7f:40:04:5b
[ 3963.682361] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
00:03:7f:40:04:5b
[ 3964.682550] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
00:03:7f:40:04:5b
[ 3965.682743] ath10k_pci 0000:01:00.0: Spurious quick kickout for STA
00:03:7f:40:04:5b
and there are also error message like this be happened at early time:


[ 1316.883053] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0

[ 1316.912357] ath10k_pci 0000:01:00.0: failed to transmit management
frame via WMI: -11

[ 1316.985476] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0

I suspect it is triggered as you mentioned because the HTC Tx credits
are drained
to 0 and no other commands can be submitted,  if the answer is yes,
I'd hear your suggestion about whether this patch still  worth to be
continue improve to solve such kinds of issue.

Thanks
BR /Yanbo

On Wed, Apr 9, 2014 at 3:48 AM, Michal Kazior <michal.kazior@tieto.com> wrote:
> Each WMI management Tx consumes 1 HTC Tx credit
> and doesn't replenish it until the frame is
> actually transmitted out of firmware's Tx queues.
>
> If associated client was asleep and has gone out
> of range then unicast frames won't be released for
> FW/HW queues for a while (10 seconds per
> observation). This means that if more management
> frames are queued then HTC Tx credits are drained
> to 0 and no other commands can be submitted
> including beacons and peer removal.
>
> This could in turn result in clients disconnecting
> due to their beacon loss and may trigger spurious
> sta kickouts because wmi peer removal command may
> never reach firmware during disassociation.
>
> This could happen, e.g. when disconnecting
> client (hostapd inactivity) that has gone away
> while asleep when acting as AP.
>
> As a workaround flush frames that can potentialy
> get stuck in FW Tx queues.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 96 +++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/wmi.c |  5 --
>  drivers/net/wireless/ath/ath10k/wmi.h |  3 ++
>  3 files changed, 99 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 58ec5a7..5cfbf88 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -2076,9 +2076,67 @@ void ath10k_mgmt_over_wmi_tx_purge(struct ath10k *ar)
>         }
>  }
>
> +static void ath10k_mgmt_tx_flush(struct ath10k *ar, struct sk_buff *skb)
> +{
> +       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> +       struct ieee80211_sta *sta;
> +       struct ath10k_vif *arvif;
> +       u8 *da = ieee80211_get_DA(hdr);
> +       u8 vdev_id = ATH10K_SKB_CB(skb)->vdev_id;
> +       u32 bcn_intval = 0;
> +       unsigned int msecs;
> +       int ret;
> +
> +       lockdep_assert_held(&ar->conf_mutex);
> +
> +       if (!is_unicast_ether_addr(da))
> +               return;
> +
> +       rcu_read_lock();
> +       sta = ieee80211_find_sta_by_ifaddr(ar->hw, da, NULL);
> +       rcu_read_unlock();
> +
> +       /*
> +        * FW Tx queues can be paused only for associated peers. Since this is
> +        * a workaround just assume worst case if station simply entry exists.
> +        */
> +       if (!sta)
> +               return;
> +
> +       list_for_each_entry(arvif, &ar->arvifs, list) {
> +               if (arvif->vdev_id == vdev_id) {
> +                       bcn_intval = arvif->beacon_interval;
> +                       break;
> +               }
> +       }
> +
> +       if (!bcn_intval)
> +               return;
> +
> +       /*
> +        * Wait 2 beacon intervals before flushing so stations that are
> +        * asleep but are actually still in range have a chance to see
> +        * updated PVB, wake up and fetch the frame. There's no other way of
> +        * synchronizing other than sleeping because there's no tx completion
> +        * indication event for WMI management tx.
> +        */
> +       msecs = 2 * arvif->beacon_interval * 1024 / 1000;
> +       ath10k_dbg(ATH10K_DBG_MAC,
> +                  "mac flushing peer %pM on vdev %i mgmt tid for unicast mgmt (%d msecs)\n",
> +                  da, vdev_id, msecs);
> +       msleep(msecs);
> +
> +       ret = ath10k_wmi_peer_flush(ar, vdev_id, da,
> +                                   WMI_PEER_TID_MGMT_MASK);
> +       if (ret)
> +               ath10k_warn("failed to flush peer %pM mgmt tid: %d\n",
> +                           da, ret);
> +}
> +
>  void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
>  {
>         struct ath10k *ar = container_of(work, struct ath10k, wmi_mgmt_tx_work);
> +       struct ieee80211_tx_info *info;
>         struct sk_buff *skb;
>         int ret;
>
> @@ -2087,12 +2145,50 @@ void ath10k_mgmt_over_wmi_tx_work(struct work_struct *work)
>                 if (!skb)
>                         break;
>
> +               mutex_lock(&ar->conf_mutex);
> +
>                 ret = ath10k_wmi_mgmt_tx(ar, skb);
>                 if (ret) {
>                         ath10k_warn("failed to transmit management frame via WMI: %d\n",
>                                     ret);
> +                       mutex_unlock(&ar->conf_mutex);
>                         ieee80211_free_txskb(ar->hw, skb);
> +                       continue;
>                 }
> +
> +               /*
> +                * Each WMI management Tx consumes 1 HTC Tx credit and doesn't
> +                * replenish it until the frame is actually transmitted out of
> +                * firmware's Tx queues.
> +                *
> +                * If associated client was asleep and has gone out of range
> +                * then unicast frames won't be released for FW/HW queues for a
> +                * while (10 seconds per observation). This means that if more
> +                * management frames are queued then HTC Tx credits are drained
> +                * to 0 and no other commands can be submitted including
> +                * beacons and peer removal.
> +                *
> +                * This could in turn result in clients disconnecting due to
> +                * their beacon loss and may trigger spurious sta kickouts
> +                * because wmi peer removal command may never reach firmware
> +                * during disassociation.
> +                *
> +                * This could happen, e.g. when disconnecting client that has
> +                * gone away while asleep.
> +                *
> +                * As a workaround flush unicast management frames that can
> +                * possibly be buffered.
> +                *
> +                * Note: This is a deficiency in design of WMI_MGMT_TX command.
> +                */
> +               ath10k_mgmt_tx_flush(ar, skb);
> +
> +               mutex_unlock(&ar->conf_mutex);
> +
> +               /* there's no way to get ACK so just assume it's acked */
> +               info = IEEE80211_SKB_CB(skb);
> +               info->flags |= IEEE80211_TX_STAT_ACK;
> +               ieee80211_tx_status(ar->hw, skb);
>         }
>  }
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index d4b48ef..3b270a4 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -637,7 +637,6 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
>         struct wmi_mgmt_tx_cmd *cmd;
>         struct ieee80211_hdr *hdr;
>         struct sk_buff *wmi_skb;
> -       struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>         int len;
>         u16 fc;
>
> @@ -673,10 +672,6 @@ int ath10k_wmi_mgmt_tx(struct ath10k *ar, struct sk_buff *skb)
>         if (ret)
>                 return ret;
>
> -       /* TODO: report tx status to mac80211 - temporary just ACK */
> -       info->flags |= IEEE80211_TX_STAT_ACK;
> -       ieee80211_tx_status_irqsafe(ar->hw, skb);
> -
>         return ret;
>  }
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
> index ae83822..90fe2e9 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.h
> +++ b/drivers/net/wireless/ath/ath10k/wmi.h
> @@ -3844,6 +3844,9 @@ struct wmi_peer_delete_cmd {
>         struct wmi_mac_addr peer_macaddr;
>  } __packed;
>
> +#define WMI_PEER_TID_MGMT 17
> +#define WMI_PEER_TID_MGMT_MASK BIT(WMI_PEER_TID_MGMT)
> +
>  struct wmi_peer_flush_tids_cmd {
>         __le32 vdev_id;
>         struct wmi_mac_addr peer_macaddr;
> --
> 1.8.5.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

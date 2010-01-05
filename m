Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:59515 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab0AERBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 12:01:44 -0500
Received: by iwn32 with SMTP id 32so931312iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2010 09:01:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100105083803.GP1735@mail.wantstofly.org>
References: <20100105083803.GP1735@mail.wantstofly.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 5 Jan 2010 09:01:23 -0800
Message-ID: <43e72e891001050901v2d07ddd9m16789b200f096ef8@mail.gmail.com>
Subject: Re: infinite transmit buffering issue in 2.6.32 mac80211
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Sasidhar Subramaniam <Sasidhar.Subramaniam@atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 5, 2010 at 12:38 AM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> Hi!
>
> Since "mac80211: remove master netdev", mac80211 no longer propagates
> TX queue full status (ieee80211_stop_queue et al) up.  While the
> underlying hardware's TX queue is stopped, mac80211 buffers frames
> internally (in ieee80211_tx), but there's no upper limit on the number
> of frames it will buffer, leading to badness when there is heavy TX
> traffic on the wireless interface:
>
> * It breaks TCP's packet drop-induced rate control.  Instead, you'll
>  end up with much of the same effects as tunneling TCP in TCP like
>  some VPN apps do, where individual packets will see wildly varying
>  RTTs and you'll end up adding retransmits to the TX queue while
>  the original packet didn't even go out yet.
>
> * If there is bulk data transfer going on, you end up with unbounded
>  and highly variable RTTs for concurrent traffic (say, pings).
>
> * On the kind of machines I typically work on (embedded access point
>  type devices), more so than on big x86_64 machines, unbounded
>  packet buffering will typically lead to OOM very quickly. :-)

Felix, curious have you seen OOMs quickly in your setups with embedded
devices and current mac80211 drivers?

> Routing from a wired interface to wireless, and flooding the wired
> interface with traffic to be routed, say with a traffic generator (for
> performance testing) can trigger OOM and cripple the box in seconds,
> but I think (but haven't verified) that even just simple non-forwarded
> bulk TCP upload should be able to trigger OOM as well on sufficiently
> constrained machines.

Don't traffic generators typically cripple boxes though? How about
with plain iperf pusing 1gbit/s over the ethernet and routing out via
the wireless interface?

> Something like this makes the OOM and jitter issues go away:
>
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index eaa4118..f7d9033 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1294,6 +1298,8 @@ static void ieee80211_tx(struct ieee80211_sub_if_data *sda
>                        goto drop;
>                /* fall through */
>        case IEEE80211_TX_PENDING:
> +               goto drop;
> +
>                skb = tx.skb;
>
>                spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
>
>
> However, TX queue status feedback is still broken with this, which is
> problematic as per:
>
>        http://marc.info/?l=linux-netdev&m=121994203129939&w=2
>        http://marc.info/?l=linux-netdev&m=122004613003333&w=2
>
>
> Propagating the queue stop to the higher-level interface (as per the
> somewhat broken patch below) is closer into the right direction, but
> Johannes voiced concerns that this is inefficient (which is demonstrated
> e.g. by the first email referenced above), but also, it creates a new
> problem, which is that of head-of-line blocking -- a low-priority flow
> can now cause the wlanX interface's main queue to be stopped, leading
> to queueing of high-priority traffic in the stack while the hardware's
> high-priority traffic queue sits empty.
>
>
> The only way I see to solve all of these issues cleanly is to convert
> the AP/STA/etc subinterfaces to be multiqueue interfaces, with the same
> number of transmit queues as the hardware has, so that there are
> independently stoppable/resumable virtual output queues all the way
> from userland to the actual hardware, and then to stop/resume those
> queues in response to the hardware DMA queues filling up and draining.

How does this resolve the main OOM issues you are seeing though? I
don't see the link yet.

> Before I go ahead and do this -- thoughts?

So the way we had multiqueue support implemented in mac80211 did not
exactly reflect the actual hardware queues as implemented on ethernet
drivers. Each driver would still need to queue buffers themselves then
and we only used mac80211 to propagate frames to our driver's queue.
Adding multiqueue support back seems fine if it indeed resolves an
issue we cannot deal with right now but if we do, it'd be good to
allow for us to reconsider the way we implement it hopefully to ensure
we don't re do queuing on drivers and so that each netdev queue will
directly move buffers to hardware.

One downside worth mentioning to re-adding MQ support is doing so
would mean losing kernel compatibility back again for kernels <
2.6.27. In way should kernel compatility concerns hold back
development but if I'd before we go and re-add MQ support I'd like to
ensure it will really cure an issue we cannot resolve through other
means.

  Luis

>
> thanks,
> Lennert
>
>
>
>
>
> (broken -- doesn't deal properly with stops/wakes on multiple queues)
>
>
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index dc76267..5ac558f 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -296,8 +296,33 @@ void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
>
>  void ieee80211_wake_queue(struct ieee80211_hw *hw, int queue)
>  {
> +       struct ieee80211_local *local = hw_to_local(hw);
> +       struct ieee80211_sub_if_data *sdata;
> +
>        ieee80211_wake_queue_by_reason(hw, queue,
>                                       IEEE80211_QUEUE_STOP_REASON_DRIVER);
> +
> +       rcu_read_lock();
> +
> +       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +               switch (sdata->vif.type) {
> +               case __NL80211_IFTYPE_AFTER_LAST:
> +               case NL80211_IFTYPE_UNSPECIFIED:
> +               case NL80211_IFTYPE_MONITOR:
> +               case NL80211_IFTYPE_AP_VLAN:
> +                       continue;
> +               case NL80211_IFTYPE_AP:
> +               case NL80211_IFTYPE_STATION:
> +               case NL80211_IFTYPE_ADHOC:
> +               case NL80211_IFTYPE_WDS:
> +               case NL80211_IFTYPE_MESH_POINT:
> +                       if (netif_running(sdata->dev))
> +                               netif_wake_queue(sdata->dev);
> +                       break;
> +               }
> +        }
> +
> +       rcu_read_unlock();
>  }
>  EXPORT_SYMBOL(ieee80211_wake_queue);
>
> @@ -325,8 +350,33 @@ void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
>
>  void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue)
>  {
> +       struct ieee80211_local *local = hw_to_local(hw);
> +       struct ieee80211_sub_if_data *sdata;
> +
>        ieee80211_stop_queue_by_reason(hw, queue,
>                                       IEEE80211_QUEUE_STOP_REASON_DRIVER);
> +
> +       rcu_read_lock();
> +
> +       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +               switch (sdata->vif.type) {
> +               case __NL80211_IFTYPE_AFTER_LAST:
> +               case NL80211_IFTYPE_UNSPECIFIED:
> +               case NL80211_IFTYPE_MONITOR:
> +               case NL80211_IFTYPE_AP_VLAN:
> +                       continue;
> +               case NL80211_IFTYPE_AP:
> +               case NL80211_IFTYPE_STATION:
> +               case NL80211_IFTYPE_ADHOC:
> +               case NL80211_IFTYPE_WDS:
> +               case NL80211_IFTYPE_MESH_POINT:
> +                       if (netif_running(sdata->dev))
> +                               netif_stop_queue(sdata->dev);
> +                       break;
> +               }
> +        }
> +
> +       rcu_read_unlock();
>  }
>  EXPORT_SYMBOL(ieee80211_stop_queue);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

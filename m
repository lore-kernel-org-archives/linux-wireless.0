Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:35761 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757731Ab2CFHpW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 02:45:22 -0500
Received: by dadp12 with SMTP id p12so6310923dad.11
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2012 23:45:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120305164813.GB2979@redhat.com>
References: <20120305164813.GB2979@redhat.com>
Date: Tue, 6 Mar 2012 08:45:21 +0100
Message-ID: <CAGXE3d9==tT-ukfn5RO9xTEfw=YXO=FAVJob2WMFJS-FS8j9GQ@mail.gmail.com> (sfid-20120306_084525_634192_78332121)
Subject: Re: [PATCH 3.3] rt2x00: fix random stalls
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Mar 5, 2012 at 5:48 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Is possible that we stop queue and then do not wake up it again,
> especially when packets are transmitted fast. That can be easily
> reproduced with modified tx queue entry_num to some small value e.g. 16.
>
> If mac80211 already hold local->queue_stop_reason_lock, then we can wait
> on that lock in both rt2x00queue_pause_queue() and
> rt2x00queue_unpause_queue(). After drooping ->queue_stop_reason_lock
> is possible that __ieee80211_wake_queue() will be performed before
> __ieee80211_stop_queue(), hence we stop queue and newer wake up it
> again.
>
> To prevent stalls serialize pause/unpause by queue->tx_lock.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/rt2x00/rt2x00dev.c |   10 ++++++++--
>  drivers/net/wireless/rt2x00/rt2x00mac.c |   10 +++++++++-
>  2 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 49a51b4..6c64658 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -430,10 +430,16 @@ void rt2x00lib_txdone(struct queue_entry *entry,
>        /*
>         * If the data queue was below the threshold before the txdone
>         * handler we must make sure the packet queue in the mac80211 stack
> -        * is reenabled when the txdone handler has finished.
> +        * is reenabled when the txdone handler has finished. This has to be
> +        * serialized with rt2x00mac_tx, otherwise we can wake up mac80211
> +        * queue before it was stopped if someone else hold mac80211 internal
> +        * local->queue_stop_reason_lock .
>         */
> -       if (!rt2x00queue_threshold(entry->queue))
> +       if (!rt2x00queue_threshold(entry->queue)) {
> +               spin_lock_irq(&entry->queue->tx_lock);
>                rt2x00queue_unpause_queue(entry->queue);
> +               spin_unlock_irq(&entry->queue->tx_lock);

Why do we need to disable interrupts here? spin_lock_bh should
be sufficient.

> +       }
>  }
>  EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> index ede3c58..2880512 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -152,13 +152,21 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>        if (unlikely(rt2x00queue_write_tx_frame(queue, skb, false)))
>                goto exit_fail;
>
> -       if (rt2x00queue_threshold(queue))
> +       /*
> +        * Pausing queue has to be serialized with rt2x00lib_txdone .
> +        */
> +       if (rt2x00queue_threshold(queue)) {
> +               spin_lock(&queue->tx_lock);
>                rt2x00queue_pause_queue(queue);
> +               spin_unlock(&queue->tx_lock);
> +       }
>
>        return;
>
>  exit_fail:
> +       spin_lock(&queue->tx_lock);
>        rt2x00queue_pause_queue(queue);
> +       spin_unlock(&queue->tx_lock);
>  exit_free_skb:
>        ieee80211_free_txskb(hw, skb);
>  }
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

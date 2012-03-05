Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46782 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab2CET1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 14:27:48 -0500
Received: by vbbff1 with SMTP id ff1so3744752vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2012 11:27:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120305164813.GB2979@redhat.com>
References: <20120305164813.GB2979@redhat.com>
Date: Mon, 5 Mar 2012 20:27:47 +0100
Message-ID: <CAOZOX0VX4=4=M0z2wDwh_vjNqGfjoEwz+CdVvgZA5TK6JKerHQ@mail.gmail.com> (sfid-20120305_202751_944052_26ADC2B7)
Subject: Re: [rt2x00-users] [PATCH 3.3] rt2x00: fix random stalls
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

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
>
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com

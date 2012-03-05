Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53677 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756488Ab2CETyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 14:54:33 -0500
Received: by wgbdr13 with SMTP id dr13so3833009wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2012 11:54:32 -0800 (PST)
References: <20120305164813.GB2979@redhat.com>
In-Reply-To: <20120305164813.GB2979@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <8287E603-C5DE-4CF9-8647-DE63B9D3E93E@gmail.com> (sfid-20120305_205437_371038_0CF8257B)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [rt2x00-users] [PATCH 3.3] rt2x00: fix random stalls
Date: Mon, 5 Mar 2012 20:54:37 +0100
To: Stanislaw Gruszka <sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On 5 mrt. 2012, at 17:48, Stanislaw Gruszka <sgruszka@redhat.com> wrote:

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
> drivers/net/wireless/rt2x00/rt2x00dev.c |   10 ++++++++--
> drivers/net/wireless/rt2x00/rt2x00mac.c |   10 +++++++++-
> 2 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index 49a51b4..6c64658 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -430,10 +430,16 @@ void rt2x00lib_txdone(struct queue_entry *entry,
>    /*
>     * If the data queue was below the threshold before the txdone
>     * handler we must make sure the packet queue in the mac80211 stack
> -     * is reenabled when the txdone handler has finished.
> +     * is reenabled when the txdone handler has finished. This has to be
> +     * serialized with rt2x00mac_tx, otherwise we can wake up mac80211
> +     * queue before it was stopped if someone else hold mac80211 internal
> +     * local->queue_stop_reason_lock .
>     */
> -    if (!rt2x00queue_threshold(entry->queue))
> +    if (!rt2x00queue_threshold(entry->queue)) {
> +        spin_lock_irq(&entry->queue->tx_lock);
>        rt2x00queue_unpause_queue(entry->queue);
> +        spin_unlock_irq(&entry->queue->tx_lock);
> +    }
> }
> EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
> index ede3c58..2880512 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00mac.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
> @@ -152,13 +152,21 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>    if (unlikely(rt2x00queue_write_tx_frame(queue, skb, false)))
>        goto exit_fail;
> 
> -    if (rt2x00queue_threshold(queue))
> +    /*
> +     * Pausing queue has to be serialized with rt2x00lib_txdone .
> +     */
> +    if (rt2x00queue_threshold(queue)) {
> +        spin_lock(&queue->tx_lock);
>        rt2x00queue_pause_queue(queue);
> +        spin_unlock(&queue->tx_lock);
> +    }
> 
>    return;
> 
>  exit_fail:
> +    spin_lock(&queue->tx_lock);
>    rt2x00queue_pause_queue(queue);
> +    spin_unlock(&queue->tx_lock);
>  exit_free_skb:
>    ieee80211_free_txskb(hw, skb);
> }

There are more places in the rt2x00 code that call upon rt2x00queue_pause_queue and rt2x00queue_unpause_queue. Shouldn't these places be protected with tx_lock as well?
Or better, shouldn't the locking be moved inside the pause / unpause functions?

---
Gertjan
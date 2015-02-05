Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45357 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbbBEGqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2015 01:46:30 -0500
Received: by mail-wg0-f44.google.com with SMTP id z12so5794715wgg.3
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2015 22:46:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1423084303.31870.15.camel@edumazet-glaptop2.roam.corp.google.com>
References: <CA+BoTQkVu23P3EOmY_Q3E1GJnWsyF==Pawz4iPOS_Bq5dvfO5Q@mail.gmail.com>
	<1422537297.21689.15.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQk2xT-8DqPuiiKG+kHAjLPrj8F9dLTb-rcGhvMq0u_2Qw@mail.gmail.com>
	<1422628835.21689.95.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQkV+mOZfe_Niz5101sMQeaV6muKCsShptjGQ1AgOHqqoQ@mail.gmail.com>
	<1422903136.21689.114.camel@edumazet-glaptop2.roam.corp.google.com>
	<1422926330.21689.138.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQkMikA8wxm1ce2DkKhPB0HiKeAqT7f+sQ=91W40z=X0Rg@mail.gmail.com>
	<1422973660.907.10.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQmvUuFdfYF=wVMYxrf_nQZB5GCV=LvDZVvfs-3hAE4WKw@mail.gmail.com>
	<1423051045.907.108.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQ=BDcQ779uKCuX+f40=4npXVF4MTQnpjKimNYAxPsxBoQ@mail.gmail.com>
	<1423053531.907.115.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQ=qmCZz4CmSOvCOzMLowrDEG12XBffkTcYxjGqVD9604g@mail.gmail.com>
	<1423055810.907.125.camel@edumazet-glaptop2.roam.corp.google.com>
	<1423056591.907.130.camel@edumazet-glaptop2.roam.corp.google.com>
	<1423084303.31870.15.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Thu, 5 Feb 2015 07:46:29 +0100
Message-ID: <CA+BoTQnwcmu=YbKB17JQb7ZPwGZoQS7zQ6nT-WEJHjnBX34QKA@mail.gmail.com> (sfid-20150205_074640_453337_54562BBE)
Subject: Re: Throughput regression with `tcp: refine TSO autosizing`
From: Michal Kazior <michal.kazior@tieto.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Neal Cardwell <ncardwell@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	eyalpe@dev.mellanox.co.il
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 February 2015 at 22:11, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> I do not see how a TSO patch could hurt a flow not using TSO/GSO.
>
> This makes no sense.
>
> ath10k tx completions being batched/deferred to a tasklet might increase
> probability to hit this condition in tcp_wfree() :
>
>         /* If this softirq is serviced by ksoftirqd, we are likely under stress.
>          * Wait until our queues (qdisc + devices) are drained.
>          * This gives :
>          * - less callbacks to tcp_write_xmit(), reducing stress (batches)
>          * - chance for incoming ACK (processed by another cpu maybe)
>          *   to migrate this flow (skb->ooo_okay will be eventually set)
>          */
>         if (wmem >= SKB_TRUESIZE(1) && this_cpu_ksoftirqd() == current)
>                 goto out;
>
> Meaning tcp stack waits all skbs left qdisc/NIC queues before queuing
> additional packets.
>
> I would try to call skb_orphan() in ath10k if you really want to keep
> these batches.
>
> I have hard time to understand why tx completed packets go through
> ath10k_htc_rx_completion_handler().. anyway...

There's a couple of layers for host-firmware communication. The
transport layer (e.g. PCI) delivers HTC packets. These contain WMI
(configuration stuff) or HTT (traffic stuff). HTT can contain
different events (tx complete, rx complete, etc). HTT Tx completion
contains a list of ids which refer to frames that have been completed
(either sent or dropped).

I've tried reverting tx/rx tasklet batching. No change in throughput.
I can get tcpdump if you're interested.


> Most conservative patch would be :
>
> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
> index 9c782a42665e1aaf43bfbca441631ee58da50c09..6a36317d6bb0447202dee15528130bd5e21248c4 100644
> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
> @@ -1642,6 +1642,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
>                 break;
>         }
>         case HTT_T2H_MSG_TYPE_TX_COMPL_IND:
> +               skb_orphan(skb);
>                 spin_lock_bh(&htt->tx_lock);
>                 __skb_queue_tail(&htt->tx_compl_q, skb);
>                 spin_unlock_bh(&htt->tx_lock);

I suppose you want to call skb_orphan() on actual data packets, right?
This skb is just a host-firmware communication buffer.


Michał

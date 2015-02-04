Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:38202 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbbBDVLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 16:11:45 -0500
Message-ID: <1423084303.31870.15.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20150204_221152_938302_BBAECAD7)
Subject: Re: Throughput regression with `tcp: refine TSO autosizing`
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Neal Cardwell <ncardwell@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	eyalpe@dev.mellanox.co.il
Date: Wed, 04 Feb 2015 13:11:43 -0800
In-Reply-To: <1423056591.907.130.camel@edumazet-glaptop2.roam.corp.google.com>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I do not see how a TSO patch could hurt a flow not using TSO/GSO.

This makes no sense.

ath10k tx completions being batched/deferred to a tasklet might increase
probability to hit this condition in tcp_wfree() :

        /* If this softirq is serviced by ksoftirqd, we are likely under stress.
         * Wait until our queues (qdisc + devices) are drained.
         * This gives :
         * - less callbacks to tcp_write_xmit(), reducing stress (batches)
         * - chance for incoming ACK (processed by another cpu maybe)
         *   to migrate this flow (skb->ooo_okay will be eventually set)
         */
        if (wmem >= SKB_TRUESIZE(1) && this_cpu_ksoftirqd() == current)
                goto out;

Meaning tcp stack waits all skbs left qdisc/NIC queues before queuing
additional packets.

I would try to call skb_orphan() in ath10k if you really want to keep
these batches.

I have hard time to understand why tx completed packets go through
ath10k_htc_rx_completion_handler().. anyway...

Most conservative patch would be :

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 9c782a42665e1aaf43bfbca441631ee58da50c09..6a36317d6bb0447202dee15528130bd5e21248c4 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1642,6 +1642,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_TX_COMPL_IND:
+		skb_orphan(skb);
 		spin_lock_bh(&htt->tx_lock);
 		__skb_queue_tail(&htt->tx_compl_q, skb);
 		spin_unlock_bh(&htt->tx_lock);



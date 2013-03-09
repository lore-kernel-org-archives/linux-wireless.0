Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:45307 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3CIJ15 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 04:27:57 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>,
	<ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Add rx workqueue for SDIO
References: <1362732148-26384-1-git-send-email-rmani@qca.qualcomm.com>
Date: Sat, 9 Mar 2013 11:27:51 +0200
In-Reply-To: <1362732148-26384-1-git-send-email-rmani@qca.qualcomm.com> (Raja
	Mani's message of "Fri, 8 Mar 2013 14:12:28 +0530")
Message-ID: <87obesly7c.fsf@kamboji.qca.qualcomm.com> (sfid-20130309_102813_762059_C7908E69)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qca.qualcomm.com> writes:

> In the current implementation, all RX packets (data and control)
> are fetched from the chip and processed in ISR handler context.
> ISR handler has to process fetched packets first before it goes
> ahead and fetch further packets from the chip. In high throughput
> scenario, doing everything (read and process) in one context is
> time consuming and it's not quicker way of reading RX packets from
> the chip.
>
> This patch lets ISR to read packets (data and control) from the chip
> and process control packets alone (EP0 pkts). All data packets are
> moved to another queue which is separately processed by another worker
> thread. So that, ISR doesn't have to wait to read further packets until
> fetched data packets are processed. With this change, significant
> improvement is seen both in TCP (around 10 Mpbs) and UDP (around 5 Mpbs)
> down-link case.
>
> Signed-off-by: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Sorry, I think I missed this in our internal review:

> +static void ath6kl_htc_rx_work(struct work_struct *work)
> +{
> +	struct htc_target *target;
> +	struct htc_packet *packet, *tmp_pkt;
> +	struct htc_endpoint *endpoint;
> +
> +	target = container_of(work, struct htc_target, rx_work);
> +
> +	spin_lock_bh(&target->rx_comp_lock);
> +	list_for_each_entry_safe(packet, tmp_pkt, &target->rx_bufq, list) {
> +		list_del(&packet->list);
> +
> +		spin_unlock_bh(&target->rx_comp_lock);
> +		endpoint = &target->endpoint[packet->endpoint];
> +
> +		ath6kl_dbg(ATH6KL_DBG_HTC,
> +			   "htc rx complete ep %d packet 0x%p\n",
> +			   endpoint->eid, packet);
> +
> +		endpoint->ep_cb.rx(endpoint->target, packet);
> +		spin_lock_bh(&target->rx_comp_lock);
> +	}
> +	spin_unlock_bh(&target->rx_comp_lock);

I think there's a (theoretical?) race here. You cannot consume rx_bufq
with a for loop and then release rx_comp_lock inside the loop. Nothing
prevents that rx_bufq is not modified while the lock is released. Ok, in
practise it won't be a problem as ISR is adding them to the end of list.

I think to fix the race the queue should be consumed something like
this (pseudo code):

lock()
while (!list_empty()) {
      entry = list_first_entry()
      unlock()

      do_stuff()

      lock()
}

Can someone else comment? Am I on right track?

I so wish sdio.c and htc would use struct sk_buff. It would have all the
infrastructure for this :/

BTW, for consistency please also rename rx_comp_lock to rx_bufq_lock.


-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:51097 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaKVOlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2014 09:41:14 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: nick <xerofoify@gmail.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: FIX ME locking is implemented?
References: <54709610.6020502@gmail.com>
Date: Sat, 22 Nov 2014 16:41:07 +0200
In-Reply-To: <54709610.6020502@gmail.com> (nick's message of "Sat, 22 Nov 2014
	08:56:32 -0500")
Message-ID: <87lhn38fi4.fsf@kamboji.qca.qualcomm.com> (sfid-20141122_154135_592436_A70BB795)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nick <xerofoify@gmail.com> writes:

> I am wondering why the fix me in the code below still exists as this
> code is clearly being locked properly with a spin lock on the lock
> related to the created linked list in this code.

It would be nice to mention what driver and file you are referring to.
So this is from ath6kl_tx_queue_full() in
drivers/net/wireless/ath/ath6kl/txrx.c.

> /* FIXME: Locking */
> spin_lock_bh(&ar->list_lock);
> list_for_each_entry(vif, &ar->vif_list, list) {
> 	if (vif->nw_type == ADHOC_NETWORK ||
>  			action != HTC_SEND_FULL_DROP) {
>                         spin_unlock_bh(&ar->list_lock);
>
>                          set_bit(NETQ_STOPPED, &vif->flags);
>                          netif_stop_queue(vif->ndev);
>
>                          return action;
>               }
>         }
>         spin_unlock_bh(&ar->list_lock);

Most probably someone just forgot to update the comment, patches welcome :)

-- 
Kalle Valo

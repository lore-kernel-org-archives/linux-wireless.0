Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4183 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104AbcCDJR6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 04:17:58 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 10/13] ath10k: implement flushing of pending frames in
 txqs
Date: Fri, 4 Mar 2016 09:17:52 +0000
Message-ID: <87h9gmy538.fsf@kamboji.qca.qualcomm.com> (sfid-20160304_101821_913289_5F4C711D)
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
	<1453384006-31907-11-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1453384006-31907-11-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 21 Jan 2016 14:46:43 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Firmware supporting pull-push tx model may request
> a switch between modes. When switching from
> pull-push to push-only it will be necessary to
> flush all pending frames. The code will do that
> once other bits that actually trigger it are added.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

This fails to apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/htt_rx.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0010 ath10k: implement flushing of pending frames in txqs

> @@ -2370,6 +2371,8 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
>  		dev_kfree_skb_any(skb);
>  	}
>  
> +	ath10k_mac_tx_push_pending(ar);
> +
>  	spin_lock_bh(&htt->rx_ring.lock);
>  	while ((skb = __skb_dequeue(&htt->rx_compl_q))) {
>  		resp = (struct htt_resp *)skb->data;

This hunk seems to be the problem. I could try to fix it myself but the
function has changed so I would prefer that you respin.

-- 
Kalle Valo
Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8145 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbaBSMsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 07:48:53 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT 3/7] ath10k: replace send_head() with tx_sg()
References: <1392629563-31046-1-git-send-email-michal.kazior@tieto.com>
	<1392629563-31046-4-git-send-email-michal.kazior@tieto.com>
Date: Wed, 19 Feb 2014 14:48:48 +0200
In-Reply-To: <1392629563-31046-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 17 Feb 2014 10:32:39 +0100")
Message-ID: <87y517xo7j.fsf@kamboji.qca.qualcomm.com> (sfid-20140219_134856_618541_175AFFEB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> PCI is capable of handling scatter-gather lists.
> This can be used to avoid copying memory.
>
> Change the name of the callback while at to
> reflect its purpose.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> +struct ath10k_hif_sg_item {
> +	u16 transfer_id;
> +	void *transfer_context;
> +	void *vaddr; /* for debugging mostly */
> +	u32 paddr;
> +	u16 len;
> +};

This is the part I don't like. Instead of adding our own structs we
instead should have everything in skb->cb and pass the skbs around. The
sad part was that last fall I was working on cleaning up that but never
found the time to finish it :(

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44412 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbeBAHIF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 02:08:05 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: Re: [v5 4/8] rsi: add coex support
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
        <1513168977-2121-5-git-send-email-amitkarwar@gmail.com>
Date: Thu, 01 Feb 2018 09:08:00 +0200
In-Reply-To: <1513168977-2121-5-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Wed, 13 Dec 2017 18:12:53 +0530")
Message-ID: <87inbhmblb.fsf@purkki.adurom.net> (sfid-20180201_080810_146434_D937FD88)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> With BT support, driver has to handle two streams of data
> (i.e. wlan and BT). Actual coex implementation is in firmware.
> Coex module just schedule the packets to firmware by taking them
> from the corresponding paths.
>
> Structures for module and protocol operations are introduced for
> this purpose. Protocol operations structure is global structure
> which can be shared among different modules. Initialization of
> coex and operating mode values is moved to rsi_91x_init().
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

[...]

> +static void rsi_coex_sched_tx_pkts(struct rsi_coex_ctrl_block *coex_cb)
> +{
> +	enum rsi_coex_queues coex_q;
> +	struct sk_buff *skb;
> +
> +	while (1) {
> +		coex_q = rsi_coex_determine_coex_q(coex_cb);
> +		rsi_dbg(INFO_ZONE, "queue = %d\n", coex_q);
> +
> +		if (coex_q == RSI_COEX_Q_INVALID) {
> +			rsi_dbg(DATA_TX_ZONE, "No more pkt\n");
> +			break;
> +		}
> +
> +		if (coex_q == RSI_COEX_Q_BT)
> +			skb = skb_dequeue(&coex_cb->coex_tx_qs[RSI_COEX_Q_BT]);
> +	}
> +}

Neverending loops are dangerous in kernel. Can you put a limit so that
if there's a bug the loop will not run forever?

-- 
Kalle Valo

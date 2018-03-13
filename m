Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47654 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751217AbeCMPBi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 11:01:38 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: Re: [PATCH 1/3] rsi: improve RX handling in SDIO interface
References: <1519803508-27737-1-git-send-email-amitkarwar@gmail.com>
        <1519803508-27737-2-git-send-email-amitkarwar@gmail.com>
Date: Tue, 13 Mar 2018 17:01:33 +0200
In-Reply-To: <1519803508-27737-2-git-send-email-amitkarwar@gmail.com>
        (Amitkumar Karwar's message of "Wed, 28 Feb 2018 13:08:26 +0530")
Message-ID: <87muzc10ky.fsf@purkki.adurom.net> (sfid-20180313_160141_857920_78F38CD2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> Currently, RX packets are handled in interrupt context in SDIO
> interface. To improve the efficiency of processing RX packets,
> RX thread and RX skb queues are introduced.
> When the packet is read from device, driver prepares skb, add to
> RX queue and trigger RX thread event. RX thread processes the
> packets from RX queue.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

[...]

> +void rsi_sdio_rx_thread(struct rsi_common *common)
> +{
> +	struct rsi_hw *adapter = common->priv;
> +	struct rsi_91x_sdiodev *sdev = adapter->rsi_dev;
> +	struct sk_buff *skb;
> +	int status;
> +
> +	do {
> +		rsi_wait_event(&sdev->rx_thread.event, EVENT_WAIT_FOREVER);
> +		rsi_reset_event(&sdev->rx_thread.event);

I started to wonder what these rsi_wait_event() and rsi_reset_event()
are and indeed, at least to me, they look suspicious (creating own
kthread and use of atomics etc). Why reinvent the wheel and not use
standard kernel frameworks, like workqueue? Most of the time trying to
be too clever ends up just being buggy.

No need for any immeadiate action but something to keep in mind and
hopefully clean up later.

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54380 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752898AbdEROdc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 10:33:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: [PATCH v2 5/6] mwifiex: do not aggregate tcp ack in usb tx aggregation queue
References: <1493986100-24509-1-git-send-email-huxinming820@gmail.com>
        <1493986100-24509-5-git-send-email-huxinming820@gmail.com>
Date: Thu, 18 May 2017 17:33:26 +0300
In-Reply-To: <1493986100-24509-5-git-send-email-huxinming820@gmail.com>
        (Xinming Hu's message of "Fri, 5 May 2017 12:08:19 +0000")
Message-ID: <87lgpu5j61.fsf@purkki.adurom.net> (sfid-20170518_163335_787205_FAE9615E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxinming820@gmail.com> writes:

> From: Xinming Hu <huxm@marvell.com>
>
> Tcp ack should be send as soon to avoid throuput drop during receive tcp
> traffic.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>

[...]

> +static bool is_piggyback_tcp_ack(struct sk_buff *skb)
> +{
> +	struct ethhdr *ethh = NULL;
> +	struct iphdr  *iph = NULL;
> +	struct tcphdr *tcph = NULL;
> +
> +	ethh = (struct ethhdr *)skb->data;
> +	if (ntohs(ethh->h_proto) != ETH_P_IP)
> +		return false;
> +
> +	iph = (struct iphdr *)((u8 *)ethh + sizeof(struct ethhdr));
> +	if (iph->protocol != IPPROTO_TCP)
> +		return false;
> +
> +	tcph = (struct tcphdr *)((u8 *)iph + iph->ihl * 4);
> +	/* Piggyback ack without payload*/
> +	if (*((u8 *)tcph + 13) == 0x10 &&
> +	    ntohs(iph->tot_len) <= (iph->ihl + tcph->doff) * 4) {
> +		return true;
> +	}

It's rather ugly to use magic values (13 and 0x10) like that. Can't you
use some of the existing defines? At least I see TCP_FLAG_ACK and struct
tcphdr::ack being available, so you should even have choises what to
use.

-- 
Kalle Valo

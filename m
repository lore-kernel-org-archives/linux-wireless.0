Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:40854 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757753Ab1GKPPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 11:15:21 -0400
Message-ID: <4E1B1388.4060500@gnu.org> (sfid-20110711_171530_312853_6080B123)
Date: Mon, 11 Jul 2011 11:15:20 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
CC: netdev@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 04/46] net/wireless: p54: remove useless dma_sync_single_for_device(DMA_FROM_DEVICE)
References: <cover.1310339688.git.mirq-linux@rere.qmqm.pl> <86c8bde08b005ca7eb4806ea77aec1f3212d63fc.1310339688.git.mirq-linux@rere.qmqm.pl>
In-Reply-To: <86c8bde08b005ca7eb4806ea77aec1f3212d63fc.1310339688.git.mirq-linux@rere.qmqm.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/10/2011 08:52 PM, Michał Mirosław wrote:
> Also constify pointers used in frame parsers to verify assumptions.

Cleanups are better done separately.

> -	u16 type = le16_to_cpu(*((__le16 *)skb->data));
> +	u16 type = le16_to_cpu(*(const __le16 *)skb->data);

I think it would be more appropriate to use get_unaligned_le16() here. 
No casts should be needed then.

That's not an objection, just a suggestion :)

-- 
Regards,
Pavel Roskin

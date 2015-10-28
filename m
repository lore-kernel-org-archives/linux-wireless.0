Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:59026 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbbJ1KXD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 06:23:03 -0400
Subject: Re: [PATCH] Minstrel_ht: use lowest rate last
To: Dmitry Ivanov <dmitrijs.ivanovs@ubnt.com>,
	linux-wireless@vger.kernel.org
References: <20151026114236.233d1b54e6c08f3ab2b4c41a@ubnt.com>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <5630A1FC.6010309@openwrt.org> (sfid-20151028_112307_492104_A8287592)
Date: Wed, 28 Oct 2015 11:22:52 +0100
MIME-Version: 1.0
In-Reply-To: <20151026114236.233d1b54e6c08f3ab2b4c41a@ubnt.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-10-26 10:42, Dmitry Ivanov wrote:
> Minstrel_ht: use lowest rate last as in minstrel.
> It should improve robustness in environments with non-stationary noise.
> 
> Signed-off-by: Dmitry Ivanov <dima@ubnt.com>
Not using the lowest rate is intentional. Using the lowest rate severely
limits aggregation. In many cases, dropping a packet is preferrable, as
trying too hard to retry individual packets can cause extra bufferbloat
and severely increased latencies.

NACK from me on this patch. If anything, I think we should probably
change minstrel to behave in the same way as minstrel_ht.

- Felix

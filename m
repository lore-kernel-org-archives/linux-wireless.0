Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42409 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964828AbbJ1S6k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 14:58:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: wcn36xx: introduce per-channel ring buffer locks
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1445708535-20169-1-git-send-email-me@bobcopeland.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, k.eugene.e@gmail.com,
	wcn36xx@lists.infradead.org, Bob Copeland <me@bobcopeland.com>
Message-Id: <20151028185840.6D7F8141579@smtp.codeaurora.org> (sfid-20151028_195846_445117_5ACC6D2C)
Date: Wed, 28 Oct 2015 18:58:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> wcn36xx implements a ring buffer for transmitted frames for each
> (high and low priority) DMA channel.  The ring buffers are lockless:
> new frames are inserted at the head of the queue, while finished
> packets are reaped from the tail.
> 
> Unfortunately, the list manipulations are missing any kind of barriers
> so are susceptible to various races: for example, a TX completion
> handler might read an updated desc->ctrl before the head has actually
> advanced, and then null out the ctl->skb pointer while it is still
> being used in the TX path.
> 
> Simplify things here by adding a spin lock when traversing the ring.
> This change increased stability for me without adding any noticeable
> overhead on my platform (xperia z).
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo

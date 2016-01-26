Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:55132 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbcAZKpy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 05:45:54 -0500
Subject: Re: [PATCH 2/2] mac80211: expose txq queue depth and size to drivers
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless@vger.kernel.org
References: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com>
 <1453382588-27105-2-git-send-email-michal.kazior@tieto.com>
Cc: johannes@sipsolutions.net
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56A74E51.80609@openwrt.org> (sfid-20160126_114558_756390_D632AD3B)
Date: Tue, 26 Jan 2016 11:45:37 +0100
MIME-Version: 1.0
In-Reply-To: <1453382588-27105-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-01-21 14:23, Michal Kazior wrote:
> This will allow drivers to make more educated
> decisions whether to defer transmission or not.
> 
> Relying on wake_tx_queue() call count implicitly
> was not possible because it could be called
> without queued frame count actually changing on
> software tx aggregation start/stop code paths.
> 
> It was also not possible to know how long
> byte-wise queue was without dequeueing.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Instead of exposing these in the struct to the driver directly, please
make a function to get them. Since the number of frames is already
tracked in txqi->queue, you can avoid counter duplication that way.
Also, that way you can fix a race condition between accessing the number
of frames counter and the bytes counter.

- Felix

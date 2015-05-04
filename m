Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45141 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbbEDKPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 06:15:16 -0400
Message-ID: <1430734511.2013.18.camel@sipsolutions.net> (sfid-20150504_121520_026009_F0702BB5)
Subject: Re: [PATCH 1/2] add mt7601u driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Jakub =?UTF-8?Q?Kici=C5=84ski?= <moorray3@wp.pl>
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Date: Mon, 04 May 2015 12:15:11 +0200
In-Reply-To: <20150504120401.30835e07@north>
References: <1430571690-9054-1-git-send-email-moorray3@wp.pl>
	 <1430571690-9054-2-git-send-email-moorray3@wp.pl>
	 <1430732248.2013.16.camel@sipsolutions.net> <20150504120401.30835e07@north>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-05-04 at 12:04 +0200, Jakub Kiciński wrote:

> > Don't know how your buffers are set up, but if the DMA engine consumes
> > pages you could consider using paged RX instead of the memcpy().
> 
> DMA engine can concatenate multiple frames into a single USB bulk
> transfer to a large continuous buffer.  There is no way to request 
> any alignment of the frames within that large buffer so I think paged 
> RX is not an option.

You could probably still do it because the networking stack only
requires the *headers* to be aligned. But if they headers aren't in the
skb->data (skb->head) then they'll be pulled into that by the network
stack, where they'll be aligned.

johannes


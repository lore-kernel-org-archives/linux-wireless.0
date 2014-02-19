Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbaBSOvr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 09:51:47 -0500
Message-ID: <1392821503.4733.26.camel@jlt4.sipsolutions.net> (sfid-20140219_155155_311360_299D6079)
Subject: Re: [PATCH 2/2] mac80211: protect skb_queue_len(&ps->bc_buf) by lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 15:51:43 +0100
In-Reply-To: <20140219133546.GE1851@redhat.com>
References: <1392812916-13656-1-git-send-email-sgruszka@redhat.com>
	 <1392812916-13656-2-git-send-email-sgruszka@redhat.com>
	 <1392815649.4733.23.camel@jlt4.sipsolutions.net>
	 <20140219133546.GE1851@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-19 at 14:35 +0100, Stanislaw Gruszka wrote:

> > It ultimately makes no difference at all, it just makes this code more
> > difficult to read and understand.
> 
> It make difference when queue length value is modified on different CPU
> and read on different CPU. Without lock you can 'see' old length value
> on CPU that run ieee80211_tx_h_multicast_ps_buf() for undefined
> period of time (ok maybe not undefined on x86), and current oldest
> frame can be not necessarily dropped.

I don't see how that can be true, since the modifications of the queue
length are under spinlock with the implied memory barriers.

johannes


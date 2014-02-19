Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56220 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaBSNOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 08:14:12 -0500
Message-ID: <1392815649.4733.23.camel@jlt4.sipsolutions.net> (sfid-20140219_141416_207148_3661D418)
Subject: Re: [PATCH 2/2] mac80211: protect skb_queue_len(&ps->bc_buf) by lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Feb 2014 14:14:09 +0100
In-Reply-To: <1392812916-13656-2-git-send-email-sgruszka@redhat.com>
References: <1392812916-13656-1-git-send-email-sgruszka@redhat.com>
	 <1392812916-13656-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-19 at 13:28 +0100, Stanislaw Gruszka wrote:
> Similar change as on current patch "mac80211: fix calling
> ieee80211_free_txskb with NULL skb", but for multicast queue. Patch does
> not prevent crash, as dev_kfree_skb() checks against NULL skb, but it
> help to prevent not necessary frame drop, when bc_buf queue was
> partially flushed and no longer exceeds AP_MAX_BC_BUFFER .

I don't think this makes sense. It doesn't really change anything,
holding a spinlock isn't something magic that makes other things go
away, so instead of

 * check queue length, is >= limit
 * free frame from queue, even if somebody else is dequeuing as well

as before, you'd just have
 * check queue length, is >= limit
 * take lock
 * check queue length, is >= limit
 * drop frame
 * unlock
 * somebody else who was dequeuing now wakes up from waiting on the lock
and
   finds no frame there

It ultimately makes no difference at all, it just makes this code more
difficult to read and understand.

johannes


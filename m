Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab2KZR4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 12:56:23 -0500
Message-ID: <1353952597.2800.12.camel@jlt4.sipsolutions.net> (sfid-20121126_185628_780133_134FAA02)
Subject: Re: Kernel splat from 3.5.7+ (tainted)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 26 Nov 2012 18:56:37 +0100
In-Reply-To: <50B3AAEB.3070709@candelatech.com> (sfid-20121126_184631_765629_DC554BCF)
References: <50B3A275.3010302@candelatech.com>
	 <50B3AAEB.3070709@candelatech.com> (sfid-20121126_184631_765629_DC554BCF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-26 at 09:46 -0800, Ben Greear wrote:

> 0x182f9 is in __ieee80211_tx (/home/greearb/git/linux-3.5.dev.y/net/mac80211/tx.c:1256).
> 1251					skb_queue_splice_init(skbs, &local->pending[q]);
> 1252				} else {
> 1253					u32 len = skb_queue_len(&local->pending[q]);
> 1254					if (len >= max_pending_qsize) {
> 1255						__skb_unlink(skb, skbs);
> 1256						dev_kfree_skb(skb);
> 1257						/* TODO:  Add counter for this */
> 1258					} else {

Wait .. this appears to be a local patch you have, it doesn't exist.
That explains why, the bug doesn't exist upstream (all freeing there is
outside the queue lock)

johannes


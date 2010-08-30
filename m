Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab0H3OLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Aug 2010 10:11:25 -0400
Subject: Re: mac80211 using different tx queue for frames with same TID and
 RA
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	Krishna Kumar <krkumar2@in.ibm.com>, netdev@vger.kernel.org
In-Reply-To: <201008301601.12971.helmut.schaa@googlemail.com>
References: <201008301601.12971.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 16:11:20 +0200
Message-ID: <1283177480.3691.66.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-30 at 16:01 +0200, Helmut Schaa wrote:

> while debugging an issue in rt2x00 I've discovered that in some cases frames
> with the same TID and RA end up in different tx queues (which causes problems
> in rt2x00 when using aggregation).
> 
> Is this behavior expected and we need to handle that case in rt2x00 or is it
> more likely a bug? At least I thought the select_queue implementation in
> mac80211 was meant to always pick the same tx queue for skbs with the same
> priority and hence it shouldn't happen that frames with the same TID are
> queued into different tx queues.

Indeed, that seems like a bug. I don't see how this can happen though,
since the code _appears_ to not use the sk_tx_queue_mapping when an
ndo_select_queue method is present.

johannes


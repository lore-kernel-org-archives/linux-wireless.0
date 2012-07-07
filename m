Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55754 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2GGTnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jul 2012 15:43:10 -0400
Message-ID: <1341690188.5334.3.camel@jlt3.sipsolutions.net> (sfid-20120707_214331_546134_0683392A)
Subject: Re: [PATCH 2/2] mac80211: request TX status for BlockAck Requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Sat, 07 Jul 2012 21:43:08 +0200
In-Reply-To: <edffedafcc56e4b333030ce4f5f8cf85c56d6ab4.1341667309.git.chunkeey@googlemail.com> (sfid-20120707_153449_431412_F1FD3485)
References: <3accb52e0c55e2ac8388de7903ed6adfd964671b.1341667309.git.chunkeey@googlemail.com>
	 <edffedafcc56e4b333030ce4f5f8cf85c56d6ab4.1341667309.git.chunkeey@googlemail.com>
	 (sfid-20120707_153449_431412_F1FD3485)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-07-07 at 15:13 +0200, Christian Lamparter wrote:
> Because ieee80211_tx_status in status.c checks if
> outgoing BlockAck requests have been acked, it is
> necessary to tell the driver that tx feedback for
> this sort of frame is important.
> 
> Otherwise, the stack will continue to send the same
> BlockAck request over and over, which can cause
> the receiver to flush or clean its reorder buffer
> over and over.
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> AFAICT no driver will be really affected by this patch since
> either the TX status is always reported anyway or not at all.
> 
> BTW: ieee80211_tx_skb_tid is used by a few other agg functions
> (mostly addba/delba), so maybe it would make sense to do the
> same there.

Applied.

johannes


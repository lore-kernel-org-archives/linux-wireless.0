Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:51810 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbcGXTCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jul 2016 15:02:42 -0400
Date: Sun, 24 Jul 2016 20:02:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Alan Curry <rlwinm@sdf.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alexmcwhirter@triadic.us
Subject: Re: PROBLEM: network data corruption (bisected to e5a4b0bb803b)
Message-ID: <20160724190237.GP2356@ZenIV.linux.org.uk> (sfid-20160724_210320_354514_4222B2A4)
References: <201607240335.u6O3ZE81014171@sdf.org>
 <1659922.nTqITfJpFk@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1659922.nTqITfJpFk@debian64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 24, 2016 at 07:45:13PM +0200, Christian Lamparter wrote:

> > The symptom is that downloaded files (http, ftp, and probably other
> > protocols) have small corrupted segments (about 1-2 kilobytes long) in
> > random locations. Only downloads that sustain a high speed for at least a
> > few seconds are corrupted. Anything small enough to be received in less
> > than about 5 seconds is not affected.

Can that sucker be reproduced with netcat?  That would eliminate all issues
with multi-iovec recvmsg(2), narrowing the things down quite bit.

Another thing (and if that works, it's *NOT* a proper fix - it would be
papering over the problem, but at least it would show where to look for
it) - try (on top of mainline) the following delta:

diff --git a/net/core/datagram.c b/net/core/datagram.c
index b7de71f..0ee5995 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -734,7 +734,7 @@ int skb_copy_and_csum_datagram_msg(struct sk_buff *skb,
 	if (!chunk)
 		return 0;
 
-	if (msg_data_left(msg) < chunk) {
+	if (iov_iter_single_seg_count(&msg->msg_iter) < chunk) {
 		if (__skb_checksum_complete(skb))
 			goto csum_error;
 		if (skb_copy_datagram_msg(skb, hlen, msg, chunk))

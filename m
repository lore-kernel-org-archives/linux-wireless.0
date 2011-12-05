Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50531 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab1LEJF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Dec 2011 04:05:28 -0500
MIME-Version: 1.0
Date: Mon, 5 Dec 2011 10:05:27 +0100
Message-ID: <CAA93jw7kQYONQiAozatRmdRRJeK0GB9eNDWtRZ3AL+OVKn0OpA@mail.gmail.com> (sfid-20111205_100544_254878_6DBE3D0E)
Subject: Time in Queue, bufferbloat, and... our accidentally interplanetary network
From: Dave Taht <dave.taht@gmail.com>
To: bloat <bloat@lists.bufferbloat.net>,
	bloat-devel <bloat-devel@lists.bufferbloat.net>,
	netdev@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was tickled to see that expiring packets based on 'time in queue'
was already a
key design feature of the IPN,

http://www.science20.com/interwebometry/lessons_nasa_can_learn_internet-84861

and the idea was suggested also independently in saturday's CACM
article's comments...

http://queue.acm.org/detail.cfm?id=2071893


Making decisions based on time in queue (TiQ), rather than length of
queue, would
seem to be a win, especially for wireless, but also for  that does
'soft' traffic
shaping with HTB-like qdiscs and sub qdiscs. Anything that is not running
at GigE plus speeds would benefit.

... since basically what's been happening with bufferbloat is a too early
implementation of the IPN, with detours between here and the moon!

... and so far I haven't seen any major theoretical holes in with TiQ, except
for deciding as to how long is too long as to consider a packet as 'expired',
(which can be measured in ms or 10s of ms), and having reasonably
monotonic time.

I just wish I (or someone) could come up with a way to implement it in Linux
without multiple layer violations. skb->queuestamp has a nice ring to it, but
when I look at this portion of the stack I freely admit quivering in ignorance
and fear.

I did a bit of work on a set of timestamping fifos, but realized that
it was the
entire queue's duration from entrance to exit (through multiple scheduling
qdiscs) was what needed to be  measured, and the drop/no drop decision
needs to be made as late as possible - and preferably, the queue being
pulled from needs the next packet pulled forward so as to inform the
receiver that congestion is happening...

And Eric dumazet also produced a preliminary patch a few weeks back
that tied timestamping to before the head of a queue, but that tried to use a
reserved field in the skb that appears from points A to Z is not guaranteed
to be preserved.

Thoughts?

-- 
Dave Täht
SKYPE: davetaht
US Tel: 1-239-829-5608
FR Tel: 0638645374
http://www.bufferbloat.net

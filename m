Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58162 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbZBVTXM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 14:23:12 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: More data on open-source firmware crash
Date: Sun, 22 Feb 2009 20:20:29 +0100
Cc: Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	Lorenzo Nava <navalorenx@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
References: <49A1A331.9080205@lwfinger.net>
In-Reply-To: <49A1A331.9080205@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902222020.29586.mb@bu3sch.de> (sfid-20090222_202316_253339_5E673A9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 22 February 2009 20:10:41 Larry Finger wrote:
> Francesco and Lorenzo,
> 
> I modified my driver source to dump the firmware machine state whenever the
> b43_dma_handle_txstatus routine was called with an out-of-order cookie. With
> proprietary firmware, the test of a flood ping in one job and repeated tcpperf
> transmissions in a second ran for 10 hours without a single "failure". With the
> open-source firmware it failed after about 2 hours.
> 
> Below are the saved status data. Listed for each item are the cookie, the
> sequence number, and the skb length. The 0x84 length values come from the ping.
> All of the out-of-order items come from tcpperf - is it significant that they
> are from the longer set? Note that a number of cookie/sequence pairs are
> missing, namely: 2064/9C1, 2066/9C2, 2068/9C3, 206A/9C4, 206C/9C5, 2072/9C7,
> 2076/9C9, and 207A/9CB. Cookie 206E is missing, but the next sequence (9C6) was
> attached to cookie 2070.
> 
> This was not the first printout, but at this point cookie/sequence pair 2086/9D2
> was received. It is a duplicate of item 22, thus its skb had been deleted and
> poisoned.
> 
> I don't understand the firmware, but is it possible that there is a queue
> overrun, or some data in a queue are being missed?

Of course this is possible, but I don't know how to verify this.

Maybe you should modify the tx status fetching loop.
I think (this is only an estimation) that the queue is about 16 entries long.
So if you are able to fetch 16 entries in a row from it, it's possible that we had
and overflow, if the firmware overflow protection mechanism failed at that point.

So you can see if the 16-entries-in-a-row and the out-of-order cookies happen at
about the same time.

Of course I don't know if the number 16 is correct. It's just an estimation.

-- 
Greetings, Michael.

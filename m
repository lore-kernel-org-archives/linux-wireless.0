Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:44729 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbZBVTr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2009 14:47:27 -0500
Cc: Lorenzo Nava <navalorenx@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Message-Id: <80C13710-6BA9-4F14-95B5-82C3043CE93B@ing.unibs.it> (sfid-20090222_204730_584456_DEC8E7F4)
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
To: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <49A1A331.9080205@lwfinger.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: More data on open-source firmware crash
Date: Sun, 22 Feb 2009 20:47:24 +0100
References: <49A1A331.9080205@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 22, 2009, at 8:10 PM, Larry Finger wrote:

> Francesco and Lorenzo,
>
Hi Larry,

many thanks for your analysis.

> I modified my driver source to dump the firmware machine state  
> whenever the
> b43_dma_handle_txstatus routine was called with an out-of-order  
> cookie. With
> proprietary firmware, the test of a flood ping in one job and  
> repeated tcpperf
> transmissions in a second ran for 10 hours without a single  
> "failure". With the
> open-source firmware it failed after about 2 hours.
>
> Below are the saved status data. Listed for each item are the  
> cookie, the
> sequence number, and the skb length. The 0x84 length values come  
> from the ping.
> All of the out-of-order items come from tcpperf - is it significant  
> that they
> are from the longer set? Note that a number of cookie/sequence pairs  
> are
> missing, namely: 2064/9C1, 2066/9C2, 2068/9C3, 206A/9C4, 206C/9C5,  
> 2072/9C7,
> 2076/9C9, and 207A/9CB. Cookie 206E is missing, but the next  
> sequence (9C6) was
> attached to cookie 2070.
>
> This was not the first printout, but at this point cookie/sequence  
> pair 2086/9D2
> was received. It is a duplicate of item 22, thus its skb had been  
> deleted and
> poisoned.
>
> I don't understand the firmware, but is it possible that there is a  
> queue
> overrun, or some data in a queue are being missed?
That could be. After reading this, I remember that there was one  
condition (always false on all of our boards) that we can't understand  
at that time. I'm preparing a patch: I hope you can test it as we do  
not have boards that will jump on that condition.

Cheers,
-FG

>
> Feb 22 00:07:59 mtech kernel: Item 28: 0x205A 0x9BC 0x84
> Feb 22 00:07:59 mtech kernel: Item 27: 0x205C 0x9BD 0x84
> Feb 22 00:07:59 mtech kernel: Item 26: 0x205E 0x9BE 0x84
> Feb 22 00:07:59 mtech kernel: Item 25: 0x2060 0x9BF 0x84
> Feb 22 00:07:59 mtech kernel: Item 24: 0x2062 0x9C0 0x84
> Feb 22 00:07:59 mtech kernel: Item 23: 0x2084 0x9D1 0x60C
> Feb 22 00:07:59 mtech kernel: Item 22: 0x2086 0x9D2 0x60C
> Feb 22 00:07:59 mtech kernel: Item 21: 0x2088 0x9D3 0x60C
> Feb 22 00:07:59 mtech kernel: Item 20: 0x208A 0x9D4 0x60C
> Feb 22 00:07:59 mtech kernel: Item 19: 0x208C 0x9D5 0x60C
> Feb 22 00:07:59 mtech kernel: Item 18: 0x208E 0x9D6 0x60C
> Feb 22 00:07:59 mtech kernel: Item 17: 0x2070 0x9C6 0x60C
> Feb 22 00:07:59 mtech kernel: Item 16: 0x2090 0x9D7 0x60C
> Feb 22 00:07:59 mtech kernel: Item 15: 0x2092 0x9D8 0x60C
> Feb 22 00:07:59 mtech kernel: Item 14: 0x2074 0x9C8 0x60C
> Feb 22 00:07:59 mtech kernel: Item 13: 0x2094 0x9D9 0x60C
> Feb 22 00:07:59 mtech kernel: Item 12: 0x2096 0x9DA 0x60C
> Feb 22 00:07:59 mtech kernel: Item 11: 0x2078 0x9CA 0x60C
> Feb 22 00:07:59 mtech kernel: Item 10: 0x2098 0x9DB 0x60C
> Feb 22 00:07:59 mtech kernel: Item  9: 0x209A 0x9DC 0x1B4
> Feb 22 00:07:59 mtech kernel: Item  8: 0x207C 0x9CC 0x60C
> Feb 22 00:07:59 mtech kernel: Item  7: 0x209C 0x9DD 0x60C
> Feb 22 00:07:59 mtech kernel: Item  6: 0x209E 0x9DE 0x84
> Feb 22 00:07:59 mtech kernel: Item  5: 0x2080 0x9CE 0x60C
> Feb 22 00:07:59 mtech kernel: Item  4: 0x20A0 0x9DF 0x84
> Feb 22 00:07:59 mtech kernel: Item  3: 0x2082 0x9D0 0x60C
> Feb 22 00:07:59 mtech kernel: Item  2: 0x20A2 0x9E0 0x84
> Feb 22 00:07:59 mtech kernel: Item  1: 0x20A4 0x9E1 0x84
>
> Larry
Larry, it seems that

-------

Francesco Gringoli, PhD - Assistant Professor
Dept. of Electrical Engineering for Automation
University of Brescia
via Branze, 38
25123 Brescia
ITALY

Ph:  ++39.030.3715843
FAX: ++39.030.380014
WWW: http://www.ing.unibs.it/~gringoli





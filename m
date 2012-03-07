Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759040Ab2CGSqw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 13:46:52 -0500
Date: Wed, 7 Mar 2012 19:46:36 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Martin =?iso-8859-1?Q?Hundeb=F8ll?= <m.hundeboll@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3.3] rt2x00: fix random stalls
Message-ID: <20120307184635.GD15839@redhat.com> (sfid-20120307_194655_935777_F0414EEC)
References: <20120305164813.GB2979@redhat.com>
 <4F564CDC.5040808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4F564CDC.5040808@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Tue, Mar 06, 2012 at 06:43:56PM +0100, Martin Hundebøll wrote:
> Hi,
> 
> On 03/05/2012 05:48 PM, Stanislaw Gruszka wrote:
> >Is possible that we stop queue and then do not wake up it again,
> >especially when packets are transmitted fast. That can be easily
> >reproduced with modified tx queue entry_num to some small value e.g. 16.
> >
> >If mac80211 already hold local->queue_stop_reason_lock, then we can wait
> >on that lock in both rt2x00queue_pause_queue() and
> >rt2x00queue_unpause_queue(). After drooping ->queue_stop_reason_lock
> >is possible that __ieee80211_wake_queue() will be performed before
> >__ieee80211_stop_queue(), hence we stop queue and newer wake up it
> >again.
> >
> >To prevent stalls serialize pause/unpause by queue->tx_lock.
> 
> I've been having CPU load issues with rt2800usb/Ralink RT2870, when doing simultaneous TX/RX between to nodes in an adhoc network. While transfering UDP packets in one direction with iperf[1], I get ~23Mbit/s and kworker is utilizing <10% of the CPU (OMAP4 1GHz dualcore or/and Pentium M 1.70GHz) on both ends. When doing bidirectional tests with iperf[2], one kworker thread jumps too 100% and throughput drops.
> 
> By using two iperf clients to do bidirectional TCP transfers, I got ~6Mbit/s in both directions, so I suspected some queueing issues and thus applied this patch, but no change. I've tried to do some tracing[3], but this is quite new to me, so please instruct me, if you need more info.

I did short test here and do not enter that issue. Which kernel version are you using?

> [3]
> out.txt has a trace from 10.10.10.55 while running iperf as in [2] and the following commands:

Please newer do this again :-) If you want to provide such big data, put it
somewhere and paste download link to the email. Moreover that tracing
did not provide any useful information.

Stanislaw


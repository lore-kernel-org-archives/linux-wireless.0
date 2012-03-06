Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61645 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756486Ab2CFVhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 16:37:17 -0500
Received: by lahj13 with SMTP id j13so6527354lah.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2012 13:37:16 -0800 (PST)
Message-ID: <4F568389.8080803@gmail.com> (sfid-20120306_223723_446693_A16F2B14)
Date: Tue, 06 Mar 2012 22:37:13 +0100
From: =?UTF-8?B?TWFydGluIEh1bmRlYsO4bGw=?= <m.hundeboll@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3.3] rt2x00: fix random stalls
References: <20120305164813.GB2979@redhat.com> <4F564CDC.5040808@gmail.com>
In-Reply-To: <4F564CDC.5040808@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm very sorry about the size of my previous mail. I hope that it was not too trouble.

/ Martin

On 03/06/2012 06:43 PM, Martin Hundebøll wrote:
> Hi,
>
> On 03/05/2012 05:48 PM, Stanislaw Gruszka wrote:
>> Is possible that we stop queue and then do not wake up it again,
>> especially when packets are transmitted fast. That can be easily
>> reproduced with modified tx queue entry_num to some small value e.g. 16.
>>
>> If mac80211 already hold local->queue_stop_reason_lock, then we can wait
>> on that lock in both rt2x00queue_pause_queue() and
>> rt2x00queue_unpause_queue(). After drooping ->queue_stop_reason_lock
>> is possible that __ieee80211_wake_queue() will be performed before
>> __ieee80211_stop_queue(), hence we stop queue and newer wake up it
>> again.
>>
>> To prevent stalls serialize pause/unpause by queue->tx_lock.
>
> I've been having CPU load issues with rt2800usb/Ralink RT2870, when doing simultaneous TX/RX between to nodes in an adhoc network. While transfering UDP packets in one direction with iperf[1], I get ~23Mbit/s and kworker is utilizing <10% of the CPU (OMAP4 1GHz dualcore or/and Pentium M 1.70GHz) on both ends. When doing bidirectional tests with iperf[2], one kworker thread jumps too 100% and throughput drops.
>
> By using two iperf clients to do bidirectional TCP transfers, I got ~6Mbit/s in both directions, so I suspected some queueing issues and thus applied this patch, but no change. I've tried to do some tracing[3], but this is quite new to me, so please instruct me, if you need more info.
>
> Kind regards,
> Martin Hundebøll
>
> [1]
>  iperf unidirectional cmd and output:
> # iperf -c10.10.10.56 -ub50M
> Server Report:
> 0.0-10.0 sec  27.5 MBytes  22.9 Mbits/sec   1.639 ms    0/19602 (0%)
>
> [2]
>  iperf bidirectional cmd and output:
> # iperf -c10.10.10.56 -udb8M
> Sent 2501 datagrams
> [  3]  0.0-11.0 sec  1.26 MBytes   963 Kbits/sec  22.437 ms  943/ 1840 (51%)
> Server Report:
> [  4]  0.0-10.9 sec  2.11 MBytes  1.62 Mbits/sec  309.803 ms  993/ 2500 (40%)
>
> [3]
> out.txt has a trace from 10.10.10.55 while running iperf as in [2] and the following commands:
> $ echo workqueue:workqueue_queue_work > /sys/kernel/debug/tracing/set_event
> $ cat /sys/kernel/debug/tracing/trace_pipe > out.txt


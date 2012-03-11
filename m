Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60218 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752107Ab2CKJxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2012 05:53:36 -0400
Received: by lahj13 with SMTP id j13so2861205lah.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Mar 2012 01:53:34 -0800 (PST)
Message-ID: <4F5C761B.2050403@gmail.com> (sfid-20120311_105349_522371_241F5283)
Date: Sun, 11 Mar 2012 10:53:31 +0100
From: =?UTF-8?B?TWFydGluIEh1bmRlYsO4bGw=?= <m.hundeboll@gmail.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3.3] rt2x00: fix random stalls
References: <20120305164813.GB2979@redhat.com> <4F564CDC.5040808@gmail.com> <20120307184635.GD15839@redhat.com>
In-Reply-To: <20120307184635.GD15839@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 03/07/2012 07:46 PM, Stanislaw Gruszka wrote:
> Hi
>
> On Tue, Mar 06, 2012 at 06:43:56PM +0100, Martin Hundebøll wrote:
>> Hi,
>>
>> On 03/05/2012 05:48 PM, Stanislaw Gruszka wrote:
>>> Is possible that we stop queue and then do not wake up it again,
>>> especially when packets are transmitted fast. That can be easily
>>> reproduced with modified tx queue entry_num to some small value e.g. 16.
>>>
>>> If mac80211 already hold local->queue_stop_reason_lock, then we can wait
>>> on that lock in both rt2x00queue_pause_queue() and
>>> rt2x00queue_unpause_queue(). After drooping ->queue_stop_reason_lock
>>> is possible that __ieee80211_wake_queue() will be performed before
>>> __ieee80211_stop_queue(), hence we stop queue and newer wake up it
>>> again.
>>>
>>> To prevent stalls serialize pause/unpause by queue->tx_lock.
>> I've been having CPU load issues with rt2800usb/Ralink RT2870, when doing simultaneous TX/RX between to nodes in an adhoc network. While transfering UDP packets in one direction with iperf[1], I get ~23Mbit/s and kworker is utilizing<10% of the CPU (OMAP4 1GHz dualcore or/and Pentium M 1.70GHz) on both ends. When doing bidirectional tests with iperf[2], one kworker thread jumps too 100% and throughput drops.
>>
>> By using two iperf clients to do bidirectional TCP transfers, I got ~6Mbit/s in both directions, so I suspected some queueing issues and thus applied this patch, but no change. I've tried to do some tracing[3], but this is quite new to me, so please instruct me, if you need more info.
> I did short test here and do not enter that issue. Which kernel version are you using?

I forgot to mention, that we work with adhoc networks. I've tested 2.6.38.4 and 3.2.7, with in-tree and compat-wireless on both versions.

However, the issue is fixed by another patch-set posted on users@rt2x00.serialmonkey.com ([RFC/RFT 0/5] rt2x00: rt2800usb: rework tx path). So now I "just" see random stalls, which should be fixed by this patch. (I will test the most recent version shortly.)

>> [3]
>> out.txt has a trace from 10.10.10.55 while running iperf as in [2] and the following commands:
> Please newer do this again :-) If you want to provide such big data, put it
> somewhere and paste download link to the email. Moreover that tracing
> did not provide any useful information.

Will never happen again :)

// Martin

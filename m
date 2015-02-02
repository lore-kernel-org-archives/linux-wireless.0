Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:40423 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933099AbbBBK1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 05:27:16 -0500
Received: by mail-wg0-f41.google.com with SMTP id a1so37849057wgh.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2015 02:27:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422628835.21689.95.camel@edumazet-glaptop2.roam.corp.google.com>
References: <CA+BoTQkVu23P3EOmY_Q3E1GJnWsyF==Pawz4iPOS_Bq5dvfO5Q@mail.gmail.com>
	<1422537297.21689.15.camel@edumazet-glaptop2.roam.corp.google.com>
	<CA+BoTQk2xT-8DqPuiiKG+kHAjLPrj8F9dLTb-rcGhvMq0u_2Qw@mail.gmail.com>
	<1422628835.21689.95.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Mon, 2 Feb 2015 11:27:15 +0100
Message-ID: <CA+BoTQkV+mOZfe_Niz5101sMQeaV6muKCsShptjGQ1AgOHqqoQ@mail.gmail.com> (sfid-20150202_112723_997131_ECCF61A5)
Subject: Re: Throughput regression with `tcp: refine TSO autosizing`
From: Michal Kazior <michal.kazior@tieto.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	eyalpe@dev.mellanox.co.il
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 January 2015 at 15:40, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Fri, 2015-01-30 at 14:39 +0100, Michal Kazior wrote:
>
>> I've briefly tried playing with this knob to no avail unfortunately. I
>> tried 256K, 1M - it didn't improve TCP performance. When I tried to
>> make it smaller (e.g. 16K) the traffic dropped even more so it does
>> have an effect. It seems there's some other limiting factor in this
>> case.
>
> Interesting.
>
> Could you take some tcpdump/pcap with various tcp_limit_output_bytes
> values ?
>
> echo 131072 >/proc/sys/net/ipv4/tcp_limit_output_bytes
> tcpdump -p -i wlanX -s 128 -c 20000 -w 128k.pcap
>
> echo 262144 >/proc/sys/net/ipv4/tcp_limit_output_bytes
> tcpdump -p -i wlanX -s 128 -c 20000 -w 256k.pcap

I've run a couple of tests across different kernels. This got pretty
big so I decided to use an external file hosting:
 http://www.filedropper.com/testtar

Let me know if you can't access it (and perhaps you could suggest how
you prefer the logs to be delivered in that case).

The layout of logs is: $kernel/$limit-P$threads.pcap. I've also
included the test script and output of each test run.

While testing I've had my internal GRO patch for ath10k and no stretch
ack patches.

When I was trying to come up with a testing methodology I've noticed
something interesting:
 1. set 16k limit
 2. start iperf -P1
 3. observe 200mbps
 4. set 2048k limit (while iperf is running)
 5. observe 600mbps
 6. set 16limit back (while iperf is running)
 7. observe 500-600mbps (i.e. no drop to 200mbps)

Due to that I've decided to re-start iperf for each limit test.

If you want me to gather some other logs/dumps/configuration
permutations let me know, please.


Michał

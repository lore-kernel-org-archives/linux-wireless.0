Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:60821 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbbA3Oki (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 09:40:38 -0500
Message-ID: <1422628835.21689.95.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20150130_154045_483920_79CE22F7)
Subject: Re: Throughput regression with `tcp: refine TSO autosizing`
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	eyalpe@dev.mellanox.co.il
Date: Fri, 30 Jan 2015 06:40:35 -0800
In-Reply-To: <CA+BoTQk2xT-8DqPuiiKG+kHAjLPrj8F9dLTb-rcGhvMq0u_2Qw@mail.gmail.com>
References: <CA+BoTQkVu23P3EOmY_Q3E1GJnWsyF==Pawz4iPOS_Bq5dvfO5Q@mail.gmail.com>
	 <1422537297.21689.15.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CA+BoTQk2xT-8DqPuiiKG+kHAjLPrj8F9dLTb-rcGhvMq0u_2Qw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-30 at 14:39 +0100, Michal Kazior wrote:

> I've briefly tried playing with this knob to no avail unfortunately. I
> tried 256K, 1M - it didn't improve TCP performance. When I tried to
> make it smaller (e.g. 16K) the traffic dropped even more so it does
> have an effect. It seems there's some other limiting factor in this
> case.

Interesting.

Could you take some tcpdump/pcap with various tcp_limit_output_bytes
values ?

echo 131072 >/proc/sys/net/ipv4/tcp_limit_output_bytes
tcpdump -p -i wlanX -s 128 -c 20000 -w 128k.pcap

echo 262144 >/proc/sys/net/ipv4/tcp_limit_output_bytes
tcpdump -p -i wlanX -s 128 -c 20000 -w 256k.pcap

...

Thanks !



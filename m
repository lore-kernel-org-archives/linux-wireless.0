Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35440 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab0GZXgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 19:36:48 -0400
Received: by eya25 with SMTP id 25so585661eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 16:36:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimGvPtolVncEu_csK22xvf1SIFFPusCSqxYiU-A@mail.gmail.com>
References: <AANLkTimQ7O2nOmh2Rda3d_PKWbS2WlGVBHYMCuhxW10W@mail.gmail.com>
	<4C4791AF.8040909@openwrt.org>
	<AANLkTimGvPtolVncEu_csK22xvf1SIFFPusCSqxYiU-A@mail.gmail.com>
Date: Tue, 27 Jul 2010 01:36:46 +0200
Message-ID: <AANLkTinN77ep3qgVsQH4pWpp1k565pkHXs19yqgYh-sQ@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k: performance regressions / tx semi-stuck
	somehow
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/7/23 Björn Smedman <bjorn.smedman@venatech.se>:
> 2010/7/22 Felix Fietkau <nbd@openwrt.org>:
>> On 2010-07-22 12:17 AM, Björn Smedman wrote:
>>> I just tried out compat-wireless-2010-07-16 on AR913x (with
>>> openwrt/trunk@r22321) and saw some weird performance problems.
>>>
>> Could you please try if the earlier version that was in OpenWrt
>> (2010-07-06) has the same issues?

I had some trouble reproducing this but now I feel convinced that this
performance issue was caused by interference, although I think ath9k
could do a better job in difficult radio environments.

Note how downstream throughput goes from ~55 Mbps down to around 3
Mbps. Nothing is moved in this experiment.

bjorn-smedmans-macbook-2:~ bjornsmedman$ iperf -w 256K -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size:   256 KByte
------------------------------------------------------------
[  4] local 192.168.78.119 port 5001 connected with 192.168.78.211 port 58060
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-30.0 sec    194 MBytes  54.1 Mbits/sec
[  4] local 192.168.78.119 port 5001 connected with 192.168.78.211 port 58926
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-30.0 sec    203 MBytes  56.6 Mbits/sec
[  4] local 192.168.78.119 port 5001 connected with 192.168.78.211 port 58990
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-30.0 sec    190 MBytes  53.2 Mbits/sec
[  4] local 192.168.78.119 port 5001 connected with 192.168.78.211 port 59236
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-30.0 sec    189 MBytes  52.8 Mbits/sec
[  4] local 192.168.78.119 port 5001 connected with 192.168.78.211 port 64327

[Some interference source probably comes in here]

[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-34.5 sec  5.64 MBytes  1.37 Mbits/sec
[  4] local 192.168.78.119 port 5001 connected with 192.168.78.211 port 64424
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-30.3 sec  8.06 MBytes  2.23 Mbits/sec
[  4] local 192.168.78.119 port 5001 connected with 192.168.78.211 port 64625
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-31.3 sec  13.6 MBytes  3.64 Mbits/sec


If I then switch the AP channel (from 1 to 11) performance is looking
good again:

bjorn-smedmans-macbook-2:~ bjornsmedman$ iperf -w 256K -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size:   256 KByte
------------------------------------------------------------
[  4] local 192.168.78.119 port 5001 connected with 192.168.78.211 port 55550
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-120.0 sec    621 MBytes  43.4 Mbits/sec
[  4] local 192.168.78.119 port 5001 connected with 192.168.78.211 port 55562
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-120.0 sec    764 MBytes  53.4 Mbits/sec
[  4] local 192.168.78.119 port 5001 connected with 192.168.78.211 port 55568
[ ID] Interval       Transfer     Bandwidth
[  4]  0.0-10.0 sec  68.1 MBytes  56.9 Mbits/sec


/Björn

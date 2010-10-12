Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63088 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306Ab0JLROV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 13:14:21 -0400
Received: by wyb28 with SMTP id 28so218715wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 10:14:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010121933.59209.br1@einfach.org>
References: <201010121933.59209.br1@einfach.org>
Date: Tue, 12 Oct 2010 12:14:19 -0500
Message-ID: <AANLkTin3eFFnVS5e1uK=-jmA3iC4qqfBLWkt0KFexYDg@mail.gmail.com>
Subject: Re: [ath5k-devel] How to profile this strange effect under high load?
From: Qasim Javed <qasimj@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

How about using trace-cmd and kernelshark with function graph tracer
to see what is getting called so often?

-Qasim

On Tue, Oct 12, 2010 at 5:33 AM, Bruno Randolf <br1@einfach.org> wrote:
> Hello!
>
> I am trying to debug a strange effect, I am seeing on soekris net48xx boards
> with two ath5k interfaces:
>
>  * wlan0 [phy0] configured in ad-hoc mode, A band, and it is getting a lot of
> traffic routed thru it
>  * wlan1 [phy1] also configured in ad-hoc mode, G band, but not actively
> sending (no IP address).
>
> I run iperf between two PCs attached by ethernet, UDP 25Mbps and I am sure all
> traffic is routed thru wlan0 (phy0). The load on the SENDING box gets very
> high:
>
> Mem: 27304K used, 99040K free, 0K shrd, 616K buff, 14128K cached
> CPU:   0% usr   0% sys   0% nic   0% idle   0% io   5% irq  93% sirq
> Load average: 1.73 1.01 2.23 2/38 3128
>  PID  PPID USER     STAT   VSZ %MEM %CPU COMMAND
>  2772     2 root     RW       0   0%  71% [phy1]
>  2757     2 root     SW       0   0%  11% [phy0]
>  3128   436 root     R      988   1%   8% top
>    3     2 root     SW       0   0%   5% [ksoftirqd/0]
>    5     2 root     SW       0   0%   3% [events/0]
>   56     2 root     SW       0   0%   1% [bdi-default]
>  1383     1 root     S     1824   1%   0% /usr/bin/oprofiled --session-dir=/r
>
> ...and the interesting thing is that [phy1] - the INACTIVE interface -
> consumes much more CPU time than [phy0] which is actually transmitting.
>
> I have disabled ANI on wlan1, to avoid getting many MIB interrupts, but it
> does not change much.
>
> I have dumped frames on phy1, and all it sees are a few beacon frames.
>
> I have tried wlan1 in managed mode - same effect. The effect is slightly less
> in AP mode, though...
>
> I tried oprofile, but it shows mostly tx related things.
>
> So my question is: How can I find out, what [phy1] is so busy doing? Any ideas
> how to profile this?
>
> Thanks in advance,
> bruno
> _______________________________________________
> ath5k-devel mailing list
> ath5k-devel@lists.ath5k.org
> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
>

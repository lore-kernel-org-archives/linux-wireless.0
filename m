Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:38135 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757149Ab0JLKdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 06:33:52 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0248509629
	for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 19:33:50 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: How to profile this strange effect under high load?
Date: Tue, 12 Oct 2010 19:33:59 +0900
Cc: ath5k-devel@lists.ath5k.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201010121933.59209.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I am trying to debug a strange effect, I am seeing on soekris net48xx boards 
with two ath5k interfaces:

 * wlan0 [phy0] configured in ad-hoc mode, A band, and it is getting a lot of 
traffic routed thru it
 * wlan1 [phy1] also configured in ad-hoc mode, G band, but not actively 
sending (no IP address).

I run iperf between two PCs attached by ethernet, UDP 25Mbps and I am sure all 
traffic is routed thru wlan0 (phy0). The load on the SENDING box gets very 
high:

Mem: 27304K used, 99040K free, 0K shrd, 616K buff, 14128K cached
CPU:   0% usr   0% sys   0% nic   0% idle   0% io   5% irq  93% sirq
Load average: 1.73 1.01 2.23 2/38 3128
  PID  PPID USER     STAT   VSZ %MEM %CPU COMMAND
 2772     2 root     RW       0   0%  71% [phy1]
 2757     2 root     SW       0   0%  11% [phy0]
 3128   436 root     R      988   1%   8% top 
    3     2 root     SW       0   0%   5% [ksoftirqd/0]
    5     2 root     SW       0   0%   3% [events/0]
   56     2 root     SW       0   0%   1% [bdi-default]
 1383     1 root     S     1824   1%   0% /usr/bin/oprofiled --session-dir=/r

...and the interesting thing is that [phy1] - the INACTIVE interface - 
consumes much more CPU time than [phy0] which is actually transmitting.

I have disabled ANI on wlan1, to avoid getting many MIB interrupts, but it 
does not change much. 

I have dumped frames on phy1, and all it sees are a few beacon frames.

I have tried wlan1 in managed mode - same effect. The effect is slightly less 
in AP mode, though...

I tried oprofile, but it shows mostly tx related things.

So my question is: How can I find out, what [phy1] is so busy doing? Any ideas 
how to profile this?

Thanks in advance,
bruno

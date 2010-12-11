Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:36656 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab0LKGKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Dec 2010 01:10:30 -0500
Received: by bwz16 with SMTP id 16so4840855bwz.4
        for <linux-wireless@vger.kernel.org>; Fri, 10 Dec 2010 22:10:28 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 10 Dec 2010 22:10:28 -0800
Message-ID: <AANLkTimWEGHychwGqeCjmPcx=6gtsE8cGfg_XYsaKMnP@mail.gmail.com>
Subject: [RFC] improving latency under congestion in the iwlwifi driver
From: Nathaniel Smith <njs@pobox.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using an iwl3945 ("rev 02") to talk to a netgear AP, and normally,
when my network is uncongested, the latency between my laptop and the
AP is quite small, on the order of 2 ms:

------------------
~$ ping -qnc 10 192.168.1.7
--- 192.168.1.7 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9012ms
rtt min/avg/max/mdev = 1.707/2.406/3.645/0.703 ms
------------------

But if I fill the uplink by transmitting a lot of data (to 'frances',
a computer attached to the AP by 100 Mbs ethernet, so the wifi link is
the bottleneck), then latencies go up. (In real life, this happens to
me daily when rsync takes backups, and suddenly HTTP and ssh become
unusable.):

------------------
~$ nttcp -t -T -D -n10000 frances & (sleep 60 && ping -qnc 10 192.168.16.7)
--- 192.168.16.7 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9055ms
rtt min/avg/max/mdev = 2058.065/3646.303/5672.363/1093.343 ms, pipe 6

nttcp transfer statistics:
     Bytes  Real s   CPU s Real-MBit/s  CPU-MBit/s   Calls  Real-C/s   CPU-C/s
l 40960000  114.41    0.18      2.8642   1780.7631   10000     87.41   54344.6
1 40960000  117.22    0.25      2.7954   1300.2401   28862    246.22  114524.9
------------------

(This particular set of pings is actually rather tame... while testing
this, I've seen individual pings at 11+ seconds, and averages over 6
seconds.)

As Jim Gettys has recently reminded us, latency can come from overly
large buffers; when a transmit queue fills up, then packets have to
spend time draining from the tail of the buffer to its head before
they can continue on their way, and the latency added is queue-size
divided by link-bandwidth. My connection is not so awesome ("Bit Rate:
5.5 Mb/s"), but that does not seem to be a sufficient excuse for the
kernel to introduce 3+ seconds of latency between userspace and my
network card. I mean, they're like, right next to each other.

So I tried reducing txqueuelen to 0, but that didn't help much:

------------------
~$ sudo ip link set wlan0 txqueuelen 0
~$ nttcp -t -T -D -n10000 frances & (sleep 60 && ping -qnc 10 192.168.16.7)
--- 192.168.16.7 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9029ms
rtt min/avg/max/mdev = 1023.633/2936.387/5291.846/1424.396 ms, pipe 5

nttcp transfer statistics:
     Bytes  Real s   CPU s Real-MBit/s  CPU-MBit/s   Calls  Real-C/s   CPU-C/s
l 40960000  186.83    0.09      1.7539   3723.4248   10000     53.53  113629.9
1 40960000  191.49    0.22      1.7112   1516.9457   28291    147.74  130969.0
------------------

So, I applied the attached patch to reduce the effective size of the
ring-buffers used to communicate with the network card from 224
packets down to 8, and again set txqueuelen to 0:

------------------
~$ sudo insmod ./iwlcore.ko && sudo insmod ./iwl3945.ko
~$ sudo ip link set wlan0 txqueuelen 0
~$ nttcp -t -T -D -n10000 frances & (sleep 60 && ping -qnc 10 192.168.16.7)
--- 192.168.16.7 ping statistics ---
10 packets transmitted, 9 received, 10% packet loss, time 10013ms
rtt min/avg/max/mdev = 4.551/25.640/49.847/16.672 ms

nttcp transfer statistics:
     Bytes  Real s   CPU s Real-MBit/s  CPU-MBit/s   Calls  Real-C/s   CPU-C/s
l 40960000  115.98    0.11      2.8253   2925.5314   10000     86.22   89280.1
1 40960000  116.13    0.29      2.8217   1122.1265   28264    243.39   96788.9
------------------

Also, using the PRIO qdisc to prioritize latency-sensitive traffic
seems to actually work now, which it doesn't without this patch --
presumably because the problem was the buffer *between* the qdisc and
the network card.

So. I'm sure no-one is going to accept this patch as-is, which is why
I'm being lazy and just sending diff -u output against ubuntu's 2.6.32
lucid kernel. Some thoughts on improvements (probably multiple patches
worth):
  -- Presumably people will want some kind of more rigorous testing to
make sure that this doesn't cause excessive CPU usage or loss of
throughput in higher-bandwidth contexts? (Not that I'm seeing any red
flags in the above output.)
  -- Some sort of tuning knob, via /sys or ethtool or whatever? Though
more sensible defaults would be better still!
  -- Heck, the driver has (or could have) a reasonable idea of how
long it should take for the current DMA ringbuffer contents to drain,
and refuse to queue more than X ms of data. That should Just Work,
right?
  -- Maybe even some way to exploit the multiple transmit queues (I
can't figure out what these are even for -- 'tc -s class show dev
wlan0' seems to indicate that only one even gets used, at least in my
old kernel?) along with QoS to allow a large DMA ringbuffer for
high-throughput data and a small DMA ringbuffer for latency-sensitive
data?

It'd also be nice for debugging this sort of thing if the old
.get_tx_stats functionality were resurrected and exposed to userspace
somehow.

I'm not currently up enough on my kernel hacking to do any of this, at
least in reasonable time. But I'm hoping that a one-character patch
that, in real world situations, speeds up interactive network use by a
factor of ~140, will maybe catch someone's attention?

Thoughts?

-- Nathaniel

--- iwl-tx.c~	2010-12-10 08:12:23.000000000 -0800
+++ iwl-tx.c	2010-12-10 20:38:38.000000000 -0800
@@ -287,7 +287,7 @@ static int iwl_queue_init(struct iwl_pri
 	if (q->low_mark < 4)
 		q->low_mark = 4;

-	q->high_mark = q->n_window / 8;
+        q->high_mark = q->n_window - 8;
 	if (q->high_mark < 2)
 		q->high_mark = 2;

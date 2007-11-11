Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hydra.gt.owl.de ([195.71.99.218]:60542 "EHLO hydra.gt.owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbXKKKwV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Nov 2007 05:52:21 -0500
Date: Sun, 11 Nov 2007 11:23:15 +0100
From: Florian Lohoff <flo@rfc822.org>
To: linux-wireless@vger.kernel.org
Subject: rt2x00/rt2500 PCI unresponsive / sluggish response
Message-ID: <20071111102315.GC10486@paradigm.rfc822.org> (sfid-20071111_105226_675313_56109FC8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,
i today tried the in tree rt2x00 driver the first time and it immediatly
felt a little sluggish. It sometimes feels a little as the driver is
actually not using interrupts but rather polls at HZ rate or something.
I can actually see the device generating interrupts in /proc/interrupts
but still.

Machine is a 2Ghz P4 with an PCI Ralink RT2500:

0000:01:02.0 Network controller: RaLink Ralink RT2500 802.11 Cardbus Reference Card (rev 01)
        Subsystem: SiteCom Europe BV: Unknown device 9073
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, Cache Line Size: 0x20 (128 bytes)
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at dfdfe000 (32-bit, non-prefetchable) [size=8K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Kernel is current git ecd744eec3aa8bbc949ec04ed3fbf7ecb2958a0e. 
NonTickless, HZ is 1000, HiresTimes enabled, no CPUFREQ 

While running an "find /" via ssh the output comes in and a second terminal shows this:

64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=7 ttl=64 time=3.02 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=8 ttl=64 time=3.01 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=9 ttl=64 time=2.87 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=10 ttl=64 time=2.90 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=11 ttl=64 time=46.5 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=12 ttl=64 time=2.86 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=13 ttl=64 time=13675 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=14 ttl=64 time=12749 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=15 ttl=64 time=11853 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=16 ttl=64 time=10949 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=17 ttl=64 time=10024 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=18 ttl=64 time=9095 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=19 ttl=64 time=8161 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=20 ttl=64 time=7620 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=21 ttl=64 time=6694 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=22 ttl=64 time=5753 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=23 ttl=64 time=4830 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=24 ttl=64 time=3893 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=25 ttl=64 time=2962 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=26 ttl=64 time=2070 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=27 ttl=64 time=1342 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=28 ttl=64 time=423 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=29 ttl=64 time=2.89 ms
64 bytes from heisenberg.domain (192.168.251.215): icmp_seq=30 ttl=64 time=2.89 ms

Flo
-- 
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little 
          security shall soon have neither - Benjamin Franklin

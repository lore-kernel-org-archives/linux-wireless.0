Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:32978 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710Ab2GINxk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 09:53:40 -0400
Received: from bottleman (helo=localhost)
	by icf.org.ru with local-esmtp (Exim 4.75)
	(envelope-from <bottleman@icf.org.ru>)
	id 1SoDhR-0004V4-31
	for linux-wireless@vger.kernel.org; Mon, 09 Jul 2012 17:08:25 +0400
Date: Mon, 9 Jul 2012 17:08:25 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: linux-wireless@vger.kernel.org
Subject: strange regression with 802.11s and bridge
Message-ID: <alpine.DEB.2.02.1207091641110.9539@icf.org.ru> (sfid-20120709_155345_653451_5D6A62F1)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-1902124286-1341839305=:9539"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-1902124286-1341839305=:9539
Content-Type: TEXT/PLAIN; format=flowed; charset=KOI8-R
Content-Transfer-Encoding: 8BIT


Hi, i have strange regression with compat-wireless 3.5-rc5-1-snpc and 
also try compat-wireless-2012-07-03 and get same behaviour.

i have the following scheme:

r1 - gateway with dhcp server and NAT.
mp1 - meshpoint with bridge mp1 and eth1 connected to r1
mp2 - meshpoint associated with mp1.

[r1 eth0(192.168.2.1/24)] <--(wired)--> [br0(192.168.2.2) with eth1 and mp1 in br0 mp1] <--wireless-->
[mp2 get ip from dhcp server on r1, in thate case its get 192.168.2.153]

with this scheme dhcp is working and mp2 getting ip from server, icmp is working, i can ping 
r1(192.168.2.1) from mp2, but tcp not working betwen mp2 and r1, get timeout on any trying to connect
to any services on r1 or to internet behind r1, but tcp work fine between mp2<->mp1 and mp1<->r1.
i attach dumps from mp2 wireless interface dump-mp2.pcap and from eth0 on r1 called dump-dhcp-server.pcap
with icmp pings from mp2 to r1 and trying to ssh from mp2 to r1.

also i verify bridging with wired interface on mp1 and with ap interface - its work with same version
of compat-wireless, seems not work only in case if interface is meshpoint type. also i try with stock 
3.2.22 and same scheme with meshpoint working fine without problems.

additional info from mp2:

root@prototype:~# iw dev mp1 info
Interface mp1
     ifindex 7
     type mesh point
     wiphy 0
     channel 7 (2442 MHz) HT40+

iw dev mp1 get mesh_param
mesh_retry_timeout = 100 milliseconds
mesh_confirm_timeout = 100 milliseconds
mesh_holding_timeout = 100 milliseconds
mesh_max_peer_links = 32
mesh_max_retries = 3
mesh_ttl = 31
mesh_element_ttl = 31
mesh_auto_open_plinks = 1
mesh_hwmp_max_preq_retries = 4
mesh_path_refresh_time = 1000 milliseconds
mesh_min_discovery_timeout = 100 milliseconds
mesh_hwmp_active_path_timeout = 5000 TUs
mesh_hwmp_preq_min_interval = 10 TUs
mesh_hwmp_net_diameter_traversal_time = 50 TUs
mesh_hwmp_rootmode = 0
mesh_hwmp_rann_interval = 5000
mesh_gate_announcements = 0
mesh_fwding = 1
mesh_sync_offset_max_neighor = 50
mesh_rssi_threshold = 0 dBm

iw dev mp0 station dump
Station 00:21:a4:35:36:24 (on mp1)
inactive time:	10 ms
rx bytes:	38605
rx packets:	618
tx bytes:	1107
tx packets:	10
tx retries:	0
tx failed:	0
signal:  	-35 [-35, -55] dBm
signal avg:	-34 [-34, -52] dBm
Toffset:	15993000 us
tx bitrate:	1.0 MBit/s
rx bitrate:	1.0 MBit/s
mesh llid:	40565
mesh plid:	64186
mesh plink:	ESTAB
authorized:	yes
authenticated:	yes
preamble:	long
WMM/WME:	yes
MFP:		no
TDLS peer:	no


brctl showstp br0
br0
  bridge id		8000.00026fb894d4
  designated root	8000.00026fb894d4
  root port		   0			path cost		   0
  max age		  19.99			bridge max age		  19.99
  hello time		   1.99			bridge hello time	   1.99
  forward delay		  14.99			bridge forward delay	  14.99
  ageing time		 299.95
  hello timer		   1.60			tcn timer		   0.00
  topology change timer	   0.00			gc timer		  17.68
  flags


eth1 (1)
  port id		8001			state		     forwarding
  designated root	8000.00026fb894d4	path cost		 100
  designated bridge	8000.00026fb894d4	message age timer	   0.00
  designated port	8001			forward delay timer	   0.00
  designated cost	   0			hold timer		   0.59
  flags

mp1 (2)
  port id		8002			state		     forwarding
  designated root	8000.00026fb894d4	path cost		 100
  designated bridge	8000.00026fb894d4	message age timer	   0.00
  designated port	8002			forward delay timer	   0.00
  designated cost	   0			hold timer		   0.59
  flags

ifconfig br0
br0       Link encap:Ethernet  HWaddr 00:02:6f:b8:94:d4
           inet addr:192.168.2.2  Bcast:192.168.2.255  Mask:255.255.255.0
           inet6 addr: fe80::202:6fff:feb8:94d4/64 Scope:Link
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:6185 errors:0 dropped:0 overruns:0 frame:0
           TX packets:8140 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:0
           RX bytes:1163015 (1.1 MiB)  TX bytes:719516 (702.6 KiB)




C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-1902124286-1341839305=:9539--

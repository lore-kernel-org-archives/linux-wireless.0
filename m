Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:39205 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab2GJHLv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 03:11:51 -0400
Received: from bottleman (helo=localhost)
	by icf.org.ru with local-esmtp (Exim 4.75)
	(envelope-from <bottleman@icf.org.ru>)
	id 1SoUbu-00061A-An
	for linux-wireless@vger.kernel.org; Tue, 10 Jul 2012 11:11:50 +0400
Date: Tue, 10 Jul 2012 11:11:50 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: linux-wireless@vger.kernel.org
Subject: Re: strange regression with 802.11s and bridge
In-Reply-To: <alpine.DEB.2.02.1207091641110.9539@icf.org.ru>
Message-ID: <alpine.DEB.2.02.1207101111400.22261@icf.org.ru> (sfid-20120710_091157_649745_00C612C8)
References: <alpine.DEB.2.02.1207091641110.9539@icf.org.ru>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-111077414-1341904310=:22261"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-111077414-1341904310=:22261
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2012-07-09 17:08 +0400, Georgiewskiy Yuriy wrote linux-wireless@vger.ker...:

seems dumps don't fit in list by size, can be found here - 
ftp://icf.org.ru/pub/log/802.11s/dump802.11s.tar.bz2

GY>
GY>Hi, i have strange regression with compat-wireless 3.5-rc5-1-snpc and also
GY>try compat-wireless-2012-07-03 and get same behaviour.
GY>
GY>i have the following scheme:
GY>
GY>r1 - gateway with dhcp server and NAT.
GY>mp1 - meshpoint with bridge mp1 and eth1 connected to r1
GY>mp2 - meshpoint associated with mp1.
GY>
GY>[r1 eth0(192.168.2.1/24)] <--(wired)--> [br0(192.168.2.2) with eth1 and mp1
GY>in br0 mp1] <--wireless-->
GY>[mp2 get ip from dhcp server on r1, in thate case its get 192.168.2.153]
GY>
GY>with this scheme dhcp is working and mp2 getting ip from server, icmp is
GY>working, i can ping r1(192.168.2.1) from mp2, but tcp not working betwen mp2
GY>and r1, get timeout on any trying to connect
GY>to any services on r1 or to internet behind r1, but tcp work fine between
GY>mp2<->mp1 and mp1<->r1.
GY>i attach dumps from mp2 wireless interface dump-mp2.pcap and from eth0 on r1
GY>called dump-dhcp-server.pcap
GY>with icmp pings from mp2 to r1 and trying to ssh from mp2 to r1.
GY>
GY>also i verify bridging with wired interface on mp1 and with ap interface -
GY>its work with same version
GY>of compat-wireless, seems not work only in case if interface is meshpoint
GY>type. also i try with stock 3.2.22 and same scheme with meshpoint working
GY>fine without problems.
GY>
GY>additional info from mp2:
GY>
GY>root@prototype:~# iw dev mp1 info
GY>Interface mp1
GY>    ifindex 7
GY>    type mesh point
GY>    wiphy 0
GY>    channel 7 (2442 MHz) HT40+
GY>
GY>iw dev mp1 get mesh_param
GY>mesh_retry_timeout = 100 milliseconds
GY>mesh_confirm_timeout = 100 milliseconds
GY>mesh_holding_timeout = 100 milliseconds
GY>mesh_max_peer_links = 32
GY>mesh_max_retries = 3
GY>mesh_ttl = 31
GY>mesh_element_ttl = 31
GY>mesh_auto_open_plinks = 1
GY>mesh_hwmp_max_preq_retries = 4
GY>mesh_path_refresh_time = 1000 milliseconds
GY>mesh_min_discovery_timeout = 100 milliseconds
GY>mesh_hwmp_active_path_timeout = 5000 TUs
GY>mesh_hwmp_preq_min_interval = 10 TUs
GY>mesh_hwmp_net_diameter_traversal_time = 50 TUs
GY>mesh_hwmp_rootmode = 0
GY>mesh_hwmp_rann_interval = 5000
GY>mesh_gate_announcements = 0
GY>mesh_fwding = 1
GY>mesh_sync_offset_max_neighor = 50
GY>mesh_rssi_threshold = 0 dBm
GY>
GY>iw dev mp0 station dump
GY>Station 00:21:a4:35:36:24 (on mp1)
GY>inactive time:	10 ms
GY>rx bytes:	38605
GY>rx packets:	618
GY>tx bytes:	1107
GY>tx packets:	10
GY>tx retries:	0
GY>tx failed:	0
GY>signal:  	-35 [-35, -55] dBm
GY>signal avg:	-34 [-34, -52] dBm
GY>Toffset:	15993000 us
GY>tx bitrate:	1.0 MBit/s
GY>rx bitrate:	1.0 MBit/s
GY>mesh llid:	40565
GY>mesh plid:	64186
GY>mesh plink:	ESTAB
GY>authorized:	yes
GY>authenticated:	yes
GY>preamble:	long
GY>WMM/WME:	yes
GY>MFP:		no
GY>TDLS peer:	no
GY>
GY>
GY>brctl showstp br0
GY>br0
GY> bridge id		8000.00026fb894d4
GY> designated root	8000.00026fb894d4
GY> root port		   0			path cost		   0
GY> max age		  19.99			bridge max age
GY>19.99
GY> hello time		   1.99			bridge hello time
GY>1.99
GY> forward delay		  14.99			bridge forward delay
GY>14.99
GY> ageing time		 299.95
GY> hello timer		   1.60			tcn timer
GY>0.00
GY> topology change timer	   0.00			gc timer
GY>17.68
GY> flags
GY>
GY>
GY>eth1 (1)
GY> port id		8001			state
GY>forwarding
GY> designated root	8000.00026fb894d4	path cost		 100
GY> designated bridge	8000.00026fb894d4	message age timer
GY>0.00
GY> designated port	8001			forward delay timer
GY>0.00
GY> designated cost	   0			hold timer
GY>0.59
GY> flags
GY>
GY>mp1 (2)
GY> port id		8002			state
GY>forwarding
GY> designated root	8000.00026fb894d4	path cost		 100
GY> designated bridge	8000.00026fb894d4	message age timer
GY>0.00
GY> designated port	8002			forward delay timer
GY>0.00
GY> designated cost	   0			hold timer
GY>0.59
GY> flags
GY>
GY>ifconfig br0
GY>br0       Link encap:Ethernet  HWaddr 00:02:6f:b8:94:d4
GY>          inet addr:192.168.2.2  Bcast:192.168.2.255  Mask:255.255.255.0
GY>          inet6 addr: fe80::202:6fff:feb8:94d4/64 Scope:Link
GY>          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
GY>          RX packets:6185 errors:0 dropped:0 overruns:0 frame:0
GY>          TX packets:8140 errors:0 dropped:0 overruns:0 carrier:0
GY>          collisions:0 txqueuelen:0
GY>          RX bytes:1163015 (1.1 MiB)  TX bytes:719516 (702.6 KiB)
GY>
GY>
GY>
GY>
GY>C уважением                       With Best Regards
GY>Георгиевский Юрий.                Georgiewskiy Yuriy
GY>+7 4872 711666                    +7 4872 711666
GY>факс +7 4872 711143               fax +7 4872 711143
GY>Компания ООО "Ай Ти Сервис"       IT Service Ltd
GY>http://nkoort.ru                  http://nkoort.ru
GY>JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
GY>YG129-RIPE                        YG129-RIPE

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-111077414-1341904310=:22261--

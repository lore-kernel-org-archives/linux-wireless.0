Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:51141 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaHaQiq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Aug 2014 12:38:46 -0400
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.82 #2)
	id 1XO89M-0001eq-0K
	for linux-wireless@vger.kernel.org; Sun, 31 Aug 2014 18:38:44 +0200
Received: from localhost ([::1]:51111 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.82 #2)
	id 1XO89L-0000Aj-SV
	for linux-wireless@vger.kernel.org; Sun, 31 Aug 2014 18:38:43 +0200
Received: from mx13.freenet.de ([195.4.92.23]:55094)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.82 #2)
	id 1XO86u-0005hM-Sx
	for linux-wireless@vger.kernel.org; Sun, 31 Aug 2014 18:36:12 +0200
Received: from p4fde051b.dip0.t-ipconnect.de ([79.222.5.27]:41549 helo=mail.maya.org)
	by mx13.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256) (port 587) (Exim 4.82 #2)
	id 1XO86u-0004ta-Je
	for linux-wireless@vger.kernel.org; Sun, 31 Aug 2014 18:36:12 +0200
Message-ID: <54034EF1.6040407@maya.org> (sfid-20140831_183855_736406_F08B96F1)
Date: Sun, 31 Aug 2014 18:36:01 +0200
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>, users@rt2x00.serialmonkey.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] MediaTek Inc. MT7601U Wireless Adapter
References: <53FCC55B.90705@gmail.com> <20140826182849.GE30445@tuxdriver.com>	<53FD7BFA.1040304@maya.org> <20140827135550.GD15173@tuxdriver.com>	<53FE9920.2040702@gmail.com> <5402B519.1080002@gmail.com>
In-Reply-To: <5402B519.1080002@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

poma wrote:
> 
> A new patch[1] mainly based on patches at 
> https://github.com/ashaffer/rt3573sta
> and several network throughput tests via the Iperf.
> Tested with kernels:
> - 3.15.10-200.fc20.x86_64
> - 3.16.1-301.fc21.x86_64
> - 3.17.0-0.rc2.git3.1.fc22.x86_64
> - 3.16.1-301.fc21.i686
> - 3.17.0-0.rc2.git3.1.fc22.i686
> 
> <Proximity>
> Wi-Fi <~20cm LOS~> AP(Wi-Fi <-bridge-> 100Mbit switch) <-> Ethernet
> 
> <AP>
> # iwconfig ra0
> ra0       RTWIFI SoftAP  ESSID:"Geppetto"  
>           Mode:Managed  Channel=13  Access Point: 00:22:44:66:88:aa   
>           Bit Rate=150 Mb/s   
> </AP>
>           
> <Wi-Fi>
> $ iwconfig ra0 
> ra0       Ralink STA  ESSID:"Geppetto"  Nickname:"MT7601STA"
>           Mode:Managed  Frequency=2.472 GHz  Access Point: 00:22:44:66:88:aa   
>           Bit Rate=150 Mb/s   
>           RTS thr:off   Fragment thr:off
>           Link Quality=100/100  Signal level:-22 dBm  Noise level:-53 dBm
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:0   Missed beacon:0
> </Wi-Fi>
> 
> <Ethernet>
> $ ifconfig bridge0
> bridge0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
>         inet 192.168.2.2  netmask 255.255.255.0  broadcast 192.168.2.255
>         ether 00:12:34:56:78:90  txqueuelen 0  (Ethernet)
>         RX errors 0  dropped 0  overruns 0  frame 0
>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
> </Ethernet>
> 
> <Ethernet-TCP>
> $ iperf -s -i 1
> ------------------------------------------------------------
> Server listening on TCP port 5001
> TCP window size: 85.3 KByte (default)
> ------------------------------------------------------------
> [  4] local 192.168.2.2 port 5001 connected with 192.168.2.36 port 58536
> [ ID] Interval       Transfer     Bandwidth
> [  4]  0.0- 1.0 sec  10.6 MBytes  88.9 Mbits/sec
> [  4]  1.0- 2.0 sec  11.2 MBytes  94.1 Mbits/sec
> [  4]  2.0- 3.0 sec  11.2 MBytes  94.1 Mbits/sec
> [  4]  3.0- 4.0 sec  11.2 MBytes  94.1 Mbits/sec
> [  4]  4.0- 5.0 sec  11.2 MBytes  94.1 Mbits/sec
> [  4]  5.0- 6.0 sec  11.2 MBytes  94.1 Mbits/sec
> [  4]  6.0- 7.0 sec  11.2 MBytes  94.1 Mbits/sec
> [  4]  7.0- 8.0 sec  11.2 MBytes  94.1 Mbits/sec
> [  4]  8.0- 9.0 sec  11.2 MBytes  94.1 Mbits/sec
> [  4]  9.0-10.0 sec  11.2 MBytes  94.1 Mbits/sec
> [  4]  0.0-10.1 sec   113 MBytes  93.6 Mbits/sec
> </Ethernet-TCP>

...

Thanks for providing test results. With respect to the bottleneck fast
ethernet switch in between and that it is most probably a 1x1:1 mimo
config according[1], they are fine!

The 64bit patch you attached is fine for use with tunneling, like vxlan,
too!


Regards,
Andreas

[1] (one line)
https://wikidevi.com/wiki/Special:Ask?title=Special:Ask&q=[[Chip1+model::~MT7601U*]]&po=?Interface%250D%250A?Form+factor=FF%250D%250A?Interface+connector+type=USB+conn.%250D%250A?FCC+ID%250D%250A?Manuf%250D%250A?Manuf+product+model=Manuf.+mdl%250D%250A?Vendor+ID%250D%250A?Device+ID%250D%250A?Chip1+model%250D%250A?Supported+802dot11+protocols=PHY+modes%250D%250A?MIMO+config%250D%250A?OUI%250D%250A?Estimated+year+of+release=Est.+year&eq=yes&p[format]=broadtable&order[0]=ASC&sort_num=&order_num=ASC&p[limit]=500&p[offset]=&p[link]=all&p[sort]=&p[headers]=show&p[mainlabel]=&p[intro]=&p[outro]=&p[searchlabel]=…+further+results&p[default]=&p[class]=sortable+wikitable+smwtable


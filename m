Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jubileegroup.co.uk ([217.147.177.250]:48761 "EHLO
	mail.jubileegroup.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2HRONS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2012 10:13:18 -0400
Received: from mail5.jubileegroup.co.uk (localhost [127.0.0.1])
	by mail5.jubileegroup.co.uk (8.14.5/8.14.5) with ESMTP id q7IE4UsY031187
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sat, 18 Aug 2012 15:04:30 +0100
Received: from localhost (ged@localhost)
	by mail5.jubileegroup.co.uk (8.14.5/8.14.3/Submit) with ESMTP id q7IE4TO7031184
	for <linux-wireless@vger.kernel.org>; Sat, 18 Aug 2012 15:04:29 +0100
Date: Sat, 18 Aug 2012 15:04:29 +0100 (BST)
From: "G.W. Haywood" <ged@jubileegroup.co.uk>
To: linux-wireless@vger.kernel.org
Subject: Wireless link dies under heavy load.
Message-ID: <Pine.LNX.4.64.1208181339020.29799@mail5.jubileegroup.co.uk> (sfid-20120818_161323_261056_DE0AEB6B)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

I believe that this may be my first post to this list.  If it isn't,
it's certainly my first post in a good few years.

Since at least 2005 I have run a number of Linksys wireless routers,
mostly WRT54GSv1.1, which I flashed with OpenWRT way back when I first
started to use them.  Apart from a couple of failed power supplies,
they have been very reliable on 24/7 links over distances of anywhere
from under fifty yards to over three miles.  A couple of the routers
are perched on radio masts thirty metres high with no more protection
from the elements than a plastic lunch box fitted with a drain hole.

As a result of what I can only describe as a temporary loss of mental
competence, recently I decided to upgrade the firmware in four of the
routers.  Result, misery.

Firstly I installed OpenWRT 'Backfire' version 10.03.1 with all the
routers configured as access points with WDS.  The wireless links
would come up fine but then die under load.  Changing configuration,
encryption, link type and anything else that I coudl think of did not
improve the performance.  Discovering that this problem had been known
for at least two years, I chipped in on this thread, in which someone
claims to have found a workaround:

https://dev.openwrt.org/ticket/7552

The claimed workaround is this command (on both ends of any link):

root@OpenWrt:~# iw dev wlan0 set bitrates legacy-2.4 6 9 12 18 24 36 48 54

I tested the fix on OpenWRT 10.03.1 and found that it was ineffective.
I posted this experience in the thread and was asked to repeat my test
using OpenWRT 'trunk'.  Unfortunately time was against me so in sheer
desperation I secondly reflashed the routers with 'Tomato' firmware.
The wireless links would then happily sustain continuous heavy loads.

Unfortunately Tomato does not allow some flexibility that I need, so I
cannot continue to use it.

Thirdly, yesterday I built and installed OpenWRT 'trunk' on two of the
routers.  There seems to be an unrelated problem where a client will
associate with an access point for a couple of tens of milliseconds
and then promptly disassociate, but I believe that is a known bug that
has now been fixed.  Operating two routers in ad-hoc mode, under load
the wireless link again repeatably dies after only a few seconds and
must be restarted manually.

In the thread linked above Florian asked that this problem be posted
to the Linux Wireless Development mailing list.  Here it is.  I think
that the drivers of concern are b43 and b43legacy.  A list of all the
kernel modules loaded is given below.

Although as you'll have gathered I am no stranger to building software
I am inexperienced in building software for wireless routers.  However
in an effort to sove this problem I am happy to provide any further
information which you may need, and to experiment if necessary on the
routers here as and when time and resources permit.  I am aware that
there is relatively little technical detail in this message but there
should at least enough to repeat my experience should anyone here be
motivated to try it and have access to the equipment.

root@OpenWrt:/etc/config# uname -a
Linux OpenWrt 3.3.8 #1 Fri Aug 17 14:41:45 BST 2012 mips GNU/Linux
root@OpenWrt:/etc/config# cat /proc/cpuinfo 
system type             : Broadcom BCM47XX
processor               : 0
cpu model               : Broadcom BMIPS3300 V0.7
BogoMIPS                : 213.50
wait instruction        : yes
microsecond timers      : yes
tlb_entries             : 32
extra interrupt vector  : yes
hardware watchpoint     : no
ASEs implemented        :
shadow register sets    : 1
kscratch registers      : 0
core                    : 0
VCED exceptions         : not available
VCEI exceptions         : not available

root@OpenWrt:/etc/config# lsmod
Module                  Size  Used by    Tainted: G 
nf_nat_irc               848  0 
nf_conntrack_irc        2512  1 nf_nat_irc
nf_nat_ftp              1008  0 
nf_conntrack_ftp        4544  1 nf_nat_ftp
ipt_MASQUERADE           976  0 
iptable_nat             2128  0 
nf_nat                 10784  4 nf_nat_irc,nf_nat_ftp,ipt_MASQUERADE,iptable_nat
pppoe                   8816  0 
xt_conntrack            2128  0 
xt_CT                   1568  0 
xt_NOTRACK               576  0 
iptable_raw              560  0 
xt_state                 608  0 
nf_conntrack_ipv4       4016  3 iptable_nat,nf_nat
nf_defrag_ipv4           624  1 nf_conntrack_ipv4
nf_conntrack           41424 12 nf_nat_irc,nf_conntrack_irc,nf_nat_ftp,nf_conntrack_ftp,ipt_MASQUERADE,iptable_nat,nf_nat,xt_conntrack,xt_CT,xt_NOTRACK,xt_state,nf_conntrack_ipv4
pppox                   1152  1 pppoe
ipt_REJECT              1744  0 
xt_TCPMSS               1904  0 
ipt_LOG                 6432  0 
xt_comment               400  0 
xt_multiport            1136  0 
xt_mac                   528  0 
xt_limit                1040  0 
iptable_mangle           816  0 
iptable_filter           592  0 
ip_tables               8896  4 iptable_nat,iptable_raw,iptable_mangle,iptable_filter
xt_tcpudp               1664  0 
x_tables                9936 18 ipt_MASQUERADE,iptable_nat,xt_conntrack,xt_CT,xt_NOTRACK,iptable_raw,xt_state,ipt_REJECT,xt_TCPMSS,ipt_LOG,xt_comment,xt_multiport,xt_mac,xt_limit,iptable_mangle,iptable_filter,ip_tables,xt_tcpudp
ppp_async               8128  0 
ppp_generic            20368  3 pppoe,pppox,ppp_async
slhc                    4736  1 ppp_generic
b43legacy              90272  0 
b43                   292800  0 
mac80211              269376  2 b43legacy,b43
crc_ccitt                944  1 ppp_async
cfg80211              154784  3 b43legacy,b43,mac80211
compat                  3376  4 b43legacy,b43,mac80211,cfg80211
arc4                     768  2 
aes_generic            30592  0 
crypto_algapi           9408  2 arc4,aes_generic
switch_robo             3632  0 
switch_core             4672  1 switch_robo
diag                    7584  0

root@OpenWrt:/etc/config# cat wireless 
config wifi-device  radio0
         option type     mac80211
         option country  us
         option channel  6
         option macaddr  'x'
         option hwmode   11g

config wifi-iface
         option device   radio0
         option mode     adhoc
         option ssid     'x'
         option encryption WEP
         option key      'x'

--

73,
Ged.

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wp071.webpack.hosteurope.de ([80.237.132.78]:59151 "EHLO
	wp071.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750843Ab3HKVVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Aug 2013 17:21:35 -0400
Message-ID: <5207FC2A.4040207@skbx.de> (sfid-20130811_232139_174793_0D65445B)
Date: Sun, 11 Aug 2013 23:03:38 +0200
From: "Volker von Hoesslin @ SKBX Systems" <hoesslin.v@skbx.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 80211s with DFS
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi mailinglist!

i have a real big problem! i'm trying to implement a wireless-mesh 
(80211s) with openWRT (current trunk) over 11a (5GHz) with "authSAE" for 
outdoor. all works fine, mesh is runnning and all fine. but now, i'm at 
germany and for the outdoor use, i have to use the channel 100-140 with 
DFS & TPC. so the mesh implementation dont work in this channel? with 
this error:

authSAE config:
#######################################################
authsae:
{
  sae:
   {
     debug = 480;
     password = "foobar";
     group = [19, 26, 21, 25, 20];
     blacklist = 5;
     thresh = 5;
     lifetime = 3600;
   };
  meshd:
   {
     meshid = "foobar";
     interface = "mesh0";
     band = "11a";
     channel = 104;
     htmode = "ht20";
     mcast-rate = 6;
     debug = 1;
   };
};
#######################################################

starting mesh with "authSAE":

#######################################################
# meshd-nl80211 -c /etc/authsae.cfg
----------
nlcfg rates hexdump
00 3c 00 5a 00 78 00 b4 00 f0 01 68 01 e0 02 1c
----------

----------
mgtk:  hexdump
ce 5a b3 fc 8b 76 db 62 11 c9 58 33 fa 0c 26 88
----------

----------
Fixed Information Elements in this STA hexdump
01 08 8c 12 98 24 b0 48 60 6c
----------

meshd: Starting mesh with mesh id = foobar
----------
basic rates: hexdump
8c 98 b0
----------

joining mesh foobar on freq 3443784, mode 0
nlerror, cmd 68, seq 1376254403: Invalid argument
#######################################################

and this is without "authSAE":

#######################################################
# iw mesh0 set channel 104
# iw mesh0 mesh join foobar
command failed: Invalid argument (-22)
#######################################################

but this is working with a non-DFS channel 44:

#######################################################
# iw mesh0 set channel 44
# iw mesh0 mesh join hackewrt
[21044.240000] IPv6: ADDRCONF(NETDEV_CHANGE): mesh0: link becomes ready
[21044.240000] mesh-br: port 1(vlan11) entered forwarding state
[21044.250000] mesh-br: port 1(vlan11) entered forwarding state
[21044.260000] IPv6: ADDRCONF(NETDEV_CHANGE): vlan11: link becomes ready
[21044.260000] coova-br: port 1(vlan12) entered forwarding state
[21044.270000] coova-br: port 1(vlan12) entered forwarding state
[21044.280000] IPv6: ADDRCONF(NETDEV_CHANGE): vlan12: link becomes ready
root@6470028F55A2:~#

#######################################################


i think this error is from the "netlink lib(libnl genl)"...

if i use a channel without DFS, it works fine (in germany channel like 
36-48)... so how it is possible to use mesh (80211s) with DFS ?

big thx for answer,
   volker...


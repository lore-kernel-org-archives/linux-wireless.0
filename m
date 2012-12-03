Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:34511 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2LCQde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 11:33:34 -0500
Received: from webmail.3eti.com (rockmx01.rock.corp [192.168.200.4]) by mail.ultra-3eti.com with ESMTP id EHQ0cLFiHf7a6x2p (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2012 11:33:32 -0500 (EST)
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: help: 802.11s bad performance with 802.11n enabled
Date: Mon, 3 Dec 2012 16:33:30 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C125E7@RockMX01.rock.corp> (sfid-20121203_173347_011221_629431EC)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A 4th problem is AES-CCM pairwise key complains about "packet replay". 
All keys are good, mpaths are good. But ping does not reply and counter in /debugfs/ieee80211/phy0/keys/[key-num]/replays keeps going up.

I have seen such problem many times when running 802.11s traffic. 


-----Original Message-----
From: Chaoxing Lin 
Sent: Monday, December 03, 2012 9:38 AM
To: 'linux-wireless@vger.kernel.org'
Subject: RE: help: 802.11s bad performance with 802.11n enabled

After a lot of experiments, here are various problems observed.

1. The "Fail to stop Tx DMA" related issue plays a role. But not the major part. It accounts for about 3% of packet loss in my testbed.
Is anyone looking at this issue? This issue is now very easy to recreate.

2. Security Key for peer link and mesh path messed up

For example, in one case,
Device A cannot ping device B but it can ping device C. And it is seen that telnet from device A to device C and from device C it can ping device B.
This means device A actually can reach device B. But user has to do it manually (through a third device)

Below is a "reachable graph" in one of the real scenario.

147 ----> 115
    ----> 111 ------>103
              ------>104
              ------>113
              ------>115

Device 147 can only ping 115 and 111, although its mpath table says it has direct mpath to every node. 
But a telnet session from 147 to 111 can ping the rest devices 103, 104, 113, 115.

Further analysis peer link between 147 and 104 reveals below.

147 has peer link to 104 in "ESTAB" and has all 3 keys (CCM pairwise, CMAC group key, CCM group key) installed for peer 104.
But 104 has peer link to 147 in "LISTEN" and it does not have any keys installed for 147.
That is to say, the peer link between 147 and 104 is bad. The worse thing is the mpath table on 147 keep saying the path to 104 is active. So all packets to 104 are sent to this peer link, but could not be decrypted on the other end.

I run meshd-nl80211 compiled from auth-sae for the encryption. Does anyone know what's the problem here? Is this a protocol defect, e.g. failure to cover certain error condition? Or is it auth-sae/kernel implementation bug?


3. 802.11n packet aggregation plays a big role in 802.11s mesh network in-stability

For experiment, I changed ath9k driver to disable 802.11n packet aggregation. The network becomes much better.
It's as stable as running 802.11a only mode.
So it seems that the aggregation plays a big role in in-stability of 802.11s network with 802.11n.
Any one has any idea why?




-----Original Message-----
From: Chaoxing Lin
Sent: Friday, November 16, 2012 12:41 PM
To: 'linux-wireless@vger.kernel.org'
Subject: help: 802.11s bad performance with 802.11n enabled

I set up a 7 node 802.11s mesh network and try to evaluate network performance.

My first test is to evaluate packet loss.
My test utility is very simple. Do a continuous ping to all 7 nodes. And count the ping replies. The ping rate is about 10 ping requests per second to each node.

802.11a channel 40. Clean RF environment, nobody else is on this channel

When 802.11n is NOT enabled, the ping loss rate is very good. Only a few packets are lost during an overnight test.

However, when 802.11n (HT40+ or HT20) is enabled, the network is crazily unstable. The ping loss is about 30% or more to each node. 

FYI, The 802.11n itself seems to work well with 802.11s when there are only 2 nodes (standalone). I say so because I did throughput test on a 2 node mesh with channel 40 HT40+. The throughput was good. IPERF TCP throughput is about 170Mbps out of 300Mbps (2 streams).


Does anyone know what's going on?
Or anyone did 802.11s performance test and can share the test data/setup, etc?


Thanks,

Chaoxing

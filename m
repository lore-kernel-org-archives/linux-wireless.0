Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.236.10]:48578 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086Ab2LCPWU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 10:22:20 -0500
Date: Mon, 3 Dec 2012 18:45:28 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: help: 802.11s bad performance with 802.11n enabled
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp>
Message-ID: <alpine.DEB.2.02.1212031842350.27546@icf.org.ru> (sfid-20121203_162238_596007_659AEDE0)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-1783095201-1354545928=:27546"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-1783095201-1354545928=:27546
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2012-12-03 14:37 -0000, Chaoxing Lin wrote linux-wireless@vger.kernel.org:

CL>After a lot of experiments, here are various problems observed.
CL>
CL>1. The "Fail to stop Tx DMA" related issue plays a role. But not the major part. It accounts for about 3% of packet loss in my testbed.
CL>Is anyone looking at this issue? This issue is now very easy to recreate.

In my case it much more than 3%.

CL>
CL>2. Security Key for peer link and mesh path messed up
CL>
CL>For example, in one case,
CL>Device A cannot ping device B but it can ping device C. And it is seen that telnet
CL>from device A to device C and from device C it can ping device B.
CL>This means device A actually can reach device B. But user has to do it manually
CL>(through a third device)
CL>
CL>Below is a "reachable graph" in one of the real scenario.
CL>
CL>147 ----> 115
CL>    ----> 111 ------>103
CL>              ------>104
CL>              ------>113
CL>              ------>115
CL>
CL>Device 147 can only ping 115 and 111, although its mpath table says it has direct mpath to every node. 
CL>But a telnet session from 147 to 111 can ping the rest devices 103, 104, 113, 115.
CL>
CL>Further analysis peer link between 147 and 104 reveals below.
CL>
CL>147 has peer link to 104 in "ESTAB" and has all 3 keys (CCM pairwise, CMAC group key, CCM group key) installed for peer 104.
CL>But 104 has peer link to 147 in "LISTEN" and it does not have any keys installed for 147.
CL>That is to say, the peer link between 147 and 104 is bad. The worse thing is the mpath table on 147 keep saying the path to 104 is active. So all packets to 104 are sent to this peer link, but could not be decrypted on the other end.
CL>
CL>I run meshd-nl80211 compiled from auth-sae for the encryption. Does anyone know what's the problem here? Is this a protocol defect, e.g. failure to cover certain error condition? Or is it auth-sae/kernel implementation bug?
CL>
CL>
CL>3. 802.11n packet aggregation plays a big role in 802.11s mesh network in-stability
CL>
CL>For experiment, I changed ath9k driver to disable 802.11n packet aggregation. The network becomes much better.
CL>It's as stable as running 802.11a only mode.
CL>So it seems that the aggregation plays a big role in in-stability of 802.11s network with 802.11n.
CL>Any one has any idea why?

Can you post a patch? i want test this too.

CL>
CL>
CL>
CL>-----Original Message-----
CL>From: Chaoxing Lin 
CL>Sent: Friday, November 16, 2012 12:41 PM
CL>To: 'linux-wireless@vger.kernel.org'
CL>Subject: help: 802.11s bad performance with 802.11n enabled
CL>
CL>I set up a 7 node 802.11s mesh network and try to evaluate network performance.
CL>
CL>My first test is to evaluate packet loss.
CL>My test utility is very simple. Do a continuous ping to all 7 nodes. And count the ping replies. The ping rate is about 10 ping requests per second to each node.
CL>
CL>802.11a channel 40. Clean RF environment, nobody else is on this channel
CL>
CL>When 802.11n is NOT enabled, the ping loss rate is very good. Only a few packets are lost during an overnight test.
CL>
CL>However, when 802.11n (HT40+ or HT20) is enabled, the network is crazily unstable. The ping loss is about 30% or more to each node. 
CL>
CL>FYI, The 802.11n itself seems to work well with 802.11s when there are only 2 nodes (standalone). I say so because I did throughput test on a 2 node mesh with channel 40 HT40+. The throughput was good. IPERF TCP throughput is about 170Mbps out of 300Mbps (2 streams).
CL>
CL>
CL>Does anyone know what's going on?
CL>Or anyone did 802.11s performance test and can share the test data/setup, etc?
CL>
CL>
CL>Thanks,
CL>
CL>Chaoxing
CL>--
CL>To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
CL>the body of a message to majordomo@vger.kernel.org
CL>More majordomo info at  http://vger.kernel.org/majordomo-info.html
CL>

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-1783095201-1354545928=:27546--

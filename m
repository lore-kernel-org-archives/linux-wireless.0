Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:45327 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2LJPLl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 10:11:41 -0500
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: help: 802.11s bad performance with 802.11n enabled
Date: Mon, 10 Dec 2012 15:11:37 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C12910@RockMX01.rock.corp> (sfid-20121210_161145_361577_B58C9DFC)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp>
 <alpine.DEB.2.02.1212031842350.27546@icf.org.ru>
In-Reply-To: <alpine.DEB.2.02.1212031842350.27546@icf.org.ru>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



-----Original Message-----
From: Georgiewskiy Yuriy [mailto:bottleman@icf.org.ru] 
Sent: Monday, December 03, 2012 9:45 AM
To: Chaoxing Lin
Cc: linux-wireless@vger.kernel.org
Subject: RE: help: 802.11s bad performance with 802.11n enabled

On 2012-12-03 14:37 -0000, Chaoxing Lin wrote linux-wireless@vger.kernel.org:

CL>After a lot of experiments, here are various problems observed.
CL>
CL>1. The "Fail to stop Tx DMA" related issue plays a role. But not the major part. It accounts for about 3% of packet loss in my testbed.
CL>Is anyone looking at this issue? This issue is now very easy to recreate.

GY>>In my case it much more than 3%.

When I say 3% loss due to "Tx DMA", it's measured by eliminate other factors as much as possible (turning off aggregation, etc.) Below is the number from 3-day continuous test. During this 3-day test, "Fail to stop Tx DMA" happens once a while on various nodes.



                CLIN network activity/stability monitoring system

       Total targets: 6 Total instability monitored: 3221

192.168.5.103    ICMP Tx 5899087 Rx 5883235 Seq=846  OutOfOrder 427 Pkt loss 15852(0.27%) RTT min/avg/max = 55.0/57.9/11580.0 ms
192.168.5.104    ICMP Tx 5899087 Rx 5721023 Seq=846  OutOfOrder 121213 Pkt loss 178064(3.02%) RTT min/avg/max = 54.0/57.7/9032.0 ms
192.168.5.111    ICMP Tx 5899087 Rx 5726094 Seq=846  OutOfOrder 164950 Pkt loss 172993(2.93%) RTT min/avg/max = 54.0/59.0/9421.0 ms
192.168.5.113    ICMP Tx 5899087 Rx 5894984 Seq=846  OutOfOrder 686 Pkt loss 4103(0.07%) RTT min/avg/max = 54.0/58.0/11524.0 ms
192.168.5.115    ICMP Tx 5899087 Rx 5869967 Seq=846  OutOfOrder 66782 Pkt loss 29120(0.49%) RTT min/avg/max = 54.0/67.7/11801.0 ms
192.168.5.147    ICMP Tx 5899087 Rx 5899086 Seq=846  OutOfOrder 0 Pkt loss   1(0.00%) RTT min/avg/max = 0.0/54.0/110.0 ms



Bad Packets: 0 short pkt, 3217664 not-my-echo, 0 not-echo-reply, 0 unknown sender
  Application Starts: Thu Dec  6 13:59:58 2012
        Current Time: Mon Dec 10 08:50:34 2012


Notes: 
1. ignore the big numbers in "outoforder" column. When ICMP sequence number is about to overflow (65535), if the last few packets (e.g. ICMP sn.65535) get lost, all packets after overflow will be counted as "outoforder".
2. if anyone is interested in the test tool I used in this test, it's here
http://sites.google.com/site/ebaylinkan5709pictures/files-to-share/clinmonitor.gz
It's an executable running on any 32-bit Linux.


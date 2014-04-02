Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out03.msg.oleane.net ([62.161.7.1]:59123 "EHLO
	smtp-out03.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036AbaDBIxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 04:53:50 -0400
Received: from smtp26.msg.oleane.net (smtp26.mail.priv [172.17.20.148])
	by smtp-out03.msg.oleane.net with ESMTP id s328XbYs012114
	for <linux-wireless@vger.kernel.org>; Wed, 2 Apr 2014 10:33:37 +0200
Subject: Re: TR: [RFC] 802.11s bitrate correction in airtime metric calculation
Date: Wed, 2 Apr 2014 10:13:03 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A3190173423A@sbs2003.acksys.local> (sfid-20140402_105356_058723_78FCA226)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
From: "Cedric Debarge" <cedric.debarge@acksys.fr>
To: <devel@lists.open80211s.org>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bob and Dennis,

Thanks for your answer.

>On 3/28/2014 8:22 AM, Bob Copeland wrote:
>> Interesting -- I tried this exact thing once before, but got mixed
>> results in my testing.
>>
>> Can you share your testing strategy?

Here is my testing summary :

     __  _      |_|_|                           |_|_|      __  _
    [__]|=|--->[____°]                         [____°]<---[__]|=|
    /::/|_|                                               /::/|_|
                       .------------------.
   Mesh portal B       | Office building  |   Mesh portal A
   Fixed location      |    15m x 40m     |   Fixed location
                       |                  |
                       |                  |
                       |                  |
                       |                  |
                       |                  |
                       |                  |
                       |                  |
                       |                  |
                       |                  |
                       |                  |
                       |                  |
                       |                  |
                       |                  |
                       '------------------'
      __  _     |_|_|
     [__]|=|-->[____°]
     /::/|_|

    Mesh portal C
    Fixed location

All points are mesh portals. Signal levels are :
	- around -60dBm between A and B --> metric = 152
	- around -60dBm between B and C --> metric = 152
	- around -80dBm between A and C --> metric >> 2*152

All point are using openwrt with compat-wireless v2013-04-16.

A runs an iperf server and C an iperf client (see iperf parameters below)
iperf -c mesh_point_A_ip -b10M -i10 -t9999

During the test I monitored both mpath and minstrel stats on mesh portal C:
	- mpath (iw wlan0 mpath dump)
	- minstrel stats (rc_stats files for stations B and A)

Without my patch, I get 10 or more mpath changes per minute. When I apply it,
the number of changes drops to 1 or 2 per minute. In this particular case, it
seems to be an improvement but I haven't tested this patch in another scenario.
In order to get a fully stable link, I have to set a rssi threshold in order to
prevent C to establish any plink with A (and do the same on point A).

Cédric DEBARGE
ACKSYS R&D dpt.

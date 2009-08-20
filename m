Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:61729 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381AbZHTOPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2009 10:15:10 -0400
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0KOO001OWI9BDC60@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Thu, 20 Aug 2009 16:15:11 +0200 (CEST)
Received: from [137.226.12.123]
 (informatik-4-137-226-12-123.nn.RWTH-Aachen.DE [137.226.12.123] (may be
 forged))	by relay.rwth-aachen.de (8.13.8+Sun/8.13.8/1)
 with ESMTP id n7KEFB2L018025	for <linux-wireless@vger.kernel.org>; Thu,
 20 Aug 2009 16:15:11 +0200 (CEST)
Message-id: <4A8D5A48.5070809@nets.rwth-aachen.de>
Date: Thu, 20 Aug 2009 16:14:32 +0200
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Minstrel's definition of best throughput
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

while watching the rc_stats of minstrel, I noticed
that minstrel does not choose the rate with best throughput.
For example, I often see something like this:

rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
     1         0.8       89.1      100.0          0(  0)       1490        2257
     2         1.8       95.3      100.0          0(  0)         13          15
     5.5       4.8       95.5      100.0          0(  0)         17          22
  P 11         9.4       98.5      100.0          0(  0)       1532        2195
     6         5.4       95.6      100.0          0(  0)         28          88
     9         8.1       96.2      100.0          0(  0)        143         431
    12         8.7       78.8      100.0          0(  0)        209         814
    18        12.3       75.8      100.0          0(  0)        302        2416
    24        18.3       86.2      100.0          0(  0)       5765        9196
    36         2.6       85.2      100.0          0(  0)     736813      886517
T   48        14.7       97.4      100.0          2(  2)    3433862     4411674
 t  54         8.5       73.3      100.0          0(  0)    1488241     2180261


Why did minstrel chose the 48M rate, and not 24M for the best throughput rate?
Also "this prob" seems fishy to me, its always 100...
Another thing: I noticed that the througput field in minstrel_rate is never used?
Should I send a patch, removing it? Or does anyone remember why it was there
in the first place?


Best regards,
Arnd

P.S. runnning 2.6.31-rc6 with ath5k...




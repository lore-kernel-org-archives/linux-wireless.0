Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34023 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbbFZBX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2015 21:23:29 -0400
Received: by wicnd19 with SMTP id nd19so32453250wic.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2015 18:23:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4bd697c41f2bb66593c849246bde7b00@mail.gmail.com>
References: <CAEFj986a0b9r4qia-CFXsm_aiD8P5gLeJJqxS2NYcSjKcspLNw@mail.gmail.com>
	<4bd697c41f2bb66593c849246bde7b00@mail.gmail.com>
Date: Fri, 26 Jun 2015 09:23:28 +0800
Message-ID: <CAEFj9878gNnDViLYh+TW6GPUvJBbSn4Y=tDBmdp3NwBHymqxRg@mail.gmail.com> (sfid-20150626_032332_651785_B12A4154)
Subject: Re: [PATCH] mac80211: mesh - always do every discovery retry
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Jesse Jones <jjones@cococorp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Yes, it will cause more management packets to be sent. PREQs will flood out
> dot11MeshHWMPmaxPREQretries times and PREPs will be sent back but only along
> the best path.
>

If you have more 10 nodes, all the nodes will have to re-broadcast
this PREQ mgmt frame (broadcast/multicast) 4 times more than previous
implementation. We have already have ARP flooding discussion on o11s
mailing list that day
(http://lists.open80211s.org/pipermail/devel/2015-June/003685.html).
Bob has even mentioned about multicast-to-unicast conversion for ARP
packet. Don't think that this is good idea doing the same with PREQ.

> No it will not cause additional latency. Imagine a classic challenging
> topology for mesh routing: four or more nodes arranged into a U where we
> want to route from one end of the U to the other end. But the short direct
> hop is very bad and the links along the U are all excellent.
>
> Before what would happen is that we would first hear a PREP from the direct
> hop (because the packets don't have to travel as far). We'd then select that
> route because it has newer information than what we had previously. If we
> got a PREP from the long path we'd then switch to that because it is just as
> new and a better metric. But the longer that path the greater the chance
> that we'll lose either a PREQ or a PREP. And because the PHY doesn't
> retransmit management packets this happens rather often in practice.

Maybe take a look on the driver site of the WiFi chipset that you used?

> And if
> we periodically refresh paths as currently happens we have even more
> opportunities to select the wrong path.

Periodically refresh the paths, you mean in 5s interval guarded by
dot11MeshHWMPactivePathTimeout, right? You can reduce this using iw
utility if you want. If you reduce this, solve your problem?

> Not entirely sure what you mean about being more aggressive. If you mean
> sending out the PREQs more rapidly that is something I have gone back and
> forth on.  My current thinking is to do a few attempts quickly to try and
> get a good path immediately and then lengthen the delay to try to compensate
> for noise bursts.

Not a good idea of PREQ flooding if the path already been established.

> It's just as important to do multiple discoveries for an established path as
> for a brand new path. In either case if we send one PREQ out we'll often
> fail to choose the right path.
>

As mentioned in section 13.10.8.5 Repeated attempts at path discovery,
dot11MeshHWMPmaxPREQretries is used to limit number of "repeated" or
"retried" attempts on path discovery. So if the path has successfully
established, you move to path maintenance and don't repeat the
attempt.

This patch may work well for your case, but not for others since the
network behavior may change with more broadcast/multicast mgmts frame
in the MBSS.

If you really think this is useful, maybe rework this patch and add
nl80211 command to enable this if you want.

---
Chun-Yeow

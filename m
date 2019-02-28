Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D697AC10F00
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 09:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD7BC21850
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 09:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732105AbfB1JGU convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 04:06:20 -0500
Received: from mout.gmx.net ([212.227.17.22]:38599 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731013AbfB1JGU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 04:06:20 -0500
Received: from w210-65-v4.eduroam.dynamic.rbg.tum.de ([131.159.210.221]) by
 mail.gmx.com (mrgmx103 [212.227.17.168]) with ESMTPSA (Nemesis) id
 0MBWIM-1gonVD06Gk-00AWdK; Thu, 28 Feb 2019 10:05:41 +0100
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH RFC] mac80211: Use IFF_ECHO to force delivery of tx_status
 frames
From:   Julius Niedworok <julius.n@gmx.net>
In-Reply-To: <550ff2ac45c891a3fcf3dd8a454f9732d8aa1b70.camel@sipsolutions.net>
Date:   Thu, 28 Feb 2019 10:05:37 +0100
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-wireless@vger.kernel.org, ga58taw@mytum.de,
        David Hildenbrand <david@redhat.com>, nc@net.in.tum.de,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Li RongQing <lirongqing@baidu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Julius Niedworok <julius.n@gmx.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <AD1F7A49-B3F3-4033-8B0A-D1F8C2C6C834@gmx.net>
References: <20190226094104.35192-1-julius.n@gmx.net>
 <c522f2e0-1bef-8679-45f7-707854918820@hartkopp.net>
 <6A213CBE-0B6A-466A-B721-E6A728D4888D@gmx.net>
 <550ff2ac45c891a3fcf3dd8a454f9732d8aa1b70.camel@sipsolutions.net>
To:     Johannes Berg <johannes@sipsolutions.net>
X-Mailer: Apple Mail (2.3273)
X-Provags-ID: V03:K1:ri6uU9ZiuVS+8u+wCZiSdVJEeAyW1a0KbHvpNqxz2ePIlD97jMU
 0KaKQClYtekqYhSLZ73QePjj2I+5Fr3PQaLAFLNm+r+VBCzUR2ORf4MZZThF5VRUlYRdS7d
 m0/68fqVLJVRjU3ZRjlWXWCeeXB5AeyOEM+5HEXZBoAQS+AUX07LCp4nfKsorfsZDbbSGx9
 dYZo09VZGW4jWMONZizMg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:XMkL79729MU=:v6/wDinId4gnUjaj+H1zVZ
 VIEBcsnWURVgyJBDe5QtUjemKZn5/KdfxcGhH3RQCoiIorLkXkHwa2um761Z6lKy8IxbRErfg
 O1QtnQf6gKta1mx3JzLPdTdwIXzlqZ7bi0JWEARA0DNQX5z+GZ7WXAOASzvXIXJBeWk0hkEN0
 EFsUBYP2fgSSgbhHmq7q4IvTaaq31EsdUBP0c0lPZPeU/CJ4ao1zoe/T+LXRiW7Rpj52Y+DAD
 1zijYBb0YmTvD4kXKFo7VimyihLwFjo/ZqXThSy9Ct504gMKcXS8Lkg/JB+Te79WfaMhivsmZ
 IFc1ur39haMwS+TSrWhEshccJM6TrNJ0UQXKIT0PW3Y9g7Kx6Jl00WaEzZRmvlmSLW4eLhPsG
 TI/q28x7eZwobDWFPeyMMiT/mY8Zvg9fMxDO3WnaSKXd4YrvhwGpp+vG59zr+4g0qpkhunU2H
 Nn+FnpXelb/2BlK5yQ/RWbvrelIWvLhfJQpUJoEyfTmXcNP+M9iy519OJou6ApHvf7sge8pgI
 YQc/z81o2a/g3+XKO7CVpHHuck7U2TAJ/A21317izOTmmSMhRZfVrifQqmVGGRSFRWOHL4zqG
 aMBC+OamoYVwU2WZxklpYU4/V8PifNeVhYxpieYziUbnqlh5XfH7pWJzUgsGvUOX9DRkD9N+d
 xkxpcZtFBH7He1OjPt5vasGtaXdyLMuAb7MjTrH6fHmRBzHeaWm6QOH5lGq0VBLWvjQuzTeiw
 VANqtZGrwGkvyk5lEK+VBItoUSxE6koz+5rDpsfa8jlnCTvvIwTH5TbDBmFz1YPmkiizxuckt
 2dwAX1JmDA9/2cEAx3F3F7MUDS3R5/iI5wsAUat6Yym6bgPTeAJvhc04yCxVSXFbC9aLTNHa2
 8EGEq3pYXD9u1xs/4LlOP+QRsJieCrzpj739e4+lomWgadd+DnPcLjJh8gIZPPGe0b+XFnQpr
 buhn01YMxMw==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> On 26.02.2019 14:33 Johannes Berg wrote
> 
> You're proposing to add this to the *monitor* interfaces and you really
> should have made the flag conditional on that to make that clear.
> 
> However, even on monitor interfaces, you typically *already* see the
> frames you transmitted there (as raw frames, which is the only thing you
> can do).
> 
Thanks for your prompt reply and thoughts on our patch.

Let us briefly describe our test setup to ensure everyone on this mailing
list is one the same page.

Our general setup looks like this:
1 $ iw wlp1s0 info
Interface wlp1s0
      ifindex 5
      wdev 0x1
      addr 4c:5e:0c:11:43:ac
      type managed
      wiphy 0
      txpower 30.00 dBm
1 $ iw phy phy0 interface add mon0 type monitor
1 $ iw phy phy0 interface add mon1 type monitor

When we send (raw) packets on mon0 using packetspammer [1] and listen on
the _other_ monitor mode interface mon1, we receive frames that were sent
on the first one:
1 $ packetspammer mon0
2 $ tcpdump -i mon1 'wlan addr2 13:22:33:44:55:66'

This is due to the fact that frames sent on mon0 are echoed back as TX
status frames, because REQ_TX_STATUS is always set for frames sent from
monitor mode interfaces.

But when we replace mon0 with an interface in managed mode (wlp1s0), the
receipt of frames stops, because in managed mode REQ_TX_STATUS is cleared
in most frames:
1 $ ifup wlp1s0
1 $ ping -I wlp1s0 192.168.254.1 # this address is not assigned to any host
2 $ tcpdump -i mon1 ‚wlan addr2 4c:5e:0c:11:43:ac‘

> What you're proposing is to use IFF_ECHO to show frames transmitted
> through *other* interfaces on the monitor interface.
> 
> I don’t think the IFF_ECHO semantics really match this.
> 
What we propose is to use IFF_ECHO to force REQ_TX_STATUS being set for all
frames sent on the interface. But you are right: The goal is that frames
transmitted through the other interface show up on the monitor interface
(but only after passing the driver). However, this is exactly how we
understand the semantics of IFF_ECHO in the kernel documentation.
> 
> Additionally, drivers are sort of free to ignore the REQ_TX_STATUS, or
> we could in the future add ways of using the _noskb to feed back TX
> status to the state machines where needed, so I'm not really sure I even
> _want_ this to be set in stone in such an API.
> 
As far as we know, drivers must return a TX status frame, if REQ_TX_STATUS
is set, but can do whatever they want, if it is clear. This is no problem for our
functionality, because we force the delivery of TX status frames by
permanently setting REQ_TX_STATUS. As long as the semantics of
REQ_TX_STATUS remains like it is now, the functionality will always be
as expected from our API.

> Now, I can also see how this can be useful for debugging, but it feels
> to me like this should be a driver (debug) option?
> 
We could also achieve the functionality by modifying the drivers but this
would mean that we had to add this functionality to every driver.
Moreover, the feature of TX status frames, how it is implemented currently
for monitor mode interfaces, is part of the mac80211 implementation. The
decision to force TX status frames for monitor mode interfaces is made in
the common mac80211 implementation.

> johannes
> 
Once again, thanks for your comments. We appreciate your response.

Julius and Charlie

[1] https://warmcat.com/git/packetspammer

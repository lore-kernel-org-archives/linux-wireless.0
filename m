Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35505 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753570AbdAZP17 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 10:27:59 -0500
Message-ID: <1485444476.5145.136.camel@edumazet-glaptop3.roam.corp.google.com> (sfid-20170126_162809_981029_3C220424)
Subject: Re: IPv6-UDP 0x0000 checksum
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 26 Jan 2017 07:27:56 -0800
In-Reply-To: <1485444276.5145.133.camel@edumazet-glaptop3.roam.corp.google.com>
References: <1485437276.14760.3.camel@sipsolutions.net>
         <1485438299.5145.117.camel@edumazet-glaptop3.roam.corp.google.com>
         (sfid-20170126_144502_343976_16232A6D) <1485438546.14760.7.camel@sipsolutions.net>
         <1485441942.5145.131.camel@edumazet-glaptop3.roam.corp.google.com>
         (sfid-20170126_154545_190303_B1FB80BF) <1485442164.14760.11.camel@sipsolutions.net>
         <1485444276.5145.133.camel@edumazet-glaptop3.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-26 at 07:24 -0800, Eric Dumazet wrote:
> On Thu, 2017-01-26 at 15:49 +0100, Johannes Berg wrote:
> 
> > Unfortunately, I haven't been able to actually test this yet. I also
> > didn't find the code that would drop frames with CSUM 0 either, so I'm
> > thinking - for now - that if all the csum handling is skipped, dropping
> > 0 csum frames would also be, and then we'd accept a frame we should
> > actually have dropped.
> > 
> > I'll go test this I guess :)
> > 
> > Any pointers to where 0 csum frames are dropped?
> 
> Probably in udp6_csum_init()

vi +804 net/ipv6/udp.c

                if (!uh->check && !udp_sk(sk)->no_check6_rx) {
                        udp6_csum_zero_error(skb);
                        goto csum_error;
                }

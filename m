Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50776 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753522AbdAZPgd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 10:36:33 -0500
Message-ID: <1485444985.14760.14.camel@sipsolutions.net> (sfid-20170126_163647_146654_D075A9E2)
Subject: Re: IPv6-UDP 0x0000 checksum
From: Johannes Berg <johannes@sipsolutions.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 26 Jan 2017 16:36:25 +0100
In-Reply-To: <1485444476.5145.136.camel@edumazet-glaptop3.roam.corp.google.com> (sfid-20170126_162759_798052_1A660877)
References: <1485437276.14760.3.camel@sipsolutions.net>
         <1485438299.5145.117.camel@edumazet-glaptop3.roam.corp.google.com>
         (sfid-20170126_144502_343976_16232A6D) <1485438546.14760.7.camel@sipsolutions.net>
         <1485441942.5145.131.camel@edumazet-glaptop3.roam.corp.google.com>
         (sfid-20170126_154545_190303_B1FB80BF) <1485442164.14760.11.camel@sipsolutions.net>
         <1485444276.5145.133.camel@edumazet-glaptop3.roam.corp.google.com>
         <1485444476.5145.136.camel@edumazet-glaptop3.roam.corp.google.com>
         (sfid-20170126_162759_798052_1A660877)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-26 at 07:27 -0800, Eric Dumazet wrote:
> 
>                 if (!uh->check && !udp_sk(sk)->no_check6_rx) {
>                         udp6_csum_zero_error(skb);
>                         goto csum_error;
>                 }



Yeah, I'd found no_check6_rx already, was still trying to figure out this one :)

Looks like we actually check uh->check regardless of anything the
driver said (CHECKSUM_UNNECESSARY, or whatever), so we should be fine
even with the hardware tagging it as good in this case.

johannes

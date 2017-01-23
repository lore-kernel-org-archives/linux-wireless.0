Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38784 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751243AbdAWQ3u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 11:29:50 -0500
Message-ID: <1485188986.7244.1.camel@sipsolutions.net> (sfid-20170123_172957_533701_783ECA37)
Subject: Re: Strange Behaviors in 802.11 Association MLME
From: Johannes Berg <johannes@sipsolutions.net>
To: Jinghao Shi <jinghaos@buffalo.edu>, linux-wireless@vger.kernel.org
Cc: Geoffrey Challen <challen@buffalo.edu>,
        Shuvendu Lahiri <Shuvendu.Lahiri@microsoft.com>,
        Ranveer Chandra <ranveer@microsoft.com>
Date: Mon, 23 Jan 2017 17:29:46 +0100
In-Reply-To: <CAKdW-HF5R2=mGUvqvdAdhx2EAXmmZaRh9GvnMemxE+GYEXBQQQ@mail.gmail.com> (sfid-20170116_222512_068147_8EC03192)
References: <CAKdW-HF5R2=mGUvqvdAdhx2EAXmmZaRh9GvnMemxE+GYEXBQQQ@mail.gmail.com>
         (sfid-20170116_222512_068147_8EC03192)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-01-16 at 16:16 -0500, Jinghao Shi wrote:
> Hi,
> 
> We're working on a formal validation framework for wireless protocol
> implementations. We have performed experiments on the 802.11
> association state machine and have found peculiar association
> behaviors.We'd like to share our findings to the community and
> confirm
> whether they reveal potential implementation bugs.
> 
> TLDR version: the client sends association request despite having
> received association response from the AP, is this a bug?
> 
> We utilized a real time reactive packet jammer to create the
> following
> packet loss pattern (the rate control policy was set to re-transmit
> the packet at most once before reporting the packet as failed. This
> may not be realistic in practice but helps reveal interesting
> behaviors faster.)
> 
>  - ASSOC_REQ (received by the AP, confirmed by the following
> ASSOC_RESP)
>  - ACK <---- JAMMED
>  - ASSOC_REQ_RETRY <----- JAMMED, the driver will declare this packet
> as failed
>  - ASSOC_RESP (received by the client, confirmed by the following
> ACK)
>  - ACK
>  - ASSOC_REQ <--- problematic packet
>  - ...

I don't really see a problem. We assume that the packet was lost due to
the missing ACK, so instead of waiting for a long time, we transmit a
new one. Typically, a missing ACK is far less likely than a missing
frame.

If, as here, the association response arrives, we should properly act
on it either way.

johannes

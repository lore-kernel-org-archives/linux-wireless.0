Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59814 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751387AbdFZLAa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jun 2017 07:00:30 -0400
Message-ID: <1498474826.3318.4.camel@sipsolutions.net> (sfid-20170626_130032_820041_677B4537)
Subject: Re: [RFC 3/6] mac80211: add a TXQ for other powersave-buffered
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Date: Mon, 26 Jun 2017 13:00:26 +0200
In-Reply-To: <89353e7a-5c61-eba3-fe34-0e7eadf7588e@candelatech.com>
References: <20170621235022.25362-1-johannes@sipsolutions.net>
         <20170621235022.25362-3-johannes@sipsolutions.net>
         <63c97c53-af93-107a-a28e-59cebcf01fd6@candelatech.com>
         <1498112650.2246.1.camel@sipsolutions.net>
         <3735eb1d-89b5-b4ad-6657-d0d4e9642574@candelatech.com>
         <1498209700.2595.2.camel@sipsolutions.net>
         <89353e7a-5c61-eba3-fe34-0e7eadf7588e@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-06-23 at 05:27 -0700, Ben Greear wrote:

> I don't understand the code well enough to know if this matters or
> not, but the ath10k wave-2 stuff has some txq prefetch logic in the
> firmware (and support in the driver).  But, it doesn't prefetch for
> the mgt tid as far as I can tell.  It somehow all mostly works
> anyway, but possibly this would have some effect on your
> changes.  wave-1 (QCA 9880, etc) doesn't do txq prefetch at all.  Any
> tricky changes to this logic would need to test with both chipsets.

I don't think this matters. The issue at hand is that the driver still
relies on mac80211 buffering.

This *can* be solved, even in this piece of code I inserted here, but
it'd have to keep state about the queues and then insert some hooks
elsewhere. I'm pretty sure I can solve that, but don't have the time
(or even hardware) to test this (easily, I have ath10k in a few
routers, but ...).

johannes

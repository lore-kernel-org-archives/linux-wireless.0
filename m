Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45398 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753049AbcLONxz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 08:53:55 -0500
Message-ID: <1481809984.2582.5.camel@sipsolutions.net> (sfid-20161215_145401_944514_1CC4C1EF)
Subject: Re: [RFC 2/3] mac80211: Implement data xmit for 802.11 encap offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>,
        "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 15 Dec 2016 14:53:04 +0100
In-Reply-To: <85c98160-3ee9-07db-cb4c-9e300f0ba798@nbd.name>
References: <1481781608-5181-1-git-send-email-vthiagar@qti.qualcomm.com>
         <1481781608-5181-3-git-send-email-vthiagar@qti.qualcomm.com>
         <1481794142.31776.5.camel@sipsolutions.net>
         <58528607.7090101@qti.qualcomm.com>
         <85c98160-3ee9-07db-cb4c-9e300f0ba798@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > I agree. Dynamic switch part is buggy, we can start with not
> > allowing interfaces resulting in dynamic switch.
> 
> Does this mean that when bringing up multiple interfaces, users would
> need to figure out the 'magic' order that works?

I think we need to talk about hardware capabilities at this point.

I was assuming that it would actually be possible to run two interfaces
with different paths here concurrently - is that not true? If that's
not true, then we absolutely _need_ dynamic switching, I agree with
Felix, but then we have a pretty big complication to figure out. But we
can't let this optimisation affect user experience.

johannes

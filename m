Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51062 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754150AbdCHWIp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 17:08:45 -0500
Message-ID: <1489008812.7127.9.camel@sipsolutions.net> (sfid-20170308_231029_408604_8FBD4586)
Subject: Re: [RFCv2 2/2] mac80211: Implement data xmit for 802.11 encap
 offload
From: Johannes Berg <johannes@sipsolutions.net>
To: "Pubbisetty, Manikanta" <mpubbise@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
Date: Wed, 08 Mar 2017 22:33:32 +0100
In-Reply-To: <30b4079fcf574d6fb62a10d8fa85ac06@aphydexm01f.ap.qualcomm.com>
References: <1488540807-27415-1-git-send-email-mpubbise@qti.qualcomm.com>
         <1488540807-27415-3-git-send-email-mpubbise@qti.qualcomm.com>
         <1488544754.25750.8.camel@sipsolutions.net>
         <30b4079fcf574d6fb62a10d8fa85ac06@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Why is that needed? Since you have a separate TX path
> > (ndo_start_xmit),
> > wouldn't it make more sense to call into a drv_tx_8023() or
> > something like that instead?
> > 
> 
> [Manikanta]  Yes, it makes sense having a separate driver hook
> instead of using drv_tx, but in case of drivers (fe ath10k) 
> where enqueuing and dequeuing tx logic (wake_tx_queue and
> ieee80211_tx_dequeue) is used there should be a way
> to indicate that the packet is not 80211 encapsulated, isn't it?
> Correct me if I am missing anything.

Ah, interesting. Yeah, I guess that makes some sense then, though I'm
not super happy with sharing the code paths between differently
encapsulated frames - best to leave that as minimal as possible.

> [Manikanta]  Hmmm you are right. I just went through the code, seems
> ieee80211_tx_status_noskb does most of them what
> ieee80211_tx_status_8023 is doing, resetting the station connection
> monitoring logic and updating last known tx rate is missing in
> _noskb. These are required, isn't it?

Maybe. I don't think the tx rate is strictly required but would be
nice, while the monitoring logic is probably needed only to avoid
spurious null data packets over the air.

However, come to think of it, we need to see how this interacts with
the tx status thing - if tx status is requested then I believe _no_skb
cannot be used.

> [Manikanta] You are correct. It is good if driver advertises the vif
> types it support in encap offload mode, but how can we decide the
> netdev_ops to be used while creating the vif? drv_add_interface will
> be invoked from ndo_open and
> even before invoking driver add_interface we have to make the
> decision of using Ethernet mode netdev_ops or the default netdev_ops,
> isn't it?

It might not be a problem to swap the dev->netdev_ops, changing only
the start_xmit, while the interface is being brought up. I assume the
driver can make this decision in add_interface(), and I think swapping
there should be OK. It might be problematic if this value changes
during suspend/resume or HW restart though.

> Can we have a separate driver hook which gives whether 80211 encap
> offload is supported for the given interface type and then decide the
> netdev_ops to be attached for the vif?

I don't think that makes sense, since you can't know if the interface
will ever be brought up, so the driver can't make a good decision since
it normally doesn't have to care about interfaces that aren't brought
up.

The only real alternative I see, which might be preferable, is for the
driver to advertise a bitmap of interface types that it wants to use
ethernet framing with.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39782 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751389AbdCNOLg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 10:11:36 -0400
Message-ID: <1489500692.10872.11.camel@sipsolutions.net> (sfid-20170314_151155_669889_E7E3E83C)
Subject: Re: [RFCv2 2/2] mac80211: Implement data xmit for 802.11 encap
 offload
From: Johannes Berg <johannes@sipsolutions.net>
To: "Pubbisetty, Manikanta" <mpubbise@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
Date: Tue, 14 Mar 2017 15:11:32 +0100
In-Reply-To: <828dd0c9cb0d409eb4d3aadc7f585a69@aphydexm01f.ap.qualcomm.com>
References: <1488540807-27415-1-git-send-email-mpubbise@qti.qualcomm.com>
         <1488540807-27415-3-git-send-email-mpubbise@qti.qualcomm.com>
         <1488544754.25750.8.camel@sipsolutions.net>
         <30b4079fcf574d6fb62a10d8fa85ac06@aphydexm01f.ap.qualcomm.com>
         <1489008812.7127.9.camel@sipsolutions.net>
         <828dd0c9cb0d409eb4d3aadc7f585a69@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

[Manikanta] In that case I will keep this change, should we consider
a separate driver hook for legacy/mgmt tx like drv_tx_8023??
> How about having wake_tx_queue_8023 and ieee80211_tx_dequeue_8023 so
> that Ethernet transmit path is totally exclusive. Thoughts??

I'm not sure this will work well. The driver might have more space for
sending to a specific station, but doesn't really know which frames
should go first. So either it'd have to call both (dequeue_8023
followed by dequeue) with mac80211 sorting out what to do, or we should
keep it combined. I think mac80211 sorting out the priority here etc.
would be far more complex than this.

> [Manikanta] Hmmm, I would like to have ieee80211_tx_status_8023 for
> now and go with a TODO for single tx reporting mechanism for both
> Ethernet and 802.11 tx formats. Any thoughts?

There's an additional wrinkle btw - we currently report the 802.11
frame to the monitor interface, if active. Not sure we can keep that,
but it's something to think about.

> > The only real alternative I see, which might be preferable, is for
> > the driver to advertise a bitmap of interface types that it wants
> > to use ethernet framing with.
> > 
> 
> [Manikanta] Correct, this would be a onetime registration. Isn't it ?
> I am just curious to know whether the supported vif types for
> ethernet framing can change dynamically, is this possible?

I don't see why it would change. I guess there's a small chance that
you might design the HW in a way that it only has enough HW resources
to do header format conversion for a limited number of interfaces, but
if that ends up being a problem we can perhaps add more other
capabilities.

The way we're looking at it will be type/header format dependent,
nothing else.

johannes

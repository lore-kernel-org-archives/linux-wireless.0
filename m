Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45410 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932741AbdCaLwW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 07:52:22 -0400
Message-ID: <1490961139.6288.10.camel@sipsolutions.net> (sfid-20170331_135225_242810_C6B367D5)
Subject: Re: [RFCv2 2/2] mac80211: Implement data xmit for 802.11 encap
 offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Manikanta Pubbisetty <mpubbise@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Date: Fri, 31 Mar 2017 13:52:19 +0200
In-Reply-To: <fbc82bc9af344237bd5cd3210d9d012e@aphydexm01f.ap.qualcomm.com>
References: <1488540807-27415-1-git-send-email-mpubbise@qti.qualcomm.com>
         <1488540807-27415-3-git-send-email-mpubbise@qti.qualcomm.com>
         <1488544754.25750.8.camel@sipsolutions.net>
         <30b4079fcf574d6fb62a10d8fa85ac06@aphydexm01f.ap.qualcomm.com>
         <1489008812.7127.9.camel@sipsolutions.net>
         <828dd0c9cb0d409eb4d3aadc7f585a69@aphydexm01f.ap.qualcomm.com>
         <1489500692.10872.11.camel@sipsolutions.net>
         <fbc82bc9af344237bd5cd3210d9d012e@aphydexm01f.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, almost dropped this thread - my bad.

> > > [Manikanta] Hmmm, I would like to have ieee80211_tx_status_8023
> > > for
> > > now and go with a TODO for single tx reporting mechanism for both
> > > Ethernet and 802.11 tx formats. Any thoughts?
> > 
> > There's an additional wrinkle btw - we currently report the 802.11
> > frame to the monitor interface, if active. Not sure we can keep
> > that, but it's something to think about.
> > 
> 
> [Manikanta] Good point, this is something we have to think about. I
> believe this one is tricky, do we need to add the .11 header just
> before giving to monitor interfaces?

It's complicated. The interface has radiotap+802.11 type, so on the one
hand it should have 802.11 header. On the other hand, having what went
to the hardware can be helpful. However, I don't think we can get
around the radiotap+802.11 type in any way.

> How important will this be for Ethernet tx changes? I am running out
> of thoughts.

Well I think it's something we should consider when we look at this
path. Hopefully nobody who really cares about performance has the
monitor stuff active - although we're thinking of ways to push down
filters to make that less expensive.

johannes

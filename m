Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40480 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754076AbcJDIhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Oct 2016 04:37:09 -0400
Message-ID: <1475570219.5324.28.camel@sipsolutions.net> (sfid-20161004_103730_906032_E4A2BEED)
Subject: Re: [PATCHv3] wireless: check A-MSDU inner frame source address on
 AP interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael.braun@fem.tu-ilmenau.de>
Cc: kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Tue, 04 Oct 2016 10:36:59 +0200
In-Reply-To: <1475569759.5324.22.camel@sipsolutions.net> (sfid-20161004_102935_286017_DBB63EF5)
References: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
         <1475229714.17481.18.camel@sipsolutions.net>
         <f9d33317-f23f-9d5e-8e9e-1e63eff1882a@fem.tu-ilmenau.de>
         <1475569759.5324.22.camel@sipsolutions.net>
         (sfid-20161004_102935_286017_DBB63EF5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-10-04 at 10:29 +0200, Johannes Berg wrote:

> > IEEE 802.11-2012 8.3.2.2 contains the note "NOTE—It is possible to
> > have different DA and SA parameter values in A-MSDU subframe
> > headers of the same A-MSDU as long as they all map to the same
> > Address 1 and Address 2 parameter values."
> >  
> > I conclude that embedding multicast in unicast A-MSDU frames is
> >  generally allowed, because "mapping" does not mean "be identical".
> 
> Yeah, I saw this. It's not clear to me that they intended this
> wording to be about multicast though. I'm not really sure what they
> had in mind here, but there's an exception for multicast for DMS,
> which would seem pointless if they had intended this "mapping" to be
> about multicast.
> 
> Then again, I don't know of any "address mapping" service or the like
> in the spec either.

Actually, I just came up with an explanation: The DA and RA can be
different, and the DA inside need not necessarily be the RA. Taken in
the context of the overall paragraph, that makes sense:

    An A-MSDU contains only MSDUs whose DA and SA parameter values map
    to the same receiver address (RA) and transmitter address (TA)
    values, i.e., all the MSDUs are intended to be received by a single
    receiver, and necessarily they are all transmitted by the same
    transmitter. The rules for determining RA and TA are independent of
    whether the frame body carries an A-MSDU.

    NOTE—It is possible to have different DA and SA parameter values in
    A-MSDU subframe headers of the same A-MSDU as long as they all map
    to the same Address 1 and Address 2 parameter values.


Obviously, now that I think about it, your patch also would break
client mode since it would refuse to accept any A-MSDU with SA != TA,
which is highly unlikely in most cases, since traffic doesn't usually
originate from the AP.

Overall, it seems to me we should do the following:

 * allow checking both DA and SA, by having optional arguments to the
   function for this
 * pass DA == RA for client mode (not when 4-addr)
 * pass SA == TA for AP/VLAN modes (not when 4-addr)
 * pass both on TDLS links
 * pass both for IBSS mode (I think)

For the "to the AP" case, this of course also covers multicast, since
the DA is A3 and won't be checked.

johannes

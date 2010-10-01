Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dee.erg.abdn.ac.uk ([139.133.204.82]:33771 "EHLO erg.abdn.ac.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750968Ab0JAHWW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 03:22:22 -0400
Message-ID: <42875.148.187.160.35.1285917725.squirrel@148.187.160.35>
In-Reply-To: <1285857487.5137.2.camel@jlt3.sipsolutions.net>
References: <20100930102508.GB3581@gerrit.erg.abdn.ac.uk>
    <1285857487.5137.2.camel@jlt3.sipsolutions.net>
Date: Fri, 1 Oct 2010 08:22:05 +0100 (BST)
Subject: Re: [Patch 1/1] wext: fix 32/64 bit alignment issue for 'point'
     type
From: gerrit@erg.abdn.ac.uk
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Gerrit Renker" <gerrit@erg.abdn.ac.uk>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Thu, 2010-09-30 at 12:25 +0200, Gerrit Renker wrote:
>> wireless: fix alignment problem
>>
>> With the current definition, IW_EV_POINT_PK_LEN is 12 on 64-bit and 8 on
>> 32-bit systems, due to the way struct iw_event is packed (24 byte on
>> 64-bit systems instead of 20 byte on 32-bit systems). Furthermore, the
iwe_stream_add_point() in
>> include/net/iw_handler.h
>> also uses IW_EV_LCP_PK_LEN as header length.
>>
>> The current definition appears to be a typo (PK_LEN instead of LEN); it
>> causes misalignment on 64 bit systems.
>
> So, correct me if I'm wrong, the only effect this change has is changing
> the second memcpy() in iwe_stream_add_point() to not copy an extra 4
> bytes that will be overwritten right away by the next memcpy()
> (presumably, unless the data is < 4, in which case the memcpy might
> actually be out of bounds).
>
Thank you for pointing this out, it seems the change is not as trivial
as I thought.

I noticed this problem in userspace where the 4 byte difference caused
misalignment of point types (such as essid) on a 64 bit system.

I wonder whether the following thinking is right:
 * the first memcpy copies 4 bytes = IW_EV_LCP_PK_LEN starting at stream
 * the second memcpy should start where the first left off, i.e.
     memcpy(stream +  IW_EV_LCP_PK_LEN,
            ((char *) &iwe->u) + IW_EV_POINT_OFF,
            IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);
   where IW_EV_POINT_PK_LEN = IW_EV_LCP_PK_LEN = 8
 * if this were true, then
      int lcp_len   = iwe_stream_lcp_len(info);
   could also go.

But I have not tested any of this. Unless it is clear, please ignore for
the moment, I will test next week and get back.


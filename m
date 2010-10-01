Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab0JAIan (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 04:30:43 -0400
Subject: Re: [Patch 1/1] wext: fix 32/64 bit alignment issue for 'point'
 type
From: Johannes Berg <johannes@sipsolutions.net>
To: gerrit@erg.abdn.ac.uk
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <42875.148.187.160.35.1285917725.squirrel@148.187.160.35>
References: <20100930102508.GB3581@gerrit.erg.abdn.ac.uk>
	 <1285857487.5137.2.camel@jlt3.sipsolutions.net>
	 <42875.148.187.160.35.1285917725.squirrel@148.187.160.35>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 10:30:39 +0200
Message-ID: <1285921839.3739.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 08:22 +0100, gerrit@erg.abdn.ac.uk wrote:

> >> The current definition appears to be a typo (PK_LEN instead of LEN); it
> >> causes misalignment on 64 bit systems.
> >
> > So, correct me if I'm wrong, the only effect this change has is changing
> > the second memcpy() in iwe_stream_add_point() to not copy an extra 4
> > bytes that will be overwritten right away by the next memcpy()
> > (presumably, unless the data is < 4, in which case the memcpy might
> > actually be out of bounds).

> Thank you for pointing this out, it seems the change is not as trivial
> as I thought.

Well, I think the change is correct, given that without it we seem to
copy too much in that memcpy() (which is unlikely to matter though)

> I noticed this problem in userspace where the 4 byte difference caused
> misalignment of point types (such as essid) on a 64 bit system.

Ah, so userspace reading this was the issue -- yes, I can see that, and
I checked the "canonical userspace" (wireless-tools), and it essentially
contains this patch.

> I wonder whether the following thinking is right:
>  * the first memcpy copies 4 bytes = IW_EV_LCP_PK_LEN starting at stream
>  * the second memcpy should start where the first left off, i.e.
>      memcpy(stream +  IW_EV_LCP_PK_LEN,
>             ((char *) &iwe->u) + IW_EV_POINT_OFF,
>             IW_EV_POINT_PK_LEN - IW_EV_LCP_PK_LEN);
>    where IW_EV_POINT_PK_LEN = IW_EV_LCP_PK_LEN = 8
>  * if this were true, then
>       int lcp_len   = iwe_stream_lcp_len(info);
>    could also go.
> 
> But I have not tested any of this. Unless it is clear, please ignore for
> the moment, I will test next week and get back.

I think it's a bit more complicated than that, but then this is wext, so
it can't be easy to understand ;)

The format should be
 - iw_event.len (2 bytes)
 - iw_event.cmd (2 bytes)
 - [potentially padding, depending on alignment of union iwreq_data
    in struct iw_event -- lcp_len accounts for this]
 - iw_point.length (2 bytes)
 - iw_point.flags (2 bytes)
 - iw_point data ("extra")

As far as I can tell, the bug that you found means that we copy 4 or 8
too many bytes when we copy in iw_point.{length,flags}, but typically it
won't matter all that much as we neither declare it valid nor will the
destination buffer usually be overrun by it.

This is the only effect on the kernel since this is the only user of
this define that you want to change. In userspace, there are more users,
and they might well run into issues due to the bad version of the
constant, which is most likely why Jean corrected it in
wireless-tools ...

In any case, I consider all this software archaeology, and not really
worth the effort unless something breaks ... nobody can properly review
this code anyway and keep their sanity :-)

johannes


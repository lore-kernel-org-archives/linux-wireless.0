Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35901 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184Ab2B2RUD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:20:03 -0500
Received: by ghrr11 with SMTP id r11so963567ghr.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 09:20:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEcp3F1ZV1MpnBrdF3uL1dpgP1zFCUB+VYFAzEMU1Zzw8A@mail.gmail.com>
References: <CAMcMvsj2XMFarr1+fqdSv88ZLrXLquK7wgF8LsTYDBfvHFwgrA@mail.gmail.com>
	<20120225012039.4E62720353@glenhelen.mtv.corp.google.com>
	<CAB3XZEcp3F1ZV1MpnBrdF3uL1dpgP1zFCUB+VYFAzEMU1Zzw8A@mail.gmail.com>
Date: Wed, 29 Feb 2012 09:20:02 -0800
Message-ID: <CAMcMvsitdrMqMUti=b-cEM6KypGH=SWPhJWnr7xY0sc7_KWOvw@mail.gmail.com> (sfid-20120229_182017_791571_CC908C55)
Subject: Re: [RFCv3] mac80211: Filter duplicate IE ids
From: Paul Stewart <pstew@chromium.org>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org, sleffler@chromium.org,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 25, 2012 at 11:14 PM, Eliad Peller <eliad@wizery.com> wrote:
>
> On Fri, Feb 24, 2012 at 3:59 AM, Paul Stewart <pstew@chromium.org> wrote:
> > mac80211 is lenient with respect to reception of corrupted beacons.
> > Even if the frame is corrupted as a whole, the available IE elements
> > are still passed back and accepted, sometimes replacing legitimate
> > data.  It is unknown to what extent this "feature" is made use of,
> > but it is clear that in some cases, this is detrimental.  One such
> > case is reported in http://crosbug.com/26832 where an AP corrupts
> > its beacons but not its probe responses.
> >
> > One approach would be to completely reject frames with invaid data
> > (for example, if the last tag extends beyond the end of the enclosing
> > PDU).  The enclosed approach is much more conservative: we simply
> > prevent later IEs from overwriting the state from previous ones.
> > This approach hopes that there might be some salient data in the
> > IE stream before the corruption, and seeks to at least prevent that
> > data from being overwritten.  This approach will fix the case above.
> >
> [...]
>
> > @@ -705,7 +730,8 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t
> > len,
> >                        if (!elems->quiet_elem) {
> >                                elems->quiet_elem = pos;
> >                                elems->quiet_elem_len = elen;
> > -                       }
> > +                       } else
> > +                               elem_parse_failed = true;
> >                        elems->num_of_quiet_elem++;
>
> i'm not familiar with this IE, but num_of_quiet_elem, which defined as:
>        u8 num_of_quiet_elem;   /* can be more the one */
> suggests we should treat it differently.

Thanks.  You're absolutely right.  I'm cooking up a new patch.  If
anyone has a list of IE elements that are okay to be repeated, that'd
be nice, but for now I'm assuming (as I've found in practice) that the
default should be to be upset if one is repeated.

>
> Eliad.

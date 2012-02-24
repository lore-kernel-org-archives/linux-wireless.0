Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55363 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2BXO3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 09:29:03 -0500
Subject: Re: [RFC] mac80211: Filter duplicate IE ids
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAMcMvsi_v=gb9UF3tHSZ11fnh83iE9bK7nSiwL1GB-tDqW47jQ@mail.gmail.com> (sfid-20120224_152447_258472_B0DA0609)
References: <20120224033729.9256A205A0@glenhelen.mtv.corp.google.com>
	 <1330068877.3426.6.camel@jlt3.sipsolutions.net>
	 <CAMcMvsi_v=gb9UF3tHSZ11fnh83iE9bK7nSiwL1GB-tDqW47jQ@mail.gmail.com>
	 (sfid-20120224_152447_258472_B0DA0609)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 15:29:01 +0100
Message-ID: <1330093741.3426.19.camel@jlt3.sipsolutions.net> (sfid-20120224_152910_393536_8250EAB8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-02-24 at 06:24 -0800, Paul Stewart wrote:
> On Thu, Feb 23, 2012 at 11:34 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2012-02-23 at 17:59 -0800, Paul Stewart wrote:
> >> mac80211 is lenient with respect to reception of corrupted beacons.
> >> Even if the frame is corrupted as a whole, the available IE elements
> >> are still passed back and accepted, sometimes replacing legitimate
> >> data.  It is unknown to what extent this "feature" is made use of,
> >> but it is clear that in some cases, this is detrimental.  One such
> >> case is reported in http://crosbug.com/26832 where an AP corrupts
> >> its beacons but not its probe responses.
> >>
> >> One approach would be to completely reject frames with invaid data
> >> (for example, if the last tag extends beyond the end of the enclosing
> >> PDU).  The enclosed approach is much more conservative: we simply
> >> prevent later IEs from overwriting the state from previous ones.
> >> This approach hopes that there might be some salient data in the
> >> IE stream before the corruption, and seeks to at least prevent that
> >> data from being overwritten.  This approach will fix the case above.
> >>
> >> Short of any statistics gathering in the various forms of AP breakage,
> >> it's not possible to ascertain the side effects of more stringent
> >> discarding of data.
> >
> > Hmmm. This seems reasonable, but in the given example (in the bug
> > report) it will at least lose the WMM info (since it's corrupt) and the
> > HT info, as well as WPS (which is probably not relevant.)
> 
> As you can see from the association request, the STA appears to hold
> an amalgamation of the broken rate information in the beacon and the
> correct HT/WMM information from the probe response.  In the
> association request there's both HT and WMM info, as it was able to
> get it from the probe response.

Ah, indeed, I hadn't even looked at that.

> > I suppose better to accept such service degradation than not connect,
> > but I wonder if we should log a warning when we actually try to use such
> > an AP?
> 
> Let me know where you'd like it.

How about having a flag in the BSS struct (ieee80211_bss) and printing a
message when we use that BSS struct for assoc? E.g. in
ieee80211_mgd_assoc()? I'm not sure I fully understand where this
actually has any effect.

johannes


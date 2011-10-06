Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51948 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935224Ab1JFQuH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 12:50:07 -0400
Received: by ywb5 with SMTP id 5so2783616ywb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 09:50:07 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [RFC 5/6] ath9k: enable DFS pulse detection
Date: Thu, 6 Oct 2011 18:49:48 +0200
Cc: kgiori@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <201110041538.12885.chunkeey@googlemail.com> <CAB=NE6VC3txpDh4SdDKDxKWKKZVtGQXKVH8opszKDnZeeZTjUQ@mail.gmail.com>
In-Reply-To: <CAB=NE6VC3txpDh4SdDKDxKWKKZVtGQXKVH8opszKDnZeeZTjUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201110061849.48838.chunkeey@googlemail.com> (sfid-20111006_185012_504637_4459D392)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, October 06, 2011 12:27:03 AM Luis R. Rodriguez wrote:
> On Tue, Oct 4, 2011 at 6:38 AM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > On Monday, October 03, 2011 09:31:12 PM Luis R. Rodriguez wrote:
> >> On Mon, Oct 3, 2011 at 12:24 PM, Christian Lamparter
> >> <chunkeey@googlemail.com> wrote:
> >> > On Monday, October 03, 2011 08:27:39 PM Luis R. Rodriguez wrote:
> >> >> On Mon, Oct 3, 2011 at 3:29 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> >> >> >
> >> >> > Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> >> >> > ---
> >> >> >  drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++++
> >> >> >  1 files changed, 12 insertions(+), 0 deletions(-)
> >> >> >
> >> >> > diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> >> >> > index e8aeb98..5defebe 100644
> >> >> > --- a/drivers/net/wireless/ath/ath9k/main.c
> >> >> > +++ b/drivers/net/wireless/ath/ath9k/main.c
> >> >> > [...]
> >> >> > +#ifdef CONFIG_ATH9K_DFS
> >> >>
> >> >> Please spare the #ifdef and just call something within dfs.c, then
> >> >> dfs.h would wrap it to nothing if DFS is disabled.
> >> > Why would anyone want to disable DFS driver support?
> >> > I would say: drop the ifdefs altogether since DFS
> >> > is and will be "required".
> >>
> >> Because DFS requires to be properly tested before being enabled.
> > Testing if a driver detects a pulse is "trivial" compared to the
> > stuff mac80211/cfg80211 and hostapd will have to do to make a
> > channel-change as smooth as possible. I think if there's a DFS
> > "OFF" switch, it should be in hostapd and I hope more people
> > agree on this one.
> 
> You do have a good point, but I disagree that you do not need to test
> / regress test hardware / driver code for DFS.

Actually, you are sort of contradicting yourself here.

Take a look at your "wireless: add DFS master support" patch
series. I don't see any IFDEFs to select between the old
and the new "way" even though you know full well that there's
some black magic going on.

http://permalink.gmane.org/gmane.linux.kernel.wireless.general/78455
Quote:
"Here's a puzzle though... If we change this series to use the other
pad byte that was available, the first pad byte, instead of the last
one, we loose backward compatibility support and I cannot figure out
why."

[Note: This is just an recent enough example. I do think I could come
up with a better one, e.g.: why didn't athXk have a compile-time
switch to disable ANI when it was introduced because it can(and has?)
caused some regressions as well?]

so, why do you want a useless compile-time for *this option* *now*?
Is this something about politics/laws I don't know about [I'm just
curious, because I don't really buy "testing" here, since Zefir
obviously has a working prototype and Atheros has a working and
certificated codebase as well which he can access and base his
work on. So I don't think its that unstable and needs added
ugliness.]
> This is what I'm talking about. But yes, userspace also submits
> itself to the same criteria.
> >> You may also want to simply disable DFS if you do not want to
> >> deal with the regulatory test implications of having it enabled.
> > AFAIK you can't "simply" disable the DFS requirement: hostapd
> > (hw_features.c), [cfg80211] (checks if tx on secondary channel
> > is possible) and mac80211 (tx.c) all have checks. Indeed, the
> > easiest way is to modify crda's database. So there's no need
> > for an extra compile-time option.
> 
> No, DFS is set for certain channels on wireless-regdb/CRDA, I just
> posted DFS master region support for wireless-regdb and CRDA. Apart
> from this we then need driver support. To get DFS you need all of
> these + hostapd part. Each one has its own set of components and does
> deserve its own set of tests and review.
This "deserve its own set of tests and review". Does it translate in:
"ath9k [every driver], mac80211, cfg80211 and hostapd need extra
DFS IFDEFS?". In fact, ifdefs make it harder to do reviews, because
sometimes you just forget the IFDEF/ELSIF/ELSE context of the code.
And regression testing can be done by "git bisect". In fact, isn't
this what git bisect is for?

Regards,
	Chr

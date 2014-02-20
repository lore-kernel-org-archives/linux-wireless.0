Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaBTJyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 04:54:37 -0500
Message-ID: <1392890072.5073.19.camel@jlt4.sipsolutions.net> (sfid-20140220_105442_606583_4C706320)
Subject: Re: [PATCH] crda: handle AUTO bw setting in db2rd
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 20 Feb 2014 10:54:32 +0100
In-Reply-To: <CALhHN=q2Dw+wNraY=F6ZHSrcv1esseQNJn9m+TV0KR-ZAhs5iw@mail.gmail.com> (sfid-20140220_103135_148090_385604FB)
References: <1392226988-3878-1-git-send-email-janusz.dziedzic@tieto.com>
	 <CAB=NE6VEmUr5rVhaeShdJQomhhQ3VeDcHaqeHo0jGNaWKtMwyQ@mail.gmail.com>
	 <CAFED-jn0AfGVqJVFfeu6Pke2UBh-+nnRrhdVM-4acYHn9WdSjQ@mail.gmail.com>
	 <CAB=NE6UR3yQOSZr7NXA4kO2hKre0zBsmK9H1MTYZ=9Wh_=9AtA@mail.gmail.com>
	 <CALhHN=qc7m7oce6aiiNfpW5wUc7ypy2E+0TmYsKNth5_s5FpxQ@mail.gmail.com>
	 <1392882691.5073.3.camel@jlt4.sipsolutions.net>
	 <CALhHN=owY-xYOmieHUeDpmSXqJir2VrmfxM8H3zjo0mVvM3GQg@mail.gmail.com>
	 <1392883153.5073.4.camel@jlt4.sipsolutions.net>
	 <CALhHN=rPZqBJiOHnT4O32FH1JkCSxBYY7gQ1m6RDnnHC9stySQ@mail.gmail.com>
	 <CALhHN=q2Dw+wNraY=F6ZHSrcv1esseQNJn9m+TV0KR-ZAhs5iw@mail.gmail.com>
	 (sfid-20140220_103135_148090_385604FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 10:31 +0100, Janusz Dziedzic wrote:
> On 20 February 2014 09:03, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
> > On 20 February 2014 08:59, Johannes Berg <johannes@sipsolutions.net> wrote:
> >> On Thu, 2014-02-20 at 08:57 +0100, Janusz Dziedzic wrote:
> >>
> >>> >> Yes, seems we should send this even this is 0.
> >>> >> Next for old kernel, all channels where BW=0 will be HT20 only.
> >>> >
> >>> > Is that really a good idea?
> >>> >
> >>> > Maybe crda should just get the logic to determine maximum bandwidth,
> >>> > like you did in the kernel, and then we can even revert the kernel code
> >>> > again?
> >>> >
> >>> Yes, this is possible to calculate this in crda (or even set this manually).
> >>
> >> Ok. Would that help older kernels? How would we handle genregdb.awk?
> >>
> > In case of older kernels we will fail (end_freq - start_freq < bw) with -EINVAL.
> > So, bw=0 (cfg calculation) seems like best idea - will work with new
> > and old kernels.
> >
> Seems cfg80211 max bandwidth calculation is best option here.
> 
> We should set BW as is in old regulatory (skip this BW=0 patches) -
> will work fine with old kernels.
> And in new regulatory add RULE flag NL80211_RRF_AUTO_BW, which will be
> checked in newer kernels and if AUTO_BW flag we will skip (end_freq -
> start_freq < bw) check and calculate maximum available bandwidth. What
> you think?

Yeah that seems reasonable.

johannes


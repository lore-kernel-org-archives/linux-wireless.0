Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaBTHvl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 02:51:41 -0500
Message-ID: <1392882691.5073.3.camel@jlt4.sipsolutions.net> (sfid-20140220_085145_289634_43FFD485)
Subject: Re: [PATCH] crda: handle AUTO bw setting in db2rd
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 20 Feb 2014 08:51:31 +0100
In-Reply-To: <CALhHN=qc7m7oce6aiiNfpW5wUc7ypy2E+0TmYsKNth5_s5FpxQ@mail.gmail.com> (sfid-20140220_082755_205713_3661CC86)
References: <1392226988-3878-1-git-send-email-janusz.dziedzic@tieto.com>
	 <CAB=NE6VEmUr5rVhaeShdJQomhhQ3VeDcHaqeHo0jGNaWKtMwyQ@mail.gmail.com>
	 <CAFED-jn0AfGVqJVFfeu6Pke2UBh-+nnRrhdVM-4acYHn9WdSjQ@mail.gmail.com>
	 <CAB=NE6UR3yQOSZr7NXA4kO2hKre0zBsmK9H1MTYZ=9Wh_=9AtA@mail.gmail.com>
	 <CALhHN=qc7m7oce6aiiNfpW5wUc7ypy2E+0TmYsKNth5_s5FpxQ@mail.gmail.com>
	 (sfid-20140220_082755_205713_3661CC86)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 08:27 +0100, Janusz Dziedzic wrote:
> On 19 February 2014 23:00, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> > On Tue, Feb 18, 2014 at 10:12 PM, Janusz Dziedzic
> > <janusz.dziedzic@gmail.com> wrote:
> >> 2014-02-19 1:33 GMT+01:00 Luis R. Rodriguez <mcgrof@do-not-panic.com>:
> >>> On Wed, Feb 12, 2014 at 9:43 AM, Janusz Dziedzic
> >>> <janusz.dziedzic@tieto.com> wrote:
> >>>> Handle AUTO bandwidth setting in db2rd.
> >>>> Don't add NL80211_ATTR_FREQ_RANGE_MAX_BW attribute
> >>>> in case of AUTO bw calculation.
> >>>>
> >>>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
> >>>
> >>> Please elaborate more on this. Who deals with the automatic math on
> >>> the bandwidth?
> >>>
> >> cfg80211,
> >>
> >> Please check patch:
> >> cfg80211: regulatory introduce maximum bandwidth calculation
> >
> > OK, so we don't send the max bandwidth attribute now, what about
> > support for older kernels?
> >
> Yes, seems we should send this even this is 0.
> Next for old kernel, all channels where BW=0 will be HT20 only.

Is that really a good idea?

Maybe crda should just get the logic to determine maximum bandwidth,
like you did in the kernel, and then we can even revert the kernel code
again?

johannes


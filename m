Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:56544 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaBTH5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 02:57:08 -0500
Received: by mail-lb0-f175.google.com with SMTP id p9so1072092lbv.20
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 23:57:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392882691.5073.3.camel@jlt4.sipsolutions.net>
References: <1392226988-3878-1-git-send-email-janusz.dziedzic@tieto.com>
	<CAB=NE6VEmUr5rVhaeShdJQomhhQ3VeDcHaqeHo0jGNaWKtMwyQ@mail.gmail.com>
	<CAFED-jn0AfGVqJVFfeu6Pke2UBh-+nnRrhdVM-4acYHn9WdSjQ@mail.gmail.com>
	<CAB=NE6UR3yQOSZr7NXA4kO2hKre0zBsmK9H1MTYZ=9Wh_=9AtA@mail.gmail.com>
	<CALhHN=qc7m7oce6aiiNfpW5wUc7ypy2E+0TmYsKNth5_s5FpxQ@mail.gmail.com>
	<1392882691.5073.3.camel@jlt4.sipsolutions.net>
Date: Thu, 20 Feb 2014 08:57:06 +0100
Message-ID: <CALhHN=owY-xYOmieHUeDpmSXqJir2VrmfxM8H3zjo0mVvM3GQg@mail.gmail.com> (sfid-20140220_085712_295235_98B06E0E)
Subject: Re: [PATCH] crda: handle AUTO bw setting in db2rd
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 February 2014 08:51, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-02-20 at 08:27 +0100, Janusz Dziedzic wrote:
>> On 19 February 2014 23:00, Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
>> > On Tue, Feb 18, 2014 at 10:12 PM, Janusz Dziedzic
>> > <janusz.dziedzic@gmail.com> wrote:
>> >> 2014-02-19 1:33 GMT+01:00 Luis R. Rodriguez <mcgrof@do-not-panic.com>:
>> >>> On Wed, Feb 12, 2014 at 9:43 AM, Janusz Dziedzic
>> >>> <janusz.dziedzic@tieto.com> wrote:
>> >>>> Handle AUTO bandwidth setting in db2rd.
>> >>>> Don't add NL80211_ATTR_FREQ_RANGE_MAX_BW attribute
>> >>>> in case of AUTO bw calculation.
>> >>>>
>> >>>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>> >>>
>> >>> Please elaborate more on this. Who deals with the automatic math on
>> >>> the bandwidth?
>> >>>
>> >> cfg80211,
>> >>
>> >> Please check patch:
>> >> cfg80211: regulatory introduce maximum bandwidth calculation
>> >
>> > OK, so we don't send the max bandwidth attribute now, what about
>> > support for older kernels?
>> >
>> Yes, seems we should send this even this is 0.
>> Next for old kernel, all channels where BW=0 will be HT20 only.
>
> Is that really a good idea?
>
> Maybe crda should just get the logic to determine maximum bandwidth,
> like you did in the kernel, and then we can even revert the kernel code
> again?
>
Yes, this is possible to calculate this in crda (or even set this manually).
In such case we have to remove this bw check in the kernel code:

is_valid_reg_rule(...)
    freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;

    if (freq_range->max_bandwidth_khz > freq_diff)
         return false;

BR
Janusz

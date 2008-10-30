Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:35513 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893AbYJ3OwA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 10:52:00 -0400
Received: by yx-out-2324.google.com with SMTP id 8so236508yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 07:51:59 -0700 (PDT)
Message-ID: <1ba2fa240810300751h5c1ba5e0mefc4fc89dbc7418e@mail.gmail.com> (sfid-20081030_155207_265648_521D69DE)
Date: Thu, 30 Oct 2008 16:51:58 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH for 2.6.28] mac80211: fix basic rates
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1225377700.3690.53.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225300446.5439.27.camel@johannes.berg>
	 <1ba2fa240810300623o51dbd0a6p7a7bc89795dc5d35@mail.gmail.com>
	 <1225376692.3690.46.camel@johannes.berg>
	 <1ba2fa240810300739m69ec943didc1d76b82da7f1e5@mail.gmail.com>
	 <1225377700.3690.53.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 30, 2008 at 4:41 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-10-30 at 16:39 +0200, Tomas Winkler wrote:
>> On Thu, Oct 30, 2008 at 4:24 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Thu, 2008-10-30 at 15:23 +0200, Tomas Winkler wrote:
>> >> On Wed, Oct 29, 2008 at 7:14 PM, Johannes Berg
>> >> <johannes@sipsolutions.net> wrote:
>> >> > This fixes the basic rate bitmap calculation in mac80211.
>> >> >
>> >> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> >> > Cc: stable@kernel.org [2.6.25, 2.6.26, 2.6.27]
>> >> > ---
>> >> > Is this appropriate for stable? It's a trivial and obvious fix, and can
>> >> > throw off the duration calculation, but it's likely nobody will ever
>> >> > really notice...
>> >>
>> >> You would should fail association if one of the basic rates is not
>> >> supported  by the station
>> >
>> > No, this has nothing to do with association, it's just setting the
>> > internal variable about which rates are basic in the BSS.
>>
>> I understand that but What your patch is doing it is preventing
>> of setting basic rates for ratest that are not sported by the driver,
>> but according
>> the spec it is not permissible that driver will not support one of the
>> basic rates.
>
> I don't understand. My patch is simply fixing the basic rate bitmap
> calculation. If we don't support all basic rates then the AP shall have
> denied the association, or we probably didn't even ask it.
>
> The current code there is just wrong, it will always set _all_ rates in
> the basic rate bitmap rather than just those that really are basic
> rates.

Oh, I now I got it out of index. What about coding it in more readable way?


for (i = 0; i < elems.supp_rates_len; i++) {
                int rate = (elems.supp_rates[i] & 0x7f) * 5;
                bool is_basic = !!(elems.supp_rates[i] & 0x80);

                if (rate > 110)
                        have_higher_than_11mbit = true;

                for (j = 0; j < sband->n_bitrates; j++) {
                        if (sband->bitrates[j].bitrate == rate) {
                                rates |= BIT(j);
                                if (is_basic)
                                        basic_rates |= BIT(j);
                                break;
                        }
                }
        }

Tomas

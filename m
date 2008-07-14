Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:8497 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbYGNWeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 18:34:21 -0400
Received: by an-out-0708.google.com with SMTP id d40so977541and.103
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2008 15:34:19 -0700 (PDT)
Message-ID: <43e72e890807141534s508f5485s8ac3e352c8453ae8@mail.gmail.com> (sfid-20080715_003428_145855_6D49607B)
Date: Mon, 14 Jul 2008 15:34:19 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH] Add new regulatory framework for Linux wireless
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"Jouni Malinen" <j@w1.fi>
In-Reply-To: <1ba2fa240807141445y327c0ce7t5f160ee66344d10b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080711123039.GP17936@ruslug.rutgers.edu>
	 <1ba2fa240807140321m2c111de1x38affda7de4f6f2d@mail.gmail.com>
	 <43e72e890807141339g5abbcf8cj78622e438087a659@mail.gmail.com>
	 <1ba2fa240807141445y327c0ce7t5f160ee66344d10b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 14, 2008 at 2:45 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Mon, Jul 14, 2008 at 11:39 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Mon, Jul 14, 2008 at 3:21 AM, Tomas Winkler <tomasw@gmail.com> wrote:
>>> I've submitted RFC patch for Country IE parsing in mac80211 as part of
>>> the work on 802.11h.  (TGh)
>>
>> I saw, I have to review it now with this in mind.
>>
>>> Q. How do you plan to merge CRDA and Country IE
>>
>> When a Country IE is received and parsed in mac80211 its up to
>> mac80211 then to decide what to do. As per the specification you
>> should use what the AP sends in the country IE but from what I am
>> seeing vendors tend to do different things with the Country IE. Some
>> considerations against parsing the Country IE and trusting it
>> completely is concerns about "rogue" APs. So as a compromise I was
>> thinking that initially we can simply call CRDA with the alpha2 passed
>> in the Country IE. Then later we can have it actually get the
>> intersection between what the AP provides and what CRDA has. The
>> driver will *always* have the ultimate say though through the callback
>> if it is registered. The callback will usually be used by vendor
>> drivers who have more stringent requirements on their regulatory
>> considerations. In the end though if trust is built around the data
>> CRDA provides it should be more than enough.
>
> If you use encryption u should probably trust the AP unless it's buggy.

I get the impression others think differently so perhaps we can leave
this as a tunable parameter, trust AP, use CRDA, or get the more
paranoid option would be to get the subset of both. What do you think?

>> Now these are just my observations so far. Please feel free to chime
>> in if there are better alternatives. We probably should take some time
>> to talk about this at OLS but for now that's what I'm aiming for.
>>
>
>>> where you will keep
>>> Country IE info cfg80211 or mac80211?
>>
>> That belongs in mac80211. You only need to tell cfg80211 the alpha2 so
>> it can query CRDA for you.
>
> I mean in case we use all the data from IE elements, should we have
> the placeholder for this in
> struct ieee80211_regdomain?

The Country IE is based on channels, the struct ieee80211_regdomain is
based on frequency ranges. We could have a regulatory rule for each
channel though so it is possible to use this structure for it. So yes,
we can use it. Once built it can be passed to cfg80211 using
set_reg(), which is what nl802111 uses.

  Luis

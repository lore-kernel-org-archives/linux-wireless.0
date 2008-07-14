Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:48071 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYGNVpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 17:45:46 -0400
Received: by py-out-1112.google.com with SMTP id p76so2869582pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2008 14:45:44 -0700 (PDT)
Message-ID: <1ba2fa240807141445y327c0ce7t5f160ee66344d10b@mail.gmail.com> (sfid-20080714_234550_226276_E6FE47E2)
Date: Tue, 15 Jul 2008 00:45:44 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] Add new regulatory framework for Linux wireless
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"Jouni Malinen" <j@w1.fi>
In-Reply-To: <43e72e890807141339g5abbcf8cj78622e438087a659@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080711123039.GP17936@ruslug.rutgers.edu>
	 <1ba2fa240807140321m2c111de1x38affda7de4f6f2d@mail.gmail.com>
	 <43e72e890807141339g5abbcf8cj78622e438087a659@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 14, 2008 at 11:39 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Mon, Jul 14, 2008 at 3:21 AM, Tomas Winkler <tomasw@gmail.com> wrote:
>> I've submitted RFC patch for Country IE parsing in mac80211 as part of
>> the work on 802.11h.  (TGh)
>
> I saw, I have to review it now with this in mind.
>
>> Q. How do you plan to merge CRDA and Country IE
>
> When a Country IE is received and parsed in mac80211 its up to
> mac80211 then to decide what to do. As per the specification you
> should use what the AP sends in the country IE but from what I am
> seeing vendors tend to do different things with the Country IE. Some
> considerations against parsing the Country IE and trusting it
> completely is concerns about "rogue" APs. So as a compromise I was
> thinking that initially we can simply call CRDA with the alpha2 passed
> in the Country IE. Then later we can have it actually get the
> intersection between what the AP provides and what CRDA has. The
> driver will *always* have the ultimate say though through the callback
> if it is registered. The callback will usually be used by vendor
> drivers who have more stringent requirements on their regulatory
> considerations. In the end though if trust is built around the data
> CRDA provides it should be more than enough.

If you use encryption u should probably trust the AP unless it's buggy.

> Now these are just my observations so far. Please feel free to chime
> in if there are better alternatives. We probably should take some time
> to talk about this at OLS but for now that's what I'm aiming for.
>

>> where you will keep
>> Country IE info cfg80211 or mac80211?
>
> That belongs in mac80211. You only need to tell cfg80211 the alpha2 so
> it can query CRDA for you.

I mean in case we use all the data from IE elements, should we have
the placeholder for this in
struct ieee80211_regdomain?

Tomas

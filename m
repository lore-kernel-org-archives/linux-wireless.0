Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:16179 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbYJ3OjG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 10:39:06 -0400
Received: by yw-out-2324.google.com with SMTP id 9so232244ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 07:39:04 -0700 (PDT)
Message-ID: <1ba2fa240810300739m69ec943didc1d76b82da7f1e5@mail.gmail.com> (sfid-20081030_153912_910164_5EC3FD76)
Date: Thu, 30 Oct 2008 16:39:03 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH for 2.6.28] mac80211: fix basic rates
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1225376692.3690.46.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225300446.5439.27.camel@johannes.berg>
	 <1ba2fa240810300623o51dbd0a6p7a7bc89795dc5d35@mail.gmail.com>
	 <1225376692.3690.46.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 30, 2008 at 4:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-10-30 at 15:23 +0200, Tomas Winkler wrote:
>> On Wed, Oct 29, 2008 at 7:14 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > This fixes the basic rate bitmap calculation in mac80211.
>> >
>> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> > Cc: stable@kernel.org [2.6.25, 2.6.26, 2.6.27]
>> > ---
>> > Is this appropriate for stable? It's a trivial and obvious fix, and can
>> > throw off the duration calculation, but it's likely nobody will ever
>> > really notice...
>>
>> You would should fail association if one of the basic rates is not
>> supported  by the station
>
> No, this has nothing to do with association, it's just setting the
> internal variable about which rates are basic in the BSS.

I understand that but What your patch is doing it is preventing
of setting basic rates for ratest that are not sported by the driver,
but according
the spec it is not permissible that driver will not support one of the
basic rates.

Tomas

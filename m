Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:14501 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbYKEUSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 15:18:16 -0500
Received: by yx-out-2324.google.com with SMTP id 8so109343yxm.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2008 12:18:15 -0800 (PST)
Message-ID: <43e72e890811051218u3306222fm360c8d9f15b2f384@mail.gmail.com> (sfid-20081105_211820_292859_A675802A)
Date: Wed, 5 Nov 2008 12:18:14 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 7/7] cfg80211/mac80211: Add Country IE parsing/802.11d support
Cc: linville@tuxdriver.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Felix Fietkau" <nbd@openwrt.org>
In-Reply-To: <1225916041.3619.168.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-7-git-send-email-lrodriguez@atheros.com>
	 <1225853406-16322-8-git-send-email-lrodriguez@atheros.com>
	 <1225887783.3619.108.camel@johannes.berg>
	 <43e72e890811050857p7a6e371dq96880853dc310741@mail.gmail.com>
	 <1225908658.3619.135.camel@johannes.berg>
	 <43e72e890811051124g3931e244i3e29c413a05c08f3@mail.gmail.com>
	 <1225914733.3619.150.camel@johannes.berg>
	 <43e72e890811051210x499dab3bhd4195f592c2aeaf2@mail.gmail.com>
	 <1225916041.3619.168.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 5, 2008 at 12:14 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-11-05 at 12:10 -0800, Luis R. Rodriguez wrote:
>
>> > Ok, checksums are nice to avoid having to memcmp large things, but
>> > afaict we're talking about maybe 12 bytes, right?
>>
>> Depends on the number of triplets, but since we only support 32 reg
>> rules this means we only support 32 triplets and therefore we only
>> support a max IE of size of 99 bytes (32 * 3 + 3). Realistically in JP
>> I expect there to be around 3, 4, or 5 or maybe even 6 triplets which
>> is 21 bytes.
>
> Alright, not so bad either though.
>
>> > If so, why don't we
>> > just keep a copy of the country IE and compare it fully every time?
>>
>> Eh. I'm inclined to leave the checksum then. We'd then have to bother
>> with freeing yet another thing later.
>
> Yeah, ok, I don't really care much, it just seemed the checksum
> complicated the code a bit. I guess much of that was due to the somewhat
> unnatural split between cfg80211 and mac80211 though.

Yeah good point, let me respin and we can see how it looks then with
this merged to cfg80211.

  Luis

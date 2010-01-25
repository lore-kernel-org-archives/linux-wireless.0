Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43854 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab0AYT4B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 14:56:01 -0500
Received: by pwi21 with SMTP id 21so2484430pwi.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 11:56:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264444418.23766.53.camel@johannes.local>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	<43e72e891001221120i79c6525bo4852cb5a6c7a37@mail.gmail.com>
	<1264189560.2593.14.camel@johannes.local> <43e72e891001221544j1b1bd67ao8dfcf4d0dd12dd81@mail.gmail.com>
	<1264205494.7208.7.camel@wwguy-ubuntu> <43e72e891001221623v477b9fady32237c1a3aededda@mail.gmail.com>
	<1264206170.7208.8.camel@wwguy-ubuntu> <1264250814.2593.25.camel@johannes.local>
	<43e72e891001251018h1a62e1ccn4a7d1411fa2c0615@mail.gmail.com>
	<1264444418.23766.53.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 25 Jan 2010 11:55:41 -0800
Message-ID: <43e72e891001251155l504a74fcpf20942682ca340c1@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>, Kalle Valo <kalle.valo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 25, 2010 at 10:33 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-01-25 at 10:18 -0800, Luis R. Rodriguez wrote:
>
>> > Yes, since 0 is nonsensical, we would use 1 instead.
>>
>> OK -- it seems we have a consensus waiting for a beacon would be good,
>> but it would be good to have something in for stable. Is the patch Guy
>> posted acceptable for that purpose? That is, merge this for now until
>> we get beacon wait implemented prior to association.
>
> Not sure we even need it in stable that badly? It seems it only hurts
> power consumption

Good point, we'd just be waking up at every beacon if power save is
enabled since the default is indeed 1.

> somewhat.

Depends how common this is. I am not sure what the usual DTIM value is
either though, but if its not 1 and this is indeed very common that'd
be a bit sloppy for stable.

> And I just implemented waiting today too.

I saw, you're the fucking man.

> Although Bob has a point, we could change the way we pass the DTIM
> period to the driver, only pass it in the powersave callbacks, and then
> we could associate without it and just enable powersave only after
> receiving a beacon. That assumes that drivers don't use it for anything
> else though, of course, but I don't see anything else you could use it
> for really.

Neat -- but that would mean doing the same for other beacon-sync IE
information. What other stuff goes out in beacons that does not go
into probe responses? I think I read a thread the other day about some
WPS information.

  Luis

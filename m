Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:62357 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZG1PWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 11:22:07 -0400
Received: by qyk34 with SMTP id 34so135950qyk.33
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2009 08:22:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248766646.8113.3.camel@johannes.local>
References: <1248744593-6597-1-git-send-email-lrodriguez@atheros.com>
	<1248766646.8113.3.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 28 Jul 2009 08:21:46 -0700
Message-ID: <43e72e890907280821o591e5d76v5c38471c5db66d7@mail.gmail.com>
Subject: Re: [RFC] cfg80211: send country ie processing on the reg_work struct
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 28, 2009 at 12:37 AM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Mon, 2009-07-27 at 18:29 -0700, Luis R. Rodriguez wrote:
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>
>> Did this in a flash, so just want to see if this is you like this
>> approach. Of course a lot of cleaning can be done here but ignore that
>> for now (like the fact that beacon hint doesn't really process IEs,
>> and the functions names used here).
>>
>> This just compiles for me, never tested it.
>
> Looks ok, but I don't see why you need this type enum?

To make it clear what type of beacon hint this is. I could have just
used an element in the struct reg_beacon but thought this would make
it more clear to the reader.

>> + * enum beacon_hint_type - type of regulatory beacon hint
>
> I mean -- if the beacon was received we could just process it as before,
> and if it also has a country IE we can just process that additionally?
> Why bother doing both separately?

I agree with you but this is different than addressing just the
lockdep warning and I wasn't really planning on doing that right now,
but it seems the work required may not be that much, I'll see if I can
just do it...

  Luis

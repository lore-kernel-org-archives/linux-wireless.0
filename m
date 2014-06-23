Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:48666 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaFWSe2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 14:34:28 -0400
Received: by mail-pb0-f49.google.com with SMTP id rr13so6176114pbb.36
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 11:34:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140623182623.GC1390@garbanzo.do-not-panic.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-4-git-send-email-arik@wizery.com> <CAB=NE6XTgcMWNHppF7WgZjqGCyaZSOJLF4FUC1hwVyyaBrJ79g@mail.gmail.com>
 <CA+XVXfedV=Frh8UmAzRfgPbOw8nq1Aa-Yr7QSgZTKe8h=bh78Q@mail.gmail.com> <20140623182623.GC1390@garbanzo.do-not-panic.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 23 Jun 2014 21:34:13 +0300
Message-ID: <CA+XVXffrepXAKitqhL4C87Jxy4MiF+iAO_PP6YZkMKtqeckV+Q@mail.gmail.com> (sfid-20140623_203431_864097_DF58FD1F)
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user hints
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 23, 2014 at 9:26 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Mon, Jun 23, 2014 at 08:14:43PM +0300, Arik Nemtsov wrote:
>> On Thu, Jun 19, 2014 at 2:34 AM, Luis R. Rodriguez
>> <mcgrof@do-not-panic.com> wrote:
>> > On Tue, Jun 10, 2014 at 11:55 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> >> Allow driver and user hints to set the "world" regulatory domain,
>> >
>> > NACK - as expressed in the other patch, letting the drivers to use the
>> > new API to set the world regulatory domain doesn't make sense as we
>> > have custom apply stuff, and the world regulatory domain is not
>> > something dynamic.
>>
>> Well we want to set the world regdomain from FW. This obviously
>> happens after wiphy registration, so I don't think the custom apply
>> can be used here? (since we generally want cfg80211 to own the
>> regdomain settings).
>
> Can the driver not obtain the world regulatory domain from firmware
> prior to wiphy registration? Why not?

Since the FW is not running yet :)

>
> One thing to be careful on all this new API design is to ensure that
> upon disconnect we want the driver to go back to the original state,
> whatever that is.

This particular part is unrelated to connection state AFAICT. It just
allows someone (driver, user) to set the "00" regdomain.

Arik

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35849 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965070AbaDJIRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 04:17:40 -0400
Received: by mail-pa0-f51.google.com with SMTP id kq14so3662229pab.38
        for <linux-wireless@vger.kernel.org>; Thu, 10 Apr 2014 01:17:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397116902.4757.6.camel@jlt4.sipsolutions.net>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
 <1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com>
 <1393852248.10039.5.camel@jlt4.sipsolutions.net> <CANrMYP6Rvv4EBjY9-78bdm70G_3YGZFrJH9tFz5XVsbSSi-m=Q@mail.gmail.com>
 <CAB=NE6X02Apk8XFt7yomQKwNoENvKAy1QbGBknQUGJ2ZDs73Gw@mail.gmail.com>
 <CANrMYP4GhDZZzYkyyVCHKpb7YvJzNbFZn77hZH9T+y7HTQ4R=w@mail.gmail.com>
 <CAB=NE6UHKptAvbt1OM4O_cRiCj2wyEKGF2fFPsO_rQ0EUZQahA@mail.gmail.com>
 <CAFED-j=OAMJzFkjgCDx8YMHpEWfpZ6h4UQSRK7DQigrNuaOSig@mail.gmail.com>
 <CAB=NE6UGWfZxU6zi=XzLKWeN+1aFgxTVUpr349FVHBsRgSGo+A@mail.gmail.com>
 <CANrMYP7Meef9rt4aX_EeREq0z7uRtT6oSB6pjE3AqeHMx1GwJw@mail.gmail.com>
 <CA+XVXffzFWsJOU+PLWkeoce1+dDvrqruyi3_GG7V-6dfWpK7gA@mail.gmail.com>
 <1397071009.4964.18.camel@jlt4.sipsolutions.net> <CA+XVXfdekoT_jhVL_vpjJSPPD5hAjyprUB+g4kAN2Nssv=9-Ng@mail.gmail.com>
 <1397116902.4757.6.camel@jlt4.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 10 Apr 2014 11:17:24 +0300
Message-ID: <CA+XVXfdY65-7S-Hs1vAYSVx05wN98Q-5hmFTrhOduzKkVOdGCA@mail.gmail.com> (sfid-20140410_101746_559796_42FA4670)
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non modular
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Colleen T <colleen@cozybit.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sander Eikelenboom <linux@eikelenboom.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 10, 2014 at 11:01 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2014-04-10 at 09:13 +0300, Arik Nemtsov wrote:
>> On Wed, Apr 9, 2014 at 10:16 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > +static void reg_free_last_request(struct regulatory_request *lr)
>> >
>> > Isn't it odd to pass the last request to a function called
>> > reg_free_last_request()?
>> >
>>
>> It makes sense to me. Non-last requests are freed using kfree. The
>> last request needs RCU.
>
> Yeah but there can only be one "last request", so why pass it?

oh. well that was weird before as well. :)
let's wait to see if it solves the bug? I can respin it without the arg later.

Arik

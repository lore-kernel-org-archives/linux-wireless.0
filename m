Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:63635 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaFRV6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2014 17:58:54 -0400
Received: by mail-lb0-f171.google.com with SMTP id s7so929291lbd.16
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2014 14:58:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfcU0rG7Qtchsjgp2yOYPng6oxDjPLQ3tpjKHurZTJCXOw@mail.gmail.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-2-git-send-email-arik@wizery.com> <53980647.2070600@broadcom.com>
 <CA+XVXfcU0rG7Qtchsjgp2yOYPng6oxDjPLQ3tpjKHurZTJCXOw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 18 Jun 2014 14:58:32 -0700
Message-ID: <CAB=NE6UvGSxqxwa+wJ83t8uogdBSnXn2SLY-mP-Xmgxw_fm+Lw@mail.gmail.com> (sfid-20140618_235858_231076_1CBDDDD8)
Subject: Re: [PATCH 2/5] cfg80211: allow drivers to provide regulatory settings
To: Arik Nemtsov <arik@wizery.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2014 at 1:45 AM, Arik Nemtsov <arik@wizery.com> wrote:
> On Wed, Jun 11, 2014 at 10:33 AM, Arend van Spriel <arend@broadcom.com> wrote:
>> On 11-06-14 08:55, Arik Nemtsov wrote:
>>>
>>> Define a new wiphy callback allowing drivers to provide regulatory
>>> settings.
>>>
>>> Only The first wiphy registered with this callback will be able to provide
>>> regulatory domain info. If such a wiphy exists, it takes precedence over
>>> other data sources.
>>
>>
>> I should probably dig through linux-wireless archive for background info,
>> but how is this different from the wiphy_apply_custom_regulatory() call. Is
>> this for devices that have a regulatory database of sorts in the device
>> firmware?
>>
> Yea that's basically it. And we want the get the info dynamically from
> FW upon country changes.

Currently a few drivers exist that have regulatory data in firmware
and what we end up doing is allowing that through the usage of the
custom flag and then having the reg_notififer() poke firmware and and
ensure its OK with all the changes. It however has no way to then
splat data from firmware onto the wiphy dynamically, and although this
could be done through the custom firmware thing that is only for
initialization and before registration. Having the API explicit should
also allow us to extract vendor's regulatory data and then do our own
serialized analysis of regulatory data to populate the public regdb.
Using the firmware regulatory data is an architecture that is plain
stupid and non-scalable so if people want to shoot themsevles on the
foot with that stupidity I think its fine to let it through so long as
we can extract their regulatory data, which this helps accomplish.

Let the best firmware design win.

  Luis

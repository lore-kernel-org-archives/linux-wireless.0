Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62301 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaK3M1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2014 07:27:06 -0500
Received: by mail-wg0-f45.google.com with SMTP id b13so11994124wgh.32
        for <linux-wireless@vger.kernel.org>; Sun, 30 Nov 2014 04:27:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141128220020.GX25677@wotan.suse.de>
References: <1417074298-12254-1-git-send-email-arik@wizery.com>
 <1417074298-12254-2-git-send-email-arik@wizery.com> <1417182387.27562.8.camel@sipsolutions.net>
 <20141128220020.GX25677@wotan.suse.de>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 30 Nov 2014 14:26:49 +0200
Message-ID: <CA+XVXffyFiqE31KLN2Os1Uu5z9FrFPXXs0Qs_D+OEfnqjgd8uQ@mail.gmail.com> (sfid-20141130_132710_974231_D8522B49)
Subject: Re: [PATCH v5 2/4] cfg80211: allow usermode to query wiphy specific regdom
To: "Luis R. Rodriguez" <mcgrof@suse.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 29, 2014 at 12:00 AM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Fri, Nov 28, 2014 at 02:46:27PM +0100, Johannes Berg wrote:
>> On Thu, 2014-11-27 at 09:44 +0200, Arik Nemtsov wrote:
>> > If a wiphy-idx is specified, the kernel will return the wiphy specific
>> > regdomain, if such exists. Otherwise return the global regdom.
>> >
>> > When no wiphy-idx is specified, return the global regdomain as well as
>> > all wiphy-specific regulatory domains in the system, via a new nested
>> > list of attributes.
>>
>> Is that really a good idea? Seems rather easy to overrun the message
>> size with that, in which case your current code will not return anything
>> at all... that'll cause strange errors if somebody plugs in a few
>> devices or has hwsim open as well or so ...
>
> Good point, perhaps require 'iw reg get --all' for all listing then?
> This would mean requiring an new optional flag passed on reg get too
> then.

I think Johannes' point was that it's easy to overrun the message size
if there are a lot of wiphys.
So I'll simply add an iterator over all wiphys in "iw reg get" and
kernel-mode will only return a single regdomain in each GET_REG
invocation.

About the "--all" suggestion - I think it's fine to not have backward
compatibility in the output of "iw reg get"? So we can just output the
global first, and then output private regdoms for all wiphys that have
them.

Does that sound ok?

>
>> > Add a new attribute for each wiphy-specific regdomain, for usermode to
>> > identify it as such.
>>
>> Shouldn't userspace also *request* this for backward compatibility?
>> Otherwise older userspace might assume that a returned regd applies to
>> everything, when it doesn't really?
>
> If the flag --all is used and passed then I see no issue.

Well you have to give a wiphy-idx in order to get a private regdom in
the first place. And only new userspace will add a wiphy-idx in the
first place..

Also, when a global regdom is returned for a given wiphy-idx instead
of a private one, it is valid, since the global one is being used for
this wiphy.
If there is a private regdom (from regulatory_hint()) then we'll
return it to usermode. This is less restrictive than the global one,
and that's the one being used for channel verification for this wiphy.

Arik

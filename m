Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43246 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab2F0PU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 11:20:59 -0400
Received: by pbbrp8 with SMTP id rp8so1691495pbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 08:20:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340807890.11012.43.camel@jlt3.sipsolutions.net>
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
 <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com>
 <1340707305.14634.9.camel@jlt3.sipsolutions.net> <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com>
 <CA+XVXffLy5mSqXTtEh7STC_xtSKOJTdtVF9jGPj5UEQ88wD+LQ@mail.gmail.com>
 <1340795869.11012.12.camel@jlt3.sipsolutions.net> <CA+XVXfcNpj_UqCOXUG7sr2MQH8qZNHYr7MfBz5J3vwC3f+KU6Q@mail.gmail.com>
 <1340807890.11012.43.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 27 Jun 2012 18:20:43 +0300
Message-ID: <CA+XVXffqiwJ1+2mjrutQHbAKrF6FPChHW2+gVPMYsbX1pkd52Q@mail.gmail.com> (sfid-20120627_172109_481011_E7F82203)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eliad Peller <eliad@wizery.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 27, 2012 at 5:38 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-06-27 at 14:27 +0300, Arik Nemtsov wrote:
>> On Wed, Jun 27, 2012 at 2:17 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Tue, 2012-06-26 at 14:35 +0300, Arik Nemtsov wrote:
>> >
>> >> Can you give a bit more info on the Tx-sync approach, for the uninitiated?
>> >> I'm also thinking that maybe we could somehow treat the sleeping-GO as
>> >> a special case (maybe with some special code and a HW flag). Right now
>> >> I'm not sure the wl12xx FW even supports it.
>> >
>> > I basically had a simpler version in mind, something like this:
>> > http://p.sipsolutions.net/cd928e926a941ac7.txt
>>
>> If the low level driver has to prepare for each such Tx, that's fine.
>
> If it doesn't, then it can de-duplicate itself I guess? And it can also
> abort everything (if needed) when the bssid is cleared (failure) or when
> we go into associated (success), so I didn't add an explicit cancel
> operation.

Ok.

>
>> But does this somehow rely on the timing of the Tx? Relying on op_tx
>> to come right after this seems racy.
>
> It'll depend on the driver I guess? If you're going to set a flag "give
> this vif priority now" on the first invocation, then you probably
> wouldn't care about the timing. It looks like our implementation would
> actually start some "give me the channel" operation and when the
> firmware says "ok you have the channel now" we'd return and rely on
> getting the TX right after.
>
> Wrt. the race, this isn't going to be something that happens within less
> than a millisecond or so, it's going to give us maybe 50ms at least of
> channel time (WFA mandates replying within 30ms), so that doesn't seem
> like a problem?

It's probably not an issue. Just seems simpler to just give the skb to
the driver so it can do whatever it wants before/during/after. Bypass
op_tx completely for these.

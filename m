Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37558 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab2FZLf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 07:35:28 -0400
Received: by dady13 with SMTP id y13so6687393dad.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 04:35:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com>
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
 <CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com>
 <1340707305.14634.9.camel@jlt3.sipsolutions.net> <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 26 Jun 2012 14:35:12 +0300
Message-ID: <CA+XVXffLy5mSqXTtEh7STC_xtSKOJTdtVF9jGPj5UEQ88wD+LQ@mail.gmail.com> (sfid-20120626_133606_648686_46642033)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
To: Johannes Berg <johannes@sipsolutions.net>,
	Eliad Peller <eliad@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 26, 2012 at 2:18 PM, Eliad Peller <eliad@wizery.com> wrote:
> On Tue, Jun 26, 2012 at 1:41 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2012-06-26 at 13:09 +0300, Eliad Peller wrote:
>>
>>> > With multi-channel, one problem that we get is managing the channel
>>> > timing for authentication/association. We'll have bound the channel
>>> > context (once we have that) before we even send a frame of course, but
>>> > setting up the timing as to when to use the channel is very hard, in
>>> > particular for connections to P2P GOs that might potentially be asleep.
>>> >
>>> the other scenario we should have in mind here is the AP side - making
>>> sure we'll be able to auth/assoc a new station.
>>
>> Yes, we should keep that in mind, but I have a feeling that we should
>> treat it separately. It's quite different as mac80211 is doing a lot
>> less -- for example, mac80211 is managing retries, comeback timeouts,
>> etc. in the managed case.
>>
> i guess it makes sense. i just don't like it being managed in multiple
> places (userspace for ap, kernel for sta).

I also think managing this in multiple places can get messy. I
slightly prefer Eliad's approach with userspace giving the ROCs, since
it sees the bigger picture.

But all userspace changes are reflected in the STA flags in kernel, so
we can do STA + AP from kernel mode as well.

Can you give a bit more info on the Tx-sync approach, for the uninitiated?
I'm also thinking that maybe we could somehow treat the sleeping-GO as
a special case (maybe with some special code and a HW flag). Right now
I'm not sure the wl12xx FW even supports it.

Arik

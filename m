Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43097 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2FZLSo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 07:18:44 -0400
Received: by obbuo13 with SMTP id uo13so7885176obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 04:18:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340707305.14634.9.camel@jlt3.sipsolutions.net>
References: <1340640308.27437.16.camel@jlt3.sipsolutions.net>
	<CAB3XZEe7t3MYVv6Bja9X315CuhWa=aaEyB82pGp_9hMp8grbMg@mail.gmail.com>
	<1340707305.14634.9.camel@jlt3.sipsolutions.net>
Date: Tue, 26 Jun 2012 14:18:44 +0300
Message-ID: <CAB3XZEfEB2TaeN4EYGyBmcuh823EfmdLhSWE55u5OwPE+Ff7oQ@mail.gmail.com> (sfid-20120626_131848_223845_33D4F540)
Subject: Re: mac80211 auth/assoc in multi-channel scenarios
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 26, 2012 at 1:41 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-06-26 at 13:09 +0300, Eliad Peller wrote:
>
>> > With multi-channel, one problem that we get is managing the channel
>> > timing for authentication/association. We'll have bound the channel
>> > context (once we have that) before we even send a frame of course, but
>> > setting up the timing as to when to use the channel is very hard, in
>> > particular for connections to P2P GOs that might potentially be asleep.
>> >
>> the other scenario we should have in mind here is the AP side - making
>> sure we'll be able to auth/assoc a new station.
>
> Yes, we should keep that in mind, but I have a feeling that we should
> treat it separately. It's quite different as mac80211 is doing a lot
> less -- for example, mac80211 is managing retries, comeback timeouts,
> etc. in the managed case.
>
i guess it makes sense. i just don't like it being managed in multiple
places (userspace for ap, kernel for sta).

>> > I haven't been able to come up with any other ways, and here we really
>> > don't have much of a choice -- #1 is the only thing that seems sane to
>> > me. Thoughts?
>>
>> our current approach is making the kernel part as simple as possible,
>> and let userspace handle the channel management.
>> before authentication (or after getting auth request in the ap case)
>> the supplicant requests the kernel to "give priority" to a specific
>> vif. it's up to the low-level driver to decide on the right way to do
>> it (internally we implement it with ROC on the specified vif).
>
> I'm pretty much happy with that for the AP case, but given how much
> mac80211 really manages for auth/assoc I don't think it makes sense in
> the managed case.
>
i think that's true for open networks, but for encrypted ones the
EAPOLs are not handled by mac80211, which pretty much complicates the
flow.

>> the con here is that this might result in the channel being reserved
>> for a pretty long time (retransmits, etc.), but that's why we refer it
>> as setting "priority" rather than actual channel reservation. if the
>> fw has to do other things (e.g. beacon on each beacon interval) it
>> will do it, even though we asked it to ROC on a different channel.
>
> That seems highly implementation-dependent :-)
> The point with that though is that I think it shouldn't be necessary to
> have a firmware implementation that does this.
>
well, i'm not really sure whether our fw is doing it, but that was the plan :)

>> also, when waiting for EAPOLs after association you might have to
>> reserve the channel for a pretty long time anyway (since you still
>> can't enter ps, and some APs don't send the first EAPOL immediately).
>
> Yeah, but you might only want to wait a little bit and then stop doing
> ROC and actually enter PS mode if the AP is really slow, etc. That can
> pretty much be managed from the STA state though since once you're
> associated you're past the bit where mac80211 is doing a lot?
>
you can't enter ps while you are not authorized (it's probably not
forbidden by the spec, but i'm pretty sure some APs won't like it).
managing it from the STA state doesn't make much sense to me (why add
another management point?), and if you're going to handle it from
userspace, well... just do it from the beginning :)

Eliad.

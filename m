Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:39966 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758AbZCZIkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 04:40:23 -0400
Received: by rv-out-0506.google.com with SMTP id f9so520186rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 01:40:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87iqlw4rx7.fsf@litku.valot.fi>
References: <1237891149.4320.73.camel@johannes.local> <1237910398.9082.7.camel@localhost.localdomain>
	<1237979070.4320.156.camel@johannes.local> <1237995072.18896.9.camel@localhost.localdomain>
	<1237996137.4320.161.camel@johannes.local> <43e72e890903260100w75896d0fi9121f227cc7ca8dc@mail.gmail.com>
	<87iqlw4rx7.fsf@litku.valot.fi>
Date: Thu, 26 Mar 2009 01:40:04 -0700
Message-ID: <43e72e890903260140i751ca59dg7ec9c8d870da0006@mail.gmail.com> (sfid-20090326_094044_222514_0FB50AFA)
Subject: Re: wireless powersaving (in NM?)
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 26, 2009 at 1:19 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> "Luis R. Rodriguez" <mcgrof@gmail.com> writes:
>
>> On Wed, Mar 25, 2009 at 8:48 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>>> On Wed, 2009-03-25 at 11:31 -0400, Dan Williams wrote:
>>>
>>>> Yeah, sounds OK. =C2=A0Just to be clear, problems with this code w=
ill appear
>>>> on a *per-AP* basis, not a per-card basis, right? =C2=A0ie there a=
re some
>>>> stupid APs that won't work with it, but it won't be the case that =
a
>>>> chipset will be broken for all APs, right?
>>>
>>> Right. If a particular chipset doesn't properly supported PS then w=
e
>>> shouldn't actually support it at all -- but we cannot know if the A=
P is
>>> broken.
>>
>> How about leaving it to the supplicant to guess if the AP is borked =
or not.
>
> Very difficult and not worth the trouble IMHO.
>
>> Kalle, what would happen with these broken APs?
>
> Usually there's packet loss and for the user it shows as data
> connections not working reliably.
>
>> If we can determine this through some heuristics then we can label
>> such BSSes as borked in the supplicant and then the user won't have =
to
>> worry about this. This would only be dealt with each BSS once at mos=
t
>> as we would have saved the AP's power save borkedness after our firs=
t
>> determination of this.
>>
>> If one wants to do manual debugging you can simple add the flag
>> through the supplicant for the bss. Just don't see the need to confu=
se
>> a user with an option if we can get away with figuring it out if
>> possible.
>
> If the ui option to disable power is disliked, just hide it somewhere=
=2E
> For example, a gconf flag which can be enabled with a command line
> tool.

Oh I don't care for it, I just don't think its a good idea to be
adding more knobs and agree with the general sentiment to always focus
on saving power.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

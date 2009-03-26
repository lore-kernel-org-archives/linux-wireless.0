Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62508 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbZCZITz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 04:19:55 -0400
Received: by fxm2 with SMTP id 2so414977fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 01:19:52 -0700 (PDT)
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>,
	"Guy\, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>, Jouni Malinen <j@w1.fi>
Subject: Re: wireless powersaving (in NM?)
References: <1237891149.4320.73.camel@johannes.local>
	<1237910398.9082.7.camel@localhost.localdomain>
	<1237979070.4320.156.camel@johannes.local>
	<1237995072.18896.9.camel@localhost.localdomain>
	<1237996137.4320.161.camel@johannes.local>
	<43e72e890903260100w75896d0fi9121f227cc7ca8dc@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 26 Mar 2009 10:19:48 +0200
In-Reply-To: <43e72e890903260100w75896d0fi9121f227cc7ca8dc@mail.gmail.com> (Luis R. Rodriguez's message of "Thu\, 26 Mar 2009 01\:00\:31 -0700")
Message-ID: <87iqlw4rx7.fsf@litku.valot.fi> (sfid-20090326_092000_039752_D3DCDEC4)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> writes:

> On Wed, Mar 25, 2009 at 8:48 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Wed, 2009-03-25 at 11:31 -0400, Dan Williams wrote:
>>
>>> Yeah, sounds OK. =A0Just to be clear, problems with this code will =
appear
>>> on a *per-AP* basis, not a per-card basis, right? =A0ie there are s=
ome
>>> stupid APs that won't work with it, but it won't be the case that a
>>> chipset will be broken for all APs, right?
>>
>> Right. If a particular chipset doesn't properly supported PS then we
>> shouldn't actually support it at all -- but we cannot know if the AP=
 is
>> broken.
>
> How about leaving it to the supplicant to guess if the AP is borked o=
r not.

Very difficult and not worth the trouble IMHO.

> Kalle, what would happen with these broken APs?

Usually there's packet loss and for the user it shows as data
connections not working reliably.

> If we can determine this through some heuristics then we can label
> such BSSes as borked in the supplicant and then the user won't have t=
o
> worry about this. This would only be dealt with each BSS once at most
> as we would have saved the AP's power save borkedness after our first
> determination of this.
>
> If one wants to do manual debugging you can simple add the flag
> through the supplicant for the bss. Just don't see the need to confus=
e
> a user with an option if we can get away with figuring it out if
> possible.

If the ui option to disable power is disliked, just hide it somewhere.
=46or example, a gconf flag which can be enabled with a command line
tool.

--=20
Kalle Valo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

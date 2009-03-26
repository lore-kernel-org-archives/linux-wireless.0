Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:1765 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbZCZIAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 04:00:48 -0400
Received: by wf-out-1314.google.com with SMTP id 29so538608wff.4
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 01:00:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237996137.4320.161.camel@johannes.local>
References: <1237891149.4320.73.camel@johannes.local> <1237910398.9082.7.camel@localhost.localdomain>
	<1237979070.4320.156.camel@johannes.local> <1237995072.18896.9.camel@localhost.localdomain>
	<1237996137.4320.161.camel@johannes.local>
Date: Thu, 26 Mar 2009 01:00:31 -0700
Message-ID: <43e72e890903260100w75896d0fi9121f227cc7ca8dc@mail.gmail.com> (sfid-20090326_090246_472176_9DDA23B4)
Subject: Re: wireless powersaving (in NM?)
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 25, 2009 at 8:48 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-03-25 at 11:31 -0400, Dan Williams wrote:
>
>> Yeah, sounds OK. =C2=A0Just to be clear, problems with this code wil=
l appear
>> on a *per-AP* basis, not a per-card basis, right? =C2=A0ie there are=
 some
>> stupid APs that won't work with it, but it won't be the case that a
>> chipset will be broken for all APs, right?
>
> Right. If a particular chipset doesn't properly supported PS then we
> shouldn't actually support it at all -- but we cannot know if the AP =
is
> broken.

How about leaving it to the supplicant to guess if the AP is borked or =
not.

Kalle, what would happen with these broken APs?

If we can determine this through some heuristics then we can label
such BSSes as borked in the supplicant and then the user won't have to
worry about this. This would only be dealt with each BSS once at most
as we would have saved the AP's power save borkedness after our first
determination of this.

If one wants to do manual debugging you can simple add the flag
through the supplicant for the bss. Just don't see the need to confuse
a user with an option if we can get away with figuring it out if
possible.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

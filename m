Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f160.google.com ([209.85.217.160]:35220 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762163AbZCYRls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 13:41:48 -0400
Received: by gxk4 with SMTP id 4so352537gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 10:41:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200903260337.37783.kel@otaku42.de>
References: <43e72e890903250009hbe7bcfal546dddf731820b8e@mail.gmail.com>
	<43e72e890903250047o6a4ed5cfm4ebb849013e9d571@mail.gmail.com>
	<43e72e890903250051j44955276j42fce045c5079b87@mail.gmail.com>
	<200903260337.37783.kel@otaku42.de>
Date: Wed, 25 Mar 2009 10:41:30 -0700
Message-ID: <43e72e890903251041r657a5217q9af7b5eb34f2f824@mail.gmail.com> (sfid-20090325_184153_425610_40C0BB72)
Subject: Re: [renamed] Debian crda?
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Kel Modderman <kel@otaku42.de>
Cc: debian-devel@lists.debian.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Tim Gardner <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 25, 2009 at 10:37 AM, Kel Modderman <kel@otaku42.de> wrote:
> On Wednesday 25 March 2009 17:51:41 Luis R. Rodriguez wrote:
>> On Wed, Mar 25, 2009 at 12:47 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> > On Wed, Mar 25, 2009 at 12:39 AM, Paul Wise <pabs@debian.org> wrote:
>> >> On Wed, Mar 25, 2009 at 4:09 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> >>
>> >>> Last time I poked them it seemed it was not easy to figure out how to
>> >>> deal with, if at all, the optional but recommended RSA signature stuff
>> >>> [1] with the DFSG.
>> >>>
>> >>> [1] http://wireless.kernel.org/en/developers/Regulatory#RSADigitalSignature
>> >>
>> >> What is the percieved DFSG/RSA conflict? I can't detect any based on
>> >> that section of the page.
>> >
>> > Thanks Paul, then its just a matter of packaging. There is an
>> > debian-example/ directory with a cdbs example of how to package for
>> > wireless-regdb and crda if anyone is up for it.
>
> The example packaging needs some love, I think. I don't see it as a great
> reference to the eventual packaging material that would enter Debian.
>
>>
>> And as its probably best to coordinate with Ubuntu, they have a
>> wireless-crda package which combines both into one package. Its
>> shipping for Jaunty.
>
> And that's the only way to sanely package it (by combining the two pieces
> upstream splits) as show by Fedora also choosing that route.

Well I actually disagree.

> Luis why can't CRDA and regd simply be released in same tarball considering
> they have such a strong relationship with eachother due to the openssl stuff?

Openssl stuff is optional and in fact not the lib chosen by default,
libgcrypt is the default though.

The point is that crda won't be updated regularly but the
wireless-regdb will be. No point in updating a binary when only the
file it reads is the one that changes.

  Luis

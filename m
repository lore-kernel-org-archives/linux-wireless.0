Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f222.google.com ([209.85.217.222]:54645 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZBPJY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 04:24:26 -0500
Received: by gxk22 with SMTP id 22so2831876gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 01:24:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234775709.4219.111.camel@johannes.local>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-7-git-send-email-lrodriguez@atheros.com>
	 <1234695674.4219.50.camel@johannes.local>
	 <43e72e890902160018r40d8c694qa1da55c9fa7ec376@mail.gmail.com>
	 <1234774345.4219.106.camel@johannes.local>
	 <43e72e890902160109i386d78bydd36f182ed3e6dcd@mail.gmail.com>
	 <1234775709.4219.111.camel@johannes.local>
Date: Mon, 16 Feb 2009 01:24:24 -0800
Message-ID: <43e72e890902160124v2f36f7e1y70b0273cc456b916@mail.gmail.com> (sfid-20090216_102429_590484_52AC488F)
Subject: Re: [PATCH 06/10] cfg80211: propagate -ENOMEM during
	regulatory_init()
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2009 at 1:15 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-02-16 at 01:09 -0800, Luis R. Rodriguez wrote:
>
>> We're strictly checking just for ENOMEMs which if you are getting will
>> get you into problems anyway so might as well propagate that
>> information.
>>
>> kobject_uevent_env() can fail for a short set of other non-memory
>> related issues and those are the cases we are ignoring here including
>> the possible call to call_usermodehelper() during early boot (which
>> I'm not even sure how likely it is, Greg?).
>>
>> >, and then how is it different from crda
>> > failing in userspace to warrant stopping cfg80211 from moving on?
>>
>> This is based on the premise that we are simply bailing out for all
>> conditions on the creation of a udev event but that is not the case --
>> prior to this we were disregarding -ENOMEMs which I do not believe is
>> correct. Why wouldn't you want to propagate that?
>
> Dunno, it just seems pointless to check for an error condition that
> covers so few of the possible ways to fail here.

RIght -- I hear ya, I am not sure how critical the other failures in
kobject_uevent_env() are compared to -ENOMEM so this is why I didn't
just propagate all errors and since one user already reported
kobject_uevent_env() failing during initialization I was hesitant to
simply let cfg80211 not be loaded because of this routine's failure.

On the other hand, if we let -ENOMEM be propagated I believe it would
be easier to narrow down failures of kobject_uevent_env() during
intialization but I have to understand exactly how common those other
possible failure are and for what reason.

  Luis

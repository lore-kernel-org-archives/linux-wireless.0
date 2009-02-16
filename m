Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:6169 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbZBPJJm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 04:09:42 -0500
Received: by yx-out-2324.google.com with SMTP id 8so922669yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 01:09:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234774345.4219.106.camel@johannes.local>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-7-git-send-email-lrodriguez@atheros.com>
	 <1234695674.4219.50.camel@johannes.local>
	 <43e72e890902160018r40d8c694qa1da55c9fa7ec376@mail.gmail.com>
	 <1234774345.4219.106.camel@johannes.local>
Date: Mon, 16 Feb 2009 01:09:41 -0800
Message-ID: <43e72e890902160109i386d78bydd36f182ed3e6dcd@mail.gmail.com> (sfid-20090216_100949_902767_02DE8996)
Subject: Re: [PATCH 06/10] cfg80211: propagate -ENOMEM during
	regulatory_init()
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2009 at 12:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-02-16 at 00:18 -0800, Luis R. Rodriguez wrote:
>
>> > I disagree with this patch -- there's so much that can go wrong even if
>> > allocating the message here is ok that imho it's hardly useful to check
>> > for errors here.
>>
>> Huh?? ENOMEM is the only error we are propagating  -- that itself
>> seems reasonable to propagate.
>>
>> > crda could fail, not be installed, etc.
>>
>> This is never propagated to the kernel, that is not what this patch
>> does. Those failures you mentioned should not prevent cfg80211 from
>> moving on.
>>
>> All this patch does is propagate -ENOMEMs.
>
> Yes, all those other possible crda failures do not prevent cfg80211 from
> moving on. But being unable to create a uevent could very well also be
> treated as a crda failure

We're strictly checking just for ENOMEMs which if you are getting will
get you into problems anyway so might as well propagate that
information.

kobject_uevent_env() can fail for a short set of other non-memory
related issues and those are the cases we are ignoring here including
the possible call to call_usermodehelper() during early boot (which
I'm not even sure how likely it is, Greg?).

>, and then how is it different from crda
> failing in userspace to warrant stopping cfg80211 from moving on?

This is based on the premise that we are simply bailing out for all
conditions on the creation of a udev event but that is not the case --
prior to this we were disregarding -ENOMEMs which I do not believe is
correct. Why wouldn't you want to propagate that?

  Luis

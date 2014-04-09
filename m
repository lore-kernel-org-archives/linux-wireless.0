Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:46533 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964922AbaDIU22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 16:28:28 -0400
Date: Wed, 9 Apr 2014 22:28:23 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <884167022.20140409222823@eikelenboom.it> (sfid-20140409_222831_582498_AF64D53C)
To: Arik Nemtsov <arik@wizery.com>
CC: Colleen T <colleen@cozybit.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non modular
In-Reply-To: <CA+XVXffzFWsJOU+PLWkeoce1+dDvrqruyi3_GG7V-6dfWpK7gA@mail.gmail.com>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com> <1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com> <1393852248.10039.5.camel@jlt4.sipsolutions.net> <CANrMYP6Rvv4EBjY9-78bdm70G_3YGZFrJH9tFz5XVsbSSi-m=Q@mail.gmail.com> <CAB=NE6X02Apk8XFt7yomQKwNoENvKAy1QbGBknQUGJ2ZDs73Gw@mail.gmail.com> <CANrMYP4GhDZZzYkyyVCHKpb7YvJzNbFZn77hZH9T+y7HTQ4R=w@mail.gmail.com> <CAB=NE6UHKptAvbt1OM4O_cRiCj2wyEKGF2fFPsO_rQ0EUZQahA@mail.gmail.com> <CAFED-j=OAMJzFkjgCDx8YMHpEWfpZ6h4UQSRK7DQigrNuaOSig@mail.gmail.com> <CAB=NE6UGWfZxU6zi=XzLKWeN+1aFgxTVUpr349FVHBsRgSGo+A@mail.gmail.com> <CANrMYP7Meef9rt4aX_EeREq0z7uRtT6oSB6pjE3AqeHMx1GwJw@mail.gmail.com> <CA+XVXffzFWsJOU+PLWkeoce1+dDvrqruyi3_GG7V-6dfWpK7gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Wednesday, April 9, 2014, 6:33:09 PM, you wrote:

> Hey Collen, Luis,

> On Sun, Mar 16, 2014 at 9:04 PM, Colleen T <colleen@cozybit.com> wrote:
>> On Sat, Mar 15, 2014 at 9:42 PM, Luis R. Rodriguez
>> <mcgrof@do-not-panic.com> wrote:
>>> On Sat, Mar 15, 2014 at 8:59 AM, Janusz Dziedzic
>>> <janusz.dziedzic@gmail.com> wrote:
>>>> 2014-03-15 2:03 GMT+01:00 Luis R. Rodriguez <mcgrof@do-not-panic.com>:
>>>>> On Fri, Mar 14, 2014 at 3:12 PM, Colleen T <colleen@cozybit.com> wrote:
>>>>>> I'm on mac80211-next/master, sha is
>>>>>> 5a970df8990d173e7e4092952f2e3da1de69b27d
>>>>>
>>>>> I tried to reproduce by just merging the fixes in question onto Linus'
>>>>> tree and using radios=3 but no go. Can you provide the full kernel
>>>>> log, I'm particularly interested in what happened before. The
>>>>> COUNTRY=US on debian, which I believe you're on, should just trigger a
>>>>> regulatory domain setting to US upon initialization. Depending on how
>>>>> Debian does it this could either trigger as a module parameter or as a
>>>>> userspace event *after* the world regdom get set.
>>
>> I'm attaching a full kernel log that shows the warning being
>> triggered.  You are correct, I'm on debian.  In the attached case I
>> ran:
>> $ modprobe mac80211_hwsim radios=4
>>  I pulled the fixes onto Linus' tree and I end up with the same result.
>>

> Seems I might have found the culprit - reg_todo is called while the
> request to CRDA is in flight and the patch in question causes the
> already-in-process user-request to be handled again. Since it's the
> same regdomain as the last request (it's the last request itself), we
> get this:

> treatment = __reg_process_hint_user(user_request);
> if (treatment == REG_REQ_IGNORE ||
>    treatment == REG_REQ_ALREADY_SET) {
> kfree(user_request); <------
> return treatment;
> }

> Can you try adding the attached patch? It just replaced relevant
> kfree-s with a function that avoids freeing the last request.

> Also, in the current scheme of things, CRDA might be called twice for
> the same request in some corner cases, but that's not a problem, since
> reg_is_valid_request() will block the second set_regdom().

> Regards,
> Arik

Thanks for looking in to this .. hope that this will make it go to upstream one 
day :-)


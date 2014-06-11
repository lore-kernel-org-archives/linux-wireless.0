Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:46975 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaFKGjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 02:39:13 -0400
Received: by mail-pb0-f47.google.com with SMTP id un15so1690122pbc.6
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 23:39:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFED-j=WEkKiEmKBWjbfWCZbu7952JzEGwNt93XCow7565f1dQ@mail.gmail.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
 <1399798250-20987-3-git-send-email-emmanuel.grumbach@intel.com>
 <CAB=NE6XOm1EK5CMc8N1xfdKeXcfxRuyCZQtUXQGC3wyGXudAEQ@mail.gmail.com>
 <CA+XVXfeEWB5NasJnEGXrm0aXsdhz7AZR2Az_Azv3rBbnrvatcg@mail.gmail.com>
 <CAB=NE6U=YaomArGA4VKCOv974AREw3eiTKM9U-fnjvidCDJ90g@mail.gmail.com>
 <CA+XVXfcJ4H32D6ZABZ9tSC2JO0Dv3c3uuHkEC-m0P4q0JJcdgQ@mail.gmail.com>
 <CAB=NE6UtCkxvQ=4ZnwnsEQY6kMdx-x+-YUgu636z0OTbOiNPcw@mail.gmail.com>
 <CA+XVXfcvXEi0o-UGNu1T95+rEfpQoVZPf9oVGL3AiqgGiu-LEw@mail.gmail.com>
 <CAB=NE6Vs5y0DANeRbhU7J1z45uxENhcKDG+6b84XPxOh_f_KPw@mail.gmail.com>
 <CA+XVXffnZnaiTmW-CWNEjHxrUOhyHBJU8pyoBY21OQTQ=o1QgQ@mail.gmail.com> <CAFED-j=WEkKiEmKBWjbfWCZbu7952JzEGwNt93XCow7565f1dQ@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 11 Jun 2014 09:38:57 +0300
Message-ID: <CA+XVXfcK_KRZ-fkF4Gwt-oPEzs7CQb++0mg=QWgThuJwX3XOZg@mail.gmail.com> (sfid-20140611_083917_219995_B15DF59F)
Subject: Re: [PATCH 2/7] cfg80211: introduce regulatory flags controlling bw
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2014 at 9:21 AM, Janusz Dziedzic
<janusz.dziedzic@gmail.com> wrote:
> 2014-06-11 7:24 GMT+02:00 Arik Nemtsov <arik@wizery.com>:
>> On Wed, Jun 11, 2014 at 12:28 AM, Luis R. Rodriguez
>> <mcgrof@do-not-panic.com> wrote:
>>> On Tue, May 20, 2014 at 5:31 AM, Arik Nemtsov <arik@wizery.com> wrote:
>>>> On Tue, May 20, 2014 at 12:54 PM, Luis R. Rodriguez
>>>> <mcgrof@do-not-panic.com> wrote:
>>>>> On Tue, May 20, 2014 at 2:25 AM, Arik Nemtsov <arik@wizery.com> wrote:
>>>>>>
>>>>>> Why won't old regdb rules work? The NL80211_RRF_NO_160MHZ for instance
>>>>>> is not used anywhere in old or new regdbs.
>>>>>> So all the new code in reg_get_max_bandwidth is ignored in current or
>>>>>> older crda/regdb flows.
>>>>>>
>>>>>> What am I missing?
>>>>>
>>>>> It will also be ignored on newer kernels using old wireless-regdb.
>>>>
>>>> Is that a problem?
>>>
>>> I would have not brought it up otherwise.
>>>
>>>> Note that the new flags don't permit more things, but only narrow down
>>>> the range. So if VHT80 was blocked due to the range, it will still be
>>>> blocked.
>>>> Don't really see a reason to use them in newer regdbs either. Like you
>>>> said - range only is more scalable.
>>>
>>> You can keep all those bells and whistles provided you respect old
>>> userspace and old behavior first.
>>
>> I guess I'm waiting for some direction on what need to be changed.
>> AFAICT, these flags don't hurt old userspace and/or new kernels using
>> an old wireless-regdb.
>> Can you propose a scenario where the new flags harm something older?
>>
>
> The flag NL80211_RRF_NO_80MHZ could be usefull I think. eg to fix
> world regd veryfication issue we have:
>
> Current failing line:
> (2457 - 2482 @ 40), (20), NO-IR    --> 2482 - 2457 = 25 < 40
>
> Fixed line could be:
> (2457 - 2482 @ 40), (20), NO-IR, AUTO-BW, NO-80MHZ
>
> Without NO-80MHZ - AUTO-BW will setup BW=80MHz - I am not sure this is
> OK for 2.4?
> But setting NO-80MHZ and AUTO-BW flags we will get what expect?

Yea it should do the right thing. This is how Intel is using it.

Arik

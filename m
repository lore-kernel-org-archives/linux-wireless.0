Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:56812 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaFJV2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2014 17:28:30 -0400
Received: by mail-la0-f46.google.com with SMTP id hz20so4130340lab.5
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jun 2014 14:28:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfcvXEi0o-UGNu1T95+rEfpQoVZPf9oVGL3AiqgGiu-LEw@mail.gmail.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
 <1399798250-20987-3-git-send-email-emmanuel.grumbach@intel.com>
 <CAB=NE6XOm1EK5CMc8N1xfdKeXcfxRuyCZQtUXQGC3wyGXudAEQ@mail.gmail.com>
 <CA+XVXfeEWB5NasJnEGXrm0aXsdhz7AZR2Az_Azv3rBbnrvatcg@mail.gmail.com>
 <CAB=NE6U=YaomArGA4VKCOv974AREw3eiTKM9U-fnjvidCDJ90g@mail.gmail.com>
 <CA+XVXfcJ4H32D6ZABZ9tSC2JO0Dv3c3uuHkEC-m0P4q0JJcdgQ@mail.gmail.com>
 <CAB=NE6UtCkxvQ=4ZnwnsEQY6kMdx-x+-YUgu636z0OTbOiNPcw@mail.gmail.com> <CA+XVXfcvXEi0o-UGNu1T95+rEfpQoVZPf9oVGL3AiqgGiu-LEw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 10 Jun 2014 14:28:08 -0700
Message-ID: <CAB=NE6Vs5y0DANeRbhU7J1z45uxENhcKDG+6b84XPxOh_f_KPw@mail.gmail.com> (sfid-20140610_232834_884480_0FACB6C2)
Subject: Re: [PATCH 2/7] cfg80211: introduce regulatory flags controlling bw
To: Arik Nemtsov <arik@wizery.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2014 at 5:31 AM, Arik Nemtsov <arik@wizery.com> wrote:
> On Tue, May 20, 2014 at 12:54 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
>> On Tue, May 20, 2014 at 2:25 AM, Arik Nemtsov <arik@wizery.com> wrote:
>>>
>>> Why won't old regdb rules work? The NL80211_RRF_NO_160MHZ for instance
>>> is not used anywhere in old or new regdbs.
>>> So all the new code in reg_get_max_bandwidth is ignored in current or
>>> older crda/regdb flows.
>>>
>>> What am I missing?
>>
>> It will also be ignored on newer kernels using old wireless-regdb.
>
> Is that a problem?

I would have not brought it up otherwise.

> Note that the new flags don't permit more things, but only narrow down
> the range. So if VHT80 was blocked due to the range, it will still be
> blocked.
> Don't really see a reason to use them in newer regdbs either. Like you
> said - range only is more scalable.

You can keep all those bells and whistles provided you respect old
userspace and old behavior first.

> These flags are very useful for translating the Intel FW regulatory
> format to reg.c format. We don't have ranges there, only flags per
> channel. This allows for seamless interop, with per-channel rules.

I get it, its all fine but just address ensuring that old behavior is
respected first, then you can add whatever on top of it.

  Luis

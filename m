Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:49069 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaETMbU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 08:31:20 -0400
Received: by mail-qg0-f42.google.com with SMTP id q107so572186qgd.29
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 05:31:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UtCkxvQ=4ZnwnsEQY6kMdx-x+-YUgu636z0OTbOiNPcw@mail.gmail.com>
References: <1399798250-20987-1-git-send-email-emmanuel.grumbach@intel.com>
 <1399798250-20987-3-git-send-email-emmanuel.grumbach@intel.com>
 <CAB=NE6XOm1EK5CMc8N1xfdKeXcfxRuyCZQtUXQGC3wyGXudAEQ@mail.gmail.com>
 <CA+XVXfeEWB5NasJnEGXrm0aXsdhz7AZR2Az_Azv3rBbnrvatcg@mail.gmail.com>
 <CAB=NE6U=YaomArGA4VKCOv974AREw3eiTKM9U-fnjvidCDJ90g@mail.gmail.com>
 <CA+XVXfcJ4H32D6ZABZ9tSC2JO0Dv3c3uuHkEC-m0P4q0JJcdgQ@mail.gmail.com> <CAB=NE6UtCkxvQ=4ZnwnsEQY6kMdx-x+-YUgu636z0OTbOiNPcw@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 20 May 2014 15:31:04 +0300
Message-ID: <CA+XVXfcvXEi0o-UGNu1T95+rEfpQoVZPf9oVGL3AiqgGiu-LEw@mail.gmail.com> (sfid-20140520_143123_761686_BB02ACFA)
Subject: Re: [PATCH 2/7] cfg80211: introduce regulatory flags controlling bw
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arikx.nemtsov@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2014 at 12:54 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Tue, May 20, 2014 at 2:25 AM, Arik Nemtsov <arik@wizery.com> wrote:
>>
>> Why won't old regdb rules work? The NL80211_RRF_NO_160MHZ for instance
>> is not used anywhere in old or new regdbs.
>> So all the new code in reg_get_max_bandwidth is ignored in current or
>> older crda/regdb flows.
>>
>> What am I missing?
>
> It will also be ignored on newer kernels using old wireless-regdb.

Is that a problem?
Note that the new flags don't permit more things, but only narrow down
the range. So if VHT80 was blocked due to the range, it will still be
blocked.
Don't really see a reason to use them in newer regdbs either. Like you
said - range only is more scalable.

These flags are very useful for translating the Intel FW regulatory
format to reg.c format. We don't have ranges there, only flags per
channel. This allows for seamless interop, with per-channel rules.

Regards,
Arik

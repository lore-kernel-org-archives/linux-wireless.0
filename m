Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34602 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2BJR3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Feb 2012 12:29:07 -0500
Received: by yhoo21 with SMTP id o21so1600380yho.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Feb 2012 09:29:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1328563980.3466.10.camel@jlt3.sipsolutions.net>
References: <CAObL_7E2eW9aqz3VLsBU-=4+kMXrfPvfz6wCNUEdDHuJWVaSLA@mail.gmail.com>
 <CAFZTsKk9ojw9_XodisHf-dtHpL1n6xSRmmWDVniZ-Ps4-JLwvA@mail.gmail.com>
 <1328455870.7290.43.camel@wwguy-huron> <1DC40B07CD6EC041A66726C271A73AE611F67E@IRSMSX102.ger.corp.intel.com>
 <CAFZTsKnjkJSmMdNpNkQWzUggNcN+3Qx0OGVXzuPDsXr8+h1SiA@mail.gmail.com> <1328563980.3466.10.camel@jlt3.sipsolutions.net>
From: Andrew Lutomirski <luto@mit.edu>
Date: Fri, 10 Feb 2012 09:28:45 -0800
Message-ID: <CAObL_7Ha5JKBcxBFAG1VDvF0rcAxvWkLVe2Opi4mCcL0kR2YFg@mail.gmail.com> (sfid-20120210_182911_636308_C41840AE)
Subject: Re: [Ilw] Re: 6300agn: queue stuck and driver doesn't recover
To: Johannes Berg <johannes.berg@intel.com>
Cc: Alexander Schnaidt <alex.schnaidt@googlemail.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 6, 2012 at 1:33 PM, Johannes Berg <johannes.berg@intel.com> wrote:
> On Mon, 2012-02-06 at 22:27 +0100, Alexander Schnaidt wrote:
>
>> > I think you probably had something like "options iwlagn
>> 11n_disable=1" or so in /etc/modprobe.d/ somewhere. This caused the
>> problem to happen only with the driver called "iwlwifi", since
>> "iwlagn" would get 11n disabled.
>
>> You're almost spot on!, somewhere along the bisect I put swcrypto=1 into
>> modprobe.conf... so much for scientific reproducibility. Sorry for that.
>>
>> I redid the whole bisect with no options in modprobe.conf which defaults
>> to swcrypto=0 on >=3.0 if I'm not mistaken.
>
> ...
>
>> If my interpretation is right the culprit would be:
>>
>> commit 5a3d9882b84edf5fa8e8ca33a5d6df25e2e727a5
>> Author: Johannes Berg <johannes.berg@intel.com>
>> Date:   Fri Jul 15 13:03:12 2011 -0700
>>
>>     iwlagn: rewrite HW crypto
>
>> To me it makes sense considering that swcrypto=1 fixes
>> my problems all the way up till kernel 3.3.0-rc2.
>>
>> ps.: 11n_disable=1 as suggested by Wey-Yi does not
>> change the faulty behavior.
>>
>> Again I apologize for my blunder and thanks for the effort.
>
> Ok this makes sense. A few other people also recently reported this. I'm
> currently (still) away from home so I can't reproduce this issue, and I
> didn't find anything by just looking at the code. Traces for mac80211
> and iwlwifi subsystems would be useful to look at in this case, I think,
> if you want to record the failure case see:
> http://wireless.kernel.org/en/developers/Documentation/mac80211/tracing
> (-e mac80211 -e iwlwifi). If you do record it, please don't send the
> traces to the list, bzip2 it and send it to me directly.

I just reproduced the problem (or at least the similar problem
affecting me) with swcrypto=1.  I'll try to get a trace.

--Andy

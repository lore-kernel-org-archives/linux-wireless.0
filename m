Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59997 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2GIROk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 13:14:40 -0400
Received: by yhmm54 with SMTP id m54so11112192yhm.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 10:14:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341853775.4455.53.camel@jlt3.sipsolutions.net>
References: <1341853048-12150-1-git-send-email-arik@wizery.com>
 <1341853186.4455.52.camel@jlt3.sipsolutions.net> <CA+XVXfc0EDA3LxxT2vp=E1An4=Y8egXOgJB9y4s0-Pw2ZjujBg@mail.gmail.com>
 <1341853775.4455.53.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 9 Jul 2012 20:14:24 +0300
Message-ID: <CA+XVXffLnutstxwALNyVLOgRjjr5RR_agsMyfkkzJ1GydhHgdw@mail.gmail.com> (sfid-20120709_191443_871920_1C5394CD)
Subject: Re: [PATCH v2] mac80211: fix invalid band deref building preq IEs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 9, 2012 at 8:09 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2012-07-09 at 20:04 +0300, Arik Nemtsov wrote:
>> On Mon, Jul 9, 2012 at 7:59 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Mon, 2012-07-09 at 19:57 +0300, Arik Nemtsov wrote:
>> >> The function building probe-request IEs does not validate the band is
>> >> supported before dereferencing it. This can result in a panic when
>> >> all bands are traversed, as done during sched-scan start.
>> >>
>> >> Warn when this happens and return an empty probe request. Also fix
>> >> sched-scan to not waste memory on unsupported bands.
>> >>
>> >> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> >> ---
>> >> better? :)
>> >
>> > Yeah I'll apply this :-)
>> >
>> > I do wonder though why we even bother building probe request IEs for a
>> > band if no channels from it are listed in the sched scan request.
>>
>> It's a bit complicated to know this, because of how the request is
>> structured (have to traverse all the channels etc).
>> The memory waste is not so bad anyway I guess.
>
> Yeah but we could just iterate all the channels and build the probe
> request IEs for each channel's band unless we did before? Anyway, it
> doesn't matter, something for another day maybe :)

Yea that's a possibility I guess. For another day :)

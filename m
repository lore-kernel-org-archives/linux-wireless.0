Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50628 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2GFQHc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 12:07:32 -0400
Received: by gglu4 with SMTP id u4so8749905ggl.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2012 09:07:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341589880.16893.11.camel@jlt3.sipsolutions.net>
References: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1341357315-8053-5-git-send-email-rodrigue@qca.qualcomm.com>
 <1341394944.4482.9.camel@jlt3.sipsolutions.net> <CAB=NE6UfGuOh843dSx7NG7UYtEiDVcLUJbu6nFnBJs-Qk4tszw@mail.gmail.com>
 <1341474303.4455.5.camel@jlt3.sipsolutions.net> <CAB=NE6Uw1pso+HmVAahMvT3BZ0AheWxXuhJFLedvsHKXsUn11g@mail.gmail.com>
 <1341556785.4462.0.camel@jlt3.sipsolutions.net> <CAB=NE6XmbAu+xkLHYaBt=z6zdxXME5cOoANUd_3yEr+va_jb8g@mail.gmail.com>
 <1341583919.16893.3.camel@jlt3.sipsolutions.net> <CAB=NE6XNmrS=kqoptMg67JhBQUJfYa=jUFz+aU-4E91vzqjnTg@mail.gmail.com>
 <1341589880.16893.11.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Fri, 6 Jul 2012 09:07:11 -0700
Message-ID: <CAB=NE6XaRZa4HKg25gd5zkWn=LrjcAXq4NMPVcFWn+PdtVwRdw@mail.gmail.com> (sfid-20120706_180742_627348_729BB0B8)
Subject: Re: [PATCH 4/4] cfg80211: add cellular base station regulatory hint support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 6, 2012 at 8:51 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-07-06 at 08:47 -0700, Luis R. Rodriguez wrote:
>
>> > I guess the question is -- what does that code really enable, if the
>> > driver doesn't also set the feature flag? If it doesn't mean anything
>> > without the flag I think we don't need the extra core option?
>>
>> Ah -- good question. It'd just be the core. The core can support the
>> base station hint or not but apart from the core we could technically
>> also have a scenario today where perhaps one 802.11 card does support
>> the station hint another does not. It is true that with no 802.11 card
>> present having the core makes no sense but in practice we would, or at
>> the very least we'd have the mac80211_hwsim.
>>
>> So as I designed this I realized we really did have to consider the
>> core getting this Vs a card getting this hint. The core getting the
>> hint would only happen as-is with the onus option enabled, so if we
>> want the onus option only to be a gate to other options then
>> technically the feature would be for the core, while drivers would
>> have the options to enable / disable the same feature given that this
>> requires testing / maybe some changes in the firmware.
>
> I'm not sure I really understand what you're saying :-)
>
> What I really wanted to know though is this: If the core code is
> enabled, what effect does receiving a "blessed" hint have on devices
> that don't set the flag? If there's no effect vs. an "unblessed" hint,
> then I think we don't need another option?

Ah, OK so yes, as it is right now if the core accepts the hint but
devices do not listen to it we do have an effect right now which I
alluded to in my cover letter: country IE hints won't be listened to
after a base station hint gets accepted. Whether or not we want to
process country IE hints *after* a cell base station hint gets
accepted is debatable -- I decided that its easier to implement to
ignore country IE hints after a cell base station hint and I also
decided cell base station hints are likely something you'd prefer to
review over country IE hints. We can certainly change this and I'm
open to it.

So yes, as it is right now if you enable onus but your device does not
support he feature you may detect a regression: country IE hints would
not be processed if you did receive a base station hint that the core
processed.

  Luis

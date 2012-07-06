Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38802 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2GFPsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 11:48:07 -0400
Received: by pbbrp8 with SMTP id rp8so14796121pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2012 08:48:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341583919.16893.3.camel@jlt3.sipsolutions.net>
References: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1341357315-8053-5-git-send-email-rodrigue@qca.qualcomm.com>
 <1341394944.4482.9.camel@jlt3.sipsolutions.net> <CAB=NE6UfGuOh843dSx7NG7UYtEiDVcLUJbu6nFnBJs-Qk4tszw@mail.gmail.com>
 <1341474303.4455.5.camel@jlt3.sipsolutions.net> <CAB=NE6Uw1pso+HmVAahMvT3BZ0AheWxXuhJFLedvsHKXsUn11g@mail.gmail.com>
 <1341556785.4462.0.camel@jlt3.sipsolutions.net> <CAB=NE6XmbAu+xkLHYaBt=z6zdxXME5cOoANUd_3yEr+va_jb8g@mail.gmail.com>
 <1341583919.16893.3.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Fri, 6 Jul 2012 08:47:46 -0700
Message-ID: <CAB=NE6XNmrS=kqoptMg67JhBQUJfYa=jUFz+aU-4E91vzqjnTg@mail.gmail.com> (sfid-20120706_174813_608026_9575691B)
Subject: Re: [PATCH 4/4] cfg80211: add cellular base station regulatory hint support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 6, 2012 at 7:11 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-07-06 at 07:05 -0700, Luis R. Rodriguez wrote:
>
>> That, but also it means there are two hops for a device to use the
>> cell base station hint: onus option, and then the feature flag, which
>> could be wrapped itself around a driver specific kconfig option.
>> Reason for the feature flag is devices may need a firmware update in
>> order for them to work properly.
>>
>> As for the onus and the cell base station hint though, it is true
>> though that the onus option would alone enable the core cell base
>> station hints, so the onus option itself would be flipping a switch
>> for a feature. I could extend the patch to include a core specific
>> base station hint kconfig option, because as you say there is no
>> specific switch to select the feature right now for the core.
>
> I guess the question is -- what does that code really enable, if the
> driver doesn't also set the feature flag? If it doesn't mean anything
> without the flag I think we don't need the extra core option?

Ah -- good question. It'd just be the core. The core can support the
base station hint or not but apart from the core we could technically
also have a scenario today where perhaps one 802.11 card does support
the station hint another does not. It is true that with no 802.11 card
present having the core makes no sense but in practice we would, or at
the very least we'd have the mac80211_hwsim.

So as I designed this I realized we really did have to consider the
core getting this Vs a card getting this hint. The core getting the
hint would only happen as-is with the onus option enabled, so if we
want the onus option only to be a gate to other options then
technically the feature would be for the core, while drivers would
have the options to enable / disable the same feature given that this
requires testing / maybe some changes in the firmware.

  Luis

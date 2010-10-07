Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49985 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab0JGRVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 13:21:53 -0400
Received: by iwn9 with SMTP id 9so81338iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Oct 2010 10:21:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286435892.3657.9.camel@jlt3.sipsolutions.net>
References: <20101006185000.GJ7070@tux> <1286391301.3655.403.camel@jlt3.sipsolutions.net>
 <20101006191215.GM7070@tux> <1286392799.3655.414.camel@jlt3.sipsolutions.net>
 <AANLkTinOTsYKFpQkg2B7GVMF-eKykFd8LM1m8xmtXX7j@mail.gmail.com> <1286435892.3657.9.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 7 Oct 2010 10:21:32 -0700
Message-ID: <AANLkTi=iW1T7w-9akkR=DNnrGg3XD5nO=8pJ7V2_PiL4@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Deny new BA agreements from being started
 during offchannel operation
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Srinivasa Duvvuri <Srinivasa.Duvvuri@atheros.com>,
	Matt Smith <Matt.Smith@atheros.com>,
	Bennyam Malavazi <Bennyam.Malavazi@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 7, 2010 at 12:18 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-10-06 at 13:48 -0700, Luis R. Rodriguez wrote:
>> On Wed, Oct 6, 2010 at 12:19 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Wed, 2010-10-06 at 12:12 -0700, Luis R. Rodriguez wrote:
>> >
>> >> Good question, will ieee80211_offchannel_ps_disable() possibly be
>> >> called during suspend? I can imagine its possible. So how about we
>> >> check for local->quiescing prior to lifting the flag only:
>> >
>> > Or suspended?
>>
>> If we're suspended we would be quiesced so I do not see us calling
>> ieee80211_offchannel_ps_disable() then, but we can also just bail out
>> if quescing or suspended on  ieee80211_offchannel_ps_disable() and
>> friends.
>
> Oh, wait, yeah, while quiescing we stop the workqueue so we can't be
> processing this, so we should be fine.

Right.

> We might still be off-channel
> while suspending which is odd, and then we might lift the BA block
> earlier than you'd want.

Hehe.. unless we deny going off channel when quiescing or suspended.

> But then again, come to think of it, why are you doing this anyway?

The goal is to clean up a lot of stuff we forgot to cleanup for
offchannel operation and in the end to help with multicast/broadcast
data. This patch just addresses one of the cleanups. The timers kicked
off when going off channel will not make sense, so best to just deny
ADDBA when going offchannel.

> I'm not convinced of the whole idea, it's all racy. I'm starting to think
> that this patch won't help anything since we'll still be racy and start
> BA agreements just before we block,

Establishing the BA agreement is fine, we don't want to cancel
existing BA agreements when going offchannel, we just want to prevent
making the timers for new ADDBA requests from going stale
unnecessarily.

> _and_ if we're a station and going off-channel we'll be going into powersave
> which means we won't actually get the addBA frame until we return.

There's a race between trying to go offchannel, sending the nullfunc
and switching channels. When the race hits the ADDBA timer will just
go stale. If our goal is to go offchannel we should avoid the race by
simply denying new ADDBA requests. I just noticed that we can't
possible receive ADDBA requests when we are scanning though, since
ieee80211_iface_work() already has a check and bail out for
local->scanning, but note that local->scanning will not be checked
when doing other offchannel work.

So perhaps there is another way we can deal with this for the
non-scanning offchannel work case that might also take care of not
handling other queued up management frames when offchannel.

 Luis

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:54984 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaBEK3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 05:29:24 -0500
Received: by mail-bk0-f48.google.com with SMTP id ej10so157828bkb.21
        for <linux-wireless@vger.kernel.org>; Wed, 05 Feb 2014 02:29:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391585999.16723.7.camel@porter.coelho.fi>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	<1391421529-6067-3-git-send-email-michal.kazior@tieto.com>
	<1391434913.4488.24.camel@jlt4.sipsolutions.net>
	<1391508433.26522.61.camel@porter.coelho.fi>
	<CA+BoTQngW4Ycuv0H=ba5KWs2qDcqPQtKJWp-9XEwdqQv+Xu6CA@mail.gmail.com>
	<1391585999.16723.7.camel@porter.coelho.fi>
Date: Wed, 5 Feb 2014 11:29:22 +0100
Message-ID: <CA+BoTQkXjAYR0H4nHxagYz3Kn5atWJ048UUY1=gPrW77Gvqp+Q@mail.gmail.com> (sfid-20140205_112931_307684_E96DEE31)
Subject: Re: [RFC 2/2] cfg80211: move channel switch logic to cfg80211
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 February 2014 08:39, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2014-02-04 at 13:14 +0100, Michal Kazior wrote:
>> On 4 February 2014 11:07, Luca Coelho <luca@coelho.fi> wrote:
>> > On Mon, 2014-02-03 at 14:41 +0100, Johannes Berg wrote:
>> >> On Mon, 2014-02-03 at 10:58 +0100, Michal Kazior wrote:
>> >> >  * inform userspace what interfaces will be
>> >> >    possibly disconnected by a channel switch,
>> >>
>> >> Huh? Not sure I get that part, why would userspace ever be notified
>> >> about something that *will* happen? Either the interface disconnects
>> >> when the CSA is received, or it just switches and userspace gets a "CSA
>> >> will happen" event?
>>
>> True. Userspace can probably deduce from interface combinations some
>> interfaces require attention due to channel switching.
>>
>>
>> > How do we get the "target" beacon from userspace if the interface just
>> > switches?
>>
>> Do you really need the beacon? What for?
>
> I meant if we would switch the AP/GO interfaces automatically.  We need
> the beacon that should be transmitted in the new channel (like the one
> we need to pass in the existing channel switch request API).

I think Johannes made it clear that switching AP/GO automatically
isn't possible because it requires too much information that mac80211
(nor cfg80211) doesn't have.


>> >> >  * disconnect non-complying interfaces that were
>> >> >    sharing a channel that is being abandoned by
>> >> >    channel switching interface(s),
>> >>
>> >> Hmm, that sounds a bit the wrong way around? Shouldn't the CSA not be
>> >> possible (userspace CSA) or cause the switching interface to disconnect,
>> >> rather than *others*??
>> >
>> > It depends.  And this logic is too complicated to stay in the kernel,
>> > IMHO.  If we are in a GO-follows-STA scenario, we want to disconnect the
>> > GO.  Now, if you have an AP (with tons of STAs connected to it) and a
>> > P2P client gets a CSA for whatever reason, do we really want to stop the
>> > AP?
>>
>> Agreed.
>>
>> But doesn't this imply STA CSA shouldn't be started within kernel
>> itself? Otherwise you leave a corner case when STA CSA is very short
>> making it impossible for userspace to take any action.
>
> I don't see how involving the userspace in the STA CSA decision would
> make any difference.  Doesn't it actually make it worse, because the STA
> CSA *itself* may fail because userspace doesn't have the time to react?

If you have STA CSA started inside mac80211 userspace may not have
enough time to react and request GO to switch in the GO-follows-STA.

This really depends how strongly you want to enforce interface
combinations and how much proactive/reactive CSA should be.


>> >> > - * @channel_switch: initiate channel-switch procedure (with CSA)
>> >> > + * @ch_switch_start: initiate channel-switch procedure (with CSA). This should
>> >> > + * prompt the driver to perform preparation work (start some timers,
>> >> > + * include CS IEs in beacons, etc) but don't do an actual channel switch.
>> >> > + * Once driver has completed all preparations and is ready for the actual
>> >> > + * switch (after CSA counter is completed) it must call
>> >> > + * cfg80211_ch_switch_complete(wdev). After that ch_switch_finalize() MAY
>> >> > + * be called, but it doesn't necessarily happen immediately as cfg80211
>> >> > + * may need to synchronize with other interfaces. If channel switch is
>> >> > + * cancelled for some reason ch_switch_finalize() is not called and driver
>> >> > + * should free up resources/cleanup state in interface disconnection flow.
>> >> > + * @ch_switch_finalize: finalize channel-switch procedure, i.e. perform the
>> >> > + * actual switch.
>> >>
>> >> I don't like this at all. This totally assumes that every driver behaves
>> >> like mac80211, which clearly is not the case. The split between
>> >> "starting" and "finalizing" it should not be part of the API.
>> >
>> > I agree, especially if the driver offloads the channel switch, in which
>> > case it wouldn't be possible for cfg80211 to hold the finalize call to
>> > sync all the interfaces.
>>
>> This implies we don't care if channel switching breaks interface
>> combinations, right?
>
> Those decisions need to be made *before* the channel switch starts.

The purpose of ch_switch_finalize() is to perform the final switch
atomically and make sure non-complying interfaces are disconnected
before channel is actually switched (this could include Ilan's GO case
in a clean way).

If you want to move this to drivers you'll need RTNL to check
interface combinations at least.

Or.. cfg80211 can simply not give a damn :)


Michał

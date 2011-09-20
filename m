Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49881 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab1ITWcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 18:32:23 -0400
Received: by iaqq3 with SMTP id q3so1018738iaq.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 15:32:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VKEu24Y+1YTeCZdokRJ-=g9TyKdz_S8KWjTruPOn1okA@mail.gmail.com>
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
	<1316408970.2157.9.camel@cumari>
	<87aaa0k0a1.fsf@purkki.adurom.net>
	<CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com>
	<87litjipda.fsf@purkki.adurom.net>
	<CAK=WgbZM5zdgOurFfGbQR3V_mqd85qjS_u1_tU35oaVPCh0Rkg@mail.gmail.com>
	<87aa9zi80v.fsf@purkki.adurom.net>
	<CAB=NE6VKEu24Y+1YTeCZdokRJ-=g9TyKdz_S8KWjTruPOn1okA@mail.gmail.com>
Date: Wed, 21 Sep 2011 01:32:22 +0300
Message-ID: <CAB3XZEdcTcfGM1oT0nwjxrOvhDxqQTW_wLYMBG8C5sW6O_EuVw@mail.gmail.com> (sfid-20110921_003226_335871_F541931E)
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
From: Eliad Peller <eliad@wizery.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: Kalle Valo <kvalo@adurom.com>, Ohad Ben-Cohen <ohad@wizery.com>,
	Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 9:36 PM, Luis R. Rodriguez <mcgrof@frijolero.org> wrote:
> On Tue, Sep 20, 2011 at 7:49 AM, Kalle Valo <kvalo@adurom.com> wrote:
>> Ohad Ben-Cohen <ohad@wizery.com> writes:
>>
>>> On Tue, Sep 20, 2011 at 11:34 AM, Kalle Valo <kvalo@adurom.com> wrote:
>>>> IIRC Juuso added ieee80211_enable/disable_dyn_ps() to make it possible
>>>> use BT COEX with wl12xx.
>>>
>>> A lot has happened since then :) The wl12xx firmware today is vastly
>>> different and much improved.
>>
>> Yeah, quite a turn. That's good :)
>>
>>>> Now you are saying that you actually want the opposite?
>>>
>>> Yes. The firmware is now capable of doing coex without enforcing PSM.
>>> This leads to a much better WLAN TP while BT is on.
>>
>> So we can remove the enable/disable dynps interface soon?
>
> Eliad, can you elaborate a little on the behaviour before that
> required the enable/disable dyn ps? You say now the firmware is
> capable of doing BT coex *without* enforcing PSM, can you elaborate on
> that?
>
As Ohad noted, we'll probably shift to
IEEE80211_HW_SUPPORTS_DYNAMIC_PS soon, so this patch is redundant.
anyway, just for the record - the fw supports 2 (mutually exclusive)
coex events:
1. "soft gemini sense" event - the fw indicates coex activity is about
to start. since psm is needed in order to let the BT control the
antenna, and psm is controlled from the host, we disable dyn_ps, so we
won't get out of psm after sending a packet.

2. "auto mode" event - the fw enters a period, in which it might (and
might not) start coex (i.e. the coex activity is transparent to the
driver during this period). during this period, the fw enters and
exits psm independently. there are sub-periods in which there are not
bt activity (e.g. silence during a2dp?). that's why we don't want to
disable dyn_ps - it will badly hurt throughput.

that's what i remember from what i've been told a few months ago. i
also found it weird back then, but it did increase the throughput.

> From what I read so far it seems the firmware needs to be fixed so
> that it can handle atomically going in and out of PSM when dealing
> with BT Coex, one option that comes to mind is dropping the frames it
> has and pending if it is doing BT coex work, which introduces the
> extra delay you mentioned. The drop would likely also help with rate
> control on the other end adjusting itself to environmental factors, in
> this case btcoex event.
>
i'm not familiar with the fw code.
as mentioned above, we're moving to dyn_ps in fw soon, so from the
driver side, there's one less thing to worry about :)

anyway, thanks for your suggestions,
Eliad.

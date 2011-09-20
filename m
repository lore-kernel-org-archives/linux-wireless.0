Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45151 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab1ITSgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 14:36:44 -0400
Received: by qyk7 with SMTP id 7so849599qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 11:36:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87aa9zi80v.fsf@purkki.adurom.net>
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
 <1316408970.2157.9.camel@cumari> <87aaa0k0a1.fsf@purkki.adurom.net>
 <CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com>
 <87litjipda.fsf@purkki.adurom.net> <CAK=WgbZM5zdgOurFfGbQR3V_mqd85qjS_u1_tU35oaVPCh0Rkg@mail.gmail.com>
 <87aa9zi80v.fsf@purkki.adurom.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 20 Sep 2011 11:36:24 -0700
Message-ID: <CAB=NE6VKEu24Y+1YTeCZdokRJ-=g9TyKdz_S8KWjTruPOn1okA@mail.gmail.com> (sfid-20110920_203648_096363_FF5D9901)
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
To: Kalle Valo <kvalo@adurom.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Eliad Peller <eliad@wizery.com>,
	Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 7:49 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Ohad Ben-Cohen <ohad@wizery.com> writes:
>
>> On Tue, Sep 20, 2011 at 11:34 AM, Kalle Valo <kvalo@adurom.com> wrote:
>>> IIRC Juuso added ieee80211_enable/disable_dyn_ps() to make it possible
>>> use BT COEX with wl12xx.
>>
>> A lot has happened since then :) The wl12xx firmware today is vastly
>> different and much improved.
>
> Yeah, quite a turn. That's good :)
>
>>> Now you are saying that you actually want the opposite?
>>
>> Yes. The firmware is now capable of doing coex without enforcing PSM.
>> This leads to a much better WLAN TP while BT is on.
>
> So we can remove the enable/disable dynps interface soon?

Eliad, can you elaborate a little on the behaviour before that
required the enable/disable dyn ps? You say now the firmware is
capable of doing BT coex *without* enforcing PSM, can you elaborate on
that?

>From what I read so far it seems the firmware needs to be fixed so
that it can handle atomically going in and out of PSM when dealing
with BT Coex, one option that comes to mind is dropping the frames it
has and pending if it is doing BT coex work, which introduces the
extra delay you mentioned. The drop would likely also help with rate
control on the other end adjusting itself to environmental factors, in
this case btcoex event.

  Luis

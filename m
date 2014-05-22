Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35631 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaEVODH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 10:03:07 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so3382636wgg.13
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 07:03:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400766635.4174.18.camel@jlt4.sipsolutions.net>
References: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com>
	<1400765294-14732-4-git-send-email-michal.kazior@tieto.com>
	<1400766635.4174.18.camel@jlt4.sipsolutions.net>
Date: Thu, 22 May 2014 16:03:05 +0200
Message-ID: <CA+BoTQ=ubXxkyJZErm9eWQqPNWxAz4XZqgW=PLydWZR5hS+68g@mail.gmail.com> (sfid-20140522_160311_244817_228FDCC5)
Subject: Re: [PATCH 3/3] mac80211: make csa_currnet_counter atomic
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2014 15:50, Johannes Berg <johannes@sipsolutions.net> wrote:
> typo in subject.
>
> On Thu, 2014-05-22 at 15:28 +0200, Michal Kazior wrote:
>> Even it ieee80211_beacon_get() and
>> ieee80211_csa_update_counter() were to be
>> guaranteed to be serialized by drivers it still
>> couldn't be guaranteed to be safe on SMP systems.
>
> We had this debate internally as well, but I don't see where issues
> should be. The only place updating the counter is
> ieee80211_csa_update_counter(), and that should only be called either by
> the driver, or by ieee80211_beacon_get[_tim]() [*]. If the driver wants
> to have the counter update by ieee80211_beacon_get() then it must call
> the function once every beacon interval, if it uses the _template()
> version then it must call ieee80211_csa_update_counter() every beacon
> interval, so no races seem possible.
>
> johannes
>
> [*] the driver shouldn't call ieee80211_beacon_get[_tim] and
> ieee80211_csa_update_counter() in a mixed fashion anyway as that'd lead
> to CSA counter bugs, and ieee80211_beacon_get_template() doesn't change
> the counter

I was thinking the same. The problem is without an atomic variable the
code is simply oblivious to SMP. What if your beacon interrupts are
spread across different CPU and your caches haven't synced yet? I
suppose this is practically unlikely considering beacon intervals but
still..


Michał

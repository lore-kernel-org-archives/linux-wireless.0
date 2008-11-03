Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f12.google.com ([209.85.217.12]:57437 "EHLO
	mail-gx0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525AbYKCEwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 23:52:44 -0500
Received: by gxk5 with SMTP id 5so763242gxk.13
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 20:52:43 -0800 (PST)
Message-ID: <43e72e890811022052n8c5e7d3ic722caa65c711481@mail.gmail.com> (sfid-20081103_055255_249849_FC5BEA56)
Date: Sun, 2 Nov 2008 20:52:42 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: enable RXing beacons
Cc: "Dan Williams" <dcbw@redhat.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890811022049l386789f5qf8bde98eedcd4d2c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225672612-15106-1-git-send-email-lrodriguez@atheros.com>
	 <1225676353.13684.2.camel@localhost.localdomain>
	 <b6c5339f0811021810w229d1d9al2b27bdf4144cde69@mail.gmail.com>
	 <43e72e890811022043t5525d924vcb776569a7bebbc8@mail.gmail.com>
	 <43e72e890811022049l386789f5qf8bde98eedcd4d2c@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 2, 2008 at 8:49 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Sun, Nov 2, 2008 at 8:43 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> On Sun, Nov 2, 2008 at 6:10 PM, Bob Copeland <me@bobcopeland.com> wrote:
>>> On Sun, Nov 2, 2008 at 8:39 PM, Dan Williams <dcbw@redhat.com> wrote:
>>>> On Sun, 2008-11-02 at 16:36 -0800, Luis R. Rodriguez wrote:
>>>>> Prior to this we would rely only on probe responses
>>>>> from the AP to keep associated. We now receive beacons
>>>>> on ath5k. This should fix sporadic disassociations.
>>>>>
>>>>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>>>>
>>>> Is this also a candidate for -stable?
>>>
>>> Don't think so, see below...
>>>
>>>>
>>>>> ---
>>>>>  drivers/net/wireless/ath5k/base.c |    2 ++
>>>>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
>>>>> index f5f46fe..5505f45 100644
>>>>> --- a/drivers/net/wireless/ath5k/base.c
>>>>> +++ b/drivers/net/wireless/ath5k/base.c
>>>>> @@ -2948,6 +2948,8 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
>>>>>                       AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;
>>>>>       if (sc->opmode != NL80211_IFTYPE_STATION)
>>>>>               rfilt |= AR5K_RX_FILTER_PROBEREQ;
>>>>> +     if (sc->opmode == NL80211_IFTYPE_STATION)
>>>>> +             rfilt |= AR5K_RX_FILTER_BEACON;
>>>>>       if (sc->opmode != NL80211_IFTYPE_AP &&
>>>>>               sc->opmode != NL80211_IFTYPE_MESH_POINT &&
>>>>>               test_bit(ATH_STAT_PROMISC, sc->status))
>>>
>>> Sorry, my fault, this was a direct result of
>>> 60c7e22196fb4230b76db1f5fb283e811b8f3fb3 "ath5k: honor
>>> FIF_BCN_PRBRESP_PROMISC."  The problem remains that we have too many
>>> interrupts though if PRBRESP_PROMISC is not set.  IIRC my patch made
>>> ath5k behave same as ath9k.  Any ideas on a proper fix?
>>
>> If we don't have beacons coming in on ath9k its also an issue and may
>> explain the same exact issue we see there.
>
> I see what you saw now too.. hmmm, either we handle that wrong right
> now too or there is something else that should enable the beacons to
> come through. Something is fishy for sure. Will get back to you.

OK Vasanth confirmed this is correct, and ath9k actually has incorrect
behavior so we have to fix that there as well. If stable got the ath5k
changes to the filter then yes we should push it there too.

  Luis

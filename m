Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:41041 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235AbZI3XUM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 19:20:12 -0400
Received: by iwn8 with SMTP id 8so3938338iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2009 16:20:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890909301612v5079c9bco9ac8529f77a7c67a@mail.gmail.com>
References: <43e72e890909291224t26b7e6cbmc78976165bd1bb88@mail.gmail.com>
	<43e72e890909301612v5079c9bco9ac8529f77a7c67a@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 30 Sep 2009 16:19:56 -0700
Message-ID: <43e72e890909301619t4c0a26feq935cfef65ebf1493@mail.gmail.com>
Subject: Re: SME warning on 2.6.32-rc<bleh>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2009 at 4:12 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Sep 29, 2009 at 12:24 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> I believe the problem comes from the assumption from cfg80211 that
>> previous deauthentications would have gone through before we run
>> __cfg80211_disconnected() and are using wext or nl80211
>> connec/disconnectt. Under certain conditions (clearly not known yet)
>> this is not true and we'll end up asking mac80211 to deauthenticate us
>> from a BSS we already deauthenticated to end end up with an -ENOLINK
>> on our mac80211 cfg80211 deauth ops. It seems this race was expected
>> all along on mac80211 ieee80211_mgd_deauth():
>>
>>        /*
>>         * cfg80211 should catch this ... but it's racy since
>>         * we can receive a deauth frame, process it, hand it
>>         * to cfg80211 while that's in a locked section already
>>         * trying to tell us that the user wants to disconnect.
>>         */
>>        if (!bssid) {
>>                mutex_unlock(&ifmgd->mtx);
>>                return -ENOLINK;
>>        }
>>
>> So it seems we do need to address that race but I'm not yet sure how.
>>
>> Here is a warning from the latest wireless-testing. Unfortunately I
>> cannot reproduce in a systematic way, I've tried even different boot
>> configuration (mem=300M) and CPU pegged at 800 MHz thinking the race
>> occurs when mac80211 takes its sweet time deathenticating but that
>> wasn't the case.
>
> OK so I just got this again today with a cardbus card. The curious
> thing to see was that it happened when I rmmod'd ath9k right after
> these messages:
>
> [  234.481226] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
> AR_DIAG_SW=0x40000020
> [  234.928823] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
> AR_DIAG_SW=0x40000020
> [  237.064792] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
> AR_DIAG_SW=0x40000020
> [  310.676842] ath: DMA failed to stop in 10 ms AR_CR=0x00000024
> AR_DIAG_SW=0x40000020

Mind you I am not sure if its the Cardbus card, it could be busted,
I've seen some strange issues with it before.

  Luis

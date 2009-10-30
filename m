Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:36240 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194AbZJ3Oih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 10:38:37 -0400
Received: by iwn10 with SMTP id 10so2159555iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2009 07:38:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091030063306.GH4602@vasanth-laptop>
References: <1256849546-15119-1-git-send-email-lrodriguez@atheros.com>
	<20091030063306.GH4602@vasanth-laptop>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 30 Oct 2009 07:38:22 -0700
Message-ID: <43e72e890910300738i29a81f54p57fd0c6fdccbcaf5@mail.gmail.com>
Subject: Re: [RFC] ath9k: fix listening to idle requests
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 29, 2009 at 11:33 PM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> On Fri, Oct 30, 2009 at 02:22:26AM +0530, Luis Rodriguez wrote:
>> The way idle configuration detection was implemented as
>> busted due to the fact that it assumed the ath9k virtual wiphy,
>> the aphy, would be marked as inactive if it was not used but
>> it turns out an aphy is always active if its the only wiphy
>> present. We need to distinguish between aphy activity and
>> idleness so we now add an idle bool for the aphy and mark
>> it as such based on the passed IEEE80211_CONF_CHANGE_IDLE
>> from mac80211.
>>
>> Previous to all_wiphys_idle would never be true when using
>> only one device so we never really were using
>> IEEE80211_CONF_CHANGE_IDLE -- we never turned the radio
>> off or on upon IEEE80211_CONF_CHANGE_IDLE changes as radio
>> changes depended on all_wiphys_idle being true either to
>> turn the radio on or off. Since it was always false for
>> one device this code was doing nothing.
>>
>> Reported-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>
>> Vasanth, what do you think?
>
> Still we will have issue when bringing up a sec wiphy while the
> primary wiphy is in idle state. ath9k_start() does not brought up
> the newly created wiphy interface when the state of at least one
> previously created interface is in ACTIVE state. Unless already
> brought up interfaces are put down we hit this situation whenever
> we try to bring up a new secondary wiphy interface. So with this
> patch the actual h/w will remain radio disabled state even after
> a new interface is in active state. We need to bring the h/w into
> active state if all old interfaces are in idle state in
> ath9k_start().

I don't see what prevents a secondary virtual wiphy from getting the
radio started -- perhaps I'm missing something. When a virtual wiphy
needs to become non-idle that'll come from the mac80211 non-idle
config call and that will find that one device is non-idle and hence
start it. Unfortunately I don't have time to test this though so I
cannot be sure this indeed will work.

  Luis

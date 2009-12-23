Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:64830 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbZLWEBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 23:01:05 -0500
Received: by iwn1 with SMTP id 1so4897612iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2009 20:01:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19249.38711.712672.190663@gargle.gargle.HOWL>
References: <20091222022355.GA32508@bombadil.infradead.org>
	<19248.19829.293087.367661@gargle.gargle.HOWL> <20091222155005.GA4385@tux>
	<20091222162055.GC4385@tux> <20091222165528.GE4385@tux> <20091222175939.GF4385@tux>
	<43e72e890912221716r64ea4542qd747302b536a3156@mail.gmail.com>
	<19249.34294.19925.963051@gargle.gargle.HOWL> <43e72e890912221854s5f06a0d2jcfffb1cc8d857347@mail.gmail.com>
	<19249.38711.712672.190663@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 22 Dec 2009 20:00:42 -0800
Message-ID: <43e72e890912222000j1dd080d2w4b7f3829ee447de3@mail.gmail.com>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner case
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 22, 2009 at 8:06 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Luis Rodriguez wrote:
>> > diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>> > index 419c382..7fdcc6b 100644
>> > --- a/drivers/net/wireless/ath/ath9k/main.c
>> > +++ b/drivers/net/wireless/ath/ath9k/main.c
>> > @@ -2673,6 +2673,11 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
>> >
>> >        mutex_lock(&sc->mutex);
>> >
>> > +       if (sc->sc_flags & SC_OP_INVALID) {
>> > +               mutex_unlock(&sc->mutex);
>> > +               return 0;
>> > +       }
>> > +
>> >        /*
>> >         * Leave this as the first check because we need to turn on the
>> >         * radio if it was disabled before prior to processing the rest
>>
>> That ones busts the resume.
>
> Weird, checking for the device status before allowing configuration
> changes is valid. Not sure why this is happening.

The proper and more clean solution is to see where in mac80211 this
gets called and avoid the call when local->suspended if
local->suspended is true after driver->stop() I forget.

  Luis

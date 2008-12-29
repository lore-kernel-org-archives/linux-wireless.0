Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:35795 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbYL2Nho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 08:37:44 -0500
Received: by bwz14 with SMTP id 14so16148575bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 29 Dec 2008 05:37:41 -0800 (PST)
Message-ID: <8e92b4100812290537q7605b39dg382fe5d42963c65a@mail.gmail.com> (sfid-20081229_143754_185410_C21A0648)
Date: Mon, 29 Dec 2008 19:07:41 +0530
From: "Vivek Natarajan" <vivek.natraj@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] ath9k: Enable dynamic power save in ath9k.
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1230552660.3116.33.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081229235300.GA8458@myhost.users.atheros.com>
	 <1230552660.3116.33.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 29, 2008 at 5:41 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-12-29 at 15:53 -0800, Vivek Natarajan wrote:
>
>> +#define ATH9K_PS_WAKEUP(sc)                                                \
>> +     do {                                                                  \
>> +             if (!atomic_read(&sc->ps_usecount) &&                         \
>> +                (ah->ah_powerMode !=  ATH9K_PM_AWAKE)) {                   \
>> +                     ah->ah_restoreMode = ah->ah_powerMode;                \
>> +                     ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);         \
>> +             }                                                             \
>> +             atomic_inc(&sc->ps_usecount);                                 \
>> +     } while (0);
>> +
>> +#define ATH9K_PS_RESTORE(sc)                                               \
>> +     do {                                                                  \
>> +             if (atomic_dec_and_test(&sc->ps_usecount) &&                  \
>> +                (sc->hw->conf.flags & IEEE80211_CONF_PS))                  \
>> +                     ath9k_hw_setpower(sc->sc_ah, ah->ah_restoreMode);     \
>> +     } while (0);
>
> I think those would be better as static inlines rather than macros.
>
> johannes

Thanks Johannes. I'll change them.

> Also, this seems racy, shouldn't it use something like if
> (atomic_inc_return() == 1) ?

Thanks.This seems much better.

Vivek.

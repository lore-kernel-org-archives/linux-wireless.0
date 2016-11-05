Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:35804 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752523AbcKEFJV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Nov 2016 01:09:21 -0400
Received: by mail-it0-f47.google.com with SMTP id e187so17133970itc.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Nov 2016 22:09:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1477461362.4059.17.camel@sipsolutions.net>
References: <CAGp19xcg1qCP3+JNbuiB7Hx=UjLN7KP55wVJT0sKV-iE12501A@mail.gmail.com>
 <1477286912.4085.1.camel@sipsolutions.net> <CAGp19xdgsoyx9Sa=uas1OEiFoJdzFChmt20++9e7fJK=Z1ujWQ@mail.gmail.com>
 <1477379678.4390.2.camel@sipsolutions.net> <CAJ-Vmon0RTAXJMuwANCO23cPsFyFZ17sAHoReuGBG1u1Q9kK6w@mail.gmail.com>
 <1477461362.4059.17.camel@sipsolutions.net>
From: Adrian Chadd <adrian@freebsd.org>
Date: Fri, 4 Nov 2016 22:09:19 -0700
Message-ID: <CAJ-Vmo=OM=rx-RM0fg=0dY9Jy_9njsFCnuXEPEngrFDj40-mBg@mail.gmail.com> (sfid-20161105_060945_000919_78AFF7EE)
Subject: Re: Bayesian rate control
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bjornsmedman@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 25 October 2016 at 22:56, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> The intel 7260 and later parts also allow user controllable rate
>> control and provide transmit completion feedback, but I don't know
>> whether it's enough for your needs.
>
> Perhaps. However, existing rate control is *very* tightly coupled to
> the driver, and it'd be fairly pointless to disentangle just for the
> sake of playing with a rate control algorithm.
>
> Also, the device doesn't support per-frame control nor any kind of
> sampling-with-table-fallback, only the rate table that you give to the
> device and update.

Hi,

But there is a per-descriptor TX rate table entry in the driver.
FreeBSD uses it to implement its rate control for the intel drivers.

What am I missing? :)

>
> Btw, mac80211_hwsim with wmediumd doing some medium simulation might
> also be something to look at for just extending to VHT.
>
> And come to think of it, there's this new driver Felix et al have been
> working on, mt7601u, which also should support proper rate control
> APIs.



-adrian

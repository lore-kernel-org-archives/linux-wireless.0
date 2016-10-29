Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rs224.mailgun.us ([209.61.151.224]:56973 "EHLO rs224.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750806AbcJ2Uu5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Oct 2016 16:50:57 -0400
Received: by mail-qt0-f175.google.com with SMTP id n6so19809432qtd.1
        for <linux-wireless@vger.kernel.org>; Sat, 29 Oct 2016 13:50:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1477461362.4059.17.camel@sipsolutions.net>
References: <CAGp19xcg1qCP3+JNbuiB7Hx=UjLN7KP55wVJT0sKV-iE12501A@mail.gmail.com>
 <1477286912.4085.1.camel@sipsolutions.net> <CAGp19xdgsoyx9Sa=uas1OEiFoJdzFChmt20++9e7fJK=Z1ujWQ@mail.gmail.com>
 <1477379678.4390.2.camel@sipsolutions.net> <CAJ-Vmon0RTAXJMuwANCO23cPsFyFZ17sAHoReuGBG1u1Q9kK6w@mail.gmail.com>
 <1477461362.4059.17.camel@sipsolutions.net>
From: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bjorn@openias.org>
Date: Sat, 29 Oct 2016 22:50:55 +0200
Message-ID: <CAGp19xeDOdF+YuZ34sQrFY+NO4kvzAzuFr0+3Ae62v-a-0eUtg@mail.gmail.com> (sfid-20161029_225102_971045_D810C80B)
Subject: Re: Bayesian rate control
To: Johannes Berg <johannes@sipsolutions.net>,
        Adrian Chadd <adrian@freebsd.org>,
        =?UTF-8?B?VGhvbWFzIEjDvGhu?= <thomas@inet.tu-berlin.de>,
        Dave Taht <dave.taht@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas, Dave, Adrian, Johannes,

Thanks for comments and encouragement. I bought the TP-Link TL-WA901ND
access point and TP-Link TL-WDN4800 PCIe card. Had no problem getting
them talking to each other with ath9k, and the rate table contains 52
entries, so plenty to start out with.

I've written a follow-up post about it if anybody's interested:
http://www.openias.org/bayesian-wifi-materials-and-methods

Cheers,

Bj=C3=B6rn

On Wed, Oct 26, 2016 at 7:56 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
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
>
> Btw, mac80211_hwsim with wmediumd doing some medium simulation might
> also be something to look at for just extending to VHT.
>
> And come to think of it, there's this new driver Felix et al have been
> working on, mt7601u, which also should support proper rate control
> APIs.
>
> johannes

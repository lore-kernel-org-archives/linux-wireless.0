Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:47065 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbZIKRx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 13:53:26 -0400
Received: by iwn8 with SMTP id 8so553056iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2009 10:53:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0909110435l2e420685y7715f3512873008e@mail.gmail.com>
References: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>
	<1252632895-11914-4-git-send-email-lrodriguez@atheros.com>
	<40f31dec0909102316q7902098jbee7fd8d17c3f622@mail.gmail.com>
	<4AA9F22C.3090007@gmail.com> <43e72e890909110023k62a512bejd712a3449cc8328d@mail.gmail.com>
	<b6c5339f0909110435l2e420685y7715f3512873008e@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 11 Sep 2009 10:53:08 -0700
Message-ID: <43e72e890909111053y64026e98r7d5220e74005f16f@mail.gmail.com>
Subject: Re: [PATCH 3/4] ath5k: define ath_common ops
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	devel@linuxdriverproject.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jeff Garzik <jeff@garzik.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 11, 2009 at 4:35 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, Sep 11, 2009 at 3:23 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> ath9k/ath9k/ath9k_htc. But -- is there really is a measurable cost
>> penalty?
>>
>> This is why I asked if someone can test and give measurable
>> differences over this. If there really isn't then that's not strong
>> point against it.
>
> Honestly, it probably won't matter in the grand scheme of things, but I
> think if you are proposing a patch that touches every hotpath in two
> drivers, then you need to do the work to say "by the way, this has benefit
> X which outweighs the very small (or absent) performance regression Y,
> and here are the numbers.

You're completely right, sorry about that. I thought the advantages
would have been obvious but let me clarify them them:

So far I've tested this with:

time iw list dev wlan0 scan > /dev/null

Both with and without the patches and the time it takes to scan, when
not associated, remains the same. Granted I do have an Intel Core Duo
1.8 GHz, so if some others could test this on some embedded platforms
that would be appreciated.

The main added advantage to these changes is the possibility to now
share hw access code between ath5k/ath9k. With the patches as-is you
get one hot path on the driver, whether or not you use common hw code
through ath.ko or through the driver's own hw code. It is unclear to
me whether this has any measurable benefits so an alternative is to
only use the common read/write ops on the common ath.ko.

Although I don't see any measurable differences at the moment I
suspect most people are inclined to leave hw access directly on the
driver and only use common hw read/write ops for the common code. I'll
respin these patches to do just that.

  Luis

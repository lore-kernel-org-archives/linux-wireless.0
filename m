Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32995 "EHLO
        mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754925AbcIKDQ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Sep 2016 23:16:59 -0400
Received: by mail-pa0-f48.google.com with SMTP id cm16so40505329pac.0
        for <linux-wireless@vger.kernel.org>; Sat, 10 Sep 2016 20:16:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGhGL2D8Hfed0VTsinnCbkK31dGTc=bYjzpPfrcLRnp+x6O3sA@mail.gmail.com>
References: <20160910193315.30738-1-toke@toke.dk> <CAGhGL2D8Hfed0VTsinnCbkK31dGTc=bYjzpPfrcLRnp+x6O3sA@mail.gmail.com>
From: Loganaden Velvindron <loganaden@gmail.com>
Date: Sun, 11 Sep 2016 07:16:58 +0400
Message-ID: <CAOp4FwT-Xf5_RnQCOg6Jh_ogHQ3nzcpx-gFS-mmPhOn-aMG3xQ@mail.gmail.com> (sfid-20160911_051705_160244_4E9D1421)
Subject: Re: [Make-wifi-fast] [PATCH] mac80211: Dynamically set CoDel
 parameters per station.
To: Jim Gettys <jg@freedesktop.org>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 10, 2016 at 11:54 PM, Jim Gettys <jg@freedesktop.org> wrote:
>
>
> On Sat, Sep 10, 2016 at 3:33 PM, Toke H=C3=B8iland-J=C3=B8rgensen <toke@t=
oke.dk>
> wrote:
>>
>> CoDel can be too aggressive if a station sends at a very low rate,
>> leading to starvation. This gets worse the more stations are present, as
>> each station gets more bursty the longer the round-robin scheduling
>> between stations takes.
>>
>> This adds dynamic adjustment of CoDel parameters per station. It uses
>> the rate selection information to estimate throughput and sets more
>> lenient CoDel parameters if the estimated throughput is below a
>> threshold. To not change parameters too often, a hysteresis of two
>> seconds is added.
>
>
> Where is this 2 second constant coming from?  I'd expect it should be of
> order the maximum RTT (or a small constant factor of that, which for
> intercontinental connections should be 200-300ms.
>

Indeed, from Mauritius (Africa) to remote countries like Australia, or
parts of the US, we see latencies of up to 500-600ms.

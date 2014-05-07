Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:45154 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbaEGMMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 08:12:17 -0400
Received: by mail-wi0-f177.google.com with SMTP id f8so1189489wiw.16
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 05:12:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399463403.10517.24.camel@jlt4.sipsolutions.net>
References: <1396267459-9976-1-git-send-email-michal.kazior@tieto.com>
	<1397051137-26201-1-git-send-email-michal.kazior@tieto.com>
	<1397051137-26201-3-git-send-email-michal.kazior@tieto.com>
	<1399387345.4218.44.camel@jlt4.sipsolutions.net>
	<CA+BoTQ=FqfB46Bd6iC3F=Ps=b4f6CP77p5d6f4fiVLUttCYQjg@mail.gmail.com>
	<1399449912.5038.7.camel@jlt4.sipsolutions.net>
	<CA+BoTQnJ7N=UtDu_tySg8uYrQg9i+BvuYrwez7x-LUVinroWDw@mail.gmail.com>
	<1399453631.10517.10.camel@jlt4.sipsolutions.net>
	<CA+BoTQmygnk161oi=AUwfFM4U-r8TxuJVcHPMbsOG+QCzB03hQ@mail.gmail.com>
	<1399461426.10517.16.camel@jlt4.sipsolutions.net>
	<CA+BoTQ=uNCVZcacg32nTp2i7gu2RcZQbbe4nw5_sCBANHHTY0A@mail.gmail.com>
	<1399463403.10517.24.camel@jlt4.sipsolutions.net>
Date: Wed, 7 May 2014 14:12:16 +0200
Message-ID: <CA+BoTQk3EHR3kYQV+FUjOgp+O7vd+zp3FMeiN2LvS4zS_zEWwA@mail.gmail.com> (sfid-20140507_141222_741138_5D6B1FF3)
Subject: Re: [PATCH v4 2/5] mac80211: use chanctx reservation for AP CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 May 2014 13:50, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-05-07 at 13:43 +0200, Michal Kazior wrote:
>
>> We can't really guarantee how long we'll need to stop beaconing for.
>>
>> Assume: AP+STA. Start AP CSA bcn_int=100ms, cs_count=5. While CSA
>> progresses STA receives cs_count=100 (with bcn_int=100ms).
>>
>> This is all theory and in practice you won't get cs_count that big and
>> the lag greater shouldn't be greater than 5 or 6 beacon intervals. Is
>> that an "extended" period of time? I don't know. Should we even worry
>> about this? I don't think so.
>
> I'm not sure why we'd even allow this to start with though. We should be
> able to sync it to 1 beacon interval, it seems? Particularly if we start
> the switches together.

There's no guarantee your AP and STA's AP will finish CSA in sync. So
you either (1) prolong your stay on the (old) channel until STA's AP
completes CSA, or (2) you switch your STA interface prematurely, (3)
or you simply disconnect STA interface if you can't have a really
tight sync.


Michał

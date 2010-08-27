Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41546 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0H0Pzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 11:55:48 -0400
Received: by pvg2 with SMTP id 2so1126625pvg.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Aug 2010 08:55:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282924294.4377.15.camel@jlt3.sipsolutions.net>
References: <1282887527-23259-1-git-send-email-lrodriguez@atheros.com>
 <20100827090655.GA15873@jm.kir.nu> <AANLkTimw1MpiKM=rCfp_zxkw855SyaoZg6m1oB354tCF@mail.gmail.com>
 <1282923444.4377.13.camel@jlt3.sipsolutions.net> <AANLkTi=qWjhwo50hg8HB1wtsyUizAi55SEK9EW0Udckv@mail.gmail.com>
 <1282923799.4377.14.camel@jlt3.sipsolutions.net> <AANLkTinP7Mzk6gNL3DZaByOj5DZG=nCo2s_ne3WeN0+p@mail.gmail.com>
 <1282924294.4377.15.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 27 Aug 2010 08:55:25 -0700
Message-ID: <AANLkTikkemr390C4N2bPivp9rZhbdSpUw9=+uvS=y-Mq@mail.gmail.com>
Subject: Re: [RFT] mac80211: fix broadcast/multicast data drop on scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@adurom.com>,
	Amod Bodas <Amod.Bodas@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 27, 2010 at 8:51 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-08-27 at 08:48 -0700, Luis R. Rodriguez wrote:
>
>> > Well, there's no way we can reliably wake up exactly before a beacon by
>> > implementing that in software, hard real-time hasn't been achieved in
>> > Linux yet :-)
>>
>> Keyword here is *exactly*. I don't want to wake up *exactly* at DTIM,
>> only ensure we don't sleep during it and the send buffered frames and
>> multicast traffic data. Why can we not implement this on mac80211?
>
> Well, how long before the beacon do you want to wake up to catch it?
> 1ms? 10ms? 100ms? 1000ms? What if the system is busy?

I cannot say what would work best, how about half a beacon interval early?

  Luis

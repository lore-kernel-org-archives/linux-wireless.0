Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48066 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0H0Psp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 11:48:45 -0400
Received: by ywh1 with SMTP id 1so848046ywh.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Aug 2010 08:48:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282923799.4377.14.camel@jlt3.sipsolutions.net>
References: <1282887527-23259-1-git-send-email-lrodriguez@atheros.com>
 <20100827090655.GA15873@jm.kir.nu> <AANLkTimw1MpiKM=rCfp_zxkw855SyaoZg6m1oB354tCF@mail.gmail.com>
 <1282923444.4377.13.camel@jlt3.sipsolutions.net> <AANLkTi=qWjhwo50hg8HB1wtsyUizAi55SEK9EW0Udckv@mail.gmail.com>
 <1282923799.4377.14.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 27 Aug 2010 08:48:24 -0700
Message-ID: <AANLkTinP7Mzk6gNL3DZaByOj5DZG=nCo2s_ne3WeN0+p@mail.gmail.com>
Subject: Re: [RFT] mac80211: fix broadcast/multicast data drop on scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@adurom.com>,
	Amod Bodas <Amod.Bodas@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 27, 2010 at 8:43 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-08-27 at 08:40 -0700, Luis R. Rodriguez wrote:
>> On Fri, Aug 27, 2010 at 8:37 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Fri, 2010-08-27 at 08:28 -0700, Luis R. Rodriguez wrote:
>> >
>> >> Indeed... I do not see where we keep track of the DTIM count and was
>> >> afraid this was not sufficient. I had not thought about the last
>> >> received multicast / broadcast frame, that will require some more
>> >> work. But I also noticed even ieee80211_recalc_ps() does not take this
>> >> into account when computing the max_sleep_period ieee80211_enable_ps()
>> >> for dynamic power save, it only considers the DTIM period. We send the
>> >> nullfunc frame for dynamic power save and it does not seem we take
>> >> into consideration the DTIM count and last RX's broadcast / multicast
>> >> data prior to sending the nullfunc to go into power save. So it seems
>> >> to me dynamic power save would also loses broadcast / multicast data
>> >> frames.
>> >
>> > No, the max sleep period is just a helper variable for device
>> > implementation of sleep -- the actual alignment of it with DTIM beacons
>> > etc. has to be done by the device. Therefore, it isn't so :-)
>>
>> I noticed the comment on the PS documentation that the reason for this
>> is that mac80211 is too slow, is that right?
>
> Well, there's no way we can reliably wake up exactly before a beacon by
> implementing that in software, hard real-time hasn't been achieved in
> Linux yet :-)

Keyword here is *exactly*. I don't want to wake up *exactly* at DTIM,
only ensure we don't sleep during it and the send buffered frames and
multicast traffic data. Why can we not implement this on mac80211?

  Luis

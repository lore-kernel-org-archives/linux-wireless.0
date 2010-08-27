Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50876 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab0H0PlE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 11:41:04 -0400
Received: by gxk23 with SMTP id 23so1157296gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 27 Aug 2010 08:41:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282923444.4377.13.camel@jlt3.sipsolutions.net>
References: <1282887527-23259-1-git-send-email-lrodriguez@atheros.com>
 <20100827090655.GA15873@jm.kir.nu> <AANLkTimw1MpiKM=rCfp_zxkw855SyaoZg6m1oB354tCF@mail.gmail.com>
 <1282923444.4377.13.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 27 Aug 2010 08:40:42 -0700
Message-ID: <AANLkTi=qWjhwo50hg8HB1wtsyUizAi55SEK9EW0Udckv@mail.gmail.com>
Subject: Re: [RFT] mac80211: fix broadcast/multicast data drop on scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@adurom.com>,
	Amod Bodas <Amod.Bodas@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 27, 2010 at 8:37 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-08-27 at 08:28 -0700, Luis R. Rodriguez wrote:
>
>> Indeed... I do not see where we keep track of the DTIM count and was
>> afraid this was not sufficient. I had not thought about the last
>> received multicast / broadcast frame, that will require some more
>> work. But I also noticed even ieee80211_recalc_ps() does not take this
>> into account when computing the max_sleep_period ieee80211_enable_ps()
>> for dynamic power save, it only considers the DTIM period. We send the
>> nullfunc frame for dynamic power save and it does not seem we take
>> into consideration the DTIM count and last RX's broadcast / multicast
>> data prior to sending the nullfunc to go into power save. So it seems
>> to me dynamic power save would also loses broadcast / multicast data
>> frames.
>
> No, the max sleep period is just a helper variable for device
> implementation of sleep -- the actual alignment of it with DTIM beacons
> etc. has to be done by the device. Therefore, it isn't so :-)

I noticed the comment on the PS documentation that the reason for this
is that mac80211 is too slow, is that right?

  Luis

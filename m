Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:37095 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973AbaGWOt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 10:49:27 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so1342033wes.0
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2014 07:49:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1406125788.14675.0.camel@jlt4.sipsolutions.net>
References: <1405859555-31806-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1405859555-31806-2-git-send-email-lorenzo.bianconi83@gmail.com>
	<1405937608.32255.15.camel@jlt4.sipsolutions.net>
	<CAA2SeNKL1ZQq_G6My1Fz+vmptML1RwjTjzxBM5v8sbXCq8C0nQ@mail.gmail.com>
	<1406125788.14675.0.camel@jlt4.sipsolutions.net>
Date: Wed, 23 Jul 2014 16:49:26 +0200
Message-ID: <CAA2SeNKmrMJRd6sm3BDoUxUOxwJbHsnApsWGh_TacA9NF5oWdQ@mail.gmail.com> (sfid-20140723_164940_414828_C494E6C9)
Subject: Re: [PATCH 1/2] cfg80211: add enable_dynack API
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Philippe Duchein <wireless-dev@duchein.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Wed, 2014-07-23 at 00:56 +0200, Lorenzo Bianconi wrote:
>
>> > I think it may be better to handle this in the call that's normally used
>> > (coverage class setting), but allow the other attribute to make a sort
>> > of "dynamic coverage class". And internally, calling drivers, it seems
>> > fine to pass -1 or so since you can extend the datatype there, instead
>> > of introducing a new internal callback. External/internal doesn't always
>> > have to match perfectly.
>> >
>>
>> So we can pass coverage class equal to -1 to lower drivers in order to
>> enable ack timeout estimation. In this case I have to modify driver
>> routine signature in p54, ath5k and ath9k drivers. Moreover in
>> cfg80211/mac80211 stack we can take into account dynamic coverage
>> class using s16 datatype instead of u8 for coverage_class in wiphy
>> data structure.
>
> Right. But that seems reasonable, no?

Yes, it sounds good for me. Moreover using s16 as datatype for
coverage_class in wiphy structure allows to detect if dynack is
enabled using iw (i.e. iw phy phy0 info)

>
> johannes
>

Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep

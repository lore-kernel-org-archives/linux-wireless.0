Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:65167 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759971AbaGYJGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 05:06:46 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so612243wib.8
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jul 2014 02:06:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1406206885.14675.19.camel@jlt4.sipsolutions.net>
References: <1406198362-4999-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1406198362-4999-2-git-send-email-lorenzo.bianconi83@gmail.com>
	<1406200256.14675.17.camel@jlt4.sipsolutions.net>
	<CAA2SeN+zR_CUp4S7Vs0THpaMBKJqkwAPJdrDddhsxL4E1hhV3g@mail.gmail.com>
	<1406206885.14675.19.camel@jlt4.sipsolutions.net>
Date: Fri, 25 Jul 2014 11:06:44 +0200
Message-ID: <CAA2SeNLRvQmermy92Tx6vL+irRa-Ee3sBZPZ9guun=XpWkY4Sw@mail.gmail.com> (sfid-20140725_110654_613111_82A1BBC5)
Subject: Re: [PATCHv2 1/2] cfg80211: extend coverage_class datatype
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Philippe Duchein <wireless-dev@duchein.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Thu, 2014-07-24 at 14:21 +0200, Lorenzo Bianconi wrote:
>
>> Currently iw does not allow to set both attribute at the same time,
>> but I can use "if-else if" statement in order to exclude that
>> condition.
>
> I think you should explicitly reject the configuration if both
> attributes are given, not silently use one of them.
>

Ack

>> > You should also have a feature flag that drivers set that you test here
>> > and refuse dynamic if it's not supported, I guess?
>> >
>>
>> I would rely on lower drivers to fail (returning -EOPNOTSUPP to
>> set_coverage_class caller) if dynack it is not supported and user is
>> trying to enable it. Does it sound good for you?
>
> I imagined you'd want to know in 'iw list' whether or not it's supported
> too.
>

Ok, I can add  an entry in nl80211_feature_flags, something like
NL80211_FEATURE_ACKTO_ESTIMATION. This flags will be set by lower
driver and will be checked to very if driver supports this feature.
Moreover NL80211_FEATURE_ACKTO_ESTIMATION will be reported to
userspace.

> johannes
>

Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43371 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527AbaGXMiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 08:38:21 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so9495200wib.10
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 05:38:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1406200166.14675.16.camel@jlt4.sipsolutions.net>
References: <1406198362-4999-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1406198362-4999-2-git-send-email-lorenzo.bianconi83@gmail.com>
	<1406200166.14675.16.camel@jlt4.sipsolutions.net>
Date: Thu, 24 Jul 2014 14:38:17 +0200
Message-ID: <CAA2SeNKzvyv92aETmi-+Gum_Fi96BC-v7B03rmLeX3TATNi6bw@mail.gmail.com> (sfid-20140724_143824_365992_F85B86B5)
Subject: Re: [PATCHv2 1/2] cfg80211: extend coverage_class datatype
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Philippe Duchein <wireless-dev@duchein.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Thu, 2014-07-24 at 12:39 +0200, Lorenzo Bianconi wrote:
>
>> @@ -1269,8 +1270,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
>>                               rdev->wiphy.frag_threshold) ||
>>                   nla_put_u32(msg, NL80211_ATTR_WIPHY_RTS_THRESHOLD,
>>                               rdev->wiphy.rts_threshold) ||
>> -                 nla_put_u8(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS,
>> -                            rdev->wiphy.coverage_class) ||
>> +                 nla_put_s16(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS,
>> +                             rdev->wiphy.coverage_class) ||
>>                   nla_put_u8(msg, NL80211_ATTR_MAX_NUM_SCAN_SSIDS,
>>                              rdev->wiphy.max_scan_ssids) ||
>>                   nla_put_u8(msg, NL80211_ATTR_MAX_NUM_SCHED_SCAN_SSIDS,
>
> This will break existing userspace.
>
> Also please supply a better commit message.
>
> johannes
>

Ack

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep

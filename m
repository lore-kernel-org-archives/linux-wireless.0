Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:48421 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835AbaGXMMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 08:12:22 -0400
Received: by mail-we0-f178.google.com with SMTP id w61so2705761wes.9
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 05:12:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1406200353.14675.18.camel@jlt4.sipsolutions.net>
References: <1406198362-4999-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1406198362-4999-3-git-send-email-lorenzo.bianconi83@gmail.com>
	<1406200353.14675.18.camel@jlt4.sipsolutions.net>
Date: Thu, 24 Jul 2014 14:12:20 +0200
Message-ID: <CAA2SeNLPf6Tt61H5D1j6d3SwO1nuZQM3WuqL8-+15RKLmVAe1w@mail.gmail.com> (sfid-20140724_141226_912707_40A44248)
Subject: Re: [PATCHv2 2/2] mac80211: extend set_coverage_class signature
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Philippe Duchein <wireless-dev@duchein.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Thu, 2014-07-24 at 12:39 +0200, Lorenzo Bianconi wrote:
>
>> @@ -2950,7 +2951,7 @@ struct ieee80211_ops {
>>       int (*get_survey)(struct ieee80211_hw *hw, int idx,
>>               struct survey_info *survey);
>>       void (*rfkill_poll)(struct ieee80211_hw *hw);
>> -     void (*set_coverage_class)(struct ieee80211_hw *hw, u8 coverage_class);
>> +     int (*set_coverage_class)(struct ieee80211_hw *hw, s16 coverage_class);
>
> This patch also needs to update all drivers ......

Currently just ath9k, ath5k and p54 implement set_coverage_class
function pointer. I would send a different patch for these changes.
Should I include them in this patchset?

>
> johannes
>

Lorenzo



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep

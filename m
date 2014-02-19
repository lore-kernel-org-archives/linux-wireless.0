Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:61102 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaBSL1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 06:27:48 -0500
Received: by mail-la0-f44.google.com with SMTP id hr13so193187lab.3
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 03:27:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392807806.4733.14.camel@jlt4.sipsolutions.net>
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
	<1392807806.4733.14.camel@jlt4.sipsolutions.net>
Date: Wed, 19 Feb 2014 12:27:47 +0100
Message-ID: <CALhHN=rAT=FeEJcbDJEPG+-knGgMvV8Mt5eVvWRWD-1BgZYLpQ@mail.gmail.com> (sfid-20140219_122752_752636_913B6795)
Subject: Re: [PATCH 1/4] cfg80211: regulatory, introduce DFS CAC time
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 February 2014 12:03, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-02-12 at 19:54 +0100, Janusz Dziedzic wrote:
>
>> -#define REG_RULE(start, end, bw, gain, eirp, reg_flags) \
>> -{                                                    \
>> -     .freq_range.start_freq_khz = MHZ_TO_KHZ(start), \
>> -     .freq_range.end_freq_khz = MHZ_TO_KHZ(end),     \
>> -     .freq_range.max_bandwidth_khz = MHZ_TO_KHZ(bw), \
>> -     .power_rule.max_antenna_gain = DBI_TO_MBI(gain),\
>> -     .power_rule.max_eirp = DBM_TO_MBM(eirp),        \
>> -     .flags = reg_flags,                             \
>> +#define REG_RULE_EXT(start, end, bw, gain, eirp, dfs_cac, reg_flags) \
>> +{                                                                    \
>> +     .freq_range.start_freq_khz = MHZ_TO_KHZ(start),                 \
>> +     .freq_range.end_freq_khz = MHZ_TO_KHZ(end),                     \
>> +     .freq_range.max_bandwidth_khz = MHZ_TO_KHZ(bw),                 \
>> +     .power_rule.max_antenna_gain = DBI_TO_MBI(gain),                \
>> +     .power_rule.max_eirp = DBM_TO_MBM(eirp),                        \
>> +     .flags = reg_flags,                                             \
>> +     .dfs_cac_ms = dfs_cac,                                          \
>>  }
>>
>> +#define REG_RULE(start, end, bw, gain, eirp, reg_flags) \
>> +     REG_RULE_EXT(start, end, bw, gain, eirp, 0, reg_flags)
>
> I don't see any users of this, is that really useful?
>

genregdb.awk using this when internal regdb is used.

BR
Janusz

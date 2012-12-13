Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:61485 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab2LMWed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:34:33 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2260199lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 14:34:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355159190.8083.1.camel@jlt4.sipsolutions.net>
References: <1354812784-15845-1-git-send-email-johannes@sipsolutions.net>
 <1354812784-15845-3-git-send-email-johannes@sipsolutions.net> <1355159190.8083.1.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 14:34:12 -0800
Message-ID: <CAB=NE6VCiPXwUGO+KZmi4Bhd5PvUwwUscnQ0F3xtd5FurEDN-A@mail.gmail.com> (sfid-20121213_233436_068390_CF0208FF)
Subject: Re: [RFC 2/2] cfg80211: check (VHT) bandwidth against regulatory
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 10, 2012 at 9:06 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-12-06 at 17:53 +0100, Johannes Berg wrote:
>
>> +bool reg_check_bandwidth(struct wiphy *wiphy,
>> +                      u32 center_freq_khz, u32 bw_khz)
>> +{
>> +     const struct ieee80211_reg_rule *reg_rule;
>> +
>> +     /*
>> +      * This interpretation is a bit of a strange quirk in the regulatory
>> +      * rules definitions that we have today: each 20 MHz channel must fit
>> +      * entirely into a single regulatory range, but if this range forbids
>> +      * using more than 20 MHz then it forbids even using a small part of
>> +      * this for the wider channel.
>> +      */
>> +
>> +     reg_rule = freq_reg_info(wiphy, center_freq_khz);
>> +     if (!IS_ERR(reg_rule))
>> +             return reg_rule->freq_range.max_bandwidth_khz >= bw_khz;
>
> This needs rcu_read_lock() obviously... Fixed in my version in the wip
> branch.

Looks good, the get_wiphy_regdom() change above seemed like it'd
belong on a separate patch though.

  Luis

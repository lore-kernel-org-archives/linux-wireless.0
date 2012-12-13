Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50837 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab2LMVyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 16:54:54 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so2237803lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 13:54:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355159114.8083.0.camel@jlt4.sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
 <1354812468-15709-23-git-send-email-johannes@sipsolutions.net> <1355159114.8083.0.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 13:54:31 -0800
Message-ID: <CAB=NE6UDgqiDzaqPFsU_9j8Q-gPACw8nMvzHumkLNiHRGUvqeA@mail.gmail.com> (sfid-20121213_225457_066725_710D970F)
Subject: Re: [PATCH 22/24] regulatory: use RCU to protect global and wiphy regdomains
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 10, 2012 at 9:05 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-12-06 at 17:47 +0100, Johannes Berg wrote:
>
>> -     if (nla_put_string(msg, NL80211_ATTR_REG_ALPHA2,
>> -                        cfg80211_regdomain->alpha2) ||
>> -         (cfg80211_regdomain->dfs_region &&
>> -          nla_put_u8(msg, NL80211_ATTR_DFS_REGION,
>> -                     cfg80211_regdomain->dfs_region)))
>> -             goto nla_put_failure;
>> +     rcu_read_lock();
>> +     regdom = rcu_dereference(cfg80211_regdomain);
>> +
>> +     if (nla_put_string(msg, NL80211_ATTR_REG_ALPHA2, regdom->alpha2) ||
>> +         (regdom->dfs_region &&
>> +          nla_put_u8(msg, NL80211_ATTR_DFS_REGION, regdom->dfs_region)))
>> +             goto nla_put_failure_rcu;
>>
>>       if (reg_last_request_cell_base() &&
>
> This causes a locking issue -- mutex is taken in
> reg_last_request_cell_base(), so it needs to be before the
> rcu_read_lock(). I fixed the version in my mac80211-next.git tree's wip
> branch.

Nice!

Acked-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis

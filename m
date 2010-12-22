Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46933 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab0LVO1N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:27:13 -0500
Received: by iyi12 with SMTP id 12so4096613iyi.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 06:27:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293026617.3531.23.camel@jlt3.sipsolutions.net>
References: <1292864555-28661-1-git-send-email-lrodriguez@atheros.com>
 <1292864555-28661-4-git-send-email-lrodriguez@atheros.com> <1293026617.3531.23.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 22 Dec 2010 09:26:52 -0500
Message-ID: <AANLkTinrn=2oiSQbxV0MnR2WGtjhb6zB6aM159VjRxSL@mail.gmail.com>
Subject: Re: [PATCH 2/2] cfg80211: pass DFS region to drivers through reg_notifier()
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, kathy.giori@atheros.com,
	amod.bodas@atheros.com, david.quan@atheros.com,
	michael.green@atheros.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 9:03 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2010-12-20 at 12:02 -0500, Luis R. Rodriguez wrote:
>
>> +     u8 dfs_region;
>
> u8, when the real value is a u16?

Ah see the field is actually a country flag, but here we just extract
the DFS region.

>> +     last_request->dfs_region = (cfg80211_regdomain->flags &
>> +                                 NL80211_CFLAG_ALL_DFS_FLAGS);
>
> Also -- "regions", not "region" since it's still a bitmask of values. If
> you think it should be a single region, then you should have an enum
> instead.

You're right, for now we can enforce this to be just one region and if
we later want to change it for whatever reason we can allow for one
country to fall into multiple regions, if that makes sense. I hope to
get a better idea from Michael today if this might make sense today.
I'll reply to this thread once I do.

  Luis

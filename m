Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.177]:21887 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbZBTAkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 19:40:45 -0500
Received: by el-out-1112.google.com with SMTP id b25so359928elf.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2009 16:40:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1235050171.4023.64.camel@johannes.local>
References: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com>
	 <1235050171.4023.64.camel@johannes.local>
Date: Thu, 19 Feb 2009 16:40:43 -0800
Message-ID: <43e72e890902191640u107ff0fdse92367fccc975dba@mail.gmail.com> (sfid-20090220_014049_203166_80033F6E)
Subject: Re: [PATCH v4 00/15] cfg80211: add a workqueue for regulatory
	processing
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 19, 2009 at 5:29 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-02-18 at 18:25 -0500, Luis R. Rodriguez wrote:
>> This series has a few cleanups and minor fixes but mainly
>> adds a workqueue for cfg80211 to use to process all regulatory
>> hints. This v4 just changes the spin_lock to only be held _only_ during
>> dequeing (not like this matters much).
>>
>> This series is also rebased on today's pull of wl. Using a new
>> SMTP server now, so hopefully this goes through fine in one shot.
>
> Except for the unlikely(WARN_ON()) which still looks weird, this seems
> ok to me.

Great thanks, I'll post a new series without the unlikely on the
WARN_ON() but also I will change around the spin_lock() so it doesn't
happen before the cfg80211_mutex, that's just not needed as you had
hinted before.

> I don't know why you insist on having a wrapper for
> wiphy->wiphy_idx but it's ok :)

Heh its just because wiphy->wiphy_idx does not exist, the drv has so
you must go to the container and then use that. If we move the idx to
the wiphy then I'm good to use wiphy->wiphy_idx. Want to do that?

  Luis

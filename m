Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50171 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab2LLWCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 17:02:30 -0500
Message-ID: <1355349772.9708.19.camel@jlt4.sipsolutions.net> (sfid-20121212_230234_315095_69C1DB19)
Subject: Re: [RFC 3/6] mac80211: Check for NULL in get-ethtool-stats logic.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Dec 2012 23:02:52 +0100
In-Reply-To: <1355349295-30960-3-git-send-email-greearb@candelatech.com> (sfid-20121212_225626_327122_3F8FF5FB)
References: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
	 <1355349295-30960-3-git-send-email-greearb@candelatech.com>
	 (sfid-20121212_225626_327122_3F8FF5FB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-12 at 13:54 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> In an earlier version of this code, testing found that sometimes
> either sta wasn't found or sta->sdata was NULL.  This caused
> crashes of course.  So, add checks with WARN_ON_ONCE to
> catch these.

I don't know what you tested, but there's absolutely no way that
sta->sdata is NULL... *Especially* not after sta_info_get_bss(), I mean,
look at that function. But once it's on the list it can't be NULL, so
I'm not going to apply this patch.

In the future, I'd appreciate if you could avoid avoid sending patches
for drivers and mac80211 etc. in one series, it gets confusing with who
applies what etc.

johannes


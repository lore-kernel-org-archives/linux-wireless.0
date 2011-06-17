Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:58749 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab1FQLLm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 07:11:42 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 00/27] mac80211: create mac80211_ prefix
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
	<1f42877e8c429b956640a6e9d97127fc@secure.sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 17 Jun 2011 14:11:40 +0300
In-Reply-To: <1f42877e8c429b956640a6e9d97127fc@secure.sipsolutions.net> (Johannes Berg's message of "Thu\, 16 Jun 2011 17\:34\:41 +0200")
Message-ID: <87mxhg1zmb.fsf@purkki.adurom.net> (sfid-20110617_131145_063825_6E95FD96)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 14 Jun 2011 01:34:28 +0300, Kalle Valo wrote:
>
>> In this patchset I first fix some issues I found from the drivers,
>> then create mac80211-compat.h to make the transition as smooth as
>> possible and then start changing mac80211 itself.
>
> FWIW, I don't mind the rename, but I don't like the compat.h thing.
> The transition won't be smoothed by this, it just means the transition
> will drag out as things conflict etc.

My plan was that I will finish the transition and remove
mac80211-compat.h before the next merge window. That way the file
would not be in any of the official releases.

> If we want to rename, we'll need to bite the bullet eventually
> anyway.

What do you suggest here? So that we should rename everything (both
mac80211 and 19 drivers) in one go? If we do that, we would have to do
everything in one patch to not break bisect, and it would be huge.

With mac80211-compat.h it's possible to break down the patches into
small pieces. This makes it easier to create the patches and, most
importantly, review them.

I'm willing to work on that huge patch if we so decide, but I'm not
sure if that's the correct way.

Ah, while writing this I realised that I could instead rename symbols
in mac80211.h one at a time and that way the patches would be smaller.
Did you mean that?

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:62600 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZGaPtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 11:49:52 -0400
Received: by gxk9 with SMTP id 9so3833048gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 08:49:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249026324.29587.15.camel@johannes.local>
References: <1249001028-15110-1-git-send-email-lrodriguez@atheros.com>
	<1249026324.29587.15.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 31 Jul 2009 08:49:32 -0700
Message-ID: <43e72e890907310849l3487b8a2p52302f6662a26f95@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix regression on beacon world roaming feature
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 12:45 AM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Thu, 2009-07-30 at 17:43 -0700, Luis R. Rodriguez wrote:
>
>> By doing so though we also disallowed beacon hints on devices
>> registering their wiphy with custom world regulatory domains
>> enabled, this happens to be currently ath5k, ath9k and ar9170.
>> The passive scan and beacon restrictions on those devices would
>> never be lifted even if we did find a beacon and the hardware did
>> support such enhancements when world roaming.
>
> I dislike this solution, it just adds proliferation of possible
> behaviours.

Agreed.

> Can't those devices

Which devices?

> just set the _flags_ in their reg
> notifier,

So if you mean devices that used custom reg stuff, the answer is no
because the patch which introduced the regression would prevent the
setting of the passive scan flag and beaconing restrictions so the
reg_notifier would never notice the difference.

If you mean iwlwifi devices then yes, this is possible but it also
means a big change and I'd like to see this regression fixed on
2.6.31.

> and clear the corresponding bit in the orig_flags?

iwlwifi would just have to touch flags, not orig_flags as orig_flags
should not be touched.

How about using the patch as is for now for wireless-testing and
2.6.31, and then have iwlwifi write their own reg_notifier() ?

  Luis

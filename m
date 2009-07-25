Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f192.google.com ([209.85.222.192]:60025 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbZGYAG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 20:06:28 -0400
Received: by pzk30 with SMTP id 30so1264659pzk.33
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 17:06:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248459325.32151.32.camel@johannes.local>
References: <1248458909-15338-1-git-send-email-lrodriguez@atheros.com>
	<1248459325.32151.32.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 24 Jul 2009 17:06:09 -0700
Message-ID: <43e72e890907241706s4c2e0df5jfe143b56536bf629@mail.gmail.com>
Subject: Re: [PATCH] mac80211: add helper to add to the mac80211 workqueue
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dan Williams <dcbw@redhat.com>,
	Lennert Buytenhek <buytenh@marvell.com>,
	Daniel Drake <ddrake@brontes3d.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 24, 2009 at 11:15 AM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Fri, 2009-07-24 at 14:08 -0400, Luis R. Rodriguez wrote:
>> We add a mac80211 helper for adding work onto the mac80211
>> workqueue. We then add a warning if we are suspended. At that
>> point drivers nor mac80211 should have queued work, drivers
>> and mac80211 should ensure the workqueue will remain clair
>> until resume.
>>
>> We make use of the helper now in mac80211 and on all mac80211
>> drivers. If you see a warning because of this patch during
>> the suspend <--> resume cycle it means suspend is busted for
>> your driver or mac80211 and it needs to be fixed.
>
> Looks good to me.

Except I forgot about delayed queing, flushing. I will repost and
consider all the other things.

  Luis

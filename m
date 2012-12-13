Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:58290 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab2LMU5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 15:57:44 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2193073lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 12:57:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354922175.9124.34.camel@jlt4.sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
 <1354812468-15709-17-git-send-email-johannes@sipsolutions.net>
 <CAB=NE6VmfjfYeDirc-L-cPMmE6b4f_4iAK+nuDUs1-XUeLCO7w@mail.gmail.com> <1354922175.9124.34.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 12:57:22 -0800
Message-ID: <CAB=NE6VABjP=-ysYALAC=hc==sXp2ghPq925eJZCTTYnPqDLzg@mail.gmail.com> (sfid-20121213_215747_547691_4CCA9686)
Subject: Re: [PATCH 16/24] regulatory: clarify locking rules and assertions
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 7, 2012 at 3:16 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-12-07 at 15:11 -0800, Luis R. Rodriguez wrote:
>
>> > The reason for this is that nl80211 uses the regdom
>> > without being able to hold reg_mutex.
>>
>> Hm, do we want to do this or add a caller to reg.c that gets nl80211
>> to copy over the current regdomain over for it to parse and then send?
>> In that case we'd only need the cfg80211_mutex for
>> update_all_wiphy_regulatory(). Thoughts?
>
> I think you should look at the later patches :)

I'm on it now.

  Luis

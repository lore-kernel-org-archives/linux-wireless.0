Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:56076 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbZIYQxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 12:53:55 -0400
Received: by iwn8 with SMTP id 8so1692145iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 09:53:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <da94abde0909250947k5084db85vccafe0d3e74e2ecf@mail.gmail.com>
References: <20090924180048.14503.9579.stgit@tikku> <43e72e890909241320j592e347die8a14f8bdd962ffb@mail.gmail.com>
	<20090925044258.GA2722@tuxdriver.com> <da94abde0909250947k5084db85vccafe0d3e74e2ecf@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 25 Sep 2009 09:53:35 -0700
Message-ID: <43e72e890909250953r1714c79bsa679b96ca6f5797@mail.gmail.com>
Subject: Re: [PATCH 0/2] cfg80211: firmware and hardware version
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 25, 2009 at 9:47 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> On Thu, Sep 24, 2009 at 9:42 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> On Thu, Sep 24, 2009 at 01:20:35PM -0700, Luis R. Rodriguez wrote:
>>> On Thu, Sep 24, 2009 at 11:02 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
>>> > Here's my suggestion how to provide firmware and hardware version to
>>> > user space. First I was thinking adding a new nl80211 command and
>>> > it looked so ugly that I decided include the versions in struct wiphy
>>> > instead.
>>> >
>>> > Please comment.
>>>
>>> What was the conclusion on ethtool stuff again? I forgot.
>>
>> IIRC, I suggested that the cfg80211 driver API (or just the wiphy
>> data structure) could be extended for appropriate bits like this,
>> then cfg80211 could catch ethtool operations in a way similar to how
>> it catches wireless extensions now.
>
> Oh, then I misunderstood our discussion at the summit, my
> understanding was that we will use nl80211 anyway. Sorry about that.
>
> But we want to export two strings to user space (at least for now), is
> it really worth the effort to add ethtool support for such a minor
> feature? Also I have understood that ethtool is implemented only for
> ethernet drivers, I don't feel comfortable that we use ethernet driver
> interfaces with 802.11 device drivers. They are so much different that
> there isn't that much common functionality. That's why I prefer
> nl80211 over ethtool.
>
> What do people think?

So for Wake-on-Wireless I ran into the same, ethtool just did not
offer the same wake up events needed for wireless. I could have
technically used ethtool and expanded it to support wireless but it
just seemed dirty.

I agree that using ethtool seems overkill compared to the patches you posted.

  Luis

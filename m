Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:40714 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbZAWJcE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 04:32:04 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: vivek.natraj@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/2] mac80211: ps-poll implementation
References: <20090122114240.31443.18218.stgit@tikku>
	<1232629209.4224.2.camel@johannes.local>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Fri, 23 Jan 2009 11:31:15 +0200
In-Reply-To: <1232629209.4224.2.camel@johannes.local> (ext Johannes Berg's message of "Thu\, 22 Jan 2009 14\:00\:09 +0100")
Message-ID: <87prie8j30.fsf@nokia.com> (sfid-20090123_103210_692640_21D1DBA2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Johannes Berg" <johannes@sipsolutions.net> writes:

>> Open question is that should power save be disabled whenever mac80211
>> is ps-polling the frames. For example, p54/stlc45xx does not require to
>> disable power save in that case, it just stays awake long enough to
>> receive the data frame from the AP. So I did not disable power save
>> mode in this case, but I would like to hear comments what other
>> hardware needs.
>
> I just checked, Broadcom's hardware/firmware definitely requires doing
> this in software.

Ok. The problem is that stlc45xx/p54spi requires us to send a null
frame every time we enable power save and that's causing problems, at
least that's my current theory. So I need to solve this somehow, I
need to think this more.

But can we still apply these patches? Because b43 doesn't support
power save at all, and ath9k with dynamic power save disabled was
already broken before my patches, I consider these patches as a step
forward. And I would like to go forward one small step at a time,
maintaining huge patches myself until all issues are fixed is quite
difficult.

-- 
Kalle Valo

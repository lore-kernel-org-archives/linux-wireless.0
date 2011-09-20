Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36749 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1ITNkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 09:40:23 -0400
Received: by wyg34 with SMTP id 34so509961wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 06:40:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316524874.3953.41.camel@jlt3.sipsolutions.net>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
	<20110920130338.GA9885@kroah.com>
	<1316524874.3953.41.camel@jlt3.sipsolutions.net>
Date: Tue, 20 Sep 2011 15:40:22 +0200
Message-ID: <CACna6rxzTz5tP1VkT7+bjXh=9w7+ZBu=y4wnW2XGi2wG+a8-sA@mail.gmail.com> (sfid-20110920_154026_639062_5F1C88C6)
Subject: Re: [PATCH 00/20] staging: brcm80211: 7th reaction for mainline patch #2
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg KH <greg@kroah.com>, Franky Lin <frankyl@broadcom.com>,
	gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/20 Johannes Berg <johannes@sipsolutions.net>:
> On Tue, 2011-09-20 at 06:03 -0700, Greg KH wrote:
>
>> And while code is great and nice, I still haven't seen any real answers
>> to all of the questions that were asked of the Broadcom driver team
>> during that review by the linux-wireless developers about how things
>> will be handled properly due to the overlap in functionality with the
>> existing "real" driver in the tree.
>
> Let's qualify this to "some developers".
>
> One thing I'd like to point out is that the Broadcom's firmware API has
> always undergone changes over time. I'm actually surprised that b43
> works as well as it does (which, tbh, isn't very well at all, at least
> for me with some 11n PHY). I also don't think that Broadcom are going to
> maintain compatibility and/or maintain new firmware features for old
> devices, that just doesn't make any sense.

It's hard to talk about API compatibility breakage, until it really
happens. So far we support all firmwares, I don't have much more to
say about that. We can decide about some driver splitting, when API
breakage really happens. Now I think that are just thoeritical talks.


> As a consequence, I don't think there's any sense in saying b43 should
> be the driver that Broadcom must support upstream. Even we, back then,
> split b43 into b43 and b43legacy when it wasn't really possible any more
> to test and maintain a single driver for different devices. Rafal has
> shown that it is possible today (to some extent) to do that for the
> newer chips and the older 11g only chips that b43 still supports, but
> I'm not convinced that with new features like P2P this will be true in
> the future.

That's what we try to discuss with Broadcom. If they really see a
requirement to split driver into 2, they have to explain that and
discuss it with us.

I'm flexible, I've accepted Michaels' view on SSB & BCMA. We just need
to make Broadcom talk with us.


> And this is just discussing the technical side -- the support side is an
> entirely different question.
>
> Now, don't get me wrong -- I don't think the duplication is a good
> thing. A lot of the PHY code could be shared. However, I think it will
> probably not be possible for much longer to share the higher level MAC
> code that programs the SHM etc.
>
> So I don't claim to know what the solution is, but I think simply
> rejecting the Broadcom effort like most people seem to imply is a good
> solution at all. It will leave all of us in a bad spot by creating a
> driver that has to support too many different devices.

Having Broadcom ignoring all out questions and just sending more&more
patches is not good as well. How differently we can make them talk?
I've requested for discussion several times.

-- 
Rafał

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39199 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471AbYLGV4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 16:56:55 -0500
Message-Id: <1228687013.25070.1288752601@webmail.messagingengine.com> (sfid-20081207_225659_734197_3B46C1DF)
From: "Dan E" <trg_info@mailhaven.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
References: <1228454249.2652.1288380409@webmail.messagingengine.com>
 <43e72e890812042132y6b676a1ucf446a678e1d8a81@mail.gmail.com>
 <1228515313.30577.1288527655@webmail.messagingengine.com>
 <20081206001956.GE5926@tesla>
Subject: Re: CRDA question
In-Reply-To: <20081206001956.GE5926@tesla>
Date: Sun, 07 Dec 2008 16:56:53 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 5 Dec 2008 16:19:56 -0800, "Luis R. Rodriguez" wrote:
> 
> <snip>
> 
> It makes zero sense for you to package CRDA for 2.6.27 unless you want
> to help users of compat-wireless or wireless-testing.

True, but I'm new to this bleeding-edge development stuff so give me a
break :)

> 
> <snip>
> 
> Userspace applications which *do* want to test against a feature can do
> tests
> like:
> 
> #ifdef NL80211_NEW_STUFF
> #endif
> 
> as wpa_supplicant does it, but that's up to each developer.

My goal is writing a new driver for an unsupported chipset and advancing
the mac80211 effort so that things like wpa_supplicant can be made
obsolete sooner rather than later.

> Here are the #ifdef'able features:
> 
> NL80211_CMD_SET_BSS
> 
> NL80211_ATTR_HT_CAPABILITY
> NL80211_ATTR_BSS_BASIC_RATES
> NL80211_ATTR_WIPHY_TXQ_PARAMS
> NL80211_ATTR_WIPHY_FREQ
> NL80211_ATTR_WIPHY_SEC_CHAN_OFFSET
> 
> In CRDA's case I'm sticking to the packaged nl80211.h.

Thanks for the list.  As for CRDA and IW, I'm sticking to my local
patches that get rid of that local header file.  I can think of no other
project that does that, save for the old wireless extensions.

> 
> <snip>
> 
> We had a long discussion about this a long time ago and my first
> approach was to do it all in-kernel, then people complained and we moved
> it to userspace. Now its there and it works well. If you are so
> concerned about the size of the database then trim it yourself, make
> your let CRDA use it, or go ahead and customize the kernel and define
> statically your *one* single regulatory domain.
> 
> Supporting regulatory considerations on STA/AP for different countries
> requires that you do have some sort of regulatory information somewhere.
> Some people keep it in firmware, some in the driver, and some in a
> combination of EEPROM and driver or even some info from Windows registry
> files.
> We've generalized what we can from all drivers. If you think you can do a
> better job please send patches and go through the review cycle.

I have read all those discussions in the archives.  My intent isn't to
re-hash old arguments or open up that debate again.  For now I'm going
to accept it for what it is since my development system isn't as
constrained for resources as the ultimate embedded Linux system will be.
 The CRDA code itself is excellent and makes a great example for how to
do things with nl80211 and cfg80211.

> If you have actual issues to point out then please point them out or
> better yet just send a patch for the solution.

Indeed.  I envision an alternative scheme that can be optionally
selected as part of a "reduced footprint for embedded systems" patch
set/git branch, but that's a ways off.  Right now I just want to get my
driver working and advance the userspace tools needed to help develop,
test, and validate its operation.  Hopefully I can contribute along the
way to the cfg80211/nl80211 development effort.

Thanks for your comments.  You've obviously been doing a lot of work in
this area.  I'm still climbing the learning curve, so I value your
insight and experience tremendously.

[OT: Is it correct to reply TO your email addy and CC the list address,
or is it better to "Reply All"?  I have to install a real email client
and ditch the webmail interface soon for git purposes.]

--
Dan

-- 
http://www.fastmail.fm - IMAP accessible web-mail


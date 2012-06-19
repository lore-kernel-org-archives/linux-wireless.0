Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60982 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2FSHGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 03:06:07 -0400
Message-ID: <1340089558.4482.5.camel@jlt3.sipsolutions.net> (sfid-20120619_090611_471328_37446184)
Subject: Re: [PATCH 0/2 v3] mac80211/cfg80211: add support for userspace to
 handle auth frames on adhoc ifaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Hawkins <hawkinsw@opentechinstitute.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Antonio Quartulli <ordex@autistici.org>
Date: Tue, 19 Jun 2012 09:05:58 +0200
In-Reply-To: <4FDFC5AE.1080004@opentechinstitute.org>
References: <4FDFC5AE.1080004@opentechinstitute.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Will,

> I am sending along 2 patches to add support for user space applications
> to register for authentication frames on adhoc interfaces. These are
> revisions to a previous patch that I submitted to accomplish the same
> thing.

Thanks.

> Patch 1/2 adds a cfg80211_mgmt_reg_match function to cfg80211 to
> check whether a user space application is registered for a particular
> type of management frame rx'd on a particular device. The new function
> is very similar to cfg80211_rx_mgmt. cfg80211_rx_mgmt could not be
> reused because of its side-effect of transmitting the "query" frames to
> the registered userspace applications. This patch modifies the
> documentation for cfg80211_rx_mgmt to reflect that.

I think this isn't needed: if you look at mac80211/cfg.c, there's a
handler called ieee80211_mgmt_frame_register() where cfg80211 tells
mac80211 when a handler is registered/unregistered. mac80211 could just
keep track (for IBSS type interfaces) all by itself, and then just needs
to check some flag/variable instead of calling a function.

> Patch 2/2 sets the necessary flags to allow userspace
> applications to register for authentication frames on adhoc interfaces.
> It also adds a check to make sure that "open" authentication frames are
> not sent when a user space application is registered for authentication
> frames.

Makes sense. I'll need to check if you caught all conditions, maybe
Antonio can help out.

> As I've said before, I'm still new to this process so I look forward to
> your feedback on improving.

There's not a lot of room for improvement :-)

A small detail: the first patch should have been labelled only
"cfg80211" and the second only "mac80211".

Also, if you could send the patches (1/2 and 2/2) as a reply to the
cover letter (0/2) that helps keep the series together due to threading.
With git send-email you can instruct it to do that, but it didn't look
like you used it.

Thanks!

johannes


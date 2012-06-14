Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43595 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab2FNLY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 07:24:58 -0400
Message-ID: <1339673095.4461.2.camel@jlt3.sipsolutions.net> (sfid-20120614_132502_022325_E0CC951E)
Subject: Re: [PATCH] mac80211: add support for userspace to handle auth
 frames on adhoc ifaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: Will Hawkins <hawkinsw@opentechinstitute.org>,
	linux-wireless@vger.kernel.org
Date: Thu, 14 Jun 2012 13:24:55 +0200
In-Reply-To: <4FD99A24.3020907@lri.fr>
References: <4FD8B5D4.8060305@opentechinstitute.org>
	 <4FD99A24.3020907@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-14 at 10:00 +0200, Nicolas Cavallari wrote:

> I just have a question here : when auth frames are not delivered to
> userspace, mac80211 will respond to them, and also uses them to detect
> node reboot. If you register for auth frames, mac80211 will still send
> auth frames as soon as a new station is seen, which might be confusing
> for user space. Is that ok to do this ? Or should userspace have more
> control over how mac80211 sends auth frames ?

Please read the code. If userspace registers for them, mac80211 will
never do anything with the frame.

> There is also another thing to consider if you want to send auth frames
> from userspace, as CMD_FRAME requires a frequency, which in IBSS mode,
> can change anytime without userspace being notified. If you only have to
> answer to received auth frames, this is easier as you can reuse the
> frequency given by nl80211 when receiving the auth frame. But if you
> want to send a auth frame independently, how do you get the frequency to
> use ?

You check the BSS info, that's trivial.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:49229 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab2FNILm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 04:11:42 -0400
Message-ID: <4FD99A24.3020907@lri.fr> (sfid-20120614_101212_472876_C4379B40)
Date: Thu, 14 Jun 2012 10:00:36 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Will Hawkins <hawkinsw@opentechinstitute.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add support for userspace to handle auth frames
 on adhoc ifaces
References: <4FD8B5D4.8060305@opentechinstitute.org>
In-Reply-To: <4FD8B5D4.8060305@opentechinstitute.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13/06/2012 17:46, Will Hawkins wrote:
> Hello all!
> 
> This patch allows userspace applications to use nl80211 to register for
> AUTH frames received on adhoc interfaces.

Hi,

I just have a question here : when auth frames are not delivered to
userspace, mac80211 will respond to them, and also uses them to detect
node reboot. If you register for auth frames, mac80211 will still send
auth frames as soon as a new station is seen, which might be confusing
for user space. Is that ok to do this ? Or should userspace have more
control over how mac80211 sends auth frames ?

There is also another thing to consider if you want to send auth frames
from userspace, as CMD_FRAME requires a frequency, which in IBSS mode,
can change anytime without userspace being notified. If you only have to
answer to received auth frames, this is easier as you can reuse the
frequency given by nl80211 when receiving the auth frame. But if you
want to send a auth frame independently, how do you get the frequency to
use ?

I ask because i was currently trying to move the node reboot detection
from the kernel to userspace, and i currently only fixed these problems
by ugly hacks.

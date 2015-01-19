Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36465 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbbASUdK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 15:33:10 -0500
Message-ID: <1421699585.1965.45.camel@sipsolutions.net> (sfid-20150119_213314_615196_EE89066C)
Subject: Re: [PATCH] mac80211: only roll back station states for WDS when
 suspending
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Jan 2015 21:33:05 +0100
In-Reply-To: <1421699291-16279-1-git-send-email-luca@coelho.fi>
References: <1421699291-16279-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-19 at 22:28 +0200, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> In the suspend code, we shouldn't roll back the station states because
> this is taken care of in other parts of the code, except for WDS
> interfaces.  For AP types of interfaces, cfg80211 takes care of
> disconnecting all stations before calling the driver's suspend code.
> For station interfaces, this will be done in the quiesce code.

That's actually correct only in the corner case of ongoing
authentication or association - in the common case of being associated
while suspending it's also handled by cfg80211. Similarly, of course,
for mesh and IBSS.

Would perhaps be worth mentioning that here.

johannes


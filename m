Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58579 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2CHGzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 01:55:14 -0500
Subject: Re: bss_info_change_notify warning (hacked 3.3.0-rc5+)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4F57B7E6.1050103@candelatech.com> (sfid-20120307_203301_816701_DF7D4715)
References: <4F57B7E6.1050103@candelatech.com>
	 (sfid-20120307_203301_816701_DF7D4715)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Mar 2012 07:55:09 +0100
Message-ID: <1331189709.3446.1.camel@jlt3.sipsolutions.net> (sfid-20120308_075518_821693_720FA118)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-07 at 11:32 -0800, Ben Greear wrote:
> This is with a somewhat hacked 3.3.0-rc5+.  Just
> curious if this is a known problem.
> 
> 
> Seems very reproducible on my system.
> 
> 
> WARNING: at /home/greearb/git/linux-3.3.dev.y/net/mac80211/driver-ops.h:10 ieee80211_bss_info_change_noti)

The warning means you're modifying an interface the driver doesn't (yet)
know about.

It's odd that you should be running into this on config_beacon() though
since that can only execute when the interface is up ... can you print
out the interface name in the warning?

johannes


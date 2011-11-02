Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1KBHxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 03:53:41 -0400
Subject: Re: [wireless-next PATCH 1/5] mac80211: Support forcing station to
 disable 11n.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EAAFAA7.8090403@candelatech.com> (sfid-20111028_205543_472872_4928ADE0)
References: <1319778680-11405-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111028_071135_777672_88A08497) <1319789318.3914.10.camel@jlt3.sipsolutions.net>
	 <4EAAFAA7.8090403@candelatech.com> (sfid-20111028_205543_472872_4928ADE0)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 08:53:35 +0100
Message-ID: <1320220415.3950.1.camel@jlt3.sipsolutions.net> (sfid-20111102_085348_999807_9300A93B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-28 at 11:55 -0700, Ben Greear wrote:

> > This should be a parameter to connect() and assoc(), not a generic
> > netdev parameter, since it applies to the connection.
> >
> > Also, it would be good to have a capability check for it etc. since a
> > lot of fullmac drivers will likely never implement this.
> 
> The existing code always sets the IEEE80211_STA_DISABLE_11N flag in u.mgd if
> WEP or TKIP is configured, without any capability checks, and my patch
> sets that flag in the same location.
> 
> So, maybe it is OK as is?
> 
> If not, I will add a new capability bit and just enable
> it in ath9k (and let others enable it in their drivers as they wish).

You misunderstood -- I said fullmac drivers, not differences between
ath9k, iwlwifi etc. Other cfg80211 drivers, not other mac80211 drivers.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51940 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414AbbGQJQx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 05:16:53 -0400
Message-ID: <1437124610.1933.8.camel@sipsolutions.net> (sfid-20150717_111704_221979_4187B89F)
Subject: Re: [PATCH 08/10] mac80211: shut down interfaces before destroying
 interface list
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 17 Jul 2015 11:16:50 +0200
In-Reply-To: <1436359312-26533-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150708_144234_957308_D5968C26)
References: <1436359312-26533-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1436359312-26533-9-git-send-email-emmanuel.grumbach@intel.com>
	 (sfid-20150708_144234_957308_D5968C26)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-07-08 at 15:41 +0300, Emmanuel Grumbach wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If the hardware is unregistered while interfaces are up, mac80211 
> will
> unregister all interfaces, which in turns causes mac80211 to be 
> called
> again to remove them all from the driver and eventually shut down the
> hardware.
> 
> During this shutdown, however, it's currently already unsafe to 
> iterate
> the list of interfaces atomically, as the list is manipulated in an
> unsafe manner. This puts an undue burden on the driver - it must stop
> all its activities before calling ieee80211_unregister_hw(), while in
> the normal stop path it can do all cleanup in the stop method. If, 
> for
> example, it's using the iteration during RX for some reason, it would
> have to stop RX before unregistering to avoid crashes.
> 
> Fix this problem by closing all interfaces before unregistering them.
> This will cause the driver stop to have completed before we 
> manipulate
> the interface list, and after the driver is stopped *and* has called
> ieee80211_unregister_hw() it really musn't be iterating any more as
> the memory will be freed as well.
> 
Applied.

johannes

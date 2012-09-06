Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49270 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab2IFPhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 11:37:35 -0400
Message-ID: <1346945892.5469.19.camel@jlt4.sipsolutions.net> (sfid-20120906_173739_959254_77CC3194)
Subject: Re: [PATCH 1/2] mac80211: use synchronize_net() on key destroying
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 06 Sep 2012 17:38:12 +0200
In-Reply-To: <1346865837-32265-2-git-send-email-eliad@wizery.com> (sfid-20120905_192353_681041_CEDFC81E)
References: <1346865837-32265-1-git-send-email-eliad@wizery.com>
	 <1346865837-32265-2-git-send-email-eliad@wizery.com>
	 (sfid-20120905_192353_681041_CEDFC81E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-05 at 20:23 +0300, Eliad Peller wrote:
> __ieee80211_key_destroy() calls synchronize_rcu() in
> order to sync the tx path before destroying the key.
> 
> However, synching the tx path can be done with
> synchronize_net() as well, which is usually faster
> (the timing might be important for roaming scenarios).

Applied.

johannes


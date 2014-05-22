Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44448 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbaEVNuo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 09:50:44 -0400
Message-ID: <1400766635.4174.18.camel@jlt4.sipsolutions.net> (sfid-20140522_155052_058308_9EEF985C)
Subject: Re: [PATCH 3/3] mac80211: make csa_currnet_counter atomic
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 22 May 2014 15:50:35 +0200
In-Reply-To: <1400765294-14732-4-git-send-email-michal.kazior@tieto.com> (sfid-20140522_153531_176293_CBD1F6EB)
References: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com>
	 <1400765294-14732-4-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140522_153531_176293_CBD1F6EB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

typo in subject.

On Thu, 2014-05-22 at 15:28 +0200, Michal Kazior wrote:
> Even it ieee80211_beacon_get() and
> ieee80211_csa_update_counter() were to be
> guaranteed to be serialized by drivers it still
> couldn't be guaranteed to be safe on SMP systems.

We had this debate internally as well, but I don't see where issues
should be. The only place updating the counter is
ieee80211_csa_update_counter(), and that should only be called either by
the driver, or by ieee80211_beacon_get[_tim]() [*]. If the driver wants
to have the counter update by ieee80211_beacon_get() then it must call
the function once every beacon interval, if it uses the _template()
version then it must call ieee80211_csa_update_counter() every beacon
interval, so no races seem possible.

johannes

[*] the driver shouldn't call ieee80211_beacon_get[_tim] and
ieee80211_csa_update_counter() in a mixed fashion anyway as that'd lead
to CSA counter bugs, and ieee80211_beacon_get_template() doesn't change
the counter


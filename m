Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40372 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbcGFNDg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 09:03:36 -0400
Message-ID: <1467810206.5460.12.camel@sipsolutions.net> (sfid-20160706_150339_725056_8A90653A)
Subject: Re: [PATCH v2] cfg80211: Add mesh peer AID setting API
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Masashi Honma <masashi.honma@gmail.com>,
	linux-wireless@vger.kernel.org, j@w1.fi
Date: Wed, 06 Jul 2016 15:03:26 +0200
In-Reply-To: <20160706125826.GA7819@localhost> (sfid-20160706_145831_452947_AB83CB96)
References: <1467277258-2331-1-git-send-email-masashi.honma@gmail.com>
 <1467335974-2802-1-git-send-email-masashi.honma@gmail.com>
 <1467808954.5460.6.camel@sipsolutions.net>
	 <20160706125826.GA7819@localhost> (sfid-20160706_145831_452947_AB83CB96)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > It seems to me that it could just use the
> > regular NL80211_ATTR_STA_AID
> > attribute, and the cfg80211 code would already be in place, and
> > you'd
> > just need to add a single line to mac80211 and
> > to cfg80211_check_station_change() to accept that.
> 
> We are already using NL80211_ATTR_STA_AID, though -- one is for the
> station's AID (in our TIM, which is NL80211_ATTR_STA_AID) and the new
> one
> is for our AID in the peer's TIM.
> 
> There is the NL80211_ATTR_PEER_AID but that seems specific to TDLS
> and
> also doesn't appear to be processed in the necessary way (e.g.
> overrides
> STA_AID in nl80211_new_station).

Oh, ok. Applied then.

johannes

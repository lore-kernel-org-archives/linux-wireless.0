Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35684 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbcGFM6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 08:58:50 -0400
Received: by mail-io0-f173.google.com with SMTP id f30so198919197ioj.2
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2016 05:58:30 -0700 (PDT)
Date: Wed, 6 Jul 2016 08:58:26 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Masashi Honma <masashi.honma@gmail.com>,
	linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [PATCH v2] cfg80211: Add mesh peer AID setting API
Message-ID: <20160706125826.GA7819@localhost> (sfid-20160706_145855_645013_AA52C216)
References: <1467277258-2331-1-git-send-email-masashi.honma@gmail.com>
 <1467335974-2802-1-git-send-email-masashi.honma@gmail.com>
 <1467808954.5460.6.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1467808954.5460.6.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 06, 2016 at 02:42:34PM +0200, Johannes Berg wrote:
> > + * @NL80211_ATTR_MESH_PEER_AID: Association ID for the mesh peer
> > (u16). This is
> > + *	used to pull the stored data for mesh peer in power save
> > state.
> > 
> Why does this need new API all over?
> 
> It seems to me that it could just use the regular NL80211_ATTR_STA_AID
> attribute, and the cfg80211 code would already be in place, and you'd
> just need to add a single line to mac80211 and
> to cfg80211_check_station_change() to accept that.

We are already using NL80211_ATTR_STA_AID, though -- one is for the
station's AID (in our TIM, which is NL80211_ATTR_STA_AID) and the new one
is for our AID in the peer's TIM.

There is the NL80211_ATTR_PEER_AID but that seems specific to TDLS and
also doesn't appear to be processed in the necessary way (e.g. overrides
STA_AID in nl80211_new_station).

-- 
Bob Copeland %% http://bobcopeland.com/

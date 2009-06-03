Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1461 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459AbZFCM0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 08:26:07 -0400
Date: Wed, 3 Jun 2009 08:22:51 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, henk@god.dyndns.org,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com
Subject: Re: [PATCH] ath5k: disable beacon interrupt when interface is down
Message-ID: <20090603122251.GA5117@hash.localnet>
References: <1243998186-9200-1-git-send-email-me@bobcopeland.com> <1244012944.7176.16.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244012944.7176.16.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 03, 2009 at 09:09:04AM +0200, Johannes Berg wrote:
> On Tue, 2009-06-02 at 23:03 -0400, Bob Copeland wrote:
> > When we remove the active interface, there's no need to continue
> > sending beacons; doing so would cause a null pointer deref in
> > ieee80211_beacon_get().  Disable the interrupt in remove_interface
> > and add a WARN_ON(!vif) in case there are other instances lurking.
> 
> There's a beacon_enabled setting passed in from mac80211, you should
> just use that?

Hmm, yeah, I didn't know that.  I'll check it out.

-- 
Bob Copeland %% www.bobcopeland.com


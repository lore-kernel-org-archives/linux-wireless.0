Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48085 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933572AbbFVL7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 07:59:42 -0400
Message-ID: <1434974380.19597.10.camel@sipsolutions.net> (sfid-20150622_135945_438849_722C306F)
Subject: Re: [PATCH 2/3] ath9k: make rxfilter per HW
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	nbd@openwrt.org, sujith@msujith.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Date: Mon, 22 Jun 2015 13:59:40 +0200
In-Reply-To: <1434974312.19597.9.camel@sipsolutions.net> (sfid-20150622_135841_850054_31462557)
References: <1434973385-15865-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1434973385-15865-3-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20150622_134339_744222_8D689257) <1434974312.19597.9.camel@sipsolutions.net>
	 (sfid-20150622_135841_850054_31462557)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-06-22 at 13:58 +0200, Johannes Berg wrote:
> On Mon, 2015-06-22 at 13:43 +0200, Janusz Dziedzic wrote:
> > mac80211 configure rxfilter per HW,
> > so we don't need this per channel.
> 
> As I said before, I think there's value in mac80211 doing it per chanctx
> or even per vif, and it should be more efficient to do so.
> 
> It's tempting to do it per vif and leave the chanctx work up to the
> driver, but perhaps with CSA and all that it gets complicated enough
> that doing it per chanctx in mac80211 would make sense?

On the other hand, I think our device requires it per vif, so we'd
probably have to do both.

+Andrei, who was looking into this.

johannes

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in

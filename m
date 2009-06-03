Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41435 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZFCSAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 14:00:38 -0400
Date: Wed, 3 Jun 2009 13:48:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, henk@god.dyndns.org,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com
Subject: Re: [PATCH] ath5k: disable beacon interrupt when interface is down
Message-ID: <20090603174833.GE3317@tuxdriver.com>
References: <1243998186-9200-1-git-send-email-me@bobcopeland.com> <1244012944.7176.16.camel@johannes.local> <20090603122251.GA5117@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090603122251.GA5117@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 03, 2009 at 08:22:51AM -0400, Bob Copeland wrote:
> On Wed, Jun 03, 2009 at 09:09:04AM +0200, Johannes Berg wrote:
> > On Tue, 2009-06-02 at 23:03 -0400, Bob Copeland wrote:
> > > When we remove the active interface, there's no need to continue
> > > sending beacons; doing so would cause a null pointer deref in
> > > ieee80211_beacon_get().  Disable the interrupt in remove_interface
> > > and add a WARN_ON(!vif) in case there are other instances lurking.
> > 
> > There's a beacon_enabled setting passed in from mac80211, you should
> > just use that?
> 
> Hmm, yeah, I didn't know that.  I'll check it out.

I'll take this one for now, and you can send a better one on top when
you're ready.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

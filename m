Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33600 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbcHAKQd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 06:16:33 -0400
Message-ID: <1470044330.3389.19.camel@sipsolutions.net> (sfid-20160801_121708_671659_B84D7674)
Subject: Re: [PATCH 1/4] mac80211: mesh: flush stations before beacons are
 stopped
From: Johannes Berg <johannes@sipsolutions.net>
To: "Machani, Yaniv" <yanivma@ti.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "Hahn, Maital" <maitalm@ti.com>
Date: Mon, 01 Aug 2016 11:38:50 +0200
In-Reply-To: <AE1C82FB3D0EC64DB1F752C81CBD1101391FC38C@DFRE01.ent.ti.com> (sfid-20160713_121132_350432_32DE2AAC)
References: <20160628111307.8784-1-yanivma@ti.com>
	 <20160628111307.8784-2-yanivma@ti.com>
	 (sfid-20160628_131058_738638_5F9A964D)
 <1467184459.2461.1.camel@sipsolutions.net>
	 <AE1C82FB3D0EC64DB1F752C81CBD1101391FC38C@DFRE01.ent.ti.com>
	 (sfid-20160713_121132_350432_32DE2AAC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-07-13 at 10:11 +0000, Machani, Yaniv wrote:
> On Wed, Jun 29, 2016 at 10:14:19, Johannes Berg wrote:
> > Cc: Hahn, Maital
> > Subject: Re: [PATCH 1/4] mac80211: mesh: flush stations before
> > beacons 
> > are stopped
> > 
> > On Tue, 2016-06-28 at 14:13 +0300, Yaniv Machani wrote:
> > > From: Maital Hahn <maitalm@ti.com>
> > > 
> > > Some drivers (e.g. wl18xx) expect that the last stage in the 
> > > de-initialization process will be stopping the beacons, similar
> > > to ap.
> > > Update ieee80211_stop_mesh() flow accordingly.
> > > 
> > How well have you tested that with other drivers?
> > 
> 
> Sorry for the delayed response (I've been out) and thanks for your
> comments,
> I have tested it with RT3572 as well, and didn't see any issue.
> I'll update the comment to reflect that.
> 

I'm actually reasonably sure that it *must* work, similiar to the AP
mode change, since it's always valid to remove stations while the the
mesh beacon is still active.

I hoped you'd actually figure out that line of reasoning and put it
into the commit message :)

johannes

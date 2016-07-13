Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:37529 "EHLO
	mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbcGMNeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 09:34:24 -0400
Received: by mail-it0-f51.google.com with SMTP id f6so43137704ith.0
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2016 06:34:05 -0700 (PDT)
Date: Wed, 13 Jul 2016 09:33:38 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Machani, Yaniv" <yanivma@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Hahn, Maital" <maitalm@ti.com>
Subject: Re: [PATCH 1/4] mac80211: mesh: flush stations before beacons are
 stopped
Message-ID: <20160713133338.GD7819@localhost> (sfid-20160713_153635_675321_24C15221)
References: <20160628111307.8784-1-yanivma@ti.com>
 <20160628111307.8784-2-yanivma@ti.com>
 <1467184459.2461.1.camel@sipsolutions.net>
 <AE1C82FB3D0EC64DB1F752C81CBD1101391FC38C@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AE1C82FB3D0EC64DB1F752C81CBD1101391FC38C@DFRE01.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 13, 2016 at 10:11:25AM +0000, Machani, Yaniv wrote:
> > > Some drivers (e.g. wl18xx) expect that the last stage in the 
> > > de-initialization process will be stopping the beacons, similar to ap.
> > > Update ieee80211_stop_mesh() flow accordingly.
> > >
> > How well have you tested that with other drivers?
> > 
> 
> Sorry for the delayed response (I've been out) and thanks for your comments,
> I have tested it with RT3572 as well, and didn't see any issue.
> I'll update the comment to reflect that.

I'll give this a test on ath10k and wcn36xx as they are the ones most
likely to care about ordering.

-- 
Bob Copeland %% http://bobcopeland.com/

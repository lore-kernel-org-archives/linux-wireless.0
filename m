Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36645 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151AbbAWNUQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 08:20:16 -0500
Message-ID: <1422019208.2728.34.camel@sipsolutions.net> (sfid-20150123_142020_266482_9668F400)
Subject: Re: [PATCH] mac80211: synchronize_net() before flushing the queues
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 23 Jan 2015 14:20:08 +0100
In-Reply-To: <CANUX_P0wvnNKV+-TtGV62ujMxtDDbJ=uEhaxKQF2ePvBcvyOnA@mail.gmail.com> (sfid-20150123_123607_358282_F98B1290)
References: <1421962219-6840-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1422006994.2728.22.camel@sipsolutions.net>
	 <1422008312.13429.5.camel@egrumbacBox>
	 <1422009226.2728.31.camel@sipsolutions.net>
	 <CANUX_P0wvnNKV+-TtGV62ujMxtDDbJ=uEhaxKQF2ePvBcvyOnA@mail.gmail.com>
	 (sfid-20150123_123607_358282_F98B1290)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-23 at 13:36 +0200, Emmanuel Grumbach wrote:

> > It's not actually just "one packet for each vif/ac" - it's a whole tail
> > of whatever other RCU usages there are. Back when this was discussed,
> > the wizery people measured this to hundreds of ms in many not too
> > uncommon cases.
> 
> That's the part I didn't know. I wasn't aware that this
> synchronize_net() was there and that someone removed it.

This particular one might not have been there - I don't remember. There
were some in this path and we removed quite a few. However, if you have
keys, wpa_s is currently clearing them, which calls it for every single
key. I once had worked on an optimisation here (telling wpa_s not to
clear keys because we handle that when stations are deleted anyway) but
so far that didn't really go anywhere.

> I just wonder how we handle the case where we still have packets in
> the Tx path and we bring everything down. I can check the code, but
> not right now.

Well - I didn't expect you to check anything now :-)

I was more noting this down for 'future work'. It's possible, perhaps,
that we cannot do anything else here, but then we should think about the
other optimisations again...

johannes


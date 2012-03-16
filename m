Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14885 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab2CPSjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 14:39:36 -0400
From: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"Manoharan, Sujith" <c_manoha@qca.qualcomm.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: mac80211 20/40 coexist
Date: Fri, 16 Mar 2012 18:39:29 +0000
Message-ID: <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b> (sfid-20120316_193939_860344_525E3322)
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>,<1331902885.6753.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1331902885.6753.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi,
> 
> [I'll also fold in your other email]
> 
> > Not calling hw_config could affect drivers like ath9k_htc where the rate control runs in the firmware.
> > Those drivers will update the rate control based on CHANGED_HT flag.
> 
> Yeah that's actually an interesting point -- but we have it wrong right
> now I think. Did you see Paul's recent patch? We really shouldn't be
> reconfiguring the channel if all we want is to stop transmitting 40 MHz,
> we should just update rate control only. Now for in-device rate control
> that isn't really possible today since they can't get rate_update(), but
> that means we should add a separate callback, I think?

Yes. I missed that. I am not sure about the new callback alone is sufficient. We have to issue a WMI command
to reconfigure the rc in firmware. If so, it needs firmware changes also. May be Sujith is the right person to answer
about ath9k_htc.

> > > If we do that, is it still necessary to stop the queues for it? It seems
> > > like it shouldn't.
> > 
> > Actually the queue stop was added to avoid mismatches b/w hw and rate control. But If you dont stop the queues
> > before the rate control change, the station might send the frames in different ht mode (for example ht40) wrt AP's ht mode (ht20).
> 
> Yes, but that's probably OK. It's going to do that anyway since there
> are still frames in the hardware queues, and those will go out without
> updated rate information. There can be no guarantee (without having some
> form of hardware assist) that from the point we receive a 20/40
> notification we'll send the right bandwidth.

Yes. Sounds fine.

-Rajkumar
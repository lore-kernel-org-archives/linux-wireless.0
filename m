Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2CRKTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Mar 2012 06:19:48 -0400
Subject: RE: mac80211 20/40 coexist
From: Johannes Berg <johannes@sipsolutions.net>
To: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
Cc: "Manoharan, Sujith" <c_manoha@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	 ,<1331902885.6753.10.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Mar 2012 11:19:44 +0100
Message-ID: <1332065984.3609.5.camel@jlt3.sipsolutions.net> (sfid-20120318_111951_717544_1AB4295D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > Yeah that's actually an interesting point -- but we have it wrong right
> > now I think. Did you see Paul's recent patch? We really shouldn't be
> > reconfiguring the channel if all we want is to stop transmitting 40 MHz,
> > we should just update rate control only. Now for in-device rate control
> > that isn't really possible today since they can't get rate_update(), but
> > that means we should add a separate callback, I think?
> 
> Yes. I missed that. I am not sure about the new callback alone is
> sufficient. We have to issue a WMI command
> to reconfigure the rc in firmware. If so, it needs firmware changes
> also. May be Sujith is the right person to answer
> about ath9k_htc.

I'm not sure I can believe this -- surely the firmware has to have a way
of dealing with stations that can't do 40 MHz and stations that can, so
switching between the two doesn't seem like a major proposal? We also
don't currently handle the action frames for that, but it seems like we
should.

Note, however, that we're now discussing something already done --
Paul's patch already removed the channel type update when all we wanted
was update the RC.

johannes


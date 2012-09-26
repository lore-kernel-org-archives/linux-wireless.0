Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43852 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2IZHhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 03:37:15 -0400
Message-ID: <1348645070.10548.5.camel@jlt4.sipsolutions.net> (sfid-20120926_093750_455624_41246D02)
Subject: Re: [RFC] mac80211: Notify new IBSS network creation
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <c_manoha@qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 26 Sep 2012 09:37:50 +0200
In-Reply-To: <20578.44784.141822.850065@gargle.gargle.HOWL>
References: <20578.31128.207010.660580@gargle.gargle.HOWL>
	 <1348643666.10548.2.camel@jlt4.sipsolutions.net>
	 <20578.44784.141822.850065@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-26 at 12:59 +0530, Sujith Manoharan wrote:
> Johannes Berg wrote:
> > Interesting, I guess this makes sense. Never seemed to come up, maybe it
> > doesn't matter all that much since we sync once we receive some other
> > beacon, so worst case we just transmit a few spuriously?
> 
> Yes, that was the reported problem:
> http://www.spinics.net/lists/linux-wireless/msg96846.html

That looks a bit different from what I thought though? Not really sure I
understand that though :-)

What I'm thinking is that if you always just start beaconing, wouldn't
you just reset the beacon whenever you notice a higher TSF show up in
the network?

Actually I think we call reset_tsf() or something like that? But all of
that has always seemed very quirky to me.

johannes


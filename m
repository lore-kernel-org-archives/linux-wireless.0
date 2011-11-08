Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab1KHR4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 12:56:44 -0500
Subject: Re: [RFT/FYI] mac80211: revert on-channel work optimisations
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4EB9661F.9040901@candelatech.com>
References: <1320772222.24797.22.camel@jlt3.sipsolutions.net>
	 <4EB96416.5040700@candelatech.com>
	 <1320772727.24797.23.camel@jlt3.sipsolutions.net>
	 <4EB9661F.9040901@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 18:56:41 +0100
Message-ID: <1320775001.24797.26.camel@jlt3.sipsolutions.net> (sfid-20111108_185647_894624_9B868ED1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 09:25 -0800, Ben Greear wrote:

> That's fine by me, I found the code complex as well.  All the tmp
> and scan and active channel pointers makes for a real mess.  

Indeed.

> But if
> you want multiple vifs to work well, then you really need to be able
> to continue to function on-channel when some other vif is scanning
> on that channel.  My use of the wifi stack requires this to work,
> so if it takes any significant time to get the new code in I'm going
> to have to stick with my complex crap.

And I'm not saying you shouldn't, but I think for upstream right now
it's not really a good thing. I wish I could say otherwise but given the
bugs we have here etc. I don't really feel very confident.

Now with multi-channel stuff it's all going to change anyway, each vif
will have its own channel and the device will have to mostly sort out
the scheduling by itself, ath9k will have to do some tricks in the
driver, maybe with some help in mac80211, and off-channel stuff will be
interesting too ...

johannes


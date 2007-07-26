Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:60133 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934616AbXGZSDR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 14:03:17 -0400
Message-ID: <46A8E1D8.5040301@lwfinger.net>
Date: Thu, 26 Jul 2007 13:03:04 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx-mac80211: Fix specs typo for baseband attenuation
References: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net> <200707261931.41448.mb@bu3sch.de>
In-Reply-To: <200707261931.41448.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> Last time I checked this code it matched the specs. And that's not too
> long ago.
> Did the specs change?

We had a complaint that a change in the V3 specs broke a BCM4306/rev 2 card using bcm43xx - it 
received but did not transmit. I verified the breakage and found that reverting a patch fixed the 
problem. I contacted Joseph, who found that he had mixed the branches when doing the specs.

This morning, I found that bcm43xx-mac80211 has the same problem. I have not yet asked Joseph to 
recheck the specs; however, the patch I submitted allows my phy->rev == 1 card to work. Without it, 
it does not. I think there is an error in the specs in that place.

Larry



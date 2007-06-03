Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:34624 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbXFCTOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jun 2007 15:14:36 -0400
Message-ID: <46631315.6030608@lwfinger.net>
Date: Sun, 03 Jun 2007 14:14:29 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Olivier Cornu <o.cornu@gmail.com>, Jiri Benc <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Add module parameter for setting initial rate  in rc80211_simple
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net> <7b4bf7ff0706030333j21152541hed9384e965cacaa9@mail.gmail.com> <200706031245.31774.mb@bu3sch.de>
In-Reply-To: <200706031245.31774.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Sunday 03 June 2007 12:33:36 Olivier Cornu wrote:
>> 2007/6/2, Larry Finger <Larry.Finger@lwfinger.net>:
>>> The initial rate for STA's using rc80211_simple is set to the last
>>> rate in the rate table. This is too fast for the bcm43xx-mac80211
>>> driver. To correct this situation without affecting any other driver,
>>> an initial_rate parameter is added to the rc80211_simple module.
>> What if two different mac80211 device drivers need two different initial rates?
> 
> I'm not sure if that's useful at all. The algorithm will migrate
> away from the initial value very quickly anyway. What about simply
> using 1MBit for B-PHYs and (what's the lowest OFDM rate?) 9M? for
> G and A PHYs.

Although the algorithm will migrate away from the initial value very quickly, it doesn't happen 
quickly enough for the current version of bcm43xx-mac80211 to authenticate.

I tried setting the lowest OFDM rate (6M) and it didn't work either. There is a timeout in 
wpa_supplicant waiting for the WPA handshake. For my BCM4311 to make a connection, the rate must 
start at 1M.

Larry



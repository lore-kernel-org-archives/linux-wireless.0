Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab1I0LKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 07:10:09 -0400
Subject: Re: Questions on ieee80211_frame_duration()
From: Johannes Berg <johannes@sipsolutions.net>
To: Roland Vossen <rvossen@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4E81A098.9040708@broadcom.com>
References: <4E81A098.9040708@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 13:10:05 +0200
Message-ID: <1317121805.4082.10.camel@jlt3.sipsolutions.net> (sfid-20110927_131012_604522_F0806572)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> in response to one of your brcm80211 review comments, I am trying to 
> replace functions that calculate frame duration with Mac80211 counterparts.
> 
> As such, I have a hard time grasping this function:
> 
> http://lxr.free-electrons.com/source/net/mac80211/util.c#L108
> 
> A couple of questions:
> 
> a. The comment in the 'else' branch does not mention 802.11n, but I 
> think it should. Agree ?

Yeah, the function predates 11n support, and it seems that all devices
that actually implement 11n don't need to calculate the duration in
software, so this was never updated.

> b. The long/short preamble choice applies to CCK rates only. But this 
> function does not take that into account. Is that on purpose ?
> 
> c. In 802.11n there are 4 preamble types possible:
> - long (CCK rates)
> - short (CCK rates)
> - green field
> - mixed mode
> 
> The function does not seem to take the last two types into account. 
> Should it ?

I suppose it needs to. I'd be happy if you would fix it :-)

johannes


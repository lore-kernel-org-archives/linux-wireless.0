Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab0LPMEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 07:04:08 -0500
Subject: Re: [PATCH] mac80211: Push idle state to driver before stop
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: linux-wireless@vger.kernel.org, luis.rodriguez@atheros.com
In-Reply-To: <AANLkTimxoA+3GaZZWODKJ9MVJTJzRhnj5oh_jWGJhzWc@mail.gmail.com>
References: <20101215194246.D5FCE204D8@glenhelen.mtv.corp.google.com>
	 <1292482775.3542.8.camel@jlt3.sipsolutions.net>
	 <AANLkTi=pZAnyp5ztSqCo-MEF=_arECfAYg43JJ_j1Gb4@mail.gmail.com>
	 <1292499024.3612.3.camel@jlt3.sipsolutions.net>
	 <AANLkTimxoA+3GaZZWODKJ9MVJTJzRhnj5oh_jWGJhzWc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 13:04:07 +0100
Message-ID: <1292501047.3612.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-16 at 03:51 -0800, Paul Stewart wrote:

> So, I'm trying to balance two fairly nasty problems here.  On one end
> we have the problem before any changes where the device is not shut
> down when it legitimately should be -- we ifdown the device while scanning
> but the device in ath9k is not set to "idle".

See, I contend that statement -- we actually *turn off* the device with
stop(), so it shouldn't matter.

> Fixing the problem in ath9k
> alone causes a separate problem.  If you stop the driver from mac80211's
> pm.c, ath9k would set the device ps_idle, when mac80211 does not
> consider the device to to be idle.  Thus, when we resume from suspend,
> the device stays quiescent (mac80211 has no reason to believe it needs
> to do anything special to be able to tx, receive beacons, etc.)

How so? After resume, mac80211 will invoke start(), add interfaces and
stations back, and then invoke drv_config with all flags in "changed"
set. Therefore, at this point, the device should be reset. Where's this
not working?

I think the problem might be that ath9k is expecting mac80211 to
perfectly nest calls to idle/non-idle, even across suspend/resume and
device shutdown. I don't think that's feasible at all.

johannes


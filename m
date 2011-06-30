Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:40361 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751315Ab1F3FeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 01:34:24 -0400
Received: by mail-bw0-f41.google.com with SMTP id 14so2031996bwd.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 22:34:23 -0700 (PDT)
Subject: Re: [3.0-rc4] lockdep: netdev notifier vs rfkill
From: Luciano Coelho <coelho@ti.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <BANLkTimPMypvBWp-xv4WH_mD+WAOQQgRdA@mail.gmail.com>
References: <BANLkTimPMypvBWp-xv4WH_mD+WAOQQgRdA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 08:34:17 +0300
Message-ID: <1309412057.1514.123.camel@cumari> (sfid-20110630_073427_640474_5054F296)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-21 at 21:10 +0800, Daniel J Blueman wrote: 
> When hitting the hard rfkill in 3.0-rc4, lockdep spots some likely lock misuse:
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.0.0-rc4-340c #1
> -------------------------------------------------------
> kworker/0:0/4 is trying to acquire lock:
>  (&rdev->mtx){+.+.+.}, at: [<ffffffff816cefce>]
> cfg80211_netdev_notifier_call+0x11e/0x650
> 
> but task is already holding lock:
>  (&rdev->devlist_mtx){+.+.+.}, at: [<ffffffff816cff16>]
> cfg80211_rfkill_set_block+0x46/0xa0
> 
> which lock already depends on the new lock.

This should be fixed with the patch for 3.0 that I have just sent,
"cfg80211: fix deadlock with rfkill/sched_scan by adding new mutex".

-- 
Cheers,
Luca.


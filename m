Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:47570 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881Ab3BLKXs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 05:23:48 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [BUG] Beacon loss event every second
References: <5118F682.8000502@neratec.com>
	<1360592857.8738.30.camel@jlt4.sipsolutions.net>
	<51190341.40806@neratec.com> <87bobpc0ft.fsf@purkki.adurom.net>
	<511A15D4.6070808@neratec.com>
Date: Tue, 12 Feb 2013 12:23:47 +0200
In-Reply-To: <511A15D4.6070808@neratec.com> (Wojciech Dubowik's message of
	"Tue, 12 Feb 2013 11:13:40 +0100")
Message-ID: <877gmdbzkc.fsf@purkki.adurom.net> (sfid-20130212_112353_796399_C91057FD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik <Wojciech.Dubowik@neratec.com> writes:

> I have a test pc with 3x AR9590 and 2x AR9390. Machine is based on i7
> and hyperthreading is on so I have 8 cores.
> I am using latest wireless testing ath9k and 3.8rc7 kernel.
>
> What I see is that for some extended periods odf time beacons are not
> processed in ieee80211_rx_mgmt_beacon
> and that's why I get beacon loss. I am using 30ms beacon period.
>
>
> What is really funny, that I get this beacon loss message every
> second. Like is sth was locking ifmgd->mtx mutex
> at constant intervals.
>
>
> I will try to disable all cores and run in again to see if it's rcu problem.

You could also try wireless-next or wireless-testing to pinpoint if the
problem is in wireless code or not.

-- 
Kalle Valo

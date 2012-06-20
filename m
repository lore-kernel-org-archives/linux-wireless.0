Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44414 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035Ab2FTOT3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 10:19:29 -0400
Message-ID: <1340201968.4655.67.camel@jlt3.sipsolutions.net> (sfid-20120620_161932_944234_2E16D7E5)
Subject: Re: [PATCH v2 3/7] nl80211/cfg80211: add ability to enable TX on
 op-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Victor Goldenshtein <victorg@ti.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, adrian.chadd@gmail.com, j@w1.fi,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Wed, 20 Jun 2012 16:19:28 +0200
In-Reply-To: <4FE1D26D.8060702@neratec.com>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	    <1340111463-4554-3-git-send-email-victorg@ti.com>
	    <1340181856.4655.37.camel@jlt3.sipsolutions.net>
	    (sfid-20120620_104434_561430_DB0A480E) <1340181992.4655.39.camel@jlt3.sipsolutions.net>
	   <4FE1B9CB.2090206@neratec.com>
	  <1340193471.4655.57.camel@jlt3.sipsolutions.net>
	  <4FE1C8EC.4040902@neratec.com>
	 <1340197920.4655.62.camel@jlt3.sipsolutions.net>
	 <4FE1D26D.8060702@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-20 at 15:38 +0200, Zefir Kurtisi wrote:

> No, it serves its purpose to ensure hostapd is not going mad and tries
> to enable TX before the CAC is over via redundant checks.
> 
> What I'm saying is this: we defined that DFS regulatory compliance is
> provided by and distributed over driver, mac80211, and hostapd. We
> always must ensure that a working combination of those operates in
> compliance. But we have no control over it when a component is exchanged
> or modified.

Right, but if hostapd does something unexpected, in the code the kernel
attempts to verify that it did in fact do radar checking for a certain
minimum amount of time. I pointed out how those checks are ineffective,
and how they should be fixed.

> Back to topic: as stated above, radar_detection_timeout should be per
> wiphy. That would also resolve your concern, right?

No.

johannes


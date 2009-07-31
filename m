Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:8948 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbZGaTJq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 15:09:46 -0400
Subject: Re: [ath5k-devel] [PATCH 4/4] ath5k: Use SWI to trigger calibration
From: Pavel Roskin <proski@gnu.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linville@tuxdriver.com
In-Reply-To: <40f31dec0907311125o1654bd23jee861ba8bea57611@mail.gmail.com>
References: <20090731181020.GE7963@makis>
	 <43e72e890907311115h56df6ac0p1ea7165e305a10ee@mail.gmail.com>
	 <40f31dec0907311125o1654bd23jee861ba8bea57611@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 15:09:45 -0400
Message-Id: <1249067385.20276.16.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-31 at 21:25 +0300, Nick Kossifidis wrote:

> a) We don't need a timer for this, there is no need for accuracy
>     even with round_jiffies i think this is a waste of resources.
>     Also we don't need to run calibration if we are idle (no interrupts).

It doesn't sound right to me.

Can it be that the device gets so miscalibrated during the silence that
it won't be able to receive signal once it's there?  Say, the device is
set to channel 1 but it actually listens to channel 3, and there are
some weak beacons on channel 1.

And then there is an issue of the frequency straying outside the
permitted spectrum.  Perhaps the transmission will trigger interrupts
and thus recalibration, but in case of scanning, the first probe
requests could be on wrong frequencies.

I would probably leave the timer and allow the interrupts make the
delays shorter.

-- 
Regards,
Pavel Roskin

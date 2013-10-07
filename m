Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56191 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab3JGI3b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 04:29:31 -0400
Message-ID: <1381134567.13586.3.camel@jlt4.sipsolutions.net> (sfid-20131007_102934_686779_457D9E72)
Subject: Re: [PATCH 2/2] mac80211: implement support for configuring antenna
 gain
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 07 Oct 2013 10:29:27 +0200
In-Reply-To: <524FF599.5040706@openwrt.org>
References: <1378472763-36062-1-git-send-email-nbd@openwrt.org>
	   <1378472763-36062-2-git-send-email-nbd@openwrt.org>
	  <1380625512.14430.19.camel@jlt4.sipsolutions.net>
	  <524AAE97.5020708@openwrt.org>
	 <1380628244.14430.37.camel@jlt4.sipsolutions.net>
	 <524FF599.5040706@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-10-05 at 13:18 +0200, Felix Fietkau wrote:

> > I understand. I don't understand the pieces about "max_antenna_gain".

> Right now ath9k has an antenna gain value in the EEPROM, and it compares
> it against the channel max_antenna_gain value.

I just don't understand what the max means. If I connect a 5dBi gain
antenna, but the "max antenna gain" is 3dBi, what should happen?

> Let's assume we have configured the tx power to the maximum value, the
> regdb allows 3 dB antenna gain, and the ath9k EEPROM contains an antenna
> gain of 3 dB as well.
> If we now add another 3 dB of user-configured antenna gain, it first
> starts tapping into the regulatory-allowed antenna gain before reducing
> tx power in mac80211. The driver needs to know about this, so I put the
> calculated maximum antenna gain into the hw conf as well.

I don't think it really works this way, does it? I don't believe the
"regulatory-allowed antenna gain" is really something that's allowed on
top of the EIRP?

johannes


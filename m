Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:27061 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551AbZBSJUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 04:20:00 -0500
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx09.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id n1J9JRhw025273
	for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2009 03:19:56 -0600
To: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "Coelho Luciano \(Nokia-D\/Helsinki\)" <Luciano.Coelho@nokia.com>
Subject: Re: wl12xx: driver for TI wl1251 chipset
References: <87iqnishuj.fsf@nokia.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 19 Feb 2009 11:19:50 +0200
In-Reply-To: <87iqnishuj.fsf@nokia.com> (Valo Kalle's message of "Tue\, 10 Feb 2009 11\:32\:04 +0100")
Message-ID: <87tz6qokax.fsf@nokia.com> (sfid-20090219_102010_966736_31DD4922)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Valo Kalle (Nokia-D/Tampere)" <Kalle.Valo@nokia.com> writes:

> Hello all,
>
> in Nokia we have been working on a mac80211 driver for TI wl1251
> chipset. We named it as wl12xx, and in the future we are planning to
> add wl1271 support to the driver as well.

[...]

> http://www.valot.fi/kalle/tmp/wl12xx/wl12xx-2.6.28-1.patch

[...]

> Currently known issues:
>
> o short slot and preamble support missing
> o rts/cts and cts-to-self missing
> o no proper bitrate control support
> o using deprecated omap_get_config(), need to convert to use platform_data
> o firmware wakeup not working, deepest sleep state in firmware not yet
>   enabled

I received few comments, I'll list them here so that I don't forget
them:

o netlink interface might create problems, I'll remove netlink. cfor
  now but will revisit it later
o wl12xx_80211.h is, well, ugly
o fragmentation in the hardware might not be worth the trouble
o "*fc &= ~IEEE80211_FCTL_PROTECTED;" shouldn't be necessary, just set
  the status properly
o get_tsf() doesn't need to be atomic anymore, ad-hoc tsf hack can be
  removed

If anyone has more comments, please send them soon. I'm planning to
prepare a patch for adding wl12xx to wireless-testing next week. Let's
see if John takes it :)

-- 
Kalle Valo

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:49462 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab0L1IeO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 03:34:14 -0500
Subject: Re: [PATCH v2 06/18] wl1271: AP mode - init sequence
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTikrgQwxBKSc_s-DHU+ktU+HwHb1hBukL+0rgpYK@mail.gmail.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
	 <1293028057-6212-7-git-send-email-arik@wizery.com>
	 <1293454640.19215.3042.camel@powerslave>
	 <AANLkTikrgQwxBKSc_s-DHU+ktU+HwHb1hBukL+0rgpYK@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 10:34:09 +0200
Message-ID: <1293525249.19215.3074.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-28 at 08:16 +0200, ext Arik Nemtsov wrote:
> >> diff --git a/drivers/net/wireless/wl12xx/init.h
> b/drivers/net/wireless/wl12xx/init.h
> >> index 7762421..4d37210 100644
> >> --- a/drivers/net/wireless/wl12xx/init.h
> >> +++ b/drivers/net/wireless/wl12xx/init.h
> >> @@ -27,10 +27,13 @@
> >>  #include "wl12xx.h"
> >>
> >>  int wl1271_hw_init_power_auth(struct wl1271 *wl);
> >> -int wl1271_init_templates_config(struct wl1271 *wl);
> >> +int wl1271_sta_init_templates_config(struct wl1271 *wl);
> >>  int wl1271_init_phy_config(struct wl1271 *wl);
> >>  int wl1271_init_pta(struct wl1271 *wl);
> >>  int wl1271_init_energy_detection(struct wl1271 *wl);
> >>  int wl1271_hw_init(struct wl1271 *wl);
> >>
> >> +/* Functions from wl1271_main.c */
> >> +u32 wl1271_min_rate_get(struct wl1271 *wl);
> >> +
> >
> > This is bad and shouldn't be here.  Need to find a better place for
> it.
> 
> How about tx.h? It's TX rate we're talking about here after all.
> I can also change the name to wl1271_tx_min_rate_get(). 

Sounds good.

-- 
Cheers,
Luca.


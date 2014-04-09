Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:50970 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932560AbaDIMmG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 08:42:06 -0400
Message-ID: <1397047312.4418.68.camel@dubbel> (sfid-20140409_144220_519227_A8AE537B)
From: Luca Coelho <luca@coelho.fi>
To: Arik Nemtsov <arik@wizery.com>
Cc: Yegor Yefremov <yegorslists@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	kaloz@openwrt.org
Date: Wed, 09 Apr 2014 15:41:52 +0300
In-Reply-To: <CA+XVXfcig5u1cQ8thxwO4B5_u=69x7FpdmORxMR4dFvpig_CZQ@mail.gmail.com>
References: <CAGm1_ktNAyqWhkTPycA-yKz9iXgqGvx3unjB7JHQpmiKFnFXuA@mail.gmail.com>
	 <1396988949.4418.46.camel@dubbel>
	 <CAGm1_ksFRCUNi1DPfmv=+8bBqiWxLSm6EeSYjhfVwR7oiAWBkw@mail.gmail.com>
	 <1397035298.4418.60.camel@dubbel>
	 <CAGm1_ktMWV0m1-gUTe8bQT1=f9HseBKCJn22bvPAgxynpeaQLg@mail.gmail.com>
	 <1397044175.4418.66.camel@dubbel>
	 <CA+XVXfcig5u1cQ8thxwO4B5_u=69x7FpdmORxMR4dFvpig_CZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: wl1271: tx stuck in firmware
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-09 at 15:20 +0300, Arik Nemtsov wrote:
> >>
> >> # calibrator wlan0 plt power_mode on
> >> [   93.107215] wlcore: power up
> >> [   93.688714] wlcore: firmware booted in PLT mode PLT_ON (PLT 6.3.10.0.133)
> >> # [  139.232802] YY: wl1271_tx_allocate
> >> [  144.241849] wlcore: ERROR Tx stuck (in FW) for 5000 ms. Starting recovery
> >
> > Okay, you have a starting point. :)
> >
> > Now try to look from where this is being called and so on.  I don't
> > think we should be calling wl1271_tx_allocate() in PLT mode either.  Try
> > tracing back until you find where this is coming from.
> 
> Actually we've seen this bug before. At the time it was caused by FW
> requests for dummy packets during PLT mode, which forced us to issue
> Tx..

Ah, interesting, I hadn't heard about it.  Would it send it even if the
event was masked out? Masking it out (if it's not already) for PLT would
probably be the right thing to do.


> It was fixed in the FW, but I'm not sure this was ever upstreamed
> (customer specific fix, etc). Anyway it's pretty safe to disable the
> Tx watchdog during PLT - try something like this:
> 
> void wl12xx_rearm_tx_watchdog_locked(struct wl1271 *wl)
> {
>      if (wl->plt)
>          return;

Maybe this could be blocked even earlier, like here:

diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 1f9a360..c44d3c0 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -158,6 +158,9 @@ EXPORT_SYMBOL_GPL(wlcore_event_channel_switch);
 
 void wlcore_event_dummy_packet(struct wl1271 *wl)
 {
+       if (wl->plt)
+               return;
+
        wl1271_debug(DEBUG_EVENT, "DUMMY_PACKET_ID_EVENT_ID");
        wl1271_tx_dummy_packet(wl);
 }

--
Luca.


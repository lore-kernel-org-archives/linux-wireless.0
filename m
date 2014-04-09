Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33294 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592AbaDIMUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 08:20:32 -0400
Received: by mail-pb0-f53.google.com with SMTP id rp16so2423186pbb.40
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 05:20:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397044175.4418.66.camel@dubbel>
References: <CAGm1_ktNAyqWhkTPycA-yKz9iXgqGvx3unjB7JHQpmiKFnFXuA@mail.gmail.com>
 <1396988949.4418.46.camel@dubbel> <CAGm1_ksFRCUNi1DPfmv=+8bBqiWxLSm6EeSYjhfVwR7oiAWBkw@mail.gmail.com>
 <1397035298.4418.60.camel@dubbel> <CAGm1_ktMWV0m1-gUTe8bQT1=f9HseBKCJn22bvPAgxynpeaQLg@mail.gmail.com>
 <1397044175.4418.66.camel@dubbel>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 9 Apr 2014 15:20:16 +0300
Message-ID: <CA+XVXfcig5u1cQ8thxwO4B5_u=69x7FpdmORxMR4dFvpig_CZQ@mail.gmail.com> (sfid-20140409_142037_191056_95546CF1)
Subject: Re: wl1271: tx stuck in firmware
To: Luca Coelho <luca@coelho.fi>
Cc: Yegor Yefremov <yegorslists@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	kaloz@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>> # calibrator wlan0 plt power_mode on
>> [   93.107215] wlcore: power up
>> [   93.688714] wlcore: firmware booted in PLT mode PLT_ON (PLT 6.3.10.0.133)
>> # [  139.232802] YY: wl1271_tx_allocate
>> [  144.241849] wlcore: ERROR Tx stuck (in FW) for 5000 ms. Starting recovery
>
> Okay, you have a starting point. :)
>
> Now try to look from where this is being called and so on.  I don't
> think we should be calling wl1271_tx_allocate() in PLT mode either.  Try
> tracing back until you find where this is coming from.

Actually we've seen this bug before. At the time it was caused by FW
requests for dummy packets during PLT mode, which forced us to issue
Tx..

It was fixed in the FW, but I'm not sure this was ever upstreamed
(customer specific fix, etc). Anyway it's pretty safe to disable the
Tx watchdog during PLT - try something like this:

void wl12xx_rearm_tx_watchdog_locked(struct wl1271 *wl)
{
     if (wl->plt)
         return;

Arik

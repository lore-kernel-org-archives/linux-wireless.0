Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58298 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781AbaDINHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 09:07:49 -0400
Received: by mail-pb0-f43.google.com with SMTP id um1so2500738pbc.2
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 06:07:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397047312.4418.68.camel@dubbel>
References: <CAGm1_ktNAyqWhkTPycA-yKz9iXgqGvx3unjB7JHQpmiKFnFXuA@mail.gmail.com>
 <1396988949.4418.46.camel@dubbel> <CAGm1_ksFRCUNi1DPfmv=+8bBqiWxLSm6EeSYjhfVwR7oiAWBkw@mail.gmail.com>
 <1397035298.4418.60.camel@dubbel> <CAGm1_ktMWV0m1-gUTe8bQT1=f9HseBKCJn22bvPAgxynpeaQLg@mail.gmail.com>
 <1397044175.4418.66.camel@dubbel> <CA+XVXfcig5u1cQ8thxwO4B5_u=69x7FpdmORxMR4dFvpig_CZQ@mail.gmail.com>
 <1397047312.4418.68.camel@dubbel>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 9 Apr 2014 16:07:34 +0300
Message-ID: <CA+XVXfcB7Uu9F2OHffOUy8mfUofMc38LS0GnShx7t0NADNckpg@mail.gmail.com> (sfid-20140409_150755_194142_4A0779E9)
Subject: Re: wl1271: tx stuck in firmware
To: Luca Coelho <luca@coelho.fi>
Cc: Yegor Yefremov <yegorslists@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	kaloz@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 9, 2014 at 3:41 PM, Luca Coelho <luca@coelho.fi> wrote:
>> Actually we've seen this bug before. At the time it was caused by FW
>> requests for dummy packets during PLT mode, which forced us to issue
>> Tx..
>
> Ah, interesting, I hadn't heard about it.  Would it send it even if the
> event was masked out? Masking it out (if it's not already) for PLT would
> probably be the right thing to do.
>
>
>> It was fixed in the FW, but I'm not sure this was ever upstreamed
>> (customer specific fix, etc). Anyway it's pretty safe to disable the
>> Tx watchdog during PLT - try something like this:
>>
>> void wl12xx_rearm_tx_watchdog_locked(struct wl1271 *wl)
>> {
>>      if (wl->plt)
>>          return;
>
> Maybe this could be blocked even earlier, like here:
>
> diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
> index 1f9a360..c44d3c0 100644
> --- a/drivers/net/wireless/ti/wlcore/event.c
> +++ b/drivers/net/wireless/ti/wlcore/event.c
> @@ -158,6 +158,9 @@ EXPORT_SYMBOL_GPL(wlcore_event_channel_switch);
>
>  void wlcore_event_dummy_packet(struct wl1271 *wl)
>  {
> +       if (wl->plt)
> +               return;
> +
>         wl1271_debug(DEBUG_EVENT, "DUMMY_PACKET_ID_EVENT_ID");
>         wl1271_tx_dummy_packet(wl);
>  }
>
> --
> Luca.
>

These are good suggestions as well.

Arik

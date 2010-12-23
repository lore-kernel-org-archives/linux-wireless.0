Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39967 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab0LWGsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 01:48:24 -0500
Received: by gyb11 with SMTP id 11so2410685gyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 22:48:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293050660.14423.20.camel@powerslave>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
 <1293028057-6212-3-git-send-email-arik@wizery.com> <1293050660.14423.20.camel@powerslave>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 23 Dec 2010 08:48:08 +0200
Message-ID: <AANLkTim_o2STO7t0vKMYPbS1c-3wgM1jhChL1O6eMu80@mail.gmail.com>
Subject: Re: [PATCH v2 02/18] wl1271: AP mode - AP specific CMD_CONFIGURE sub-commands
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 22:44, Luciano Coelho <luciano.coelho@nokia.com> wrote:
>
> On Wed, 2010-12-22 at 16:27 +0200, ext Arik Nemtsov wrote:
> > Add AP max retries and rate policy configuration.
> > Rename STA rate policy configuration function.
> >
> > Signed-off-by: Arik Nemtsov <arik@wizery.com>
> > ---
>
> [...]
>
> > diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
> > index 9cbc3f4..d2a68bf 100644
> > --- a/drivers/net/wireless/wl12xx/acx.h
> > +++ b/drivers/net/wireless/wl12xx/acx.h
>
> [...]
>
> > +     __le32 rate_policy_idx; /* The index of the rate policy */
>
> This comment is quite useless. ;)

Removed :)

>
> > @@ -1062,6 +1072,19 @@ struct wl1271_acx_fw_tsf_information {
> >       u8 padding[3];
> >  } __packed;
> >
> > +#define WL1271_AP_MAX_TX_RETRY   100
>
> Should this be part of the conf.h settings? Should it be made more
> easily configurable?

Actually this configures the FW for sending up an event once the
number of TX retries was exceeded. For now this event is masked out
and we just set to to a sane minimum (to prevent the FW from working
too hard sending these events).
Recently Johannes sent patches that allow this to be hooked up to
hostapd and actually disassociate the station -
http://www.spinics.net/lists/linux-wireless/msg59831.html

When this is implemented we should perhaps make this easily
configurable. For now conf.h sounds like a good place.

Regards,
Arik

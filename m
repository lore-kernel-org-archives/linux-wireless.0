Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:28542 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbXKZRLz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 12:11:55 -0500
Received: by wa-out-1112.google.com with SMTP id v27so830945wah
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 09:11:51 -0800 (PST)
Message-ID: <1ba2fa240711260911i705350f3hefeddc7a09f76d1a@mail.gmail.com> (sfid-20071126_171203_879568_DB8DC027)
Date: Mon, 26 Nov 2007 19:11:51 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "=?ISO-8859-1?Q?Miguel_Bot=F3n?=" <mboton.lkml@gmail.com>
Subject: Re: [PATCH 2/2] iwlwifi: add power management support -v2
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	yi.zhu@intel.com
In-Reply-To: <200711261718.14711.mboton@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200711170006.49654.mboton.lkml@gmail.com>
	 <1ba2fa240711162215p30b8bc7fj9f36020378ff596a@mail.gmail.com>
	 <200711261718.14711.mboton@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 26, 2007 6:18 PM, Miguel Bot=F3n <mboton.lkml@gmail.com> wrote:
>
> On Saturday 17 November 2007 07:15:05 Tomas Winkler wrote:
> > Why power management shouldn't be enabled while in AC? The semantic=
 of this
> > ioctls is quite unclear.
>
I
> IWL_POWER_AC and IWL_POWER_BATTERY are just two power modes. IWL_POWE=
R_AC
> would be the default power mode when we're in AC (no power saving) an=
d
> IWL_POWER_BATTERY would be the default power mode when we're in batte=
ry
> (power saving mode). That's why we set IWL_POWER_ENABLED flag with
> IWL_POWER_BATTERY, because it is the only power mode that saves power=
=2E
>
> We can change to IWL_POWER_BATTERY or IWL_POWER_AC in any moment.
>
> This patch, depending if power management is enabled or not, sets whi=
ch power
> mode we should use, Then, it checks if we're already using this mode =
or not.
>
I'm not sure who introduced this names (lazy to look to history) but
that's very misleading. Nothing says that while in
AC we cannot do power saving and vice versa. This naming is scattered
all over the code, there should be only one place where AC and BATTERY
are  translated into appropriate (maybe configurable) power levels. We
have 5 power levels defined for iwlwifi.

Tomas

> --
>        Miguel Bot=F3n
>
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

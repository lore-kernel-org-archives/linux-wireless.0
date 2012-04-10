Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63105 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab2DJM0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 08:26:33 -0400
MIME-Version: 1.0
In-Reply-To: <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <1334059909-20513-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 10 Apr 2012 22:26:11 +1000
Message-ID: <CAGRGNgX+R0CrtF2tBJ1AASBqkhHjmEfcqVnJiTd_1mXFL2rVUw@mail.gmail.com> (sfid-20120410_142638_424218_863FF2AF)
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrei,

A couple of minor nits:

On Tue, Apr 10, 2012 at 22:11, Andrei Emeltchenko
<Andrei.Emeltchenko.news@gmail.com> wrote:
> From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
>
> Add new interface type VIRTUAL_AMP80211 which emulates Bluetooth AMP
> Controller. AMP is Alternate MAC/PHYs Controller for Bluetooth sybsystem.
> When an AMP is common between the two devices, the Bluetooth system
> provides mechanisms for moving data traffic from BR/EDR Controller to
> an AMP Controller.
>
> Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
> ---
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 401c01f..0718cc4 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -898,6 +900,11 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
>        case NL80211_IFTYPE_WDS:
>        case NL80211_IFTYPE_AP_VLAN:
>                break;
> +       case NL80211_IFTYPE_VIRTUAL_AMP80211:
> +#ifdef CONFIG_MAC80211_VIRTUAL_AMP
> +               ieee80211_vamp_setup_sdata(sdata);
> +               break;
> +#endif
>        case NL80211_IFTYPE_UNSPECIFIED:
>        case NUM_NL80211_IFTYPES:
>                BUG();

Should this really BUG() if VAMP is not enabled? Maybe print a warning
and return an error instead.

> diff --git a/net/mac80211/virtual_amp.h b/net/mac80211/virtual_amp.h
> new file mode 100644
> index 0000000..5b7d219
> --- /dev/null
> +++ b/net/mac80211/virtual_amp.h
> @@ -0,0 +1,29 @@
> +/*
> + * Virtual / Software AMP 80211 BT Controller header
> + *
> + * Copyright 2012 Intel Corp.
> + *
> + * Written by andrei.emeltchenko@intel.com
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include "ieee80211_i.h"
> +
> +#ifdef CONFIG_MAC80211_VIRTUAL_AMP
> +
> +void ieee80211_vamp_setup_sdata(struct ieee80211_sub_if_data *sdata);
> +void ieee80211_vamp_clean_sdata(struct ieee80211_sub_if_data *sdata);
> +
> +struct vamp_data {
> +       struct hci_dev *hdev;
> +
> +       unsigned long flags;
> +
> +       struct work_struct work;
> +       struct sk_buff_head txq;
> +};
> +
> +#endif /* CONFIG_MAC80211_VIRTUAL_AMP */

A cleaner way of doing this is to have the function prototypes
specified as empty inline functions when CONFIG_MAC80211_VIRTUAL_AMP
is not defined and remove the #ifdefs in the main code. GCC's smart
enough to compile away all the empty functions.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/

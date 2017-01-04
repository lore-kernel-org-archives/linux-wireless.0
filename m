Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34804 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030400AbdADN0x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 08:26:53 -0500
Message-ID: <1483536406.7312.3.camel@sipsolutions.net> (sfid-20170104_142713_017059_47EC8406)
Subject: Re: [PATCH V5 3/3] cfg80211: support ieee80211-freq-limit DT
 property
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Wed, 04 Jan 2017 14:26:46 +0100
In-Reply-To: <20170103225715.14072-3-zajec5@gmail.com> (sfid-20170103_235738_606634_945A6D98)
References: <20170103225715.14072-1-zajec5@gmail.com>
         <20170103225715.14072-3-zajec5@gmail.com>
         (sfid-20170103_235738_606634_945A6D98)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> V4: Move code to of.c
>     Use one helper called at init time (no runtime hooks)
>     Modify orig_flags


> +/**
> + * wiphy_read_of_freq_limits - read frequency limits from device
> tree
> + *
> + * @wiphy: the wireless device to get extra limits for
> + *
> + * Some devices may have extra limitations specified in DT. This may
> be useful
> + * for chipsets that normally support more bands but are limited due
> to board
> + * design (e.g. by antennas or extermal power amplifier).
> + *
> + * This function reads info from DT and uses it to *modify* channels
> (disable
> + * unavailable ones). It's usually a *bad* idea to use it in drivers
> with
> + * shared channel data as DT limitations are device specific.
> + *
> + * As this function access device node it has to be called after
> set_wiphy_dev.
> + * It also modifies channels so they have to be set first.
> + */

It should also be called before wiphy_register(), I think? And I
suppose you should add a comment about not being able to use shared
channels.

> +				pr_debug("Disabling freq %d MHz as
> it's out of OF limits\n",
> +					 chan->center_freq);
> +				chan->orig_flags |=
> IEEE80211_CHAN_DISABLED;
> 
But just setting orig_flags also won't work, since it'd be overwritten
again by wiphy_register(), no?

johannes

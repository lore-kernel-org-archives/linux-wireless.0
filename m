Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43794 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933016AbdABRwd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 12:52:33 -0500
Message-ID: <1483379548.15591.1.camel@sipsolutions.net> (sfid-20170102_185446_861559_8673664E)
Subject: Re: [PATCH V3 2/2] cfg80211: support ieee80211-freq-limit DT
 property
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Mon, 02 Jan 2017 18:52:28 +0100
In-Reply-To: <20170102163209.2445-2-zajec5@gmail.com> (sfid-20170102_173227_440720_CC4EC280)
References: <20170102163209.2445-1-zajec5@gmail.com>
         <20170102163209.2445-2-zajec5@gmail.com>
         (sfid-20170102_173227_440720_CC4EC280)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +static void wiphy_freq_limits_apply(struct wiphy *wiphy)
[...]
> +			if (!wiphy_freq_limits_valid_chan(wiphy,
> chan)) {
> +				pr_debug("Disabling freq %d MHz as
> it's out of OF limits\n",
> +					 chan->center_freq);
> +				chan->flags |=
> IEEE80211_CHAN_DISABLED;

I think you didn't address the problem in the best way now.

The problem with the channel sharing was the way you're applying the
limits - at runtime. This is now OK since the new function shouldn't be
called when the channel structs are shared, but hooking it all into the
regulatory code is now no longer needed.

What you can do now, when reading the OF data, is actually apply it to
the channel flags immediately. If done *before* wiphy_register(), these
flags will be preserved forever, so you no longer need any hooks in
regulatory code at all - you can just set the original channel flags
according to the OF data.

I think this greatly simplifies the flow, since you can also remove
wiphy->freq_limits (and n_freq_limits) completely, since now the only
effect of the function would be to modify the channel list, and later
regulatory updates would always preserve the flags.

johannes

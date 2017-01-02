Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37536 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751279AbdABLeR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 06:34:17 -0500
Message-ID: <1483356854.4596.14.camel@sipsolutions.net> (sfid-20170102_123420_172460_2B63D726)
Subject: Re: [PATCH] cfg80211: Random local address for Public Action frame
 exchange
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        vamsi krishna <vamsin@qti.qualcomm.com>
Date: Mon, 02 Jan 2017 12:34:14 +0100
In-Reply-To: <1482266379-9723-1-git-send-email-jouni@qca.qualcomm.com>
References: <1482266379-9723-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> + * @random_sa: indicates whether the source address is randomized.
> When this is
> + *	true, the driver needs to transmit the management frame
> using the
> + *	address specified in the SA field (Address 2) in the
> buffer and the
> + *	driver needs to receive and acknowledge the response frame
> to this
> + *	address instead of its permanent MAC address.
>   */
>  struct cfg80211_mgmt_tx_params {
>  	struct ieee80211_channel *chan;
> 

Is this really of much value to the driver - rather than comparing the
addresses?

> + * @NL80211_ATTR_MGMT_TX_RANDOM_SA: A flag attribute indicating
> whether the
> + *	source address is randomized in frames sent using
> %NL80211_CMD_FRAME.
> + *	If this flag is not set, the source address field is
> verified to match
> + *	local MAC address. Random SA can be used only with Public
> Action frames
> + *	(e.g., GAS/ANQP).

Likewise here, is this really of much value?

Or is the intent to make sure that userspace *really* intended things
to be randomized, and didn't just have a bug?

What I mean is more like this: if the driver supports "random SA", that
basically means it supports "arbitrary SA". The driver could thus
(unconditionally even, or after comparing to the iface address)
configure the RX filters appropriately.

Therefore, the only thing that would really be needed is the nl80211
extended feature flag to bypass the address check in
cfg80211_mlme_mgmt_tx().

What extra value do we get from having the "yes I really did intend it
to be random" attribute?

johannes

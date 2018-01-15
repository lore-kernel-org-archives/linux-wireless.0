Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37254 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030453AbeAONOk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 08:14:40 -0500
Message-ID: <1516022078.410.33.camel@sipsolutions.net> (sfid-20180115_141509_745270_4437E622)
Subject: Re: [RFC v2 4/5] nl80211: Implement TX of control port frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org,
        Jouni Malinen <j@w1.fi>
Date: Mon, 15 Jan 2018 14:14:38 +0100
In-Reply-To: <20180110170938.2341-5-denkenz@gmail.com> (sfid-20180110_180958_033009_D67159EE)
References: <20180110170938.2341-1-denkenz@gmail.com>
         <20180110170938.2341-5-denkenz@gmail.com>
         (sfid-20180110_180958_033009_D67159EE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok this is the interesting part :-)

> +	int	(*tx_control_port)(struct wiphy *wiphy,
> +				       struct net_device *dev,
> +				       const u8 *buf, size_t len,
> +				       const u8 *dest, const u16 proto,
> +				       const bool noencrypt);

(indentation seems off in both patchwork and my email, but whatever)

> +	wdev_lock(wdev);
> +
> +	switch (wdev->iftype) {
> +	case NL80211_IFTYPE_STATION:
> +		if (wdev->current_bss)

err, !current_bss?

> +	buf = nla_data(info->attrs[NL80211_ATTR_FRAME]);
> +	len = nla_len(info->attrs[NL80211_ATTR_FRAME]);
> +	dest = nla_data(info->attrs[NL80211_ATTR_MAC]);
> +	proto = nla_get_u16(info->attrs[NL80211_ATTR_CONTROL_PORT_ETHERTYPE]);
> +	noencrypt =
> +		nla_get_flag(info->attrs[NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT]);

So this is the data we support here.

Jouni and I were talking about this and were thinking we might need
"use old key" or something like that. That's rather difficult to do
though, I'm not even sure we keep the old key around?

Jouni? Do you see how this could work?


The other thing we thought about was that maybe we should have "open
port after this frame", but since it's an in-band mechanism now you
could do that also just before the frame.

FWIW, I'm checking with our guy on what other specialities we might
want to add into this mix as far as workarounds are concerned.

johannes

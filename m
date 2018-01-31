Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:58016 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753183AbeAaVp3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 16:45:29 -0500
Message-ID: <1517435126.2189.62.camel@sipsolutions.net> (sfid-20180131_224533_030399_B2422F10)
Subject: Re: [PATCH 3/6] nl80211: Add CMD_CONTROL_PORT_FRAME API
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org,
        Jouni Malinen <j@w1.fi>
Date: Wed, 31 Jan 2018 22:45:26 +0100
In-Reply-To: <20180131213329.25322-4-denkenz@gmail.com> (sfid-20180131_223353_648398_FEE9882F)
References: <20180131213329.25322-1-denkenz@gmail.com>
         <20180131213329.25322-4-denkenz@gmail.com>
         (sfid-20180131_223353_648398_FEE9882F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-31 at 15:33 -0600, Denis Kenzior wrote:
> 
>  /**
> + * cfg80211_rx_control_port - inform userspace about a received control port
> + * frame, e.g. EAPoL.  This is used if userspace has specified it wants to
> + * receive control port frames over NL80211.

nitpick - the short description must fit on a single line, you can have
a longer description separately (after the arguments, I'd probably even
put it after the return)

> + * @dev: The device the frame matched to
> + * @buf: control port frame
> + * @len: length of the frame data

You should document what exactly is in this frame data?

Should it be with the ethernet header removed? It would seem easier if
it's with the ethernet header included, but then why do you need the
proto argument?

> + * @NL80211_CMD_CONTROL_PORT_FRAME: Control Port (e.g. PAE) frame TX request
> + *	and RX notification.  This command is used both as a request to transmit
> + *	a control port frame and as a notification that a control port frame
> + *	has been received. %NL80211_ATTR_FRAME is used to specify the
> + *	frame contents.  The frame is the raw EAPoL data, without ethernet or
> + *	802.11 headers.

Never mind, so it's without Ethernet header. Is that really desirable
though? I mean, it could be that the Ethernet address even matters (not
sure) and it'd probably be easier to handle in (existing) userspace
where Ethernet frames are expected now?

> + nla_put_failure:
> +	genlmsg_cancel(msg, hdr);

nit: there's no point in cancelling if you free it (immediately).

> +bool cfg80211_rx_control_port(struct net_device *dev,
> +			      const u8 *buf, size_t len,
> +			      const u8 *addr, u16 proto, bool unencrypted)
> +{
> +	bool ret;
> +
> +	trace_cfg80211_rx_control_port(dev, buf, len, addr, proto, unencrypted);
> +	ret = __nl80211_rx_control_port(dev, buf, len, addr, proto,
> +					unencrypted, GFP_ATOMIC);
> +	trace_cfg80211_return_bool(ret);

this seems wrong - you return -ERROR from __nl80211_rx_control_port()
so you need either to pass that on as an integer to the caller, or put
an == 0 here or something?

"Return: %true if the frame was passed to userspace"

johannes

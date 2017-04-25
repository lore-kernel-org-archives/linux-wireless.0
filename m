Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34162 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1948048AbdDYOkO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 10:40:14 -0400
Message-ID: <1493131210.2609.2.camel@sipsolutions.net> (sfid-20170425_164025_916817_27465441)
Subject: Re: [RFC] cfg80211: add control port state to struct
 cfg80211_connect_resp_params
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 25 Apr 2017 16:40:10 +0200
In-Reply-To: <1492808507-31224-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1492808507-31224-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-04-21 at 22:01 +0100, Arend van Spriel wrote:

> I have been working on 4-way handshake offloading and one of the
> things discussed was the addition of PORT_AUTHORIZED flag. So
> this is what I came up with, but I suppose wpa_supplicant wants
> to know whether it can expect this attribute or not. One option
> is to have PORT_UNAUTHORIZED flag instead. Another option would
> be introducing it as nl80211 protocol feature although not sure
> if it could be considered as such. What do you guys think?

I think it could be, but I'm not really sure it matters?

> +	    (cr->port_state != CONTROL_PORT_STATE_UNAUTHORIZED &&
> +	     nla_put_flag(msg, NL80211_ATTR_PORT_AUTHORIZED)) ||
>  	    (cr->req_ie &&
> 
This doesn't really make sense - why does unspecified equal authorized?

johannes

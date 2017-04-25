Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36536 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1953498AbdDYShM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 14:37:12 -0400
Message-ID: <1493145418.2609.5.camel@sipsolutions.net> (sfid-20170425_203845_501712_7DB506B4)
Subject: Re: [RFC] cfg80211: add control port state to struct
 cfg80211_connect_resp_params
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 25 Apr 2017 20:36:58 +0200
In-Reply-To: <b4dc7a6d-7865-1fb5-849a-0ead03a080c3@broadcom.com> (sfid-20170425_203436_553220_83783E98)
References: <1492808507-31224-1-git-send-email-arend.vanspriel@broadcom.com>
         <1493131210.2609.2.camel@sipsolutions.net>
         <b4dc7a6d-7865-1fb5-849a-0ead03a080c3@broadcom.com>
         (sfid-20170425_203436_553220_83783E98)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-04-25 at 20:34 +0200, Arend Van Spriel wrote:

> > > +	    (cr->port_state != CONTROL_PORT_STATE_UNAUTHORIZED
> > > &&
> > > +	     nla_put_flag(msg, NL80211_ATTR_PORT_AUTHORIZED)) ||
> > >  	    (cr->req_ie &&
> > > 
> > 
> > This doesn't really make sense - why does unspecified equal
> > authorized?
> 
> I was considering default behavior here for drivers that do not
> provide this information, ie. drivers not supporting 4-way handshake
> offload. So wpa_supplicant just looks for the PORT_AUTHORIZED
> attribute and deals with it without need for checking 4-way handshake
> offload is supported.

There are two such cases - the driver is old and doesn't provide it,
but of course once you see the attribute you know that's not the case.
And the case that the driver doesn't support 4-way-HS.

Can you really distinguish these though if you *don't* see the
attribute?

But anyway, if it's like mac80211 not providing the data at all, then
it would say authorized, which seems wrong since that's clearly not the
case for mac80211?

Or maybe I'm just confused.

johannes

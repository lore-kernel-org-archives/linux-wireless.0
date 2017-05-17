Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41220 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752083AbdEQOT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 May 2017 10:19:57 -0400
Message-ID: <1495030794.2442.21.camel@sipsolutions.net> (sfid-20170517_162011_655063_1E3D63C9)
Subject: Re: [PATCH V2 0/9] nl80211: add support for PTK/GTK handshake
 offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 17 May 2017 16:19:54 +0200
In-Reply-To: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I think this looks really good. One thing though:

> Another change is the
> addition of the flag ATTR_WANT_1X_4WAY_HS that user-space has to pass
> in CONNECT request. Some drivers may need to be aware before the PMK
> is programmed through SET_PMK request.

I wonder how we really should do this, and if this is good enough.

There might be drivers that simply don't support the non-offloaded
case, so they assume you always have the newer wpa_s. That would seem
to be a legitimate decision, since the compatibility with that might
not make much sense for a completely new driver, and it might be a lot
of work to support TK operations.

We should therefore probably set the expectation that wpa_s - if it's
new enough - always uses the offloaded functionality and always sets
the WANT_1X. Then this is even better with such drivers, since they can
immediately reject the connect() command if want_1x isn't set.

Thoughts?

johannes

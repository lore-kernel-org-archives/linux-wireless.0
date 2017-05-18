Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50424 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755068AbdERJWj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 05:22:39 -0400
Message-ID: <1495099355.2553.1.camel@sipsolutions.net> (sfid-20170518_112251_310109_0FB6FF74)
Subject: Re: [PATCH V2 0/9] nl80211: add support for PTK/GTK handshake
 offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
Date: Thu, 18 May 2017 11:22:35 +0200
In-Reply-To: <1de42f39-1912-349b-e20d-4b5c3c44909f@broadcom.com> (sfid-20170518_101846_333792_84F76EA3)
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
         <1495030794.2442.21.camel@sipsolutions.net>
         <1de42f39-1912-349b-e20d-4b5c3c44909f@broadcom.com>
         (sfid-20170518_101846_333792_84F76EA3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-05-18 at 10:18 +0200, Arend Van Spriel wrote:
> 
> > We should therefore probably set the expectation that wpa_s - if
> > it's new enough - always uses the offloaded functionality and
> > always sets the WANT_1X. Then this is even better with such
> > drivers, since they can immediately reject the connect() command if
> > want_1x isn't set.

> Personally I am fine with this and it is how I tested it. So no
> network configuration or driver parameter in wpa_s.conf (mainly
> because I am lazy ;-) ). However, if the driver supports both offload
> and non-offload why not leave it up to user-space. Might be useful if
> people can try either way for example when debugging connection
> issues.

If that should be possible though, then we'd probably want to have
feature bit both ways, otherwise we'll probably get hard-to-debug
failures at some point with this?

johannes

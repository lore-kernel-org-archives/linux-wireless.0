Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:34222 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751486AbdERISr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 04:18:47 -0400
Received: by mail-wr0-f176.google.com with SMTP id l9so27753627wre.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 May 2017 01:18:46 -0700 (PDT)
Subject: Re: [PATCH V2 0/9] nl80211: add support for PTK/GTK handshake offload
To: Johannes Berg <johannes@sipsolutions.net>
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
 <1495030794.2442.21.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1de42f39-1912-349b-e20d-4b5c3c44909f@broadcom.com> (sfid-20170518_101853_894885_0E032B40)
Date: Thu, 18 May 2017 10:18:43 +0200
MIME-Version: 1.0
In-Reply-To: <1495030794.2442.21.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ hostap list

On 17-5-2017 16:19, Johannes Berg wrote:
> Hi,
> 
> I think this looks really good. One thing though:
> 
>> Another change is the
>> addition of the flag ATTR_WANT_1X_4WAY_HS that user-space has to pass
>> in CONNECT request. Some drivers may need to be aware before the PMK
>> is programmed through SET_PMK request.
> 
> I wonder how we really should do this, and if this is good enough.
> 
> There might be drivers that simply don't support the non-offloaded
> case, so they assume you always have the newer wpa_s. That would seem
> to be a legitimate decision, since the compatibility with that might
> not make much sense for a completely new driver, and it might be a lot
> of work to support TK operations.
> 
> We should therefore probably set the expectation that wpa_s - if it's
> new enough - always uses the offloaded functionality and always sets
> the WANT_1X. Then this is even better with such drivers, since they can
> immediately reject the connect() command if want_1x isn't set.
> 
> Thoughts?

Personally I am fine with this and it is how I tested it. So no network
configuration or driver parameter in wpa_s.conf (mainly because I am
lazy ;-) ). However, if the driver supports both offload and non-offload
why not leave it up to user-space. Might be useful if people can try
either way for example when debugging connection issues.

Regards,
Arend

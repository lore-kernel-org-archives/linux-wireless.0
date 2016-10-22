Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56968 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754877AbcJVU03 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Oct 2016 16:26:29 -0400
Message-ID: <1477167986.4123.1.camel@sipsolutions.net> (sfid-20161022_222632_398690_FEB6A14A)
Subject: Re: cookie_counter in wiphy object
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Sat, 22 Oct 2016 22:26:26 +0200
In-Reply-To: <0e3d457d-b0d1-f2b1-b18b-3f7b3e95365c@broadcom.com> (sfid-20161022_211311_238658_949F2131)
References: <0e3d457d-b0d1-f2b1-b18b-3f7b3e95365c@broadcom.com>
         (sfid-20161022_211311_238658_949F2131)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Since commit a442b761b24b ("cfg80211: add add_nan_func /
> del_nan_func")
> there is a cookie_counter in the wiphy object. It is only used by the
> add_nan_func now, but do we want to consolidate all cookie returning
> functions to use this cookie counter, eg. in .remain_on_channel
> callback.

We probably could now. We used to use pointers and various other kinds
of crappy things for the cookies, but the counters are much safer,
reliable, and easier to debug. Naturally, it fell out that then the
cookies would be assigned in the drivers (well, mac80211), but here I
asked that be changed - I wouldn't mind changing it for other things as
well.

johannes

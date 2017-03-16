Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41846 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751182AbdCPKIp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 06:08:45 -0400
Message-ID: <1489658923.2370.6.camel@sipsolutions.net> (sfid-20170316_110848_058214_F08F8BC5)
Subject: Re: Beacon interval for Mesh/AP in single interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 16 Mar 2017 11:08:43 +0100
In-Reply-To: <CAEFj985tdOMJOHdPEeSqWE6SvicGMdexcKxu8mxJb5CS=mm-iQ@mail.gmail.com> (sfid-20170315_092517_859551_F3CCE4B6)
References: <CAEFj985oo-Dv3dXN7rTTph74mkw_jW=7QrCfEXSjP=OGoexuYg@mail.gmail.com>
         <1489500275.10872.9.camel@sipsolutions.net>
         <CAEFj985tdOMJOHdPEeSqWE6SvicGMdexcKxu8mxJb5CS=mm-iQ@mail.gmail.com>
         (sfid-20170315_092517_859551_F3CCE4B6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-03-15 at 16:25 +0800, Chun-Yeow Yeoh wrote:

> Yes, ath9k for mesh/AP running simultaneously in one single radio
> interface can do beaconing using different beacon interval. Mesh
> providing backhaul to user accessing via STA/AP mode.

Ok.

> > If that worked, then it'd be reasonable to add the appropriate
> > value to
> > the interface combinations to let it work as before.
> > 
> > If it didn't really work properly, then we can just fix the
> > defaults to
> > be compatible?
> 
> I try to put beacon_int_min_gcd in the interface combination with
> mesh/AP/adhoc but the patch "[PATCH] cfg80211: disallow
> beacon_int_min_gcd with IBSS" disables the mesh interface due to
> adhoc interface is there.

Can we split the combination? Or should we just work on fixing this
limitation? Perhaps we could say that if beacon_int_min_gcd is 1, then
that obviously means that there's no real restriction, and then we can
allow with IBSS? How would the hardware react if you had one interface
with beacon interval 99 TU and another with 100 TU? they can collide,
but if there's some kind of mitigation it wouldn't matter, just one of
them would come late after the TBTT...

If it seems reasonable for this hardware to advertise
beacon_int_min_gcd==1, then I think we can change cfg80211 to allow
IBSS in that case.

johannes

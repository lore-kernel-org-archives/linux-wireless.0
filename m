Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39312 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752775AbdBHG6q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 01:58:46 -0500
Message-ID: <1486537122.4603.1.camel@sipsolutions.net> (sfid-20170208_075916_732308_0530EAAD)
Subject: Re: Changing of WMM queue parameters forbidden for IBSS interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rg?= Pommnitz <j.pommnitz@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 08 Feb 2017 07:58:42 +0100
In-Reply-To: <CAEvAWuH-HkC1VNbtLZdjtNQehcE2CR+k0RP=24xMx3TTxzFdUg@mail.gmail.com> (sfid-20170201_152438_772895_B51E2A0E)
References: <CAEvAWuH-HkC1VNbtLZdjtNQehcE2CR+k0RP=24xMx3TTxzFdUg@mail.gmail.com>
         (sfid-20170201_152438_772895_B51E2A0E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-02-01 at 15:24 +0100, Jörg Pommnitz wrote:
> Hello all,
> 
> I'm trying to change the WMM parameters for an IBSS network. I'm
> adding a command to set txq_params to iw. Sadly the current kernel
> code explicitly denies this for interfaces other than AP and P2P (see
> http://lxr.free-electrons.com/source/net/wireless/nl80211.c#L2279).
> 
> Is there a reason why this should not be done for IBSS interfaces?

I guess the whole thing was just ignored - we should also *adopt* the
EDCA parameters when joining an IBSS network, which I don't think we do
either.

I'm not sure we can actually modify them on the fly though - since
adoption is required, such changes would have a hard time propagating
through.

If really necessary, we'd have to implement adoption and probably only
allow setting it at IBSS creation time.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35432 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750932AbdIENYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2017 09:24:02 -0400
Message-ID: <1504617839.12380.14.camel@sipsolutions.net> (sfid-20170905_152409_001154_0F9C4977)
Subject: Re: Cisco's Wi-Fi Direct Client Policy and iwlwifi (8260)
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>,
        Dariusz Gadomski <dariusz.gadomski@canonical.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 05 Sep 2017 15:23:59 +0200
In-Reply-To: <1503076588.15969.320.camel@coelho.fi> (sfid-20170818_191635_285265_E87AFEA4)
References: <20170818124800.q4r6xtflexkbetzq@leonard>
         <1503076588.15969.320.camel@coelho.fi>
         (sfid-20170818_191635_285265_E87AFEA4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-08-18 at 20:16 +0300, Luca Coelho wrote:
> 
> I have heard about this before.  The issue is that the Cisco AP
> doesn't allow the 8260 to connect because it has the P2P IE in
> it.  But AFAICT it is not against any specs to include this IE.  The
> Cisco AP is using the IE as an indication that we are trying to
> connect as a P2P device, which in this case we are not.

I believe that this is technically incorrect: they're assuming that
because P2P IEs are included, the device is P2P *capable* - completely
unrelated to connecting as a P2P-client (vs. a regular BSS client).

Because the device is P2P capable, there's a policy decision in the
configuration to not allow these clients to connect. This is actually
described in sections 3.4.3/3.4.4 of the P2P spec, and we should
probably implement the recommendations there?

johannes

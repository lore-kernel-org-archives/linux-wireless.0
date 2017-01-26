Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33807 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752030AbdAZOpo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jan 2017 09:45:44 -0500
Message-ID: <1485441942.5145.131.camel@edumazet-glaptop3.roam.corp.google.com> (sfid-20170126_154548_909720_044F37AA)
Subject: Re: IPv6-UDP 0x0000 checksum
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 26 Jan 2017 06:45:42 -0800
In-Reply-To: <1485438546.14760.7.camel@sipsolutions.net>
References: <1485437276.14760.3.camel@sipsolutions.net>
         <1485438299.5145.117.camel@edumazet-glaptop3.roam.corp.google.com>
         (sfid-20170126_144502_343976_16232A6D) <1485438546.14760.7.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-26 at 14:49 +0100, Johannes Berg wrote:

> Oops, sorry - receive. We can only indicate "CHECKSUM_UNNECESSARY",
> nothing more advanced right now, but right now we'd indicate that if
> the packet had 0x0000 in the checksum field, but should've had 0xffff.
> 
> On TX I believe we actually do in HW exactly what your patch just did.

Can you describe the visible effects of this problem ?

Is that because of a conversion we might do later to CHECKSUM_COMPLETE ?

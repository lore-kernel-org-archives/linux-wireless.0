Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:37304 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731305AbeITNNw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 09:13:52 -0400
Message-ID: <1537428695.3874.1.camel@sipsolutions.net> (sfid-20180920_093150_146904_464DAB19)
Subject: Re: Problem with sending pkt on a monitor port
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 20 Sep 2018 09:31:35 +0200
In-Reply-To: <d6f99a05-77a3-f18a-4e7a-083062119ce4@candelatech.com>
References: <76ce3d16-dbea-e882-63e7-2337fbc269c6@candelatech.com>
         <1537389335.10305.92.camel@sipsolutions.net>
         <d6f99a05-77a3-f18a-4e7a-083062119ce4@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-19 at 13:47 -0700, Ben Greear wrote:

> > For one, the driver has no concept of the original vif, since monitor
> > vifs aren't added to it.
> 
> ath10k does create a monitor vif, but maybe it is not mapped directly
> to mac80211.

It's actually created by mac80211, but only once, and not directly
mapped to each vif seen by userspace - it's an internal construction.

> > Secondly, the old hostapd code before nl80211 injects frames that way,
> > and they need to go there.
> 
> Ok, I agree we should not break backwards compat then.  I'll poke some more
> to see if I can get it working.

We might get away with doing this only for cooked monitor mode, which it
used there ...

However, thinking about it, that also breaks userspace in other ways -
for example if you do injection this way you actually get encryption and
other nice things if you use the local address that matches an existing
interface.

Perhaps you should just use a different address, and then nothing of the
sort would happen?

johannes

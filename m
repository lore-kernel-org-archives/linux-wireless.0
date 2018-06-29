Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:39130 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934711AbeF2Ssx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 14:48:53 -0400
Received: by mail-pg0-f67.google.com with SMTP id n2-v6so4359433pgq.6
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jun 2018 11:48:53 -0700 (PDT)
Date: Fri, 29 Jun 2018 11:48:48 -0700
From: Brian Norris <briannorris@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] cfg80211: use IDA to allocate wiphy indeces
Message-ID: <20180629184847.GA251207@ban.mtv.corp.google.com> (sfid-20180629_204938_975092_D46288E8)
References: <20180621012945.185705-1-briannorris@chromium.org>
 <1530258140.3481.4.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1530258140.3481.4.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Fri, Jun 29, 2018 at 09:42:20AM +0200, Johannes Berg wrote:
> On Wed, 2018-06-20 at 18:29 -0700, Brian Norris wrote:
> > It's annoying to see the phy index increase arbitrarily, just because a
> > device got removed and re-probed (e.g., during a device reset, or due to
> > probe testing). We can use the in-kernel index allocator for this,
> > instead of just an increasing counter.
> 
> I can understand that it's somewhat annoying to people, but it was
> actually done on purpose to avoid userspace talking to the wrong device.

Hmm, interesting. I'm not dead-set on this patch, so if there are good
reasons to reject it, I won't fret.

> Imagine you have some userspace process running that has remembered the
> wiphy index to use it to talk to nl80211, and now underneath the device
> goes away and reappears. This process should understand that situation,
> and handle it accordingly, rather than being blind to the reset.

How is this different from the wlan (netdev) device naming? We allow
'wlan0' to leave and return under the same name. Isn't the right answer
that user space should be listening for udev and/or netlink events?

Brian

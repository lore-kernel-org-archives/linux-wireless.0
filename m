Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33834 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933316AbeF2HmX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 03:42:23 -0400
Message-ID: <1530258140.3481.4.camel@sipsolutions.net> (sfid-20180629_094241_011228_C7069235)
Subject: Re: [PATCH] cfg80211: use IDA to allocate wiphy indeces
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Norris <briannorris@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Date: Fri, 29 Jun 2018 09:42:20 +0200
In-Reply-To: <20180621012945.185705-1-briannorris@chromium.org> (sfid-20180621_033004_543173_9D94C00F)
References: <20180621012945.185705-1-briannorris@chromium.org>
         (sfid-20180621_033004_543173_9D94C00F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

On Wed, 2018-06-20 at 18:29 -0700, Brian Norris wrote:
> It's annoying to see the phy index increase arbitrarily, just because a
> device got removed and re-probed (e.g., during a device reset, or due to
> probe testing). We can use the in-kernel index allocator for this,
> instead of just an increasing counter.

I can understand that it's somewhat annoying to people, but it was
actually done on purpose to avoid userspace talking to the wrong device.

Imagine you have some userspace process running that has remembered the
wiphy index to use it to talk to nl80211, and now underneath the device
goes away and reappears. This process should understand that situation,
and handle it accordingly, rather than being blind to the reset.

johannes

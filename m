Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55884 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbdCQM2R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 08:28:17 -0400
Message-ID: <1489753692.2544.9.camel@sipsolutions.net> (sfid-20170317_132819_929973_9CB9F3D4)
Subject: Re: [PATCH 2/2] mac80211: Drop new node with weak power
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 17 Mar 2017 13:28:12 +0100
In-Reply-To: <d0eb6984-6ae7-d984-b61a-0c98603294ae@gmail.com> (sfid-20170317_065642_176557_2AC4F6FC)
References: <1489629438-7087-1-git-send-email-masashi.honma@gmail.com>
         <1489629438-7087-2-git-send-email-masashi.honma@gmail.com>
         <1489658630.2370.4.camel@sipsolutions.net>
         <d0eb6984-6ae7-d984-b61a-0c98603294ae@gmail.com>
         (sfid-20170317_065642_176557_2AC4F6FC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-17 at 14:56 +0900, Masashi Honma wrote:

> > It seems that this is really what the meshcfg.rssi_threshold was
> > intended for, and the plink code *does* take it into account. Can
> > you
> > explain where that's breaking down?
> 
> Indeed meshcfg.rssi_threshold is already referred by some codes. But
> when booting mesh node with user_mpm=1, the codes is not called.
> So we need to add another code.

Hmm. If path selection isn't done by mac80211 in this case, wouldn't it
be more appropriate to put this logic into the (userspace) component
that does path selection?

IOW, I'm not convinced that outright not adding the *peer* is a good
idea either way - it seems much better to me to not use the *path*.

johannes

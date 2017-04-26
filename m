Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45238 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937876AbdDZJIH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 05:08:07 -0400
Message-ID: <1493197685.2464.15.camel@sipsolutions.net> (sfid-20170426_113351_425473_724E3C38)
Subject: Re: [PATCH V3 1/9] nl80211: allow multiple active scheduled scan
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 26 Apr 2017 11:08:05 +0200
In-Reply-To: <4323eaab-39c2-1946-a4dd-3d37361e3d8c@broadcom.com> (sfid-20170426_110528_177524_24D103D9)
References: <1492776308-15120-1-git-send-email-arend.vanspriel@broadcom.com>
         <1492776308-15120-2-git-send-email-arend.vanspriel@broadcom.com>
         <1493149747.15192.0.camel@sipsolutions.net>
         <3ce6aed5-7d00-3446-a39b-b5da4b788358@broadcom.com>
         <1493196583.2464.14.camel@sipsolutions.net>
         <4323eaab-39c2-1946-a4dd-3d37361e3d8c@broadcom.com>
         (sfid-20170426_110528_177524_24D103D9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-04-26 at 11:05 +0200, Arend van Spriel wrote:
> I guess it could be done, but I'm tending towards doing that less
> > again, I have no strong preference in this case. If it was
> > something
> > that seems likely to get abused, perhaps, but here...
> 
> Ok. As long as drivers don't think they can use the list_head to push
> it on a private list.

They'll crash immediately and be disabused of that notion :)

> The internal use comment does not end up in 
> kerneldoc. So maybe we can improve that? Would work for me.

It's difficult - though we could replace it with /* private: */ and
remove those things from kernel-doc entirely.

johannes

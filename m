Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51694 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752848AbdDGTM1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 15:12:27 -0400
Message-ID: <1491592343.5800.8.camel@sipsolutions.net> (sfid-20170407_211244_302181_9C691440)
Subject: Re: [RFC 2/3] genetlink: pass extended error report down
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: pablo@netfilter.org
Date: Fri, 07 Apr 2017 21:12:23 +0200
In-Reply-To: <25e1fb8c-22e0-d7a2-13a7-d0def5432c9e@candelatech.com>
References: <20170407182620.6438-1-johannes@sipsolutions.net>
         <20170407182620.6438-3-johannes@sipsolutions.net>
         <25e1fb8c-22e0-d7a2-13a7-d0def5432c9e@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-04-07 at 11:37 -0700, Ben Greear wrote:
> 
> I guess the error string must be constant and always available in
> memory in this implementation?

Yes.

> I think it would be nice to dynamically create strings (malloc,
> snprintf, etc) and have the err_str logic free it when done?

We can think about that later, but I don't actually think it makes a
lot of sense - if we point to the attribute and/or offset you really
ought to have enough info to figure out what's up.

johannes

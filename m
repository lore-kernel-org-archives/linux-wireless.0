Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40536 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753005AbdCHGin (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 01:38:43 -0500
Message-ID: <1488955036.31187.1.camel@sipsolutions.net> (sfid-20170308_073900_709773_D879D861)
Subject: Re: rate mask resulting in no usable rates - WARN_ON
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 08 Mar 2017 07:37:16 +0100
In-Reply-To: <a1cd3a56-0453-7675-6895-9521a412a9cd@candelatech.com>
References: <1488933811.4723.1.camel@sipsolutions.net>
         <a1cd3a56-0453-7675-6895-9521a412a9cd@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Is anyone - other than ChromeOS, which sets it just after
> > association - actually using this?
> 
> I know several people who use this and depend on it being sticky.  

Do you know how they use it in more detail?

> For that matter, I think LEDE and probably OpenWRT uses 'iw' quite a
> bit to affect rates.

That seems odd, but ok.

Either way, if people do rely on it being sticky then I'll do the next
best thing and just clear the mask when detecting a situation where it
would result in no usable rates, as well as rejecting it when it's
already known that it would do so.

johannes

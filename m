Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39132 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750734AbdALIhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 03:37:13 -0500
Message-ID: <1484210226.5391.1.camel@sipsolutions.net> (sfid-20170112_093730_369726_BDB087EE)
Subject: Re: [PATCH] wext: handle NULL exta data in iwe_stream_add_point
 better
From: Johannes Berg <johannes@sipsolutions.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Date: Thu, 12 Jan 2017 09:37:06 +0100
In-Reply-To: <3292373.oxnXTOSWCQ@wuerfel>
References: <20170111143532.485827-1-arnd@arndb.de>
         <CAK8P3a2mOT=BG=9yxJ1e-q__5FYq6dfF3t3bT1vqcgFaQAUjog@mail.gmail.com>
         <1484147177.29931.14.camel@sipsolutions.net> <3292373.oxnXTOSWCQ@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-11 at 21:39 +0100, Arnd Bergmann wrote:
> On Wednesday, January 11, 2017 4:06:17 PM CET Johannes Berg wrote:
> > 
> > Applied. Also fixed the typo in the subject :)
> 
> Thanks! Unfortunately I now got another warning for the same
> function, and though I would have expected the patch to fix it, that
> did not work:

I've come to expect better of you (i.e. testing your own patches) ;-)


Come to think of it, I'm thinking I should drop this patch and the
driver should just use iwe_stream_add_event() instead? It'll be
somewhat tricky to get the length correct though.

Alternatively, perhaps we should just uninline all the crap and then
the compiler can't bother us :)

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38498 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752340AbdIRKUl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 06:20:41 -0400
Message-ID: <1505730039.13691.3.camel@sipsolutions.net> (sfid-20170918_122044_586666_EE893019)
Subject: Re: [PATCH 2/2] qtnfmac: abort scans on wireless interface changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Mon, 18 Sep 2017 12:20:39 +0200
In-Reply-To: <20170918101654.5zukak72wvmpm6pp@bars>
References: <20170918080446.21763-1-sergey.matyukevich.os@quantenna.com>
         <20170918080446.21763-3-sergey.matyukevich.os@quantenna.com>
         <1505724068.13691.0.camel@sipsolutions.net>
         <20170918095713.mfn76hkdbo73k4fu@bars>
         <1505728987.13691.2.camel@sipsolutions.net>
         <20170918101654.5zukak72wvmpm6pp@bars>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-09-18 at 13:16 +0300, Sergey Matyukevich wrote:
> 
> > > > > -     if (timer_pending(&mac->scan_timeout))
> > > > > -             del_timer_sync(&mac->scan_timeout);

> I don't quite understand the question. Do you mean it makes sense to
> call cfg80211_scan_done first and then cancel timer ?

No, I'm just not sure why you call timer_pending() first.

johannes

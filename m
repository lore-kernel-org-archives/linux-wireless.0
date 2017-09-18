Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0075.outbound.protection.outlook.com ([104.47.36.75]:13088
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751861AbdIRKbO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 06:31:14 -0400
Date: Mon, 18 Sep 2017 13:31:01 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 2/2] qtnfmac: abort scans on wireless interface changes
Message-ID: <20170918103101.o3u6v6jncsvh6qkn@bars> (sfid-20170918_123118_874788_3397FDC8)
References: <20170918080446.21763-1-sergey.matyukevich.os@quantenna.com>
 <20170918080446.21763-3-sergey.matyukevich.os@quantenna.com>
 <1505724068.13691.0.camel@sipsolutions.net>
 <20170918095713.mfn76hkdbo73k4fu@bars>
 <1505728987.13691.2.camel@sipsolutions.net>
 <20170918101654.5zukak72wvmpm6pp@bars>
 <1505730039.13691.3.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1505730039.13691.3.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > > > > -     if (timer_pending(&mac->scan_timeout))
> > > > > > -             del_timer_sync(&mac->scan_timeout);
> 
> > I don't quite understand the question. Do you mean it makes sense to
> > call cfg80211_scan_done first and then cancel timer ?
> 
> No, I'm just not sure why you call timer_pending() first.

Well, it looks like before this change it was redundant. But now it makes
sense to avoid deadlock when this function is called from the timer itself.

Regards,
Sergey

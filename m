Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0059.outbound.protection.outlook.com ([104.47.34.59]:20000
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750876AbeBHJGS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 04:06:18 -0500
Date: Thu, 8 Feb 2018 12:06:03 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH 4/6] qtnfmac: fix rmmod for missing firmware
Message-ID: <20180208090601.ornrxzwqy3rtt2ge@bars> (sfid-20180208_100626_754466_ABAB04AA)
References: <20180205150516.16030-1-sergey.matyukevich.os@quantenna.com>
 <20180205150516.16030-5-sergey.matyukevich.os@quantenna.com>
 <5A798F15.4050703@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A798F15.4050703@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Arend,

Thanks for review.

> > Check that firmware exists prior to starting firmware download.
> 
> Why would you do that? It seems expensive given that you obtain the
> firmware and discard it immediately just to check it exists. Especially,
> given that such a call can take 60 seconds to complete depending on
> kernel config.
> 
> Apart from that see minor comment below although I would seriously
> reconsider this patch altogether.

The idea behind this approach is simple: to quit early and to avoid starting
asynchronous card boot if no firmware file exists. However I didn't realize that
such a long delay may occur. What makes me worried is that the worst case
scenario may happen if firmware actually exists: we make two calls of
request_firmware, each of them taking long time.

I agree that it makes a lot of sense to reimplement this approach requesting
firmware only once. Will do for v2.

Regards,
Sergey

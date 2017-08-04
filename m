Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0069.outbound.protection.outlook.com ([104.47.36.69]:46971
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752325AbdHDUyG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Aug 2017 16:54:06 -0400
Date: Fri, 4 Aug 2017 23:53:57 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH v2 09/12] qtnfmac: implement scan timeout
Message-ID: <20170804205356.4qyfj4wnlnrnvx5d@bars> (sfid-20170804_225412_252606_C4644B28)
References: <20170727230654.30850-1-sergey.matyukevich.os@quantenna.com>
 <20170727230654.30850-10-sergey.matyukevich.os@quantenna.com>
 <87r2wtugco.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87r2wtugco.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +     if (timer_pending(&mac->scan_timeout))
> > +             del_timer_sync(&mac->scan_timeout);
> 
> What if the device is removed while the timer is pending, is that
> handled?

Good point. I took another look at this kind of corner cases. Timer is not disabled
explicitely. But ongoing scan request is explicitely aborted in relevant
cfg80211 ops, e.g. on virtual interface change or removal. Though it looks like
some of AP usecases are not handled: e.g. when AP is stopped while scan is
in progress. I will queue the fix into the next cleanup/bugfix patch series
if it is needed to abort scan in such a case.

Thanks,
Sergey

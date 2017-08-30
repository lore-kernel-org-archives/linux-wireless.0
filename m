Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0066.outbound.protection.outlook.com ([104.47.40.66]:51680
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751300AbdH3IpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 04:45:13 -0400
Date: Wed, 30 Aug 2017 11:45:02 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 3/5] qtnfmac: modify qtnf_map_bar not to return NULL
Message-ID: <20170830084501.vowpiepvdd3rqgcp@bars> (sfid-20170830_104517_736476_48CD63CF)
References: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
 <20170829121623.24761-4-sergey.matyukevich.os@quantenna.com>
 <fc30ee02-2aaa-23c6-46e3-fbeb5b5230ef@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fc30ee02-2aaa-23c6-46e3-fbeb5b5230ef@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 29, 2017 at 07:13:35PM -0700, Igor Mitsyanko wrote:
> On 08/29/2017 05:16 AM, Sergey Matyukevich wrote:
> > NULL is not a special type of success here but a error pointer.
> > So it makes sense to check against NULL in qtnf_map_bar
> > and return error code.
> > 
> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> > ---
> 
> On a first glance not immediately obvious what is logically changed here, is
> it so that pr_debug() would not print NULL pointer?

There is no actual bug here: all the mappings and error checks are in place.
This is more about coding style problem: when function return both NULL and
error pointeres, then the NULL is supposed to be a special type of success
return. In this particular case NULL is just yet another failure.

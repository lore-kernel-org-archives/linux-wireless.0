Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56948 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751018AbdCQM7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 08:59:41 -0400
Message-ID: <1489755538.2544.11.camel@sipsolutions.net> (sfid-20170317_140023_399168_79A56836)
Subject: Re: [RFT] brcmfmac: add support to move wiphy instance into network
 namespace
From: Johannes Berg <johannes@sipsolutions.net>
To: Mark Asselstine <mark.asselstine@windriver.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 17 Mar 2017 13:58:58 +0100
In-Reply-To: <10023407.Rx0XN2k1RN@yow-masselst-lx1>
References: <1489528312-28304-1-git-send-email-arend.vanspriel@broadcom.com>
         <0343e3c9-baf8-f3b1-8c37-c8b0864bd7e5@broadcom.com>
         <012ec28b-ff56-5a65-848f-0a66919ad00e@broadcom.com>
         <10023407.Rx0XN2k1RN@yow-masselst-lx1>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > I guess this is intended behavior?
> 
> I had thought this was intended behavior as well but I see that a
> patch is already prepped and tested to make this not happen. At any
> rate it wasn't appearing to affect my usecase.

I can't actually see how it'd affect any usecase, since you really need
to check inside the new netns what's going on etc. anyway, and you
don't really want to pass such identifiers across the boundaries. But
preserving it makes more sense, if only for debugging and making sure
we won't run out of numbers :)

johannes

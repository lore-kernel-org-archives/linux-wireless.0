Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60744 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751837AbdADKbC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 05:31:02 -0500
Message-ID: <1483525836.7312.1.camel@sipsolutions.net> (sfid-20170104_113134_852290_2053E4D1)
Subject: Re: [RFC] nl80211: allow multiple active scheduled scan requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Dmitry Shmidt <dimitrysh@google.com>
Date: Wed, 04 Jan 2017 11:30:36 +0100
In-Reply-To: <5ad9a594-29b3-8c52-a88f-c4186511fe4f@broadcom.com> (sfid-20170104_112053_991115_3F397A44)
References: <1481645071.20412.30.camel@sipsolutions.net>
         <1482315616-4721-1-git-send-email-arend.vanspriel@broadcom.com>
         <1483353841.4596.2.camel@sipsolutions.net>
         <ba1cb1a1-3d27-7421-47ea-a5625a886518@broadcom.com>
         <1483523988.15591.9.camel@sipsolutions.net>
         <5ad9a594-29b3-8c52-a88f-c4186511fe4f@broadcom.com>
         (sfid-20170104_112053_991115_3F397A44)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> However, we need to prefer something
> > -
> > always preferring the new sched scan could lead to bounces, so we
> > can
> > prefer (1) existing, (2) legacy-single type or (3) new-multi type,
> > but
> > not (4) new sched scan.
> 
> Not sure I can follow. What is the difference between (1) and (2). 

(1) would never cancel any existing sched scan, regardless of type
(legacy vs. multi-capable)

(2) would cancel an existing sched scan (in favour of a new one) if the
existing one is multi-capable

(3) would cancel an existing sched scan (in favour of a new one) if the
existing one is legacy type

> Also
> what do you consider (4) new sched scan. You mean the additional
> parameterization of the scheduled scan?

No, I just meant any new request.

> > I think preferring the existing would probably be best, i.e. refuse
> > legacy if any sched scan is running, and refuse multi if legacy is
> > running?
> 
> Whatever the response above, I can understand this and it seems most
> straightforward. So I tend agree this is our best option although
> maybe for the wrong reason.

:)

johannes

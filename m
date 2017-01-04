Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35462 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030641AbdADNeb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 08:34:31 -0500
Message-ID: <1483536867.7312.9.camel@sipsolutions.net> (sfid-20170104_144057_407528_4566E7B4)
Subject: Re: [PATCH v2 2/2] cfg80211: Add support to sched scan to report
 better BSSs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "Vamsi, Krishna" <vamsin@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 04 Jan 2017 14:34:27 +0100
In-Reply-To: <20161220205221.GB9756@jouni.qca.qualcomm.com>
References: <1480715949-20169-1-git-send-email-jouni@qca.qualcomm.com>
         <1480715949-20169-2-git-send-email-jouni@qca.qualcomm.com>
         <1481102727.4092.34.camel@sipsolutions.net>
         <dc960243db2b452f97721dad49f0a63b@aphydexm01b.ap.qualcomm.com>
         <280cb669-2360-d4fc-779b-80196c944e2e@broadcom.com>
         <20161208175236.GA6121@jouni.qca.qualcomm.com>
         <63343007-2245-1861-94fd-bdda0de2f7dc@broadcom.com>
         <1481644615.20412.25.camel@sipsolutions.net>
         <20161215110635.GA11840@jouni.qca.qualcomm.com>
         <1481882211.27953.18.camel@sipsolutions.net>
         <20161220205221.GB9756@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-12-20 at 20:52 +0000, Malinen, Jouni wrote:

> > I think between that (unless we add that, we could technically
> > extend flag attributes to allow them being an int as well, or add a
> > new one) and the fact that the device may not support different
> > relative RSSI matches in different matchsets, I'm almost convinced
> > that adding new attributes is better.
> 
> I'm not completely sure how to interpret all this and also the last
> email from Arend in this thread. Could either (or both :) of you
> providemore detailed suggestion on what exactly you would like us to 
> change, if anything, in the attribute design now so that we can try
> to close on this?

I guess I'm thinking out loud too much :-)

Moving to the (band,adjustment) struct thing, like we have it in the
BSS select now, would be good I think - instead of the single value
that has the band hardcoded in the name. It's fairly useless with just
two bands since you can adjust one or the other to achieve the same
result, but for consistency it'd be good.

And then doing a match attribute we more or less discarded here, so
conceptually nothing else really changes.

johannes

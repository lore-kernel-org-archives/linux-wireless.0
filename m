Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60506 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756279AbdIHI5F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 04:57:05 -0400
Message-ID: <1504861023.6177.14.camel@sipsolutions.net> (sfid-20170908_105710_262992_49A01A73)
Subject: Re: [PATCH 1/2] wireless: set correct mandatory rate flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard =?ISO-8859-1?Q?Sch=FCtz?= <rschuetz@uni-koblenz.de>,
        linux-wireless@vger.kernel.org
Date: Fri, 08 Sep 2017 10:57:03 +0200
In-Reply-To: <85930e91-2c1e-53a6-5b65-d796116295fa@uni-koblenz.de>
References: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
         <1504853647.6177.8.camel@sipsolutions.net>
         <85930e91-2c1e-53a6-5b65-d796116295fa@uni-koblenz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-08 at 10:43 +0200, Richard Schütz wrote:

> > Hmm, I guess technically you're correct, since 11b added what's now
> > Clause 16 (was Clause 18 at the time), and that has all of them
> > mandatory? But perhaps this was actually intended for Clause 15
> > compatibility?
> 
> Compatibility in what way?

Well, realistically there are only three users of this information:

 * ieee80211_mandatory_rates(), used for supported station rates if we
   don't know anything better in IBSS (and OCB) and for basic rates in
   mesh;
 * basic rates in IBSS (__cfg80211_join_ibss);
 * duration calculation in ieee80211_duration, but that's just a
   fallback

So I guess it's now pretty unlikely that anyone would have a pre-11b
device, so it would make sense to actually make this change.

johannes

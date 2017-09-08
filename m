Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59056 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754614AbdIHGzm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 02:55:42 -0400
Message-ID: <1504853740.6177.10.camel@sipsolutions.net> (sfid-20170908_085613_360648_DA28B60E)
Subject: Re: [PATCH 2/2] wireless: return correct mandatory rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard =?ISO-8859-1?Q?Sch=FCtz?= <rschuetz@uni-koblenz.de>,
        linux-wireless@vger.kernel.org
Date: Fri, 08 Sep 2017 08:55:40 +0200
In-Reply-To: <20170907154744.28357-2-rschuetz@uni-koblenz.de> (sfid-20170907_175517_817760_1C44F457)
References: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
         <20170907154744.28357-2-rschuetz@uni-koblenz.de>
         (sfid-20170907_175517_817760_1C44F457)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-09-07 at 17:47 +0200, Richard Schütz wrote:
> Use IEEE80211_RATE_MANDATORY_G instead of IEEE80211_RATE_MANDATORY_B
> for comparison to get all mandatory rates in 2.4 GHz band. It is safe
> to do so because ERP mandatory rates are a superset of HR/DSSS
> mandatory rates.

This I don't understand - what "comparison" are you talking about?

> Also force IEEE80211_RATE_MANDATORY_A for 10 MHz and 5 MHz channels
> as they use "half-clocked" respectively "quarter-clocked" operation
> of the OFDM rates (IEEE Std 802.11-2016, 17.1.1).

I don't think this is correct - the way the flags are used, anything on
2.4 GHz would never bother to check the MANDATORY_A flag.

johannes

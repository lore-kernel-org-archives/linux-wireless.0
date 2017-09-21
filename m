Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45762 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751714AbdIUNwI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 09:52:08 -0400
Message-ID: <1506001926.2048.5.camel@sipsolutions.net> (sfid-20170921_155212_745730_527B0AEF)
Subject: Re: [PATCH v2 2/2] wireless: return correct mandatory rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard =?ISO-8859-1?Q?Sch=FCtz?= <rschuetz@uni-koblenz.de>,
        linux-wireless@vger.kernel.org
Date: Thu, 21 Sep 2017 15:52:06 +0200
In-Reply-To: <20170908160712.8765-1-rschuetz@uni-koblenz.de> (sfid-20170908_180746_422254_8173A2C4)
References: <20170907154744.28357-2-rschuetz@uni-koblenz.de>
         <20170908160712.8765-1-rschuetz@uni-koblenz.de>
         (sfid-20170908_180746_422254_8173A2C4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-08 at 18:07 +0200, Richard Schütz wrote:
> Use IEEE80211_RATE_MANDATORY_G instead of IEEE80211_RATE_MANDATORY_B
> to get
> all mandatory rates in 2.4 GHz band. It is safe to do so because ERP
> mandatory rates are a superset of HR/DSSS mandatory rates. Also limit
> to
> OFDM rates for 10 MHz and 5 MHz channels as originally intended by
> commit
> 74608aca4d82e.

I don't understand this. Why should all ERP (Clause 18, 11g) rates be
mandatory for the users of this?

The way I see it, this would make us assume that all 2.4 GHz clients
support ERP in IBSS, which may not be true?

johannes

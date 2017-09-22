Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38136 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751872AbdIVK2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Sep 2017 06:28:44 -0400
Message-ID: <1506076123.2048.11.camel@sipsolutions.net> (sfid-20170922_122848_998018_65B98667)
Subject: Re: [PATCH v2 2/2] wireless: return correct mandatory rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard =?ISO-8859-1?Q?Sch=FCtz?= <rschuetz@uni-koblenz.de>,
        linux-wireless@vger.kernel.org
Date: Fri, 22 Sep 2017 12:28:43 +0200
In-Reply-To: <63eebfc4-2622-87b1-699e-58a222715900@uni-koblenz.de>
References: <20170907154744.28357-2-rschuetz@uni-koblenz.de>
         <20170908160712.8765-1-rschuetz@uni-koblenz.de>
         <1506001926.2048.5.camel@sipsolutions.net>
         <63eebfc4-2622-87b1-699e-58a222715900@uni-koblenz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-22 at 12:09 +0200, Richard Schütz wrote:

> > The way I see it, this would make us assume that all 2.4 GHz
> > clients support ERP in IBSS, which may not be true?
> 
> I disagree. On a HR/DSSS PHY this would still only return HR/DSSS
> rates because there should not by any ERP rates present in sband-
> >bitrates in the first place.

Sure, but that means that if you're an ERP PHY (which all users of this
code are likely to be), you'd assume that *everyone else* you're
talking to also is - and that's not necessarily desired.

> The reason for suggesting this change is that the basic rate set for
> a mesh STA is initialized with this function if not explicitly
> configured beforehand.

Exactly! So if you mark all the rates as basic that are mandatory for
you, you can never peer mesh with a HR/DSSS PHY. Now, that's probably
unlikely to happen - but for IBSS I'd argue it's reasonable, and the
same would happen there afaict.

> IEEE Std 802.11-2016 (10.7.4 Basic rate set, basic HT-MCS set, and
> basic VHT-MCS and NSS set for mesh STA) states: A mesh STA shall not
> establish a mesh peering with a mesh STA using a different
> BSSBasicRateSet (see 14.2.7 and 14.2.8). The SME of a Mesh STA should
> use the mandatory PHY rates as the default BSSBasicRateSet in the
> MLME-START.request primitive to reduce the risk that a candidate peer
> mesh STA utilizes a different BSSBasicRateSet.

"Should" isn't "shall"

> Selecting only HR/DSSS mandatory rates for a mesh STA default basic
> rate set on an ERP PHY violates this requirement in my opinion. 

It does seem to violate the "should", but arguably that's just a
configuration choice.

> wpa_supplicant explicitly configures all ERP mandatory rates for ERP 
> mesh points in its default configuration, whereas iw relies on the 
> kernel to do the selection. This currently leaves us with the 
> unfortunate situation that you can not join such a mesh BSS created
> by wpa_supplicant using iw without further configuration and the
> other way round.

So now we've finally gotten to the bottom of why you're doing all this?

Anyway, I disagree with the patch. I can get behind a patch changing
the mesh code, but not in a way that affects the IBSS like this.

johannes

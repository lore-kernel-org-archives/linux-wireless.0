Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from intermedia.net ([64.78.21.82]:39048 "EHLO
	dhost002-16.dex002.intermedia.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752038AbXCHAtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 19:49:41 -0500
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Wed, 7 Mar 2007 16:49:40 -0800
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: cfg/nl80211 primitives
Message-ID: <20070308004940.GC31388@devicescape.com>
References: <1173219649.3503.50.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1173219649.3503.50.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 06, 2007 at 11:20:49PM +0100, Johannes Berg wrote:

> To me, separating actions from settings is basically this procedure:
>  (1) give the kernel a bunch of parameters
>  (2) give it some other parameter
>  (3) change some parameters again
>  (4) tell it to use the "current parameters" to do X
> (where X may be "associate", "authenticate", ...)

And where would
   (5) change some parameters within this association without triggering
       new authentication/association
fit in?

> However, I don't see why we shouldn't go to a model where we give the
> kernel all information it needs to do an operation when we want it to do
> it, like the procedure
>  (1) tell the kernel to do X
>    - using parameter A=B
>    - using parameter C=D
>    - ...
>  (2) tell the kernel to do Y

Would this be all parameters as in _no_ other parameters could be set
before or after the command? As an example, how would one set
fragmentation threshold and then change that value after having
associated?

> This would also be a lot more in line with primitives outlined in the
> IEEE 802.11 specification, like MLME-ASSOCIATE.request et al. In fact,
> it seems that the interface could be modelled pretty much after the MLME
> SAP interface outlined in clause 10.3.

MLME SAP primitives may be okay for many cases, but we cannot limit
ourselves to just the parameters defined there. Number of parameters do
not go through MLME SAP interface and some of the options may require
getting used to (e.g., power management options would use their own
primitive, not MLME-ASSOCIATE, etc.).

> Obviously, we wouldn't need to actually have all of them. For example,
> MLME-START.request for BSSes wouldn't be implemented within mac80211 but
> rather in hostapd. I don't know how ipw2200 master mode works though,
> maybe we would in fact need to have the MLME-START.request in nl80211
> for some devices. For a whole range of hardware MLME-JOIN also makes no
> sense, but for bcm43xx for example it almost would [1].

MLME SAP interface is between MLME and SME, but when we have some parts
of MLME in user space and some in kernel, things can get bit confusing
since the interface between MLME and SME is not the same as interface
between kernel and user space.

-- 
Jouni Malinen                                            PGP id EFC895FA

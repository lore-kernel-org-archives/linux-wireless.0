Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37588 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752540AbdBUOqN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 09:46:13 -0500
Message-ID: <1487688369.15350.3.camel@sipsolutions.net> (sfid-20170221_154616_216812_DC7B7832)
Subject: Re: [RFC v2 1/2] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Date: Tue, 21 Feb 2017 15:46:09 +0100
In-Reply-To: <20170221144335.GA17601@w1.fi>
References: <20170221123758.5339-1-johannes@sipsolutions.net>
         <20170221144335.GA17601@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> While the existing WPA2-PSK cases all use 32 octet PMK, there are
> also
> 48 octet PMKs in use with EAP (Suite B 192-bit level and FILS with
> SHA384). Patch 2/2 seemed to look at the PMK length as well.. Should
> the same be done already with 1/2 so that the PSK case is separately
> validating exact match with 32 octets in length for PMK = PSK while
> the other cases allow longer PMK as well?
> 
> I never remember how the attr policy .len works, so that may already
> be the implicit behavior here, but it would be clearer to be more
> explicit about the possible lengths of the WLAN_ATTR_PMK and not
> assume that WLAN_PMK_LEN definition is the only possible option.

The .len verifies that it's at least that long. We're thus ignoring
additional bytes in the PSK case if they're present, which I suppose we
should fix by checking the exact length in the code separately.

johannes

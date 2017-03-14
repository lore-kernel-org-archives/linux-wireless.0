Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39658 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751635AbdCNOEh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Mar 2017 10:04:37 -0400
Message-ID: <1489500275.10872.9.camel@sipsolutions.net> (sfid-20170314_150447_567535_2E6EB0A5)
Subject: Re: Beacon interval for Mesh/AP in single interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 14 Mar 2017 15:04:35 +0100
In-Reply-To: <CAEFj985oo-Dv3dXN7rTTph74mkw_jW=7QrCfEXSjP=OGoexuYg@mail.gmail.com> (sfid-20170309_052218_154549_E223479F)
References: <CAEFj985oo-Dv3dXN7rTTph74mkw_jW=7QrCfEXSjP=OGoexuYg@mail.gmail.com>
         (sfid-20170309_052218_154549_E223479F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> The introduction of the following patches doesn't allow the AP and
> mesh mode to simultaneously run on a single radio interface due to
> beacon interval for both interfaces by default is different.
> [PATCH] cfg80211: disallow beacon_int_min_gcd with IBSS
> [PATCH] cfg80211: support virtual interfaces with different beacon
> intervals
> [PATCH] cfg80211: validate beacon int as part of iface combinations
> 
> Any suggestion that we could solve this.

Interesting. Did hardware actually support this, and if so, what did it
do?

If that worked, then it'd be reasonable to add the appropriate value to
the interface combinations to let it work as before.

If it didn't really work properly, then we can just fix the defaults to
be compatible?

johannes

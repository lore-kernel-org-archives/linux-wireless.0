Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55470 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751283AbdITRvu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 13:51:50 -0400
Message-ID: <1505929904.3026.17.camel@sipsolutions.net> (sfid-20170920_195154_752397_2378F52A)
Subject: Re: mac80211: avoid allocating TXQs that won't be used
From: Johannes Berg <johannes@sipsolutions.net>
To: Colin Ian King <colin.king@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Wed, 20 Sep 2017 19:51:44 +0200
In-Reply-To: <3592b0b1-0455-ca9a-9ca7-702d7cf421ff@canonical.com>
References: <3592b0b1-0455-ca9a-9ca7-702d7cf421ff@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-09-20 at 17:08 +0100, Colin Ian King wrote:
> Johannes,
> 
> Static analysis with CoverityScan on linux-next today detected a null
> pointer dereference issue on commit:
> 
> From 0fc4b3403d215ecd3c05505ec1f0028a227ed319 Mon Sep 17 00:00:00
> 2001
> From: Johannes Berg <johannes.berg@intel.com>
> Date: Thu, 22 Jun 2017 12:20:29 +0200
> Subject: [PATCH] mac80211: avoid allocating TXQs that won't be used
> 
> Issue: sdata is null when the sdata is dereferenced by:
> 
>                    sdata->vif.type != NL80211_IFTYPE_AP_VLAN &&
>                    sdata->vif.type != NL80211_IFTYPE_MONITOR)
> 
> note that sdata is assigned a non-null much later with the statement
> sdata = netdev_priv(ndev).

Yeah, umm, that should be checking just 'type'. Thanks, will fix.

johannes

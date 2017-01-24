Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48736 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750734AbdAXJo0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 04:44:26 -0500
Message-ID: <1485251062.7244.10.camel@sipsolutions.net> (sfid-20170124_104430_394423_B7B3CE05)
Subject: Re: [PATCH v2 3/4] cfg80211: Accept multiple RSSI thresholds for CQM
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 24 Jan 2017 10:44:22 +0100
In-Reply-To: <CAOq732JhLoeMQSwadM=ReBv7gAy9zb1uQ9RZAzEtvyDo7je+ww@mail.gmail.com> (sfid-20170107_104335_299116_3D4EAE6E)
References: <20161212015213.21323-2-andrew.zaborowski@intel.com>
         <20161212015213.21323-3-andrew.zaborowski@intel.com>
         <1483545210.7312.17.camel@sipsolutions.net>
         <CAOq732JfxTx7KrPhic+2aej0ddj6igaqjcGzg+9MJ6=zDYfWAw@mail.gmail.com>
         <1483616947.4394.10.camel@sipsolutions.net>
         <CAOq732JhLoeMQSwadM=ReBv7gAy9zb1uQ9RZAzEtvyDo7je+ww@mail.gmail.com>
         (sfid-20170107_104335_299116_3D4EAE6E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-01-07 at 04:43 -0500, Andrew Zaborowski wrote:

> With the basic mac80211 implementation in my patch 4/4 this feature
> should be set when IEEE80211_VIF_BEACON_FILTER is not set.  The
> problem with a nl80211_ext_feature is that it's per wiphy instead of
> per interface.  So in the case mac80211, it would need to be set if
> all interfaces can accept lists of thresholds and that can change
> dynamically as interfaces are added.  And nl80211 has no per-
> interface features.

Right - it doesn't even have that concept, and I'm not sure that really
makes sense.

> I wonder if it's better to add a ieee80211_hw_flags flag to advertise
> this feature per wiphy, or, as an approximation, set the flag based
> on the default interface that is created in ieee80211_register_hw.

I think we should just leave the new flag up to the driver then. The
only driver using per-interface beacon filtering (iwlwifi, afaik) will
either need to convert to actually handle it in the beacon filtering
case (which is the normal case anyway).

johannes

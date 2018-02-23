Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55658 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbeBWLcN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 06:32:13 -0500
Message-ID: <1519385531.2231.12.camel@sipsolutions.net> (sfid-20180223_123217_507226_8B028C2C)
Subject: Re: [PATCH v2] cfg80211/nl80211: add DFS offload flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>,
        Dmitry Lebed <lebed.dmitry@gmail.com>
Date: Fri, 23 Feb 2018 12:32:11 +0100
In-Reply-To: <20180222091513.25456-1-sergey.matyukevich.os@quantenna.com>
References: <20180222091513.25456-1-sergey.matyukevich.os@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-02-22 at 12:15 +0300, Sergey Matyukevich wrote:
> From: Dmitry Lebed <dlebed@quantenna.com>
> 
> Add wiphy EXT_FEATURE flag to indicate that HW or driver does
> all DFS actions by itself.
> User-space functionality already implemented in hostapd using
> vendor-specific (QCA) OUI to advertise DFS offload support.
> Need to introduce generic flag to inform about DFS offload support.
> For deivces with DFS_OFFLOAD flag set user-space will no longer
> need to issue CAC or do any actions in response to
> "radar detected" events. HW will do everything by itself and send
> events to user-space to indicate that CAC was started/finished, etc.
> 
> + * @NL80211_EXT_FEATURE_DFS_OFFLOAD: HW/driver will offload DFS actions.
> + *	Device or driver will do all DFS-related actions by itself,
> + *	informing user-space about CAC progress, radar detection event,
> + *	channel change triggered by radar detection event.
> + *	No need to start CAC from user-space, no need to react to
> + *	"radar detected" event.

The "channel change" part bothers me a bit - isn't normally hostapd
very much in control of the channel? How does it even get notified of
the new channel? How can you configure the parameters like how many
beacons to include the (E)CSA IE for, and whether to add ECSA or not
etc?

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0064.outbound.protection.outlook.com ([104.47.38.64]:4699
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965940AbeCAIqq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 03:46:46 -0500
Date: Thu, 1 Mar 2018 11:46:25 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>,
        Dmitry Lebed <lebed.dmitry@gmail.com>
Subject: Re: [PATCH v2] cfg80211/nl80211: add DFS offload flag
Message-ID: <20180301084619.noxh64db73lrklwp@bars> (sfid-20180301_094709_579746_D8D15532)
References: <20180222091513.25456-1-sergey.matyukevich.os@quantenna.com>
 <1519385531.2231.12.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1519385531.2231.12.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello Johannes,

> > Add wiphy EXT_FEATURE flag to indicate that HW or driver does
> > all DFS actions by itself.
> > User-space functionality already implemented in hostapd using
> > vendor-specific (QCA) OUI to advertise DFS offload support.
> > Need to introduce generic flag to inform about DFS offload support.
> > For deivces with DFS_OFFLOAD flag set user-space will no longer
> > need to issue CAC or do any actions in response to
> > "radar detected" events. HW will do everything by itself and send
> > events to user-space to indicate that CAC was started/finished, etc.
> >
> > + * @NL80211_EXT_FEATURE_DFS_OFFLOAD: HW/driver will offload DFS actions.
> > + *   Device or driver will do all DFS-related actions by itself,
> > + *   informing user-space about CAC progress, radar detection event,
> > + *   channel change triggered by radar detection event.
> > + *   No need to start CAC from user-space, no need to react to
> > + *   "radar detected" event.
> 
> The "channel change" part bothers me a bit - isn't normally hostapd
> very much in control of the channel? How does it even get notified of
> the new channel? How can you configure the parameters like how many
> beacons to include the (E)CSA IE for, and whether to add ECSA or not
> etc?

We are about to send v3 for this feature. Could you please clarify
your preferences in terms of patchwork procedure ? Should we mark
previous patch versions as superseded for nl80211/cfg80211 patches ?

Regards,
Sergey

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53362 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750897AbdAXPSW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jan 2017 10:18:22 -0500
Message-ID: <1485271099.1236.3.camel@sipsolutions.net> (sfid-20170124_161825_929294_B25FA18A)
Subject: Re: [PATCH v3 4/4] mac80211: Add set_cqm_rssi_range_config
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 24 Jan 2017 16:18:19 +0100
In-Reply-To: <20170120085509.13222-4-andrew.zaborowski@intel.com> (sfid-20170120_095528_786571_157085EA)
References: <20170120085509.13222-1-andrew.zaborowski@intel.com>
         <20170120085509.13222-4-andrew.zaborowski@intel.com>
         (sfid-20170120_095528_786571_157085EA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-01-20 at 09:55 +0100, Andrew Zaborowski wrote:
> Support .set_cqm_rssi_range_config if the beacons are available for
> processing in mac80211.  There's no reason that this couldn't be
> offloaded by mac80211-based drivers but there's no driver method for
> that added in this patch as I don't have the hardware.

I thought you only required now that the level was given or something
like that, so most HW should support it?

> The NL80211_EXT_FEATURE_CQM_RSSI_LIST feature is automatically set
> during ieee80211_register_hw if the default interface being created
> doesn't indicate beacon filtering enabled.  For drivers that don't
> want a default interface but want to support this feature the flag
> needs to be set explicitly in the driver.
> 
> Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
> ---
> changes in v3:
>  - set NL80211_EXT_FEATURE_CQM_RSSI_LIST automatically in
>    ieee80211_register_hw based on the default interface's
>    IEEE80211_VIF_BEACON_FILTER flag.  This is a bit of an RFC as I'm
>    not sure how practical it is for a driver to allow creation of
>    additional interfaces that also implement CQM, but which filter
>    beacons in the firmware.  In any case userspace would only
>    receive EOPNOTSUPP on those addiitonal interfaces when trying to
>    use the feature.

That can't possibly work, since the flag can't be set by a driver at
this point - the interface isn't brought up yet, so the driver knows
nothing about it.

Therefore, you'd always set the flag (in a convoluted way) and be wrong
about it if filtering is actually done.

johannes

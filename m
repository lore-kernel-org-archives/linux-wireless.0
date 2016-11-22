Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41332 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754413AbcKVNRL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 08:17:11 -0500
Message-ID: <1479820627.2517.53.camel@coelho.fi> (sfid-20161122_141714_362786_F9BF1BF0)
From: Luca Coelho <luca@coelho.fi>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 22 Nov 2016 15:17:07 +0200
In-Reply-To: <9fa76f2c-44b2-9782-8636-09afd1d59927@broadcom.com>
References: <1479810126-28492-1-git-send-email-arend.vanspriel@broadcom.com>
         <9fa76f2c-44b2-9782-8636-09afd1d59927@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] nl80211: change validation of scheduled scan interval
 values
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-11-22 at 14:12 +0100, Arend Van Spriel wrote:
> On 22-11-2016 11:22, Arend van Spriel wrote:
> > When user-space does not provide scheduled scan plans, ie. uses the
> > old scheduled scan API containing NL80211_ATTR_SCHED_SCAN_INTERVAL.
> > The interval value passed by user-space is validated against
> > struct wiphy::max_sched_scan_plan_interval and if it is exceeding
> > it the interval is set to struct wiphy::max_sched_scan_plan_interval.
> > However, when the driver does not set this limit the interval the
> > interval in the request will always be zero. Hence add a check to
> > see whether the driver set struct wiphy::max_sched_scan_plan_interval.
> > 
> > For the new API, ie. for scheduled scan plans, the interval validation
> > has been simalarly adjusted to assure the limit is non-zero.
> 
> Actually turns out that max_sched_scan_plan_interval is always set in
> wiphy_new_nm() which is used by all drivers so please drop this patch.

Right, I mixed mac80211 into the picture and got confused.

--
Luca.

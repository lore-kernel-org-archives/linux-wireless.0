Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:43994 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753242AbdLAOtE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 09:49:04 -0500
Message-ID: <1512139742.25588.14.camel@sipsolutions.net> (sfid-20171201_154932_562625_287DC8AA)
Subject: Re: Setting TX power on a monitoring interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter =?ISO-8859-1?Q?Gro=DFe?= <pegro@friiks.de>,
        linux-wireless@vger.kernel.org
Date: Fri, 01 Dec 2017 15:49:02 +0100
In-Reply-To: <20171127160722.4969cd23@friiks.de> (sfid-20171127_160737_710701_E5B0F542)
References: <20171120173415.1ae44829@fem-net.de>
         <1511782993.5456.6.camel@sipsolutions.net>
         <20171127160722.4969cd23@friiks.de> (sfid-20171127_160737_710701_E5B0F542)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-11-27 at 16:07 +0100, Peter Große wrote:

> > I think if the driver has WANT_MONITOR_VIF, then we can pass that
> > through and let the driver sort it out.
> > 
> > But if not, we probably just have to reject the configuration?
> 
> With passing through you mean calling bss_info_changed on the driver for the
> monitor interface?

I meant to pass the &monitor_sdata.vif pointer instead of the real
monitor interface that's coming through cfg80211. The former is virtual
and has no netdev, but the diver is aware of it.

> Are monitor interfaces allowed to exist when WANT_MONITOR_VIF is not set?

Yes

> I ask, whether I would have to check 
>   sdata->vif.type == NL80211_IFTYPE_MONITOR
> _and_ also
>   ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF)

You can check that

	local->monitor_sdata

exists, and use it if yes, and reject if no.

johannes

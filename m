Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44652 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755430AbdJKICb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 04:02:31 -0400
Message-ID: <1507708948.1998.15.camel@sipsolutions.net> (sfid-20171011_100440_048918_C443C234)
Subject: Re: Setting single rate in ath10k broken by "reject/clear user rate
 mask if not usable"
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, kirtika@google.com,
        Johannes Berg <johannes.berg@intel.com>
Date: Wed, 11 Oct 2017 10:02:28 +0200
In-Reply-To: <13895fa0-3685-dd2b-583d-2d6469d23cfe@candelatech.com> (sfid-20171010_225427_620459_2849A16B)
References: <13895fa0-3685-dd2b-583d-2d6469d23cfe@candelatech.com>
         (sfid-20171010_225427_620459_2849A16B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> #iw dev vap206 set bitrates legacy-5 ht-mcs-5 0 vht-mcs-5
> command failed: Invalid argument (-22)
> 
> But, it actually *does* successfully set the rate in the driver
> first, which is confusing at best.

Huh?

> So, I think we should relax this check, at least for ath10k.

Well, yes and no. I don't think we should make ath10k special here, and
this fixes a real problem - namely that you can set up the system so
that you have no usable rates at all, and then you just get a WARN_ON
and start using the lowest possible rate...

> commit e8e4f5280ddd0a7b43a795f90a0758e3c99df6a6
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Wed Mar 8 11:12:10 2017 +0100
> 
>      mac80211: reject/clear user rate mask if not usable
> 
>      If the user rate mask results in no (basic) rates being usable,
>      clear it. Also, if we're already operating when it's set, reject
>      it instead.
> 
>      Technically, selecting basic rates as the criterion is a bit too
>      restrictive, but calculating the usable rates over all stations
>      (e.g. in AP mode) is harder, and all stations must support the
>      basic rates. Similarly, in client mode, the basic rates will be
>      used anyway for control frames.

I guess you could implement this part? I.e. iterating the clients and
checking that they all support the rate that is set. However, then you
also need to implement that this gets reset when a new client that
doesn't support this rate connects.

Overall, this isn't very well defined for AP mode...

Perhaps it'd be better - as you pointed out in the other thread - to
have API to force a rate per station? We already have that for iwlwifi
in debugfs, so perhaps that'd be something to consider for this too,
I'm not sure there would be a real need to have it in nl80211?

johannes

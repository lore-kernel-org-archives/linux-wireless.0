Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60828 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755365AbcJUM2E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 08:28:04 -0400
Message-ID: <1477052876.4068.40.camel@sipsolutions.net> (sfid-20161021_142809_034368_11DCF814)
Subject: Re: [PATCH v3] cfg80211: Check radar_detect and
 num_different_channels with beacon interface combinations.
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        usdutt@qti.qualcomm.com, amarnath@qca.qualcomm.com
Date: Fri, 21 Oct 2016 14:27:56 +0200
In-Reply-To: <1476371730-23027-1-git-send-email-pkushwah@qti.qualcomm.com>
References: <1476371730-23027-1-git-send-email-pkushwah@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-10-13 at 20:45 +0530, Purushottam Kushwaha wrote:
> This commit enhances the current beacon interval validation to also
> consider
> the "radar_detect" and "num_different_channels".
> 
> Move calculation of GCD for all beaconing interfaces to
> "cfg80211_iter_combinations".
> 
> Rename "cfg80211_validate_beacon_int" to
> "cfg80211_validate_beacon_combination"
> as the validation considers other parameters.

So this was better, but I think we're mixing too many things in here.

I'm not convinced, for example, that checking if radar is required is
really the right thing, it might still be enabled even if it's not
required (any more, regulatory may change)?

Not that I don't think that's a worthwhile goal - moving more of the
data/calculation back into cfg80211 - but I don't think it should be
mixed in here.

I've just sent out a few patches that, I think, implement the necessary
validation for just the beacon intervals, without all this extra
baggage. Please take a look and let me know what you think.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60228 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933196AbdJJUyV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 16:54:21 -0400
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, kirtika@google.com,
        Johannes Berg <johannes.berg@intel.com>
From: Ben Greear <greearb@candelatech.com>
Subject: Setting single rate in ath10k broken by "reject/clear user rate mask
 if not usable"
Message-ID: <13895fa0-3685-dd2b-583d-2d6469d23cfe@candelatech.com> (sfid-20171010_225427_620459_2849A16B)
Date: Tue, 10 Oct 2017 13:54:20 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At one point, you could set a single rate using 'iw' and
ath10k would convert that to a special firmware API that
fixed all data traffic to a particular rate set.  (Management
frames and broadcast will not be affected by setting the rates
when using ath10k).

But, with the commit below, a command like this will fail:

#iw dev vap206 set bitrates legacy-5 ht-mcs-5 0 vht-mcs-5
command failed: Invalid argument (-22)

But, it actually *does* successfully set the rate in the driver first, which
is confusing at best.

So, I think we should relax this check, at least for ath10k.

commit e8e4f5280ddd0a7b43a795f90a0758e3c99df6a6
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed Mar 8 11:12:10 2017 +0100

     mac80211: reject/clear user rate mask if not usable

     If the user rate mask results in no (basic) rates being usable,
     clear it. Also, if we're already operating when it's set, reject
     it instead.

     Technically, selecting basic rates as the criterion is a bit too
     restrictive, but calculating the usable rates over all stations
     (e.g. in AP mode) is harder, and all stations must support the
     basic rates. Similarly, in client mode, the basic rates will be
     used anyway for control frames.

     This fixes the "no supported rates (...) in rate_mask ..." warning
     that occurs on TX when you've selected a rate mask that's not
     compatible with the connection (e.g. an AP that enables only the
     rates 36, 48, 54 and you've selected only 6, 9, 12.)

     Reported-by: Kirtika Ruchandani <kirtika@google.com>
     Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50583 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755070AbcJMMmn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 08:42:43 -0400
Message-ID: <1476362558.4904.23.camel@sipsolutions.net> (sfid-20161013_144310_413331_B9210563)
Subject: Re: [PATCH v2] cfg80211: Check radar_detect and
 num_different_channels with beacon interface combinations.
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        usdutt@qti.qualcomm.com, amarnath@qca.qualcomm.com
Date: Thu, 13 Oct 2016 14:42:38 +0200
In-Reply-To: <1476277034-6972-1-git-send-email-pkushwah@qti.qualcomm.com>
References: <1476277034-6972-1-git-send-email-pkushwah@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-10-12 at 18:27 +0530, Purushottam Kushwaha wrote:
> This commit enhances the current beacon interval validation to also
> consider the "radar_detect" and "num_different_channels".
> 
> Rename "cfg80211_validate_beacon_int" to
> "cfg80211_validate_beacon_combination"
> as the validation considers other parameters.

Looking at this more closely, I think it's correct, but incomplete.

Consider a case like the following:

interface combinations:
(1) AP=3, beacon_int_gcd=50
(2) AP=2, station=1, beacon_int_gcd=0

AP interfaces A and B are both active, with beacon intervals of 100 and
150 respectively. So far, this is not a problem, falling into the
interface combination (1).

Now, somebody wants to add a station interface, and brings it up.
Because the validation thereof doesn't take the beacon intervals into
account at all, this would be accepted as falling into the interface
combination (2), but is actually incorrect due to the differing beacon
intervals.

As a consequence, I think we need to factor out the beacon interval
information building from cfg80211_validate_beacon_int() as it is right
now (with your other two patches applied), and also apply it when we
call cfg80211_iter_combinations() so that the case above gets verified.

This patch is probably a step in the right direction, but given the
situation above I don't think it's complete.

johannes

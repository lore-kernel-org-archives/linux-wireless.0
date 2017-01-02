Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40084 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933271AbdABOdd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 09:33:33 -0500
Message-ID: <1483367607.21014.9.camel@sipsolutions.net> (sfid-20170102_153340_754932_2E2A853E)
Subject: Re: [PATCH] cfg80211: Random local address for Public Action frame
 exchange
From: Johannes Berg <johannes@sipsolutions.net>
To: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>,
        jouni@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, vamsin@qti.qualcomm.com
Date: Mon, 02 Jan 2017 15:33:27 +0100
In-Reply-To: <c7eaea82-a5be-d047-c67a-ce9e58b4b65f@quantenna.com>
References: <1482266379-9723-1-git-send-email-jouni@qca.qualcomm.com>
         <cf228384-c98e-737e-3ba6-6c18e988210c@quantenna.com>
         <1483356523.4596.12.camel@sipsolutions.net>
         <c7eaea82-a5be-d047-c67a-ce9e58b4b65f@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Acknowledgment is done for transmitter<->receiver addresses,
> not for source<->destination?

Well, these are management frames, there either are no SA/DA or they're
identical to RA/TA, depending on how you want to look at it. Typically
it does get called SA/DA too then.

> Patch talks about source address randomization, but I guess it
> actually
>   meant transmitter address (basically dynamic BSSID config?). Maybe
> naming should be changed in the patch.

Yes, I suppose TA might be a tad more accurate.

BSSID is another (unrelated) address.

> For NL80211_EXT_FEATURE_MGMT_TX_RANDOM_SA_CONNECTED case,
> I wonder if HW can be configured to not filter-out multiple BSSIDs
> or 
> the idea
> is that while random_sa frame is pending for ACK, HW will drop all 
> frames destined
> for initially configured BSSID?

Again, BSSID is unrelated (unless you're restricting yourself to the AP
STA case where BSSID == local MAC address).

And no, traffic would not be permitted to be dropped in this case, IMO

johannes

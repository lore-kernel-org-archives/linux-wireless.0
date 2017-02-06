Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41210 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751154AbdBFOic (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 09:38:32 -0500
Message-ID: <1486391893.5430.6.camel@sipsolutions.net> (sfid-20170206_153946_062767_75AF50A9)
Subject: Re: [PATCH v2 1/2] cfg80211: Add support to set tx power for a
 station associated
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>
Cc: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Mon, 06 Feb 2017 15:38:13 +0100
In-Reply-To: <00887d68-80b7-cf80-e426-e3772d8122f1@candelatech.com>
References: <1485888101-23454-1-git-send-email-arnagara@qti.qualcomm.com>
         <12efc3d8-2274-a6e8-6d74-c06bf89762fb@candelatech.com>
         <14f6b3acb8b26d0eb806148c0ee47fb0@codeaurora.org>
         <2b68dc12-44bf-f510-339a-3d987a88e8b5@candelatech.com>
         <1f3a3dec67fbe4f580750eb06f9b628b@codeaurora.org>
         <00887d68-80b7-cf80-e426-e3772d8122f1@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> You use value '0' to mean set to default values, as far as I can
> tell.

I think you're confusing the internal API and the userspace API - at a
userspace level you have to set NL80211_ATTR_STA_TX_POWER_SETTING to
NL80211_TX_POWER_AUTOMATIC to revert back to defaults, no?

For perfect backwards compatibility we should ignore it if not
supported, but that doesn't really make sense - I think we should
reject it and handle errors elsewhere in the not supported case.

johannes

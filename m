Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39292 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758598AbdAIKgg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 05:36:36 -0500
Message-ID: <1483958190.17582.15.camel@sipsolutions.net> (sfid-20170109_113702_739278_26A66746)
Subject: Re: [PATCH 2/4] cfg80211: Add new NL80211_CMD_SET_BTCOEX_PRIORITY
 to support BTCOEX
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhchelvam@codeaurora.org>
Cc: c_traja@qti.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Date: Mon, 09 Jan 2017 11:36:30 +0100
In-Reply-To: <6f9711ed6f6fe170b915b67a054b985b@codeaurora.org>
References: <1478610932-21954-1-git-send-email-c_traja@qti.qualcomm.com>
         <1478610932-21954-3-git-send-email-c_traja@qti.qualcomm.com>
         <1480949353.31788.27.camel@sipsolutions.net>
         <5e5e8971c96293a81e7cb37bcdfbd593@codeaurora.org>
         <1481645351.20412.34.camel@sipsolutions.net>
         <134cc8e58ecb804b6dda0137c4c37be8@codeaurora.org>
         <1481881024.27953.14.camel@sipsolutions.net>
         <ae82112880d55451342e7a6e5a47c33f@codeaurora.org>
         <1483354130.4596.5.camel@sipsolutions.net>
         <a5521b4e246de90ed8526891c84a97e5@codeaurora.org>
         <1483623500.4394.18.camel@sipsolutions.net>
         <6f9711ed6f6fe170b915b67a054b985b@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Is it fine to have something like this
> 
> 1) We can have this btcoex_priority value as a optional value in
> btcoex enable command like below
> 
> iw phyX btcoex_state <enable| disable> [prirority(vendor spcific
> value)]
> 
> 2) Or we can have seperate command for btcoex_priority as below
> 
> iw phyX set btcoex_priority <priority (vendor spcific value)>
> 
> Hopefully this will get rid off all the nl80211 bits.

That makes no sense.

If the bits are vendor specific, then there's no value in having this
as an nl80211 command (rather than a vendor command) to start with.

You need to understand that I'm differentiating between *capability*
bits and actual *priority setting* bits - please re-read the thread
with that in mind.

johannes

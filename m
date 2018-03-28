Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46344 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750820AbeC1IEE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 04:04:04 -0400
Message-ID: <1522224241.4222.1.camel@sipsolutions.net> (sfid-20180328_100410_043875_3366D4D9)
Subject: Re: [RFC 3/4] mac80211: Apply per-peer NoAck tid bitmap
 configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: vthiagar@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Date: Wed, 28 Mar 2018 10:04:01 +0200
In-Reply-To: <55759171b924fb2075fe189d3d149e28@codeaurora.org>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
         <1522140171-10926-4-git-send-email-vthiagar@codeaurora.org>
         <1522155253.3050.8.camel@sipsolutions.net>
         <55759171b924fb2075fe189d3d149e28@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I think 0 as the Noack configuration from user can also be a valid one 
> in the case
> where user does not want any NoAck policy to be used for a particular 
> station even
> when a non-zero NoAck configuration is set for ndev level. In this case, 
> the logic
> may need to be modified so that the default non-zero configuration 
> (something like -1)
> could be used to determine that the station has been never configured 
> with any NoAck
> policy and use ndev level configuration. Does this sound reasonable?

Yes. You'll have to use int instead of u16 I guess, but that's
completely doable.

johannes

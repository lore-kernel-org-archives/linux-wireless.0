Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39356 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755817AbcIAVBx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 17:01:53 -0400
Message-ID: <1472756034.9608.15.camel@sipsolutions.net> (sfid-20160901_230156_674928_0D4E91D8)
Subject: Re: Ath10k probe response error related to mac80211 commit.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 01 Sep 2016 20:53:54 +0200
In-Reply-To: <c7eb32b4-84c5-41ae-1fe6-89df7cbbe7d4@candelatech.com>
References: <cf9852df-6d14-baf6-af0a-9cc78c448fde@candelatech.com>
         <1472752911.9608.11.camel@sipsolutions.net>
         <c7eb32b4-84c5-41ae-1fe6-89df7cbbe7d4@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-09-01 at 11:23 -0700, Ben Greear wrote:
> 
> Could easily be that others are corrupted too, but since probe resp
> is bad, the association will not proceed.

makes sense.

> Heh, I spent 4 days tracking this down, so I wanted to be precise in
> my bug report :)

Ahrg, ouch. Sorry about that. I really didn't think the flag would
cause any issues for anyone.

> The result I see is that there is an extra 10 bytes at the end of the
> frame on air.  But, it looks like the exact same pkt is sent to the
> firmware both with and without this patch.  Maybe the firmware is
> using the wrong tid or something like that due to how the station is
> created differently with this patch.

That makes no sense though, unless this only happens on say the second
station that connects? Until the first station sends an authentication
frame, that patch really should have no impact whatsoever.

johannes

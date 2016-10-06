Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54648 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752864AbcJFLgg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Oct 2016 07:36:36 -0400
Message-ID: <1475753787.2015.13.camel@sipsolutions.net> (sfid-20161006_133639_850419_EC5DAD6F)
Subject: Re: [PATCHv4] mac80211: check A-MSDU inner frame source address on
 AP interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: michael-dev <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Date: Thu, 06 Oct 2016 13:36:27 +0200
In-Reply-To: <bb2ea10f30d2ae8a3cc048974ed148c8@fami-braun.de>
References: <1475661751-26262-1-git-send-email-michael-dev@fami-braun.de>
         <1475679558.5257.7.camel@sipsolutions.net>
         <bb2ea10f30d2ae8a3cc048974ed148c8@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The rules when to check sa/da should be independent of the driver
> and  thus would likely be duplicated by each caller. This is why I
> had it in ieee80211_amsdu_to_8023s.

That does make sense, I guess. But I feel that it's overly complicated,
and most drivers don't actually support all those features, in
particular, 4-addr station/AP is currently exclusive to mac80211.

> My patch defaulted into not checking sa/da for interface type not 
> explicitly given, whereas your code defaults to checking both for
> those.
> This makes a difference for IFTYPE_MONITOR, IFTYPE_P2P_*, 

Monitor will never get there, and P2P_CLIENT == STATION, P2P_GO == AP
as far as mac80211's vif.type is concerned, so those are handled.

> IFTYPE_OCB, 

That can't do A-MSDU I believe.

> IFTYPE_UNSPECIFIED, 

That is invalid and can never happen here.

> IFTYPE_WDS. 

This is ... it can't even negotiate HT, so I doubt A-MSDU could be used
in any way. This is old crap, and I'd actually rather remove it, the 4-
addr station/AP superseded it.

> I don't know if filtering is appropiate 
> for those or if they can actually occur there.

I think it's all covered then.

Could you test my patches in your scenario to see they do what we want?
I'll resend as [PATCH] then, and think about applying them and perhaps
backporting also.

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36616 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751710AbeAOMWh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 07:22:37 -0500
Message-ID: <1516018955.410.21.camel@sipsolutions.net> (sfid-20180115_132240_640967_B8034E41)
Subject: Re: [PATCH v2 1/3] cfg80211/nl80211: Optional authentication
 offload to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Srinivas Dasari <dasaris@qti.qualcomm.com>
Date: Mon, 15 Jan 2018 13:22:35 +0100
In-Reply-To: <c2554a26-bbbc-3bd2-0091-06fc14e88946@gmail.com> (sfid-20180104_215955_609727_80A46600)
References: <1513960419-24780-1-git-send-email-jouni@qca.qualcomm.com>
         <c2554a26-bbbc-3bd2-0091-06fc14e88946@gmail.com>
         (sfid-20180104_215955_609727_80A46600)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-01-04 at 14:59 -0600, Denis Kenzior wrote:

> So this implies userspace must pre-register for authentication 
> management frames, correct?  And other applications could register to 
> receive these frames as well?  Would it not be easier (and more secure) 
> to simply forward these directly to the application that triggered 
> CMD_CONNECT instead?

Only one will be able to register, so I think it's OK. We could even
check that it's registered already at CONNECT time, I guess.

> > +	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
> > +				NL80211_MCGRP_MLME, gfp);
> 
> Is there a reason this is being multicast and not unicast to the 
> application that triggered the CONNECT?  Who else besides the supplicant 
> daemon might find this information useful?

That's a good point, we should send this to the CONNECT owner (and thus
obviously also require that there is one).

johannes

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0079.outbound.protection.outlook.com ([104.47.36.79]:23632
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758264AbdLSKmu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 05:42:50 -0500
Date: Tue, 19 Dec 2017 13:42:34 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 10/10] qtnfmac: support MAC address based access control
Message-ID: <20171219104233.wcyemlr3gp4rq5ae@bars> (sfid-20171219_114307_155498_7D1AAE24)
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
 <20171113102815.11254-11-sergey.matyukevich.os@quantenna.com>
 <871skalepz.fsf@purkki.adurom.net>
 <20171205160010.cytra3bqbttwz5db@bars>
 <878te0kud2.fsf@kamboji.qca.qualcomm.com>
 <20171218161811.3f3sjhlxdfmsnljx@bars>
 <1513676321.26145.1.camel@sipsolutions.net>
 <20171219102932.xv7bxasvlvguy7jb@bars>
 <1513679705.26145.13.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1513679705.26145.13.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

> > I guess it should be possible to do some kind of source address filtering
> > in hardware. But it looks like your question is whether it makes sense
> > or not. Probably not, I have no idea.
> 
> Either way, I see no reason to support it if nobody has a driver for it
> :)
> 
> > By the way, what do you think about making MAC-based ACL capability the
> > first bit in enum nl80211_ap_sme_features ?
> 
> No issues with that; I thought we already had some ACL feature bit
> though?

Not yet. At the moment enum nl80211_ap_sme_features in uapi/linux/nl80211.h
is commented out. For MAC-based ACL the following things are being checked
on wiphy registration: complete flag WIPHY_FLAG_HAVE_AP_SME, non-zero
max_acl_mac_addrs, and set_mac_acl cfg80211 callback.

I will send an RFC patch, lets see how it is going to look like...

Regards,
Sergey

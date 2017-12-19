Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0063.outbound.protection.outlook.com ([104.47.38.63]:25040
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751462AbdLSLTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 06:19:34 -0500
Date: Tue, 19 Dec 2017 14:19:20 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 10/10] qtnfmac: support MAC address based access control
Message-ID: <20171219111919.7uoupifxeizqs3x3@bars> (sfid-20171219_121940_330331_D5691F9D)
References: <20171113102815.11254-11-sergey.matyukevich.os@quantenna.com>
 <871skalepz.fsf@purkki.adurom.net>
 <20171205160010.cytra3bqbttwz5db@bars>
 <878te0kud2.fsf@kamboji.qca.qualcomm.com>
 <20171218161811.3f3sjhlxdfmsnljx@bars>
 <1513676321.26145.1.camel@sipsolutions.net>
 <20171219102932.xv7bxasvlvguy7jb@bars>
 <1513679705.26145.13.camel@sipsolutions.net>
 <20171219104233.wcyemlr3gp4rq5ae@bars>
 <1513681186.26145.14.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1513681186.26145.14.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Not yet. At the moment enum nl80211_ap_sme_features in uapi/linux/nl80211.h
> > is commented out. For MAC-based ACL the following things are being checked
> > on wiphy registration: complete flag WIPHY_FLAG_HAVE_AP_SME, non-zero
> > max_acl_mac_addrs, and set_mac_acl cfg80211 callback.
> 
> I guess that's enough then? Userspace can check max_acl_mac_addrs as
> well, so it can just use that?

Correct, that is what hostapd is doing. I was simply surprised by the fact
that MAC-based ACL support implies full-fledged AP SME support. Though
your almost convinced me that this is ok and other wireless cards simply
do not exist.

Regards,
Sergey

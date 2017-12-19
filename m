Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41950 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdLSQ6u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 11:58:50 -0500
Message-ID: <1513702727.26145.17.camel@sipsolutions.net> (sfid-20171219_175944_632612_B6948A05)
Subject: Re: [PATCH 10/10] qtnfmac: support MAC address based access control
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Tue, 19 Dec 2017 17:58:47 +0100
In-Reply-To: <5A390813.40400@broadcom.com> (sfid-20171219_133742_396000_3393D974)
References: <20171113102815.11254-11-sergey.matyukevich.os@quantenna.com>
         <871skalepz.fsf@purkki.adurom.net> <20171205160010.cytra3bqbttwz5db@bars>
         <878te0kud2.fsf@kamboji.qca.qualcomm.com>
         <20171218161811.3f3sjhlxdfmsnljx@bars>
         <1513676321.26145.1.camel@sipsolutions.net>
         <20171219102932.xv7bxasvlvguy7jb@bars>
         <1513679705.26145.13.camel@sipsolutions.net>
         <20171219104233.wcyemlr3gp4rq5ae@bars>
         <1513681186.26145.14.camel@sipsolutions.net>
         <20171219111919.7uoupifxeizqs3x3@bars> <5A390813.40400@broadcom.com>
         (sfid-20171219_133742_396000_3393D974)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-12-19 at 13:37 +0100, Arend van Spriel wrote:
> On 12/19/2017 12:19 PM, Sergey Matyukevich wrote:
> > > > Not yet. At the moment enum nl80211_ap_sme_features in uapi/linux/nl80211.h
> > > > is commented out. For MAC-based ACL the following things are being checked
> > > > on wiphy registration: complete flag WIPHY_FLAG_HAVE_AP_SME, non-zero
> > > > max_acl_mac_addrs, and set_mac_acl cfg80211 callback.
> > > 
> > > I guess that's enough then? Userspace can check max_acl_mac_addrs as
> > > well, so it can just use that?
> > 
> > Correct, that is what hostapd is doing. I was simply surprised by the fact
> > that MAC-based ACL support implies full-fledged AP SME support. Though
> > your almost convinced me that this is ok and other wireless cards simply
> > do not exist.
> 
> So the question seems to be here: what shall drivers/firmware implement 
> to allow flag WIPHY_FLAG_HAVE_AP_SME being set. The kerneldoc is a bit 
> short in providing guidance:
> 
>   * @WIPHY_FLAG_HAVE_AP_SME: device integrates AP SME

They should implement the AP SME? :)

That is, handling auth/assoc/etc.

With the SAE-"offload"-to-host those lines are blurring again though.

johannes

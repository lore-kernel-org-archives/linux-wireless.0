Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0068.outbound.protection.outlook.com ([104.47.33.68]:55427
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751333AbdF2Qne (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 12:43:34 -0400
Date: Thu, 29 Jun 2017 19:43:03 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 1/8] qtnfmac: updates and fixes for regulatory support
Message-ID: <20170629164300.oljhwccy7eqogau4@bars> (sfid-20170629_184339_432634_06D2C705)
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
 <20170620195517.18373-2-sergey.matyukevich.os@quantenna.com>
 <87wp7x4aah.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87wp7x4aah.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
> 
> > This patch introduces several changes for regulatory support
> > in qtnfmac driver:
> >
> > * Introduce support for setting regdomain from host
> > New command is implemented to notify firmware about regdomain changes
> > performed by host. Firmware is supposed to check requested regdomain
> > changes. On success firmware enables updated hardware channel
> > configuration and then host driver updates channel info for each band.
> >
> > * Introduce support of custom regulatory rules
> > Obtain custom regulatory rules from the firmware and
> > enable them during wiphy registration
> >
> > * Regulatory for self-managed setup
> > Regdomain information needs to be registered with cfg80211
> > for devices with REGULATORY_WIPHY_SELF_MANAGED flag set.
> >
> > * Misc fixes in regulatory code paths
> >   - add missing lock in qtnf_cmd_get_mac_chan_info
> >   - do not free band channel structure if channel count is the same
> >   - free allocated regdomain hw_info.rd structure on detach
> >
> > Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> 
> Each patch should contain one logical change, but here you are listing
> multiple changes in the commit log which is a clear indication that's
> not the case here. Is there a specific reason why you did it like this?

There is no specific reason. I grouped changes into patches based on features.
For instance, this particular patch includes all the regulatory changes.
Though I agree that this particular patch can be splitted at least into
3 different self-contained patches. Will do for the v2.

Regards,
Sergey

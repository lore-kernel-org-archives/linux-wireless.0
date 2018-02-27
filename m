Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0057.outbound.protection.outlook.com ([104.47.42.57]:4592
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753292AbeB0PNw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 10:13:52 -0500
Date: Tue, 27 Feb 2018 18:13:39 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH v2 4/4] qtnfmac: enable networked standby mode on device
 inactivity
Message-ID: <20180227151339.xlvxqb7d36s4og6k@bars> (sfid-20180227_161357_385929_01968E77)
References: <20180210140420.17013-1-sergey.matyukevich.os@quantenna.com>
 <20180210140420.17013-5-sergey.matyukevich.os@quantenna.com>
 <87inaifqpt.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87inaifqpt.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
> 
> > From: Sergei Maksimenko <smaksimenko@quantenna.com>
> >
> > Enable support of networked standby mode (NSM) on qsr10g devices.
> > Networked standby is a power saving mode when the device keeps
> > all existing network connections and returns to full power mode
> > on a network activity. When enabled, device enters standby mode
> > after 15 min of inactivity (no associated stations or no trattic).
> > This period can be changed by setting sysfs attribute standby_timeout
> > (0 disables NSM support). A module parameter auto_standby
> > (defaults to 1) controls enabling NSM support on module loading.
> >
> > Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
> 
> Adding a new sysfs file for a wireless driver is usually a bad idea, I
> don't even remember when we had a case where it was ok to do that. In
> principle we want everything to go through cfg80211 using nl80211.
> 
> Also I'm not really fond of the module parameter just to disable a
> feature. And there isn't even any justification why it's needed.

Ok, noted. Then we will take a break and look for better ways to integrate
this feature. Meanwhile, if you have no concerns regarding the first three
patches in the series, is it possible to apply them ? Or I better send v3 ?

Regards,
Sergey

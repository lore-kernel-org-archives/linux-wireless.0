Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0073.outbound.protection.outlook.com ([104.47.40.73]:33559
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752066AbeFDMue (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 08:50:34 -0400
Date: Mon, 4 Jun 2018 15:50:23 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH 3/6] qtnfmac: implement cfg80211 power management callback
Message-ID: <20180604125021.pvcbnqexrkgqd72q@bars> (sfid-20180604_145039_740941_6069220D)
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
 <20180531091102.28666-4-sergey.matyukevich.os@quantenna.com>
 <0303f713-9e0d-5180-035f-ea78ffe56d67@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0303f713-9e0d-5180-035f-ea78ffe56d67@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Igor,

> > Implement set_power_mgmt() callback that forwards power saving
> > settings to the device firmware.
> > 
> > Signed-off-by: Sergei Maksimenko <smaksimenko@quantenna.com>
> > ---
> >   static void qtnf_cfg80211_reg_notifier(struct wiphy *wiphy_in,
> > @@ -922,6 +939,9 @@ struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus)
> >   	if (bus->hw_info.hw_capab & QLINK_HW_CAPAB_DFS_OFFLOAD)
> >   		qtn_cfg80211_ops.start_radar_detection = NULL;
> > +	if (!(bus->hw_info.hw_capab & QLINK_HW_CAPAB_PWR_MGMT))
> > +		qtn_cfg80211_ops.set_power_mgmt	= NULL;
> > +
> 
> I think it's better be moved somewhere out of qtnf_wiphy_allocate() as OPS
> are global for all MACs, while qtnf_wiphy_allocate() is called for each MAC
> separately.

Consider the case of splitting hardware capabilities into two groups:
global and per-wmac. In this case we may need to register different
subsets of cfg80211 operations for each wmac. In such a case, function
qtnf_wiphy_allocate looks like a reasonable point where to merge both
capability groups and customize cfg80211_ops structure for each wmac.

Regards,
Sergey

Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0054.outbound.protection.outlook.com ([104.47.33.54]:35840
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750835AbdH3IF3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 04:05:29 -0400
Date: Wed, 30 Aug 2017 11:05:16 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH 14/27] qtnfmac: do not cache CSA chandef info
Message-ID: <20170830080516.7l4kkzrxr6glfbo2@bars> (sfid-20170830_100534_316888_346D71EB)
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <20170825023024.10565-15-igor.mitsyanko.os@quantenna.com>
 <20170829154455.j2qrxcu35mwkwzcl@bars>
 <0627667f-87d7-644b-a582-27b9ce638ff9@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0627667f-87d7-644b-a582-27b9ce638ff9@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 29, 2017 at 06:48:23PM -0700, Igor Mitsyanko wrote:
> On 08/29/2017 08:44 AM, Sergey Matyukevich wrote:
> > I am ok with removal of CSA chandef info. It was kept mainly to warn
> > about channel switch to the frequency that differs from original
> > CSA request.
> > 
> > > -	if (vif->vifid != 0) {
> > > -		if (!(mac->status & QTNF_MAC_CSA_ACTIVE))
> > > -			return -EOPNOTSUPP;
> > > -
> > > -		if (!cfg80211_chandef_identical(&params->chandef,
> > > -						&mac->csa_chandef))
> > > -			return -EINVAL;
> > > -
> > > -		return 0;
> > > -	}
> > 
> > 
> > This particular CSA_ACTIVE status check was introduced for compatibility with
> > hostapd behaviour. Currently hostapd goes through all the virtual interfaces
> > and sends CSA for each of them. So the idea was to send CSA for primary
> > interface and confirm success for the others. If this snipped is dropped
> > then we end up in multiple identical CSA requests queued in firmware.
> > 
> > I suggest to remove chandef_identical check, but to keep the logic for
> > secondary virtual interface handling.
> 
> The idea was that driver doesn't have to keep track of this, but instead it
> will just forward directly to card, and card will return success for CSA
> request to the same channel, because card knows that already.
> 
> As a bonus, in case it will ever support virtual concurrent (virtual
> interfaces on different physical channels), no changes to driver will be
> required.

If we drop this check from driver, then we have to add similar check into
the firmware for the time being. We should drop subsequent CSA requests
for secondary virtual interfaces.

Regards,
Sergey

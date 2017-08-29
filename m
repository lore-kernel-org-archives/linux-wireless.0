Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0087.outbound.protection.outlook.com ([104.47.34.87]:43184
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751241AbdH2PpQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 11:45:16 -0400
Date: Tue, 29 Aug 2017 18:44:56 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: igor.mitsyanko.os@quantenna.com
Cc: linux-wireless@vger.kernel.org, avinashp@quantenna.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH 14/27] qtnfmac: do not cache CSA chandef info
Message-ID: <20170829154455.j2qrxcu35mwkwzcl@bars> (sfid-20170829_174521_379703_C9AE7083)
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <20170825023024.10565-15-igor.mitsyanko.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825023024.10565-15-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am ok with removal of CSA chandef info. It was kept mainly to warn
about channel switch to the frequency that differs from original
CSA request.

> -	if (vif->vifid != 0) {
> -		if (!(mac->status & QTNF_MAC_CSA_ACTIVE))
> -			return -EOPNOTSUPP;
> -
> -		if (!cfg80211_chandef_identical(&params->chandef,
> -						&mac->csa_chandef))
> -			return -EINVAL;
> -
> -		return 0;
> -	}


This particular CSA_ACTIVE status check was introduced for compatibility with
hostapd behaviour. Currently hostapd goes through all the virtual interfaces
and sends CSA for each of them. So the idea was to send CSA for primary
interface and confirm success for the others. If this snipped is dropped
then we end up in multiple identical CSA requests queued in firmware.

I suggest to remove chandef_identical check, but to keep the logic for
secondary virtual interface handling.

Regards,
Sergey

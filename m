Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0050.outbound.protection.outlook.com ([104.47.42.50]:7760
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751318AbdH3Bsa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 21:48:30 -0400
Subject: Re: [PATCH 14/27] qtnfmac: do not cache CSA chandef info
To: "sergey.matyukevich.os@quantenna.com"
        <sergey.matyukevich.os@quantenna.com>
References: <20170825023024.10565-1-igor.mitsyanko.os@quantenna.com>
 <20170825023024.10565-15-igor.mitsyanko.os@quantenna.com>
 <20170829154455.j2qrxcu35mwkwzcl@bars>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org, avinashp@quantenna.com,
        johannes@sipsolutions.net
Message-ID: <0627667f-87d7-644b-a582-27b9ce638ff9@quantenna.com> (sfid-20170830_034834_865890_A7EE7C60)
Date: Tue, 29 Aug 2017 18:48:23 -0700
MIME-Version: 1.0
In-Reply-To: <20170829154455.j2qrxcu35mwkwzcl@bars>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2017 08:44 AM, Sergey Matyukevich wrote:
> I am ok with removal of CSA chandef info. It was kept mainly to warn
> about channel switch to the frequency that differs from original
> CSA request.
> 
>> -	if (vif->vifid != 0) {
>> -		if (!(mac->status & QTNF_MAC_CSA_ACTIVE))
>> -			return -EOPNOTSUPP;
>> -
>> -		if (!cfg80211_chandef_identical(&params->chandef,
>> -						&mac->csa_chandef))
>> -			return -EINVAL;
>> -
>> -		return 0;
>> -	}
> 
> 
> This particular CSA_ACTIVE status check was introduced for compatibility with
> hostapd behaviour. Currently hostapd goes through all the virtual interfaces
> and sends CSA for each of them. So the idea was to send CSA for primary
> interface and confirm success for the others. If this snipped is dropped
> then we end up in multiple identical CSA requests queued in firmware.
> 
> I suggest to remove chandef_identical check, but to keep the logic for
> secondary virtual interface handling.
> 
> Regards,
> Sergey
> 

The idea was that driver doesn't have to keep track of this, but instead 
it will just forward directly to card, and card will return success for 
CSA request to the same channel, because card knows that already.

As a bonus, in case it will ever support virtual concurrent (virtual 
interfaces on different physical channels), no changes to driver will be 
required.

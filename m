Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:60287 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbbBTT3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 14:29:03 -0500
Message-ID: <54E78AFA.1000400@broadcom.com> (sfid-20150220_202908_421787_1060756C)
Date: Fri, 20 Feb 2015 20:28:58 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	Ahmad Kholaif <akholaif@qca.qualcomm.com>
Subject: Re: [PATCH 1/2] cfg80211: Allow NL80211_ATTR_IFINDEX to be added
 to vendor events
References: <1424442925-10778-1-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1424442925-10778-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/15 15:35, Jouni Malinen wrote:
> @@ -7405,6 +7405,12 @@ __cfg80211_alloc_vendor_skb(struct cfg80211_registered_device *rdev,
>   			goto nla_put_failure;
>   	}
>
> +	if (wdev&&  wdev->netdev) {
> +		if (nla_put_u32(skb, NL80211_ATTR_IFINDEX,
> +				wdev->netdev->ifindex))
> +			goto nla_put_failure;
> +	}
> +

Could consider putting wdev id in there as well.

Regards,
Arend

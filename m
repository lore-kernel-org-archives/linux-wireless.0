Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:50221 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbbIAHsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 03:48:36 -0400
Message-ID: <55E55851.1090004@broadcom.com> (sfid-20150901_094839_787214_9489D2B5)
Date: Tue, 1 Sep 2015 09:48:33 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] nl80211: put current TX power in interface info
References: <1441054778-22499-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1441054778-22499-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/31/2015 10:59 PM, Rafał Miłecki wrote:
> Many drivers implement reading current TX power (using either cfg80211
> or ieee80211 op) but userspace can't get it using nl80211. Right now the
> only way to access it is to call some wext ioctl.
> Let's put TX power in interface info reply (callback is wdev specific)
> just like we do with current channel.
> To be consistent (e.g. NL80211_CMD_SET_WIPHY) let's use mBm as na unit.

An iw patch would be nice as well ;-)

Regards,
Arend

> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>   net/wireless/nl80211.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 5d8748b..a5d4e6f 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -2403,6 +2403,17 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
>   		}
>   	}
>
> +	if (rdev->ops->get_tx_power) {
> +		int dbm, ret;
> +
> +		ret = rdev_get_tx_power(rdev, wdev, &dbm);
> +		if (ret == 0) {
> +			if (nla_put_u32(msg, NL80211_ATTR_WIPHY_TX_POWER_LEVEL,
> +					DBM_TO_MBM(dbm)))
> +				goto nla_put_failure;
> +		}
> +	}
> +
>   	if (wdev->ssid_len) {
>   		if (nla_put(msg, NL80211_ATTR_SSID, wdev->ssid_len, wdev->ssid))
>   			goto nla_put_failure;
>


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55452 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbaJNJVR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 05:21:17 -0400
Message-ID: <1413278472.2455.3.camel@jlt4.sipsolutions.net> (sfid-20141014_112119_858748_640D11BC)
Subject: Re: [PATCH 2/2] cfg80211: Specify frame and reason code for
 NL80211_CMD_DEL_STATION
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Oct 2014 11:21:12 +0200
In-Reply-To: <20141010175525.GA29436@jouni.qca.qualcomm.com>
References: <20141010175525.GA29436@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-10 at 20:55 +0300, Jouni Malinen wrote:

>   * @mac: MAC address of the station to remove or NULL to remove all stations
> + * @subtype: Management frame subtype to use for indicating removal
> + *	(0 = no guidance on whether to indicate the removal to the station is
> + *	provided, 10 = Disassociation, 12 = Deauthentication)
> + * @reason_code: Reason code for the Disassociation/Deauthentication frame
>   */
>  struct station_del_parameters {
>  	const u8 *mac;
> +	u8 subtype;
> +	u16 reason_code;

the reason_code could end up being zero right now, if userspace doesn't
specify the attribute.

> +	if (info->attrs[NL80211_ATTR_MGMT_SUBTYPE]) {
> +		params.subtype =
> +			nla_get_u8(info->attrs[NL80211_ATTR_MGMT_SUBTYPE]);
> +		if (params.subtype != IEEE80211_STYPE_DISASSOC >> 4 &&
> +		    params.subtype != IEEE80211_STYPE_DEAUTH >> 4)
> +			return -EINVAL;
> +	}
> +
> +	if (info->attrs[NL80211_ATTR_REASON_CODE]) {
> +		params.reason_code =
> +			nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
> +		if (params.reason_code == 0)
> +			return -EINVAL; /* 0 is reserved */
> +	}

I think you should probably force a reason code to be given when
specifying the subtype. And I'm thinking that defaulting to deauth/3
would be better than leaving it up to the driver(s)?

johannes


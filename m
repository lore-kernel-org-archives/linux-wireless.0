Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45660 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751099AbeAVMsJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:48:09 -0500
Message-ID: <1516625287.2508.18.camel@sipsolutions.net> (sfid-20180122_134813_174553_7E08E625)
Subject: Re: [PATCH 1/2] cfg80211: Add support to notify station's opmode
 change to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: tamizhr@codeaurora.org
Cc: linux-wireless@vger.kernel.org, tamizhr@qti.qualcomm.com
Date: Mon, 22 Jan 2018 13:48:07 +0100
In-Reply-To: <1516173508-16528-1-git-send-email-tamizhr@codeaurora.org>
References: <1516173508-16528-1-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-17 at 12:48 +0530, tamizhr@codeaurora.org wrote:
> 
>  /**
> + * enum wiphy_opmode_info_flag - opmode information flags
> + *
> + * @MAX_BW_CHANGED: Max Bandwidth changed
> + * @SMPS_MODE_CHANGED: SMPS mode changed
> + * @N_SS_CHANGED: max N_SS (number of spatial streams) changed
> + *
> + */
> +enum wiphy_opmode_info_flag {
> +	MAX_BW_CHANGED		= BIT(0),
> +	SMPS_MODE_CHANGED	= BIT(1),
> +	N_SS_CHANGED		= BIT(2),
> +};

These need to have some kind of common prefix, e.g.
STA_OPMODE_{BW,SMPS,NSS}_CHANGED


>  /**
> + * cfg80211_sta_opmode_change_notify - Station's SMPS mode, rx_nss and
> + *	max bandwidth change event

need to find a shorter description - must fit on one line

> + * @dev: network device
> + * @mac: MAC address of a station which opmode got modified
> + * @changed: contains value from &enum wiphy_opmode_info_flag
> + * @smps_mode: New SMPS mode of a station
> + * @bw: new max bandwidth value of a station
> + * @rx_nss: new rx_nss value of a station
> + * @gfp: context flags
> + *
> + * This function is called when station's opmode modified via action frame.

Rephrase, say "Drivers should call this function when ..."

> +void cfg80211_sta_opmode_change_notify(struct net_device *dev, const u8 *mac,
> +				       enum wiphy_opmode_info_flag changed,
> +				       u8 smps_mode, u8 bw, u8 rx_nss,
> +				       gfp_t gfp);

We may not want to add more, but pulling out those parameters "changed,
smps_mode, bw, rx_nss" into a small structure would IMHO be a good
idea.

> + * @NL80211_CMD_STA_OPMODE_CHANGED: An event that notify station's
> + *	ht opmode or vht opmode changes. This will use &NL80211_ATTR_SMPS_MODE,
> + *	&NL80211_ATTR_CHANNEL_WIDTH, &NL80211_ATTR_NSS to send the event to
> + *	userspace.

Should document that not all of those attributes may be included at all
times.

> +void cfg80211_sta_opmode_change_notify(struct net_device *dev, const u8 *mac,
> +				       enum wiphy_opmode_info_flag changed,
> +				       u8 smps, u8 bw, u8 rx_nss, gfp_t gfp)
> +{
> +	struct sk_buff *msg;
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
> +	void *hdr;
> +
> +	if (!mac)
> +		return;

WARN_ON(), perhaps

> +	if (mac && nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac))
> +		goto nla_put_failure;

no need to check mac != NULL again

> +nla_put_failure:
> +	genlmsg_cancel(msg, hdr);

no need for cancel when you're going to free the message

johannes

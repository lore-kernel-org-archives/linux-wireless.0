Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41338 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751281AbdLKLNB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 06:13:01 -0500
Message-ID: <1512990779.26976.69.camel@sipsolutions.net> (sfid-20171211_121558_004692_2C447BC0)
Subject: Re: [PATCH] nl80211: Update ERP info using
 NL80211_CMD_UPDATE_CONNECT_PARAMS
From: Johannes Berg <johannes@sipsolutions.net>
To: Vidyullatha Kanchanapally <vidyullatha@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        vkanchan@qti.qualcomm.com, amarnath@qti.qualcomm.com,
        usdutt@qti.qualcomm.com, vamsin@qti.qualcomm.com
Date: Mon, 11 Dec 2017 12:12:59 +0100
In-Reply-To: <1508923248-18848-1-git-send-email-vidyullatha@codeaurora.org>
References: <1508923248-18848-1-git-send-email-vidyullatha@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-25 at 14:50 +0530, Vidyullatha Kanchanapally wrote:

> + * @UPDATE_FILS_ERP_INFO: Indicates that FILS connection parameters (realm,
> + *	username, erp sequence number and rrk) are updated
> + * @UPDATE_AUTH_TYPE: Indicates that Authentication type is updated

These are new here, but you don't know if they were actually supported:

> +	if (wiphy_ext_feature_isset(&rdev->wiphy,
> +				    NL80211_EXT_FEATURE_FILS_SK_OFFLOAD) &&

here.

> +	    info->attrs[NL80211_ATTR_FILS_ERP_USERNAME] &&
> +	    info->attrs[NL80211_ATTR_FILS_ERP_REALM] &&
> +	    info->attrs[NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM] &&
> +	    info->attrs[NL80211_ATTR_FILS_ERP_RRK]) {
[...]
> +	} else if (info->attrs[NL80211_ATTR_FILS_ERP_USERNAME] ||
> +		   info->attrs[NL80211_ATTR_FILS_ERP_REALM] ||
> +		   info->attrs[NL80211_ATTR_FILS_ERP_NEXT_SEQ_NUM] ||
> +		   info->attrs[NL80211_ATTR_FILS_ERP_RRK]) {
> +		return -EINVAL;
> +	}

This logic is also really odd, why not

if (attrs) {
	if (not flag)
		return -EINVAL;
	/* use attrs etc. */
}

> +
> +	if (info->attrs[NL80211_ATTR_AUTH_TYPE]) {
> +		u32 auth_type =
> +			nla_get_u32(info->attrs[NL80211_ATTR_AUTH_TYPE]);
> +		if (!nl80211_valid_auth_type(rdev, auth_type,
> +					     NL80211_CMD_CONNECT))
> +			return -EINVAL;
> +		connect.auth_type = auth_type;
> +		changed |= UPDATE_AUTH_TYPE;
> +	}

Again, how do you know the driver will actually look at
UPDATE_AUTH_TYPE?

johannes

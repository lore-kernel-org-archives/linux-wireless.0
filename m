Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:41486 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752552AbeADU7y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 15:59:54 -0500
Received: by mail-pg0-f66.google.com with SMTP id 77so1162259pgd.8
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jan 2018 12:59:54 -0800 (PST)
Subject: Re: [PATCH v2 1/3] cfg80211/nl80211: Optional authentication offload
 to userspace
To: Jouni Malinen <jouni@qca.qualcomm.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Srinivas Dasari <dasaris@qti.qualcomm.com>
References: <1513960419-24780-1-git-send-email-jouni@qca.qualcomm.com>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <c2554a26-bbbc-3bd2-0091-06fc14e88946@gmail.com> (sfid-20180104_215958_410754_0912712A)
Date: Thu, 4 Jan 2018 14:59:51 -0600
MIME-Version: 1.0
In-Reply-To: <1513960419-24780-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni, Johannes,

<snip>> + *	User space uses the %NL80211_CMD_CONNECT command to the host 
driver for
> + *	triggering a connection. The host driver selects a BSS and further uses
> + *	this interface to offload only the authentication part to the user
> + *	space. Authentication frames are passed between the driver and user
> + *	space through the %NL80211_CMD_FRAME interface. The status of

So this implies userspace must pre-register for authentication 
management frames, correct?  And other applications could register to 
receive these frames as well?  Would it not be easier (and more secure) 
to simply forward these directly to the application that triggered 
CMD_CONNECT instead?

> + *	authentication is further indicated by user space to the host driver
> + *	with the %NL80211_CMD_EXTERNAL_AUTH command through
> + *	%NL80211_ATTR_STATUS_CODE attribute. This enables the driver to proceed
> + *	with association on successful authentication. Driver shall use this
> + *	%NL80211_ATTR_STATUS_CODE attribute to report the connect result to
> + *	user space on an authentication failure.
> + *
>    * @NL80211_CMD_MAX: highest used command number
>    * @__NL80211_CMD_AFTER_LAST: internal use
>    */

<snip>

>   
> +int cfg80211_external_auth_request(struct net_device *dev,
> +				   struct cfg80211_external_auth_params *params,
> +				   gfp_t gfp)
> +{
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
> +	struct sk_buff *msg;
> +	void *hdr;
> +
> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_EXTERNAL_AUTH);
> +	if (!hdr) {
> +		nlmsg_free(msg);
> +		return -ENOMEM;
> +	}
> +
> +	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
> +	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
> +	    nla_put_u32(msg, NL80211_ATTR_AKM_SUITES, params->key_mgmt_suite) ||
> +	    nla_put_u32(msg, NL80211_ATTR_EXTERNAL_AUTH_ACTION,
> +			params->action) ||
> +	    nla_put(msg, NL80211_ATTR_BSSID, ETH_ALEN, params->bssid) ||
> +	    nla_put(msg, NL80211_ATTR_SSID, params->ssid.ssid_len,
> +		    params->ssid.ssid))
> +		goto nla_put_failure;
> +
> +	genlmsg_end(msg, hdr);
> +
> +	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
> +				NL80211_MCGRP_MLME, gfp);

Is there a reason this is being multicast and not unicast to the 
application that triggered the CONNECT?  Who else besides the supplicant 
daemon might find this information useful?

> +	return 0;
> +
> + nla_put_failure:
> +	genlmsg_cancel(msg, hdr);
> +	nlmsg_free(msg);
> +	return -ENOBUFS;
> +}
> +EXPORT_SYMBOL(cfg80211_external_auth_request);
> +
>   /* initialisation/exit functions */
>   
>   int __init nl80211_init(void)

Regards,
-Denis

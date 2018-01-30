Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:59530 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751537AbeA3HxT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 02:53:19 -0500
Message-ID: <1517298797.2189.36.camel@sipsolutions.net> (sfid-20180130_085322_903779_DFCAF59B)
Subject: Re: [PATCH v3 2/3] cfg80211/nl80211: Optional authentication
 offload to userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Srinivas Dasari <dasaris@qti.qualcomm.com>
Date: Tue, 30 Jan 2018 08:53:17 +0100
In-Reply-To: <1516893219-30243-2-git-send-email-jouni@qca.qualcomm.com>
References: <1516893219-30243-1-git-send-email-jouni@qca.qualcomm.com>
         <1516893219-30243-2-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-01-25 at 17:13 +0200, Jouni Malinen wrote:
> 
> +	if (nla_get_flag(info->attrs[NL80211_ATTR_EXTERNAL_AUTH_SUPPORT]))
> +		connect.flags |= CONNECT_REQ_EXTERNAL_AUTH_SUPPORT;

It seems like here we should check for connection owner, no?

If you say yes, I can edit that in.

> +int cfg80211_external_auth_request(struct net_device *dev,
> +				   struct cfg80211_external_auth_params *params,
> +				   gfp_t gfp)
> +{
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
> +	struct sk_buff *msg;
> +	void *hdr;
> +
> +	if (!wdev->conn_owner_nlportid)
> +		return -EINVAL;

This still kinda makes sense, of course, though it should only happen
through races (connection owner goes away and we can't tear down the
connection quickly enough before this happens)

johannes

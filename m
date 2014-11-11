Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59025 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbaKKQQT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 11:16:19 -0500
Message-ID: <1415722576.2163.11.camel@sipsolutions.net> (sfid-20141111_171624_033117_CADF6143)
Subject: Re: [PATCH v2] nl80211: Broadcast CMD_NEW_INTERFACE and
 CMD_DEL_INTERFACE
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Nov 2014 17:16:16 +0100
In-Reply-To: <1415693965-3081-1-git-send-email-tomasz.bursztyka@linux.intel.com> (sfid-20141111_092406_015374_24F83E13)
References: <1415693965-3081-1-git-send-email-tomasz.bursztyka@linux.intel.com>
	 (sfid-20141111_092406_015374_24F83E13)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-11 at 10:19 +0200, Tomasz Bursztyka wrote:

>  static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flags,
>  			      struct cfg80211_registered_device *rdev,
> -			      struct wireless_dev *wdev)
> +			      struct wireless_dev *wdev, bool new)

That "new" parameter makes no sense, everybody is going to read that as
"is it a new interface" (for the mcast of NEW_INTERFACE) but that's
completely bogus. I kinda understand where you're coming from (the
command name) but it's still really confusing.

Inverting it to "removal" or so would be much easier to follow.

Additionally,

> @@ -2364,7 +2368,7 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
>  			(cfg80211_rdev_list_generation << 2)))
>  		goto nla_put_failure;
>  
> -	if (rdev->ops->get_channel) {
> +	if (new && rdev->ops->get_channel) {
>  		int ret;
>  		struct cfg80211_chan_def chandef;

This shouldn't be needed, since when the interface is removed if there's
still a channel you can send it, but usually there won't be one.
 
> @@ -2375,7 +2379,7 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
>  		}
>  	}
>  
> -	if (wdev->ssid_len) {
> +	if (new && wdev->ssid_len) {
>  		if (nla_put(msg, NL80211_ATTR_SSID, wdev->ssid_len, wdev->ssid))
>  			goto nla_put_failure;

Ditto, I don't believe there can still be an SSID stored.

> @@ -2587,7 +2591,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
>  	struct cfg80211_registered_device *rdev = info->user_ptr[0];
>  	struct vif_params params;
>  	struct wireless_dev *wdev;
> -	struct sk_buff *msg;
> +	struct sk_buff *msg, *n_msg;

n_msg means nothing? maybe just call that *event?

> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (msg && nl80211_send_iface(msg, 0, 0, 0, rdev, wdev, false) < 0) {
> +			nlmsg_free(msg);
> +			msg = NULL;
> +	}

broken indentation

>  	/*
>  	 * If we remove a wireless device without a netdev then clear
>  	 * user_ptr[1] so that nl80211_post_doit won't dereference it
> @@ -2708,7 +2733,14 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
>  	if (!wdev->netdev)
>  		info->user_ptr[1] = NULL;
>  
> -	return rdev_del_virtual_intf(rdev, wdev);
> +	status = rdev_del_virtual_intf(rdev, wdev);
> +	if (status >= 0 && msg) {
> +		genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy),
> +					msg, 0, NL80211_MCGRP_CONFIG,
> +					GFP_KERNEL);
> +	}

no need for braces, missing else

johannes


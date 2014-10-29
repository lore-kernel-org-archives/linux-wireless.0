Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38660 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933331AbaJ2Pof (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:44:35 -0400
Message-ID: <1414597472.1827.12.camel@jlt4.sipsolutions.net> (sfid-20141029_164440_271307_811CDCBC)
Subject: Re: [PATCH] wireless: nl80211: Broadcast CMD_NEW_INTERFACE and
 CMD_DEL_INTERFACE
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Oct 2014 16:44:32 +0100
In-Reply-To: <1414413807-7649-1-git-send-email-tomasz.bursztyka@linux.intel.com> (sfid-20141027_134340_833740_6984A324)
References: <1414413807-7649-1-git-send-email-tomasz.bursztyka@linux.intel.com>
	 (sfid-20141027_134340_833740_6984A324)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-27 at 14:43 +0200, Tomasz Bursztyka wrote:
> Let the other listeners being notified when a new or del interface
> command has been issued, thus reducing later necessary request to be in
> sync with current context.

I see no reason to list "wireless:" in the subject - please just use
nl80211: prefix.

> It bloats a bit nl80211_send_iface() function (I wanted to reuse its logic
> for both commands). Tell me if you would prefer a better way to do this.

I guess I'll see that below :)

It really bloats the *arguments* more than anything, no way to change
that, say by sending the delete message before the wdev is destroyed?

> @@ -2370,10 +2376,8 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
>  		}
>  	}
>  
> -	if (wdev->ssid_len) {
> -		if (nla_put(msg, NL80211_ATTR_SSID, wdev->ssid_len, wdev->ssid))
> +	if (ssid_len && nla_put(msg, NL80211_ATTR_SSID, ssid_len, ssid))
>  			goto nla_put_failure;
> -	}

This results in bad indentation.
 
> @@ -2687,10 +2725,17 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
>  {
>  	struct cfg80211_registered_device *rdev = info->user_ptr[0];
>  	struct wireless_dev *wdev = info->user_ptr[1];
> +	enum nl80211_iftype iftype = wdev->iftype;
> +	struct net_device *dev = wdev->netdev;
> +	u8 address[ETH_ALEN];
> +	u64 id = wdev_id(wdev);
> +	int status;
>  
>  	if (!rdev->ops->del_virtual_intf)
>  		return -EOPNOTSUPP;
>  
> +	memcpy(address, wdev_address(wdev), ETH_ALEN);
> +
>  	/*
>  	 * If we remove a wireless device without a netdev then clear
>  	 * user_ptr[1] so that nl80211_post_doit won't dereference it
> @@ -2698,10 +2743,17 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
>  	 * since the wdev has been freed, unlike with a netdev where
>  	 * we need the dev_put() for the netdev to really be freed.
>  	 */
> -	if (!wdev->netdev)
> +	if (!dev)
>  		info->user_ptr[1] = NULL;
>  
> -	return rdev_del_virtual_intf(rdev, wdev);
> +	status = rdev_del_virtual_intf(rdev, wdev);
> +	if (status < 0)
> +		return status;
> +
> +	nl80211_notify_iface(rdev, NULL, iftype, id, address, dev,
> +			     0, NULL, false, info->snd_portid);

I'm not sure why this needs to be so late in the command, if you put it
first you don't have the whole argument bloating issue.

johannes


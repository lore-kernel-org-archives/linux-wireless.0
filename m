Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937383Ab3DIKGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 06:06:41 -0400
Message-ID: <1365501997.8465.23.camel@jlt4.sipsolutions.net> (sfid-20130409_120645_279762_E3EF2739)
Subject: Re: [PATCH] cfg80211: introduce critical protocol indication from
 user-space
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 09 Apr 2013 12:06:37 +0200
In-Reply-To: <1365412173-7428-1-git-send-email-arend@broadcom.com>
References: <1365412173-7428-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-08 at 11:09 +0200, Arend van Spriel wrote:

> + * @crit_proto_start: Indicates a critical protocol needs more link reliability.

Can you elaborate here on what the protocol means? Why is it there, and
how is it supposed to be used? Why and how would a device/driver do
something different for different protocols?

Also please document that the duration units is milliseconds. (both here
and in the missing kernel-doc for the nl80211 attributes)

> +/**
> + * cfg80211_crit_proto_stopped() - indicate critical protocol stopped by driver.
> + *
> + * @wdev: the wireless device for which critical protocol is stopped.
> + *
> + * This function can be called by the driver to indicate it has reverted
> + * operation back to normal. One reason could be that the duration given
> + * by .crit_proto_start() has expired.
> + */
> +void cfg80211_crit_proto_stopped(struct wireless_dev *wdev);

May need gfp_t argument to send a netlink message?

> @@ -1709,6 +1719,9 @@ enum nl80211_attrs {
>  	NL80211_ATTR_MDID,
>  	NL80211_ATTR_IE_RIC,
>  
> +	NL80211_ATTR_CRIT_PROT_ID,
> +	NL80211_ATTR_MAX_CRIT_PROT_DURATION,

missing kernel-doc.


> +/**
> + * enum nl80211_crit_proto_id - nl80211 critical protocol identifiers
> + *
> + * @NL80211_CRIT_PROTO_UNSPEC: protocol unspecified.
> + * @NL80211_CRIT_PROTO_BOOTP: BOOTP protocol.
> + * @NL80211_CRIT_PROTO_EAPOL: EAPOL protocol.
> + * @NL80211_CRIT_PROTO_ARP: ARP protocol for APIPA.

Don't like IPv6? :-)

> + * @NL80211_CRIT_PROTO_LAST: must be kept last.

shouldn't that be NUM_NL80211_CRIT_PROTO to be more like the (most)
other enums?

> --- a/net/wireless/mlme.c
> +++ b/net/wireless/mlme.c
> @@ -648,6 +648,9 @@ void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlportid)
>  
>  	spin_unlock_bh(&wdev->mgmt_registrations_lock);
>  
> +	if (rdev->ops->crit_proto_stop)
> +		rdev_crit_proto_stop(rdev, wdev);

This is broken, you're not checking that it's the correct socket.
Therefore, if you run, for example, "iw wlan0 link" while the critical
operation is ongoing it will be aborted.

> +	duration = min_t(u16, duration, NL80211_MAX_CRIT_PROT_DURATION);

Why not reject it if too large (although then the max should be defined
in the header file)? Is there a reason, like maybe wanting to be able to
increase the kernel value later? If so, might want to have a comment?

> +static int nl80211_crit_protocol_stop(struct sk_buff *skb,
> +				      struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct wireless_dev *wdev = info->user_ptr[1];
> +
> +	if (!rdev->ops->crit_proto_stop)
> +		return -EOPNOTSUPP;
> +
> +	rdev_crit_proto_stop(rdev, wdev);

What if it's not even started?

> +void cfg80211_crit_proto_stopped(struct wireless_dev *wdev)
> +{
> +	struct cfg80211_registered_device *rdev;
> +
> +	rdev = wiphy_to_dev(wdev->wiphy);
> +	WARN_ON(!rdev->crit_proto_started);
> +	rdev->crit_proto_started = false;
> +}

Oh, so you don't want to tell userspace?

Do you expect drivers to call this function even when explicitly asked
to stop? That should be documented then, I think.

johannes


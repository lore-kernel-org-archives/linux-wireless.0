Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57203 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754216AbcJNHcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 03:32:08 -0400
Message-ID: <1476430325.4382.18.camel@sipsolutions.net> (sfid-20161014_093211_630824_2D290E17)
Subject: Re: [PATCH] cfg80211: Add support to update connection parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        vamsi krishna <vamsin@qti.qualcomm.com>
Date: Fri, 14 Oct 2016 09:32:05 +0200
In-Reply-To: <1476373178-31105-1-git-send-email-jouni@qca.qualcomm.com>
References: <1476373178-31105-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In addition to Arend's comments...

>   *     (invoked with the wireless_dev mutex held)
> + * @update_connect_params: Update the connect parameters while connected to a
> + *     BSS. The updated parameters can be used by driver/firmware for
> + *     subsequent BSS selection (roaming) decisions and to form the
> + *     Authentication/(Re)Association Request frames. This call does not
> + *     request an immediate disassociation or reassociation with the current
> + *     BSS, i.e., this impacts only subsequence (re)associations.

The other related calls are all invoked with the wireless_dev mutex
held, I think it'd be better for consistency to replicate that here.

> +static int nl80211_update_connect_params(struct sk_buff *skb,
> +					 struct genl_info *info)
> +{
> +	struct cfg80211_connect_params connect;
> +	struct cfg80211_connect_params_valid cpv;
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct net_device *dev = info->user_ptr[1];
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +
> +	memset(&connect, 0, sizeof(connect));
> +	memset(&cpv, 0, sizeof(cpv));

I tend to prefer (0) C99 initalizers since it makes the code shorter,
but it doesn't really matter much.

> +	if (!wdev->current_bss)
> +		return -ENOLINK;

Also, regarding the locking, there's no guarantee that this won't
become NULL immediately after the check, if you don't have any locking.

Now, the driver (or more likely firmware!), would still have to protect
against races, say where the firmware disconnected while userspace
called this ... but at least software wise it'd be consistent.

johannes

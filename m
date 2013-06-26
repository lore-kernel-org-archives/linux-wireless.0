Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3FZPb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 11:31:56 -0400
Message-ID: <1372260710.13529.20.camel@jlt4.sipsolutions.net> (sfid-20130626_173159_408916_5FD99CA5)
Subject: Re: [PATCH v12 2/2] cfg80211: P2P find phase offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	Ilan Peer <ilan.peer@intel.com>
Date: Wed, 26 Jun 2013 17:31:50 +0200
In-Reply-To: <1372167756-17928-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1372167756-17928-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1372167756-17928-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looking good ... :)

On Tue, 2013-06-25 at 16:42 +0300, Vladimir Kondratiev wrote:

> + * @channels: channels to operate on
> + *     may be NULL, in this case driver suppose to scan for all
> social
> + *     channels; or channel set should be non-empty (n_channels > 0)

Does that make sense, or should cfg80211 just build the channel list in
the case the user didn't specify anything, rather than leave it NULL? It
seems that every driver implementing it really needs the list, and
having multiple drivers create it seems wasteful?

> +static int nl80211_stop_p2p_find(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	struct wireless_dev *wdev = info->user_ptr[1];
> +
> +	if (wdev->iftype != NL80211_IFTYPE_P2P_DEVICE)
> +		return -EOPNOTSUPP;
> +
> +	if (!rdev->ops->start_p2p_find || !rdev->ops->stop_p2p_find)
> +		return -EOPNOTSUPP;
> +
> +	rdev_stop_p2p_find(rdev, wdev);

You don't track whether this p2p find is ongoing, so userspace can abort
it many times. I think it would be worth documenting that, and also that
in that case cfg80211_p2p_find_notify_end() probably shouldn't be
called?

johannes


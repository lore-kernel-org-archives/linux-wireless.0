Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ipv4.connman.net ([82.165.8.211]:40987 "EHLO mail.holtmann.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750778AbcGIOFl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2016 10:05:41 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [RFC v2 1/3] nl80211: Add nl80211_notify_iface
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1468044967-9236-2-git-send-email-denkenz@gmail.com>
Date: Sat, 9 Jul 2016 16:05:33 +0200
Cc: linux-wireless@vger.kernel.org
Message-Id: <1601C89F-62D4-42F5-B5A4-2C9E2F02A673@holtmann.org> (sfid-20160709_160610_980414_B29C2A97)
References: <1468044967-9236-1-git-send-email-denkenz@gmail.com> <1468044967-9236-2-git-send-email-denkenz@gmail.com>
To: Denis Kenzior <denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Denis,

> This function emits NL80211_CMD_NEW_INTERFACE or
> NL80211_CMD_DEL_INTERFACE events.  This is meant to be used by the core
> to notify userspace applications such as wpa_supplicant when a netdev
> related to a wireless device has been added or removed.
> 
> Signed-off-by: Denis Kenzior <denkenz@gmail.com>
> ---
> net/wireless/nl80211.c | 28 ++++++++++++++++++++++++++++
> net/wireless/nl80211.h |  3 +++
> 2 files changed, 31 insertions(+)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index f39fd4d..da03e17 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -11855,6 +11855,34 @@ void nl80211_notify_wiphy(struct cfg80211_registered_device *rdev,
> 				NL80211_MCGRP_CONFIG, GFP_KERNEL);
> }
> 
> +void nl80211_notify_iface(struct cfg80211_registered_device *rdev,
> +				struct wireless_dev *wdev,
> +				enum nl80211_commands cmd)
> +{
> +	struct sk_buff *msg;
> +	bool removal;
> +
> +	WARN_ON(cmd != NL80211_CMD_NEW_INTERFACE &&
> +		cmd != NL80211_CMD_DEL_INTERFACE);

I would assume that BUILD_BUG_ON does a way job better here.

Regards

Marcel


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35881 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812Ab0KPWZb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 17:25:31 -0500
Subject: Re: [PATCH 1/2] cfg80211: add support for setting the ad-hoc
 multicast rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1289484443-96326-1-git-send-email-nbd@openwrt.org>
References: <1289484443-96326-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 14:27:03 -0800
Message-ID: <1289946423.3673.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-11 at 15:07 +0100, Felix Fietkau wrote:

> +	if (info->attrs[NL80211_ATTR_MCAST_RATE])
> +		ibss.mcast_rate =
> +			nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE]);

That should really check that the rate is supported, and maybe that it's
a basic rate.

johannes


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.solarflare.com ([216.237.3.220]:21268 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbZJABos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2009 21:44:48 -0400
Subject: Re: [PATCH 1/3] wireless: implement basic ethtool support for
 cfg80211 devices
From: Ben Hutchings <bhutchings@solarflare.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Kalle Valo <kalle.valo@nokia.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1254359942-3483-1-git-send-email-linville@tuxdriver.com>
References: <20091001011340.GA3123@tuxdriver.com>
	 <1254359942-3483-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Oct 2009 02:30:38 +0100
Message-Id: <1254360638.23350.0.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-09-30 at 21:19 -0400, John W. Linville wrote:
[...]
> +void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
> +{
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +
> +	strncpy(info->driver, wiphy_dev(wdev->wiphy)->driver->name,
> +		sizeof(info->driver));
> +	info->driver[sizeof(info->driver) - 1] = '\0';
[...]

Use strlcpy() instead of these two statements.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42006 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2CBJBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 04:01:30 -0500
Subject: Re: [PATCH] cfg80211: Add an attribute to set inactivity timeout
 in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1330615294-13123-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1330615294-13123-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 10:01:24 +0100
Message-ID: <1330678884.8542.11.camel@jlt3.sipsolutions.net> (sfid-20120302_100134_914134_70AAB160)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vasanth,

On Thu, 2012-03-01 at 20:51 +0530, Vasanthakumar Thiagarajan wrote:
> This patch adds an attribute, NL80211_ATTR_INACTIVITY_TIMEOUT,
> to set the inactivity timeout which can be used to remove the
> station in AP mode. This can be passed in NL80211_CMD_START_AP
> and used by the drivers which have AP MLME in firmware but
> don't support get_station() properly. To disable inactivity
> timer in userspace, wpa_s for example, there is a capability
> flag, WIPHY_FLAG_SUPPORTS_INACTIVITY_TIMER, through which
> drivers can register their capability to use the inactivity
> timeout to free the stations.

Thanks.

> + * @NL80211_ATTR_INACTIVITY_TIMER_SUPPORT: Indicates if the driver has the
> + *	capability to use %NL80211_ATTR_INACTIVITY_TIMEOUT for freeing up
> + *	connected stations.

I think now that we have "enum nl80211_feature_flags" you could just add
a flag to it.

> + * @NL80211_ATTR_INACTIVITY_TIMEOUT: timeout value in seconds, this can be
> + *	used by the drivers which has MLME in firmware and does not have support
> + *	to report per station tx/rx activity to free up the staion entry from
> + *	the list. This should not be sent from userspace when the driver does
> + *	not register it's capability to timeout the stations.

Shouldn't that be the other way around -- it needs to be used when the
driver *does* advertise support for it?


> +	WIPHY_FLAG_SUPPORTS_INACTIVITY_TIMER	= BIT(22),

If you use nl80211_feature_flags you also don't need this wiphy to
feature translation, the driver can directly set those flags.

johannes


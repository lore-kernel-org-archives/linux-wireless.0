Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab2DDHeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 03:34:50 -0400
Message-ID: <1333524885.3912.2.camel@jlt3.sipsolutions.net> (sfid-20120404_093453_296775_604EE07E)
Subject: Re: [PATCH] cfg80211: Add channel information to
 NL80211_CMD_GET_INTERFACE
From: Johannes Berg <johannes@sipsolutions.net>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 04 Apr 2012 09:34:45 +0200
In-Reply-To: <1333463998-19329-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20120403_164012_468794_1452235E)
References: <1333463998-19329-1-git-send-email-pontus.fuchs@gmail.com>
	 (sfid-20120403_164012_468794_1452235E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-03 at 16:39 +0200, Pontus Fuchs wrote:
> If the current channel is known, add frequency and channel type to
> NL80211_CMD_GET_INTERFACE.
> 
> Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
> ---
>  include/net/cfg80211.h     |    3 ++-
>  net/mac80211/cfg.c         |    4 +++-
>  net/wireless/nl80211.c     |   13 +++++++++++++
>  net/wireless/wext-compat.c |    3 ++-
>  4 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 83d800c..a1b202c 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1698,7 +1698,8 @@ struct cfg80211_ops {
>  				  struct net_device *dev,
>  				  u16 noack_map);
>  
> -	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy);
> +	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy,
> +					       enum nl80211_channel_type *type);

If you're adding it to GET_INTERFACE, maybe you should also get it per
interface so we can do something smarter when we add multi-channel?

johannes


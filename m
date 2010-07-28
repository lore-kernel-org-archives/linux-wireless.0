Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab0G1GuM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 02:50:12 -0400
Subject: Re: [PATCH] mac80211: inform drivers about the off-channel status
 on channel changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4C4F7C91.9000300@openwrt.org>
References: <4C4F7C91.9000300@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 08:50:08 +0200
Message-ID: <1280299808.3832.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-07-28 at 02:40 +0200, Felix Fietkau wrote:
> For some drivers it can be useful to know whether the channel they're
> supposed to switch to is going to be used for short off-channel work or
> scanning, or whether the hardware is expected to stay on it for a while
> longer. This is important for various kinds of calibration work, which
> takes longer to complete and should keep some persistent state, even if
> the channel temporarily changes.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
> I need something like this for properly getting rid of the ath9k sw
> scanning callback and for fixing various calibration bugs.

Fine with me, I'll just have to hope people don't abuse it too
much... :-)

johannes

> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -625,11 +625,14 @@ struct ieee80211_rx_status {
>   *	may turn the device off as much as possible. Typically, this flag will
>   *	be set when an interface is set UP but not associated or scanning, but
>   *	it can also be unset in that case when monitor interfaces are active.
> + * @IEEE80211_CONF_OFFCHANNEL: The device is currently not on its main
> + *	operating channel.
>   */
>  enum ieee80211_conf_flags {
>  	IEEE80211_CONF_MONITOR		= (1<<0),
>  	IEEE80211_CONF_PS		= (1<<1),
>  	IEEE80211_CONF_IDLE		= (1<<2),
> +	IEEE80211_CONF_OFFCHANNEL	= (1<<3),
>  };
>  
> 
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -111,12 +111,15 @@ int ieee80211_hw_config(struct ieee80211
>  	if (scan_chan) {
>  		chan = scan_chan;
>  		channel_type = NL80211_CHAN_NO_HT;
> +		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
>  	} else if (local->tmp_channel) {
>  		chan = scan_chan = local->tmp_channel;
>  		channel_type = local->tmp_channel_type;
> +		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
>  	} else {
>  		chan = local->oper_channel;
>  		channel_type = local->_oper_channel_type;
> +		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
>  	}
>  
>  	if (chan != local->hw.conf.channel ||
> 



Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44410 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302Ab3BRWmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 17:42:39 -0500
Message-ID: <1361227342.8555.59.camel@jlt4.sipsolutions.net> (sfid-20130218_234243_006511_5126A6C8)
Subject: Re: [PATCHv10 1/2] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Mon, 18 Feb 2013 23:42:22 +0100
In-Reply-To: <1360343782-32149-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130208_182033_365425_39F6743D)
References: <1360343782-32149-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1360343782-32149-2-git-send-email-siwu@hrz.tu-chemnitz.de>
	 (sfid-20130208_182033_365425_39F6743D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 18:16 +0100, Simon Wunderlich wrote:


> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -531,9 +531,16 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
>  	if ((chan->flags & IEEE80211_CHAN_NO_IBSS) &&
>  	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_IBSS))
>  		goto nla_put_failure;
> -	if ((chan->flags & IEEE80211_CHAN_RADAR) &&
> -	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_RADAR))
> -		goto nla_put_failure;
> +	if ((chan->flags & IEEE80211_CHAN_RADAR)) {
> +		u32 time = elapsed_jiffies_msecs(chan->dfs_state_entered);
> +		if (nla_put_flag(msg, NL80211_FREQUENCY_ATTR_RADAR))
> +			goto nla_put_failure;
> +		if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_DFS_STATE,
> +				chan->dfs_state))
> +			goto nla_put_failure;
> +		if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_DFS_TIME, time))
> +			goto nla_put_failure;
> +	}

I'm going to have to revert this part for now, it's causing nl80211
wiphy information messages to overflow depending on the regdomain.
Luckily, we already have a solution in the works, but we're going to
have to send some information only to userspace that implements the
solution.

johannes


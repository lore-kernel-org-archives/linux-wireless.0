Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39586 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1IZJeo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 05:34:44 -0400
Subject: Re: [PATCH 1/3] cfg80211/mac80211: add netdev param to
 set_txq_params()
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1316970415-23239-1-git-send-email-eliad@wizery.com> (sfid-20110925_190730_335163_D6C4F06F)
References: <1316970415-23239-1-git-send-email-eliad@wizery.com>
	 (sfid-20110925_190730_335163_D6C4F06F)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 11:34:41 +0200
Message-ID: <1317029681.4117.29.camel@jlt3.sipsolutions.net> (sfid-20110926_113447_191681_7AF2B258)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-09-25 at 20:06 +0300, Eliad Peller wrote:

> +++ b/net/wireless/nl80211.c
> @@ -1235,6 +1235,11 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
>  			goto bad_res;
>  		}
>  
> +		if (!netdev) {
> +			result = -EINVAL;
> +			goto bad_res;
> +		}
> +

I'm a little worried about this change, but I don't think we have a
choice. Technically, it is an API change. I believe that no existing
applications (hostapd is probably the only using this) make use of this
with just the phy (and not the netdev).

johannes


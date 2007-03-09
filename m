Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35386
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993126AbXCIPrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2007 10:47:06 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH] mac80211: Prevent unregistering of unregistered hw
Date: Fri, 9 Mar 2007 16:46:05 +0100
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200703091614.04526.IvDoorn@gmail.com>
In-Reply-To: <200703091614.04526.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703091646.05292.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 09 March 2007 16:14, Ivo van Doorn wrote:
> At the moment it is possible to call ieee80211_unregister_hw()
> for an unregistered hw structure. This will cause a big panic.
> This patch will add a check to check if IEEE80211_DEV_REGISTERED
> has been set before attempting to unregister hw.

For which reason would a driver call unregister, but not register before?
I smell design problems in the driver ;)

> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> ---
> 
> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
> index 577dbe3..7494280 100644
> --- a/net/mac80211/ieee80211.c
> +++ b/net/mac80211/ieee80211.c
> @@ -4765,6 +4765,12 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
>  	/* TODO: skb_queue should be empty here, no need to do anything? */
>  
>  	rtnl_lock();
> +
> +	if (local->reg_state != IEEE80211_DEV_REGISTERED) {
> +		rtnl_unlock();
> +		return;
> +	}
> +
>  	local->reg_state = IEEE80211_DEV_UNREGISTERED;
>  	if (local->apdev)
>  		ieee80211_if_del_mgmt(local);

-- 
Greetings Michael.

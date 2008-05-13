Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7732 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbYEMB1Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 21:27:16 -0400
Subject: Re: [RFC PATCH] mac80211 : Association with 11n hidden ssid ap.
From: Zhu Yi <yi.zhu@intel.com>
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <12103509413156-git-send-email-abhijeet.kolekar@intel.com>
References: <12103509413156-git-send-email-abhijeet.kolekar@intel.com>
Content-Type: text/plain
Date: Tue, 13 May 2008 09:26:35 +0800
Message-Id: <1210641995.2506.200.camel@debian.sh.intel.com> (sfid-20080513_032720_037813_395D828B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-09 at 09:35 -0700, Abhijeet Kolekar wrote:
> This patch fixes the association problem with 11n hidden ssid ap.
> Patch fixes the problem of associating with hidden ssid when
> all three parameters ap,essid and channel are given to iwconfig.
> This patch removes the condition of checking three parameters
> and always checks for bss in bss list while associating.

Johannes, can you please take a look at this patch? The original code
looks like a shortcut to start authentication/association when all the
three parameters (BSSID/SSID/CHANNEL) are provided. But this is not
sufficient in the case of associate with an 11N hidden SSID AP. The 11n
and wmm information must be retrieved by an active probe request. Not
doing so will cause the 11N AP refuse to associate with the client.

Thanks,
-yi

> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> ---
>  net/mac80211/mlme.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index cb01995..872b105 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -3390,13 +3390,6 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
>  	struct ieee80211_sta_bss *bss, *selected = NULL;
>  	int top_rssi = 0, freq;
>  
> -	if (!(ifsta->flags & (IEEE80211_STA_AUTO_SSID_SEL |
> -	    IEEE80211_STA_AUTO_BSSID_SEL | IEEE80211_STA_AUTO_CHANNEL_SEL))) {
> -		ifsta->state = IEEE80211_AUTHENTICATE;
> -		ieee80211_sta_reset_auth(dev, ifsta);
> -		return 0;
> -	}
> -
>  	spin_lock_bh(&local->sta_bss_lock);
>  	freq = local->oper_channel->center_freq;
>  	list_for_each_entry(bss, &local->sta_bss_list, list) {

